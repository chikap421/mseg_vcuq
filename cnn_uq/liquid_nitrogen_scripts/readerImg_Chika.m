clc; clear; close all;
% Thresholding Images
for k=1:21
    load(['/Users/mac/Dropbox (MIT)/RED LAB/Second data from Florian/Thresholding/METRICS_21749_v2512_' num2str(k) '.mat'])
    figure;
    for i = 1:2000:2000
        imagesc(pir_metrics.dim3.id_map(:,:,i));
        axis equal
        axis off
        path = ['/Users/mac/Library/CloudStorage/OneDrive-Personal/RED LAB/Image analysis/Image Data/Current/Second data from Florian/Thresholding/img_' num2str(k) '_' num2str(i) '.tiff'] ;
        export_fig (path);
        pause (0.01)
    end
end
close all
%% Camera Images
for k = 16
    load(['C:\Users\dell g3\Dropbox (MIT)\RAW_DATA\First data from Florian\Camera Images\pre_21749_v2512_' num2str(k) '.mat'])
    figure;
    for i = 1901
        imagesc(img_preTEST(:,:,i))
        axis equal
        axis off
        path = ['C:\Users\dell g3\OneDrive\New folder\img_' num2str(k) '_' num2str(i) '.tiff'] ;
        export_fig (path);
        pause (0.01)
    end
end
% close all