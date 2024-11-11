% define the image path
composite_tiff_path = '/Users/mac/Desktop/New New Latest/Composite tiffs/Camera/img_8.tif';

% Get info about the TIFF file to find out how many images it contains
info = imfinfo(composite_tiff_path);
num_images = numel(info);

% Define the output path
output_tiff_path = '/Users/mac/Desktop/New New Latest/Composite tiffs/Camera/Noramlized/img_8.tiff';

% Create directory if it doesn't exist
if ~exist(fileparts(output_tiff_path), 'dir')
   mkdir(fileparts(output_tiff_path));
end

% Loop over all images in the TIFF file
for idx = 1:num_images
    % Read in each individual image
    img = imread(composite_tiff_path, idx, 'Info', info);
    
    % Normalize the image
    img_normalized = normalize_image(img);

    % Write the normalized image to a new TIFF file
    if idx == 1
        imwrite(img_normalized, output_tiff_path);
    else
        imwrite(img_normalized, output_tiff_path, 'writemode', 'append');
    end
end

% Define the function to normalize the image
function img_normalized = normalize_image(img)
    img_min = double(min(img(:)));
    img_max = double(max(img(:)));
    img_normalized = (double(img) - img_min) / (img_max - img_min);
end
