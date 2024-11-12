function bubblemetrics()
    clc; close all; clear;
    segmentationDir = '/Users/chikamaduabuchi/Documents/paul/segmentation1';
    groundTruthDir = '/Users/chikamaduabuchi/Documents/paul/groundtruth';
    [metricsArray, imageFileNames] = calculateAllMetrics(segmentationDir, groundTruthDir);
    plotMetricsArray(metricsArray, imageFileNames);
    T = calculateAndDisplayErrors(metricsArray, imageFileNames);
    plotErrorAnalysis(T, {'Dry_Area', 'Contact_Line'});
    calculateStatisticalErrorAnalysis(T);
    visualizeBubblePerimeters()
end

function [metricsArray, imageFileNames] = calculateAllMetrics(segmentationDir, groundTruthDir)
    segFiles = dir(fullfile(segmentationDir, '*.tif'));
    numFiles = length(segFiles);
    metricsArray = repmat(struct('segmented', [], 'groundTruth', []), numFiles, 1);
    imageFileNames = strings(numFiles, 1);

    for i = 1:numFiles
        imageFileNames(i) = segFiles(i).name; 
        segImagePath = fullfile(segmentationDir, segFiles(i).name);
        gtImagePath = fullfile(groundTruthDir, segFiles(i).name);

        segBinaryMask = imbinarize(imread(segImagePath));
        gtBinaryMask = imbinarize(imread(gtImagePath));

        segMetrics = calculateDryAreaAndContactLine(segBinaryMask);
        gtMetrics = calculateDryAreaAndContactLine(gtBinaryMask);

        metricsArray(i).segmented = segMetrics;
        metricsArray(i).groundTruth = gtMetrics;
    end
end

function metrics = calculateDryAreaAndContactLine(binaryMask)
    totalPixels = numel(binaryMask);
    wetPixels = sum(binaryMask == 0, 'all');
    dryAreaFraction = 1 - (wetPixels / totalPixels);

    invertedBinaryMask = ~binaryMask;
    dist = bwdist(invertedBinaryMask);
    contactLineLength = sum(dist == 1, 'all');
    contactLineDensity = contactLineLength / totalPixels;

    metrics = struct('dry_area_fraction', dryAreaFraction, 'contact_line_density', contactLineDensity);
end


function plotMetricsArray(metricsArray, imageFileNames)
    numMetrics = 2;
    numFiles = length(metricsArray);
    metricLabels = {'Dry Area Fraction', 'Contact Line Density'};
    metricsData = zeros(numFiles, numMetrics, 2);
    imageNames = strings(numFiles, 1);

    for i = 1:numFiles
        imageNames(i) = erase(erase(imageFileNames(i), "Img"), ".tif");
        metricsData(i, 1, 1) = metricsArray(i).segmented.dry_area_fraction;
        metricsData(i, 1, 2) = metricsArray(i).groundTruth.dry_area_fraction;
        metricsData(i, 2, 1) = metricsArray(i).segmented.contact_line_density;
        metricsData(i, 2, 2) = metricsArray(i).groundTruth.contact_line_density;
    end

    figure;
    for i = 1:numMetrics
        subplot(numMetrics, 1, i);
        hold on;
        box on;
        set(gca, 'LineWidth', 2);
        bar(squeeze(metricsData(:, i, :)), 'grouped');
        set(gca, 'xticklabel', imageNames, 'XTick', 1:numFiles);
        xlabel('Image Name');
        
        if strcmp(metricLabels{i}, 'Contact Line Density')
            ylabel([metricLabels{i} ' (px/px^2)'], 'FontSize', 14, 'FontWeight', 'bold');
        else
            ylabel(metricLabels{i}, 'FontSize', 14, 'FontWeight', 'bold');
        end
        
        if i == 1
            legend('Segmented', 'Ground Truth', 'Location', 'best');
        end
        grid on;
        set(gca, 'FontSize', 14, 'FontWeight', 'bold');
        set(gca, 'GridLineStyle', '-', 'GridColor', 'k', 'GridAlpha', 0.3); 
        set(gca, 'MinorGridLineStyle', ':', 'MinorGridColor', 'k', 'MinorGridAlpha', 0.05);
        ax = gca;
        ax.XAxis.MinorTick = 'on';
        ax.YAxis.MinorTick = 'on';
        ax.XMinorGrid = 'on';
        ax.YMinorGrid = 'on';
        hold off;
    end
