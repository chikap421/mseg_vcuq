%% Extract Dry Area Fraction and Contact Line Density from Multi-frame TIFFs
clc; clear;

% Add path to the function
addpath('/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/Image analysis/Scripts and Macros/Chika scripts/Marco/');

% Paths to the segmented and binary videos
segmentedVideoPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Video/FC72_500_Frames.tif';
binaryVideoPath = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Binarization/NB/TIFF/FC72_500_Frames.tif';

% Get size of the segmented images to resize all frames to this size
infoSegmented = imfinfo(segmentedVideoPath);
referenceSize = [infoSegmented(1).Height, infoSegmented(1).Width];

% Process segmented video
[segmented_dry_area_fraction, segmented_contact_line_density] = processMultiFrameTiff(segmentedVideoPath, referenceSize);

% Process binary video
[binary_dry_area_fraction, binary_contact_line_density] = processMultiFrameTiff(binaryVideoPath, referenceSize);

%% Visualization for Segmented vs. Binary

% Set output folder path
outputFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Results/FC72/VISUALIZATIONS';

% Number of frames
numFrames = length(segmented_dry_area_fraction);

%%
% Compute the range for dry area fraction and contact line density
min_dry_area = min([min(segmented_dry_area_fraction), min(binary_dry_area_fraction)]);
max_dry_area = max([max(segmented_dry_area_fraction), max(binary_dry_area_fraction)]);
min_contact_line_density = min([min(segmented_contact_line_density), min(binary_contact_line_density)]);
max_contact_line_density = max([max(segmented_contact_line_density), max(binary_contact_line_density)]);

% Compute the maximum frequency for dry area fraction and contact line density
[~,edges] = histcounts([segmented_dry_area_fraction; binary_dry_area_fraction]);
max_freq_dry_area = max([histcounts(segmented_dry_area_fraction, edges), histcounts(binary_dry_area_fraction, edges)]);

[~,edges] = histcounts([segmented_contact_line_density; binary_contact_line_density]);
max_freq_contact_line_density = max([histcounts(segmented_contact_line_density, edges), histcounts(binary_contact_line_density, edges)]);

% Histogram plots with four separate subplots
figure;

% Segmented Dry Area Fraction
subplot(2,2,1);
histogram(segmented_dry_area_fraction, 'FaceColor', 'b');
title('Segmented Dry Area Fraction');
xlabel('Dry Area Fraction');
ylabel('Frequency');
grid on;
xlim([min_dry_area, max_dry_area]); % Set x-axis limits
ylim([0, max_freq_dry_area]); % Set y-axis limits

% Binary Dry Area Fraction
subplot(2,2,2);
histogram(binary_dry_area_fraction, 'FaceColor', 'r');
title('Binary Dry Area Fraction');
xlabel('Dry Area Fraction');
ylabel('Frequency');
grid on;
xlim([min_dry_area, max_dry_area]); % Set x-axis limits
ylim([0, max_freq_dry_area]); % Set y-axis limits

% Segmented Contact Line Density
subplot(2,2,3);
histogram(segmented_contact_line_density, 'FaceColor', 'b');
title('Segmented Contact Line Density');
xlabel('Contact Line Density');
ylabel('Frequency');
grid on;
xlim([min_contact_line_density, max_contact_line_density]); % Set x-axis limits
ylim([0, max_freq_contact_line_density]); % Set y-axis limits

% Binary Contact Line Density
subplot(2,2,4);
histogram(binary_contact_line_density, 'FaceColor', 'r');
title('Binary Contact Line Density');
xlabel('Contact Line Density');
ylabel('Frequency');
grid on;
xlim([min_contact_line_density, max_contact_line_density]); % Set x-axis limits
ylim([0, max_freq_contact_line_density]); % Set y-axis limits

% Optionally save the figure to a file
% saveas(gcf, fullfile(outputFolder, 'SeparateHistogramPlots.png'));
% close all;


%%
% Determine the overall range for dry area fraction
min_dry_area = min([min(segmented_dry_area_fraction), min(binary_dry_area_fraction)]);
max_dry_area = max([max(segmented_dry_area_fraction), max(binary_dry_area_fraction)]);

% Calculate the maximum y-value (probability density) for both PDFs to ensure the same y-axis limits
max_pdf_segmented = max(histcounts(segmented_dry_area_fraction, 'Normalization', 'pdf'));
max_pdf_binary = max(histcounts(binary_dry_area_fraction, 'Normalization', 'pdf'));
max_pdf_limit = max(max_pdf_segmented, max_pdf_binary);

% Histogram with PDF and CDF for Dry Area Fraction
figure;

% PDF for Segmented Dry Area Fraction
subplot(2,2,1);
histogram(segmented_dry_area_fraction, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'b');
title('PDF of Segmented Dry Area Fraction');
xlabel('Dry Area Fraction');
ylabel('Probability Density');
legend('Segmented', 'Location','best');
grid on;
xlim([min_dry_area, max_dry_area]);
ylim([0, max_pdf_limit]);

% PDF for Binary Dry Area Fraction
subplot(2,2,2);
histogram(binary_dry_area_fraction, 'Normalization', 'pdf', 'FaceColor', 'r', 'EdgeColor', 'r');
title('PDF of Binary Dry Area Fraction');
xlabel('Dry Area Fraction');
ylabel('Probability Density');
legend('Binary', 'Location','best');
grid on;
xlim([min_dry_area, max_dry_area]);
ylim([0, max_pdf_limit]);

