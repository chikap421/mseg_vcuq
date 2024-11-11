% Function to process multi-frame TIFFs
function [dry_area_fraction, contact_line_density] = processMultiFrameTiff(filePath, referenceSize)
    info = imfinfo(filePath);
    numFrames = numel(info);
    dry_area_fraction = zeros(numFrames, 1);
    contact_line_density = zeros(numFrames, 1);
    
    fprintf('Processing %s...\n', filePath);
    for frameIndex = 1:numFrames
        binary_mask = imread(filePath, frameIndex);
        binary_mask = imresize(binary_mask, referenceSize);
        binary_mask = imbinarize(binary_mask);
        
        [dry_area_fraction(frameIndex), contact_line_density(frameIndex)] = calc_density_fraction(binary_mask);
        
        % Print progress
        fprintf('Processed frame %d of %d\n', frameIndex, numFrames);
    end
    fprintf('Finished processing %s\n', filePath);
end