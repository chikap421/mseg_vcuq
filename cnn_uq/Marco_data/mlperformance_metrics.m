% Initialization and directory definition
clc; clear;

BASE_PATH = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject';
SEGMENTED_DIR = fullfile(BASE_PATH, 'Segmentation/Frames/FC72');
GROUND_TRUTH_DIR = fullfile(BASE_PATH, 'GroundTruths/FC72');

% Process images and compute metrics
[metrics, imageNames] = processImages(SEGMENTED_DIR, GROUND_TRUTH_DIR);

% Plot metrics using bar plots
plotBarMetrics(imageNames, metrics);

% Plot metrics using line plots
plotLineMetrics(imageNames, metrics);

% Compute average metrics
avgMetrics = computeAverageMetrics(metrics);

% Plot average metrics using bar plots
plotAverageMetricsBar(avgMetrics);

% Plot average metrics using Line/Scatter plots
plotAverageMetricsLine(avgMetrics);

% --- Local Functions ---

function [metrics, imageNames] = processImages(segmentedDir, groundTruthDir)
    segmentedFiles = dir(fullfile(segmentedDir, '*.tif'));

    % Initialize metrics to store results
    metrics.accuracy = zeros(1, length(segmentedFiles));
    metrics.precision = zeros(1, length(segmentedFiles));
    metrics.recall = zeros(1, length(segmentedFiles));
    metrics.f1Score = zeros(1, length(segmentedFiles));
    metrics.iou = zeros(1, length(segmentedFiles));
    metrics.mcc = zeros(1, length(segmentedFiles));

    % For image names
    imageNames = strings(1, length(segmentedFiles));

    for fileIdx = 1:length(segmentedFiles)
        [~, baseFilename, ~] = fileparts(segmentedFiles(fileIdx).name);
        imageNames(fileIdx) = baseFilename;

        segmentedImagePath = fullfile(segmentedDir, [baseFilename, '.tif']);
        groundTruthPath = fullfile(groundTruthDir, [baseFilename, '.tif']);

        segmentedImage = imbinarize(imread(segmentedImagePath));
        groundTruthImage = imbinarize(imread(groundTruthPath));

        [confMatrix, accuracy, precision, recall, f1Score, iou, mcc] = computeMetrics(segmentedImage, groundTruthImage);

        % Store computed metrics
        metrics.accuracy(fileIdx) = accuracy;
        metrics.precision(fileIdx) = precision;
        metrics.recall(fileIdx) = recall;
        metrics.f1Score(fileIdx) = f1Score;
        metrics.iou(fileIdx) = iou;
        metrics.mcc(fileIdx) = mcc;

        printMetrics(baseFilename, confMatrix, accuracy, precision, recall, f1Score, iou, mcc);
    end
end

function printMetrics(baseFilename, confMatrix, accuracy, precision, recall, f1Score, iou, mcc)
    fprintf('\nMetrics for Image: %s\n', baseFilename);
    fprintf('----------------------------------\n');
    fprintf('Confusion Matrix:\n');
    disp(confMatrix);
    fprintf('Accuracy: %f\nPrecision: %f\nRecall: %f\nF1 Score: %f\nIoU: %f\nMCC: %f\n', accuracy, precision, recall, f1Score, iou, mcc);
end

function plotBarMetrics(imageNames, metrics)
    figure;
    metricFields = fields(metrics);
    
    for i = 1:numel(metricFields)
        subplot(2, 3, i);
        bar(categorical(imageNames), metrics.(metricFields{i}));
        title(metricFields{i});
        xlabel('Image Name');
        ylabel(metricFields{i});
        grid on;
    end
    
    sgtitle('Performance Metrics for Different Images');
end

function plotLineMetrics(imageNames, metrics)
    figure;
    hold on;
    metricFields = fields(metrics);
    
    for i = 1:numel(metricFields)
        plot(categorical(imageNames), metrics.(metricFields{i}), '-o', 'DisplayName', metricFields{i});
    end
    
    title('Performance Metrics for Different Images');
    xlabel('Image Name');
    ylabel('Metric Value');
    legend('Location', 'best');
    grid on;
    hold off;
end

function avgMetrics = computeAverageMetrics(metrics)
    metricFields = fields(metrics);
    for i = 1:numel(metricFields)
        avgMetrics.(metricFields{i}) = mean(metrics.(metricFields{i}));
    end
end

function plotAverageMetricsBar(avgMetrics)
    metricNames = fields(avgMetrics);
    avgValues = zeros(1, numel(metricNames));
    
    for i = 1:numel(metricNames)
        avgValues(i) = avgMetrics.(metricNames{i});
    end
    
    figure;
    bar(categorical(metricNames), avgValues);
    title('Average Performance Metrics Across All Images (Bar Plot)');
    xlabel('Metric Name');
    ylabel('Average Value');
    grid on;
end

function plotAverageMetricsLine(avgMetrics)
    metricNames = fields(avgMetrics);
    avgValues = zeros(1, numel(metricNames));
    
    for i = 1:numel(metricNames)
        avgValues(i) = avgMetrics.(metricNames{i});
    end
    
    figure;
    plot(categorical(metricNames), avgValues, 's', 'Color', 'b', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    title('Average Performance Metrics Across All Images (Scatter Plot)');
    xlabel('Metric Name');
    ylabel('Average Value');
    grid on;
end
