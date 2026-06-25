%% preamble
clear all; close all; clc; 
utils.call.paths;

envi = environment.setup();


%% ----------------
% Loading the databases
% ----------------

% Declaring model names
modelList = string(reshape(envi.shockDict.Properties.RowNames, 1, []));

% Append the step-by-step simplified Gc-shock variants (not in shockDict; added
% directly in runModel.m). They share all variables with the full model, so they
% flow through the same export machinery.
modelList = [modelList, "Model_Simple1_exp_gc", "Model_Simple2_exp_gc", "Model_Simple3_exp_gc", "Model_Simple4_exp_gc", "Model_NK_exp_gc", "Model_NK_exp_gc_d1", "Model_NK_exp_gc_d4", "Model_NK_exp_gc_d20"];

% Deviation transforms come straight from varDict.diffTransf: each entry is an
% expression in x (simulated level path) and y (steady-state path), e.g.
% "(x./y-1)*100" for a percent deviation, "(x-y)*400" for an annualized
% percentage-point deviation, "(x-y)*100" for a percentage point of GDP. Compile
% one @(x,y) handle per variable once, then reuse across all models.
varNames = string(envi.varDict.Properties.RowNames).';
transfFuncs = struct();
for aVar = varNames
    transfFuncs.(char(aVar)) = str2func("@(x,y) " + string(envi.varDict{aVar, "diffTransf"}));
end

% Initialize an empty structure to hold results
resultsProc = struct();

