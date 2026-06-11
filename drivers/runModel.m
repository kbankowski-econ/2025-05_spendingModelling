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

%% model list: {name, shock gap, shock horizon}
% A non-empty gap generates <name>.shockValues before the dynare run; the
% "low" variants reuse the shock file generated for the row above them.
% The submodules include directory is additive and harmless for models
% that do not include from it, so all models share one dynare call.
modelList = {
    'Model_HumanCapital_epsi_ig',               [],     []
    'Model_HumanCapital_epsi_cge',              [],     []
    'Model_HumanCapital_epsi_cgrd',             [],     []
    'Model_HumanCapital_epsi_igCgrd',           [],     []
    'Model_HumanCapital_epsi_igCge',            [],     []
    'Model_HumanCapital_epsi_cgeCgrd',          [],     []
    'Model_HumanCapital_epsieff30y',            0.35,   30
    'Model_HumanCapital_epsieffcge30y',         0.295,  30
    'Model_HumanCapital_epsi_igeff30y',         0.35,   30
    'Model_HumanCapital_epsi_igeff25y',         0.35,   25
    'Model_HumanCapital_epsi_igeff10y',         0.35,   10
    'Model_HumanCapital_epsi_igeff5y',          0.35,   5
    'Model_HumanCapital_epsi_cgeeff30y',        0.295,  30
    'Model_HumanCapital_epsi_cgeeff25y',        0.295,  25
    'Model_HumanCapital_epsi_cgeeff10y',        0.295,  10
    'Model_HumanCapital_epsi_cgeeff5y',         0.295,  5
    'Model_HumanCapital_epsi_igeff10y_al',      0.35,   10
    'Model_HumanCapital_epsi_cgeeff10y_al',     0.295,  10
    'EM_Model_HumanCapital_epsiig',             [],     []
    'EM_Model_HumanCapital_epsiiglow',          [],     []
    'EM_Model_HumanCapital_epsicge',            [],     []
    'EM_Model_HumanCapital_epsicgelow',         [],     []
    'EM_Model_HumanCapital_epsiigCge',          [],     []
    'EM_Model_HumanCapital_epsiigCgeVarShare',  [],     []
    'EM_Model_HumanCapital_epsieff30y',         0.415,  20
    'EM_Model_HumanCapital_epsieffcge30y',      0.320,  20
    'EM_Model_HumanCapital_epsiigeff30y',       0.415,  15
    'EM_Model_HumanCapital_epsiigeff30ylow',    [],     []
    'EM_Model_HumanCapital_epsiigeff25y',       0.415,  25
    'EM_Model_HumanCapital_epsiigeff25ylow',    [],     []
    'EM_Model_HumanCapital_epsiigeff10y',       0.415,  10
    'EM_Model_HumanCapital_epsiigeff10ylow',    [],     []
    'EM_Model_HumanCapital_epsiigeff5y',        0.415,  5
    'EM_Model_HumanCapital_epsiigLAGeff10y',    0.415,  10
    'EM_Model_HumanCapital_epsicgeeff30y',      0.320,  15
    'EM_Model_HumanCapital_epsicgeeff30ylow',   [],     []
    'EM_Model_HumanCapital_epsicgeeff25y',      0.320,  25
    'EM_Model_HumanCapital_epsicgeeff25ylow',   [],     []
    'EM_Model_HumanCapital_epsicgeeff10y',      0.320,  10
    'EM_Model_HumanCapital_epsicgeeff10ylow',   [],     []
    'EM_Model_HumanCapital_epsicgeeff5y',       0.320,  5
    'EM_Model_HumanCapital_epsicgeLAGeff10y',   0.320,  10
    'EM_Model_HumanCapital_epsiigeff25y_al',    0.415,  25
    'EM_Model_HumanCapital_epsicgeeff25y_al',   0.320,  25
    'Model_HumanCapital_epsi_cgrd_eff',         0.41,   10
    'Model_HumanCapital_epsi_cgrd_eff25y',      0.41,   25
    'Model_HumanCapital_epsicgrd_cge_adt',      0.03,   10
    'Model_HumanCapital_epsicgrd_cge_limt',     -0.03,  10
    };

%% run all models
for iModel = 1:size(modelList, 1)
    thisModel   = modelList{iModel, 1};
    thisGap     = modelList{iModel, 2};
    thisHorizon = modelList{iModel, 3};

    if ~isempty(thisGap)
        utils.subroutines.generateShockFile([thisModel '.shockValues'], thisGap, thisHorizon);
    end

    dynare([thisModel '.mod'], 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
end

%% Canonicalize all results in a clean child MATLAB process.
% Must be a separate process, not a call in this session: with Dynare
% loaded, save() writes nondeterministic function-handle context into the
% MAT subsystem and the bytes differ run-to-run even for identical data.
% See canonicalizeResults.m.
utils.subroutines.spawnCanonicalize();
