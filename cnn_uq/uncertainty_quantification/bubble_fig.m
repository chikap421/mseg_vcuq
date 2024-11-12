clc; close all; clear;

L = 0.001; % Domain size
R = 100E-6; % Bubble radius
N_values = [10, 20, 45, 100]; % Resolution values

% Preparing the figure
fig = figure;
set(fig, 'Position', [100, 100, 1049, 895]); % Set figure position and size

% Dummy objects for the legend
hold on;
h1 = plot(NaN, NaN, 'k', 'LineWidth', 5); % Dummy plot for Discretized Bubble
h2 = plot(NaN, NaN, 'r', 'LineWidth', 2); % Dummy plot for Theoretical Bubble Outline

% Iterating over N values
for idx = 1:length(N_values)
    N = N_values(idx); % Current N value
    [Xc, Yc] = meshgrid(linspace(0, L, N));
    Xb = L/2; % Centering the bubble in the middle of the domain
    Yb = L/2;
    Dis = sqrt((Xc - Xb).^2 + (Yc - Yb).^2);
    bub = (Dis < R);
    
    % Subplot configuration
    subplot(2, 2, idx);
    imagesc([0 L], [0 L], double(~bub)); colormap("parula"); 
    axis square; % Square aspect ratio
    
    % Plotting the theoretical bubble outline in red
    viscircles([N/2, N/2]*L/N, R, 'EdgeColor', 'r', 'LineWidth', 2); % Thicker red circle for visibility
    
    % Improving plot aesthetics
    ax = gca;
    ax.FontSize = 14; % Larger font size for subplot
    ax.LineWidth = .5; % Thicker axes lines for visibility
    ax.GridColor = [0, 0, 0]; % Black color for major grids
    ax.GridAlpha = 0.5; % Transparency of the grid lines
    ax.MinorGridColor = [0.2, 0.2, 0.2]; % Darker minor grid color
    ax.MinorGridAlpha = 0.05; % Transparency of minor grid lines
    ax.MinorGridLineStyle = '--'; % Style of minor grid lines
    ax.XMinorGrid = 'on'; % Turn on minor grid for X-axis
    ax.YMinorGrid = 'on'; % Turn on minor grid for Y-axis
    
    % Labels and title for subplots
    title(sprintf('N = %d', N), 'FontSize', 16);
    xlabel('X Position (m)', 'FontSize', 14);
    ylabel('Y Position (m)', 'FontSize', 14);
end

% Adjust the legend
legend([h1, h2], {'Discretized Bubble', 'Theoretical Bubble Outline'}, 'FontSize', 14, 'Location', 'bestoutside');
hold off;
