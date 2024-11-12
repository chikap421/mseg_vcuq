clc; clear; close all

% Calculating the metrics
imagePaths = {...
    '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/FLORIAN DATASET 1/New New Latest/Ground Truths/3/img_3_1_new.tif', ...
    '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/FLORIAN DATASET 1/New New Latest/Ground Truths/3/img_3_1.tif'};
labels = {'New Output', 'Old Output'};
metrics = arrayfun(@(path) calculateMetrics(char(path)), imagePaths, 'UniformOutput', false);
metrics = [metrics{:}];

diffs = struct(...
    'dry_area_fraction', abs(metrics(1).dry_area_fraction - metrics(2).dry_area_fraction), ...
    'contact_line_density', abs(metrics(1).contact_line_density - metrics(2).contact_line_density));
rel_diffs = struct(...
    'dry_area_fraction', diffs.dry_area_fraction / mean([metrics.dry_area_fraction]) * 100, ...
    'contact_line_density', diffs.contact_line_density / mean([metrics.contact_line_density]) * 100);

% Creating the visuals
figure;

subplot(2,1,1);
createBarPlot(metrics(1).dry_area_fraction, metrics(2).dry_area_fraction, ...
              'Dry Area Fraction', 'Dry Area Fraction Comparison', ...
              diffs.dry_area_fraction, rel_diffs.dry_area_fraction, labels);

subplot(2,1,2);
createBarPlot(metrics(1).contact_line_density, metrics(2).contact_line_density, ...
              'Contact Line Density (pixels per pixel)', 'Contact Line Density Comparison', ...
              diffs.contact_line_density, rel_diffs.contact_line_density, labels);

% Function to calculate metrics
function metrics = calculateMetrics(imagePath)
    binary_mask = imread(imagePath);
    total_pixels = numel(binary_mask);
    wet_pixels = sum(binary_mask == 0, 'all');
    dry_area_fraction = 1 - (wet_pixels / total_pixels);
    inverted_binary_mask = ~binary_mask;
    dist = bwdist(inverted_binary_mask);
    dist(dist > 1) = 0;
    contact_line_length = sum(dist, 'all');
    contact_line_density = contact_line_length / total_pixels;
    metrics = struct('dry_area_fraction', dry_area_fraction, 'contact_line_density', contact_line_density);
end

% Function to create visuals
function createBarPlot(metric1, metric2, ylabelText, titleText, diffAbs, diffRel, labels)
    bar([metric1, metric2]);
    set(gca, 'XTickLabel', labels, 'LineWidth', 2, 'FontSize', 10, 'Box', 'on', 'GridLineStyle', '-', 'YGrid', 'on');
    ylabel(ylabelText, 'FontSize', 12);
    title(titleText, 'FontSize', 14);
    legend(sprintf('Abs Diff: %.4f, Rel Diff: %.2f%%', diffAbs, diffRel), 'FontSize', 9, 'Location', 'northwest');
end