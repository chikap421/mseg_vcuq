clear; close all; clc;

% Read the background image (A)
image_A = imread('/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/OLD/Chika/Big data/Camera Images/img_1_1.jpg');

% List of image_B names
image_B_names = {'img_9_1.tif', 'img_9_1901.tif', 'img_8_1.tif', 'img_8_1901.tif'};

% Loop through each image_B name
for i = 1:length(image_B_names)
    
    % Read the current image_B
    image_B_path = fullfile('/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/High Resolution Images/Camera Images', image_B_names{i});
    image_B = imread(image_B_path);
    
    % Resize image_B to match the dimensions of image_A
    image_B_resized = imresize(image_B, [size(image_A, 1), size(image_A, 2)]);
    
    % Perform an absolute difference between the two images
    subtracted_image = imadjust(im2gray(imabsdiff(image_B_resized, image_A)));
    subtracted_image2 = im2gray(imabsdiff(image_B_resized, imgaussfilt(image_A,2)));
    
    % Display the subtracted images
    figure; imshow(imcomplement(subtracted_image)); title(['Image ', num2str(i), ' (imcomplement)']);
    figure; imshow(imadjust(im2gray(subtracted_image2))); title(['Image ', num2str(i), ' (imadjust)']);
    
    % Programmatically crop the subtracted image
    crop_size = [343, 344]; % Size [height, width]
    crop_position = [1, 1]; % Starting position [x, y]
    cropped_image = imcrop(subtracted_image, [crop_position, crop_size]);
    
    % Display the cropped image
    figure; imshow(cropped_image); title(['Cropped Image ', num2str(i)]);
    
    % Save the cropped image
    [~, image_B_name, ~] = fileparts(image_B_names{i});
    output_path = fullfile('/Users/mac/Desktop/Validation Study/User Ground Truth', [image_B_name, '_cropped.tif']);
    imwrite(cropped_image, output_path);
end
