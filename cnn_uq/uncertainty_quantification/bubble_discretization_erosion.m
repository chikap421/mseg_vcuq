%% Run Simulations and Save Results
clc; close all; clear;

L = 0.001;
numSimulations = 20e3;
N_values = linspace(20, 250, 24);
R_values = linspace(10E-6, 200E-6, 10);
results = struct();
rng(0);
totalIterations = length(N_values) * length(R_values) * numSimulations;
currentIteration = 0;

tic;

for N_idx = 1:length(N_values)
    for R_idx = 1:length(R_values)
        N = N_values(N_idx);
        R = R_values(R_idx);
        [Xc, Yc] = meshgrid(linspace(L/N/2, L-L/N/2, N));

        A_theoretical = pi * R^2;
        P_theoretical = 2 * pi * R;
        
        Perb = zeros(numSimulations, 1);
        Abub = zeros(numSimulations, 1);

        for k = 1:numSimulations
            currentIteration = currentIteration + 1;
            Xb = R + (L - 2*R) * rand();
            Yb = R + (L - 2*R) * rand();
            Dis = sqrt((Xc - Xb).^2 + (Yc - Yb).^2);
            bub = (Dis < R);

            Perb(k) = sum(bwperim(bub), 'all') * (L/N);
            Abub(k) = sum(bub, 'all') * (L/N)^2;
            
            if mod(currentIteration, 100) == 0
                fprintf('Progress: %.2f%%\n', (currentIteration / totalIterations) * 100);
            end
        end

        field_R = ['R_', strrep(sprintf('%.0e', R), 'e-', 'e_neg')];

        results(N_idx).(field_R).PRE_area = 100 *(A_theoretical-mean(Abub)) / A_theoretical;
        results(N_idx).(field_R).PRE_perimeter = 100 * (P_theoretical-mean(Perb)) / P_theoretical;
        results(N_idx).(field_R).ME_area = (A_theoretical-mean(Abub));
        results(N_idx).(field_R).ME_perimeter = (P_theoretical-mean(Perb));
    end
end

totalTime = toc;
fprintf('Total simulation time: %.2f seconds.\n', totalTime);

save('bubble_discretization_results_erosion.mat', 'results');

%% Load Results and Plot

load('bubble_discretization_results_erosion.mat', 'results');

R_values_um = linspace(10E-6, 200E-6, 10) * 1e6;
N_values_um = (0.001 ./ linspace(20, 250, 24)) * 1e6;
fontSize = 16;
figPosition = [100, 100, 1024, 768];

PRE_Area_Matrix = extractMatrixFromResults(results, 'PRE_area');
PRE_Perimeter_Matrix = extractMatrixFromResults(results, 'PRE_perimeter');
ME_Area_Matrix = extractMatrixFromResults(results, 'ME_area');
ME_Perimeter_Matrix = extractMatrixFromResults(results, 'ME_perimeter');

fig = figure;
set(fig, 'Position', figPosition);

createHistogramPlot(ME_Area_Matrix(:), 'Mean Error of Area (\mum^2)', 'Frequency', 'Mean Error for Area', fontSize, 1, 'linear', 'adjusted');
createHistogramPlot(ME_Perimeter_Matrix(:), 'Mean Error of Perimeter (\mum)', 'Frequency', 'Mean Error for Perimeter', fontSize, 2, 'linear', 'adjusted');
createHistogramPlot(PRE_Area_Matrix(:), 'PRE of Area (%)', 'Frequency', 'Histogram of PRE for Area', fontSize, 3, 'linear', 'adjusted');
createHistogramPlot(PRE_Perimeter_Matrix(:), 'PRE of Perimeter (%)', 'Frequency', 'PRE for Perimeter', fontSize, 4, 'linear', 'adjusted');

figPosition1 = [100, 100, 560, 420];
figPosition2 = [700, 100, 560, 420];
figPosition3 = [100, 550, 560, 420];
figPosition4 = [700, 550, 560, 420];

createSurfacePlot(N_values_um, R_values_um, PRE_Area_Matrix, 'PRE of Area (%)', fontSize, 'PRE_Area.png', figPosition1);
createSurfacePlot(N_values_um, R_values_um, PRE_Perimeter_Matrix, 'PRE of Perimeter (%)', fontSize, 'PRE_Perimeter.png', figPosition2);
createSurfacePlot(N_values_um, R_values_um, ME_Area_Matrix, 'ME of Area (\mum^2)', fontSize, 'ME_Area.png', figPosition3);
createSurfacePlot(N_values_um, R_values_um, ME_Perimeter_Matrix, 'ME of Perimeter (\mum)', fontSize, 'ME_Perimeter.png', figPosition4);

%% Printing the Errors for Fixed Grid Resolution
gridResolution = 12.5;
gridIndex = find(N_values_um == gridResolution);

if isempty(gridIndex)
    disp('Grid resolution of 12.5 µm not found.');
    return;
end

filename = 'table_data_erosion.csv';
fid = fopen(filename, 'w');

header = {'Bubble Radius (µm)', 'PRE Area (%)', 'PRE Perimeter (%)', 'ME Area (µm^2)', 'ME Perimeter (µm)'};
fprintf(fid, '%s,', header{1:end-1});
fprintf(fid, '%s\n', header{end});

dataFormat = '%.2f,%.5f,%.5f,%.2e,%.2e\n';
for R_idx = 1:length(R_values_um)
    fprintf(fid, dataFormat, R_values_um(R_idx), PRE_Area_Matrix(R_idx, gridIndex), PRE_Perimeter_Matrix(R_idx, gridIndex), ME_Area_Matrix(R_idx, gridIndex), ME_Perimeter_Matrix(R_idx, gridIndex));
end

fclose(fid);
disp(['The results are written to the File ' filename]);
%% Local Functions

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

function createHistogramPlot(data, xLabel, yLabel, titleText, fontSize, subplotIndex, scaleType, binType)
    subplot(2, 2, subplotIndex);
    histogram(data, 'BinEdges', linspace(min(data), max(data), 11));
    xlabel(xLabel, 'FontSize', 20);
    ylabel(yLabel, 'FontSize', 20);
    title(titleText, 'FontSize', 20);
    set(gca, 'LineWidth', 2, 'FontSize', 16, 'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
    if strcmp(scaleType, 'linear')
        set(gca, 'XScale', 'linear');
        set(gca, 'YScale', 'linear');
    end
end

function createSurfacePlot(N_values_um, R_values_um, matrix, titleText, fontSize, ~, figPosition)
    figure;
    set(gcf, 'Position', figPosition);
    colormap(jet); 
    s = surf(N_values_um, R_values_um, matrix);
    s.EdgeColor = 'none';
    xlabel('Grid Cell Size (\mum)', 'FontSize', fontSize);
    ylabel('Bubble Radius (R) [\mum]', 'FontSize', fontSize);
    zlabel(titleText, 'FontSize', fontSize); 
    title(titleText, 'FontSize', fontSize); 
    colorbar;
    box on; 
    set(gca, 'LineWidth', 2);
end



