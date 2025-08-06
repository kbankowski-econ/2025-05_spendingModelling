%% preamble
clear all; close all; clc; 
utils.call.paths;

envi = environment.setup();


%% ----------------
% Loading the databases
% ----------------

% Declaring model names
modelList = string(reshape(envi.shockDict.Properties.RowNames, 1, []));

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
    
    % Calculate IRF transformations
    serIndex = cellfun(@(x) any(endsWith(x, {'effshock', 'effgeshock'})), resultsRaw.M_.endo_names);
    
    resultsProc.(aModel).irf = databank.copy( ...
        resultsProc.(aModel).endo, ...
        "Transform", @(x) (x/x(qq(0, 4))-1)*100, ...
        "SourceNames", resultsRaw.M_.endo_names(~serIndex) ...
    );
    
    resultsProc.(aModel).irf = databank.copy( ...
        resultsProc.(aModel).endo, ...
        "SourceNames", resultsRaw.M_.endo_names(serIndex), ...
        "Transform", @(x) (x-x(qq(0, 4))), ...
        "TargetDb", resultsProc.(aModel).irf ...
    );
end


%% Plot comparison
%vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock"], ["Model_HumanCapital_epsi_ig" , "Model_HumanCapital_epsi_cge" , "Model_HumanCapital_epsi_cgrd", "Model_HumanCapital_epsieff30y", "Model_HumanCapital_epsieffcge30y"], 'epsiall_AE');
vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock", "TFP"], ["Model_HumanCapital_epsi_igeff10y", "Model_HumanCapital_epsi_cgeeff10y", "Model_HumanCapital_epsi_igeff10y_al", "Model_HumanCapital_epsi_cgeeff10y_al"], 'epsiall_AE');
vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock", "TFP"], ["EM_Model_HumanCapital_epsiigeff25y", "EM_Model_HumanCapital_epsicgeeff25y", "EM_Model_HumanCapital_epsiigeff25y_al", "EM_Model_HumanCapital_epsicgeeff25y_al"], 'epsiall_EM');

%vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock"], ["Model_HumanCapital_epsi_ig", "EM_Model_HumanCapital_epsiig"], 'epsi_ig');;
%vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock"], ["Model_HumanCapital_epsi_cge", "EM_Model_HumanCapital_epsicge"], 'epsi_cge');;

%%

for aModel = modelList
    vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock"], [aModel], char(aModel));
end


%% reporting the numbers

tempDatabank = struct();

varList = ["yd", "C", "Ip", "Ig", "Cg", "Cge", "Cgrd", "H", "Lab", "E", "effshock", "effgeshock", "TFP", "ZZRD", "AAt"]

for aVar = varList

for aModel = modelList

tempDatabank.(aModel+"___"+aVar) = resultsProc.(aModel).irf.(aVar);

end

end

databank.toCSV(tempDatabank, "/Users/kk/Documents/0000-00_work/2025-05_spendingModelling/docs/csvFiles/figureNumbers.csv", qq(0, 4): qq(50, 4) , "Decimals", 3, "Comments", false, "Class", false);

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
    t = tiledlayout(4, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
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
    
    fullFileName = fullfile(project_path, 'docs', [outputFileName '.png']);
    exportgraphics(t, fullFileName, 'BackgroundColor', 'none');
    fprintf('Graph saved as: %s\n', fullFileName);
end