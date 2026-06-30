%% §4.3 sensitivity sweep — multipliers vs. structural parameters (AE).
% One-at-a-time (OAT) sweep of the AE standard expansions over the parameters
% flagged in §4.3: alpha_G (alphaG, infra output elasticity), mu (alphaH, HC
% formation elasticity) and the three efficiency wedges e^GI/e^GE/e^GRD
% (eGI_ss/eGE_ss/eGRD_ss). For each (experiment, parameter, grid value) it
% re-solves the perfect-foresight model and recomputes the *present-value
% cumulative own-spending multiplier* at the same horizons as Table 3
% (makeMultipliers.py), so the swept numbers are comparable to the paper.
%
% Isolation: each model is built in a gitignored work/ dir (NOT models/), so the
% committed _results.mat are never touched. The shared macros and the external
% steady-state helper are pulled from models/ via the preprocessor include path
% (-I) and the MATLAB path (iniProject's genpath).
%
% Run headless from the repo root:
%   matlab -batch "cd('<repo>'); iniProject; run('docs/2026-06_wp-imf/investigations/sensitivity/sweep.m')"
% A quick smoke test (one experiment, one parameter, short horizon) first:
%   SWEEP_SMOKE=1 matlab -batch "...same..."
% (benign exit-time segfault after completion, as with runModel.m).

global M_ oo_ options_

here = fileparts(mfilename('fullpath'));
utils.call.paths;                       % assigns project_path into this workspace
repo = char(project_path);
modelsDir = fullfile(repo, 'models');
workDir   = fullfile(here, 'work');
resDir    = fullfile(here, 'results');
if ~exist(workDir, 'dir'); mkdir(workDir); end
if ~exist(resDir,  'dir'); mkdir(resDir);  end

smoke = ~isempty(getenv('SWEEP_SMOKE'));

%% Experiments (AE only): {model name, own-spending instrument, shock spec}.
% Same AR(1) rho=0.9, +1%-of-GDP, debt-financed specs as runModel.m's exp_*.
exps = {
    'Model_HumanCapital_exp_gc',  'Gc',  {{'epsi_gc',  'ar1', [0.01 0.9], '1:1000'}}
    'Model_HumanCapital_exp_igi', 'Igi', {{'epsi_igi', 'ar1', [0.01 0.9], '1:1000'}}
    'Model_HumanCapital_exp_ige', 'Ige', {{'epsi_ige', 'ar1', [0.01 0.9], '1:1000'}}
    'Model_HumanCapital_exp_grd', 'Grd', {{'epsi_grd', 'ar1', [0.01 0.9], '1:1000'}}
    };

%% Parameters to sweep: {name, grid (include a point near the AE baseline)}.
% The baseline (restore) value is read from M_.params at build time, so the
% derived alphaRD = 0.09*(1-rho_ZZRD) = 0.0189 needs no hardcoding. The
% efficiency-gap params (eGI_ss/eGE_ss/eGRD_ss) were dropped: the per-dollar
% multiplier is exactly invariant to them (the (1-e) wedge cancels), so they
% add nothing to the sweep (see README).
params = {
    'alphaG',    [0.02 0.054 0.08 0.12 0.17 0.20]    % infra output elasticity (alpha_G)
    'alphaH',    [0.05 0.10 0.15 0.20 0.25 0.30]     % HC formation elasticity (mu)
    'alphaRD',   [0.005 0.0189 0.04 0.07 0.10]       % R&D-on-TFP elasticity (alpha_RD, code value)
    'rhoSADOPT', [0.10 0.30 0.50 0.80 0.90 0.95]     % adoption elasticity (varsigma)
    };

horizonsYr = [1 5 10 20 25 250];          % years; quarter window is 4N
periods    = 2000;
if smoke
    exps       = exps(4, :);              % grd only (exercises the R&D channel)
    params     = params(3, :);           % alphaRD only
    params{1,2} = [0.005 0.0189 0.07];   % 3 points
    horizonsYr = [1 5 10];
    periods    = 1200;                    % must exceed the period-1000 shock path
end

nYears = ternary(smoke, 10, 50);     % annual yd IRF horizon

csvPath = fullfile(resDir, sprintf('sweep_AE%s.csv', ternary(smoke, '_smoke', '')));
fid = fopen(csvPath, 'w');
hdr = sprintf('mult_%dy,', horizonsYr); hdr = strrep(hdr(1:end-1), 'mult_250y', 'mult_long');
fprintf(fid, 'experiment,instrument,param,param_value,is_baseline,%s\n', hdr);

% Companion file: annual yd IRF (percent deviation from SS), wide — one row per
% draw, columns yd_y0..yd_y<nYears>.
irfPath = fullfile(resDir, sprintf('sweep_AE_irf%s.csv', ternary(smoke, '_smoke', '')));
fidIrf = fopen(irfPath, 'w');
irfHdr = sprintf('yd_y%d,', 0:nYears); irfHdr = irfHdr(1:end-1);
fprintf(fidIrf, 'experiment,instrument,param,param_value,is_baseline,%s\n', irfHdr);

for ie = 1:size(exps, 1)
    modelName = exps{ie, 1};
    instVar   = exps{ie, 2};
    shockSpec = exps{ie, 3};
    fprintf('\n=================== %s (instrument %s) ===================\n', modelName, instVar);

    % --- build the model in the isolated work dir ---
    cd(workDir);
    utils.subroutines.generateShocksFile([modelName '.shockValues'], shockSpec);
    copyfile(fullfile(modelsDir, 'modelTemplate.mod'),            [modelName '.mod']);
    copyfile(fullfile(modelsDir, 'modelTemplate_steadystate.m'), [modelName '_steadystate.m']);

    % Dynare's driver ends by save()ing into <model>/Output/; pre-create it so
    % the (otherwise harmless) save does not abort the run.
    if ~exist(fullfile(workDir, modelName, 'Output'), 'dir')
        mkdir(fullfile(workDir, modelName, 'Output'));
    end
    try
        dynare([modelName '.mod'], 'savemacro', 'json=compute', ...
            sprintf('-I%s', modelsDir), ...
            '-DparamFile="AE_parameters.macro"', ...
            '-DeffFile="AE_efficiency.macro"', ...
            sprintf('-DshockFile="%s.shockValues"', modelName));
    catch ME
        % The model is fully built and solved before the final save; tolerate a
        % save-only failure (oo_/M_ already populated) but surface anything else.
        if ~(isfield(oo_, 'endo_simul') && ~isempty(oo_.endo_simul))
            rethrow(ME);
        end
        fprintf('  (continuing past dynare save error: %s)\n', ME.message);
    end

    % indices / discount factor (constant across the sweep)
    endoNames = cellstr(M_.endo_names);
    parNames  = cellstr(M_.param_names);
    iYd   = find(strcmp(endoNames, 'yd'));
    iInst = find(strcmp(endoNames, instVar));
    beta  = M_.params(strcmp(parNames, 'betta'));
    baseParams = M_.params;                  % snapshot of the AE calibration
    options_.periods = periods;

    % --- baseline (all params at AE calibration) ---
    [mBase, ydBase] = solveMult(periods, iYd, iInst, beta, horizonsYr, nYears);
    writeRow(fid, modelName, instVar, 'baseline', NaN, 1, mBase);
    writeRow(fidIrf, modelName, instVar, 'baseline', NaN, 1, ydBase);
    fprintf('  baseline  %s\n', fmtMult(mBase, horizonsYr));

    % --- OAT sweep ---
    for ip = 1:size(params, 1)
        pName = params{ip, 1};
        pGrid = params{ip, 2};
        pBase = baseParams(strcmp(parNames, pName));   % AE calibration of this param
        for v = pGrid
            ok = true;
            try
                set_param_value(pName, v);
                [m, ydAnn] = solveMult(periods, iYd, iInst, beta, horizonsYr, nYears);
            catch ME
                ok = false; m = nan(1, numel(horizonsYr)); ydAnn = nan(1, nYears + 1);
                fprintf('  !! %s=%g failed: %s\n', pName, v, ME.message);
            end
            writeRow(fid, modelName, instVar, pName, v, 0, m);
            writeRow(fidIrf, modelName, instVar, pName, v, 0, ydAnn);
            if ok
                fprintf('  %-8s=%-7g %s\n', pName, v, fmtMult(m, horizonsYr));
            end
        end
        set_param_value(pName, pBase);   % restore before sweeping the next param
    end
end

fclose(fid);
fclose(fidIrf);
fprintf('\nWrote %s\n  and %s\n', csvPath, irfPath);

%% ---------- local functions ----------
function [m, ydAnn] = solveMult(periods, iYd, iInst, beta, horizonsYr, nYears)
    global oo_ options_
    options_.periods = periods;
    steady;                       % refresh SS at the current params
    perfect_foresight_setup;
    perfect_foresight_solver;
    if isfield(oo_, 'deterministic_simulation') && ...
            isfield(oo_.deterministic_simulation, 'status') && ...
            ~oo_.deterministic_simulation.status
        error('perfect_foresight_solver did not converge');
    end
    e   = oo_.endo_simul;
    yd  = e(iYd, :);
    fc  = e(iInst, :) - e(iInst, 1);     % deviation from initial SS
    m   = nan(1, numel(horizonsYr));
    for i = 1:numel(horizonsYr)
        ped = horizonsYr(i) * 4 + 1;
        if size(e, 2) < ped; continue; end
        disc = beta .^ (0:ped-2);
        m(i) = sum(disc .* (yd(2:ped) - yd(1))) / sum(disc .* fc(2:ped));
    end
    % Annual yd IRF as percent deviation from the pre-shock SS (yd(1)). Year 0 is
    % the SS (=0); year k is the mean of that year's 4 quarters, periods
    % (4k-2):(4k+1) (the shock is active from period 2). Matches the paper's
    % "percent deviation from steady state" yearly output-gain figures.
    ydss  = yd(1);
    ydAnn = nan(1, nYears + 1);
    ydAnn(1) = 0;
    for k = 1:nYears
        q = (4*k - 2):(4*k + 1);
        if max(q) <= size(e, 2)
            ydAnn(k + 1) = mean(yd(q) / ydss - 1) * 100;
        end
    end
end

function writeRow(fid, model, inst, param, val, isBase, m)
    cells = sprintf('%.6f,', m); cells = cells(1:end-1);
    if isnan(val); valStr = ''; else; valStr = sprintf('%g', val); end
    fprintf(fid, '%s,%s,%s,%s,%d,%s\n', model, inst, param, valStr, isBase, cells);
end

function s = fmtMult(m, hy)
    s = '';
    for i = 1:numel(hy)
        lbl = sprintf('%dy', hy(i)); if hy(i) == 250; lbl = 'long'; end
        s = [s sprintf('%s=%+.2f ', lbl, m(i))]; %#ok<AGROW>
    end
end

function out = ternary(cond, a, b)
    if cond; out = a; else; out = b; end
end
