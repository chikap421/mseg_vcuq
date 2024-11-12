function ImageAnalysis
    clear;
    close all;
    clc;

    imagePath = '/Users/chikamaduabuchi/Documents/paul/uncertainty/LAr.tif';
    conversionFactor = 12.6;
    numBins = 15;

    [binaryMask, bubbleMeasurements] = processImage(imagePath);
    totalBubbles = length(bubbleMeasurements); 
    fprintf('Total number of bubbles: %d\n', totalBubbles);

    [perimeters_um, areas_um2, radii_um, radiiFromPerimeter_um] = calculateDimensions(bubbleMeasurements, conversionFactor);
    [d_daf, d_cld] = calc_density_fraction(binaryMask, conversionFactor);
    fprintf('Dry Area Fraction (DAF): %f\n', d_daf);
    fprintf('Contact Line Density (CLD): %f\n', d_cld);

    % plotDistributions(perimeters_um, areas_um2, radii_um);
    % plotRadiiComparison(radii_um, radiiFromPerimeter_um);
    % plotPerimeterVsAreaRadius(radiiFromPerimeter_um, radii_um);
    printAndSaveTopRadii(radii_um, numBins);
end

%% Local Functions
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

function binsLog = createLogBins(data, numBins)
    minData = min(data(data > 0));
    maxData = max(data);
    binsLog = logspace(log10(minData), log10(maxData), numBins);
end

function plotPDF(data, plotTitle, bins, axisType, normalization, dataLabel)
    if isempty(bins)
        histogram(data, 'Normalization', normalization);
    else
        histogram(data, 'BinEdges', bins, 'Normalization', normalization);
    end
    set(gca, 'XScale', axisType);
    if strcmp(axisType, 'log')
        minData = min(data(data > 0));
        maxData = max(data);
        ticks = logspace(floor(log10(minData)), ceil(log10(maxData)), ceil(log10(maxData))-floor(log10(minData))+1);
        set(gca, 'XTick', ticks);
        tickLabels = arrayfun(@(v) sprintf('10^{%d}', round(log10(v))), ticks, 'UniformOutput', false);
        set(gca, 'XTickLabel', tickLabels);
    end
    xlabel(dataLabel);
    if strcmp(normalization, 'pdf')
        if contains(dataLabel, 'Area')
            ylabel('Probability Density (1/\mum^2)');
        elseif contains(dataLabel, 'Perimeter')
            ylabel('Probability Density (1/\mum)');
        else
            ylabel('Probability Density (1/\mum)');
        end
    else
        ylabel('Count');
    end
    title(plotTitle);
    set(gca, 'LineWidth', 1.5);
    set(gca, 'FontSize', 12);
    set(gca, 'FontWeight', 'bold');
    grid on;
    set(gca, 'GridLineStyle', '-');
    set(gca, 'MinorGridLineStyle', ':');
    set(gca, 'GridAlpha', 0.2);
    set(gca, 'MinorGridAlpha', 0.2);
end

function printAndSaveTopRadii(radii, numBins)
    binEdges = linspace(min(radii), max(radii), numBins + 1);
    [~, ~, binIdx] = histcounts(radii, binEdges);
    binCounts = accumarray(binIdx', 1, [numBins 1], @sum, 0);
    [sortedCounts, sortIdx] = sort(binCounts, 'descend');
    top10BinCounts = sortedCounts(1:10);
    top10BinEdges = binEdges(sortIdx(1:10));
    binStarts = top10BinEdges;
    binEnds = binEdges(sortIdx(1:10) + 1);
    
    top10BinsTable = table(binStarts', binEnds', top10BinCounts, 'VariableNames', {'BinStart_um', 'BinEnd_um', 'Frequency'});

    disp('Top 10 most occurring radii bins (um) and their frequencies:');
    disp(top10BinsTable);
    filename = 'top10BinsTable.csv';
    writetable(top10BinsTable, filename);
    disp(['Top 10 bins table written to ', filename]);
end
