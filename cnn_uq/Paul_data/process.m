mkdirIfNeeded = @(dir) ~exist(dir, 'dir') && mkdir(dir);
processImage = @(img, method, outputFile) imwrite(method(img), outputFile, 'Compression', 'none');

inputDir = '/Users/chikamaduabuchi/Documents/paul/cropped';
outputDirs = {'/Users/chikamaduabuchi/Documents/paul/processed/algorithm1', ...
              '/Users/chikamaduabuchi/Documents/paul/processed/algorithm2'};

cellfun(mkdirIfNeeded, outputDirs);

tifFiles = dir(fullfile(inputDir, '*.tif'));
for fileIdx = 1:length(tifFiles)
    image_B = imread(fullfile(inputDir, tifFiles(fileIdx).name));
    image_A = zeros(size(image_B), class(image_B));
    
    processImage(image_B, @(img) imadjust(im2gray(imabsdiff(img, image_A))), ...
                 fullfile(outputDirs{1}, tifFiles(fileIdx).name));
    processImage(image_B, @(img) im2gray(imabsdiff(img, imgaussfilt(image_A,2))), ...
                 fullfile(outputDirs{2}, tifFiles(fileIdx).name));
end

disp('Processing complete for all images.');
