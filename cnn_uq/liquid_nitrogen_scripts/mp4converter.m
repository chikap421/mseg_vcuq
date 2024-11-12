% Directory where your TIFF files are stored
imageDir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Video';

% Specify the output directory
outputDir = '/Users/chikamaduabuchi/Dropbox (MIT)/RED LAB/MarcoProject/Segmentation/Video/MP4';

% Ensure that the output directory exists
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Loop through the img_* files
for fileIndex = 1:21
    % Construct the filename
    imageFilename = fullfile(imageDir, sprintf('img_%d.tif', fileIndex));
    
    % Get the number of frames in the TIFF file
    info = imfinfo(imageFilename);
    numFrames = numel(info);

    % Specify the output video file for the current TIFF file
    outputVideo = VideoWriter(fullfile(outputDir, sprintf('img_%d.mp4', fileIndex)), 'MPEG-4');
    
    % Open the video writer
    open(outputVideo);

    % Loop through the frames in the current TIFF file
    for frameIndex = 1:numFrames
        % Read the current frame
        img = imread(imageFilename, frameIndex);
        
        % Write the image to the video
        writeVideo(outputVideo, img);
        
        % Display progress
        fprintf('Processing frame %d of %d in file %d of 21\n', frameIndex, numFrames, fileIndex);
    end
    
    % Close the video file
    close(outputVideo);

    % Notify user that video was created
    disp(['Video created successfully for img_' num2str(fileIndex)]);
end

disp(['All videos created successfully in ' outputDir]);
