clc; clear; close all;

% Define folders and settings
settings.segmentedFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Frames/LAr_Baseline';
settings.groundTruthFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/GroundTruths/LAr_Baseline';
settings.resultFolder = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Results/LAr_Baseline';
settings.fontSize = 14;

% Validate the number of files
validateFiles(settings);

% Extract global limits
[globalMinX, globalMaxX, globalMinY, globalMaxY] = getGlobalLimits(settings);

% Generate histograms and compute bubble numbers
[numBubblesSegmented, numBubblesGT, imageNames] = generateHistogramsAndComputeBubbles(settings, globalMinX, globalMaxX, globalMinY, globalMaxY);

% Plot bubble numbers
plotBubbleNumbers(numBubblesSegmented, numBubblesGT, imageNames);

% Supporting functions below
% -------------------------------------------------------------------------------

function validateFiles(settings)
    segmentedFiles = dir(fullfile(settings.segmentedFolder, '*.tif'));
    groundTruthFiles = dir(fullfile(settings.groundTruthFolder, '*.tif'));
    if length(segmentedFiles) ~= length(groundTruthFiles)
        error('The number of segmented images and ground truth images are not the same.');
    end
end

function [globalMinX, globalMaxX, globalMinY, globalMaxY] = getGlobalLimits(settings)
    segmentedFiles = dir(fullfile(settings.segmentedFolder, '*.tif'));
    
    globalMinX = inf;
    globalMaxX = -inf;
    globalMinY = inf;
    globalMaxY = -inf;

    for idx = 1:length(segmentedFiles)
        segmented = imbinarize(imread(fullfile(settings.segmentedFolder, segmentedFiles(idx).name)));
        groundtruth = imbinarize(imread(fullfile(settings.groundTruthFolder, segmentedFiles(idx).name)));
        
        [minX, maxX, maxY] = getLocalLimits(segmented, groundtruth);

        globalMinX = min(globalMinX, minX);
        globalMaxX = max(globalMaxX, maxX);
        globalMaxY = max(globalMaxY, maxY);
    end
    globalMinY = 1;
end

function [minX, maxX, maxY] = getLocalLimits(segmented, groundtruth)
    seg_areas = [regionprops(bwlabel(segmented), 'Area').Area];
    gt_areas = [regionprops(bwlabel(groundtruth), 'Area').Area];

    minX = min(log10([seg_areas, gt_areas]));
    maxX = max(log10([seg_areas, gt_areas]));
    maxY = max([histcounts(log10(seg_areas), 50), histcounts(log10(gt_areas), 50)]);
end

function [numBubblesSegmented, numBubblesGT, imageNames] = generateHistogramsAndComputeBubbles(settings, globalMinX, globalMaxX, globalMinY, globalMaxY)
    segmentedFiles = dir(fullfile(settings.segmentedFolder, '*.tif'));
    
    numBubblesSegmented = zeros(length(segmentedFiles), 1);
    numBubblesGT = zeros(length(segmentedFiles), 1);
    imageNames = cell(1, length(segmentedFiles));

    figure;
    sgtitle('Bubble Area Count Distributions');
    for idx = 1:length(segmentedFiles)
        imageName = segmentedFiles(idx).name;
        [~, nameOnly, ~] = fileparts(imageName);
        imageNames{idx} = nameOnly;

        segmented = imbinarize(imread(fullfile(settings.segmentedFolder, imageName)));
        groundtruth = imbinarize(imread(fullfile(settings.groundTruthFolder, imageName)));

        saveDifferenceImage(segmented, groundtruth, settings.resultFolder, nameOnly);

        plotHistograms(segmented, groundtruth, idx, nameOnly, settings, globalMinX, globalMaxX, globalMinY, globalMaxY);

        numBubblesSegmented(idx) = max(bwlabel(segmented, 4), [], 'all');
        numBubblesGT(idx) = max(bwlabel(groundtruth, 4), [], 'all');
    end
end

function saveDifferenceImage(segmented, groundtruth, resultFolder, nameOnly)
    difference = abs(double(segmented) - double(groundtruth));
    imwrite(difference, fullfile(resultFolder, ['difference_image_', nameOnly, '.tif']));
end

function plotHistograms(segmented, groundtruth, idx, nameOnly, settings, globalMinX, globalMaxX, globalMinY, globalMaxY)
    seg_areas = [regionprops(bwlabel(segmented), 'Area').Area];
    gt_areas = [regionprops(bwlabel(groundtruth), 'Area').Area];

    subplot(2, 3, idx);
    histogram(log10(seg_areas), 50, 'DisplayName', 'Segmented');
    hold on;
    histogram(log10(gt_areas), 50, 'DisplayName', 'Ground Truth');
    title(['Image ', nameOnly], 'FontSize', settings.fontSize, 'FontWeight', 'bold');
    xlabel('Log of Bubble Area (px^2)', 'FontSize', settings.fontSize, 'FontWeight', 'bold');
    ylabel('Count', 'FontSize', settings.fontSize, 'FontWeight', 'bold');
    legend('FontSize', settings.fontSize, 'FontWeight', 'bold');
    set(gca, 'FontSize', settings.fontSize);
    xlim([globalMinX globalMaxX]);
    ylim([globalMinY globalMaxY]);
    hold off;
end

function plotBubbleNumbers(numBubblesSegmented, numBubblesGT, imageNames)
    figure;
    bar(1:length(numBubblesSegmented), [numBubblesSegmented, numBubblesGT]);
    legend('Segmented', 'Ground Truth', 'Location', 'best');
    title('Number of Bubbles for Each Image');
    xlabel('Image Name');
    ylabel('Number of Bubbles');
    xticks(1:length(numBubblesSegmented));
    xticklabels(imageNames);
    xtickangle(45);
end
