function environment = setup(project_path)

utils.call.paths;

environment = struct();
environment.varDict = importVarDict(project_path);
environment.shockDict = importShockDict(project_path);

end%

function Table = importVarDict(project_path)

    fileName = sprintf('%s/+environment/csvFiles/varDict.csv', project_path); 
    
    opts = detectImportOptions(fileName, 'ReadRowNames', true,  'ReadVariableNames', true, 'Delimiter', ',');
    opts = setvartype( ...
        opts ...
        , {'description', 'diffTransf', 'diffDesc'}, 'string' ...
    );

    Table = readtable(fileName, opts);

end

function Table = importShockDict(project_path)

    fileName = sprintf('%s/+environment/csvFiles/shockDict.csv', project_path); 
    
    opts = detectImportOptions(fileName, 'ReadRowNames', true,  'ReadVariableNames', true, 'Delimiter', ',');
    opts = setvartype( ...
        opts ...
        , {'description'}, 'string' ...
    );

    Table = readtable(fileName, opts);

end