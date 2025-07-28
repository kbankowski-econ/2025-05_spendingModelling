% PREAMBLE
% cleaning evenrything
close all;
clear all;
clc;

% recalling the paths
utils.call.paths;

% Cding to a relevant directory
cd(fullfile(project_path, 'models'));

%% 
dynare('Model_HumanCapital_epsi_ig.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_cge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_cgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_igCgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_igCge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_cgeCgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsieff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsieffcge30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_igeff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
dynare('Model_HumanCapital_epsi_igeff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
dynare('Model_HumanCapital_epsi_igeff10y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
dynare('Model_HumanCapital_epsi_igeff5y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('Model_HumanCapital_epsi_cgeeff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
dynare('Model_HumanCapital_epsi_cgeeff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
dynare('Model_HumanCapital_epsi_cgeeff10y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
dynare('Model_HumanCapital_epsi_cgeeff5y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

%% 
dynare('EM_Model_HumanCapital_epsiig.mod', 'savemacro', 'json=compute');

%% 
dynare('EM_Model_HumanCapital_epsicge.mod', 'savemacro', 'json=compute');
%% 
dynare('EM_Model_HumanCapital_epsiigCge.mod', 'savemacro', 'json=compute');
%% 
dynare('EM_Model_HumanCapital_epsieff30y.mod', 'savemacro', 'json=compute');

%% 
dynare('EM_Model_HumanCapital_epsieffcge30y.mod', 'savemacro', 'json=compute');

%% 
dynare('EM_Model_HumanCapital_epsiigeff30y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsiigeff25y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsiigeff10y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsiigeff5y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsiigLAGeff10y.mod', 'savemacro', 'json=compute');

%% 
dynare('EM_Model_HumanCapital_epsicgeeff30y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsicgeeff25y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsicgeeff10y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsicgeeff5y.mod', 'savemacro', 'json=compute');
dynare('EM_Model_HumanCapital_epsicgeLAGeff10y.mod', 'savemacro', 'json=compute');
