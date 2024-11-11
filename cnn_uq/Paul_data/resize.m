sourceDir = '/Users/chikamaduabuchi/Documents/paul/segmentation1/';
targetDir = '/Users/chikamaduabuchi/Documents/paul/processed/algorithm1/';
files = dir(fullfile(sourceDir, '*.tif'));
targetImageFiles = dir(fullfile(targetDir, '*.tif'));
targetImage = imread(fullfile(targetDir, targetImageFiles(1).name));
[yRows, yCols, ~] = size(targetImage);

for i = 1:length(files)
    img = imread(fullfile(sourceDir, files(i).name));
    resizedImg = imresize(img, [yRows yCols]);
    imwrite(resizedImg, fullfile(sourceDir, files(i).name));
end
