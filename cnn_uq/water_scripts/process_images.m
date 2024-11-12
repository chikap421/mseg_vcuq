function process_images()
    % Base directories and file paths
    sourceDir = '/Users/chikamaduabuchi/Documents/paul/case1/rawdata';
    baseFile = '/Users/chikamaduabuchi/Library/CloudStorage/GoogleDrive-sparkresearchers@gmail.com/My Drive/boilsam/data/highwater';
    compositeFile = [baseFile '.tif'];
    croppedFile = [baseFile '_cropped.tif'];
    processedFile = [baseFile '_processed.tif'];
    
    % Process operations
    extract_and_combine_tiffs(sourceDir, compositeFile, 500);
    crop_tiff_images(compositeFile, croppedFile);
    process_tiff_images(croppedFile, processedFile);
end

function extract_and_combine_tiffs(sourceDir, outputFile, maxFiles)
    % Extract TIFF files and combine into a multi-page file
    files = dir(fullfile(sourceDir, '*.tif'));
    files = {files.name};
    files = files(1:min(maxFiles, numel(files)));
    
    for i = 1:length(files)
        filename = fullfile(sourceDir, files{i});
        info = imfinfo(filename);
        for k = 1:numel(info)
            image = imread(filename, k);
            writeMode = chooseWriteMode(i, k);
            imwrite(image, outputFile, 'WriteMode', writeMode, 'Compression', 'none');
        end
        fprintf('Processed %d/%d files\n', i, length(files));
    end
    fprintf('All images have been successfully written to %s\n', outputFile);
end

function mode = chooseWriteMode(i, k)
    if i == 1 && k == 1
        mode = 'overwrite';
    else
        mode = 'append';
    end
end

function crop_tiff_images(inputFile, outputFile)
    % Crop each image in a TIFF file and save to a new file
    info = imfinfo(inputFile);
    for i = 1:numel(info)
        img = imread(inputFile, i, 'Info', info);
        [rows, cols] = size(img);
        margins = round([rows * 0.13, rows * 0.09, cols * 0.17, cols * 0.17]);
        cropRect = [margins(3) + 1, margins(1) + 1, cols - sum(margins(3:4)) - 1, rows - sum(margins(1:2)) - 1];
        croppedImg = imcrop(img, cropRect);
        writeMode = chooseWriteMode(i, 1); % Always '1' for second argument since cropping does not loop through pages inside this function
        imwrite(croppedImg, outputFile, 'WriteMode', writeMode, 'Compression', 'none');
        fprintf('Cropped %d/%d images\n', i, numel(info));
    end
    fprintf('All images have been cropped and saved to %s\n', outputFile);
end

function process_tiff_images(inputFile, outputFile)
    % Process and adjust images in a TIFF file
    info = imfinfo(inputFile);
    for i = 1:numel(info)
        img = imread(inputFile, i, 'Info', info);
        blankImg = zeros(size(img), class(img));
        processedImg = imadjust(im2gray(imabsdiff(img, blankImg)));
        writeMode = chooseWriteMode(i, 1); % Always '1' for second argument since processing does not loop through pages inside this function
        imwrite(processedImg, outputFile, 'WriteMode', writeMode, 'Compression', 'none');
        fprintf('Processed %d/%d images\n', i, numel(info));
    end
    disp('Processing complete for all images.');
end
