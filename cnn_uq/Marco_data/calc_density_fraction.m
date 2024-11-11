function [d_daf, d_cld] = calc_density_fraction(binary_mask)
    total_pixels = numel(binary_mask);
    wet_pixels = sum(binary_mask == 0, 'all');
    d_daf = (1 - (wet_pixels / total_pixels));

    inverted_binary_mask = ~binary_mask;
    dist = bwdist(inverted_binary_mask);
    dist(dist > 1) = 0;
    contact_line_length = sum(dist, 'all');
    d_cld = contact_line_length / total_pixels;
end