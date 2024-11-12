clc; close all; clear

% Specify the input folder and the output folder
input_folder = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Current/First data from Florian/Chika/Thresholding';
output_folder = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Current/First data from Florian/Chika/Thresholding/Grayscale';

% Get a list of all IR image files in the input folder
image_files = dir(fullfile(input_folder, '*.tif')); % You can change '*.jpg' to the appropriate file format

% Loop through all the image files
for i = 1:length(image_files)
    % Read the infrared image
    ir_image = imread(fullfile(input_folder, image_files(i).name));

    % Convert the image to grayscale
    gray_image = rgb2gray(ir_image);

    % Save the grayscale image to the output folder
    imwrite(gray_image, fullfile(output_folder, ['grayscale_' image_files(i).name]));

    % Display the progress
    fprintf('Converted and saved image %d of %d: %s\n', i, length(image_files), image_files(i).name);
end

fprintf('All images have been converted and saved in the output folder.\n');
