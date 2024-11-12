rng(1);
sourceDir = '/Users/chikamaduabuchi/Documents/paul/rawdata';
targetDir = '/Users/chikamaduabuchi/Documents/paul/random';
if ~exist(targetDir, 'dir'), mkdir(targetDir); end
files = dir(fullfile(sourceDir, '*.tif'));
fileNames = {files.name};
if numel(fileNames) < 10, error('Less than 10 images.'); end
indices = randperm(numel(fileNames), 10);
arrayfun(@(i) copyfile(fullfile(sourceDir, fileNames{i}), targetDir), indices);
disp('10 images copied.');
