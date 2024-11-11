function compare_users_metrics()
    % Define users and methods
    users = {'Chika', 'Marco', 'Rodrigo', 'Stefano', 'Yang', 'Segmentation', 'Thresholding'};
    images = {'img_8_1.tif', 'img_8_1901.tif', 'img_9_1.tif', 'img_9_1901.tif'};
    baseDir = '/Users/mac/Desktop/Validation Study/User Ground Truth/8/Binary';

    % Initialize results variables
    dry_area_fractions = zeros(length(users), length(images));
    contact_line_densities = zeros(length(users), length(images));

    % Calculate metrics for each user and image
    for i = 1:length(users)
        for j = 1:length(images)
            % Build the full image path
            imagePath = fullfile(baseDir, users{i}, images{j});

            % Load the image
            binary_mask = imread(imagePath);

            % Calculate the metrics
            [dry_area_fractions(i,j), contact_line_densities(i,j)] = calc_density_fraction(binary_mask);
        end
    end

    % Print dry area fractions
    disp('Dry Area Fractions:')
    disp(array2table(dry_area_fractions, 'RowNames', users, 'VariableNames', strrep(images, '.tif', '')))

    % Print contact line densities
    disp('Contact Line Densities:')
    disp(array2table(contact_line_densities, 'RowNames', users, 'VariableNames', strrep(images, '.tif', '')))
end
