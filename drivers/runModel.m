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

%% gaps for the calibration (2023 medians from the efficiency estimates; EMDE =
%% average of the emerging-market and low-income medians)
%   INF:     AE 0.351   EMDE (0.372 + 0.426) / 2 = 0.399
%   HLT:     AE 0.295   EMDE (0.311 + 0.307) / 2 = 0.309
%   EDU:     AE 0.318   EMDE (0.347 + 0.350) / 2 = 0.348
%   HLT/EDU: AE 0.306   EMDE 0.329   (human capital = average of HLT and EDU)
%   RND:     AE 0.41    EMDE -       (unchanged; no 2023 estimate)
%   JAM:     INF 0.1359 (2023);  HC = avg(HLT 0.3617, EDU 0.3516) = 0.357

%% model list: {name, params, efficiency, shocks}
% The params entry names a parameter set ('AE' or 'EM') and the efficiency
% entry an efficiency-gap set ('AE', 'EMnorm', 'EMlow' or 'JAM'). The model is
% preprocessed with -DparamFile="<params>_parameters.macro" and
% -DeffFile="<efficiency>_efficiency.macro", which the shared template
% includes after parameters_common.macro, so each macro file holds only
% its specific values.
% Each shocks entry is a cell of {var, kind, value, periods} specs that is
% written to <name>.shockValues (the sole content of the model's shocks
% block, selected via -DshockFile), so the rows are fully self-contained
% and order-independent.
% The per-model <name>.mod and <name>_steadystate.m files are copies of
% models/modelTemplate.mod and models/modelTemplate_steadystate.m made by
% the loop below; the copies are tracked but always regenerate
% byte-identical, so the templates are the source of truth.
%   kind 'const'  - constant value over the periods range (quarters)
%   kind 'ramp'   - linear increase from 0 to value over '1:N', then held
%                   constant through period 1000
%   kind 'custom' - explicit values vector, periods written verbatim
% An optional 5th element sets the sprintf format of the written values
% (default '%g'); 'roundtrip' writes the shortest decimal that parses back
% to the exact double, where the historical files carried full precision.
% The post-simulation commands (solver plus display-only multiplier
% reporting) are identical for all models and live in the shared
% models/postSimul.mod.

