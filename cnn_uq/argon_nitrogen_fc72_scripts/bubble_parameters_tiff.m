%% Extract Dry Area Fraction and Contact Line Density
clc; clear;

% Add path to the function
addpath('/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Image analysis/Scripts and Macros/Chika scripts/Marco/');

% Define the folders and verify they exist
segmentedFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Frames/FC72';
binaryFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Annotations/Binary/FC72';
groundTruthFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/GroundTruths/FC72';

if ~isfolder(segmentedFolder) || ~isfolder(binaryFolder) || ~isfolder(groundTruthFolder)
    error('One or more specified folders do not exist');
end

% Get list of all files in the folders
segmentedFiles = dir(fullfile(segmentedFolder, '*.tif'));
binaryFiles = dir(fullfile(binaryFolder, '*.tif'));
groundTruthFiles = dir(fullfile(groundTruthFolder, '*.tif'));

% Create a cell array to store the file names (without extension)
imageNames = {segmentedFiles.name};
for i = 1:length(imageNames)
    imageNames{i} = erase(imageNames{i}, '.tif');
end

% Initialize arrays to store results
segmented_dry_area_fraction = zeros(length(segmentedFiles), 1);
segmented_contact_line_density = zeros(length(segmentedFiles), 1);
binary_dry_area_fraction = zeros(length(binaryFiles), 1);
binary_contact_line_density = zeros(length(binaryFiles), 1);
groundTruth_dry_area_fraction = zeros(length(groundTruthFiles), 1);
groundTruth_contact_line_density = zeros(length(groundTruthFiles), 1);

% Loop for segmented files
for i = 1:length(segmentedFiles)
    % Read and resize the image
    binary_mask = imread(fullfile(segmentedFolder, segmentedFiles(i).name));
    binary_mask = imresize(binary_mask, [720 602]);
    % Binarize the image
    binary_mask = imbinarize(binary_mask);
    
    [segmented_dry_area_fraction(i), segmented_contact_line_density(i)] = calc_density_fraction(binary_mask);
end

% Loop for binary files
for i = 1:length(binaryFiles)
    % Read and resize the image
    binary_mask = imread(fullfile(binaryFolder, binaryFiles(i).name));
    binary_mask = imresize(binary_mask, [720 602]);
    % Binarize the image
    binary_mask = imbinarize(binary_mask);
    
    [binary_dry_area_fraction(i), binary_contact_line_density(i)] = calc_density_fraction(binary_mask);
end

% Loop for GroundTruth files
for i = 1:length(groundTruthFiles)
    % Read and resize the image
    binary_mask = imread(fullfile(groundTruthFolder, groundTruthFiles(i).name));
    binary_mask = imresize(binary_mask, [720 602]);
    % Binarize the image
    binary_mask = imbinarize(binary_mask);
    
    [groundTruth_dry_area_fraction(i), groundTruth_contact_line_density(i)] = calc_density_fraction(binary_mask);
end

% Plotting for dry area fraction
figure;
bar([segmented_dry_area_fraction, binary_dry_area_fraction(1:length(segmented_dry_area_fraction)), groundTruth_dry_area_fraction(1:length(segmented_dry_area_fraction))]);
legend('Segmented', 'Binary', 'GroundTruth','Location', 'northeast');
title('Dry Area Fraction');
xlabel('Image Name');
ylabel('Dry Area Fraction');
xticks(1:length(imageNames));
xticklabels(imageNames);
xtickangle(45);

% Plotting for contact line density
figure;
bar([segmented_contact_line_density, binary_contact_line_density(1:length(segmented_contact_line_density)), groundTruth_contact_line_density(1:length(segmented_contact_line_density))]);
legend('Segmented', 'Binary', 'GroundTruth', 'Location', 'north');
title('Contact Line Density');
xlabel('Image Name');
ylabel('Contact Line Density (px/px^2)');
xticks(1:length(imageNames));
xticklabels(imageNames);
xtickangle(45);

% Relative Error Calculations

% Initialize arrays to store the relative errors
segmented_relative_error_dry_area = abs((segmented_dry_area_fraction - groundTruth_dry_area_fraction(1:length(segmented_dry_area_fraction))) ./ groundTruth_dry_area_fraction(1:length(segmented_dry_area_fraction))) * 100;
segmented_relative_error_contact_line = abs((segmented_contact_line_density - groundTruth_contact_line_density(1:length(segmented_contact_line_density))) ./ groundTruth_contact_line_density(1:length(segmented_contact_line_density))) * 100;

binary_relative_error_dry_area = abs((binary_dry_area_fraction - groundTruth_dry_area_fraction(1:length(binary_dry_area_fraction))) ./ groundTruth_dry_area_fraction(1:length(binary_dry_area_fraction))) * 100;
binary_relative_error_contact_line = abs((binary_contact_line_density - groundTruth_contact_line_density(1:length(binary_contact_line_density))) ./ groundTruth_contact_line_density(1:length(binary_contact_line_density))) * 100;
%
% Plotting for relative errors in dry area fraction
figure;
bar([segmented_relative_error_dry_area, binary_relative_error_dry_area(1:length(segmented_relative_error_dry_area))]);
legend('Segmented', 'Binary');
title('Relative Error in Dry Area Fraction');
xlabel('Image Name');
ylabel('Relative Error (%)');
xticks(1:length(imageNames));
xticklabels(imageNames);
xtickangle(45);

% Plotting for relative errors in contact line density
figure;
bar([segmented_relative_error_contact_line, binary_relative_error_contact_line(1:length(segmented_relative_error_contact_line))]);
legend('Segmented', 'Binary');
title('Relative Error in Contact Line Density');
xlabel('Image Name');
ylabel('Relative Error (%)');
xticks(1:length(imageNames));
xticklabels(imageNames);
xtickangle(45);

% Average DAF and CLD Calculations

% Calculate the mean percentage relative error for segmented and binary images for dry area fraction and contact line density
mean_segmented_relative_error_dry_area = mean(segmented_relative_error_dry_area);
mean_segmented_relative_error_contact_line = mean(segmented_relative_error_contact_line);
mean_binary_relative_error_dry_area = mean(binary_relative_error_dry_area);
mean_binary_relative_error_contact_line = mean(binary_relative_error_contact_line);

% Display the results in the console
fprintf('Mean Percentage Relative Error for Segmented Images:\n');
fprintf('Dry Area Fraction: %.2f%%\n', mean_segmented_relative_error_dry_area);
fprintf('Contact Line Density: %.2f%%\n', mean_segmented_relative_error_contact_line);

fprintf('Mean Percentage Relative Error for Binary Images:\n');
fprintf('Dry Area Fraction: %.2f%%\n', mean_binary_relative_error_dry_area);
fprintf('Contact Line Density: %.2f%%\n', mean_binary_relative_error_contact_line);

% Optionally, you can create a bar chart to visualize these mean percentage errors
figure;
bar([mean_segmented_relative_error_dry_area, mean_binary_relative_error_dry_area; mean_segmented_relative_error_contact_line, mean_binary_relative_error_contact_line]);
xticklabels({'Dry Area Fraction', 'Contact Line Density'});
ylabel('Mean Percentage Relative Error (%)');
legend('Segmented', 'Binary','Location', 'north');
title('Mean Percentage Relative Error');
