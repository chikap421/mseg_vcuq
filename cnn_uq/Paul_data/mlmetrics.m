 function mlmetrics
    segmentationDir = '/Users/chikamaduabuchi/Documents/paul/segmentation1';
    groundTruthDir = '/Users/chikamaduabuchi/Documents/paul/groundtruth';
    files = dir(fullfile(segmentationDir, '*.tif'));
    numFiles = length(files);
    metrics = zeros(numFiles, 7);
    imageNames = strings(numFiles, 1);

    for i = 1:numFiles
        segImage = imbinarize(imread(fullfile(segmentationDir, files(i).name)));
        gtImage = imbinarize(imread(fullfile(groundTruthDir, files(i).name)));
        metrics(i, :) = calculateMetrics(segImage, gtImage);
        imageNames(i) = erase(files(i).name, [".tif", "Img"]);
    end

    metricsTable = array2table(metrics, 'VariableNames', {'Accuracy', 'Precision', 'Recall', 'F1Score', 'Specificity', 'IoU', 'MCC'});
    plotMetrics(metricsTable, imageNames);
end

function metrics = calculateMetrics(segImage, gtImage)
    TP = sum((segImage & gtImage), 'all');
    TN = sum((~segImage & ~gtImage), 'all');
    FP = sum((segImage & ~gtImage), 'all');
    FN = sum((~segImage & gtImage), 'all');
    metrics = [...
        (TP + TN) / (TP + TN + FP + FN), ... % Accuracy
        TP / (TP + FP), ... % Precision
        TP / (TP + FN), ... % Recall
        2 * ((TP / (TP + FP)) * (TP / (TP + FN))) / ((TP / (TP + FP)) + (TP / (TP + FN))), ... % F1Score
        TN / (TN + FP), ... % Specificity
        TP / (TP + FP + FN), ... % IoU
        (TP * TN - FP * FN) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN)) ... % MCC
    ];
end

function plotMetrics(metricsTable, imageNames)
    figure; hold on;
    box on;
    set(gca, 'LineWidth', 2);
    colors = lines(7);
    h = plot(metricsTable{:, :}, '-o', 'LineWidth', 2);
    set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
    set(h, {'MarkerFaceColor'}, num2cell(colors, 2));
    grid on;
    set(gca, 'GridLineStyle', '-', 'GridColor', 'k', 'GridAlpha', 0.3); 
    set(gca, 'MinorGridLineStyle', ':', 'MinorGridColor', 'k', 'MinorGridAlpha', 0.05); 
    ax = gca;
    ax.XAxis.MinorTick = 'on';
    ax.YAxis.MinorTick = 'on';
    ax.XMinorGrid = 'on';
    ax.YMinorGrid = 'on';
    set(gca, 'XTick', 1:length(imageNames), 'XTickLabel', imageNames, 'XTickLabelRotation', 45); 
    set(gca, 'FontSize', 14); 
    xlabel('Image Name', 'FontSize', 16);
    ylabel('Metric Value', 'FontSize', 16);
    title('Machine Learning Performance Metrics', 'FontSize', 18);
    legend(metricsTable.Properties.VariableNames, 'FontSize', 14, 'NumColumns', 3, 'Location','north');
    hold off;
end
