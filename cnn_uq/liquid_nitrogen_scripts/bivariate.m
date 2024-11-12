%% Bivariate distribution plotting
% Load the pre-saved data
clc;clear;close all;
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/THRESHOLDING/threshbubblesizes.mat');
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/segbubblesizes.mat');
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/segheatflux.mat');
load('/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/THRESHOLDING/threshheatflux.mat');

% Define common range for bin edges
minBubbleSize = min([min(segbubblesizes) min(threshbubblesizes)]);
maxBubbleSize = max([max(segbubblesizes) max(threshbubblesizes)]);

nbins=100;
ybins=logspace(log10(minBubbleSize),log10(maxBubbleSize),nbins+1);

%% Bivariate (probability) distribution plotting [Segmentation (U-net)]

figure
h=histogram2(segheatflux,segbubblesizes,'YBinEdges',ybins,'normalization','probability','DisplayStyle','bar','FaceColor','flat');
h.EdgeColor = 'k';
colormap('jet')
colorbar
set(gca,'YScale','log')
set(gca,'ZScale','log')
xlabel('Heat Flux (kW/m^2)')
ylabel('Bubble Sizes (px)')
zlabel('Probability')
title('Bivariate distribution of Heat Flux and Bubble Sizes (Segmentation-U-net)')
saveas(gcf,'/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/segbivariate(probability).fig')

% Bivariate (probability) distribution plotting [Thresholding]

figure
h=histogram2(threshheatflux,threshbubblesizes,'YBinEdges',ybins,'normalization','probability','DisplayStyle','bar','FaceColor','flat');
h.EdgeColor = 'k';
colormap('jet')
colorbar
set(gca,'YScale','log')
set(gca,'ZScale','log')
xlabel('Heat Flux (kW/m^2)')
ylabel('Bubble Sizes (px)')
zlabel('Probability')
title('Bivariate distribution of Heat Flux and Bubble Sizes (Thresholding)')
saveas(gcf,'/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/THRESHOLDING/threshbivariate(probability).fig')

% Bivariate (count) distribution plotting [Segmentation (U-net)]

figure
h=histogram2(segheatflux,segbubblesizes,'YBinEdges',ybins,'normalization','count','DisplayStyle','bar','FaceColor','flat');
h.EdgeColor = 'k';
colormap('jet')
colorbar
set(gca,'YScale','log')
set(gca,'ZScale','log')
xlabel('Heat Flux (kW/m^2)')
ylabel('Bubble Sizes (px)')
zlabel('Count')
title('Bivariate distribution of Heat Flux and Bubble Sizes (Segmentation-U-net)')
saveas(gcf,'/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/SEGMENTATION/segbivariate(count).fig')

% Bivariate (count) distribution plotting [Thresholding]

figure
h=histogram2(threshheatflux,threshbubblesizes,'YBinEdges',ybins,'normalization','count','DisplayStyle','bar','FaceColor','flat');
h.EdgeColor = 'k';
colormap('jet')
colorbar
set(gca,'YScale','log')
set(gca,'ZScale','log')
xlabel('Heat Flux (kW/m^2)')
ylabel('Bubble Sizes (px)')
zlabel('Count')
title('Bivariate distribution of Heat Flux and Bubble Sizes (Thresholding)')
saveas(gcf,'/Users/mac/Desktop/New New Latest/Composite tiffs/Plots/BUBBLE DISTRIBUTION/THRESHOLDING/threshbivariate(count).fig')
