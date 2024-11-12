clear; clc; close all;

% Define directory where the thresholded videos are located
thresholdedVideoDir = '/Users/mac/Desktop/New New Latest/Composite tiffs/Thresholding'; % Modify this path
outputDir = '/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/THRESHOLDING'; % Modify this path

% Arrays to store bubble sizes and corresponding video indices for the bivariate plot
threshbubblesizes = [];
videoIndicesForAllBubbles = [];

% Loop through each thresholded video (from img_3 to img_18)
for videoIndex = 3:18
    % Define file path for the current thresholded video
    thresholdedVideoPath = fullfile(thresholdedVideoDir, sprintf('img_%d.tif', videoIndex));

    % Get the number of images in the TIFF file
    info = imfinfo(thresholdedVideoPath);
    numImages = numel(info);

    % Array to store bubble sizes from all images in the current thresholded video
    bubbleSizesCurrentVideo = [];

    % Iterate through each image in the thresholded video
    for k = 1:numImages
        % Read the current image from the thresholded video
        currentImage = imread(thresholdedVideoPath, k, 'Info', info);

        % Label the binary image
        labeledImage = bwlabel(currentImage);

        % Calculate areas (bubble sizes)
        imageProperties = regionprops(labeledImage, 'Area');
        bubbleSizes = [imageProperties.Area];

        % Concatenate bubble sizes to the array for the current thresholded video
        bubbleSizesCurrentVideo = [bubbleSizesCurrentVideo, bubbleSizes];

        % Display progress
        fprintf('Processing frame %d of %d in thresholded video img_%d...\n', k, numImages, videoIndex);
    end

    % Store bubble sizes and corresponding video indices for bivariate plot
    threshbubblesizes = [threshbubblesizes, bubbleSizesCurrentVideo];
    videoIndicesForAllBubbles = [videoIndicesForAllBubbles, repmat(videoIndex, 1, length(bubbleSizesCurrentVideo))];
end

% Define the heat flux vector
mean_heat_flux = 1e-3 .* [45561.0318436366, 66600.5782165498, 84689.7339259306, 103690.135239410, 121831.617791306, 140451.249652030, 158018.803662130, 175652.410486368, 195264.248073821, 216387.486378102, 234258.872820858, 250314.551709416, 268961.626441209, 285648.404789797, 297224.729610854, 305720.026775847];

% Map video indices to heat flux values
threshheatflux = mean_heat_flux(videoIndicesForAllBubbles - 2);

% Save the data to .mat files for later use
save(fullfile(outputDir, 'videoIndicesForAllBubbles.mat'), 'videoIndicesForAllBubbles');
save(fullfile(outputDir, 'threshbubblesizes.mat'), 'threshbubblesizes');
save(fullfile(outputDir, 'threshheatflux.mat'), 'threshheatflux');

fprintf('All processing of thresholded videos completed.\n');

%% Plotting

% Load the pre-saved data
load(fullfile(outputDir, 'videoIndicesForAllBubbles.mat'));
load(fullfile(outputDir, 'threshbubblesizes.mat'));
load(fullfile(outputDir, 'threshheatflux.mat'));

% Define the output directory for saving the plot
outputDir = '/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/THRESHOLDING'; % Modify this path

% Plot Bivariate Control Plot
figure;
scatter(threshheatflux, threshbubblesizes, 30, threshbubblesizes, 'filled');
colormap('jet');
colorbar;
xlabel('Heat Flux (kW/m^2)');
ylabel('Bubble Size');
title('Bubble Sizes vs. Heat Flux');
axis tight;
box on;

% Save the bivariate plot to a file in TIFF format with 300 DPI resolution
outputFilename = fullfile(outputDir, 'bubbleSizes_vs_threshheatflux_bivariatePlot.tif');
print('-dtiff', '-r300', outputFilename);

fprintf('Plotting and saving completed.\n');

close all
