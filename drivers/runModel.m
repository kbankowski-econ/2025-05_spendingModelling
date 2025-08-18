% PREAMBLE
% cleaning evenrything
close all;
clear all;
clc;

% recalling the paths
utils.call.paths;

% Cding to a relevant directory
cd(fullfile(project_path, 'models'));

%% gaps for the calibration
% +---------+------------------------------+----------------------------------------------------+
% |         |             AEs              |                       EMDEs                        |
% +---------+------------------------------+----------------------------------------------------+
% | INF     | 0.35                         | (0.37 + 0.46) / 2 = 0.415                          |
% | HLT/EDU | (0.28 + 0.31) / 2 = 0.295    | ((0.30 + 0.29) / 2 + (0.34 + 0.35) / 2) / 2 = 0.320 |
% +---------+------------------------------+----------------------------------------------------+

%% 
dynare('Model_HumanCapital_epsi_ig.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

dynare('Model_HumanCapital_epsi_cge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

dynare('Model_HumanCapital_epsi_cgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

dynare('Model_HumanCapital_epsi_igCgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

dynare('Model_HumanCapital_epsi_igCge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

dynare('Model_HumanCapital_epsi_cgeCgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsieff30y.shockValues', 0.35, 30);
dynare('Model_HumanCapital_epsieff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsieffcge30y.shockValues', 0.295, 30);
dynare('Model_HumanCapital_epsieffcge30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff30y.shockValues', 0.35, 30);
dynare('Model_HumanCapital_epsi_igeff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff25y.shockValues', 0.35, 25);
dynare('Model_HumanCapital_epsi_igeff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff10y.shockValues', 0.35, 10);
dynare('Model_HumanCapital_epsi_igeff10y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff5y.shockValues', 0.35, 5);
dynare('Model_HumanCapital_epsi_igeff5y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff30y.shockValues', 0.295, 30);
dynare('Model_HumanCapital_epsi_cgeeff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff25y.shockValues', 0.295, 25);
dynare('Model_HumanCapital_epsi_cgeeff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff10y.shockValues', 0.295, 10);
dynare('Model_HumanCapital_epsi_cgeeff10y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff5y.shockValues', 0.295, 5);
dynare('Model_HumanCapital_epsi_cgeeff5y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff10y_al.shockValues', 0.35, 10);
dynare('Model_HumanCapital_epsi_igeff10y_al.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff10y_al.shockValues', 0.295, 10);
dynare('Model_HumanCapital_epsi_cgeeff10y_al.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');

dynare('EM_Model_HumanCapital_epsiig.mod', 'savemacro', 'json=compute');

dynare('EM_Model_HumanCapital_epsicge.mod', 'savemacro', 'json=compute'); 

dynare('EM_Model_HumanCapital_epsiigCge.mod', 'savemacro', 'json=compute'); 

dynare('EM_Model_HumanCapital_epsiigCgeVarShare.mod', 'savemacro', 'json=compute'); 

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsieff30y.shockValues', 0.415, 30);
dynare('EM_Model_HumanCapital_epsieff30y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsieffcge30y.shockValues', 0.320, 30);
dynare('EM_Model_HumanCapital_epsieffcge30y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff30y.shockValues', 0.415, 30);
dynare('EM_Model_HumanCapital_epsiigeff30y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff25y.shockValues', 0.415, 25);
dynare('EM_Model_HumanCapital_epsiigeff25y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff10y.shockValues', 0.415, 10);
dynare('EM_Model_HumanCapital_epsiigeff10y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff5y.shockValues', 0.415, 5);
dynare('EM_Model_HumanCapital_epsiigeff5y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigLAGeff10y.shockValues', 0.415, 10);
dynare('EM_Model_HumanCapital_epsiigLAGeff10y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff30y.shockValues', 0.320, 30);
dynare('EM_Model_HumanCapital_epsicgeeff30y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff25y.shockValues', 0.320, 25);
dynare('EM_Model_HumanCapital_epsicgeeff25y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff10y.shockValues', 0.320, 10);
dynare('EM_Model_HumanCapital_epsicgeeff10y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff5y.shockValues', 0.320, 5);
dynare('EM_Model_HumanCapital_epsicgeeff5y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeLAGeff10y.shockValues', 0.320, 10);
dynare('EM_Model_HumanCapital_epsicgeLAGeff10y.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff25y_al.shockValues', 0.415, 25);
dynare('EM_Model_HumanCapital_epsiigeff25y_al.mod', 'savemacro', 'json=compute');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff25y_al.shockValues', 0.320, 25);
dynare('EM_Model_HumanCapital_epsicgeeff25y_al.mod', 'savemacro', 'json=compute');
