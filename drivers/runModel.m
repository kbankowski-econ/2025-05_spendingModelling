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
%   RND:     AE 0.399   EMDE -       (EMDE technology-creation channel inactive)
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
% Models named *_exp_* are the non-budget-neutral expansions. In their generated
% shock files, eTaux=0 over 1:1000 suspends the transfer response to debt until
% the spending path ends; eTaux=1 then restores the standard fiscal closure.
% The canonical NK benchmark is excluded because it has no government debt or
% transfer rule.
% The post-simulation commands (solver plus display-only multiplier
% reporting) are identical for all models and live in the shared
% models/postSimul.mod.

% Section 4.4 compares a permanent 0.25%-of-GDP spending increase with an
% efficiency improvement that generates the same increase in effective
% productive spending. For instrument x, the equivalent gap reduction is
%   delta_e_x = (1-e_x_ss) * delta_X / (X_ss/Y_ss).
comparisonSpendingShock = 0.0025;
comparisonEffGI = (1-0.359) * comparisonSpendingShock / 0.03;
comparisonEffGE = (1-0.306) * comparisonSpendingShock / 0.0145;
comparisonEffGRD = (1-0.399) * comparisonSpendingShock / 0.006;
comparisonEffGI_EMDE = (1-0.406) * comparisonSpendingShock / 0.05;
comparisonEffGE_EMDE = (1-0.329) * comparisonSpendingShock / 0.02;

