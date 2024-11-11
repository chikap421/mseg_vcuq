clear; close all; clc;

% Define paths
image_path = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Video/NB/TIFF/FC72.tif';
output_dir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Video/NB/TIFF/Processed';
output_file_path = fullfile(output_dir, 'Processed_FC72.tif');

% Read the multi-frame TIFF
info = imfinfo(image_path);
num_images = numel(info);
img = imread(image_path, 1); % Read the first frame to get size

% Create a blank image based on the size and type of the frames in the composite TIFF
image_A = zeros(size(img), class(img));

% Initialize waitbar
h = waitbar(0, 'Initializing...');

% Loop through each frame in the multi-frame TIFF
for k = 1:num_images
    % Update the waitbar to show which image is currently being processed
    waitbar(k/num_images, h, sprintf('Processing image %d of %d', k, num_images));
    
    image_B = imread(image_path, k); % Read the kth frame
    
    % Perform an absolute difference between the two images
    subtracted_image = imadjust(im2gray(imabsdiff(image_B, image_A)));
    subtracted_image2 = im2gray(imabsdiff(image_B, imgaussfilt(image_A,2)));
    
    % Save the processed image to a multi-frame TIFF
    if k == 1
        imwrite(subtracted_image, output_file_path, 'Compression', 'none');
    else
        imwrite(subtracted_image, output_file_path, 'WriteMode', 'append', 'Compression', 'none');
    end
end

% Close the waitbar once processing is done
close(h);
