outputFolder = '/Users/chikamaduabuchi/Documents/paul/case1/bubbleperimeter';
processImages('/Users/chikamaduabuchi/Documents/paul/case1/processed/algorithm1/Img000000.tif', ...
              '/Users/chikamaduabuchi/Documents/paul/case1/groundtruth/img000000.tif', ...
              '/Users/chikamaduabuchi/Documents/paul/case1/segmentation1/Img000000.tif', ...
              outputFolder);

function processImages(cameraImagePath, groundTruthImagePath, segmentedImagePath, outputFolder)
    cameraImage = imread(cameraImagePath);
    cameraImageSize = size(cameraImage(:, :, 1));
    groundTruthImage = imresize(imread(groundTruthImagePath), cameraImageSize);
    segmentedImage = imresize(imread(segmentedImagePath), cameraImageSize);
    cameraImageRGB = im2uint8(ind2rgb(cameraImage, gray(256)));
    [groundTruthPerimeter, segmentedPerimeter] = findAndDilatePerimeters(groundTruthImage, segmentedImage);
    overlayAndDisplay(cameraImageRGB, groundTruthPerimeter, [1, 0, 0], fullfile(outputFolder, 'ground_truth_overlay.tif'));
    overlayAndDisplay(cameraImageRGB, segmentedPerimeter, [0, 1, 0], fullfile(outputFolder, 'segmented_overlay.tif'));
    overlayBothAndDisplay(cameraImageRGB, groundTruthPerimeter, segmentedPerimeter, fullfile(outputFolder, 'both_overlay.tif'));
end

function [gtPerimeter, segPerimeter] = findAndDilatePerimeters(gtImage, segImage)
    gtPerimeter = imdilate(bwperim(imbinarize(gtImage)), strel('disk', 1));
    segPerimeter = imdilate(bwperim(imbinarize(segImage)), strel('disk', 1));
end

function overlayAndDisplay(cameraRGB, perimeter, color, outputFileName)
    overlayImage = cameraRGB;
    for k = 1:3
        channel = overlayImage(:,:,k);
        channel(perimeter) = color(k) * 255;
        overlayImage(:,:,k) = channel;
    end
    figure; imshow(overlayImage);
    imwrite(overlayImage, outputFileName);
end

function overlayBothAndDisplay(cameraRGB, gtPerimeter, segPerimeter, outputFileName)
    overlayImage = cameraRGB;
    overlayImage(:,:,1) = max(overlayImage(:,:,1), uint8(255 * gtPerimeter));
    overlayImage(:,:,2) = max(overlayImage(:,:,2), uint8(255 * segPerimeter));
    overlap = gtPerimeter & segPerimeter;
    overlayImage(repmat(overlap, [1 1 3])) = 0;
    overlayImage(:,:,1) = overlayImage(:,:,1) + uint8(255 * overlap);
    overlayImage(:,:,2) = overlayImage(:,:,2) + uint8(255 * overlap);
    figure; imshow(overlayImage)
    imwrite(overlayImage, outputFileName);
end