modelList = {
    % =================== STANDARD EXPANSIONS (Sections 4.1-4.2) ===================
    % Debt-financed expansions, no offsetting cut. The AE AR(1) shocks have
    % persistence 0.9 and a 1%-of-GDP impact. They feed the persistent-temporary-
    % shock appendix transmission figure and the AE rows of its multiplier table.
    'Model_HumanCapital_exp_gc',                'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_HumanCapital_exp_igi',               'AE', 'AE',     {{'epsi_igi',      'ar1', [0.01 0.9],  '1:1000'}}
    'Model_HumanCapital_exp_ige',               'AE', 'AE',     {{'epsi_ige',      'ar1', [0.01 0.9],  '1:1000'}}
    'Model_HumanCapital_exp_grd',               'AE', 'AE',     {{'epsi_grd',      'ar1', [0.01 0.9],  '1:1000'}}
    % The matching EMDE AR(1) shocks feed the EMDE rows of the appendix table.
    % They do not enter the transmission figure, which reports AEs only.
    'EM_Model_HumanCapital_exp_gc',             'EM', 'EMnorm', {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'EM_Model_HumanCapital_exp_igi',            'EM', 'EMnorm', {{'epsi_igi',      'ar1', [0.01 0.9],  '1:1000'}}
    'EM_Model_HumanCapital_exp_ige',            'EM', 'EMnorm', {{'epsi_ige',      'ar1', [0.01 0.9],  '1:1000'}}
    % The seven permanent counterparts are the Section 4 baseline. The AE paths
    % feed the headline transmission figure, and all seven feed the headline
    % multiplier table. With permanent spending, the multiplier denominator keeps
    % growing with the horizon, unlike the AR(1) denominator, which saturates.
    'Model_HumanCapital_exp_gc_perm',           'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_HumanCapital_exp_igi_perm',          'AE', 'AE',     {{'epsi_igi',      'const', 0.01, '1:1000'}}
    'Model_HumanCapital_exp_ige_perm',          'AE', 'AE',     {{'epsi_ige',      'const', 0.01, '1:1000'}}
    'Model_HumanCapital_exp_grd_perm',          'AE', 'AE',     {{'epsi_grd',      'const', 0.01, '1:1000'}}
    'EM_Model_HumanCapital_exp_gc_perm',        'EM', 'EMnorm', {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'EM_Model_HumanCapital_exp_igi_perm',       'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01, '1:1000'}}
    'EM_Model_HumanCapital_exp_ige_perm',       'EM', 'EMnorm', {{'epsi_ige',      'const', 0.01, '1:1000'}}
    % Comparable permanent experiments for Section 4.4. The first three raise
    % AE spending by 0.25% of GDP. The remaining rows leave spending unchanged
    % and raise effective productive spending by exactly the same amount. The
    % EMDE calibration has no active R&D-creation channel, so its comparison is
    % limited to infrastructure and human capital.
    'Model_HumanCapital_exp_igi_perm025',        'AE', 'AE',     {{'epsi_igi',     'const', comparisonSpendingShock, '1:1000'}}
    'Model_HumanCapital_exp_ige_perm025',        'AE', 'AE',     {{'epsi_ige',     'const', comparisonSpendingShock, '1:1000'}}
    'Model_HumanCapital_exp_grd_perm025',        'AE', 'AE',     {{'epsi_grd',     'const', comparisonSpendingShock, '1:1000'}}
    'Model_HumanCapital_effgi_perm025',          'AE', 'AE',     {{'epsi_effgi',   'const', comparisonEffGI,         '1:1000', 'roundtrip'}}
    'Model_HumanCapital_effge_perm025',          'AE', 'AE',     {{'epsi_effge',   'const', comparisonEffGE,         '1:1000', 'roundtrip'}}
    'Model_HumanCapital_effgrd_perm025',         'AE', 'AE',     {{'epsi_effgrd',  'const', comparisonEffGRD,        '1:1000', 'roundtrip'}}
    'EM_Model_HumanCapital_effgi_perm025',       'EM', 'EMnorm', {{'epsi_effgi',   'const', comparisonEffGI_EMDE,    '1:1000', 'roundtrip'}}
    'EM_Model_HumanCapital_effge_perm025',       'EM', 'EMnorm', {{'epsi_effge',   'const', comparisonEffGE_EMDE,    '1:1000', 'roundtrip'}}
    % ====================== POLICY EXPERIMENTS (Section 5) ======================
    % Reallocation reforms increase growth-enhancing spending and cut public
    % consumption by the same amount. The FM-style efficiency comparisons add a
    % gradual efficiency improvement and report the gain relative to reallocation
    % alone. The permanent efficiency-only experiments above leave spending unchanged.
    %
    % --- AE reallocation + human-capital/R&D mix ---
    % epsi_ig / epsi_cge / epsi_cgrd: reallocation toward infrastructure / human
    % capital / R&D. Enter Figure 2 (fig:reallocation, panel a, Section 5.1).
    % epsi_cge and epsi_cgrd also enter the human-capital + R&D mix,
    % Figure 5 (fig:humanCapital, Section 5.3). epsi_cgeCgrd is the combined HC+R&D
    % experiment: Figure 5 and the baseline for the diffusion experiment, Figure 6
    % (fig:diffusion, Section 5.3).
    'Model_HumanCapital_epsi_ig',               'AE', 'AE',     {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cge',              'AE', 'AE',     {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgrd',             'AE', 'AE',     {{'epsi_grd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgeCgrd',          'AE', 'AE',     {{'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % --- Permanent efficiency-gap closures --- Each experiment sets one
    % efficiency gap to zero from quarter 1 onward while leaving spending
    % unchanged. The AE scenarios feed Section 4.4; the EMDE scenarios are
    % retained for comparison outside the current draft.
    'Model_HumanCapital_effgi_perm',            'AE', 'AE',     {{'epsi_effgi',  'const', 0.359, '1:1000'}}
    'Model_HumanCapital_effge_perm',            'AE', 'AE',     {{'epsi_effge',  'const', 0.306, '1:1000'}}
    'Model_HumanCapital_effgrd_perm',           'AE', 'AE',     {{'epsi_effgrd', 'const', 0.399, '1:1000'}}
    'EM_Model_HumanCapital_effgi_perm',         'EM', 'EMnorm', {{'epsi_effgi',  'const', 0.406, '1:1000'}}
    'EM_Model_HumanCapital_effge_perm',         'EM', 'EMnorm', {{'epsi_effge',  'const', 0.329, '1:1000'}}
    % --- AE gradual efficiency scenarios --- These combine reallocation with a
    % 25-year ramp that closes the relevant spending-efficiency gap. Their
    % incremental output gains enter Figure 5 (fig:policyEfficiency, Section 5.2).
    'Model_HumanCapital_epsi_igeff25y',         'AE', 'AE',     {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgi',   'ramp',  0.359,  '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgeeff25y',        'AE', 'AE',     {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % --- EMDE reallocation and legacy gradual efficiency scenarios --- The bare
    % epsiig / epsicge reallocations enter Figure 2 (fig:reallocation, panel b,
    % Section 5.1). The remaining rows provide the initial-gap and 15y/25y
    % efficiency-ramp comparisons in Figure 5 (Section 5.2). The EMDE R&D channel
    % is inactive.
    'EM_Model_HumanCapital_epsiig',             'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiiglow',          'EM', 'EMlow',  {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicge',            'EM', 'EMnorm', {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsicgelow',         'EM', 'EMlow',  {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff30y',       'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgi',   'ramp',  0.406, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff30ylow',    'EM', 'EMlow',  {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgi',   'ramp',  0.399, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff25y',       'EM', 'EMnorm', {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgi',   'ramp',  0.406, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'EM_Model_HumanCapital_epsiigeff25ylow',    'EM', 'EMlow',  {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgi',   'ramp',  0.399, '1:100'}
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
    % --- AE gradual R&D-efficiency scenario (Figure 5, Section 5.2) ---
    'Model_HumanCapital_epsi_cgrd_eff25y',      'AE', 'AE',     {{'epsi_grd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgrd',  'ramp',  0.399, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % --- AE technology-diffusion experiments --- The combined HC+R&D reform under a
    % faster (adt) and a slower/limited (limt) technology-adoption speed. Enter
    % Figure 6 (fig:diffusion, Section 5.3), against the epsi_cgeCgrd baseline above.
    'Model_HumanCapital_epsicgrd_cge_adt',      'AE', 'AE',     {{'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsi_q', 'ramp',  0.03,  '1:40'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsicgrd_cge_limt',     'AE', 'AE',     {{'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsi_q', 'ramp',  -0.03, '1:40'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % ===================== JAMAICA (separate FM-panel project) =====================
    % NOT used in this working paper. Kept for the separate Jamaica fiscal-multiplier
    % deck; calibrated to Jamaica (JAM params/efficiency). Excluded from every paper
    % figure and table here.
    'JAM_Model_HumanCapital_epsiig',            'JAM', 'JAM',    {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsicge',           'JAM', 'JAM',    {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsiigeff30y',      'JAM', 'JAM',    {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_effgi',   'ramp',  0.1681, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsicgeeff30y',     'JAM', 'JAM',    {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.357, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % =========== GOV-CONSUMPTION TRANSMISSION BENCHMARKS (APPENDICES D-E) ===========
    % The AR(1) rho=0.9 +1%-of-GDP government-consumption shock is the temporary
    % counterpart to the main permanent exercise. Both are run through a sequence
    % of model simplifications to isolate which features drive the response signs.
    % --- Step-by-step simplified variants (AE params, gov-consumption shock).
    % Names contain SimpleN -> built from modelTemplateSimple.mod with
    % -DSIMPLIFY_LEVEL=N, which progressively removes endogenous technology,
    % human capital, public infrastructure, private capital, price indexation,
    % trend growth, and finally the extended fiscal block. Simple7 is the
    % canonical NK endpoint derived from the shared full-model source.
    % These variants enter the persistent-temporary-shock appendix; the canonical-
    % NK end of the ladder is Model_NK_exp_gc below.
    'Model_Simple1_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple2_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple3_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple4_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple5_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple6_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple7_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    % From-scratch canonical NK benchmark (own .mod; param/eff columns ignored).
    % AR(1) rho=0.9 +1%-of-GDP government-consumption shock, matching the rest
    % of the temporary ladder.
    'Model_NK_exp_gc',                          'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    % Permanent counterparts of the simplification ladder. Together with the
    % full-model exp_gc_perm path, these feed the primary robustness appendix
    % figure (fig:simplifiedGc).
    'Model_Simple1_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_Simple2_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_Simple3_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_Simple4_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_Simple5_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_Simple6_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_Simple7_exp_gc_perm',                'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
    'Model_NK_exp_gc_perm',                     'AE', 'AE',     {{'epsi_gc',       'const', 0.01, '1:1000'}}
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

    if ~contains(thisModel, 'Model_NK')
        if contains(thisModel, '_exp_')
            thisShocks{end + 1} = {'eTaux', 'const', 1, '1001:2000'};
        else
            thisShocks{end + 1} = {'eTaux', 'const', 1, '1:2000'};
        end
    end

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
        % with -DSIMPLIFY_LEVEL=N. Conditional equation blocks remove each channel,
        % while a dedicated steady-state routine preserves the common allocation
        % through level 6 and supplies the canonical normalization at level 7.
        simpTok = regexp(thisModel, 'Simple(\d)', 'tokens', 'once');
        if isempty(simpTok)
            copyfile('modelTemplate.mod', [thisModel '.mod']);
            extraDefs = {};
        else
            copyfile('modelTemplateSimple.mod', [thisModel '.mod']);
            % nostrict: pinning channels leaves some declared shocks unused (e.g.
            % epsi_q once R&D is off); they are zero in these experiments anyway.
            extraDefs = {sprintf('-DSIMPLIFY_LEVEL=%s', simpTok{1}), 'nostrict'};
            if contains(thisModel, 'NoIndex')
                extraDefs{end + 1} = '-DNO_INDEXATION=1';
            end
        end
        if isempty(simpTok)
            copyfile('modelTemplate_steadystate.m', [thisModel '_steadystate.m']);
        else
            copyfile('modelTemplateSimple_steadystate.m', [thisModel '_steadystate.m']);
        end

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
