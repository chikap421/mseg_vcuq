clc; clear; close all

% Add the export_fig package to your path (if not already added)
addpath('C:\Users\dell g3\Dropbox (MIT)\RAW_DATA\First data from Florian\Camera Images\export_fig');

% Camera Images
k_values = 19;
i_values = 1;
for k = k_values
    mat_file = fullfile('C:\Users\dell g3\Dropbox (MIT)\RAW_DATA\First data from Florian\Camera Images', ['pre_21749_v2512_' num2str(k) '.mat']);
    load(mat_file);
    for i = i_values
        save_image(img_preTEST(:,:,i), k, i);
    end
end
%%

% Thresholding Images
k_values = 16;
i_values = 1901;
for k = k_values
    mat_file = fullfile('C:\Users\dell g3\Dropbox (MIT)\RAW_DATA\First data from Florian\Thresholding_Old', ['21749_v2512_' num2str(k) '.mat']);
    load(mat_file);
    for i = i_values
        save_image(pir_Mat(:,:,i), k, i);
    end
end
%%

% Function to process and save images
function save_image(image_data, k, i)
    % Create a new figure and set it to be invisible
    fig = figure('visible', 'off');

    % Display the image
    imagesc(image_data);

    % Set the colormap
    colormap(parula);

    % Set axis properties
    axis equal;
    axis off;

    % Save the figure
    path = fullfile('C:\Users\dell g3\OneDrive\New folder', ['img_' num2str(k) '_' num2str(i) '.tiff']);
    export_fig(path); % Save as high-resolution TIFF file

    % Close the invisible figure
%     close(fig);

    pause(0.01);
end