folderPath = '\\metlab21\Matlab\Ohad\test';
files = dir([folderPath '\*.tif']);

nFiles = length(files);

for i = 1 : nFiles
    im = imread([folderPath '\' files(i).name]);
    background = imopen(im,strel('disk',15));
    I2 = im - background;
    I3 = imadjust(I2);
    level = 0.5 * graythresh(I3);
    bw = im2bw(I3,level);
    bw = bwareaopen(bw, 50);
    bwb = imfill(bw,'holes');
    bwb = (bwb-1).^2;
    B = bwboundaries(bwb,'noholes');
    [~,index] = biggest_area(B);
    h = figure('Visible','Off');
    imshow(im);
    hold on;
    for j = 1 : length(B)
        plot(B{j}(:,2),B{j}(:,1),'r','LineWidth',2);
    end
    boundary.Orig = B{index};
    saveas(h,['\\metlab21\Matlab\Ohad\test\out' strrep(files(i).name,'tif','tiff')]);
    close(h);
end
    