end


function T = calculateAndDisplayErrors(metricsArray, imageFileNames)
    numFiles = length(metricsArray);
    
    dryAreaError = zeros(numFiles, 1);
    dryAreaPercError = zeros(numFiles, 1);
    contactLineError = zeros(numFiles, 1);
    contactLinePercError = zeros(numFiles, 1);
    
    for i = 1:numFiles
        dryAreaError(i) = metricsArray(i).segmented.dry_area_fraction - metricsArray(i).groundTruth.dry_area_fraction;
        dryAreaPercError(i) = (dryAreaError(i) / metricsArray(i).groundTruth.dry_area_fraction) * 100;
        
        contactLineError(i) = metricsArray(i).segmented.contact_line_density - metricsArray(i).groundTruth.contact_line_density;
        contactLinePercError(i) = (contactLineError(i) / metricsArray(i).groundTruth.contact_line_density) * 100;
    end
    
    processedImageNames = erase(erase(imageFileNames, "Img"), ".tif");
    
    T = table(processedImageNames, dryAreaError, dryAreaPercError, contactLineError, contactLinePercError, ...
        'VariableNames', {'Image_Name', 'Dry_Area_Error', 'Dry_Area_Perc_Error', 'Contact_Line_Error', 'Contact_Line_Perc_Error'});
    
    writetable(T, 'error_analysis.xlsx')

    disp(T);
end

function plotErrorAnalysis(T, metricNames)
    numMetrics = numel(metricNames);
    absoluteErrorColor = [0, 0, 0];
    percentageErrorColor = [1, 0, 0];
    figure('Name', 'Error Analysis', 'NumberTitle', 'off');
    
    for i = 1:numMetrics
        metricLabel = metricNames{i};
        absErrorName = [metricLabel, '_Error'];
        percErrorName = [metricLabel, '_Perc_Error'];
        
        subplot(numMetrics, 1, i);
        
        yyaxis left;
        plot(1:height(T), T.(absErrorName), 's', 'Color', absoluteErrorColor, 'MarkerFaceColor', absoluteErrorColor, 'LineWidth', 2, 'MarkerSize', 8);
        set(gca, 'YMinorTick', 'on');
        if strcmp(metricLabel, 'Contact_Line')
            ylabel('Error (px/px^2)', 'FontWeight', 'bold');
        else
            ylabel('Error', 'FontWeight', 'bold');
        end
        set(gca, 'YColor', [0.15, 0.15, 0.15], 'LineWidth', 2, 'FontWeight', 'bold', 'FontSize', 12);

        yyaxis right;
        plot(1:height(T), T.(percErrorName), 'o', 'Color', percentageErrorColor, 'MarkerFaceColor', percentageErrorColor, 'LineWidth', 2, 'MarkerSize', 8);
        ylabel('Percentage Error (%)', 'FontWeight', 'bold');
        set(gca, 'YColor', percentageErrorColor, 'LineWidth', 2, 'FontWeight', 'bold', 'FontSize', 12);

        title([strrep(metricLabel, '_', ' '), ' Error Analysis'], 'FontWeight', 'bold', 'FontSize', 14);
        xlabel('Image Name', 'FontWeight', 'bold');
        xticks(1:height(T));
        xticklabels(T.Image_Name);
        xtickangle(45);
        grid on;

        ax = gca;
        ax.GridLineStyle = '-';
        ax.GridAlpha = 0.5;
        ax.MinorGridLineStyle = ':';
        ax.MinorGridColor = [0.8, 0.8, 0.8];
        ax.MinorGridAlpha = 0.4;
        ax.XMinorGrid = 'on';
        ax.YMinorGrid = 'on';
        
        axis tight; set(gca, 'XTickMode', 'auto', 'XMinorTick', 'on', 'YTickMode', 'auto', 'YMinorTick', 'on');
        set(gca, 'FontWeight', 'bold', 'FontSize', 12);
        box on;
        
        if i == 1
            legend({'Absolute Error', 'Percentage Error'}, 'Location', 'best', 'FontWeight', 'bold');
        end
    end
