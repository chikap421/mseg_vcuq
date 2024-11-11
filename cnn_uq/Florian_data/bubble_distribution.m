clear; clc; close all;

% Define file paths
segmentedImagePath = '/Users/mac/Desktop/Validation Study/Segmentations/img_8/img_9_1.tif';
cameraImagePath = '/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Camera/Grayscale/9/img_9_1.tif';
thresholdedImagePath = '/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Threshold/Grayscale/img_9_1.tif';

% Save directory
saveDir = '/Users/mac/Desktop/Validation Study/Plots/Differences';

% Read images
segmentedImage = imread(segmentedImagePath);
cameraImage = imread(cameraImagePath);
thresholdedImage = imread(thresholdedImagePath);

% Adjust contrast of the camera image
cameraImage = imadjust(cameraImage);

% Make sure the segmented image is binary
if max(segmentedImage(:)) > 1
    segmentedImage = imbinarize(segmentedImage);
end

% Make sure the thresholded image is binary
if max(thresholdedImage(:)) > 1
    thresholdedImage = imbinarize(thresholdedImage);
end

% Label the binary images
segLabels = bwlabel(segmentedImage);
threshLabels = bwlabel(thresholdedImage);

% Calculate areas
segProps = regionprops(segLabels, 'Area');
threshProps = regionprops(threshLabels, 'Area');
segAreas = [segProps.Area];
threshAreas = [threshProps.Area];

% Plot Bubble Size Distribution with a linear y-axis
fig1 = figure;
binSize = 5; % you can adjust this to your liking

% Plot the histograms with same bin size
histogram(segAreas, 'BinWidth', binSize, 'FaceColor', 'r', 'FaceAlpha', 0.5);
hold on;
histogram(threshAreas, 'BinWidth', binSize, 'FaceColor', 'b', 'FaceAlpha', 0.5);

xlabel('Bubble size (px)');
ylabel('Count');
legend('Segmented', 'Thresholded');
title('Bubble Size Distribution (Linear Bins)');

% Save histogram plot
outputFilename = fullfile(saveDir, 'bubbleSizeDistribution_linear.tif');
print(fig1, outputFilename, '-dtiff', '-r300');
close all;

% Plot Bubble Size Distribution with log y-axis
fig2 = figure;

% Define bin edges as logarithmically spaced values
minArea = min([segAreas, threshAreas]);
maxArea = max([segAreas, threshAreas]);
binEdges = logspace(log10(minArea), log10(maxArea), 20); % 20 bins, adjust to your preference

% Plot the histograms with same bin size
histogram(segAreas, 'BinEdges', binEdges, 'FaceColor', 'r', 'FaceAlpha', 0.5);
hold on;
histogram(threshAreas, 'BinEdges', binEdges, 'FaceColor', 'b', 'FaceAlpha', 0.5);

set(gca, 'XScale', 'log'); % set x-axis to log scale

xlabel('Bubble size (px)');
ylabel('Count');
legend('Segmented', 'Thresholded');
title('Bubble Size Distribution (Log Bins)');

% Save histogram plot
outputFilename = fullfile(saveDir, 'bubbleSizeDistribution_logscale.tif');
print(fig2, outputFilename, '-dtiff', '-r300');
close all;

numBubblesInSegmentedImage = length(segAreas);
numBubblesInThresholdedImage = length(threshAreas);

disp(['Number of bubbles in segmented image: ', num2str(numBubblesInSegmentedImage)]);
disp(['Number of bubbles in thresholded image: ', num2str(numBubblesInThresholdedImage)]);
