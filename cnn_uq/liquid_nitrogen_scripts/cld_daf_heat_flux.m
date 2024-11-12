clc; close all; clear

% Define folders
segmentation_folder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Desktop/New New Latest/Composite tiffs/Segmentation';
thresholding_folder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Desktop/New New Latest/Composite tiffs/Thresholding';
plot_folder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Desktop/New New Latest/Composite tiffs/Plots/YY PLOTS';

% Process images in each folder
[all_dry_area_fraction_seg, all_contact_line_density_seg] = processImages(segmentation_folder);
[all_dry_area_fraction_thresh, all_contact_line_density_thresh] = processImages(thresholding_folder);
%%
% Define the heat flux values in order of the images
mean_heat_flux = 1e-3.*[45561.0318436366,66600.5782165498,84689.7339259306,103690.135239410,121831.617791306,140451.249652030,158018.803662130,175652.410486368,195264.248073821,216387.486378102,234258.872820858,250314.551709416,268961.626441209,285648.404789797,297224.729610854,305720.026775847];

% First, let's create a cell array of strings that we will use for titles and file names
param_names = {'Dry Area Fraction', 'Contact Line Density'};

% No need to convert to matrices if they're already matrices
all_dry_area_fraction_mat_seg = all_dry_area_fraction_seg;
all_contact_line_density_mat_seg = all_contact_line_density_seg;
all_dry_area_fraction_mat_thresh = all_dry_area_fraction_thresh;
all_contact_line_density_mat_thresh = all_contact_line_density_thresh;

% And a cell array to hold the data arrays
all_data_seg = {all_dry_area_fraction_mat_seg, all_contact_line_density_mat_seg};
all_data_thresh = {all_dry_area_fraction_mat_thresh, all_contact_line_density_mat_thresh};

% Your code here to define mean_heat_flux, ...
heat_flux_repeated = repelem(mean_heat_flux, size(all_dry_area_fraction_mat_seg, 1));

%% plots (Line plots with error bars, box plots, and combined box and line plots)
% Loop over the two parameters and Line plots with error bars for the two parameters
for p = 1:2
    % Get the data for this parameter
    param_data_seg = all_data_seg{p};
    param_data_thresh = all_data_thresh{p};
    param_name = param_names{p};

    % Create a new figure for each parameter
    fig = figure;

    % Line plot with error bars for segmentation data
    errorbar(mean_heat_flux, mean(param_data_seg), std(param_data_seg), 'b-o', ...
        'DisplayName', 'Segmentation', 'MarkerSize', 10); % Increase marker size
    hold on; % Allows the next plot to be drawn on the same axes

    % Line plot with error bars for thresholding data
    errorbar(mean_heat_flux, mean(param_data_thresh), std(param_data_thresh), 'r-o', ...
        'DisplayName', 'Thresholding', 'MarkerSize', 10); % Increase marker size

    % Add numbers next to the points in the plot
    xData1 = mean_heat_flux;
    yData1 = mean(param_data_seg);
    for i = 1:length(xData1)
        text(xData1(i), yData1(i), num2str(i+2), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
            'FontSize', 12); % Increase font size
    end

    xData2 = mean_heat_flux;
    yData2 = mean(param_data_thresh);
    for i = 1:length(xData2)
        text(xData2(i), yData2(i), num2str(i+2), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', ...
            'FontSize', 12); % Increase font size
    end

    % Setting the font size for axes labels and title
    ax = gca;
    ax.FontSize = 14; % Increase font size of axis ticks

    ylabel(param_name, 'FontSize', 14); % Increase font size
    xlabel('Mean Heat Flux (kWm^{-2})', 'FontSize', 14); % Increase font size
    title(['Line plot of ' param_name ' vs Mean Heat Flux'], 'FontSize', 16); % Increase title font size

    % Adding legend with increased font size
    legend('Location', 'best', 'FontSize', 12);

    % Save the plot
    % print(fig, '-dtiff', '-r300', fullfile(plot_folder, ['line_' param_name '_vs_mean_heat_flux_both_methods.tif']));
    % close(fig);
    
end


%%

% Loop over the two parameters and plot box plots with line plots for the two parameters
for p = 1:2
    % Get the data for this parameter
    param_data_seg = all_data_seg{p};
    param_data_thresh = all_data_thresh{p};
    param_name = param_names{p};

    % Create a new figure for each parameter
    fig = figure;
    
    % Calculate mean values for the line plot (segmentation)
    unique_heat_flux = unique(heat_flux_repeated);
    mean_values_seg = arrayfun(@(x) mean(param_data_seg(heat_flux_repeated == x)), unique_heat_flux);

    % Box plot for segmentation data
    boxplot(param_data_seg, heat_flux_repeated, 'Color', 'b', 'PlotStyle', 'compact', 'Labels', unique_heat_flux);
    hold on; % Keep the current plot and add another plot to it
    
    % Adding line plot for segmentation data
    plot(1:numel(unique_heat_flux), mean_values_seg, '-ob', 'DisplayName', 'Segmentation');
    
    % Calculate mean values for the line plot (thresholding)
    mean_values_thresh = arrayfun(@(x) mean(param_data_thresh(heat_flux_repeated == x)), unique_heat_flux);
    
    % Box plot for thresholding data (overlayed)
    boxplot(param_data_thresh, heat_flux_repeated, 'Color', 'r', 'PlotStyle', 'compact', 'Labels', unique_heat_flux);
    
    % Adding line plot for thresholding data
    plot(1:numel(unique_heat_flux), mean_values_thresh, '-or', 'DisplayName', 'Thresholding');
    hold off; % Release the hold so that next plot doesn't get added to the current figure

    % Adding labels and title
    ylabel(param_name);
    title(['Box plot of ' param_name ' vs Mean Heat Flux']);
    xlabel('Mean Heat Flux (kWm^{-2})');

    % Adding legend
    legend('Location', 'best');

