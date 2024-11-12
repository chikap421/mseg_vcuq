clc; close all; clear;

L = 0.001;
numSimulations = 5e3;
N_values = 20:10:250;
R_values = linspace(10E-6, 100E-6, 10);
numN = length(N_values);
numR = length(R_values);

ME_Area = zeros(numSimulations, numN, numR);
PRE_Area = zeros(numSimulations, numN, numR);
ME_Perimeter = zeros(numSimulations, numN, numR);
PRE_Perimeter = zeros(numSimulations, numN, numR);

rng(0);
totalIterations = numSimulations * numN * numR;
currentIteration = 0;

tic;

for N_idx = 1:numN
    for R_idx = 1:numR
        N = N_values(N_idx);
        R = R_values(R_idx);
        [Xc, Yc] = meshgrid(linspace(L/N/2, L-L/N/2, N));
        A_theoretical = pi * R^2;
        P_theoretical = 2 * pi * R;
        
        for k = 1:numSimulations
            currentIteration = currentIteration + 1;
            Xb = R + (L - 2*R) * rand();
            Yb = R + (L - 2*R) * rand();
            Dis = sqrt((Xc - Xb).^2 + (Yc - Yb).^2);
            bub = (Dis < R);

            A_Simulated = sum(bub, 'all') * (L/N)^2;
            P_Simulated = sum(bwperim(bub), 'all') * (L/N);

            ME_Area(k, N_idx, R_idx) = A_theoretical - A_Simulated;
            PRE_Area(k, N_idx, R_idx) = 100 * (A_theoretical - A_Simulated) / A_theoretical;
            ME_Perimeter(k, N_idx, R_idx) = P_theoretical - P_Simulated;
            PRE_Perimeter(k, N_idx, R_idx) = 100 * (P_theoretical - P_Simulated) / P_theoretical;
            
            if mod(currentIteration, 100) == 0
                fprintf('Progress: %d of %d simulations completed. (%.2f%%)\n', currentIteration, totalIterations, (currentIteration / totalIterations) * 100);
            end
        end
    end
end

totalTime = toc;
fprintf('Total simulation time: %.2f seconds.\n', totalTime);

save('bubble_discretization_results_ErrorDistributions.mat', 'ME_Area', 'PRE_Area', 'ME_Perimeter', 'PRE_Perimeter');


%% Visualizations

load('bubble_discretization_results_ErrorDistributions.mat', 'ME_Area', 'PRE_Area', 'ME_Perimeter', 'PRE_Perimeter');

R_values_um = linspace(10E-6, 100E-6, 10) * 1e6;
N_values_um = (0.001 ./ (20:10:250)) * 1e6;
fontSize = 16;
figPosition = [100, 100, 1024, 768];
preAreaLimits = [-200 100];

fig = figure;
set(fig, 'Position', figPosition);
createHistogramSubplot(ME_Area(:), 1, 'Mean Error of Area (\mum^2)', 'Mean Error for Area');
createHistogramSubplot(ME_Perimeter(:), 2, 'Mean Error of Perimeter (\mum)', 'Mean Error for Perimeter');
createHistogramSubplot(PRE_Area(:), 3, 'PRE of Area (%)', 'Histogram of PRE for Area');
createHistogramSubplot(PRE_Perimeter(:), 4, 'PRE of Perimeter (%)', 'PRE for Perimeter');

%% Local Functions
function createHistogramSubplot(data, position, xlabelText, titleText, xLimits)
    subplot(2, 2, position);
    histogram(data, 10);
    xlabel(xlabelText, 'FontSize', 20);
    ylabel('Frequency', 'FontSize', 20);
    title(titleText, 'FontSize', 20);
    set(gca, 'LineWidth', 2, 'FontSize', 16, 'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');

    if exist('xLimits', 'var')
        xlim(xLimits);
    end
end
