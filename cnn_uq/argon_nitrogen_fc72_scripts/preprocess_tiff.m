clear; close all; clc;

% Define directories
inputDir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Annotations/Camera/FC72';
outputDir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Annotations/Camera/FC72_Normalized';

% List all .tif files in the directory
tifFiles = dir(fullfile(inputDir, '*.tif'));

% Loop through each file in the directory
for fileIdx = 1:length(tifFiles)
    % Read the current TIFF image
    currentImagePath = fullfile(inputDir, tifFiles(fileIdx).name);
    image_B = imread(currentImagePath);

    % Create a blank image based on the size and type of the image
    image_A = zeros(size(image_B), class(image_B));

    % Perform an absolute difference between the two images
    subtracted_image = imadjust(im2gray(imabsdiff(image_B, image_A)));
    subtracted_image2 = im2gray(imabsdiff(image_B, imgaussfilt(image_A,2)));

    % Define output path
    [~, baseFilename, ~] = fileparts(tifFiles(fileIdx).name);
    outputFilePath = fullfile(outputDir, strcat(baseFilename, '.tif'));
    
    % Save the processed image
    imwrite(subtracted_image, outputFilePath, 'Compression', 'none');

    fprintf('Processed and saved: %s\n', tifFiles(fileIdx).name);
end

disp('Processing complete for all images in the directory!');
