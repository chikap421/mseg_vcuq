% Extracting Bubble Dynamic Parameters from Binary Segmented Images and Visualizing the Results in MATLAB

% Specify the folder containing the binary segmented images
folder = '/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Segmentation results/New Results/Segmentation scores/';

% Get a list of all the binary segmented images in the folder
file_list = dir(fullfile(folder, '*.tif'));

% Initialize arrays to store the calculated parameters
nsd_values = [];
ftg_values = [];
r_values = [];

% Loop through each image in the folder
for i = 1:numel(file_list)
    
    % Load the binary segmented image
    filename = fullfile(folder, file_list(i).name);
    I = imread(filename);

    % Convert the binary image to a label matrix
    L = bwlabeln(I, 6);

    % Get the number of bubbles and their properties
    S = regionprops3(L, 'Volume', 'Centroid', 'PrincipalAxisLength');

    % Calculate the NSD
    radii = 0.5*S.PrincipalAxisLength(:,1);
    mean_radius = mean(radii);
    nsd = std(radii)/mean_radius;

    % Calculate the f.tg
    surface_tension = 0.072;  % N/m (example value)
    diffusion_coefficient = 2.5e-9;  % m^2/s (example value)
    ftg = surface_tension./(diffusion_coefficient.*radii.^2);

    % Calculate the bubble radius
    R = mean(radii);

    % Store the calculated parameters in the arrays
    nsd_values = [nsd_values; nsd];
    ftg_values = [ftg_values; mean(ftg)];
    r_values = [r_values; R];
end

% Plot the NSD values
subplot(3,1,1)
bar(nsd_values)
title('Normalized Standard Deviation (NSD)')
xlabel('Image number')
ylabel('NSD')

% Plot the f.tg values
subplot(3,1,2)
bar(ftg_values)
title('f.tg')
xlabel('Image number')
ylabel('f.tg')

% Plot the bubble radius values
subplot(3,1,3)
bar(r_values)
title('Bubble Radius (R)')
xlabel('Image number')
ylabel('Radius (m)')

% Save the plots as PNG files
saveas(gcf, 'subplot.png')