% CDF for Segmented Dry Area Fraction
subplot(2,2,3);
histogram(segmented_dry_area_fraction, 'Normalization', 'cdf', 'FaceColor', 'b', 'EdgeColor', 'b');
title('CDF of Segmented Dry Area Fraction');
xlabel('Dry Area Fraction');
ylabel('Cumulative Probability');
legend('Segmented', 'Location','best');
grid on;
xlim([min_dry_area, max_dry_area]);
ylim([0, 1]);

% CDF for Binary Dry Area Fraction
subplot(2,2,4);
histogram(binary_dry_area_fraction, 'Normalization', 'cdf', 'FaceColor', 'r', 'EdgeColor', 'r');
title('CDF of Binary Dry Area Fraction');
xlabel('Dry Area Fraction');
ylabel('Cumulative Probability');
legend('Binary', 'Location','best');
grid on;
xlim([min_dry_area, max_dry_area]);
ylim([0, 1]);
% Optionally save the figure to a file
% saveas(gcf, fullfile(outputFolder, 'PDF_CDF_DryAreaFraction.png'));
% close all;
%%
% Calculate maximum y-value for PDFs of contact line density to ensure same y-axis limits
maxPDFValue_segmented = max(histcounts(segmented_contact_line_density, 'Normalization', 'pdf'));
maxPDFValue_binary = max(histcounts(binary_contact_line_density, 'Normalization', 'pdf'));
maxPDFValue = max(maxPDFValue_segmented, maxPDFValue_binary);

% Determine the overall range for contact line density
min_contact_line_density = min([min(segmented_contact_line_density), min(binary_contact_line_density)]);
max_contact_line_density = max([max(segmented_contact_line_density), max(binary_contact_line_density)]);

% Histogram with PDF and CDF for Contact Line Density
figure;

% PDF for Segmented Contact Line Density
subplot(2,2,1);
histogram(segmented_contact_line_density, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'b');
title('PDF of Segmented Contact Line Density');
xlabel('Contact Line Density');
ylabel('Probability Density');
legend('Segmented', 'Location','best');
grid on;
xlim([min_contact_line_density, max_contact_line_density]);
ylim([0, maxPDFValue]); % Set the same y-axis limits

% PDF for Binary Contact Line Density
subplot(2,2,2);
histogram(binary_contact_line_density, 'Normalization', 'pdf', 'FaceColor', 'r', 'EdgeColor', 'r');
title('PDF of Binary Contact Line Density');
xlabel('Contact Line Density');
ylabel('Probability Density');
legend('Binary', 'Location','best');
grid on;
xlim([min_contact_line_density, max_contact_line_density]);
ylim([0, maxPDFValue]); % Set the same y-axis limits

% CDF for Segmented Contact Line Density
subplot(2,2,3);
histogram(segmented_contact_line_density, 'Normalization', 'cdf', 'FaceColor', 'b', 'EdgeColor', 'b');
title('CDF of Segmented Contact Line Density');
xlabel('Contact Line Density');
ylabel('Cumulative Probability');
legend('Segmented', 'Location','best');
grid on;
xlim([min_contact_line_density, max_contact_line_density]);

% CDF for Binary Contact Line Density
subplot(2,2,4);
histogram(binary_contact_line_density, 'Normalization', 'cdf', 'FaceColor', 'r', 'EdgeColor', 'r');
title('CDF of Binary Contact Line Density');
xlabel('Contact Line Density');
ylabel('Cumulative Probability');
legend('Binary', 'Location','best');
grid on;
xlim([min_contact_line_density, max_contact_line_density]);

% Optionally save the figure to a file
% saveas(gcf, fullfile(outputFolder, 'PDF_CDF_ContactLineDensity.png'));
% close all;

%% Box plots
figure;

% Calculate common y-axis limits for dry area fraction
dryAreaFractionLimits = [
    min([segmented_dry_area_fraction; binary_dry_area_fraction]),
    max([segmented_dry_area_fraction; binary_dry_area_fraction])
];

% Calculate common y-axis limits for contact line density
contactLineDensityLimits = [
    min([segmented_contact_line_density; binary_contact_line_density]),
    max([segmented_contact_line_density; binary_contact_line_density])
];

% Boxplot for Segmented Dry Area Fraction
subplot(2,2,1);
boxplot(segmented_dry_area_fraction, 'Labels', {'Segmented'});
title('Boxplot of Segmented Dry Area Fraction');
ylim(dryAreaFractionLimits); % Set the common y-axis limits

% Boxplot for Binary Dry Area Fraction
subplot(2,2,2);
boxplot(binary_dry_area_fraction, 'Labels', {'Binary'});
title('Boxplot of Binary Dry Area Fraction');
ylim(dryAreaFractionLimits); % Set the common y-axis limits

% Boxplot for Segmented Contact Line Density
subplot(2,2,3);
boxplot(segmented_contact_line_density, 'Labels', {'Segmented'});
title('Boxplot of Segmented Contact Line Density');
ylim(contactLineDensityLimits); % Set the common y-axis limits

% Boxplot for Binary Contact Line Density
subplot(2,2,4);
boxplot(binary_contact_line_density, 'Labels', {'Binary'});
title('Boxplot of Binary Contact Line Density');
ylim(contactLineDensityLimits); % Set the common y-axis limits


% Optionally save the figure to a file
% saveas(gcf, fullfile(outputFolder, 'Separate_BoxPlots.png'));
% close all;
