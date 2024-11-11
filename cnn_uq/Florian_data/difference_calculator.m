clear; clc; close all;

% Define file paths
segmentedImagePath = '/Users/mac/Desktop/Validation Study/Segmentations/img_16/img_1_6.tif';
thresholdedImagePath = '/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Threshold/Grayscale/img_16_1.tif';

% Read images
segmentedImage = imread(segmentedImagePath);
thresholdedImage = imread(thresholdedImagePath);

% Convert 32-bit image to 8-bit
thresholdedImage = uint8(255 * mat2gray(thresholdedImage));
% Create a blank channel
blankChannel = zeros(size(segmentedImage), 'like', segmentedImage);

% Create the RGB image for overlay
redChannel = segmentedImage;
greenChannel = thresholdedImage;
blueChannel = blankChannel;
combinedImage = cat(3, redChannel, greenChannel, blueChannel);

% fig1 = figure; imshow(combinedImage);
% title('Red: Segmented, Green: Thresholded');

% Save combined image
outputFolder = '/Users/mac/Desktop/Validation Study/Plots/Differences';
% saveas(fig1, fullfile(outputFolder, 'combinedImage.tif'));

% Ensure that the images are binary
if max(segmentedImage(:)) > 1
    segmentedImage = imbinarize(segmentedImage);
end

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

% % Visualize the labeled images
% fig2 = figure; 
% subplot(1,2,1); imshow(label2rgb(segLabels)); title('Labeled Segmented Image');
% subplot(1,2,2); imshow(label2rgb(threshLabels)); title('Labeled Thresholded Image');

% % Save labeled images
% saveas(fig2, fullfile(outputFolder, 'labeledImages.tif'));

% Plot Bubble Size Distribution with a logarithmic y-axis
fig3 = figure;
histogram(segAreas, 'FaceColor', 'r', 'FaceAlpha', 0.5);
hold on;
histogram(threshAreas, 'FaceColor', 'b', 'FaceAlpha', 0.5);
xlabel('Bubble size');
ylabel('Count');
legend('Segmented', 'Thresholded');
title('Bubble Size Distribution (Logarithmic Scale)');
set(gca, 'YScale', 'log');

% % Save histogram plot
% saveas(fig3, fullfile(outputFolder, 'bubbleSizeDistribution.tif'));

% % Side-by-Side Comparison with Zoom
% fig4 = figure;
% subplot(1,3,1); imshow(segmentedImage); title('Segmented');
% subplot(1,3,2); imshow(thresholdedImage); title('Thresholded');
% subplot(1,3,3); imshow(imcrop(abs(double(segmentedImage) - double(thresholdedImage)), [100, 100, 200, 200]), []); title('Zoomed Difference');

% % Save side-by-side comparison
% saveas(fig4, fullfile(outputFolder, 'sideBySideComparison.tif'));
% close all