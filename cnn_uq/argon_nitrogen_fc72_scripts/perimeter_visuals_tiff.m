clc; clear;
% Define directories
baseDir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject';
segmentedDir = fullfile(baseDir, 'Segmentation', 'Frames', 'FC72');
binaryDir = fullfile(baseDir, 'Annotations', 'Binary', 'FC72');
cameraDir = fullfile(baseDir, 'Annotations', 'Camera', 'FC72_Normalized');
outputDir = fullfile(baseDir, 'OverlayImages', 'FC72');

% List all .tif files in the camera directory
cameraFiles = dir(fullfile(cameraDir, '*.tif'));

% Define the structuring element for dilation
se = strel('disk', 1);

% Loop through each file in the camera directory
    for fileIdx = 1:length(cameraFiles)
        baseFilename = extract_file_name(cameraFiles(fileIdx).name);

        % Read images
        segmentedImage = read_and_process_image(fullfile(segmentedDir, baseFilename), se);
        binarizedImage = read_and_process_image(fullfile(binaryDir, baseFilename), se);
        cameraImageRGB = read_and_convert_camera_image(fullfile(cameraDir, baseFilename));

        % Create and save overlays
        create_and_save_overlay(cameraImageRGB, segmentedImage, outputDir, baseFilename, '_OverlaySegmented.tif');
        create_and_save_overlay(cameraImageRGB, binarizedImage, outputDir, baseFilename, '_OverlayBinary.tif');
    end

    disp('Overlay images saved for all images in the directory!');


function baseFilename = extract_file_name(fileName)
    [~, baseFilename, ~] = fileparts(fileName);
    baseFilename = strcat(baseFilename, '.tif');
end

function processedImage = read_and_process_image(imagePath, se)
    image = imread(imagePath);
    image = imbinarize(image);
    imageEdges = imdilate(bwperim(image), se);
    processedImage = uint8(imageEdges * 255);
end

function cameraImageRGB = read_and_convert_camera_image(cameraImagePath)
    cameraImage = imread(cameraImagePath);
    cameraImageRGB = im2double(repmat(cameraImage, 1, 1, 3));
end

function create_and_save_overlay(cameraImageRGB, edgesImage, outputDir, baseFilename, suffix)
    if strcmp(suffix, '_OverlaySegmented.tif')
        edgesRGB = cat(3, edgesImage, zeros(size(edgesImage)), zeros(size(edgesImage)));
    elseif strcmp(suffix, '_OverlayBinary.tif')
        edgesRGB = cat(3, zeros(size(edgesImage)), edgesImage, zeros(size(edgesImage)));
    else
        edgesRGB = cat(3, edgesImage, zeros(size(edgesImage)), zeros(size(edgesImage)));
    end
    overlayImage = max(cameraImageRGB, im2double(edgesRGB));
    outputPath = fullfile(outputDir, strcat(baseFilename, suffix));
    imwrite(overlayImage, outputPath, 'Compression', 'none');
    fprintf('Processed and saved %s for: %s\n', suffix, baseFilename);
end
