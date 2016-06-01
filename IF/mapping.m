clear all; clc; close all;
layerWidth = 40;
numOfLayers = 15;
folderPath = '\\metlab23\MATLAB\Lee\mapping';

flouFileName = [folderPath '\LH001040115CHR1016DA3WHGF1ACT1ARC1NNN0NNN0.tif'];
maskFileName = [folderPath '\LH001040115MASK016DA3WHGF1ACT1ARC1NNN0NNN0.tif'];

flouIM = imread(flouFileName);
maskIM = imread(maskFileName);

B = bwboundaries(maskIM,'noholes');

biggest_area = 0;
for i = 1 : length(B)
    cur_sum = sum(B{i}(:));
    if cur_sum > biggest_area
        biggest_area = cur_sum;
        index = i;
    end
end


boundary.Orig = B{index};
boundary.Top = [];
boundary.Bottom = [];

for i = 1 : size(flouIM,2)
    boundary.Bottom = [boundary.Bottom max(boundary.Orig(boundary.Orig(:,2) == i))];
    boundary.Top = [boundary.Top min(boundary.Orig(boundary.Orig(:,2) == i))];
end

figure;
imagesc(flouIM);
colormap(hot);


hold on;
%plot(boundary.Orig(:,2),boundary.Orig(:,1),'b','LineWidth',2)
for k = 0 : numOfLayers 
    Layer.Bottom(k+1,1:length(boundary.Bottom)) = boundary.Bottom' + (k * layerWidth);
end
for k = 0 : numOfLayers
    Layer.Top(k+1,1:length(boundary.Top)) = boundary.Top' - (k * layerWidth);
end
Layer.Top = [ones(1,size(Layer.Top,2)); Layer.Top ];
Layer.Bottom = [size(flouIM,1) * ones(1,size(Layer.Bottom,2)); Layer.Bottom ];
cmap = winter(size(Layer.Top,1));

for i = 1 : size(Layer.Bottom,1)
    plot(1:size(Layer.Bottom,2),Layer.Bottom(i,:),'Color',cmap(i,:),'LineWidth',1.5);
    plot(1:size(Layer.Top,2),Layer.Top(i,:),'Color',cmap(i,:),'LineWidth',1.5);
end




