% Load the .mat file from the folder
mat_file_path = '/Users/mac/Dropbox (MIT)/RAW_DATA/First data from Florian/Camera Images/pre_21749_v2512_10.mat';
loaded_data = load(mat_file_path);

% Assuming 'images' is a 3D matrix containing 2000 frames
% (height x width x num_frames) within the .mat file
images = loaded_data.img_preTEST;  % Replace this with your actual variable name
num_frames = size(images, 3);

% Create a figure window for displaying the video
figure;

% Set the frame rate (frames per second)
frame_rate = 30;
frame_duration = 1 / frame_rate;

% Iterate through the frames and display each frame
for i = 1:num_frames
    imshow(images(:,:,i), []);
    pause(frame_duration);
end
