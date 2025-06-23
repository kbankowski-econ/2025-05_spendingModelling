% PREAMBLE
% cleaning evenrything
close all;
clear all;
clc;

% recalling the paths
utils.call.paths;

% Cding to a relevant directory
cd(fullfile(project_path, 'models'));

%% just a simple stochastic simulation of gov. investment shock
dynare('Model_FR_rate.mod', 'savemacro');

%% just a simple stochastic simulation of gov. investment shock
dynare('Model_HumanCapital_v0.mod', 'savemacro');

%% just a simple stochastic simulation of gov. investment shock
dynare('Model_HumanCapital_v1.mod', 'savemacro');

%% gov. investment shock
dynare('Model_HumanCapital_epsiig.mod', 'savemacro');

%% gov. cge shock
dynare('Model_HumanCapital_epsicg.mod', 'savemacro');

%% gov. cgerd shock
dynare('Model_HumanCapital_epsigrd.mod', 'savemacro');

%% gov. cgerd shock
dynare('Model_HumanCapital_epsiall.mod', 'savemacro');
