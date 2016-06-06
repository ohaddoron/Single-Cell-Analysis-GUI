function IF_fixed_layers_multiple_LeeV2(flouFolderPath,maskFolderPath,pixRes, numOfLayers,layerWidth,outputLocation)
    
    %warning('off','all')
    close all;
    graphs_data.plot_data = {};
    graphs_data.title = {};
    
    mkdir([outputLocation '\Bar\Images\'])
    mkdir([outputLocation '\Box\Images\'])
    %filesDIC = dir([dicFolderPath '\*.tif']);
    filesFlou = dir([flouFolderPath '\*.tif']);
    filesMask = dir([maskFolderPath '\*.tif']);
    for i = 1 : length(filesFlou)
        %dicFileName = [dicFolderPath '\' filesDIC(i).name];
        %disp(['Opening ' filesDIC(i).name]);
        flouFileName = [flouFolderPath '\' filesFlou(i).name];
        %maskFileName = [maskFolderPath '\' filesMask(i).name];
        expCode = strrep(strrep(filesFlou(i).name(19:end),'NNN0',''),'.tif','');
        index = strfind({filesMask.name},expCode);
        maskFileName = [maskFolderPath '\' (filesMask(~isempty(index)).name)];
        
        %disp(['Opening ' filesFlou(i).name]);
        [graphs_data.plot_data{i}, graphs_data.labels{i}] = IF_fixed_layers ...
            (flouFileName,maskFileName,pixRes,numOfLayers,layerWidth);
        graphs_data.title{i} = strrep(strrep([filesFlou(i).name(12:14) filesFlou(i).name(19:end) ],'NNN0',''),'.mat','');
        handler = figure;
        %handler = figure('Visible','Off');
        %xAxis = 1:(length(graphs_data.plot_data{i}.mean));
        hold on;
        bar(graphs_data.plot_data{i}.mean);
        errorbar(graphs_data.plot_data{i}.mean,graphs_data.plot_data{i}.error);
        ylabel('Fluorescence Intensity [Arbitrary Units]');
        title(graphs_data.title{i});
        ax = gca;
        ax.XTick = 1 : length(graphs_data.plot_data{i}.mean)
        set(gca,'XTickLabel',graphs_data.labels{i}) 
        set(ax,'XTickLabel',graphs_data.labels{i}) 
        ax.XTickLabelRotation = 45;
        %{
        hx = get(gca,'XLabel');
        set(hx,'Units','data'); 
        pos = get(hx,'Position'); 
        y = pos(2);
        for j = 1:length(graphs_data.labels{i})
            t(j) = text(xAxis(j),y,graphs_data.labels{i}{j}); 
            t(j).Position = t(j).Position - [0.15 0 0];
        end
        %set(t,'Rotation',30,'HorizontalAlignment','right','FontSize',6); 
        %}
        h = xlabel('Distance From The Scratch [\mum]');
        %pos = get(h,'pos');
        %set(h,'pos',pos-[0 0.45 0]); 
        saveas(handler,[outputLocation '\Bar\Images\' graphs_data.title{i} '.tiff']);  
        saveas(handler,[outputLocation '\Bar\' graphs_data.title{i} '.fig']);  
        close(handler)
        %{
        biggest = 0;
        for ii = 1 : length(graphs_data.plot_data{i}.Raw)
            biggest = max(biggest,length(graphs_data.plot_data{i}.Raw{ii}));
        end
        data = nan(biggest,length(graphs_data.plot_data{i}.Raw));
        for ii = 1 : length(graphs_data.plot_data{i}.Raw)
            data(1:length(graphs_data.plot_data{i}.Raw{ii}),ii) = graphs_data.plot_data{i}.Raw{ii};
        end
        %}
        %handler = figure('Visible','Off');
        %boxplot(data,'labels',graphs_data.labels{i},'notch','on','whisker',1);
        %saveas(handler,[outputLocation '\Box\Images\' graphs_data.title{i} '.tiff']);  
        %saveas(handler,[outputLocation '\Box\' graphs_data.title{i} '.fig']);  
    end  
    close all;
    %warning('on','all')
end
        
    
    

function [Intensity, labels] = IF_fixed_layers (flouFileName,maskFileName,pixRes,numOfLayers,layerWidth)
    
    
    for k = 1:numOfLayers
        labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    layerWidth = layerWidth * pixRes;
    flouIM=imread(flouFileName);
    BW = imread(maskFileName);
    B = bwboundaries(BW,'noholes');
    [~,index] = biggest_area(B);
    boundary.Orig = B{index};
    
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
            Int = double(flouIM(Layer.Bottom(k+1,i) : Layer.Bottom(k,i),i));
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
