% Batch Processing of Images from Two Folders, Plotting Side-by-Side Subplots, and Saving to TIFF Files
clc; clear; close all;
% Specify the file paths for the two folders
folder1_path = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Segmented_Florian/Selected Images/';
folder2_path = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Camera Images/Selected Images/';

% Get the file names and dates for the two folders
folder1_data = dir(fullfile(folder1_path, '*.jpg'));
folder2_data = dir(fullfile(folder2_path, '*.jpg'));

% Sort the files by date modified
folder1_dates = [folder1_data(:).datenum]';
[~, folder1_idx] = sort(folder1_dates);
folder1_data = folder1_data(folder1_idx);

folder2_dates = [folder2_data(:).datenum]';
[~, folder2_idx] = sort(folder2_dates);
folder2_data = folder2_data(folder2_idx);

% Choose the number of images to use in each batch
batch_size = 3;

% Get the total number of images in each folder
folder1_num_images = length(folder1_data);
folder2_num_images = length(folder2_data);

% Specify the folder path to save the TIFF files
save_folder_path = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Camera and Florian';

% Loop over the images in each folder in batches of batch_size
folder1_batch_idx = 1;
folder2_batch_idx = 1;
while folder1_batch_idx <= folder1_num_images || folder2_batch_idx <= folder2_num_images
    % Get the images for the current batch from folder 1
    folder1_images = {};
    for i = folder1_batch_idx:min(folder1_batch_idx+batch_size-1, folder1_num_images)
        folder1_images{i-folder1_batch_idx+1} = imread(fullfile(folder1_path, folder1_data(i).name));
    end
    
    % Get the images for the current batch from folder 2
    folder2_images = {};
    for i = folder2_batch_idx:min(folder2_batch_idx+batch_size-1, folder2_num_images)
        folder2_images{i-folder2_batch_idx+1} = imread(fullfile(folder2_path, folder2_data(i).name));
    end
    
    % Plot the images for the current batch
    fig = figure;
    for i = 1:length(folder1_images)
        subplot(2, length(folder1_images), i);
        imshow(folder1_images{i});
        title(sprintf('Florian, image %d', folder1_batch_idx+i-1));
        
        subplot(2, length(folder1_images), length(folder1_images)+i);
        imshow(folder2_images{i});
        title(sprintf('Camera, image %d', folder2_batch_idx+i-1));
    end
    
    % Save the subplots for the current batch to TIFF files
    saveas(fig, fullfile(save_folder_path, sprintf('batch_%d.tif', floor((folder1_batch_idx-1)/batch_size+1))), 'tiffn');
    
    % Close the figure
    close(fig);
    
    % Update the batch indices for each folder
    folder1_batch_idx = folder1_batch_idx + batch_size;
    folder2_batch_idx = folder2_batch_idx + batch_size;
end
