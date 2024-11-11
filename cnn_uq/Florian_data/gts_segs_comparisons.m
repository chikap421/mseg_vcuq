clc; clear; close all;

% Define folders
ground_truth_folders = {'/Users/mac/Desktop/Validation Study/User Ground Truth/Stefano', '/Users/mac/Desktop/Validation Study/User Ground Truth/Marco', '/Users/mac/Desktop/Validation Study/User Ground Truth/Yang', '/Users/mac/Desktop/Validation Study/User Ground Truth/Rodrigo', '/Users/mac/Desktop/Validation Study/User Ground Truth/Chika'};
segmented_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Segmentation';
save_folder = '/Users/mac/Desktop/Validation Study/User Ground Truth/Plots';

% Initialize arrays to store results for all folders
all_dry_area_fractions = [];
all_contact_line_densities = [];
folder_names = {};

% Loop through each ground truth folder
for folder_idx = 1:length(ground_truth_folders)
    ground_truth_folder = ground_truth_folders{folder_idx};

    % Extract folder name from the path
    [~, folder_name, ~] = fileparts(ground_truth_folder);
    folder_names = [folder_names, folder_name];

    % Get file names in each folder
    ground_truth_files = dir(fullfile(ground_truth_folder, 'img_*.tif'));

    % Initialize arrays to store results for current folder
    dry_area_fraction = [];
    contact_line_density = [];

    % Process each pair of corresponding images
    for i = 1:length(ground_truth_files)
        gt_file = fullfile(ground_truth_folder, ground_truth_files(i).name);

        % Load the images
        gt_img = imread(gt_file);

        % Calculate the metrics for each image
        [daf_gt, cld_gt] = calculate_metrics(gt_img);

        % Store the results
        dry_area_fraction = [dry_area_fraction, daf_gt];
        contact_line_density = [contact_line_density, cld_gt];
    end
    
    % Store the results for current folder in the all arrays
    all_dry_area_fractions = [all_dry_area_fractions; dry_area_fraction];
    all_contact_line_densities = [all_contact_line_densities; contact_line_density];
end

% Add segmentation results to all arrays
segmented_files = dir(fullfile(segmented_folder, 'img_*.tif'));
dry_area_fraction = [];
contact_line_density = [];
for i = 1:length(segmented_files)
    seg_file = fullfile(segmented_folder, segmented_files(i).name);
    seg_img = imread(seg_file);
    [daf_seg, cld_seg] = calculate_metrics(seg_img);
    dry_area_fraction = [dry_area_fraction, daf_seg];
    contact_line_density = [contact_line_density, cld_seg];
end
all_dry_area_fractions = [all_dry_area_fractions; dry_area_fraction];
all_contact_line_densities = [all_contact_line_densities; contact_line_density];
folder_names = [folder_names, 'Segmentation'];

% Bar chart for Dry Area Fraction
fig1 = figure;
bar(all_dry_area_fractions');
legend(folder_names, 'Location', 'bestoutside');
ylabel('Dry Area Fraction (%)');
title('Comparison of Dry Area Fraction');
set(gca, 'XTick', 1:size(all_dry_area_fractions, 2), 'XTickLabel', {'image 1', 'image 2'});
print(fig1, fullfile(save_folder, 'Dry_Area_Fraction_Comparison.tif'), '-dtiff', '-r300');

% Bar chart for Contact Line Density
fig2 = figure;
bar(all_contact_line_densities');
legend(folder_names, 'Location', 'bestoutside');
ylabel('Contact Line Density (px/px^2)');
title('Comparison of Contact Line Density');
set(gca, 'XTick', 1:size(all_contact_line_densities, 2), 'XTickLabel', {'image 1', 'image 2'});
print(fig2, fullfile(save_folder, 'Contact_Line_Density_Comparison.tif'), '-dtiff', '-r300');
close all
function [dry_area_fraction, contact_line_density] = calculate_metrics(binary_mask)
    % This function calculates the dry area fraction and contact line density
    % for the given binary mask image.
    total_pixels = numel(binary_mask);
    wet_pixels = sum(binary_mask == 0, 'all');
    dry_area_fraction = 100 * (1 - (wet_pixels / total_pixels));
    inverted_binary_mask = ~binary_mask;
    dist = bwdist(inverted_binary_mask);
    dist(dist > 1) = 0;
    contact_line_length = sum(dist(:));
    contact_line_density = contact_line_length / total_pixels;
end
