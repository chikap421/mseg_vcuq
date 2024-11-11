clc; clear; close all;

% Set the folder containing the .mat files
mat_folder = '/Users/mac/Dropbox (MIT)/RAW_DATA/First data from Florian/Thresholding';

% Set the output folder for the .tiff files
output_directory = '/Users/mac/Desktop/New New Latest/Composite tiffs/Thresholding';

% Create the output directory if it does not exist
if ~exist(output_directory, 'dir')
    mkdir(output_directory);
end

% Set the frame rate (frames per second)
frame_rate = 30;
frame_duration = 1 / frame_rate;

% Process each .mat file in the folder
for file_num = 1:21
    % Load the .mat file
    mat_file_path = fullfile(mat_folder, sprintf('21749_v2512_%d.mat', file_num));
    loaded_data = load(mat_file_path);

    % Assuming 'images' is a 3D matrix containing frames (height x width x num_frames) within the .mat file
    images = loaded_data.pir_Mat;
    num_frames = size(images, 3);

    % Specify the output .tiff file path
    output_file_path = fullfile(output_directory, sprintf('img_%d.tif', file_num));

    % Iterate through the frames, display each frame, and save them as a multi-page .tiff file
    for i = 1:num_frames
        % Normalize the image to the range [0, 1] and convert to uint8
        image = images(:,:,i);
        image = (image - min(image(:))) / (max(image(:)) - min(image(:)));
        image = im2uint8(image);

        % Save the frame to the .tiff file
        if i == 1
            imwrite(image, output_file_path, 'tif', 'Compression', 'none', 'WriteMode', 'overwrite');
        else
            imwrite(image, output_file_path, 'tif', 'Compression', 'none', 'WriteMode', 'append');
        end

        % Show progress
        fprintf('File %d of 21: Frame %d of %d saved.\n', file_num, i, num_frames);
    end
end