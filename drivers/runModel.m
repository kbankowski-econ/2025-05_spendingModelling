% PREAMBLE
% cleaning evenrything
close all;
clear all;
clc;

% recalling the paths
utils.call.paths;

% Cding to a relevant directory
cd(fullfile(project_path, 'models'));

%% gov. investment shock
dynare('Model_HumanCapital_epsi_ig.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'));

%% gov. cge shock
dynare('Model_HumanCapital_epsi_cge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'));

%% gov. cgerd shock
dynare('Model_HumanCapital_epsi_cgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'));

%% gov. cgerd shock
dynare('Model_HumanCapital_epsi_all.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'));

%% EM: gov. cgerd shock
dynare('EM_Model_HumanCapital_epsiig.mod', 'savemacro');

%% EM: gov. cgerd shock
dynare('EM_Model_HumanCapital_epsicge.mod', 'savemacro');

%% EM: gov. cgerd shock
dynare('EM_Model_HumanCapital_epsieff.mod', 'savemacro');

%% EM: gov. cgerd shock
dynare('EM_Model_HumanCapital_epsieffcge.mod', 'savemacro');

%% EM: gov. cgerd shock
dynare('EM_Model_HumanCapital_epsiall.mod', 'savemacro');
