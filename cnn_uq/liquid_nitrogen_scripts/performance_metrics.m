% Performance Metrics of Segmented Images: Box Plot, Bar Graph, and Line Plot in MATLAB

clear; close all; clc

% Initialize variables to store the metrics
accuracy = [];
precision = [];
recall = [];
specificity = [];
mcc = [];
diceCoeff = [];
jaccardIndex = [];
f1Score = [];

% Load all images in the folder
folder_path = 'C:\Users\dell g3\OneDrive\RED LAB\Image analysis\Image Data\Segmentation results\New Results\Binary masks\';
files = dir(fullfile(folder_path, '*.tif'));

% Loop over all images
for k=1:length(files)
    % Read the segmentation score image
    A_path = fullfile('C:\Users\dell g3\OneDrive\RED LAB\Image analysis\Image Data\Segmentation results\New Results\Segmentation scores\', strcat(num2str(k), '.tif'));
    A = imread(A_path);
    
    % Read the ground truth binary mask image
    B_path = fullfile(folder_path, strcat(num2str(k), '.tif'));
    B = imread(B_path);
    
    % Resize the images
    B = imresize(B, size(A));
    
    % Binarize the images
    BW = imbinarize(A);
    BW_groundTruth = imbinarize(B);
    
    % Calculate the confusion matrix
    tp = sum(sum(BW&BW_groundTruth));
    fp = sum(sum(BW&~BW_groundTruth));
    tn = sum(sum(~BW&~BW_groundTruth));
    fn = sum(sum(~BW&BW_groundTruth));
    
    % Calculate the metrics
    accuracy(k) = (tp+tn)/(tp+tn+fp+fn);
    precision(k) = tp/(tp+fp);
    recall(k) = tp/(tp+fn);
    specificity(k) = tn/(tn+fp);
    mcc(k) = (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
    diceCoeff(k) = 2*tp/(2*tp+fp+fn);
    jaccardIndex(k) = tp/(tp+fp+fn);
    f1Score(k) = 2*precision(k)*recall(k)/(precision(k)+recall(k));
end

% Display the metrics in a table
T = table(accuracy', precision', recall', specificity', mcc', diceCoeff', jaccardIndex', f1Score', 'VariableNames', {'Accuracy', 'Precision', 'Recall', 'Specificity', 'MCC', 'Dice Coefficient', 'Jaccard Index', 'F1 Score'});

% Save the table as an Excel file
writetable(T, 'C:\Users\dell g3\OneDrive\RED LAB\Image analysis\Image Data\Segmentation results\New Results\Performance metrics\metrics_table.xlsx');


% Create a box plot for the metrics
figure;
boxplot([accuracy' precision' recall' specificity' mcc' diceCoeff' jaccardIndex' f1Score'], 'Labels', {'Accuracy', 'Precision', 'Recall', 'Specificity', 'MCC', 'Dice Coefficient', 'Jaccard Index', 'F1 Score'})
ylabel('Metric Value')
title('Performance Metrics')

% Rotate the x-axis labels by 45 degrees
xtickangle(45);

% Save the box plot to a directory on your computer
saveas(gcf, 'C:\Users\dell g3\OneDrive\RED LAB\Image analysis\Image Data\Segmentation results\New Results\Performance metrics\box_plot.png')

% Create a bar graph with each metric for all images
figure;
bar([accuracy', precision', recall', specificity', mcc', diceCoeff', jaccardIndex', f1Score'])
legend('Accuracy', 'Precision', 'Recall', 'Specificity', 'MCC', 'Dice Coefficient', 'Jaccard Index', 'F1 Score')
xlabel('Images')
ylabel('Metric Value')
title('Performance Metrics')

% Save the bar graph to a directory on your computer
saveas(gcf, 'C:\Users\dell g3\OneDrive\RED LAB\Image analysis\Image Data\Segmentation results\New Results\Performance metrics\bar_graph.png')

% Plot the metrics for all images as a line plot
figure;
plot(accuracy, '-o')
hold on
plot(precision, '-o')
plot(recall, '-o')
plot(specificity, '-o')
plot(mcc, '-o')
plot(diceCoeff, '-o')
plot(jaccardIndex, '-o')
plot(f1Score, '-o')
hold off
legend('Accuracy', 'Precision', 'Recall', 'Specificity', 'MCC', 'Dice Coefficient', 'Jaccard Index', 'F1 Score','Location', 'south')
xlabel('Image Number')
ylabel('Metric Value')
title('Performance Metrics')

% Save the line plot to a directory on your computer
saveas(gcf, 'C:\Users\dell g3\OneDrive\RED LAB\Image analysis\Image Data\Segmentation results\New Results\Performance metrics\line_plot.png')
