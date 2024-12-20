clear; clc; close all;

% Define directory where the segmented videos are located
segmentedVideoDir = '/Users/mac/Desktop/New New Latest/Composite tiffs/Segmentation';
outputDir = '/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION';

% Arrays to store bubble sizes and corresponding video indices for the bivariate plot
segbubblesizes = [];
videoIndicesForAllBubbles = [];

% Loop through each segmented video (from img_3 to img_18)
for videoIndex = 3:18
    % Define file path for the current thresholded video
    segmentedVideoPath = fullfile(segmentedVideoDir, sprintf('img_%d.tif', videoIndex));

    % Get the number of images in the TIFF file
    info = imfinfo(segmentedVideoPath);
    numImages = numel(info);

    % Array to store bubble sizes from all images in the current segmented video
    bubbleSizesCurrentVideo = [];

    % Iterate through each image in the segmented video
    for k = 1:numImages
        % Read the current image from the segmented video
        currentImage = imread(segmentedVideoPath, k, 'Info', info);

        % Label the binary image
        labeledImage = bwlabel(currentImage);

        % Calculate areas (bubble sizes)
        imageProperties = regionprops(labeledImage, 'Area');
        bubbleSizes = [imageProperties.Area];

        % Concatenate bubble sizes to the array for the current segmented video
        bubbleSizesCurrentVideo = [bubbleSizesCurrentVideo, bubbleSizes];

        % Display progress
        fprintf('Processing frame %d of %d in segmented video img_%d...\n', k, numImages, videoIndex);
    end

    % Store bubble sizes and corresponding video indices for bivariate plot
    segbubblesizes = [segbubblesizes, bubbleSizesCurrentVideo];
    videoIndicesForAllBubbles = [videoIndicesForAllBubbles, repmat(videoIndex, 1, length(bubbleSizesCurrentVideo))];
end

% Define the heat flux vector
mean_heat_flux = 1e-3 .* [45561.0318436366, 66600.5782165498, 84689.7339259306, 103690.135239410, 121831.617791306, 140451.249652030, 158018.803662130, 175652.410486368, 195264.248073821, 216387.486378102, 234258.872820858, 250314.551709416, 268961.626441209, 285648.404789797, 297224.729610854, 305720.026775847];

% Map video indices to heat flux values
segheatflux = mean_heat_flux(videoIndicesForAllBubbles - 2);

% Save the data to .mat files for later use
save(fullfile(outputDir, 'videoIndicesForAllBubbles.mat'), 'videoIndicesForAllBubbles');
save(fullfile(outputDir, 'segbubblesizes.mat'), 'segbubblesizes');
save(fullfile(outputDir, 'segheatflux.mat'), 'segheatflux');

fprintf('All processing of segmented videos completed.\n');

%% If you've already saved the videoIndicesForAllBubbles.mat and segbubblesizes.mat files to your system, 
% load this data into MATLAB and use it to regenerate the bivariate plot. 
% You can then save the plot as an image file (e.g., TIFF format) to your system.

clear; clc; close all;

% Load the pre-saved data
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/videoIndicesForAllBubbles.mat');
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/segbubblesizes.mat');
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/segheatflux.mat');

% Define the output directory for saving the plot
outputDir = '/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION';

% Plot Bivariate Control Plot
figure;
scatter(segheatflux, segbubblesizes, 30, segbubblesizes, 'filled');
colormap('jet');
colorbar;
xlabel('Heat Flux (kW/m^2)');
ylabel('Bubble Size');
title('Bubble Sizes vs. Heat Flux');
axis tight;
box on;

% Save the bivariate plot to a file in TIFF format with 300 DPI resolution
outputFilename = fullfile(outputDir, 'bubbleSizes_vs_segheatflux_bivariatePlot.tif');
print('-dtiff', '-r300', outputFilename);

fprintf('Plotting and saving completed.\n');

close all
