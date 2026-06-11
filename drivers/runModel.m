% PREAMBLE
% cleaning evenrything
close all;
clear all;
clc;

% recalling the paths
utils.call.paths;

% start the overall execution timer; the guard reports elapsed time on
% normal completion and on error/exit
runTimer = tic;
timerGuard = onCleanup(@() fprintf('\nrunModel total execution time: %s (%.0f s)\n', ...
        string(duration(0, 0, toc(runTimer))), toc(runTimer)));

% Cding to a relevant directory
cd(fullfile(project_path, 'models'));

%% gaps for the calibration
% +---------+------------------------------+----------------------------------------------------+
% |         |             AEs              |                       EMDEs                        |
% +---------+------------------------------+----------------------------------------------------+
% | INF     | 0.35                         | (0.37 + 0.46) / 2 = 0.415                          |
% | HLT/EDU | (0.28 + 0.31) / 2 = 0.295    | ((0.30 + 0.29) / 2 + (0.34 + 0.35) / 2) / 2 = 0.320 |
% | RND     | 0.41                         | -                                                  |
% +---------+------------------------------+----------------------------------------------------+

%% 
dynare('Model_HumanCapital_epsi_ig.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_ig');

dynare('Model_HumanCapital_epsi_cge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cge');

dynare('Model_HumanCapital_epsi_cgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgrd');

dynare('Model_HumanCapital_epsi_igCgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igCgrd');

dynare('Model_HumanCapital_epsi_igCge.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igCge');

dynare('Model_HumanCapital_epsi_cgeCgrd.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgeCgrd');

utils.subroutines.generateShockFile('Model_HumanCapital_epsieff30y.shockValues', 0.35, 30);
dynare('Model_HumanCapital_epsieff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsieff30y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsieffcge30y.shockValues', 0.295, 30);
dynare('Model_HumanCapital_epsieffcge30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsieffcge30y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff30y.shockValues', 0.35, 30);
dynare('Model_HumanCapital_epsi_igeff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igeff30y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff25y.shockValues', 0.35, 25);
dynare('Model_HumanCapital_epsi_igeff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igeff25y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff10y.shockValues', 0.35, 10);
dynare('Model_HumanCapital_epsi_igeff10y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igeff10y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff5y.shockValues', 0.35, 5);
dynare('Model_HumanCapital_epsi_igeff5y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igeff5y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff30y.shockValues', 0.295, 30);
dynare('Model_HumanCapital_epsi_cgeeff30y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgeeff30y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff25y.shockValues', 0.295, 25);
dynare('Model_HumanCapital_epsi_cgeeff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgeeff25y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff10y.shockValues', 0.295, 10);
dynare('Model_HumanCapital_epsi_cgeeff10y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgeeff10y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff5y.shockValues', 0.295, 5);
dynare('Model_HumanCapital_epsi_cgeeff5y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgeeff5y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_igeff10y_al.shockValues', 0.35, 10);
dynare('Model_HumanCapital_epsi_igeff10y_al.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_igeff10y_al');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgeeff10y_al.shockValues', 0.295, 10);
dynare('Model_HumanCapital_epsi_cgeeff10y_al.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgeeff10y_al');

dynare('EM_Model_HumanCapital_epsiig.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiig');
dynare('EM_Model_HumanCapital_epsiiglow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiiglow');

dynare('EM_Model_HumanCapital_epsicge.mod', 'savemacro', 'json=compute'); 
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicge');
dynare('EM_Model_HumanCapital_epsicgelow.mod', 'savemacro', 'json=compute'); 
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgelow');

dynare('EM_Model_HumanCapital_epsiigCge.mod', 'savemacro', 'json=compute'); 
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigCge');

dynare('EM_Model_HumanCapital_epsiigCgeVarShare.mod', 'savemacro', 'json=compute'); 
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigCgeVarShare');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsieff30y.shockValues', 0.415, 20);
dynare('EM_Model_HumanCapital_epsieff30y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsieff30y');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsieffcge30y.shockValues', 0.320, 20);
dynare('EM_Model_HumanCapital_epsieffcge30y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsieffcge30y');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff30y.shockValues', 0.415, 15);
dynare('EM_Model_HumanCapital_epsiigeff30y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff30y');
dynare('EM_Model_HumanCapital_epsiigeff30ylow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff30ylow');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff25y.shockValues', 0.415, 25);
dynare('EM_Model_HumanCapital_epsiigeff25y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff25y');
dynare('EM_Model_HumanCapital_epsiigeff25ylow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff25ylow');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff10y.shockValues', 0.415, 10);
dynare('EM_Model_HumanCapital_epsiigeff10y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff10y');
dynare('EM_Model_HumanCapital_epsiigeff10ylow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff10ylow');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff5y.shockValues', 0.415, 5);
dynare('EM_Model_HumanCapital_epsiigeff5y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff5y');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigLAGeff10y.shockValues', 0.415, 10);
dynare('EM_Model_HumanCapital_epsiigLAGeff10y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigLAGeff10y');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff30y.shockValues', 0.320, 15);
dynare('EM_Model_HumanCapital_epsicgeeff30y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff30y');
dynare('EM_Model_HumanCapital_epsicgeeff30ylow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff30ylow');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff25y.shockValues', 0.320, 25);
dynare('EM_Model_HumanCapital_epsicgeeff25y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff25y');
dynare('EM_Model_HumanCapital_epsicgeeff25ylow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff25ylow');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff10y.shockValues', 0.320, 10);
dynare('EM_Model_HumanCapital_epsicgeeff10y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff10y');
dynare('EM_Model_HumanCapital_epsicgeeff10ylow.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff10ylow');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff5y.shockValues', 0.320, 5);
dynare('EM_Model_HumanCapital_epsicgeeff5y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff5y');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeLAGeff10y.shockValues', 0.320, 10);
dynare('EM_Model_HumanCapital_epsicgeLAGeff10y.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeLAGeff10y');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsiigeff25y_al.shockValues', 0.415, 25);
dynare('EM_Model_HumanCapital_epsiigeff25y_al.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsiigeff25y_al');

utils.subroutines.generateShockFile('EM_Model_HumanCapital_epsicgeeff25y_al.shockValues', 0.320, 25);
dynare('EM_Model_HumanCapital_epsicgeeff25y_al.mod', 'savemacro', 'json=compute');
utils.subroutines.spawnCanonicalize('EM_Model_HumanCapital_epsicgeeff25y_al');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgrd_eff.shockValues', 0.41, 10);
dynare('Model_HumanCapital_epsi_cgrd_eff.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgrd_eff');

utils.subroutines.generateShockFile('Model_HumanCapital_epsi_cgrd_eff25y.shockValues', 0.41, 25);
dynare('Model_HumanCapital_epsi_cgrd_eff25y.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsi_cgrd_eff25y');

utils.subroutines.generateShockFile('Model_HumanCapital_epsicgrd_cge_adt.shockValues', 0.03, 10);
dynare('Model_HumanCapital_epsicgrd_cge_adt.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsicgrd_cge_adt');

utils.subroutines.generateShockFile('Model_HumanCapital_epsicgrd_cge_limt.shockValues', -0.03, 10);
dynare('Model_HumanCapital_epsicgrd_cge_limt.mod', 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
utils.subroutines.spawnCanonicalize('Model_HumanCapital_epsicgrd_cge_limt');

% NOTE: each dynare call above is followed by utils.subroutines.spawnCanonicalize,
% which makes that model's results byte-reproducible in a clean child MATLAB
% process (~5 s each). See canonicalizeResults.m for why it must be a
% separate, Dynare-free process.
