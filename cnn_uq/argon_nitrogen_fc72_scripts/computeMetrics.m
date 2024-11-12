% Define a function to compute the metrics
function [confMatrix, accuracy, precision, recall, f1Score, iou, mcc] = computeMetrics(segmented, groundTruth)
    TP = sum(sum(segmented & groundTruth));
    TN = sum(sum(~segmented & ~groundTruth));
    FP = sum(sum(segmented & ~groundTruth));
    FN = sum(sum(~segmented & groundTruth));
    
    confMatrix = [TP, FN; FP, TN];
    
    accuracy = (TP + TN) / (TP + TN + FP + FN);
    precision = TP / (TP + FP);
    recall = TP / (TP + FN);
    f1Score = 2 * (precision * recall) / (precision + recall);
    iou = TP / (TP + FP + FN);
    mcc = (TP * TN - FP * FN) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));
end