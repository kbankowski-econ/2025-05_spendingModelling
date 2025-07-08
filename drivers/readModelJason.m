% Read the JSON file
filename = fullfile(project_path, 'models/Model_HumanCapital_epsi_ig/model/json/modfile-original.json');  % or whatever you named the file
filetext = fileread(filename);
data = jsondecode(filetext);

% Access the data
model_equations = data.model;
ast_data = data.abstract_syntax_tree;
statements = data.statements;

model_struct = [model_equations{:}];

% Now you can easily access and view the data
% View all equations in a table format
equations_table = struct2table(model_struct);
disp(equations_table);