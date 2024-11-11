function WeightedAverage2(caseType, fluidType)
    basePath = '/Users/chikamaduabuchi/Documents/paul/uncertainty';
    frequencyFilename = fullfile(basePath, ['top10BinsTable_', fluidType, '.csv']);
    if ~isfile(frequencyFilename)
        disp(['Frequency file for ', fluidType, ' not found.']);
        return;
    end
    opts = detectImportOptions(frequencyFilename);
    opts.VariableNamingRule = 'preserve';  % Preserves the original column headers
    frequencyData = readtable(frequencyFilename, opts);
    frequencies = frequencyData.Frequency;

    dataPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Image analysis/Scripts and Macros/Chika scripts/Marco/bubble_discretization';
    if strcmp(caseType, 'erosion')
        dataFilename = fullfile(dataPath, 'table_data_erosion.csv');
    elseif strcmp(caseType, 'dilation')
        dataFilename = fullfile(dataPath, 'table_data_dilation.csv');
    else
        disp('Invalid case type. Please specify "erosion" or "dilation".');
        return;
    end
    if ~isfile(dataFilename)
        disp(['Data file ', dataFilename, ' not found.']);
        return;
    end
    opts = detectImportOptions(dataFilename);
    opts.VariableNamingRule = 'preserve';  % Preserves the original column headers
    mainData = readtable(dataFilename, opts);
    calculateWeightedAverages(mainData, frequencies);
end

function calculateWeightedAverages(mainData, frequencies)
    weightedAvgPREArea = calculateWeightedAverage(mainData.('PRE Area (%)'), frequencies);
    weightedAvgPREPerimeter = calculateWeightedAverage(mainData.('PRE Perimeter (%)'), frequencies);
    weightedAvgMEArea = calculateWeightedAverage(mainData.('ME Area (µm^2)'), frequencies);
    weightedAvgMEPerimeter = calculateWeightedAverage(mainData.('ME Perimeter (µm)'), frequencies);
    disp(['Weighted Avg PRE Area: ', num2str(weightedAvgPREArea)]);
    disp(['Weighted Avg PRE Perimeter: ', num2str(weightedAvgPREPerimeter)]);
    disp(['Weighted Avg ME Area: ', num2str(weightedAvgMEArea)]);
    disp(['Weighted Avg ME Perimeter: ', num2str(weightedAvgMEPerimeter)]);
end

function [weightedAvg] = calculateWeightedAverage(values, weights)
    weightedAvg = sum(values .* weights) / sum(weights);
end
