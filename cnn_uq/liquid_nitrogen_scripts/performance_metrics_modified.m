% Image file paths
folder1_img_16_1_path = "/Users/mac/Desktop/New New Latest/Segmentation/Improper Annotation Results/img_16_1.tif";
folder1_img_16_1901_path = "/Users/mac/Desktop/New New Latest/Segmentation/Improper Annotation Results/img_16_1901.tif";
folder2_img_16_1_path = "/Users/mac/Desktop/New New Latest/Segmentation/Proper Annotation Results/img_16_1.tif";
folder2_img_16_1901_path = "/Users/mac/Desktop/New New Latest/Segmentation/Proper Annotation Results/img_16_1901.tif";

% Ground truth file paths
gt_folder1_img_16_1_path = "/Users/mac/Desktop/New New Latest/Ground Truths/Improper 16/img_16_1.tif";
gt_folder1_img_16_1901_path = "/Users/mac/Desktop/New New Latest/Ground Truths/Improper 16/img_16_1901.tif";
gt_folder2_img_16_1_path = "/Users/mac/Desktop/New New Latest/Ground Truths/Proper 16/img_16_1.tif";
gt_folder2_img_16_1901_path = "/Users/mac/Desktop/New New Latest/Ground Truths/Proper 16/img_16_1901.tif";

% Calculate performance metrics for all images
[accuracy1, precision1, recall1, f1_1, iou1, specificity1, sensitivity1, mcc1] = calc_performance_metrics(imread(gt_folder1_img_16_1_path), imread(folder1_img_16_1_path));
[accuracy2, precision2, recall2, f1_2, iou2, specificity2, sensitivity2, mcc2] = calc_performance_metrics(imread(gt_folder1_img_16_1901_path), imread(folder1_img_16_1901_path));
[accuracy3, precision3, recall3, f1_3, iou3, specificity3, sensitivity3, mcc3] = calc_performance_metrics(imread(gt_folder2_img_16_1_path), imread(folder2_img_16_1_path));
[accuracy4, precision4, recall4, f1_4, iou4, specificity4, sensitivity4, mcc4] = calc_performance_metrics(imread(gt_folder2_img_16_1901_path), imread(folder2_img_16_1901_path));

% Plot the results using a bar chart
labels = {'Improper- img\_16\_1', 'Improper - img\_16\_1901', 'Proper - img\_16\_1', 'Proper - img\_16\_1901'};
performance_metrics = [accuracy1, precision1, recall1, f1_1, iou1, specificity1, sensitivity1, mcc1;
                       accuracy2, precision2, recall2, f1_2, iou2, specificity2, sensitivity2, mcc2;
                       accuracy3, precision3, recall3, f1_3, iou3, specificity3, sensitivity3, mcc3;
                       accuracy4, precision4, recall4, f1_4, iou4, specificity4, sensitivity4, mcc4];

figure;
b = bar(performance_metrics);
set(gca, 'XTickLabel', labels, 'XTickLabelRotation', 45);
legend('Accuracy', 'Precision', 'Recall', 'F1 Score', 'IoU', 'Specificity', 'Sensitivity', 'MCC', 'Location', 'east');
ylabel('Value');
title('Comparison of Performance Metrics for Proper and Improper Models');


% Save the figure as a 300 dpi image
save_folder = '/Users/mac/Desktop/New New Latest/Performance metrics';
save_name = 'performance_metrics_comparison.png';
save_path = fullfile(save_folder, save_name);
print('-dpng', '-r300', save_path);

function [accuracy, precision, recall, f1, iou, specificity, sensitivity, mcc] = calc_performance_metrics(ground_truth, prediction)
    % Cast the ground_truth and prediction images to logical type
    ground_truth = logical(ground_truth);
    prediction = logical(prediction);

    % Calculate true positive, false positive, true negative, and false negative
    tp = sum((ground_truth == 1) & (prediction == 1), 'all');
    fp = sum((ground_truth == 0) & (prediction == 1), 'all');
    tn = sum((ground_truth == 0) & (prediction == 0), 'all');
    fn = sum((ground_truth == 1) & (prediction == 0), 'all');

    % Calculate accuracy
    accuracy = (tp + tn) / (tp + fp + tn + fn);

    % Calculate precision
    if tp + fp == 0
        precision = NaN;
    else
        precision = tp / (tp + fp);
    end

    % Calculate recall (sensitivity)
    if tp + fn == 0
        recall = NaN;
    else
        recall = tp / (tp + fn);
    end

    % Calculate specificity
    if tn + fp == 0
        specificity = NaN;
    else
        specificity = tn / (tn + fp);
    end

    % Calculate sensitivity (same as recall)
    sensitivity = recall;

    % Calculate F1 score
    if precision + recall == 0
        f1 = NaN;
    else
        f1 = 2 * (precision * recall) / (precision + recall);
    end

    % Calculate Intersection over Union (IoU)
    intersection = sum((ground_truth == 1) & (prediction == 1), 'all');
    union = sum((ground_truth == 1) | (prediction == 1), 'all');
    if union == 0
        iou = NaN;
    else
        iou = intersection / union;
    end

    % Calculate Matthews correlation coefficient (MCC)
    denominator = sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn));
    if denominator == 0
        mcc = NaN;
    else
        mcc = (tp * tn - fp * fn) / denominator;
    end
end