% Loop through each model and load data
for aModel = modelList
    % Load the model data
    resultsRaw = load(fullfile(project_path, 'models', aModel, 'Output', [char(aModel) '_results.mat']));
    dataRange = qq(0, 4): qq(0, 4) + size(resultsRaw.oo_.endo_simul', 1) - 1;

    % Store endogenous and steady state variables
    resultsProc.(aModel).endo = databank.fromArray( ...
        resultsRaw.oo_.endo_simul', ...
        resultsRaw.M_.endo_names, ...
        dataRange(1) ...
    );

    % Handle SS values
    resultsProc.(aModel).ss = databank.fromArray( ...
        repmat(resultsRaw.oo_.steady_state', numel(dataRange), 1), ...
        resultsRaw.M_.endo_names, ...
        dataRange(1) ...
    );

    % Handle parameters
    for aParam = string(reshape(resultsRaw.M_.param_names, 1, []))
        resultsProc.(aModel).param.(aParam) = resultsRaw.M_.params(strcmp(aParam, resultsRaw.M_.param_names));
    end

    e = resultsProc.(aModel).endo;
    s = resultsProc.(aModel).ss;

    % Calculate IRF transformations by evaluating each variable's varDict formula
    % against its level (x) and steady-state (y) path. Every plotted series
    % (including rreal, Trans_ys and dserv) is now a genuine model variable
    % computed in the model block, so nothing is constructed here.
    resultsProc.(aModel).irf = struct();
    for aVar = varNames
        f = char(aVar);
        if ~isfield(e, f); continue; end
        resultsProc.(aModel).irf.(f) = transfFuncs.(f)(e.(f), s.(f));
    end
end

%% reporting the numbers

tempDatabank = struct();

% Percent-deviation block consumed by every figure (the deviation formula now
% lives in varDict.diffTransf; this just selects which variables to export).
varList = ["yd", "C", "Ip", "Kp", "Kg", "Igi", "Gc", "Ige", "Grd", "G", "H", "Lab", "N", "E", "eGI", "eGE", "TFP", "ZZRD", "AAt", "mc", "W_real"]

for aVar = varList

for aModel = modelList

% Skip variables a model does not have (e.g. the canonical NK benchmark lacks
% Ip/Kp/Kg/...); its column is simply absent and the figure leaves it blank.
if isfield(resultsProc.(aModel).irf, char(aVar))
    tempDatabank.(aModel+"___"+aVar) = resultsProc.(aModel).irf.(aVar);
end

end

end

% Unit-converted columns for the transmission panel (fig:standardShocks): the
% nominal block is in annualized percentage points and the fiscal block in
% percentage points of steady-state GDP (the _yss variables are computed in the
% model block). Those units are set in varDict.diffTransf; here we only map each
% source variable to its output suffix.
%   source var (varDict)   output column suffix
derivedMap = [ ...
    "PI",        "PI_ann"   ; ...
    "Rmp",       "Rmp_ann"  ; ...
    "R",         "R_ann"    ; ...
    "rreal",     "rreal_ann"; ...
    "pdef_yss",  "pdef_yss" ; ...
    "Trans_yss", "Trans_yss"; ...
    "dserv_yss", "dserv_yss"; ...
    "by_yss",    "by_yss"   ];

for aModel = modelList
    for k = 1:size(derivedMap, 1)
        if isfield(resultsProc.(aModel).irf, char(derivedMap(k, 1)))
            tempDatabank.(aModel+"___"+derivedMap(k, 2)) = resultsProc.(aModel).irf.(derivedMap(k, 1));
        end
    end
end

% Shift the whole databank onto a real calendar: the simulation is built on
% a synthetic date axis starting at qq(0,4); we anchor period 25Q4 to 2050Q1
% so that calendar dates in the exported CSV match the shock horizon.
tempDatabank = databank.redate(tempDatabank, qq(25, 4), qq(2050, 1));

% Write the CSV from the post-redate databank, truncated to the window we
% care about (pre-shock steady state through the 2050Q1 endpoint).
databank.toCSV(tempDatabank, fullfile(project_path, "docs/csvFiles/figureNumbers.csv"), qq(2025, 1): qq(2050, 1) , "Decimals", 3, "Comments", false, "Class", false);

% Annual version: take the Q1 value as the representative for each year.
% convert(..., "Method", "first") picks the first high-frequency observation
% in each yearly period; since our series is anchored at Q1, that's Q1.
annualDatabank = databank.apply(tempDatabank, @(x) convert(x, Frequency.YEARLY, "Method", "first"));
databank.toCSV(annualDatabank, fullfile(project_path, "docs/csvFiles/figureNumbers_yearly.csv"), yy(2025): yy(2050) , "Decimals", 3, "Comments", false, "Class", false);

%%
function vertModelComparison(resultsProc, VarListToPlot, modelList, outputFileName)
    % Load objects and adjust settings
    utils.call.paths;
    envi = environment.setup();
    
    % Please specify the date range of the series
    dataRange = qq(1,1): qq(30,4);
    
    % Plotting
    figure
    
    % Create main tiledlayout
    t = tiledlayout(3, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
    h = gcf;
    set(h, 'Units', 'centimeters', 'Position', [0 0 18 11])
    set(h, 'DefaultTextInterpreter', 'latex');
    set(h, 'DefaultAxesTickLabelInterpreter', 'latex');
    set(h, 'DefaultLegendInterpreter', 'latex');
    
    % Create nested tiledlayouts for each row
    for aVar = VarListToPlot
        nexttile;
        grid on
        hold on
        title({envi.varDict{aVar, "description"}; "("+replace(aVar, "_", "\_")+", "+envi.varDict{aVar, "diffDesc"}+")"}, 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', 10);
        
        for aModel = modelList % for each panel
            % Plotting the data
            plotData = resultsProc.(aModel).irf.(aVar){dataRange}; % Accessing the specific variable for the current model
            pp.(aModel) = plot(plotData, "LineWidth", 2);
        end
        
        hold off;
        
        % Setting of the x and y axis
        xtickformat(gca,'yQQQ');
        set(gca, ...
            'Xtick', dater.toMatlab(dataRange(1:40:end)), ...
            'Fontsize', 6, ...
            'Box', 'off', ...
            'TickLabelInterpreter', 'latex', ...
            'XLimitMethod', 'tight' ...
        );
    end

    % Setting of the legend   
    % Setting of the legend   
    leg = legend(...
        struct2array(pp) ...
        , replace(envi.shockDict{fieldnames(pp), "description"}, "&", "\&") ...
        , 'Orientation', 'horizontal' ...
        , 'Color', [1 1 1] ...
        , 'Fontsize', 8 ...
        , 'Interpreter', 'latex' ...
    );
    leg.Layout.Tile = 'north';
    leg.NumColumns = 2;    
    
    chartsDir = fullfile(project_path, 'docs', 'modelCharts');
    if ~exist(chartsDir, 'dir'); mkdir(chartsDir); end
    fullFileName = fullfile(chartsDir, [outputFileName '.png']);
    exportgraphics(t, fullFileName, 'BackgroundColor', 'none');
    fprintf('Graph saved as: %s\n', fullFileName);
end