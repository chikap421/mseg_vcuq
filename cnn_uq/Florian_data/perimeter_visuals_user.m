% Define file paths
userImagePath = '/Users/mac/Desktop/Validation Study/User Ground Truth/8/Binary/Yang/img_9_1901.tif';
segmentedImagePath = '/Users/mac/Desktop/Validation Study/User Ground Truth/8/Binary/Segmentation/img_9_1901.tif';
thresholdedImagePath = '/Users/mac/Desktop/Validation Study/User Ground Truth/8/Binary/Thresholding/img_9_1901.tif';
cameraImagePath = '/Users/mac/Desktop/Validation Study/User Ground Truth/8/Annotations/Chika/img_9_1901.tif';

% Read images
userImage = imread(userImagePath);
segmentedImage = imread(segmentedImagePath);
thresholdedImage = imread(thresholdedImagePath);
cameraImage = imread(cameraImagePath);

% Adjust contrast of the camera image
cameraImage = imadjust(cameraImage);

% Ensure binary for segmented, thresholded, and user images
segmentedImage = imbinarize(segmentedImage);
thresholdedImage = imbinarize(thresholdedImage);
userImage = imbinarize(userImage);

% Define the target size
targetSize = size(cameraImage);

% Resize all binary images to the target size
segmentedImage = imresize(segmentedImage, targetSize(1:2));
thresholdedImage = imresize(thresholdedImage, targetSize(1:2));
userImage = imresize(userImage, targetSize(1:2));

% Find edges
segmentedImageEdges = bwperim(segmentedImage);
thresholdedImageEdges = bwperim(thresholdedImage);
userImageEdges = bwperim(userImage);

% Convert binary edges to RGB image
segmentedEdgesRGB = uint8(cat(3, segmentedImageEdges * 255, zeros(size(segmentedImageEdges), 'uint8'), zeros(size(segmentedImageEdges), 'uint8')));
thresholdedEdgesRGB = uint8(cat(3, zeros(size(thresholdedImageEdges), 'uint8'), thresholdedImageEdges * 255, zeros(size(thresholdedImageEdges), 'uint8')));
userEdgesRGB = uint8(cat(3, zeros(size(userImageEdges), 'uint8'), zeros(size(userImageEdges), 'uint8'), userImageEdges * 255));

% Convert the grayscale camera image to RGB
cameraImageRGB = im2double(repmat(cameraImage, 1, 1, 3));

% Blend the edge RGB images with the original camera image
overlayCameraSegmentedEdges = max(cameraImageRGB, im2double(segmentedEdgesRGB));
overlayCameraThresholdedEdges = max(cameraImageRGB, im2double(thresholdedEdgesRGB));
overlayCameraUserEdges = max(cameraImageRGB, im2double(userEdgesRGB));

% Blend the segmentation and thresholding RGB images
combinedSegmentedThresholdedEdges = max(im2double(segmentedEdgesRGB), im2double(thresholdedEdgesRGB));

% Blend the combined edges with the original camera image
overlayCameraCombinedEdges = max(cameraImageRGB, combinedSegmentedThresholdedEdges);

% Combine all together
overlayCameraCombinedAll = max(overlayCameraSegmentedEdges, overlayCameraThresholdedEdges);
overlayCameraCombinedAll = max(overlayCameraCombinedAll, overlayCameraUserEdges);

% Combine segmented, user, and camera edges
overlayCameraSegmentedUser = max(overlayCameraSegmentedEdges, overlayCameraUserEdges);

% Create a combined overlay of thresholded and user edges
overlayCameraThresholdedUser = max(cameraImageRGB, im2double(thresholdedEdgesRGB));
overlayCameraThresholdedUser = max(overlayCameraThresholdedUser, im2double(userEdgesRGB));

% Folder to save the images
outputFolder = '/Users/mac/Desktop/Validation Study/User Ground Truth/8/Edges';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

figure;
imshow(cameraImage);
title('Original Camera Image');
saveas(gcf, fullfile(outputFolder, 'Original_Camera_Image.tif'));

figure;
imshow(overlayCameraSegmentedUser);
title('Segmented and User Edges Overlay');
saveas(gcf, fullfile(outputFolder, 'Combined_Segmented_User_Camera_Edges_Overlay.tif'));

figure;
imshow(overlayCameraThresholdedUser);
title('Thresholded and User Edges Overlay');
saveas(gcf, fullfile(outputFolder, 'Combined_Thresholded_User_Edges_Overlay.tif'));

close all