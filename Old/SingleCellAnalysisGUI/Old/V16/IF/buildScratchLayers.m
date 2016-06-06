function [scratchLayers,labels]  = buildScratchLayers(scratchLimits, layerWidth ,num_of_layers, pixelResolution , imLimits)

% scratchLimits : An array with two rows, the first represents the
% upper side of the scratch, the second represents the lower side of the
% scratch.
% imLimits : upper and lower limit of the image.

for k = 1:num_of_layers - 1
    labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
end
labels{k+1} = [num2str((k) * layerWidth) ' < ' ];


layerWidth = ceil(layerWidth / pixelResolution);
scratchLayers.Up = scratchLimits(1,:);
scratchLayers.Down = scratchLimits(2,:);
for i = 1 : (num_of_layers-1)
    curLayerUp = scratchLayers.Up(i,:) - layerWidth;
    curLayerDown = scratchLayers.Down(i,:) + layerWidth;
    curLayerUp(curLayerUp < imLimits(1)) = imLimits(1);
    curLayerDown(curLayerDown > imLimits(2)) = imLimits(2);
    
    
    scratchLayers.Up = [scratchLayers.Up; curLayerUp];
    scratchLayers.Down = [scratchLayers.Down; curLayerDown];
end
scratchLayers.Up = [scratchLayers.Up ; repmat(imLimits(1),1,size(scratchLayers.Up,2))];
scratchLayers.Down = [scratchLayers.Down ; repmat(imLimits(2),1,size(scratchLayers.Down,2))];



    
    
    