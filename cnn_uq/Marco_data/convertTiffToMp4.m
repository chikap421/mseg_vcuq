function convertTiffToMp4(inputTIFFPath, outputVideoPath)
    % Check if the input file exists
    if ~exist(inputTIFFPath, 'file')
        error('The specified input TIFF file does not exist.');
    end

    % Get the number of frames in the TIFF file
    info = imfinfo(inputTIFFPath);
    numFrames = numel(info);

    % Create the video writer object
    outputVideo = VideoWriter(outputVideoPath, 'MPEG-4');
    outputVideo.FrameRate = 10; % Adjust the frame rate as needed
    
    % Open the video writer
    open(outputVideo);

    % Initialize waitbar
    h = waitbar(0, sprintf('Processing file: %s', inputTIFFPath), 'Name', 'Converting TIFF to MP4...');
    
    % Loop through the frames in the TIFF file
    for frameIndex = 1:numFrames
        % Read the current frame
        img = imread(inputTIFFPath, frameIndex);
        
        % Write the image to the video
        writeVideo(outputVideo, img);
        
        % Update waitbar
        waitbar(frameIndex / numFrames, h, sprintf('Processing frame %d of %d', frameIndex, numFrames));
    end

    % Close the video file and the waitbar
    close(outputVideo);
    close(h);
    
    disp(['Video saved to: ' outputVideoPath]);
end
