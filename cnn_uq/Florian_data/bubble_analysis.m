% Assuming your binary mask is stored in a variable called 'binary_mask'
% Where 1 represents the dry (bubble) region and 0 represents the liquid region

% Read the binary mask
binary_mask = imread("/Users/mac/Desktop/New New Latest/Segmentation/img_16_1.tif");

% Calculate the total number of pixels in the image
total_pixels = numel(binary_mask);

% Calculate the number of dry pixels (ones)
dry_pixels = sum(binary_mask == 1, 'all');

% Calculate the dry area fraction
dry_area_fraction = dry_pixels / total_pixels;

% Invert the binary mask
inverted_binary_mask = ~binary_mask;

% Calculate the Euclicdean distance transform of the inverted mask
dist = bwdist(inverted_binary_mask);

% Set all distance values greater than 1 to 0
dist(dist > 1) = 0;

% Calculate the contact line length by counting the pixels in the dist image
contact_line_length = sum(dist, 'all');

% Calculate the contact line density (length per unit area)
contact_line_density = contact_line_length / total_pixels;

%  Length  scale of the bubble 
scale = dry_area_fraction/contact_line_density;

% Display the results
fprintf('Dry area fraction: %.4f\n', dry_area_fraction);
fprintf('Contact line density: %.4f\n', contact_line_density);
fprintf('Length scale of the bubble: %.4f\n', scale);
