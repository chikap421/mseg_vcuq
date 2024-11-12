sourceDir = '/Users/chikamaduabuchi/Documents/paul/random';
targetDir = '/Users/chikamaduabuchi/Documents/paul/cropped';
if ~exist(targetDir, 'dir'), mkdir(targetDir); end
files = dir(fullfile(sourceDir, '*.tif'));

for i = 1:length(files)
    img = imread(fullfile(sourceDir, files(i).name));
    [rows, cols, ~] = size(img);
    margins = round([rows * 0.13, rows * 0.09, cols * 0.17, cols * 0.17]);
    cropRect = [margins(3) + 1, margins(1) + 1, cols - sum(margins(3:4)) - 1, rows - sum(margins(1:2)) - 1];
    imwrite(imcrop(img, cropRect), fullfile(targetDir, files(i).name));
end
disp('All images have been cropped and saved to the target directory.');
