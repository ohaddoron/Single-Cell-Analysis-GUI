function handler = Layers(folder_path,par,numOfLayers,layerWidth,scale)
    

    warning('off','all');
    graphs_data.names = [];
    graphs_data.plot_data = {};
    graphs_data.title = [];
    graphs_data.legend = {};
    
    disp(['opening folder ' folder_path]);
    
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    
    %mkdir([folder_path '\Layer Plots\Upper Scratch']);
    %mkdir([folder_path '\Layer Plots\Lower Scratch']);
    
    for i = 1 : num_of_mat_files
        disp(['loading file ' files(i).name]);
        file_path = [folder_path '\' files(i).name];
        temp = load(file_path);
        name = fieldnames(temp);
        At = temp.(name{1});
        tint = At.dt;
        graphs_data.names{i} = files(i).name;
        graphs_data.title{i} = strrep(strrep(graphs_data.names{i},'NNN0',''),'.mat','');
        %graphs_data.legend = [graphs_data.legend;strrep(graphs_data.names{i}(10:29),'NNN0','')];
        lowerScratchLayer = [];
        upperScratchLayer = [];
        for j = 1 : length(par)
            graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean = [];
            graphs_data.plot_data.(graphs_data.title{i}).(par{j}).STDEV = [];
            graphs_data.max.(par{j}) = [];
            for t = 1 : size(At.(par{j}),1)
                
                if j == 1
                    try
                        [lowerScratch, upperScratch] = scratchDetect(At,t);
                    catch
                    end
                    maxPos = nanmax(nanmax(At.y_Pos(:,:)));
                    if size(lowerScratch,2) ~= 0 && size(upperScratch,2) ~= 0
                        lowerLayerWidth = layerWidth;
                        upperLayerWidth = layerWidth;
                        
                        lowerScratchLayer = [lowerScratchLayer; [0 (lowerScratch - numOfLayers*layerWidth):layerWidth:lowerScratch]];
                        upperScratchLayer = [upperScratchLayer; fliplr([upperScratch:layerWidth:(upperScratch+(layerWidth*numOfLayers)) maxPos])];
                    else
                        low = lowerScratchLayer(size(lowerScratchLayer,1),:);
                        up = upperScratchLayer(size(upperScratchLayer,1),:);
                        lowerScratchLayer = [lowerScratchLayer; low];
                        upperScratchLayer = [upperScratchLayer; up];
                    end
                end
                
            end
            for t = 1 : size(At.(par{j}),1)
                for k = 1 : (size(lowerScratchLayer,2) - 1)
                    parData = At.(par{j})(t,:);
                    posData = At.y_Pos(t,:);
                    dataLow = parData(posData > lowerScratchLayer(t,k) & posData < lowerScratchLayer(t,k+1)); 
                    dataHigh = parData(posData < upperScratchLayer(t,k) & posData > upperScratchLayer(t,k+1));
                    data = [dataLow dataHigh];
                    scratchMean(k) = nanmean(data);
                    scratchSTDEV(k) = nanstd(data)./(sum(~isnan(data)).^0.5);
                end
            graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean = [graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean; scratchMean];
            graphs_data.plot_data.(graphs_data.title{i}).(par{j}).STDEV = [graphs_data.plot_data.(graphs_data.title{i}).(par{j}).STDEV; scratchSTDEV];
            graphs_data.max.(par{j}) = [graphs_data.max.(par{j}) nanmax(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean)];
            end
            Ax.(par{j}) = nanmax(graphs_data.max.(par{j})) + 5 * nanstd(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean(:));
        end
    end
    for i = 1 : num_of_mat_files
        for j = 1 : length(par)
            if i == 1
                mkdir([folder_path '\Layers\' par{j}]);
                mkdir([folder_path '\Layers\Images\' par{j}]);
            end
            handler.(par{j})(i) = figure('Visible','Off');
            %handler = figure(j);
            hold on;
            t = (0 : size(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean,1) - 1)' * tint;
            l = size(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean,2);
            time = meshgrid(t,1:l)';
            c = colormap(jet(size(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean,2)));
            for k = 1 : length(c)
                errorbar(time(:,k),graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean(:,k),...
                    graphs_data.plot_data.(graphs_data.title{i}).(par{j}).STDEV(:,k),'Color',c(k,:));
                if i == 1
                    if k < length(c)
                        graphs_data.legend = [graphs_data.legend; num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
                    else
                        graphs_data.legend = [graphs_data.legend; ' > ' num2str((k-1) * layerWidth)];
                    end
                    
                end
            end
            hold off;
            %{
            if scale.choice(1) == 1 && scale.choice(2) == 1
                axis([0 max(max(t)) 0 1])
                axis('manual','auto y');
            end
            if scale.choice(1) == 1 && scale.choice(2) == 0
                axis([0 max(max(t)) scale.Ax(3) scale.Ax(4)]);
            end
            if scale.choice(1) == 0 && scale.choice(2) == 1
                axis([scale.Ax(1) scale.Ax(2) 0 1]);
                axis('manual','auto y');
            end
            if scale.choice(1) == 0 && scale.choice(2) == 0
                axis(scale.Ax);
            end
            %}
            title([graphs_data.title{i} ' - ' par{j}],'FontSize',20);
            xlabel('Time [min]');
            ylabel([par{j} ' ' Units(par{j})]);
            axis([0 max(max(t)) 0 Ax.(par{j})]);
            %axis('manual','auto y');
            handler_legend = legend(fliplr(graphs_data.legend'),'Location','northwestoutside');
            set(handler_legend,'FontSize',6);
            saveas(handler.(par{j})(i),[folder_path '\Layers\Images\' par{j} '\' graphs_data.title{i} ' - ' par{j} '.tiff']);
            saveas(handler.(par{j})(i),[folder_path '\Layers\' par{j} '\' graphs_data.title{i} ' - ' par{j}]);
            Data = [nan(1,size(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean,2)); graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean; ...
                nan(1,size(graphs_data.plot_data.(graphs_data.title{i}).(par{j}).Mean,2)); graphs_data.plot_data.(graphs_data.title{i}).(par{j}).STDEV];
            try
                xlswrite([folder_path '\Layers\Graphs Data - ' graphs_data.title{i}],Data,par{j}); 
            catch
                continue
            end
            
            close all;
            
        end
        close all;
    end
    close all;
    warning('on','all');
end
          

function [lowerScratch, upperScratch] = scratchDetect(At,t)
    [counts,centers] = hist(At.y_Pos(t,:));
    counts(counts<10) = 0;
    posCenters = 1:length(counts);
    posCenters = posCenters(counts==0);
    lowerScratch = centers(min(posCenters)-1);
    upperScratch = centers(max(posCenters)+1);
end
    
    
    