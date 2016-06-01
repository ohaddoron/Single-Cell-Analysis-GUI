function IF_fixed_layers_multiple(dicFolderPath,flouFolderPath,pixRes, numOfLayers,layerWidth,outputLocation)
    
    warning('off','all')
    close all;
    graphs_data.plot_data = {};
    graphs_data.title = {};
    
    mkdir([outputLocation '\Images'])
    filesDIC = dir([dicFolderPath '\*.tif']);
    filesFlou = dir([flouFolderPath '\*.tif']);
    for i = 1 : length(filesFlou)
        dicFileName = [dicFolderPath '\' filesDIC(i).name];
        disp(['Opening ' filesDIC(i).name]);
        flouFileName = [flouFolderPath '\' filesFlou(i).name];
        disp(['Opening ' filesFlou(i).name]);
        [graphs_data.plot_data, graphs_data.labels{i}] = IF_fixed_layers ...
            (dicFileName,flouFileName,pixRes,numOfLayers,layerWidth,outputLocation);
        graphs_data.title{i} = strrep(strrep(strrep(strrep(filesFlou(i).name,'NNN0',''),'.tif',''),'GFP',''),'_',' ');
        %handler = figure(i);
        handler = figure('Visible','Off');
        xAxis = 0:(length(graphs_data.plot_data.mean)-1);
        hold on;
        bar(xAxis,graphs_data.plot_data.mean);
        errorbar(xAxis,graphs_data.plot_data.mean,graphs_data.plot_data.error,'.');
        ylabel('Fluorescence Intensity [Arbitrary Units]');
        title(graphs_data.title{i});
        set(gca,'XTick',1:length(graphs_data.labels));
        set(gca,'XTickLabel',graphs_data.labels{i});
        set(gca,'XTickLabelRotation',45);
        
        xlabel('Distance From The Scratch [\mum]');
        
        saveas(handler,[outputLocation '\Images\' graphs_data.title{i}],'tiff');  
        saveas(handler,[outputLocation '\' graphs_data.title{i} '.fig']);  
        close(handler);
    end  
    close all;
    warning('on','all')
end

function [Intensity, labels] = IF_fixed_layers (dicFileName, flouFileName , pixRes , numOfLayers , layerWidth,outputLocation)
    
    I = imread(dicFileName);
    flouIM = imread(flouFileName);
    for k = 1:numOfLayers
            labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    layerWidth = layerWidth * pixRes;
    
    background = imopen(I,strel('disk',15));
    I2 = I - background;
    I3 = imadjust(I2);
    level = graythresh(I3);
    bw = im2bw(I3,level);
    bw = bwareaopen(bw, 50);
    bwb = imfill(bw,'holes');
    bwb = (bwb-1).^2;
    B = bwboundaries(bwb,'noholes');
    [~,index] = biggest_area(B);
    
    
    imshow(bwb);
    hold on;
    plot(B{index}(:,2),B{index}(:,1),'r','LineWidth',2);
    boundary.Orig = B{index};
    
    for i = 1 : size(flouIM,2)
        
    end
    boundary.Top = [];
    boundary.Bottom = [];
    for i = 1 : size(flouIM,2)
        boundary.Top = [boundary.Top max(boundary.Orig(boundary.Orig(:,2) == i))];
        boundary.Bottom = [boundary.Bottom min(boundary.Orig(boundary.Orig(:,2) == i))];
    end
    for k = 0 : numOfLayers 
        Layer.Bottom(k+1,1:length(boundary.Bottom)) = boundary.Bottom' + (k * layerWidth);
    end
    for k = 0 : numOfLayers
        Layer.Top(k+1,1:length(boundary.Top)) = boundary.Top' - (k * layerWidth);
    end
    Layer.Bottom = flipud([ones(1,size(Layer.Bottom,2)); Layer.Bottom]);
    Layer.Top = flipud([size(flouIM,1) * ones(1,size(Layer.Top,2)); Layer.Top]);
    for k = 1 : size(Layer.Top,1) - 1
        intens = [];
        for i = 1 : size(Layer.Top,2)
            Int = double(flouIM(Layer.Top(k,i) : Layer.Top(k+1,i),i));
            intens = [intens (Int(:))'];
        end
        try
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        catch
            Intensity.Raw{k} = [];
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        end
    end
    for k = 1 : size(Layer.Bottom,1) - 1
        intens = [];
        for i = 1 : size(Layer.Bottom,2)
            try
                Int = double(flouIM(Layer.Bottom(k+1,i) : Layer.Bottom(k,i),i));
            catch
                [~,flouName,flouExt] = fileparts(flouFileName);
                [~,dicName,dicExt] = fileparts(dicFileName);
                mkdir([outputLocation '\Problems\DIC']);
                mkdir([outputLocation '\Problems\Flou']);
                close all;
                copyfile(flouFileName,[outputLocation '\Problems\Flou\' flouName flouExt]);
                copyfile(dicFileName,[outputLocation '\Problems\DIC\' dicName dicExt]);
                [Intensity,labels] = IF_layers_manual(dicFileName,flouFileName,pixRes, numOfLayers , layerWidth,outputLocation);
                return
                
            end
            intens = [intens (Int(:))'];
        end
        try
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        catch
            Intensity.Raw{k} = [];
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        end
    end
    for k = 1 : length(Intensity.Raw)
        Intensity.mean(k) = mean(Intensity.Raw{k});
        Intensity.error(k) = std(Intensity.Raw{k}) ./ (sum(~isnan(Intensity.Raw{k})) .^0.5);
    end

end


function [Intensity,labels] = IF_layers_manual(dicFileName,flouFileName,pixRes, numOfLayers , layerWidth,outputLocation)
    
    for k = 1:numOfLayers
        labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    layerWidth = layerWidth * pixRes;
    
    dicIM=imread(dicFileName);
    flouIM=imread(flouFileName);
    
    close all;
    imshow(dicIM);
    h = imfreehand;
    bwb = createMask(h);
    
    B = bwboundaries(bwb,'noholes');
    [~,index] = biggest_area(B);
    
    
    imshow(bwb);
    hold on;
    plot(B{index}(:,2),B{index}(:,1),'r','LineWidth',2);
    boundary.Orig = B{index};
    
    for i = 1 : size(flouIM,2)
        
    end
    boundary.Top = [];
    boundary.Bottom = [];
    for i = 1 : size(flouIM,2)
        boundary.Top = [boundary.Top max(boundary.Orig(boundary.Orig(:,2) == i))];
        boundary.Bottom = [boundary.Bottom min(boundary.Orig(boundary.Orig(:,2) == i))];
    end
    for k = 0 : numOfLayers 
        Layer.Bottom(k+1,1:length(boundary.Bottom)) = boundary.Bottom' + (k * layerWidth);
    end
    for k = 0 : numOfLayers
        Layer.Top(k+1,1:length(boundary.Top)) = boundary.Top' - (k * layerWidth);
    end
    Layer.Bottom = flipud([ones(1,size(Layer.Bottom,2)); Layer.Bottom]);
    Layer.Top = flipud([size(flouIM,1) * ones(1,size(Layer.Top,2)); Layer.Top]);
    for k = 1 : size(Layer.Top,1) - 1
        intens = [];
        for i = 1 : size(Layer.Top,2)
            Int = double(flouIM(Layer.Top(k,i) : Layer.Top(k+1,i),i));
            intens = [intens (Int(:))'];
        end
        try
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        catch
            Intensity.Raw{k} = [];
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        end
    end
    for k = 1 : size(Layer.Bottom,1) - 1
        intens = [];
        for i = 1 : size(Layer.Bottom,2)
            Int = double(flouIM(Layer.Bottom(k+1,i) : Layer.Bottom(k,i)));
            intens = [intens (Int(:))'];
        end
        try
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        catch
            Intensity.Raw{k} = [];
            Intensity.Raw{k} = [Intensity.Raw{k} intens];
        end
    end
    for k = 1 : length(Intensity.Raw)
        Intensity.mean(k) = mean(Intensity.Raw{k});
        Intensity.error(k) = std(Intensity.Raw{k}) ./ (sum(~isnan(Intensity.Raw{k})) .^0.5);
    end
end
    
    
    
    
function [biggest_area,index] = biggest_area(B)
biggest_area = 0;
for i = 1 : length(B)
    cur_sum = sum(B{i}(:));
    if cur_sum > biggest_area
        biggest_area = cur_sum;
        index = i;
    end
end
end

