function [retData, retLabels] = IF_fixed_layers_multiple(dicFolderPath,floFolderPath,pixRes, numOfLayers,layerWidth,outputLocation,MA)
    
    warning('off','all')
    %close all;
    graphs_data.plot_data = {};
    graphs_data.title = {};
    
    mkdir([outputLocation '\Bar\Images']);
    mkdir([outputLocation '\Box\Images'])
    filesDIC = dir([dicFolderPath '\*.tif']);
    filesflo = dir([floFolderPath '\*.tif']);
    for i = 1 : length(filesflo)
        dicFileName = [dicFolderPath '\' filesDIC(i).name];
        disp(['Opening ' filesDIC(i).name]);
        floFileName = [floFolderPath '\' filesflo(i).name];
        disp(['Opening ' filesflo(i).name]);
        [graphs_data.plot_data, graphs_data.labels{i}] = IF_fixed_layers ...
            (dicFileName,floFileName,pixRes,numOfLayers,layerWidth,outputLocation,i,MA);
        graphs_data.title{i} = strrep(strrep(strrep(strrep(filesflo(i).name,'NNN0',''),'.tif',''),'GFP',''),'_',' ');
        
        Raw = graphs_data.plot_data.Raw;
        Data = [];
        for ii = 1 : length(Raw)
            if length(Raw{ii}) > size(Data,1)
                Data = [Data; nan(length(Raw{ii}) - size(Data,1),size(Data,2))];
            else
                Raw{ii} = [Raw{ii}; nan(size(Data,1) - length(Raw{ii}),length(Raw{ii}))];
            end
            Data = [Data Raw{ii}'];
        end;
        try        
            [p,~,~] = anova1(Data,graphs_data.labels{i},'off');
        catch 
            p = nan;
        end
        h_box = figure('Visible','Off');
        boxplot(Data,graphs_data.labels{i},'notch','on');
        set(h_box.CurrentAxes,'XTickLabelRotation',45);
        ylabel('Fluorescence Intensity [Arbitrary Units]');
        title(graphs_data.title{i});
        xlabel('Distance From The Scratch [\mum]');
        saveas(h_box,[outputLocation '\Box\Images\' graphs_data.title{i} '.tiff']);
        saveas(h_box,[outputLocation '\Box\' graphs_data.title{i} '.fig']);
        close(h_box);
        
        %handler = figure;
        handler = figure('Visible','Off');
        xAxis = 1:length(graphs_data.plot_data.mean);
        hold on;
        bar(xAxis,graphs_data.plot_data.mean);
        errorbar(xAxis,graphs_data.plot_data.mean,graphs_data.plot_data.error,'.');
        ylabel('Fluorescence Intensity [Arbitrary Units]');
        title(graphs_data.title{i});
        set(gca,'XTick',1:length(graphs_data.labels{i}));
        set(gca,'XTickLabel',graphs_data.labels{i});
        set(gca,'XTickLabelRotation',45);
        if p <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p);
        end
        text(0.82,1,['p value = ' Pvalue],'Units','normalized','FontSize',14)
        xlabel('Distance From The Scratch [\mum]');
        
        saveas(handler,[outputLocation '\Bar\Images\' graphs_data.title{i}],'tiff');  
        saveas(handler,[outputLocation '\Bar\' graphs_data.title{i} '.fig']);  
        close(handler);
        retData{i} = graphs_data.plot_data.mean;
        retLabels{i} = graphs_data.title;
    end  
    %close all;
    warning('on','all')
end

function [Intensity, labels] = IF_fixed_layers (dicFileName, floFileName , pixRes , numOfLayers , layerWidth,outputLocation,i,MA)
    
    
    floIM = imread(floFileName);
    dicIM = imread(dicFileName);
    for k = 1:numOfLayers
            labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    layerWidth = layerWidth * pixRes;
    
    
    if MA == 1 
        figure;
        imagesc(dicIM);
        colormap(gray);
        h = imfreehand;
        BW = createMask(h);
        B = bwboundaries(BW,'noholes');
        [~,index] = biggest_area(B);
    else
        % Automatic Segmentation
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
    end

    h = figure('Visible','Off');
    imshow(dicIM);
    hold on;
    plot(B{index}(:,2),B{index}(:,1),'r','LineWidth',2);
    boundary.Orig = B{index};
    saveas(h,['\\metlab21\Matlab\Ohad\Yossi\EXP 50\' num2str(i) '.tiff']);
    close(h);

    boundary.Orig = B{index};
    boundary.Top = [];
    boundary.Bottom = [];
    for i = 1 : size(floIM,2)
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
    Layer.Top = flipud([size(floIM,1) * ones(1,size(Layer.Top,2)); Layer.Top]);
    Layer.Top(Layer.Top <= 1) = 1;
    Layer.Bottom(Layer.Bottom <=1) = 1;
    Layer.Top(Layer.Top >= size(dicIM,1)) = size(dicIM,1);
    Layer.Bottom(Layer.Bottom >= size(dicIM,1)) = size(dicIM,1);
    for k = 1 : size(Layer.Top,1) - 1
        intens = [];
        for i = 1 : size(Layer.Top,2)
            try
                Int = double(floIM(Layer.Top(k,i) : Layer.Top(k+1,i),i));
                intens = [intens (Int(:))'];
            catch 
                Intensity.Raw = [];
                Intensity.mean = [];
                Intensity.error = [];
                return;
            end
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
                Int = double(floIM(Layer.Bottom(k+1,i) : Layer.Bottom(k,i),i));
                intens = [intens (Int(:))'];
            catch 
                Intensity.Raw = [];
                Intensity.mean = [];
                Intensity.error = [];
            return;
            end
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
    close all;
end


%{
function [Intensity,labels] = IF_layers_manual(dicFileName,floFileName,pixRes, numOfLayers , layerWidth,outputLocation)
    
    for k = 1:numOfLayers
        labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    layerWidth = layerWidth * pixRes;
    
    dicIM=imread(dicFileName);
    floIM=imread(floFileName);
    
    %close all;
    imshow(dicIM);
    h = imfreehand;
    bwb = createMask(h);
    
    B = bwboundaries(bwb,'noholes');
    [~,index] = biggest_area(B);
    
    
    imshow(bwb);
    hold on;
    plot(B{index}(:,2),B{index}(:,1),'r','LineWidth',2);
    boundary.Orig = B{index};
    
    for i = 1 : size(floIM,2)
        
    end
    boundary.Top = [];
    boundary.Bottom = [];
    for i = 1 : size(floIM,2)
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
    Layer.Top = flipud([size(floIM,1) * ones(1,size(Layer.Top,2)); Layer.Top]);
    for k = 1 : size(Layer.Top,1) - 1
        intens = [];
        for i = 1 : size(Layer.Top,2)
            Int = double(floIM(Layer.Top(k,i) : Layer.Top(k+1,i),i));
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
            Int = double(floIM(Layer.Bottom(k+1,i) : Layer.Bottom(k,i)));
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
    
    
    
%}    
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

