% Display and Save Multiple Images in MATLAB

% This code reads in a series of JPEG images from a folder, displays them in a single figure using subplots, and then saves the figure as a TIFF image with 800 DPI resolution.
% 
% First, the code specifies the folder path and file extension for the images using the folder and file_extension variables.
% 
% The code then uses the dir function to obtain a list of all the image files in the folder that match the specified file extension. It calculates the number of rows and columns needed for the subplots based on the number of images, using the ceil function to ensure that there are enough subplots to display all the images.
% 
% Next, the code creates a new figure and loops through each image file. For each image file, it constructs the full file path, reads in the image using the imread function, creates a new subplot using the subplot function, and displays the image using the imshow function. The subplot position is also adjusted to make the image larger using the set function.
% 
% After all the images have been displayed in subplots, the code sets the paper size and DPI of the figure using the set function. It then saves the figure as a TIFF image with 800 DPI resolution using the print function.
% 
% Overall, this code can be useful for visualizing a series of images in a single figure and saving them in a high-quality format for later use or publication.
clc; clear; close all

% Define folder path and file extension
folder = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Segmented_Florian/Selected Images/';
file_extension = '*.jpg';

% Get list of all image files in folder and sort based on date modified
image_files = dir(fullfile(folder, file_extension));
[~, sort_idx] = sort([image_files.datenum]);
image_files = image_files(sort_idx);

% Calculate the number of rows and columns needed for the subplots
num_images = numel(image_files);
num_rows = ceil(sqrt(num_images));
num_cols = ceil(num_images / num_rows);

% Create a figure and loop through each image file
figure;
for i = 1:num_images
    % Construct the full file path
    file_path = fullfile(folder, image_files(i).name);
    
    % Read in the image
    img = imread(file_path);
    
    % Create a subplot and display the image
    subplot(num_rows, num_cols, i);
    imshow(img);
    title(sprintf('Image %d', i));
    
    % Resize the subplot to make the image larger
    set(gca, 'Position', get(gca, 'Position') + [0.01 0.01 -0.02 -0.02]);
end

% Set the figure paper size and DPI
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 8 8], 'PaperPositionMode', 'manual');
set(gcf, 'Renderer', 'Painters');
set(gcf, 'InvertHardcopy', 'off');

% Save the figure as a TIFF image with 800 DPI resolution
print(gcf, '-dtiff', '-r800', 'my_images.tif');
