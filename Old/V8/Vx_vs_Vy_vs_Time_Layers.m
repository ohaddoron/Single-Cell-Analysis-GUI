function Vx_vs_Vy_vs_Time_Layers ( folderPath , numOfLayers, layerWidth)


    graphs_data.names = [];
    graphs_data.plot_data = {};
    graphs_data.title = [];
    graphs_data.legend = {};
    
    
    disp(['opening folder ' folderPath]);
    legends = {};
    
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = length(files);
    %mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Time\Images']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Abs\Images']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Sun\Images']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Avg\Images']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Test\Images']);
    
    
    for k = 1:numOfLayers
            graphs_data.labels{k} = [num2str((k-1) * layerWidth) ' - ' num2str(k * layerWidth)];
    end
    graphs_data.labels{k+1} = [num2str((k) * layerWidth) ' < ' ];
    
    
    for i = 1 : num_of_mat_files
        disp(['loading file ' files(i).name]);
        file_path = [folderPath '\' files(i).name];
        temp = load(file_path);
        name = fieldnames(temp);
        At = temp.(name{1});
        tint = At.dt;
        graphs_data.names{i} = files(i).name;
        graphs_data.title{i} = strrep(strrep(graphs_data.names{i},'NNN0',''),'.mat','');
        %graphs_data.legend = [graphs_data.legend;strrep(graphs_data.names{i}(10:29),'NNN0','')];
        lowerScratchLayer = [];
        upperScratchLayer = [];
        for t = 1 : size(At.y_Pos,1)
            [lowerScratch, upperScratch] = scratchDetect(At,t);
            maxPos = nanmax(At.y_Pos(:));
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
        Vx = [];
        Vy = [];
        for t = 1 : size(At.y_Pos,1)
            for k = 1 : (size(lowerScratchLayer,2) - 1)
                VxData = At.Velocity_X(t,:);
                posData = At.y_Pos(t,:);
                dataLow = VxData(posData > lowerScratchLayer(t,k) & posData < lowerScratchLayer(t,k+1));
                dataHigh = VxData(posData < upperScratchLayer(t,k) & posData > upperScratchLayer(t,k+1));     
                Vx{t,k} = [dataLow dataHigh];
                
                VyData = At.Velocity_Y(t,:);
                posData = At.y_Pos(t,:);
                dataLow = VyData(posData > lowerScratchLayer(t,k) & posData < lowerScratchLayer(t,k+1));
                dataHigh = VyData(posData < upperScratchLayer(t,k) & posData > upperScratchLayer(t,k+1));
                Vy{t,k} = [dataLow dataHigh];
            end
        end
        Vx = fliplr(Vx);
        Vy = fliplr(Vy);
        [Row,Col] = size(Vx);
        for k = 1 : Col
            curVx = Vx(:,k);
            curVy = Vy(:,k);
            t = (0:Row-1) * At.dt;
                        
            for kk = 1 : numel(t)
                time{kk} = ones(1,numel(curVx{kk})) * t(kk);
            end
            time = time';
            
            Vxtot{k} = cat(2,curVx{:})';
            Vytot{k} = cat(2,curVy{:})';
            timetot{k} = cat(2,time{:})';
            ztot{k} = k * ones(numel(Vxtot{k}),1);
            
        end
        graphs_data.Vxtot{i} = cat(1,Vxtot{:});
        graphs_data.Vytot{i} = cat(1,Vytot{:});
        graphs_data.timetot{i} = cat(1,timetot{:});
        graphs_data.ztot{i} = cat(1,ztot{:});
        
        
        for k = 1 : Col
            curVx = Vx(:,k);
            curVy = Vy(:,k); 
            
            for kk = 1 : numel(curVx)
                Vxtime(kk) = nanmean(abs(curVx{kk}));
                Vytime(kk) = nanmean(abs(curVy{kk}));
            end
            VTime{k} = [Vxtime' Vytime'];
        end
        graphs_data.Time{i} = VTime;
        
    end

    for i = 1 : num_of_mat_files
        
        
        
        curVxtot = graphs_data.Vxtot{i};
        curVytot = graphs_data.Vytot{i};
        curTimeTot = graphs_data.timetot{i};
        curZTot = graphs_data.ztot{i};
        ax = max([abs(min([cat(1,graphs_data.Vxtot{:}); cat(1,graphs_data.Vytot{:})])) abs(max([cat(1,graphs_data.Vxtot{:}); cat(1,graphs_data.Vytot{:})]))]);
        
        h = figure('Visible','Off');
        
        
        colormap(jet);
        scatter3(curVxtot,curVytot,curZTot,10,curTimeTot,'filled');
        title(graphs_data.title{i});
        xlabel(['Velocity X' Units('Velocity_X')]);
        ylabel(['Velocity Y' Units('Velocity_Y')]);
        zlabel('Distance from scratch [\mum]');
        b = colorbar;
        xlabel(b,'Time [min]');
        
        h.CurrentAxes.XLim = [-ax ax];
        h.CurrentAxes.YLim = [-ax ax];
        
        set(h.CurrentAxes,'ZTickLabel',graphs_data.labels);
        saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Sun\Images\' graphs_data.title{i} '.tiff']);
        saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Sun\' graphs_data.title{i} '.fig']);
    end
    
    close all;
    for i = 1 : num_of_mat_files
        curVxtot = graphs_data.Vxtot{i};
        curVytot = graphs_data.Vytot{i};
        curTimeTot = graphs_data.timetot{i};
        curZTot = graphs_data.ztot{i};
        
        h = figure('Visible','Off');
        colormap(jet);
        scatter3(abs(curVxtot),abs(curVytot),curZTot,10,curTimeTot,'filled');
        title(graphs_data.title{i});
        xlabel(['Velocity X' Units('Velocity_X')]);
        ylabel(['Velocity Y' Units('Velocity_Y')]);
        zlabel('Distance from scratch [\mum]');
        b = colorbar;
        xlabel(b,'Time [min]');
        
        h.CurrentAxes.XLim = [0 ax];
        h.CurrentAxes.YLim = [0 ax];
        
        set(h.CurrentAxes,'ZTickLabel',graphs_data.labels);
        saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Abs\Images\' graphs_data.title{i} '.tiff']);
        saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Abs\' graphs_data.title{i} '.fig']);
    end

    close all;
    for i = 1 : num_of_mat_files
        tTime = [];
        z = [];
        curTime = graphs_data.Time{i};
        zTime = 1 : numel(curTime);
        h = figure('Visible','Off');
        colormap jet;
        
        for ii = 1 : numel(curTime)
            tTime{ii} = 1 : size(curTime{ii},1);
            z{ii} = ones(size(curTime{ii},1),1) * zTime(ii);
            
            
        end
        tTime = cat(2,tTime{:})';
        z = cat(1,z{:});
        c = cat(1,curTime{:});
        X = c(:,1);
        Y = c(:,2);
        scatter3(X,Y,z,40,tTime,'filled')
        ax = max([h.CurrentAxes.XLim h.CurrentAxes.YLim]);
        h.CurrentAxes.XLim = [0 ax];
        h.CurrentAxes.YLim = [0 ax];
        xlabel(['Velocity X' Units('Velocity_X')]);
        ylabel(['Velocity Y' Units('Velocity_Y')]);
        zlabel('Distance from scratch [\mum]');
        b = colorbar;
        xlabel(b,'Time [min]');
        title(graphs_data.title{i});
        set(h.CurrentAxes,'ZTickLabel',graphs_data.labels);
        saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Avg\Images\' graphs_data.title{i} '.tiff']);
        saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Avg\' graphs_data.title{i} '.fig']);
        for j = 1 : max(z)
            h(j) = figure('Visible','Off');
            scatter(X(z==j),Y(z==j),60,tTime(z==j),'filled');
            colormap(jet);
            hcolor = colorbar;
            xlabel(hcolor,'Time [min]');
            xlabel(['Velocity X' Units('Velocity_X')]);
            ylabel(['Velocity Y' Units('Velocity_Y')]);
            title([graphs_data.title{i} ' Layer - ' num2str(j)]);
            
        end
        ax = 0;
        for j = 1 : max(z)
            ax = max([ax abs([h(j).CurrentAxes.XLim h(j).CurrentAxes.YLim])]);
        end
        for j = 1 : max(z)
            h(j).CurrentAxes.XLim = [0 ax];
            h(j).CurrentAxes.YLim = [0 ax];
            saveas(h(j),[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Test\' graphs_data.title{i} 'Layer - ' num2str(j) '.fig']) 
            saveas(h(j),[folderPath '\Velocity_X VsVelocity_Y Vs Time Layers\Test\Images' graphs_data.title{i} 'Layer - ' num2str(j) '.tiff']) 
        end
        
    end
        
        
        
        
    
    
    close all;
end
        
        
function [lowerScratch, upperScratch] = scratchDetect(At,t)
    [counts,centers] = hist(At.y_Pos(t,:));
    counts(counts<10) = 0;
    posCenters = 1:length(counts);
    posCenters = posCenters(counts==0);
    lowerScratch = centers(min(posCenters)-1);
    upperScratch = centers(max(posCenters)+1);
end