function Bin ( folderPath, outputLocation )

    files = dir([folderPath '\*.tif']);
    
    num_of_imgs = length(files);
    
    disp(['Opening ' folderPath]);
    mkdir([outputLocation '\Bin']);
    for i = 1 : num_of_imgs
        filePath = [folderPath '\' files(i).name];
        img = imread(filePath);
        img_new = ndnanfilter(img,'rectwin',[6 6]);
        h = figure('Visible','Off');
        colormap(hot);
        imagesc(img_new);
        %saveas(h,[folderPath '\Bin\Images\' strrep(files(i).name,'.tif','.tiff')]);
        %saveas(h,[folderPath '\Bin\' strrep(files(i).name,'.tif','.fig')]);
        
        
        imwrite(img_new,hot(256),[outputLocation '\Bin\' files(i).name]);
        close all;
    end
end
        