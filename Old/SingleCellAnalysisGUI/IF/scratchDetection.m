function scratchLimits = scratchDetection (dicIM,segmentation_decision)


if segmentation_decision == 0
    % Automatic segementation
    background = imopen(dicIM,strel('disk',15));
    I2 = dicIM - background;
    I3 = imadjust(I2);
    level = 0.5 * graythresh(I3);
    bw = im2bw(I3,level);
    bw = bwareaopen(bw, 50);
    bwb = imfill(bw,'holes');
    bwb = (bwb-1).^2;
    B = bwboundaries(bwb,'noholes');
    [~,index] = biggest_area(B);
else
    % Manual segmentation
    figure;
    imagesc(dicIM);
    colormap(gray);
    h = imfreehand;
    BW = createMask(h);
    B = bwboundaries(BW,'noholes');
    [~,index] = biggest_area(B);
end
b = B{index};
scratchLimits =[];
for i = 1 : size(dicIM,2)
    curCol = b(b(:,2) == i,1);
    cur_scratchLimits = [min(curCol); max(curCol)];
    scratchLimits = [scratchLimits cur_scratchLimits];
end
    

    