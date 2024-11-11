clc; clear; close all

% Define folders

ground_truth_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Stefano';
segmented_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Chika';
CLD_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Plots/CLD';
DAF_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Plots/DAF';
metrics_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Plots/RE';

% Extract folder name from the path
[~, folder_name, ~] = fileparts(ground_truth_folder);

% Get file names in each folder
ground_truth_files = dir(fullfile(ground_truth_folder, 'img_*.tif'));
segmented_files = dir(fullfile(segmented_folder, 'img_*.tif'));

% Initialize arrays to store results
dry_area_fraction_gt = [];
dry_area_fraction_seg = [];
contact_line_density_gt = [];
contact_line_density_seg = [];

% Initialize arrays to store error metrics
relative_error_daf = [];
relative_error_cld = [];

image_names = {}; % array to hold file names

% Process each pair of corresponding images
for i = 1:length(ground_truth_files)
    gt_file = fullfile(ground_truth_folder, ground_truth_files(i).name);
    seg_file = fullfile(segmented_folder, segmented_files(i).name);
    
    % Load the images
    gt_img = imread(gt_file);
    seg_img = imread(seg_file);
    
    % Calculate the metrics for each image
    [daf_gt, cld_gt] = calculate_metrics(gt_img);
    [daf_seg, cld_seg] = calculate_metrics(seg_img);
    
    % Store the results
    dry_area_fraction_gt = [dry_area_fraction_gt, daf_gt];
    dry_area_fraction_seg = [dry_area_fraction_seg, daf_seg];
    contact_line_density_gt = [contact_line_density_gt, cld_gt];
    contact_line_density_seg = [contact_line_density_seg, cld_seg];
    
    % Calculate and store error metrics
    relative_error_daf = [relative_error_daf, abs((daf_gt - daf_seg) / daf_gt)];
    relative_error_cld = [relative_error_cld, abs((cld_gt - cld_seg) / cld_gt)];
    
    % Store the name of the image file without extension
    [~, name, ~] = fileparts(gt_file);
    image_names = [image_names, name];
end

% Bar chart for Dry Area Fraction
fig1=figure;
bar([dry_area_fraction_gt; dry_area_fraction_seg]');
legend({'Stefano', 'Chika'}, 'Location', 'north');
ylabel('Dry Area Fraction (%)');
title('Comparison of Dry Area Fraction');
set(gca, 'XTickLabel', image_names, 'XTick', 1:numel(image_names));
print(fig1, fullfile(DAF_folder, ['Dry_Area_Fraction_Comparison_' folder_name '.tif']), '-dtiff', '-r300');

% Bar chart for Contact Line Density
fig2=figure;
bar([contact_line_density_gt; contact_line_density_seg]');
legend({'Stefano', 'Chika'}, 'Location', 'northwest');
ylabel('Contact Line Density (px/px^2)');
title('Comparison of Contact Line Density');
set(gca, 'XTickLabel', image_names, 'XTick', 1:numel(image_names));
print(fig2, fullfile(CLD_folder, ['Contact_Line_Density_Comparison_' folder_name '.tif']), '-dtiff', '-r300');

% Bar chart for Relative Error
fig3=figure;
bar([relative_error_daf; relative_error_cld]');
legend({'Dry Area Fraction', 'Contact Line Density'}, 'Location', 'north');
ylabel('Relative Error');
title('Comparison of Relative Errors');
set(gca, 'XTickLabel', image_names, 'XTick', 1:numel(image_names));
print(fig3, fullfile(metrics_folder, ['Relative_Error_Comparison_' folder_name '.tif']), '-dtiff', '-r300');

close all

function [dry_area_fraction, contact_line_density] = calculate_metrics(binary_mask)
    % This function calculates the dry area fraction and contact line density
    % for the given binary mask image.
    
    % Total number of pixels
    total_pixels = numel(binary_mask);
    % Calculate the number of wet pixels (zeros)
    wet_pixels = sum(binary_mask == 0, 'all');

    % Calculate the dry area fraction
    dry_area_fraction = 100*(1-(wet_pixels / total_pixels));

    % Invert the binary mask
    inverted_binary_mask = ~binary_mask;
    % Euclidean distance transform
    dist = bwdist(inverted_binary_mask);
    % Set all distance values greater than 1 to 0
    dist(dist > 1) = 0;
    % Contact line length
    contact_line_length = sum(dist(:));
    % Contact line density
    contact_line_density = contact_line_length / total_pixels;
end
