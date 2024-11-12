% Image file paths
folder1_img_16_1_path = "/Users/mac/Desktop/New New Latest/Segmentation/Improper Annotation Results/img_16_1.tif";
folder1_img_16_1901_path = "/Users/mac/Desktop/New New Latest/Segmentation/Improper Annotation Results/img_16_1901.tif";
folder2_img_16_1_path = "/Users/mac/Desktop/New New Latest/Segmentation/Proper Annotation Results/img_16_1.tif";
folder2_img_16_1901_path = "/Users/mac/Desktop/New New Latest/Segmentation/Proper Annotation Results/img_16_1901.tif";

% Calculate contact line density and dry area fraction for all images
[dry_area_fraction1, contact_line_density1] = calc_density_fraction(folder1_img_16_1_path);
[dry_area_fraction2, contact_line_density2] = calc_density_fraction(folder1_img_16_1901_path);
[dry_area_fraction3, contact_line_density3] = calc_density_fraction(folder2_img_16_1_path);
[dry_area_fraction4, contact_line_density4] = calc_density_fraction(folder2_img_16_1901_path);


% Plot the results using a bar chart
labels = {'Improper- img\_16\_1', 'Improper - img\_16\_1901', 'Proper - img\_16\_1', 'Proper - img\_16\_1901'};
dry_area_fractions = [dry_area_fraction1, dry_area_fraction2, dry_area_fraction3, dry_area_fraction4];
contact_line_densities = [contact_line_density1, contact_line_density2, contact_line_density3, contact_line_density4];

figure;
b = bar(1:4, [dry_area_fractions; contact_line_densities]', 'grouped');
set(gca, 'XTickLabel', labels, 'XTickLabelRotation', 45);
legend('Dry Area Fraction', 'Contact Line Density', 'Location','Best');
ylabel('Value');
title('Comparison of Dry Area Fraction and Contact Line Density');

% Add the values on top of each bar
for k = 1:length(b)
    xtips = b(k).XEndPoints;
    ytips = b(k).YEndPoints;
    labels = string(b(k).YData);
    text(xtips, ytips, labels, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 8);
end

% Save the figure as a 300 dpi image
save_folder = '/Users/mac/Desktop/New New Latest/Performance metrics';
save_name = 'bar_chart_comparison.png';
save_path = fullfile(save_folder, save_name);
print('-dpng', '-r300', save_path);


% (Your previous code for calculating dry area fractions and contact line densities)

% Calculate the differences between proper and improper images
diff_dry_area_fractions = abs(dry_area_fractions(3:4) - dry_area_fractions(1:2));
diff_contact_line_densities = abs(contact_line_densities(3:4) - contact_line_densities(1:2));

% Plot the differences using a bar chart
figure;
b_diff = bar(1:2, [diff_dry_area_fractions; diff_contact_line_densities]', 'grouped');
set(gca, 'XTickLabel', {'img\_16\_1', 'img\_16\_1901'}, 'XTickLabelRotation', 45);
legend('Difference in Dry Area Fraction', 'Difference in Contact Line Density', 'Location','Best');
ylabel('Difference');
title('Differences between Proper and Improper Images');

% Add the values on top of each bar
for k = 1:length(b_diff)
    xtips_diff = b_diff(k).XEndPoints;
    ytips_diff = b_diff(k).YEndPoints;
    labels_diff = string(b_diff(k).YData);
    text(xtips_diff, ytips_diff, labels_diff, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 8);
end

save_name_diff = 'bar_chart_comparison_differences.png';
save_path_diff = fullfile(save_folder, save_name_diff);
print('-dpng', '-r300', save_path_diff);

function [dry_area_fraction, contact_line_density] = calc_density_fraction(image_path)
    % Read the binary mask
    binary_mask = imread(image_path);

    % Calculate the total number of pixels in the image
    total_pixels = numel(binary_mask);

    % Calculate the number of dry pixels (ones)
    dry_pixels = sum(binary_mask == 1, 'all');

    % Calculate the dry area fraction
    dry_area_fraction = dry_pixels / total_pixels;

    % Invert the binary mask
    inverted_binary_mask = ~binary_mask;

    % Calculate the Euclidean distance transform of the inverted mask
    dist = bwdist(inverted_binary_mask);

    % Set all distance values greater than 1 to 0
    dist(dist > 1) = 0;

    % Calculate the contact line length by counting the pixels in the dist image
    contact_line_length = sum(dist, 'all');

    % Calculate the contact line density (length per unit area)
    contact_line_density = contact_line_length / total_pixels;
end
