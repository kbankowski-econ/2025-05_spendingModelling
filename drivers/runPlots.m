%% preamble
clear all; close all; clc; 
utils.call.paths;

%% ----------------
% Loading the databases
%  ----------------

%Declaring model names 
modelNames = ["Model_HumanCapital_v0", "Model_HumanCapital_v1"];  

%Declaring variables 
varConfig = struct(...
    'Model_HumanCapital_v0', struct(...
        'yd', 'Aggregate Demand', ...
        'C', 'Private Consumption', ...
        'Ip', 'Private investment', ...
        'Ig', 'Goverment Investment', ...
        'Cg', 'Goverment consumption: wastefule', ...
        'Cge', 'Government consumption: usefule', ...
        'effshock', 'Efficiency Process (1)', ...
        'effgeshock', 'Efficiency Process (2)' ...
    ) ...
);

% Initialize an empty structure to hold results
results = struct();

% Loop through each model and load data
for i = 1:length(modelNames)

    modelName = modelNames{i};

    % Load the model data
    plotDatabank.model = load(fullfile(project_path, 'models', modelName, 'Output', [modelName '_results.mat']));
    M_ = plotDatabank.model.M_;

    dataRange = qq(0, 4): qq(0, 4) + size(plotDatabank.model.oo_.endo_simul', 1) - 1;

    % Store endogenous and steady state variables
    results.(modelName).endoStruct.model = databank.fromArray( ...
        plotDatabank.model.oo_.endo_simul', ...
        M_.endo_names, ...
        dataRange(1) ...
    );
    
    results.(modelName).ssStruct.model = databank.fromArray( ...
        repmat(plotDatabank.model.oo_.steady_state', numel(dataRange), 1), ...
        M_.endo_names, ...
        dataRange(1) ...
    );

    % Handle parameters
    for aParam = string(reshape(plotDatabank.model.M_.param_names, 1, []))
        results.(modelName).paramStruct.model.(aParam) = plotDatabank.model.M_.params(strcmp(aParam, plotDatabank.model.M_.param_names));
    end

    % Calculate IRF transformations
    serIndex = cellfun(@(x) any(endsWith(x, {'effshock', 'effgeshock'})), M_.endo_names);

    results.(modelName).irfStruct.model = databank.copy( ...
        results.(modelName).endoStruct.model, ...
        "Transform", @(x) (x/x(qq(0, 4))-1)*100, ...
        "SourceNames", M_.endo_names(~serIndex) ...
    );

    results.(modelName).irfStruct.model = databank.copy( ...
        results.(modelName).endoStruct.model, ...
        "SourceNames", M_.endo_names(serIndex), ...
        "Transform", @(x) (x-x(qq(0, 4)))*100, ...
        "TargetDb", results.(modelName).irfStruct.model ...
    );


end


%% Plot comparison
vertModelComparison(results, ["yd", "C", "Ip", "Ig", "Cg", "Cge", "effshock", "effgeshock"], ["Model_HumanCapital_v0", "Model_HumanCapital_v1"], 'epsi_eff');

%%
function vertModelComparison(results, VarListToPlot, modelList, outputFileName)

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
            plotData = results.(aModel).irfStruct.model.(aVar){dataRange};  % Accessing the specific variable for the current model
            plot(plotData, "LineWidth", 2);

        end 

        hold off;

            
        % Setting of the x and y axis
        xtickformat(gca,'yQQQ');

        set(gca ...
            , 'Xtick', dater.toMatlab(dataRange(1:16:end)) ...
            , 'Fontsize', 8 ...
            , 'Box', 'off' ...
            , 'TickLabelInterpreter', 'latex' ...
            , 'XLimitMethod', 'tight' ...
        );

    end
    
    fullFileName = fullfile(project_path, 'docs', [outputFileName '.png']);
    exportgraphics(t, fullFileName, 'BackgroundColor', 'none');
    
    fprintf('Graph saved as: %s\n', fullFileName);
end