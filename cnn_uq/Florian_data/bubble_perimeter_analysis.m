% Cleanup
clear; clc; close all;

% Define file paths
baseImagePath = '/Users/mac/Desktop/New New Latest/Composite tiffs/';
segmentedImagePath = fullfile(baseImagePath, 'Segmentation/img_%d.tif');
cameraImagePath = fullfile('/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Camera/Grayscale/9/img_9_1.tif');
thresholdedImagePath = fullfile(baseImagePath, 'Thresholding/img_%d.tif');

% Prompt user to input the video number and frame number
videoNum = input('Please enter the video number (3-18): ');
frameNum = input('Please enter the frame number (1-2000): ');

% Define full paths with video and frame numbers
segmentedImageFullPath = sprintf(segmentedImagePath, videoNum);
thresholdedImageFullPath = sprintf(thresholdedImagePath, videoNum);

% Read specific frame from multi-frame TIFFs for segmented and thresholded images
segmentedImage = imread(segmentedImageFullPath, frameNum);
cameraImage = imread(cameraImagePath);
thresholdedImage = imread(thresholdedImageFullPath, frameNum);

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

% Define the target size
targetSize = [343, 343]; 

% Resize all images to the target size
segmentedImage = imresize(segmentedImage, targetSize);
cameraImage = imresize(cameraImage, targetSize);
thresholdedImage = imresize(thresholdedImage, targetSize);

% Find edges in the segmented image
segmentedImageEdges = bwperim(segmentedImage);

% Convert binary edges to RGB image
segmentedEdgesRGB = uint8(cat(3, segmentedImageEdges * 255, zeros(size(segmentedImageEdges), 'uint8'), zeros(size(segmentedImageEdges), 'uint8')));

% Find edges in the thresholded image
thresholdedImageEdges = bwperim(thresholdedImage);

% Convert binary edges to RGB image
thresholdedEdgesRGB = uint8(cat(3, zeros(size(thresholdedImageEdges), 'uint8'), thresholdedImageEdges * 255, zeros(size(thresholdedImageEdges), 'uint8')));

% Convert the grayscale camera image to RGB
cameraImageRGB = im2double(repmat(cameraImage, 1, 1, 3));

% Blend the edge RGB images with the original camera image
overlayCameraSegmentedEdges = max(cameraImageRGB, im2double(segmentedEdgesRGB));
overlayCameraThresholdedEdges = max(cameraImageRGB, im2double(thresholdedEdgesRGB));

% Blend all together
overlayCameraBothEdges = max(overlayCameraSegmentedEdges, overlayCameraThresholdedEdges);

% Define save directories
saveDirBase = '/Users/mac/Desktop/Validation Study/Plots/Differences';
saveDirSegmented = fullfile(saveDirBase, 'SegmentedEdges');
saveDirThresholded = fullfile(saveDirBase, 'ThresholdedEdges');
saveDirCombined = fullfile(saveDirBase, 'CombinedEdges');

% Create directories if they do not exist
if ~exist(saveDirSegmented, 'dir')
   mkdir(saveDirSegmented);
end

if ~exist(saveDirThresholded, 'dir')
   mkdir(saveDirThresholded);
end

if ~exist(saveDirCombined, 'dir')
   mkdir(saveDirCombined);
end

% Save Camera and Segmented Overlay
f = figure('visible','on');
imshow(overlayCameraSegmentedEdges, 'InitialMagnification', 'fit');
axis off;
% print(f, fullfile(saveDirSegmented, sprintf('Camera_and_Segmented_Edges_Overlay_Video_%d_Frame_%d.tif', videoNum, frameNum)), '-dtiff', '-r300');

% Save Camera and Thresholded Overlay
f = figure('visible','on');
imshow(overlayCameraThresholdedEdges, 'InitialMagnification', 'fit');
axis off;
% print(f, fullfile(saveDirThresholded, sprintf('Camera_and_Thresholded_Edges_Overlay_Video_%d_Frame_%d.tif', videoNum, frameNum)), '-dtiff', '-r300');

% Save Combined Overlay
f = figure('visible','on');
imshow(overlayCameraBothEdges, 'InitialMagnification', 'fit');
axis off;
% print(f, fullfile(saveDirCombined, sprintf('Combined_Edges_Overlay_Video_%d_Frame_%d.tif', videoNum, frameNum)), '-dtiff', '-r300');

% Close figures
% close all
