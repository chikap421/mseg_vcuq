clc; clear; close all
% Define users and methods
users = {'Chika', 'Marco', 'Rodrigo', 'Stefano', 'Yang', 'Segmentation', 'Thresholding'};
images = {'img_8_1901.tif', 'img_9_1901.tif'};
baseDir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Desktop/Validation Study/User Ground Truth/8/Binary';

% Generate new legend labels as User 1, User 2, ..., but keep the last two entries unchanged
userLabels = arrayfun(@(x) sprintf('User %d', x), 1:(length(users)-2), 'UniformOutput', false);
userLabels = [userLabels, users(length(users)-1:end)]; % Keep the last two entries as is

% Add path to the calc_density_fraction function
addpath('/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Image analysis/Scripts and Macros/Chika scripts/Florian'); % <-- Replace this with the actual path

% Initialize results variables
dry_area_fractions = zeros(length(users), length(images));
contact_line_densities = zeros(length(users), length(images));

% Calculate metrics for each user and image
for i = 1:length(users)
    for j = 1:length(images)
        imagePath = fullfile(baseDir, users{i}, images{j});
        binary_mask = imread(imagePath);
        [dry_area_fractions(i,j), contact_line_densities(i,j)] = calc_density_fraction(binary_mask);
    end
end

% Create titles
titles = {'Video 8, Image 1901', 'Video 9, Image 1901'};

% Get screen size
screensize = get(groot, 'Screensize');

% Define font size and weight
fontSize = 24;
fontWeight = 'bold';

% Plot dry area fractions
figure('Position', screensize);
subplot(2,1,1); % 2 rows, 1 column
bar(dry_area_fractions');
title('Comparison of Dry Area Fraction for Each Image', 'FontSize', fontSize, 'FontWeight', fontWeight);
ylabel('Value', 'FontSize', fontSize, 'FontWeight', fontWeight);
xlabel('Images', 'FontSize', fontSize, 'FontWeight', fontWeight);
set(gca, 'XTickLabel', titles, 'FontSize', fontSize, 'FontWeight', fontWeight); % Use titles as labels
lgd = legend(userLabels, 'Location', 'bestoutside'); % Use userLabels here for legend
set(lgd, 'FontSize', fontSize, 'FontWeight', fontWeight);
grid on; % Add a grid

% Plot contact line densities
subplot(2,1,2); % 2 rows, 1 column
bar(contact_line_densities');
title('Comparison of Contact Line Density for Each Image', 'FontSize', fontSize, 'FontWeight', fontWeight);
ylabel('Value', 'FontSize', fontSize, 'FontWeight', fontWeight);
xlabel('Images', 'FontSize', fontSize, 'FontWeight', fontWeight);
set(gca, 'XTickLabel', titles, 'FontSize', fontSize, 'FontWeight', fontWeight); % Use titles as labels
lgd = legend(userLabels, 'Location', 'bestoutside'); % Again, use userLabels here
set(lgd, 'FontSize', fontSize, 'FontWeight', fontWeight);
grid on; % Add a grid
%%
% Identify index for "Segmentation" and indices to exclude from the maximum calculation
segmentationIndex = find(strcmp(users, 'Segmentation'));
thresholdingIndex = find(strcmp(users, 'Thresholding'));
excludeIndices = [segmentationIndex, thresholdingIndex];

% Compute maximum values excluding specific indices
max_dry_area_fractions = max(dry_area_fractions(setdiff(1:length(users), excludeIndices), :));
max_contact_line_densities = max(contact_line_densities(setdiff(1:length(users), excludeIndices), :));

% Compute percentage differences for dry area fraction and contact line density
percentage_diff_dry_area_segmentation = 100 * (dry_area_fractions(segmentationIndex, :) - max_dry_area_fractions) ./ max_dry_area_fractions;
percentage_diff_contact_line_segmentation = 100 * (contact_line_densities(segmentationIndex, :) - max_contact_line_densities) ./ max_contact_line_densities;

percentage_diff_dry_area_thresholding = 100 * (dry_area_fractions(thresholdingIndex, :) - max_dry_area_fractions) ./ max_dry_area_fractions;
percentage_diff_contact_line_thresholding = 100 * (contact_line_densities(thresholdingIndex, :) - max_contact_line_densities) ./ max_contact_line_densities;

% Display results
disp('Percentage difference between Segmentation and maximum values for dry area fraction:');
disp(percentage_diff_dry_area_segmentation);

disp('Percentage difference between Thresholding and maximum values for dry area fraction:');
disp(percentage_diff_dry_area_thresholding);

disp('Percentage difference between Segmentation and maximum values for contact line density:');
disp(percentage_diff_contact_line_segmentation);

disp('Percentage difference between Thresholding and maximum values for contact line density:');
disp(percentage_diff_contact_line_thresholding);

% Add plotting code here if needed
% Prepare data for plotting
percentage_differences_dry_area = [percentage_diff_dry_area_segmentation; percentage_diff_dry_area_thresholding]';
percentage_differences_contact_line = [percentage_diff_contact_line_segmentation; percentage_diff_contact_line_thresholding]';

% Your existing code remains the same until the plotting section

% Define font size and weight
fontSize = 18;
fontWeight = 'bold';

% Create a new figure
figure('Position', screensize);

% Plot percentage differences for dry area fraction (top subplot)
subplot(2,1,1);
bar(percentage_differences_dry_area);
title('Percentage Difference for Dry Area Fraction', 'FontSize', fontSize, 'FontWeight', fontWeight);
ylabel('Percentage Difference (%)', 'FontSize', fontSize, 'FontWeight', fontWeight);
xlabel('Images', 'FontSize', fontSize, 'FontWeight', fontWeight);
set(gca, 'XTickLabel', titles, 'FontSize', fontSize, 'FontWeight', fontWeight); % Use titles as labels
lgd = legend({'Segmentation', 'Thresholding'}, 'Location', 'bestoutside'); % Add legend
set(lgd, 'FontSize', fontSize, 'FontWeight', fontWeight);
grid on; % Add a grid

% Plot percentage differences for contact line density (bottom subplot)
subplot(2,1,2);
bar(percentage_differences_contact_line);
title('Percentage Difference for Contact Line Density', 'FontSize', fontSize, 'FontWeight', fontWeight);
ylabel('Percentage Difference (%)', 'FontSize', fontSize, 'FontWeight', fontWeight);
xlabel('Images', 'FontSize', fontSize, 'FontWeight', fontWeight);
set(gca, 'XTickLabel', titles, 'FontSize', fontSize, 'FontWeight', fontWeight); % Use titles as labels
lgd = legend({'Segmentation', 'Thresholding'}, 'Location', 'bestoutside'); % Add legend
set(lgd, 'FontSize', fontSize, 'FontWeight', fontWeight);
grid on; % Add a grid
