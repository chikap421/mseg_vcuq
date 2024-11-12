clear; clc; close all;

% Define file paths
segmentedImagePath = '/Users/mac/Desktop/Validation Study/Segmentations/img_8/img_8_1.tif';
cameraImagePath = '/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Camera/Grayscale/8/img_8_1.tif';
thresholdedImagePath = '/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Threshold/Grayscale/img_8_1.tif';

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

% Define the target size
targetSize = [343, 344]; 

% Resize the segmented image
segmentedImage = imresize(segmentedImage, targetSize);

% Convert binary images to RGB images
segmentedRGB = uint8(cat(3, segmentedImage * 255, zeros(size(segmentedImage), 'uint8'), zeros(size(segmentedImage), 'uint8')));
thresholdedRGB = uint8(cat(3, zeros(size(thresholdedImage), 'uint8'), zeros(size(thresholdedImage), 'uint8'), thresholdedImage * 255));

% Blend the RGB images
combinedImage = max(segmentedRGB, thresholdedRGB);

% Create overlays with raw camera image
overlayCameraSegmented = max(im2double(cat(3, cameraImage, cameraImage, cameraImage)), im2double(segmentedRGB));
overlayCameraThresholded = max(im2double(cat(3, cameraImage, cameraImage, cameraImage)), im2double(thresholdedRGB));

% Save directory
saveDir = '/Users/mac/Desktop/Validation Study/Plots/Differences';

% Save Camera and Segmented Overlay
f = figure('visible','on');
imshow(overlayCameraSegmented, 'InitialMagnification', 'fit');
title('Camera and Segmented Overlay (Segmented in Red)');
axis off;
print(f, fullfile(saveDir, 'Camera_and_Segmented_Overlay.tif'), '-dtiff', '-r300');

% Save Camera and Thresholded Overlay
f = figure('visible','on');
imshow(overlayCameraThresholded, 'InitialMagnification', 'fit');
title('Camera and Thresholded Overlay (Thresholded in Blue)');
axis off;
print(f, fullfile(saveDir, 'Camera_and_Thresholded_Overlay.tif'), '-dtiff', '-r300');

% Save Combined Image
f = figure('visible','on');
imshow(combinedImage, 'InitialMagnification', 'fit');
title('Combined Image (Segmented in Red, Thresholded in Magenta)');
axis off;
print(f, fullfile(saveDir, 'Combined_Image.tif'), '-dtiff', '-r300');

% Save Raw Camera Image
f = figure('visible','on');
imshow(cameraImage, 'InitialMagnification', 'fit');
title('Raw Camera Image (Contrast Adjusted)');
axis off;
print(f, fullfile(saveDir, 'Raw_Camera_Image.tif'), '-dtiff', '-r300');
close all
