function [retData, retLabels] = IF_fixed_layers_multiple_LeeV3(flouFolderPath,maskFolderPath,pixRes, numOfLayers,layerWidth,outputLocation)
    
    warning('off','all')
    close all;
    graphs_data.plot_data = {};
    graphs_data.title = {};
    
    mkdir([outputLocation '\Bar\Images'])
    mkdir([outputLocation '\Box\Images']);
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
        [graphs_data.plot_data, graphs_data.labels] = IF_fixed_layers ...
            (flouFileName,maskFileName,pixRes,numOfLayers,layerWidth);
        graphs_data.title = strrep(strrep([filesFlou(i).name(12:14) filesFlou(i).name(19:end) ],'NNN0',''),'.tif','');
        %handler = figure;
        
        
        Raw = graphs_data.plot_data.Raw;
        a = 1001;
        Raw_new = [];
        for ii = 1 : length(Raw)
            tmp = [];
            curData = Raw{ii};
            for iii = 1 : length(curData)/a : (length(curData) - length(curData)/a)
                tmp = [tmp mean(curData(iii:iii+length(curData)/a),2)];
            end
            Raw_new = [Raw_new tmp'];
        end
        graphs_data.plot_data.mean = mean(Raw_new,1);
        graphs_data.plot_data.error = std(Raw_new,0,1)./(sum(~isnan(Raw_new)).^ 0.5);
        
        handler = figure('Visible','Off');
        %handler = figure;
        xAxis = 1:(length(graphs_data.plot_data.mean));
        hold on;
        bar(xAxis,graphs_data.plot_data.mean);
        errorbar(xAxis,graphs_data.plot_data.mean,graphs_data.plot_data.error);
        ax = gca;
        ax.XTick = xAxis;
        ax.XTickLabel = graphs_data.labels;
        ax.XTickLabelRotation = 45;
        ylabel('Fluorescence Intensity [Arbitrary Units]');
        title(graphs_data.title);
        xlabel('Distance From The Scratch [\mum]');
        
        [p,~,~] = anova1(Raw_new,graphs_data.labels,'off');
        h_box = figure('Visible','Off');
        boxplot(Raw_new,graphs_data.labels,'notch','on');
        set(h_box.CurrentAxes,'XTickLabelRotation',45);
        ylabel('Fluorescence Intensity [Arbitrary Units]');
        title(graphs_data.title);
        xlabel('Distance From The Scratch [um]');
        title(graphs_data.title);
        saveas(h_box,[outputLocation '\Box\Images\' graphs_data.title '.tiff']);
        saveas(h_box,[outputLocation '\Box\' graphs_data.title '.fig']);
        close(h_box);
        set(0,'CurrentFigure',handler);
        %ax1 = axes('Position',[0 0 1 1],'Visible','off');
        %axes(ax1);
        if p <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p);
        end
        text(0.82,1,['p value = ' Pvalue],'Units','normalized','FontSize',14)
        
        saveas(handler,[outputLocation '\Bar\Images\' graphs_data.title '.tiff']);  
        saveas(handler,[outputLocation '\Bar\' graphs_data.title '.fig']);  
        retData{i} = graphs_data.plot_data.mean;
        retLabels{i} = graphs_data.title;
    end  
    close all;
    warning('on','all')
end
        
    
    

function [Intensity, labels] = IF_fixed_layers (flouFileName,maskFileName,pixRes,numOfLayers,layerWidth)
    
    % boundary(:,2) - x positions
    % boundary(:,1) - y positions
    
    
    for k = 1:numOfLayers
        labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    layerWidth = layerWidth * pixRes;
    flouIM=imread(flouFileName);
    BW = imread(maskFileName);
    B = bwboundaries(BW,'noholes');
    [~,index] = biggest_area(B);
    boundary = B{index};
    
    
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
    close all;
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