% %   Save the plot (uncomment if needed)
%     print(fig,'-dtiff', '-r300', fullfile(plot_folder, ['boxplot_with_line_' param_name '_vs_mean_heat_flux_both_methods.tif']));
%     close(fig);
end

%% Relativ error comparisons

% Folder to save the plots
plot_folder = '/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/YY PLOTS';

% Create table to display the data and relative errors
resultTable = cell(17, 5); % initialize a cell array for the table
resultTable(1, :) = {'Index', 'Segmentation', 'Thresholding', 'Absolute Difference', 'Relative Error'}; % Headers

% Calculate values and relative errors for Contact Line Density and Dry Area Fraction
for p = 1:2
    param_data_seg = all_data_seg{p};
    param_data_thresh = all_data_thresh{p};
    param_name = param_names{p};
    
    fprintf('\nResults for %s:\n', param_name);
    
    % Calculate values and relative error for each index (3 to 18)
    for i = 1:length(mean_heat_flux)
        seg_value = mean(param_data_seg(:, i));
        thresh_value = mean(param_data_thresh(:, i));
        abs_difference = abs(seg_value - thresh_value);
        relative_error = (abs_difference / thresh_value); % Relative error in percentage
        
        % store the results in the table
        resultTable(i+1, :) = {i+2, seg_value, thresh_value, abs_difference, relative_error};
    end
    
    % Convert cell array to table
    T = cell2table(resultTable(2:end, :), 'VariableNames', resultTable(1, :));
    
    % Display the table
    disp(T);
    
    % Bar chart for visualization
    figure;
    h = bar(cell2mat(resultTable(2:end, 5))); % use the relative error for bar chart
    title(['Relative Error for ' param_name]);
    xlabel('Index');
    ylabel('Relative Error');
    xticks(1:16);
    xticklabels(3:18); % Setting x-axis labels from 3 to 18
    
    % Adding the values above the bars
    y = cell2mat(resultTable(2:end, 5)); % relative error values
    for i = 1:length(y)
        text(i, y(i), sprintf('%.2f', y(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    
    % Save the plot as a 300 dpi TIFF image in the specified folder
    filename = fullfile(plot_folder, sprintf('Relative_Error_Bar_Chart_%s.tif', param_name));
    print('-dtiff', '-r300', filename);
end
close all

%%
function [all_dry_area_fraction_mat, all_contact_line_density_mat] = processImages(folder)
    % Initialize cell arrays to store all dry area fractions and contact line densities
    all_dry_area_fraction = cell(1,16);
    all_contact_line_density = cell(1,16);

    % Loop over each file from img_3.tif to img_18.tif
    for i = 3:18
        % Get the full path to the file
        file = fullfile(folder, sprintf('img_%d.tif', i));

        % Get information about the TIFF file
        info = imfinfo(file);

        % Number of images in the TIFF file
        num_images = numel(info);

        % Preallocate arrays to store results
        dry_area_fraction = zeros(num_images, 1);
        contact_line_density = zeros(num_images, 1);

        % Loop over each image in the tiff file
        for k = 1:num_images
            % Load the specific image from the tiff file
            binary_mask = imread(file, k, 'Info', info);

            % Calculate the total number of pixels in the image
            total_pixels = numel(binary_mask);

            % Calculate the number of wet pixels (zeros)
            wet_pixels = sum(binary_mask == 0, 'all');

            % Calculate the dry area fraction
            dry_area_fraction(k) = 100*(1-(wet_pixels / total_pixels));

            % Invert the binary mask
            inverted_binary_mask = ~binary_mask;

            % Calculate the Euclidean distance transform of the inverted mask
            dist = bwdist(inverted_binary_mask);

            % Set all distance values greater than 1 to 0
            dist(dist > 1) = 0;

            % Calculate the contact line length by counting the pixels in the dist image
            contact_line_length = sum(dist, 'all');

            % Calculate the contact line density (length per unit area)
            contact_line_density(k) = contact_line_length / total_pixels;

            % Display progress
            fprintf('Processed image %d of %d in file img_%d.tif\n', k, num_images, i);
        end

        % Add the results to the cell arrays
        all_dry_area_fraction{i-2} = dry_area_fraction;
        all_contact_line_density{i-2} = contact_line_density;
    end

    % Convert all_dry_area_fraction and all_contact_line_density to matrices
    all_dry_area_fraction_mat = cell2mat(all_dry_area_fraction);
    all_contact_line_density_mat = cell2mat(all_contact_line_density);
end
