clc; close all; clear;

L = 0.001;
numSimulations = 20e3;
N_values = linspace(20, 250, 24);
R_values = linspace(10E-6, 200E-6, 10);
results = struct();
rng(0);
totalIterations = length(N_values) * length(R_values) * numSimulations;
currentIteration = 0;

se = strel('disk', 1, 0);

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
            dilatedBub = imdilate(bub, se); 

            areaSimulated = sum(bub, 'all') * (L/N)^2;
            perimeterSimulated = sum(bwperim(dilatedBub), 'all') * (L/N);

            Perb(k) = perimeterSimulated;
            Abub(k) = areaSimulated;
            
            if mod(currentIteration, 100) == 0
                fprintf('Progress: %.2f%%\n', (currentIteration / totalIterations) * 100);
            end
            
        end

        field_R = ['R_', strrep(sprintf('%.0e', R), 'e-', 'e_neg')];
        results(N_idx).(field_R).PRE_area = 100 * (A_theoretical - mean(Abub)) / A_theoretical;
        results(N_idx).(field_R).PRE_perimeter = 100 * (P_theoretical - mean(Perb)) / P_theoretical;
        results(N_idx).(field_R).ME_area = A_theoretical - mean(Abub);
        results(N_idx).(field_R).ME_perimeter = P_theoretical - mean(Perb);
        results(N_idx).(field_R).Dilated_PRE_perimeter = 100 * (P_theoretical - mean(Perb)) / P_theoretical;
        results(N_idx).(field_R).Dilated_ME_perimeter = P_theoretical - mean(Perb);
    end
end   

totalTime = toc;
fprintf('Total simulation time: %.2f seconds.\n', totalTime);

save('bubble_discretization_results_dilation.mat', 'results');

%% Load Results and Plot

load('bubble_discretization_results_dilation.mat', 'results');

R_values_um = linspace(10E-6, 200E-6, 10) * 1e6;
N_values_um = (0.001 ./ linspace(20, 250, 24)) * 1e6;
fontSize = 16;

PRE_Area_Matrix = extractMatrixFromResults(results, 'PRE_area');
PRE_Perimeter_Matrix = extractMatrixFromResults(results, 'PRE_perimeter');
ME_Area_Matrix = extractMatrixFromResults(results, 'ME_area');
ME_Perimeter_Matrix = extractMatrixFromResults(results, 'ME_perimeter');

% figure
% createHistogramPlot(ME_Area_Matrix(:), 'ME of Area', 'Probability Density (1/\mum^2)', 'ME for Area', 1, 'linear');
% createHistogramPlot(ME_Perimeter_Matrix(:), 'ME of Perimeter', 'Probability Density (1/\mum)', 'ME for Perimeter', 2, 'linear');
% createHistogramPlot(PRE_Area_Matrix(:), 'PRE of Area (%)', 'Probability Density (1\mum^2)', 'PRE for Area', 3, 'linear');
% createHistogramPlot(PRE_Perimeter_Matrix(:), 'PRE of Perimeter (%)', 'Probability Density (\mum)', 'PRE for Perimeter', 4, 'linear');

figPosition1 = [100, 100, 560, 420];
figPosition2 = [700, 100, 560, 420];
figPosition3 = [100, 550, 560, 420];
figPosition4 = [700, 550, 560, 420];

% createSurfacePlot(N_values_um, R_values_um, PRE_Area_Matrix, 'PRE of Area (%)', fontSize, 'PRE_Area.png', figPosition1);
% createSurfacePlot(N_values_um, R_values_um, PRE_Perimeter_Matrix, 'PRE of Perimeter (%)', fontSize, 'PRE_Perimeter.png', figPosition2);
% createSurfacePlot(N_values_um, R_values_um, ME_Area_Matrix, 'ME of Area', fontSize, 'ME_Area.png', figPosition3);
% createSurfacePlot(N_values_um, R_values_um, ME_Perimeter_Matrix, 'ME of Perimeter', fontSize, 'ME_Perimeter.png', figPosition4);

%% Printing the Errors for Fixed Grid Resolution
gridResolution = 12.5;
gridIndex = find(N_values_um == gridResolution);

if isempty(gridIndex)
    disp('Grid resolution of 12.5 µm not found.');
    return;
end

filename = 'table_data_dilation.csv';
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

function createHistogramPlot(data, xLabel, yLabel, titleText, subplotIndex, scaleType)
    subplot(2, 2, subplotIndex);
    
    if isempty(scaleType) || strcmp(scaleType, 'linear')
        bins = 'auto';
    else
        bins = linspace(min(data), max(data), 11);
    end
    
    if strcmp(bins, 'auto')
        histogram(data, 'Normalization', 'pdf');
    else
        histogram(data, 'BinEdges', bins, 'Normalization', 'pdf');
    end
    
    fontSizeAxis = 14;
    fontSizeTicks = 12;
    fontSizeTitle = 16;
    lineWidth = 1.5;

    xlabel(xLabel, 'FontSize', fontSizeAxis);
    ylabel(yLabel, 'FontSize', fontSizeAxis);
    title(titleText, 'FontSize', fontSizeTitle);
    set(gca, 'FontSize', fontSizeTicks, 'LineWidth', lineWidth, 'XGrid', 'on', 'YGrid', 'on', 'Box', 'on', 'GridLineStyle', '-');

    if strcmp(scaleType, 'log')
        set(gca, 'XScale', 'log');
    else
        set(gca, 'XScale', 'linear');
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





