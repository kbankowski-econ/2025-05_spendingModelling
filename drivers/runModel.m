%// NOTE: next step is to introduce the missing elements of the
% import content that may be not covered in the loops (see also
% some TODO items; first to load the model and then later to
% solve for its SS)

utils.call.paths;
% Cding to a relevant directory
cd(fullfile(project_path, 'models'));

%% just a simple stochastic simulation of gov. investment shock
dynare('Model_FR_rate.mod', 'savemacro');