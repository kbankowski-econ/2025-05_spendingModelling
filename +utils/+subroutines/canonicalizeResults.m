function canonicalizeResults(searchRoot)
    % Strip the volatile timestamp from results MAT-file headers.
    %
    % Every MATLAB `save` writes a fresh "Created on: <timestamp>" into the
    % 116-byte text header of a v5 MAT-file, so byte-identical results still
    % look "changed" to git/LFS. This rewrites that text header with a fixed
    % canonical string so identical data yields byte-identical files. The
    % binary data and the version/endianness bytes (offsets 116-127) are
    % left untouched, so the files still load normally.
    %
    % Inputs:
    %   searchRoot - folder to scan recursively (string). Defaults to the
    %                project's `models` directory.

    if nargin < 1 || isempty(searchRoot)
        utils.call.paths;   % defines project_path
        searchRoot = fullfile(project_path, 'models');
    end

    % Fixed 116-byte text header (space-padded, no timestamp).
    canon = uint8(repmat(' ', 1, 116));
    text  = uint8('MATLAB 5.0 MAT-file, Platform: MACA64, Created on: (canonicalized)');
    n = min(numel(text), 116);
    canon(1:n) = text(1:n);

    files = dir(fullfile(searchRoot, '**', 'Output', '*_results.mat'));

    nChanged = 0;
    for k = 1:numel(files)
        fpath = fullfile(files(k).folder, files(k).name);
        fid = fopen(fpath, 'r+');   % read/write in place, do not truncate
        if fid < 0
            warning('canonicalizeResults:open', 'Could not open %s', fpath);
            continue;
        end
        existing = fread(fid, 116, '*uint8')';
        if ~isequal(existing, canon)
            fseek(fid, 0, 'bof');
            fwrite(fid, canon, 'uint8');
            nChanged = nChanged + 1;
        end
        fclose(fid);
    end

    fprintf('canonicalizeResults: normalized header on %d of %d results file(s).\n', ...
            nChanged, numel(files));
end
