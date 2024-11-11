clc; clear;

% Define folders
segmentedFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Video/LN2_Baseline.tif';
binarizedFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Binarization/NB/TIFF/LN2_Baseline.tif';
cameraFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Video/NB/TIFF/Processed/Processed_LN2_Baseline.tif';

% Output TIFF file
outputTIFFPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/OverlayImages/LN2_Baseline.tif';

% Read image info to get the number of frames
infoCamera = imfinfo(cameraFolder);
numFrames = numel(infoCamera);

% Loop through each frame
for i = 1:numFrames
    % Read each frame
    segmentedImage = imread(segmentedFolder, 'Index', i);
    binarizedImage = imread(binarizedFolder, 'Index', i);
    cameraImage = imread(cameraFolder, 'Index', i);
    
    % Resize (if needed)
    cameraImage = imresize(cameraImage, [602, 702]);
    binarizedImage = imresize(binarizedImage, [602, 702]);
    segmentedImage = imresize(binarizedImage, [602, 702]);

    % Ensure binary for segmented and binarized images
    segmentedImage = imbinarize(segmentedImage);
    binarizedImage = imbinarize(binarizedImage);
    
    % % Find edges and dilate
    % se = strel('disk', 1);
    % segmentedImageEdges = imdilate(bwperim(segmentedImage), se);
    % binarizedImageEdges = imdilate(bwperim(binarizedImage), se);

    % Find edges (no dilation step)
    segmentedImageEdges = bwperim(segmentedImage);
    binarizedImageEdges = bwperim(binarizedImage);

    % Convert binary edges to RGB image
    segmentedEdgesRGB = uint8(cat(3, segmentedImageEdges * 255, zeros(size(segmentedImageEdges), 'uint8'), zeros(size(segmentedImageEdges), 'uint8')));
    binarizedEdgesRGB = uint8(cat(3, zeros(size(binarizedImageEdges), 'uint8'), binarizedImageEdges * 255, zeros(size(binarizedImageEdges), 'uint8')));
    
    % Convert the grayscale camera image to RGB
    cameraImageRGB = im2double(repmat(cameraImage, 1, 1, 3));
    
    % Create individual overlays
    overlayFrame = max(cameraImageRGB, im2double(segmentedEdgesRGB));
    overlayFrame = max(overlayFrame, im2double(binarizedEdgesRGB));
    
    % Save the overlay image to a multi-frame TIFF
    if i == 1
        imwrite(overlayFrame, outputTIFFPath, 'Compression', 'lzw');
    else
        imwrite(overlayFrame, outputTIFFPath, 'WriteMode', 'append', 'Compression', 'lzw');
    end


    
    fprintf('Processed frame %d of %d\n', i, numFrames);
end

disp('Overlay frames saved in a single multi-frame TIFF.');

%% CONVERT TO MP4
% Define the paths
inputTIFFPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/OverlayImages/LN2_Baseline.tif';
outputVideoPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/OverlayImages/LN2_Baseline.mp4';

% Get the number of frames from the TIFF
info = imfinfo(inputTIFFPath);
numFrames = numel(info);

% Create a video writer object
v = VideoWriter(outputVideoPath, 'MPEG-4');
v.FrameRate = 10; % You can adjust this to your desired frame rate
open(v);

% Loop through the TIFF to write frames to the video
for k = 1:numFrames
    frame = imread(inputTIFFPath, k);
    writeVideo(v, frame);
    fprintf('Writing frame %d of %d to video...\n', k, numFrames);
end

% Close the video writer object
close(v);
disp('TIFF converted to MP4 video.');
