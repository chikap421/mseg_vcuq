%% Run Simulations and Save Results
clc; close all; clear;

L = 0.001;
N = 50;
R = 50E-6;
A_theoretical = pi * R^2;
P_theoretical = 2 * pi * R;
simulationLimits = [5e3, 10e3, 15e3, 20e3];

results = struct();

for i = 1:length(simulationLimits)
    numSimulationsValues = 100:100:simulationLimits(i);
    [PRE_Area, PRE_Perimeter] = runSimulations(L, numSimulationsValues, N, R, A_theoretical, P_theoretical);
    
    results(i).PRE_Area = PRE_Area;
    results(i).PRE_Perimeter = PRE_Perimeter;
    results(i).numSimulationsValues = numSimulationsValues;
end

save('bubble_discretization_iterations_results.mat', 'results');

%% Load Results and Plot
load('bubble_discretization_iterations_results.mat', 'results');

figure;
for i = 1:length(results)
    subplot(2, 2, i);
    
    yyaxis left;
    plot(results(i).numSimulationsValues, results(i).PRE_Perimeter, 'k-', 'MarkerFaceColor', 'k', 'Color', 'k');
    ylabel('Perimeter PRE (%)', 'FontSize', 14);
    set(gca, 'ycolor', 'k');

    yyaxis right;
    plot(results(i).numSimulationsValues, results(i).PRE_Area, 'r-', 'MarkerFaceColor', 'r', 'Color', 'r');
    ylabel('Area PRE (%)', 'FontSize', 14);
    set(gca, 'ycolor', 'r'); 

    numIterationsK = round(length(results(i).numSimulationsValues) * 100 / 1000);
    title(sprintf('%d K Iterations', numIterationsK), 'FontSize', 16);
    xlabel('Iterations', 'FontSize', 14);
    grid on;
    set(gca, 'FontSize', 12);
    legend({'Perimeter PRE', 'Area PRE'}, 'Location', 'south');
end

% Local Functions
function [PRE_Area, PRE_Perimeter] = runSimulations(L, numSimulationsValues, N, R, A_theoretical, P_theoretical)
    PRE_Area = zeros(length(numSimulationsValues), 1);
    PRE_Perimeter = zeros(length(numSimulationsValues), 1);
    rng(0); 
    tic;
    totalSimulations = length(numSimulationsValues);
    for idx = 1:totalSimulations
        numSimulations = numSimulationsValues(idx);
        [AreaValues, PerimeterValues] = simulateMultipleBubbles(L, N, R, numSimulations);
        PRE_Area(idx) = 100 * (A_theoretical - mean(AreaValues)) / A_theoretical;
        PRE_Perimeter(idx) = 100 * (P_theoretical - mean(PerimeterValues)) / P_theoretical;
        if mod(idx, 1) == 0
            fprintf('Completed %d of %d simulations (%.2f%%)\n', idx, totalSimulations, (idx/totalSimulations)*100);
        end
    end
    elapsedTime = toc;
    fprintf('Total simulation time: %.2f seconds.\n', elapsedTime);
end

function [AreaValues, PerimeterValues] = simulateMultipleBubbles(L, N, R, numSimulations)
    AreaValues = zeros(numSimulations, 1);
    PerimeterValues = zeros(numSimulations, 1);
    for k = 1:numSimulations
        [PerimeterValues(k), AreaValues(k)] = simulateBubble(L, N, R);
    end
end

function [Perimeter, Area] = simulateBubble(L, N, R)
    [Xc, Yc] = meshgrid(linspace(L/N/2, L-L/N/2, N));
    Xb = R + (L - 2*R) * rand();
    Yb = R + (L - 2*R) * rand();
    Dis = sqrt((Xc - Xb).^2 + (Yc - Yb).^2);
    bubble = (Dis < R);
    Perimeter = sum(bwperim(bubble), 'all') * (L/N);
    Area = sum(bubble, 'all') * (L/N)^2;
end

function h = plotPRE(xValues, yValues, plotStyle)
    h = plot(xValues, yValues, plotStyle, 'MarkerFaceColor', 'k', 'Color', 'k');
end
