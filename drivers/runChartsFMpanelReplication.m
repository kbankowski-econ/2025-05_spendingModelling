% Driver: generate the charts for docs/2026-04_FM-panel-replication by
% invoking the Python plot scripts in pyScripts/2026-04_spendingModelling.

utils.call.paths;

pyScriptDir = fullfile(project_path, 'pyScripts', '2026-04_spendingModelling');
pyScripts = { ...
    'plotHumanCapitalIRFs.py'; ...
};

% The Python scripts rely on fiscal_common.py + fiscal_config.json sitting
% next to them and resolve paths with __file__, so we run each from its
% own directory and restore the original cwd afterwards.
prevDir = pwd;
cleanupObj = onCleanup(@() cd(prevDir));
cd(pyScriptDir);

for k = 1:numel(pyScripts)
    script = pyScripts{k};
    fprintf('Running %s ...\n', script);
    status = system(sprintf('python3 %s', script));
    if status ~= 0
        error('Python script %s failed with exit code %d', script, status);
    end
end
