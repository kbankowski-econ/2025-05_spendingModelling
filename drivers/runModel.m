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

%% model list: {name, shocks}
% Each shocks entry is a cell of {var, kind, value, periods} specs that is
% written to <name>.shockValues (the sole content of the model's shocks
% block), so the rows are fully self-contained and order-independent.
%   kind 'const'  - constant value over the periods range (quarters)
%   kind 'ramp'   - linear increase from 0 to value over '1:N', then held
%                   constant through period 1000
%   kind 'custom' - explicit values vector, periods written verbatim
% An optional 5th element sets the sprintf format of the written values
% (default '%g'); 'roundtrip' writes the shortest decimal that parses back
% to the exact double, where the historical files carried full precision.
% The submodules include directory is additive and harmless for models
% that do not include from it, so all models share one dynare call.
modelList = {
    'Model_HumanCapital_epsi_ig',               {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_cge',              {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_cgrd',             {{'epsi_cgrd',    'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_igCgrd',           {{'epsi_ig',      'const', 0.005, '1:1000'}
                                                 {'epsi_cgrd',    'const', 0.005, '1:1000'}}
    'Model_HumanCapital_epsi_igCge',            {{'epsi_ig',      'const', 0.005, '1:1000'}
                                                 {'epsi_cge',     'const', 0.005, '1:1000'}}
    'Model_HumanCapital_epsi_cgeCgrd',          {{'epsi_cge',     'const', 0.005, '1:1000'}
                                                 {'epsi_cgrd',    'const', 0.005, '1:1000'}}
    'Model_HumanCapital_epsieff30y',            {{'epsi_eff',     'ramp',  0.35,  '1:120'}}
    'Model_HumanCapital_epsieffcge30y',         {{'epsi_effge',   'ramp',  0.295, '1:120'}}
    'Model_HumanCapital_epsi_igeff30y',         {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.35,  '1:120'}}
    'Model_HumanCapital_epsi_igeff25y',         {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.35,  '1:100'}}
    'Model_HumanCapital_epsi_igeff10y',         {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.35,  '1:40'}}
    'Model_HumanCapital_epsi_igeff5y',          {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.35,  '1:20'}}
    'Model_HumanCapital_epsi_cgeeff30y',        {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.295, '1:120'}}
    'Model_HumanCapital_epsi_cgeeff25y',        {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.295, '1:100'}}
    'Model_HumanCapital_epsi_cgeeff10y',        {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.295, '1:40'}}
    'Model_HumanCapital_epsi_cgeeff5y',         {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.295, '1:20'}}
    'Model_HumanCapital_epsi_igeff10y_al',      {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.35,  '1:40'}
                                                 {'epsiallo_ig',  'custom', [0.00625 0.0125 0.01875 0.025 0.03125 0.0375 0.043750000000000004 0.05 0.056249999999999994 0.0625 0.06875 0.075 0.08125 0.08750000000000001 0.09375 0.1 0.10625000000000001 0.11249999999999999 0.11875 0.125 0.13125 0.1375 0.14375000000000002 0.15 0.15625 0.1625 0.16875 0.17500000000000002 0.18125 0.1875 0.19375 0.2 0.20625000000000002 0.21250000000000002 0.21875 0.22499999999999998 0.23125 0.2375 0.24375000000000002 0.25 0.25], '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41:1000', 'roundtrip'}}
    'Model_HumanCapital_epsi_cgeeff10y_al',     {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.295, '1:40'}
                                                 {'epsiallo_cge', 'ramp',  0.1,   '1:40'}}
    'EM_Model_HumanCapital_epsiig',             {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsiiglow',          {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsicge',            {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsicgelow',         {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsiigCge',          {{'epsi_ig',      'const', 0.005, '1:1000'}
                                                 {'epsi_cge',     'const', 0.005, '1:1000'}}
    'EM_Model_HumanCapital_epsiigCgeVarShare',  {{'epsi_cge',     'custom', [0.005 0.0052 0.0054 0.0056 0.0058 0.006 0.0062 0.0064 0.0066 0.0068 0.007], '1:40 41 42 43 44 45 46 47 48 49 50:1000'}
                                                 {'epsi_ig',      'custom', [0.005 0.0048 0.0046 0.0044 0.0042 0.004 0.0038 0.0036 0.0034 0.0032 0.003], '1:40 41 42 43 44 45 46 47 48 49 50:1000'}}
    'EM_Model_HumanCapital_epsieff30y',         {{'epsi_eff',     'ramp',  0.415, '1:80'}}
    'EM_Model_HumanCapital_epsieffcge30y',      {{'epsi_effge',   'ramp',  0.320, '1:80'}}
    'EM_Model_HumanCapital_epsiigeff30y',       {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:60'}}
    'EM_Model_HumanCapital_epsiigeff30ylow',    {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:60'}}
    'EM_Model_HumanCapital_epsiigeff25y',       {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:100'}}
    'EM_Model_HumanCapital_epsiigeff25ylow',    {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:100'}}
    'EM_Model_HumanCapital_epsiigeff10y',       {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:40'}}
    'EM_Model_HumanCapital_epsiigeff10ylow',    {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:40'}}
    'EM_Model_HumanCapital_epsiigeff5y',        {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:20'}}
    'EM_Model_HumanCapital_epsiigLAGeff10y',    {{'epsi_ig',      'const', 0.01,  '40:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:40'}}
    'EM_Model_HumanCapital_epsicgeeff30y',      {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:60'}}
    'EM_Model_HumanCapital_epsicgeeff30ylow',   {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:60'}}
    'EM_Model_HumanCapital_epsicgeeff25y',      {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:100'}}
    'EM_Model_HumanCapital_epsicgeeff25ylow',   {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:100'}}
    'EM_Model_HumanCapital_epsicgeeff10y',      {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:40'}}
    'EM_Model_HumanCapital_epsicgeeff10ylow',   {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:40'}}
    'EM_Model_HumanCapital_epsicgeeff5y',       {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:20'}}
    'EM_Model_HumanCapital_epsicgeLAGeff10y',   {{'epsi_cge',     'const', 0.01,  '40:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:40'}}
    'EM_Model_HumanCapital_epsiigeff25y_al',    {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                 {'epsi_eff',     'ramp',  0.415, '1:100'}
                                                 {'epsiallo_ig',  'custom', [0.00625 0.0125 0.01875 0.025 0.03125 0.0375 0.043750000000000004 0.05 0.056249999999999994 0.0625 0.06875 0.075 0.08125 0.08750000000000001 0.09375 0.1 0.10625000000000001 0.11249999999999999 0.11875 0.125 0.13125 0.1375 0.14375000000000002 0.15 0.15625 0.1625 0.16875 0.17500000000000002 0.18125 0.1875 0.19375 0.2 0.20625000000000002 0.21250000000000002 0.21875 0.22499999999999998 0.23125 0.2375 0.24375000000000002 0.25 0.25], '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41:1000', 'roundtrip'}}
    'EM_Model_HumanCapital_epsicgeeff25y_al',   {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                 {'epsi_effge',   'ramp',  0.320, '1:100'}
                                                 {'epsiallo_cge', 'ramp',  0.1,   '1:40'}}
    'Model_HumanCapital_epsi_cgrd_eff',         {{'epsi_cgrd',    'const', 0.01,  '1:1000'}
                                                 {'epsi_effcgrd', 'ramp',  0.41,  '1:40'}}
    'Model_HumanCapital_epsi_cgrd_eff25y',      {{'epsi_cgrd',    'const', 0.01,  '1:1000'}
                                                 {'epsi_effcgrd', 'ramp',  0.41,  '1:100'}}
    'Model_HumanCapital_epsicgrd_cge_adt',      {{'epsi_cgrd',    'const', 0.005, '1:1000'}
                                                 {'epsi_cge',     'const', 0.005, '1:1000'}
                                                 {'epsirhoadopt', 'ramp',  0.03,  '1:40'}}
    'Model_HumanCapital_epsicgrd_cge_limt',     {{'epsi_cgrd',    'const', 0.005, '1:1000'}
                                                 {'epsi_cge',     'const', 0.005, '1:1000'}
                                                 {'epsirhoadopt', 'ramp',  -0.03, '1:40'}}
    };

%% run all models
for iModel = 1:size(modelList, 1)
    thisModel  = modelList{iModel, 1};
    thisShocks = modelList{iModel, 2};

    utils.subroutines.generateShocksFile([thisModel '.shockValues'], thisShocks);

    dynare([thisModel '.mod'], 'savemacro', sprintf('-I%s/%s/submodules', project_path, 'models'), 'json=compute');
end

%% Canonicalize all results in a clean child MATLAB process.
% Must be a separate process, not a call in this session: with Dynare
% loaded, save() writes nondeterministic function-handle context into the
% MAT subsystem and the bytes differ run-to-run even for identical data.
% See canonicalizeResults.m.
utils.subroutines.spawnCanonicalize();