end

function calculateStatisticalErrorAnalysis(T)
    statsFields = {'Dry_Area_Error', 'Dry_Area_Perc_Error', 'Contact_Line_Error', 'Contact_Line_Perc_Error'};
    statNames = {'Mean', 'Standard Deviation', 'Minimum', 'Maximum'};
    statsData = zeros(length(statsFields), 4);
    for i = 1:length(statsFields)
        data = T.(statsFields{i});
        statsData(i, 1) = mean(data);
        statsData(i, 2) = std(data);
        statsData(i, 3) = min(data);
        statsData(i, 4) = max(data);
    end
    statsTable = array2table(statsData, 'VariableNames', statNames, 'RowNames', statsFields);
    disp('Statistical Analysis of Errors:');
    disp(statsTable);
    writetable(statsTable, 'StatisticalErrorAnalysis.xlsx', 'WriteRowNames', true);
end

function visualizeBubblePerimeters()
    cameraImagePath = '/Users/chikamaduabuchi/Documents/paul/processed/algorithm1/Img000000.tif';
    groundTruthPath = '/Users/chikamaduabuchi/Documents/paul/groundtruth/img000000.tif';
    segmentedPath = '/Users/chikamaduabuchi/Documents/paul/segmentation1/Img000000.tif';
    cameraImage = imread(cameraImagePath);
    groundTruthImage = imbinarize(imread(groundTruthPath));
    segmentedImage = imbinarize(imread(segmentedPath));
    cameraImageAdjusted = imadjust(cameraImage, stretchlim(cameraImage, [0.05, 0.95]));
    cameraImageRGB = repmat(cameraImageAdjusted, [1, 1, 3]);
    groundTruthEdges = bwperim(groundTruthImage);
    segmentedEdges = bwperim(segmentedImage);
    groundTruthEdgesDilated = dilateEdges(groundTruthEdges);
    segmentedEdgesDilated = dilateEdges(segmentedEdges);
    overlayCameraGroundTruth = blendOverlay(cameraImageRGB, groundTruthEdgesDilated, [0, 1, 0]);
    overlayCameraSegmented = blendOverlay(cameraImageRGB, segmentedEdgesDilated, [1, 0, 0]);
    overlayCameraSegmentedGroundTruth = blendOverlay(overlayCameraSegmented, groundTruthEdgesDilated, [0, 1, 0]);
    visualizeAndSave(overlayCameraGroundTruth, 'Camera + GroundTruth');
    visualizeAndSave(overlayCameraSegmented, 'Camera + Segmented');
    visualizeAndSave(overlayCameraSegmentedGroundTruth, 'Camera + Segmented + GroundTruth');

    function dilatedEdges = dilateEdges(binaryEdges)
        se = strel('disk', 3);
        dilatedEdges = imdilate(binaryEdges, se);
    end

    function overlayImage = blendOverlay(baseImageRGB, edgesBinary, edgeColor)
        edgeMask = cat(3, edgesBinary * edgeColor(1), edgesBinary * edgeColor(2), edgesBinary * edgeColor(3));
        edgeMaskDilated = imdilate(edgeMask, strel('disk', 1));
        overlayImage = baseImageRGB;
        for k = 1:3
            channel = overlayImage(:,:,k);
            mask = edgeMaskDilated(:,:,k);
            channel(mask > 0) = 255;
            overlayImage(:,:,k) = channel;
        end
    end

    function visualizeAndSave(image, titleText)
        figure; imshow(image);
        titleText = strrep(titleText, '_', ' + ');
        title(titleText, 'FontWeight', 'bold', 'FontSize', 14);
    end
end
