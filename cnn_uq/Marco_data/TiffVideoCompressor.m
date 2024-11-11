clc; clear;

% Specify the path to your input and output TIFF files
inputTiffPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Video/NB/TIFF/Processed/Processed_LAr_Baseline.tif';
outputTiffPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Video/NB/TIFF/Processed/LAr_Baseline_compressed.tif';

% Get the info of the TIFF file to find out the number of frames
info = imfinfo(inputTiffPath);
numFrames = numel(info);

% Create a waitbar to display progress
w = waitbar(0, '0% done', 'Name', 'TIFF Compression Progress');

% Frame reduction factor
frameReductionFactor = 1; % Reduce the number of frames by none

% Loop through each frame in the TIFF file
for k = 1:frameReductionFactor:numFrames
    % Read the current frame
    currentFrame = imread(inputTiffPath, k, 'Info', info);
    
    % Resize the frame slightly to reduce file size
    currentFrame = imresize(currentFrame, 0.3); % Adjust the resizing factor as necessary
    
    % Optionally reduce the bit depth (uncomment the line below to apply)
    currentFrame = uint8(currentFrame);

    % Save the frame to the new TIFF file with compression
    if k == 1
        imwrite(currentFrame, outputTiffPath, 'Compression', 'lzw');
    else
        imwrite(currentFrame, outputTiffPath, 'WriteMode', 'append', 'Compression', 'lzw');
    end

    % Update the waitbar
    waitbar(k / numFrames, w, sprintf('Progress: %d%%', round(100 * k / numFrames)));
end

% Close the waitbar
close(w);

disp('TIFF compression completed');
