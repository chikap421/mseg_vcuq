clear; clc; close all;

% Prompt the user for the desired image file and frame number
imgFileNumber = input('Enter image file number (3-18): ');
frameNumber = input('Enter frame number (1-2000): ');

% Check if entered numbers are within the valid range
if imgFileNumber < 3 || imgFileNumber > 18
    error('Invalid image file number. It should be between 3 and 18.');
end

if frameNumber < 1 || frameNumber > 2000
    error('Invalid frame number. It should be between 1 and 2000.');
end

% Define file paths
segmentedImagePath = sprintf('/Users/mac/Desktop/New New Latest/Composite tiffs/Segmentation/img_%d.tif', imgFileNumber);
thresholdedImagePath = sprintf('/Users/mac/Desktop/New New Latest/Composite tiffs/Thresholding/img_%d.tif', imgFileNumber);
cameraImagePath = sprintf('/Users/mac/Desktop/New New Latest/Composite tiffs/Camera/img_%d.tif', imgFileNumber);

% Read images
segmentedImage = imread(segmentedImagePath, frameNumber);
thresholdedImage = imread(thresholdedImagePath, frameNumber);
cameraImage = imread(cameraImagePath, frameNumber);

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

% Create a border mask
borderMask = false(size(thresholdedImage));
borderMask(1,:) = true; borderMask(end,:) = true;  % Top and bottom border
borderMask(:,1) = true; borderMask(:,end) = true;  % Left and right border

% Remove border lines from the image
thresholdedImage(borderMask) = 0;

% % Define the target size
% targetSize = [343, 344]; 
% 
% % Resize the segmented image
% segmentedImage = imresize(segmentedImage, targetSize);

% Label connected components in the images
segLabeled = bwlabel(segmentedImage);
threshLabeled = bwlabel(thresholdedImage);

% Get areas of the bubbles
segAreas = regionprops(segLabeled, 'Area');
threshAreas = regionprops(threshLabeled, 'Area');

% Convert areas to matrix format
segAreas = [segAreas.Area];
threshAreas = [threshAreas.Area];

% Define size classes (you may need to adjust these for your data)
sizeClasses = [0, 100, 200, 500, 1000, inf];  % example classes

% Initialize colored images
segColored = zeros([size(segmentedImage) 3], 'uint8');
threshColored = zeros([size(thresholdedImage) 3], 'uint8');

% Define colors for each size class (you may want to use different colors)
colors = uint8(jet(length(sizeClasses) - 1) * 255);

% Assign colors to bubbles based on their size
for ii = 1:length(sizeClasses)-1
    % Get binary image for the current size class
    segClass = ismember(segLabeled, find(segAreas > sizeClasses(ii) & segAreas <= sizeClasses(ii+1)));
    threshClass = ismember(threshLabeled, find(threshAreas > sizeClasses(ii) & threshAreas <= sizeClasses(ii+1)));
    
    % Add color to the images
    for jj = 1:3
        segColored(:,:,jj) = segColored(:,:,jj) + uint8(segClass) * colors(ii,jj);
        threshColored(:,:,jj) = threshColored(:,:,jj) + uint8(threshClass) * colors(ii,jj);
    end
end
%%
% Display the original and colored images
% figure; 
% imshow(segmentedImage); 
% title('Segmented Image');
% 
% figure; 
% imshow(thresholdedImage); 
% title('Thresholded Image');

figure; 
imshow(cameraImage); 
title('Camera Image');
%%
% Display colored thresholded image with colorbar
figure; 
imshow(threshColored); title('Colored Thresholded Image');
colorbarAxes = axes('Position',[.1 .05 .8 .05]);
for ii = 1:length(sizeClasses)-1
    patch([ii-1, ii, ii, ii-1], [0, 0, 1, 1], double(colors(ii,:))/255, 'EdgeColor', 'none'); hold on;
    text(ii-0.5, -0.5, sprintf('%d - %d px', sizeClasses(ii), sizeClasses(ii+1)), 'FontSize', 10, 'HorizontalAlignment', 'center');
end
set(colorbarAxes, 'Visible', 'off');
%%
% Display colored segmented image with colorbar
figure; 
imshow(segColored); title('Colored Segmented Image');
colorbarAxes = axes('Position',[.1 .05 .8 .05]);
for ii = 1:length(sizeClasses)-1
    patch([ii-1, ii, ii, ii-1], [0, 0, 1, 1], double(colors(ii,:))/255, 'EdgeColor', 'none'); hold on;
    text(ii-0.5, -0.5, sprintf('%d - %d px', sizeClasses(ii), sizeClasses(ii+1)), 'FontSize', 10, 'HorizontalAlignment', 'center');
end
set(colorbarAxes, 'Visible', 'off');
