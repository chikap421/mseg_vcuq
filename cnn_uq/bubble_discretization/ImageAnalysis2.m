function ImageAnalysis2
    clear;
    close all;
    clc;

    folderPath = '/Users/chikamaduabuchi/Documents/paul/uncertainty';
    files = dir(fullfile(folderPath, '*.tif'));
    conversionFactor = 12.6;
    numBins = 15;

    for k = 1:length(files)
        imagePath = fullfile(files(k).folder, files(k).name);
        [binaryMask, bubbleMeasurements] = processImage(imagePath);
        totalBubbles = length(bubbleMeasurements);
        fprintf('Processing %s: Total number of bubbles: %d\n', files(k).name, totalBubbles);

        [perimeters_um, areas_um2, radii_um, radiiFromPerimeter_um] = calculateDimensions(bubbleMeasurements, conversionFactor);
        [d_daf, d_cld] = calc_density_fraction(binaryMask, conversionFactor);
        fprintf('Dry Area Fraction (DAF): %f\n', d_daf);
        fprintf('Contact Line Density (CLD): %f\n', d_cld);

        outputFilename = fullfile(folderPath, ['top10BinsTable_', files(k).name(1:end-4), '.csv']);
        printAndSaveTopRadii(radii_um, numBins, outputFilename);
    end
end

%% Local Functions (unchanged)
function [binaryMask, bubbleMeasurements] = processImage(imagePath)
    image = imread(imagePath);
    binaryMask = imbinarize(image);
    labeledBubbles = bwlabel(binaryMask);
    bubbleMeasurements = regionprops(labeledBubbles, 'Perimeter', 'Area');
end

function [perimeters_um, areas_um2, radii_um, radiiFromPerimeter_um] = calculateDimensions(bubbleMeasurements, conversionFactor)
    perimeters_um = [bubbleMeasurements.Perimeter] * conversionFactor;
    areas_um2 = [bubbleMeasurements.Area] * conversionFactor^2;
    radii_um = sqrt(areas_um2 / pi);
    radiiFromPerimeter_um = perimeters_um / (2 * pi);
end

function [d_daf, d_cld] = calc_density_fraction(binary_mask, conversionFactor)
    pixelArea_um2 = conversionFactor^2; 
    total_pixels = numel(binary_mask);
    wet_pixels = sum(binary_mask == 0, 'all');
    d_daf = 1 - (wet_pixels / total_pixels);

    inverted_binary_mask = ~binary_mask;
    dist = bwdist(inverted_binary_mask, 'euclidean');
    dist(dist > 1) = 0;
    contact_line_length_pixels = sum(dist(:));
    contact_line_length_um = contact_line_length_pixels * conversionFactor;
    total_area_um2 = total_pixels * pixelArea_um2;
    d_cld = contact_line_length_um / total_area_um2;
end

function printAndSaveTopRadii(radii, numBins, filename)
    binEdges = linspace(min(radii), max(radii), numBins + 1);
    [~, ~, binIdx] = histcounts(radii, binEdges);
    binCounts = accumarray(binIdx', 1, [numBins 1], @sum, 0);
    [sortedCounts, sortIdx] = sort(binCounts, 'descend');
    top10BinCounts = sortedCounts(1:10);
    top10BinEdges = binEdges(sortIdx(1:10));
    binStarts = top10BinEdges;
    binEnds = binEdges(sortIdx(1:10) + 1);
    
    top10BinsTable = table(binStarts', binEnds', top10BinCounts, 'VariableNames', {'BinStart_um', 'BinEnd_um', 'Frequency'});

    disp(['Top 10 most occurring radii bins (um) and their frequencies for ', filename]);
    disp(top10BinsTable);
    writetable(top10BinsTable, filename);
    disp(['Top 10 bins table written to ', filename]);
end