modelList = {
    'Model_HumanCapital_epsi_ig',               'AE', 'AE',     {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_cge',              'AE', 'AE',     {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_cgrd',             'AE', 'AE',     {{'epsi_cgrd',    'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_igCgrd',           'AE', 'AE',     {{'epsi_ig',      'const', 0.005, '1:1000'}
                                                                 {'epsi_cgrd',    'const', 0.005, '1:1000'}}
    'Model_HumanCapital_epsi_igCge',            'AE', 'AE',     {{'epsi_ig',      'const', 0.005, '1:1000'}
                                                                 {'epsi_cge',     'const', 0.005, '1:1000'}}
    'Model_HumanCapital_epsi_cgeCgrd',          'AE', 'AE',     {{'epsi_cge',     'const', 0.005, '1:1000'}
                                                                 {'epsi_cgrd',    'const', 0.005, '1:1000'}}
    'Model_HumanCapital_epsieff30y',            'AE', 'AE',     {{'epsi_eff',     'ramp',  0.351,  '1:120'}}
    'Model_HumanCapital_epsieffcge30y',         'AE', 'AE',     {{'epsi_effge',   'ramp',  0.306, '1:120'}}
    'Model_HumanCapital_epsi_igeff30y',         'AE', 'AE',     {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.351,  '1:120'}}
    'Model_HumanCapital_epsi_igeff25y',         'AE', 'AE',     {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.351,  '1:100'}}
    'Model_HumanCapital_epsi_igeff10y',         'AE', 'AE',     {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.351,  '1:40'}}
    'Model_HumanCapital_epsi_igeff5y',          'AE', 'AE',     {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.351,  '1:20'}}
    'Model_HumanCapital_epsi_cgeeff30y',        'AE', 'AE',     {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:120'}}
    'Model_HumanCapital_epsi_cgeeff25y',        'AE', 'AE',     {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:100'}}
    'Model_HumanCapital_epsi_cgeeff10y',        'AE', 'AE',     {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:40'}}
    'Model_HumanCapital_epsi_cgeeff5y',         'AE', 'AE',     {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:20'}}
    'Model_HumanCapital_epsi_igeff10y_al',      'AE', 'AE',     {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.351,  '1:40'}
                                                                 {'epsiallo_ig',  'custom', [0.00625 0.0125 0.01875 0.025 0.03125 0.0375 0.043750000000000004 0.05 0.056249999999999994 0.0625 0.06875 0.075 0.08125 0.08750000000000001 0.09375 0.1 0.10625000000000001 0.11249999999999999 0.11875 0.125 0.13125 0.1375 0.14375000000000002 0.15 0.15625 0.1625 0.16875 0.17500000000000002 0.18125 0.1875 0.19375 0.2 0.20625000000000002 0.21250000000000002 0.21875 0.22499999999999998 0.23125 0.2375 0.24375000000000002 0.25 0.25], '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41:1000', 'roundtrip'}}
    'Model_HumanCapital_epsi_cgeeff10y_al',     'AE', 'AE',     {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:40'}
                                                                 {'epsiallo_cge', 'ramp',  0.1,   '1:40'}}
    'EM_Model_HumanCapital_epsiig',             'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsiiglow',          'EM', 'EMlow',  {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsicge',            'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsicgelow',         'EM', 'EMlow',  {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_epsiigCge',          'EM', 'EMnorm', {{'epsi_ig',      'const', 0.005, '1:1000'}
                                                                 {'epsi_cge',     'const', 0.005, '1:1000'}}
    'EM_Model_HumanCapital_epsiigCgeVarShare',  'EM', 'EMnorm', {{'epsi_cge',     'custom', [0.005 0.0052 0.0054 0.0056 0.0058 0.006 0.0062 0.0064 0.0066 0.0068 0.007], '1:40 41 42 43 44 45 46 47 48 49 50:1000'}
                                                                 {'epsi_ig',      'custom', [0.005 0.0048 0.0046 0.0044 0.0042 0.004 0.0038 0.0036 0.0034 0.0032 0.003], '1:40 41 42 43 44 45 46 47 48 49 50:1000'}}
    'EM_Model_HumanCapital_epsieff30y',         'EM', 'EMnorm', {{'epsi_eff',     'ramp',  0.399, '1:80'}}
    'EM_Model_HumanCapital_epsieffcge30y',      'EM', 'EMnorm', {{'epsi_effge',   'ramp',  0.329, '1:80'}}
    'EM_Model_HumanCapital_epsiigeff30y',       'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:60'}}
    'EM_Model_HumanCapital_epsiigeff30ylow',    'EM', 'EMlow',  {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:60'}}
    'EM_Model_HumanCapital_epsiigeff25y',       'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:100'}}
    'EM_Model_HumanCapital_epsiigeff25ylow',    'EM', 'EMlow',  {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:100'}}
    'EM_Model_HumanCapital_epsiigeff10y',       'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:40'}}
    'EM_Model_HumanCapital_epsiigeff10ylow',    'EM', 'EMlow',  {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:40'}}
    'EM_Model_HumanCapital_epsiigeff5y',        'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:20'}}
    'EM_Model_HumanCapital_epsiigLAGeff10y',    'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '40:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:40'}}
    'EM_Model_HumanCapital_epsicgeeff30y',      'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:60'}}
    'EM_Model_HumanCapital_epsicgeeff30ylow',   'EM', 'EMlow',  {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:60'}}
    'EM_Model_HumanCapital_epsicgeeff25y',      'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:100'}}
    'EM_Model_HumanCapital_epsicgeeff25ylow',   'EM', 'EMlow',  {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:100'}}
    'EM_Model_HumanCapital_epsicgeeff10y',      'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:40'}}
    'EM_Model_HumanCapital_epsicgeeff10ylow',   'EM', 'EMlow',  {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:40'}}
    'EM_Model_HumanCapital_epsicgeeff5y',       'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:20'}}
    'EM_Model_HumanCapital_epsicgeLAGeff10y',   'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '40:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:40'}}
    'EM_Model_HumanCapital_epsiigeff25y_al',    'EM', 'EMnorm', {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:100'}
                                                                 {'epsiallo_ig',  'custom', [0.00625 0.0125 0.01875 0.025 0.03125 0.0375 0.043750000000000004 0.05 0.056249999999999994 0.0625 0.06875 0.075 0.08125 0.08750000000000001 0.09375 0.1 0.10625000000000001 0.11249999999999999 0.11875 0.125 0.13125 0.1375 0.14375000000000002 0.15 0.15625 0.1625 0.16875 0.17500000000000002 0.18125 0.1875 0.19375 0.2 0.20625000000000002 0.21250000000000002 0.21875 0.22499999999999998 0.23125 0.2375 0.24375000000000002 0.25 0.25], '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41:1000', 'roundtrip'}}
    'EM_Model_HumanCapital_epsicgeeff25y_al',   'EM', 'EMnorm', {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:100'}
                                                                 {'epsiallo_cge', 'ramp',  0.1,   '1:40'}}
    'Model_HumanCapital_epsi_cgrd_eff',         'AE', 'AE',     {{'epsi_cgrd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_effcgrd', 'ramp',  0.41,  '1:40'}}
    'Model_HumanCapital_epsi_cgrd_eff25y',      'AE', 'AE',     {{'epsi_cgrd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_effcgrd', 'ramp',  0.41,  '1:100'}}
    'Model_HumanCapital_epsicgrd_cge_adt',      'AE', 'AE',     {{'epsi_cgrd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_cge',     'const', 0.005, '1:1000'}
                                                                 {'epsirhoadopt', 'ramp',  0.03,  '1:40'}}
    'Model_HumanCapital_epsicgrd_cge_limt',     'AE', 'AE',     {{'epsi_cgrd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_cge',     'const', 0.005, '1:1000'}
                                                                 {'epsirhoadopt', 'ramp',  -0.03, '1:40'}}
    'JAM_Model_HumanCapital_epsiig',            'EM', 'JAM',    {{'epsi_ig',      'const', 0.01,  '1:1000'}}
    'JAM_Model_HumanCapital_epsicge',           'EM', 'JAM',    {{'epsi_cge',     'const', 0.01,  '1:1000'}}
    'JAM_Model_HumanCapital_epsiigeff30y',      'EM', 'JAM',    {{'epsi_ig',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.1359, '1:60'}}
    'JAM_Model_HumanCapital_epsicgeeff30y',     'EM', 'JAM',    {{'epsi_cge',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.357, '1:60'}}
    };

%% run all models
for iModel = 1:size(modelList, 1)
    thisModel  = modelList{iModel, 1};
    thisParams = modelList{iModel, 2};
    thisEff    = modelList{iModel, 3};
    thisShocks = modelList{iModel, 4};

    utils.subroutines.generateShocksFile([thisModel '.shockValues'], thisShocks);
    copyfile('modelTemplate.mod', [thisModel '.mod']);
    copyfile('modelTemplate_steadystate.m', [thisModel '_steadystate.m']);

    dynare([thisModel '.mod'], 'savemacro', 'json=compute', ...
        sprintf('-DparamFile="%s_parameters.macro"', thisParams), ...
        sprintf('-DeffFile="%s_efficiency.macro"', thisEff), ...
        sprintf('-DshockFile="%s.shockValues"', thisModel));
end

%% Canonicalize all results in a clean child MATLAB process.
% Must be a separate process, not a call in this session: with Dynare
% loaded, save() writes nondeterministic function-handle context into the
% MAT subsystem and the bytes differ run-to-run even for identical data.
% See canonicalizeResults.m.
utils.subroutines.spawnCanonicalize();
