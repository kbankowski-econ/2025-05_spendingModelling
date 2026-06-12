function generateParamsFile(fileName, paramSpec)
    % Write a model's parameter include file to fileName.
    %
    % The generated file is meant to be the sole parameter content of a
    % model:   @#include "<model>.paramValues"
    %
    % Inputs:
    %   fileName  - name of the output file (string)
    %   paramSpec - cell array {baseName[, overrides]}
    %               baseName  - parameter set name, resolving to
    %                           <baseName>_parameters.macro
    %               overrides - optional cell, one row per parameter:
    %                           {paramName, exprString}
    %
    % Without overrides the file is a plain include of the base macro.
    % With overrides the base macro's content is copied into the file with
    % the overridden assignment lines replaced, so every parameter is
    % declared exactly once.

    baseName = paramSpec{1};
    baseFile = sprintf('%s_parameters.macro', baseName);

    if numel(paramSpec) < 2
        content = sprintf('@#include "%s"\n', baseFile);
    else
        content = fileread(baseFile);
        overrides = paramSpec{2};
        for r = 1:size(overrides, 1)
            pattern = ['^' overrides{r, 1} '\s*=[^;]*;'];
            replacement = sprintf('%s=%s;', overrides{r, 1}, overrides{r, 2});
            nMatches = numel(regexp(content, pattern, 'lineanchors'));
            assert(nMatches == 1, 'generateParamsFile:override', ...
                   'Parameter "%s" matched %d assignment(s) in %s.', ...
                   overrides{r, 1}, nMatches, baseFile);
            content = regexprep(content, pattern, replacement, 'lineanchors');
        end
    end

    fid = fopen(fileName, 'w');
    fwrite(fid, content);
    fclose(fid);

    fprintf('Params file "%s" generated successfully.\n', fileName);
end
