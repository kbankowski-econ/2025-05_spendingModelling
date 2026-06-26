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
    % =================== STANDARD EXPANSIONS (Sections 4.1-4.2) ===================
    % Debt-financed expansions, no offsetting cut. AE standard expansions: AR(1)
    % shocks, persistence 0.9 (1%-of-GDP impact). Enter the paper as the transmission
    % figure (Figure 1, fig:standardShocks, Section 4.1, AE only) and the AE rows of
    % the cumulative multiplier table (Table 3, tab:multipliers, Section 4.2).
    'Model_HumanCapital_exp_gc',                'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_HumanCapital_exp_igi',               'AE', 'AE',     {{'epsi_igi',      'ar1', [0.01 0.9],  '1:1000'}}
    'Model_HumanCapital_exp_ige',               'AE', 'AE',     {{'epsi_ige',      'ar1', [0.01 0.9],  '1:1000'}}
    'Model_HumanCapital_exp_grd',               'AE', 'AE',     {{'epsi_grd',      'ar1', [0.01 0.9],  '1:1000'}}
    % EMDE standard expansions: AR(1) shocks, persistence 0.9 (matching the AE
    % expansions above). Enter the paper as the EMDE rows of the multiplier table
    % (Table 3, tab:multipliers, Section 4.2). Not in Figure 1, which is AE only.
    'EM_Model_HumanCapital_exp_gc',             'EM', 'EMnorm', {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'EM_Model_HumanCapital_exp_igi',            'EM', 'EMnorm', {{'epsi_igi',      'ar1', [0.01 0.9],  '1:1000'}}
    'EM_Model_HumanCapital_exp_ige',            'EM', 'EMnorm', {{'epsi_ige',      'ar1', [0.01 0.9],  '1:1000'}}
    % ====================== POLICY EXPERIMENTS (Section 5) ======================
    % Budget-neutral reforms: a growth-enhancing spending increase financed by an
    % equal cut in public consumption (epsi_gc -0.01). All permanent (const, 1:1000).
    %
    % --- AE reallocation + human-capital/R&D mix ---
    % epsi_ig / epsi_cge / epsi_cgrd: reallocation toward infrastructure / human
    % capital / R&D. Enter Figure 2 (fig:reallocation, panel a, Section 5.1) and are
    % the no-efficiency baselines (denominators) for Figure 3 (fig:efficiencyAE,
    % Section 5.2). epsi_cge and epsi_cgrd also enter the human-capital + R&D mix,
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
    % --- AE efficiency gains (reallocation + a 25-year ramp that closes the
    % spending-efficiency gap) --- Enter Figure 3 (fig:efficiencyAE, Section 5.2),
    % each shown against its no-efficiency baseline above. (The R&D counterpart,
    % epsi_cgrd_eff25y, sits further below with the diffusion block.)
    'Model_HumanCapital_epsi_igeff25y',         'AE', 'AE',     {{'epsi_igi',      'const', 0.01,  '1:1000'}
                                                                 {'epsi_eff',     'ramp',  0.359,  '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsi_cgeeff25y',        'AE', 'AE',     {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.306, '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % --- EMDE reallocation + efficiency gains --- The bare epsiig / epsicge
    % reallocations enter Figure 2 (fig:reallocation, panel b, Section 5.1) and are
    % the baselines for Figure 4. All the EMDE rows here (including the *low* central-
    % calibration variants and the 25y/30y efficiency ramps) enter Figure 4
    % (fig:efficiencyEM, Section 5.2). No EMDE R&D experiment (innovation channel off).
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
    % --- AE R&D efficiency gain --- The R&D counterpart of the AE efficiency block
    % above; enters Figure 3 (fig:efficiencyAE, Section 5.2) as the R&D bars.
    'Model_HumanCapital_epsi_cgrd_eff25y',      'AE', 'AE',     {{'epsi_grd',    'const', 0.01,  '1:1000'}
                                                                 {'epsi_effcgrd', 'ramp',  0.41,  '1:100'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % --- AE technology-diffusion experiments --- The combined HC+R&D reform under a
    % faster (adt) and a slower/limited (limt) technology-adoption speed. Enter
    % Figure 6 (fig:diffusion, Section 5.3), against the epsi_cgeCgrd baseline above.
    'Model_HumanCapital_epsicgrd_cge_adt',      'AE', 'AE',     {{'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsirhoadopt', 'ramp',  0.03,  '1:40'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'Model_HumanCapital_epsicgrd_cge_limt',     'AE', 'AE',     {{'epsi_grd',    'const', 0.005, '1:1000'}
                                                                 {'epsi_ige',     'const', 0.005, '1:1000'}
                                                                 {'epsirhoadopt', 'ramp',  -0.03, '1:40'}
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
                                                                 {'epsi_eff',     'ramp',  0.1681, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    'JAM_Model_HumanCapital_epsicgeeff30y',     'JAM', 'JAM',    {{'epsi_ige',     'const', 0.01,  '1:1000'}
                                                                 {'epsi_effge',   'ramp',  0.357, '1:60'}
                                                                 {'epsi_gc',      'const', -0.01, '1:1000'}}
    % ============= GOV-CONSUMPTION TRANSMISSION BENCHMARKS (Appendix C) =============
    % AR(1) rho=0.9 +1%-of-GDP gov-consumption shock (matching Figure 1) through a
    % sequence of model simplifications, isolating which features drive the sign.
    % --- Step-by-step simplified variants (AE params, gov-consumption shock).
    % Names contain SimpleN -> built from modelTemplateSimple.mod with
    % -DSIMPLIFY_LEVEL=N, which pins progressively more channels to steady state:
    %   1 = no R&D/technology, 2 = + no human capital, 3 = + no public infra (NK).
    % Enter Figure 8 (fig:simplifiedGc, Appendix C) as the full-model -> NK ladder;
    % the canonical-NK end of that ladder is Model_NK_exp_gc below (also AR(1) rho=0.9).
    'Model_Simple1_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple2_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple3_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    'Model_Simple4_exp_gc',                     'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
    % From-scratch canonical NK benchmark (own .mod; param/eff columns ignored).
    % AR(1) rho=0.9 +1%-of-GDP gov-consumption shock (matching the rest of the ladder);
    % the canonical-NK end of Figure 8 (fig:simplifiedGc).
    'Model_NK_exp_gc',                          'AE', 'AE',     {{'epsi_gc',       'ar1', [0.01 0.9],  '1:1000'}}
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
