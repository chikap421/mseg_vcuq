clear;clc;close all
% Folder where the images are located
folder = '/Users/mac/Desktop/New New Latest/Composite tiffs/Thresholding/';

% Folder where the plots should be saved
plot_folder = '/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/PDFS/Thresholding';

% Get a list of TIFF files in the folder
files = dir(fullfile(folder, 'img_*.tif'));

% Number of filesms
num_files = length(files);

% Define the number of bins for histograms
num_bins = 20; % You can change this to the desired number of bins


% Loop over each file
for i = 1:num_files
    % Get the full path to the file
    file = fullfile(folder, files(i).name);

    % Get information about the TIFF file
    info = imfinfo(file);

    % Number of images in the TIFF file
    num_images = numel(info);

    % Preallocate arrays to store results
    dry_area_fraction = zeros(num_images, 1);
    contact_line_density = zeros(num_images, 1);


    % Loop over each image in the tiff file
    for k = 1:num_images
        % Load the specific image from the tiff file
        binary_mask = imread(file, k, 'Info', info);

        % Calculate the total number of pixels in the image
        total_pixels = numel(binary_mask);

        % Calculate the number of wet pixels (zeros)
        wet_pixels = sum(binary_mask == 0, 'all');

        % Calculate the dry area fraction
        dry_area_fraction(k) = 100*(1-(wet_pixels / total_pixels));

        % Invert the binary mask
        inverted_binary_mask = ~binary_mask;

        % Calculate the Euclidean distance transform of the inverted mask
        dist = bwdist(inverted_binary_mask);

        % Set all distance values greater than 1 to 0
        dist(dist > 1) = 0;

        % Calculate the contact line length by counting the pixels in the dist image
        contact_line_length = sum(dist, 'all');

        % Calculate the contact line density (length per unit area)
        contact_line_density(k) = contact_line_length / total_pixels;

        % Length scale of the bubble 
        length_scale(k) = dry_area_fraction(k)/contact_line_density(k);

        % Display progress
        fprintf('Processed image %d of %d in file %s\n', k, num_images, files(i).name);
    end

    % Create and save the dry area fraction probability distribution plot
    figure;
    histogram(dry_area_fraction, num_bins, 'Normalization', 'probability');
    title('Probability Distribution of Dry Area Fraction');
    xlabel('Dry Area Fraction (%)');
    ylabel('Probability Density');
    print('-dtiff', '-r300', fullfile(plot_folder, sprintf('probability_dry_area_fraction_%s.tif', files(i).name)));

    % Create and save the contact line density probability distribution plot
    figure;
    histogram(contact_line_density, num_bins, 'Normalization', 'probability');
    title('Probability Distribution of Contact Line Density');
    xlabel('Contact Line Density (px/px^2)');
    ylabel('Probability Density');
    print('-dtiff', '-r300', fullfile(plot_folder, sprintf('probability_contact_line_density_%s.tif', files(i).name)));

    % Create and save the dry area fraction cumulative distribution plot
    figure;
    histogram(dry_area_fraction, num_bins, 'Normalization', 'cdf');
    title('Cumulative Distribution of Dry Area Fraction');
    xlabel('Dry Area Fraction (%)');
    ylabel('Cumulative Probability');
    print('-dtiff', '-r300', fullfile(plot_folder, sprintf('cdf_dry_area_fraction_%s.tif', files(i).name)));

    % Create and save the contact line density cumulative distribution plot
    figure;
    histogram(contact_line_density, num_bins, 'Normalization', 'cdf');
    title('Cumulative Distribution of Contact Line Density');
    xlabel('Contact Line Density (px/px^2)');
    ylabel('Cumulative Probability');
    print('-dtiff', '-r300', fullfile(plot_folder, sprintf('cdf_contact_line_density_%s.tif', files(i).name)));

    % Close the figures to save memory
    close all;
end
