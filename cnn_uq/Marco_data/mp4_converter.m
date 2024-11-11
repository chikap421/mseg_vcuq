% List of input TIFF files
inputFiles = {'/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Video/LN2_Baseline_Processed.tif'
    };

% Corresponding list of output MP4 files
outputFiles = {
    '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Video/MP4/LN2_Baseline_Processed.mp4'
};

% Ensure output directories exist
for i = 1:length(outputFiles)
    outputPath = fileparts(outputFiles{i});
    if ~exist(outputPath, 'dir')
        mkdir(outputPath);
    end
end

% Iterate over each file and convert
for i = 1:length(inputFiles)
    convertTiffToMp4(inputFiles{i}, outputFiles{i});
end

disp('All files processed successfully.');

% Your convertTiffToMp4 function remains unchanged below this
