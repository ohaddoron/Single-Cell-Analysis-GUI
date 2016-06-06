function [intensityRawData,layerLabels,Segementation_Image] = IntensityAnalyzer (filePathDIC,filePathFluo,segmentation_decision,layerWidth,num_of_layers,pixelResolution,meanPixelIntensity)

% Reading the image
dicIM = imread(filePathDIC);
fluoIM = imread(filePathFluo);
% % Substracting the image background
% background = imopen(fluoIM,strel('disk',20));
% fluoIM = fluoIM - background;
% fluoIM = fluoIM - meanPixelIntensity;
% fluoIM(fluoIM<0) = 0;

% Detecting the scratch banks
scratchLimits = scratchDetection (dicIM,segmentation_decision);

% Building layers
imLimits = [1,size(dicIM,1)];
[scratchLayers,layerLabels]  = buildScratchLayers(scratchLimits, layerWidth ,num_of_layers, pixelResolution , imLimits);

% Segementation example
Segementation_Image = figure('Visible','off');
imshow(dicIM);
hold all;
plot(1:size(dicIM,2),scratchLayers.Up,'LineWidth',2);
plot(1:size(dicIM,2),scratchLayers.Down,'LineWidth',2);
axis off;
legend(layerLabels,'Location','NorthWestOutside');
hold off;


% Intensity analysis
for k = 1 : num_of_layers
    intensityRawData{k} = [];
    for i = 1 : size(fluoIM,2)
        rowsTakenFromImage = [scratchLayers.Up(k+1,i) : scratchLayers.Up(k,i) ...
            scratchLayers.Down(k,i) : scratchLayers.Down(k+1,i)];
        intensityRawData{k} = padconcatenation(intensityRawData{k},fluoIM(rowsTakenFromImage),2);
    end
end
    






