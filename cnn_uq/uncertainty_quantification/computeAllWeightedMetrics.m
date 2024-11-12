function computeAllWeightedMetrics()
    fluids = {'FC72', 'LAr', 'LN2', 'Water'};
    caseTypes = {'erosion', 'dilation'};
    basePath = '/Users/chikamaduabuchi/Documents/paul/uncertainty';
    dataPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Image analysis/Scripts and Macros/Chika scripts/Marco/bubble_discretization';

    for i = 1:length(fluids)
        for j = 1:length(caseTypes)
            fluidType = fluids{i};
            caseType = caseTypes{j};
            frequencyFilename = fullfile(basePath, ['top10BinsTable_', fluidType, '.csv']);
            if ~isfile(frequencyFilename)
                disp(['Frequency file for ', fluidType, ' not found.']);
                continue;
            end
            opts = detectImportOptions(frequencyFilename);
            opts.VariableNamingRule = 'preserve';
            frequencyData = readtable(frequencyFilename, opts);
            frequencies = frequencyData.Frequency;

            if strcmp(caseType, 'erosion')
                dataFilename = fullfile(dataPath, 'table_data_erosion.csv');
            elseif strcmp(caseType, 'dilation')
                dataFilename = fullfile(dataPath, 'table_data_dilation.csv');
            end
            if ~isfile(dataFilename)
                disp(['Data file ', dataFilename, ' not found for ', caseType, '.']);
                continue;
            end
            opts = detectImportOptions(dataFilename);
            opts.VariableNamingRule = 'preserve';
            mainData = readtable(dataFilename, opts);
            calculateWeightedAverages(fluidType, caseType, mainData, frequencies);
        end
    end
end

function calculateWeightedAverages(fluidType, caseType, mainData, frequencies)
    weightedAvgPREArea = calculateWeightedAverage(mainData.('PRE Area (%)'), frequencies);
    weightedAvgPREPerimeter = calculateWeightedAverage(mainData.('PRE Perimeter (%)'), frequencies);
    weightedAvgMEArea = calculateWeightedAverage(mainData.('ME Area (µm^2)'), frequencies);
    weightedAvgMEPerimeter = calculateWeightedAverage(mainData.('ME Perimeter (µm)'), frequencies);

    disp(['Results for ', fluidType, ' - ', caseType, ':']);
    disp(['Weighted Avg PRE Area: ', num2str(weightedAvgPREArea)]);
    disp(['Weighted Avg PRE Perimeter: ', num2str(weightedAvgPREPerimeter)]);
    disp(['Weighted Avg ME Area: ', num2str(weightedAvgMEArea)]);
    disp(['Weighted Avg ME Perimeter: ', num2str(weightedAvgMEPerimeter)]);
end

function [weightedAvg] = calculateWeightedAverage(values, weights)
    weightedAvg = sum(values .* weights) / sum(weights);
end
