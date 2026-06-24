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
%   INF:     AE 0.359   EMDE (0.371 + 0.441) / 2 = 0.406
%   HLT:     AE 0.295   EMDE (0.311 + 0.307) / 2 = 0.309
%   EDU:     AE 0.318   EMDE (0.347 + 0.350) / 2 = 0.348
%   HLT/EDU: AE 0.306   EMDE 0.329   (human capital = average of HLT and EDU)
%   RND:     AE 0.41    EMDE -       (unchanged; no 2023 estimate)
%   JAM:     INF 0.1681 (2023, total public investment);  HC = avg(HLT 0.3617, EDU 0.3596) = 0.357

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
% Government consumption is an explicit instrument (Gc = Gcss + ydss*epsi_gc),
% so every experiment carries its own epsi_gc row. For a budget-neutral reform
% set it to minus the sum of the spending shocks (epsi_igi + epsi_ige +
% epsi_grd); change it freely to run a non-budget-neutral configuration.
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
    'Model_HumanCapital_exp_gc',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_exp_igi',               'AE', 'AE',     {{'epsi_igi',      'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_exp_ige',               'AE', 'AE',     {{'epsi_ige',      'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_exp_grd',               'AE', 'AE',     {{'epsi_grd',      'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_exp_gc',             'EM', 'EMnorm', {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_exp_igi',            'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}}
    'EM_Model_HumanCapital_exp_ige',            'EM', 'EMnorm', {{'epsi_ige',      'const', 0.01,  '1:1000'}}
    'Model_HumanCapital_epsi_ig',               'AE', 'AE',     {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cge',              'AE', 'AE',     {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgrd',             'AE', 'AE',     {{'epsi_grd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgeCgrd',          'AE', 'AE',     {{'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_igeff25y',         'AE', 'AE',     {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.359,  '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgeeff25y',        'AE', 'AE',     {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiig',             'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiiglow',          'EM', 'EMlow',  {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicge',            'EM', 'EMnorm', {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicgelow',         'EM', 'EMlow',  {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff30y',       'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.406, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff30ylow',    'EM', 'EMlow',  {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff25y',       'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.406, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff25ylow',    'EM', 'EMlow',  {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.399, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicgeeff30y',      'EM', 'EMnorm', {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicgeeff30ylow',   'EM', 'EMlow',  {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicgeeff25y',      'EM', 'EMnorm', {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicgeeff25ylow',   'EM', 'EMlow',  {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.329, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgrd_eff25y',      'AE', 'AE',     {{'epsi_grd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_effcgrd', 'ramp',  0.41,  '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsicgrd_cge_adt',      'AE', 'AE',     {{'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsirhoadopt', 'ramp',  0.03,  '1:40'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsicgrd_cge_limt',     'AE', 'AE',     {{'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsirhoadopt', 'ramp',  -0.03, '1:40'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsiig',            'JAM', 'JAM',    {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsicge',           'JAM', 'JAM',    {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsiigeff30y',      'JAM', 'JAM',    {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.1681, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsicgeeff30y',     'JAM', 'JAM',    {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.357, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % --- Step-by-step simplified variants (AE params, gov-consumption shock).
    % Names contain SimpleN -> built from modelTemplateSimple.mod with
    % -DSIMPLIFY_LEVEL=N, which pins progressively more channels to steady state:
    %   1 = no R&D/technology, 2 = + no human capital, 3 = + no public infra (NK).
    'Model_Simple1_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    'Model_Simple2_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    'Model_Simple3_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    'Model_Simple4_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    % From-scratch canonical NK benchmark (own .mod; param/eff columns ignored).
    'Model_NK_exp_gc',                          'AE', 'AE',     {{'epsi_gc',       'const', 0.01,  '1:1000'}}
    };

%% optional subset: set the MODEL_FILTER environment variable to a substring
% and only matching model names are run (e.g. MODEL_FILTER=JAM re-runs just the
% Jamaica models after a Jamaica-specific recalibration). Read from the process
% environment so it survives the clear all in the preamble.
modelFilter = getenv('MODEL_FILTER');
if ~isempty(modelFilter)
    keepRows = contains(modelList(:, 1), modelFilter);
    fprintf('MODEL_FILTER="%s": running %d of %d models.\n', ...
            modelFilter, nnz(keepRows), numel(keepRows));
    modelList = modelList(keepRows, :);
end

%% run all models
for iModel = 1:size(modelList, 1)
    thisModel  = modelList{iModel, 1};
    thisParams = modelList{iModel, 2};
    thisEff    = modelList{iModel, 3};
    thisShocks = modelList{iModel, 4};

    utils.subroutines.generateShocksFile([thisModel '.shockValues'], thisShocks);

    if contains(thisModel, 'Model_NK')
        % Self-contained canonical NK benchmark: its own declarations, parameters,
        % equations and steady_state_model block. Reuses only the shock file; no
        % shared template, parameter/efficiency macros, or external steady state.
        copyfile('modelTemplateNK.mod', [thisModel '.mod']);
        dynare([thisModel '.mod'], 'savemacro', 'json=compute', ...
            sprintf('-DshockFile="%s.shockValues"', thisModel));
    else
        % Simplified variants (named ...SimpleN...) build from modelTemplateSimple.mod
        % with -DSIMPLIFY_LEVEL=N (channels pinned to steady state); everything else
        % (steady state, declarations, parameters) is shared with the full model.
        simpTok = regexp(thisModel, 'Simple(\d)', 'tokens', 'once');
        if isempty(simpTok)
            copyfile('modelTemplate.mod', [thisModel '.mod']);
            extraDefs = {};
        else
            copyfile('modelTemplateSimple.mod', [thisModel '.mod']);
            % nostrict: pinning channels leaves some declared shocks unused (e.g.
            % epsirhoadopt once R&D is off); they are zero in these experiments anyway.
            extraDefs = {sprintf('-DSIMPLIFY_LEVEL=%s', simpTok{1}), 'nostrict'};
        end
        copyfile('modelTemplate_steadystate.m', [thisModel '_steadystate.m']);

        dynare([thisModel '.mod'], 'savemacro', 'json=compute', ...
            sprintf('-DparamFile="%s_parameters.macro"', thisParams), ...
            sprintf('-DeffFile="%s_efficiency.macro"', thisEff), ...
            sprintf('-DshockFile="%s.shockValues"', thisModel), ...
            extraDefs{:});
    end
end

%% Canonicalize all results in a clean child MATLAB process.
% Must be a separate process, not a call in this session: with Dynare
% loaded, save() writes nondeterministic function-handle context into the
% MAT subsystem and the bytes differ run-to-run even for identical data.
% See canonicalizeResults.m.
utils.subroutines.spawnCanonicalize();
