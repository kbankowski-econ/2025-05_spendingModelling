%% preamble
clear all; close all; clc; 
utils.call.paths;

%% ----------------
% Loading the databases
%  ----------------

%Declaring model names 
modelList = ["Model_HumanCapital_v0", "Model_HumanCapital_v1"];  

% Initialize an empty structure to hold results
resultsProc = struct();

% Loop through each model and load data
for aModel = modelList

    % Load the model data
    resultsRaw = load(fullfile(project_path, 'models', aModel, 'Output', [char(aModel) '_results.mat']));

    dataRange = qq(0, 4): qq(0, 4) + size(resultsRaw.oo_.endo_simul', 1) - 1;

    % Store endogenous and steady state variables
    resultsProc.(aModel).endoStruct = databank.fromArray( ...
        resultsRaw.oo_.endo_simul', ...
        resultsRaw.M_.endo_names, ...
        dataRange(1) ...
    );
    
    resultsProc.(aModel).ssStruct = databank.fromArray( ...
        repmat(resultsRaw.oo_.steady_state', numel(dataRange), 1), ...
        resultsRaw.M_.endo_names, ...
        dataRange(1) ...
    );

    % Handle parameters
    for aParam = string(reshape(resultsRaw.M_.param_names, 1, []))
        resultsProc.(aModel).paramStruct.(aParam) = resultsRaw.M_.params(strcmp(aParam, resultsRaw.M_.param_names));
    end

    % Calculate IRF transformations
    serIndex = cellfun(@(x) any(endsWith(x, {'effshock', 'effgeshock'})), resultsRaw.M_.endo_names);

    resultsProc.(aModel).irfStruct = databank.copy( ...
        resultsProc.(aModel).endoStruct, ...
        "Transform", @(x) (x/x(qq(0, 4))-1)*100, ...
        "SourceNames", resultsRaw.M_.endo_names(~serIndex) ...
    );

    resultsProc.(aModel).irfStruct = databank.copy( ...
        resultsProc.(aModel).endoStruct, ...
        "SourceNames", resultsRaw.M_.endo_names(serIndex), ...
        "Transform", @(x) (x-x(qq(0, 4)))*100, ...
        "TargetDb", resultsProc.(aModel).irfStruct ...
    );


end


%% Plot comparison
vertModelComparison(resultsProc, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "effshock", "effgeshock"], modelList, 'epsi_eff');

%%
function vertModelComparison(resultsProc, VarListToPlot, modelList, outputFileName)
    % Load objects and adjust settings
    utils.call.paths;
    
    % Please specify the date range of the series
    dataRange = qq(1,1): qq(25,4);
    
    % Plotting
    figure
    
    % Create main tiledlayout
    t = tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
    h = gcf;
    set(h, 'Units', 'centimeters', 'Position', [0 0 17 15])
    set(h, 'DefaultTextInterpreter', 'latex');
    set(h, 'DefaultAxesTickLabelInterpreter', 'latex');
    set(h, 'DefaultLegendInterpreter', 'latex');
    
    % Create nested tiledlayouts for each row
    for aVar = VarListToPlot
        nexttile;
        grid on
        hold on
        title(replace(aVar, "_", "\_"), 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', 10);
        
        for aModel = modelList % for each panel
            % Plotting the data
            plotData = resultsProc.(aModel).irfStruct.(aVar){dataRange}; % Accessing the specific variable for the current model
            plot(plotData, "LineWidth", 2);
        end
        
        hold off;
        
        % Setting of the x and y axis
        xtickformat(gca,'yQQQ');
        set(gca, ...
            'Xtick', dater.toMatlab(dataRange(1:16:end)), ...
            'Fontsize', 8, ...
            'Box', 'off', ...
            'TickLabelInterpreter', 'latex', ...
            'XLimitMethod', 'tight' ...
        );
    end
    
    fullFileName = fullfile(project_path, 'docs', [outputFileName '.png']);
    exportgraphics(t, fullFileName, 'BackgroundColor', 'none');
    fprintf('Graph saved as: %s\n', fullFileName);
end