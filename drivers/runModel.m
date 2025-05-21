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