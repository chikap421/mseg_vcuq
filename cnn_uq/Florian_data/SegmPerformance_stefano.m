clear; clc; close

seg_path = '/Users/mac/Desktop/Validation Study/Segmentations/img_12/img_9.tif';
gt_path = '/Users/mac/Dropbox (MIT)/RED LAB/Image analysis/Image Data/Current/First data from Florian/Latest/Threshold/Grayscale/img_9_1.tif';
% Load segmentation mask and ground truth data
segmentation_mask = imread(seg_path);
ground_truth = imread(gt_path);

%original = imread(['../Imgs/Annotated/CoarseBubbly/','ann_',  test,'.tif']);

% Convert images to binary format
segmentation_mask = imbinarize(segmentation_mask);
ground_truth = imbinarize(ground_truth);
% Get sizes of both images
[seg_height, seg_width] = size(segmentation_mask);
[gt_height, gt_width] = size(ground_truth);

% Resize the segmentation_mask to the same size as ground_truth
if seg_height ~= gt_height || seg_width ~= gt_width
    segmentation_mask = imresize(segmentation_mask, [gt_height, gt_width]);
end

% Now, segmentation_mask and ground_truth should have the same size

% Calculate true positives, true negatives, false positives, false negatives
TP = sum(sum(segmentation_mask & ground_truth));
TN = sum(sum(~segmentation_mask & ~ground_truth));
FP = sum(sum(segmentation_mask & ~ground_truth));
FN = sum(sum(~segmentation_mask & ground_truth));

% Calculate accuracy, precision, recall, F1-score
accuracy = (TP + TN) / (TP + TN + FP + FN);
precision = TP / (TP + FP);
recall = TP / (TP + FN);
f1_score = 2 * (precision * recall) / (precision + recall);

% Display results
disp(['True Positives: ' num2str(TP)]);
disp(['True Negatives: ' num2str(TN)]);
disp(['False Positives: ' num2str(FP)]);
disp(['False Negatives: ' num2str(FN)]);
disp(['Accuracy: ' num2str(accuracy)]);
disp(['Precision: ' num2str(precision)]);
disp(['Recall: ' num2str(recall)]);
disp(['F1-Score: ' num2str(f1_score)]);

% Display FP and FN
close all
% Load the original image and AI segmentation mask
originalImage = ground_truth;
segmentationMask = segmentation_mask;

% Create false positive mask
falsePositiveMask = (segmentationMask == 1) & (originalImage == 0);

% Create false negative mask
falseNegativeMask = (segmentationMask == 0) & (originalImage == 1);

truePositiveMask = (segmentationMask == 1) & (originalImage == 1);
trueNegativeMask = (segmentationMask == 0) & (originalImage == 0);

% Create an RGB image to display false positives and false negatives
resultImage = uint8(cat(3, originalImage, originalImage, originalImage)); % Convert to RGB

% Set false positives to red color
resultImage(:,:,1) = imadd(uint8(falsePositiveMask) * 255, uint8(truePositiveMask)*128);

% Set false negatives to blue color
resultImage(:,:,3) = imadd(uint8(falseNegativeMask) * 255, uint8(truePositiveMask)*128);

% Set false negatives to blue color
resultImage(:,:,2) = uint8(truePositiveMask)*128;


% Display the result
figure;
hold on
imshow(resultImage);
title('False Positives (Red) and False Negatives (Blue)');

% Save the result
%imwrite(resultImage, ['FP_FN/FP_FN_',test,'.png']);

