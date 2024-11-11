function WeightedAverage(caseType)
    if strcmp(caseType, 'erosion')
        load('bubble_discretization_results_erosion.mat', 'results');
        filename = 'table_data_erosion.csv';
    elseif strcmp(caseType, 'dilation')
        load('bubble_discretization_results_dilation.mat', 'results');
        filename = 'table_data_dilation.csv';
    else
        disp('Invalid case type. Please specify "erosion" or "dilation".');
        return;
    end
    
    R_values_um = linspace(10E-6, 200E-6, 10) * 1e6;
    N_values_um = (0.001 ./ linspace(20, 250, 24)) * 1e6;
    gridResolution = 12.5;
    
    [PRE_Area_Matrix, PRE_Perimeter_Matrix, ME_Area_Matrix, ME_Perimeter_Matrix] = extractData(results);
    printErrorsToCSV(filename, R_values_um, N_values_um, PRE_Area_Matrix, PRE_Perimeter_Matrix, ME_Area_Matrix, ME_Perimeter_Matrix, gridResolution);
    calculateWeightedAveragesFromCSV(filename);
end

function [PRE_Area_Matrix, PRE_Perimeter_Matrix, ME_Area_Matrix, ME_Perimeter_Matrix] = extractData(results)
    PRE_Area_Matrix = extractMatrixFromResults(results, 'PRE_area');
    PRE_Perimeter_Matrix = extractMatrixFromResults(results, 'PRE_perimeter');
    ME_Area_Matrix = extractMatrixFromResults(results, 'ME_area');
    ME_Perimeter_Matrix = extractMatrixFromResults(results, 'ME_perimeter');
end

function printErrorsToCSV(filename, R_values_um, N_values_um, PRE_Area_Matrix, PRE_Perimeter_Matrix, ME_Area_Matrix, ME_Perimeter_Matrix, gridResolution)
    gridIndex = find(N_values_um == gridResolution, 1);
    if isempty(gridIndex)
        disp('Grid resolution of 12.5 µm not found.');
        return;
    end
    fid = fopen(filename, 'w');
    header = {'Bubble Radius (µm)', 'PRE Area (%)', 'PRE Perimeter (%)', 'ME Area (µm^2)', 'ME Perimeter (µm)'};
    fprintf(fid, '%s,', header{1:end-1});
    fprintf(fid, '%s\n', header{end});
    dataFormat = '%.2f,%.5f,%.5f,%.2e,%.2e\n';
    for R_idx = 1:length(R_values_um)
        fprintf(fid, dataFormat, R_values_um(R_idx), PRE_Area_Matrix(R_idx, gridIndex), PRE_Perimeter_Matrix(R_idx, gridIndex), ME_Area_Matrix(R_idx, gridIndex), ME_Perimeter_Matrix(R_idx, gridIndex));
    end
    fclose(fid);
    disp(['Results written to ' filename]);
end

function matrix = extractMatrixFromResults(results, fieldName)
    R_values = linspace(10E-6, 200E-6, 10);
    N_values = 20:10:250;
    matrix = zeros(length(R_values), length(N_values));
    for N_idx = 1:length(N_values)
        for R_idx = 1:length(R_values)
            field_R = ['R_', strrep(sprintf('%.0e', R_values(R_idx)), 'e-', 'e_neg')];
            matrix(R_idx, N_idx) = results(N_idx).(field_R).(fieldName);
        end
    end
end

function calculateWeightedAveragesFromCSV(filename)
    opts = detectImportOptions(filename);
    opts.VariableNamingRule = 'preserve';
    data = readtable(filename, opts);
    weights = data{:, 'Bubble Radius (µm)'};
    weightedAvgPREArea = calculateWeightedAverage(data{:, 'PRE Area (%)'}, weights);
    weightedAvgPREPerimeter = calculateWeightedAverage(data{:, 'PRE Perimeter (%)'}, weights);
    weightedAvgMEArea = calculateWeightedAverage(data{:, 'ME Area (µm^2)'}, weights);
    weightedAvgMEPerimeter = calculateWeightedAverage(data{:, 'ME Perimeter (µm)'}, weights);
    disp(['Weighted Avg PRE Area: ' num2str(weightedAvgPREArea)]);
    disp(['Weighted Avg PRE Perimeter: ' num2str(weightedAvgPREPerimeter)]);
    disp(['Weighted Avg ME Area: ' num2str(weightedAvgMEArea)]);
    disp(['Weighted Avg ME Perimeter: ' num2str(weightedAvgMEPerimeter)]);
end

function [weightedAvg] = calculateWeightedAverage(values, weights)
    weightedAvg = sum(values .* weights) / sum(weights);
end
