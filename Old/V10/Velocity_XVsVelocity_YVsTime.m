function Velocity_XVsVelocity_YVsTime(folderPath,concat)

    graphs_data.names = [];
    graphs_data.plot_data = {};
    graphs_data.title = [];
    graphs_data.legend = {};
    graphs_data.min_x = [];
    graphs_data.min_y = [];
    graphs_data.max_x = [];
    graphs_data.max_y = [];
    
    ph = plot(1:10);
%     allLineStyles = set(ph,'LineStyle');
    allMarkers = set(ph,'Marker');
    a = allMarkers;
    a(5) = [];
    a(4) = [];
    a(3) = [];
    a(1) = [];
    a(strcmp(a,'none')) = [];
    
    disp(['opening folder ' folderPath]);
    legends = {};
    
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = length(files);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Time']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Abs']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Sun']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Avg']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Time']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Abs']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Sun']);
    mkdir([folderPath '\Velocity_X VsVelocity_Y Vs Time\Avg']);
    %toPPT('openExisting','\\metlab22\F\ilants2015\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\Old\VXVY.pptx');
    %saveFilename = 'Vx vs Vy vs Time';
    %savePath = [folderPath '\Velocity_X VsVelocity_Y Vs Time'];       
    %toPPT('savePath',savePath,'saveFilename',saveFilename);
    par = {'dt','Velocity_X','Velocity_Y','Velocity_Z','x_Pos','y_Pos','z_Pos'};
    if concat ~= 0
        for i = 1 : num_of_mat_files
            disp(['loading file ' files(i).name]);
            file_path = [folderPath '\' files(i).name];
            temp = load(file_path);
            Atname = fieldnames(temp);
            At = temp.(Atname{1});
            if i == 1
                dt = At.dt;
            end
            for j = 1 : length(par)
                name = strrep([files(i).name(1:5) files(i).name(12:14) files(i).name(19:end)],'.mat','');
                if i == 1
                    names.(par{j}) = [];
                end
                if i ~= 1
                    idx = find(~cellfun(@isempty,strfind(names.(par{j}),name)));
                else
                    idx = [];
                end

                if ~isempty(idx)

                    if size(At.(par{j}),1) > size(graphs_data.data.(par{j}){idx},1) && ~isempty(graphs_data.data.(par{j}){idx})
                        At.(par{j})(size(graphs_data.data.(par{j}){idx},1)+1:end,:) = [];
                    end
                    if size(graphs_data.data.(par{j}){idx},1) > size(At.(par{j}),1) 
                        graphs_data.data.(par{j}){idx}(size(At.(par{j}),1)+1:end,:) = [];
                    end
                    graphs_data.data.(par{j}){idx} = [graphs_data.data.(par{j}){idx} At.(par{j})];
                else
                    try
                        graphs_data.data.(par{j}){end+1} = At.(par{j});
                        names.(par{j}){end+1} = name;
                    catch
                        graphs_data.data.(par{j}){1} = At.(par{j});
                        names.(par{j}){1} = name;
                    end
                        
                end
            end
        end
        for j = 1 : numel(par)
            idx = find(cellfun(@isempty,graphs_data.data.(par{j})));
            graphs_data.data.(par{j})(idx) = [];
            names.(par{j})(idx) = [];
        end
    end
    
    if concat == 0
        len = num_of_mat_files;
    else
        len = numel(graphs_data.data.Velocity_X);
    end
    
    for i = 1 : len
        Vxtime{i} = [];
        Vytime{i} = [];
        disp(['loading file ' files(i).name]);
        legends{i} = strrep(strrep([files(i).name(1:5) files(i).name(12:14) files(i).name(19:end)],'NNN0',''),'.mat','');
        filePath = [folderPath '\' files(i).name];
        temp = load(filePath);
        name = fieldnames(temp);
        graphs_data.title{i} = strrep(strrep([files(i).name(12:14) files(i).name(19:end)],'NNN0',''),'.mat','');
        
        
        if concat == 0
            data = temp.(name{1});
        else
            data.Velocity_X = graphs_data.data.Velocity_X{i};
            data.Velocity_Y = graphs_data.data.Velocity_Y{i};
            data.Velocity_Z = graphs_data.data.Velocity_Z{i};
            data.x_Pos = graphs_data.data.x_Pos{i};
            data.y_Pos = graphs_data.data.y_Pos{i};
            data.z_Pos = graphs_data.data.z_Pos{i};
            data.dt = graphs_data.data.dt{i};
            data.dt = data.dt(1);
            graphs_data.title{i} = strrep(names.Velocity_X{i},'NNN0','');
        end
        [Row,Col] = size(data.x_Pos);
        
        t = (0:Row-1) * data.dt;
        [~,time] = meshgrid(1:Col,t);
        timetot{i} = time(:);
        %r = floor(rand(1,200)* size(data.x_Pos,2));
        %r(r==0) = 1;
        %{
        [~, firstIdxs] = max(~isnan(data.Velocity_X));
        Vxfirst = diag(data.Velocity_X(firstIdxs,1:size(data.Velocity_X,2)));
        Vyfirst = diag(data.Velocity_Y(firstIdxs,1:size(data.Velocity_Y,2)));
        [Vxtottemp,~] = meshgrid(Vxfirst,1:size(data.Velocity_X,1));
        [Vytottemp,~] = meshgrid(Vyfirst,1:size(data.Velocity_X,1));
        Vxtottemp = data.Velocity_X - Vxtottemp;
        Vytottemp = data.Velocity_Y - Vytottemp;
        %}
        Vxtot{i} = data.Velocity_X(:);
        Vytot{i} = data.Velocity_Y(:);
        
        
        
        timetot{i}(isnan(Vxtot{i})) = [];
        Vxtot{i}(isnan(Vxtot{i})) = [];
        Vytot{i}(isnan(Vytot{i})) = [];
        Vxtime{i} = [Vxtime{i} nanmean(abs(data.Velocity_X),2)];
        Vytime{i} = [Vytime{i} nanmean(abs(data.Velocity_Y),2)];
        
        graphs_data.min_x = [graphs_data.min_x nanmin(Vxtot{i})];
        graphs_data.min_y = [graphs_data.min_x nanmin(Vytot{i})];
        graphs_data.max_x = [graphs_data.max_x nanmax(Vxtot{i})];
        graphs_data.max_y = [graphs_data.max_y nanmax(Vytot{i})];
    end
    Ax = max([abs(mean(graphs_data.min_x)-0*std(graphs_data.min_x)),...
                abs((mean(graphs_data.max_x)+0*std(graphs_data.max_x))),...
                abs((mean(graphs_data.min_y)-0*std(graphs_data.min_y))),...
                abs((mean(graphs_data.max_y)+0*std(graphs_data.max_y)))]);
    
    for i = 1 : len
        handler(i) = figure('Visible','Off');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        %cm = flipud(colormap(jet));
        cm = colormap(jet);
        colormap(cm);
        scatter(Vxtot{i},Vytot{i},5,timetot{i},'filled');
        title(['Vy vs Vx Sun - ' graphs_data.title{i}]);
        xlabel(['Velocity X ' Units('Velocity_X')]);
        ylabel(['Velocity Y ' Units('Velocity_Y')]);
        hcolor = colorbar;
        xlabel(hcolor,'Time [min]');
        ax = gca;
        maxax = max([ax.XLim,ax.YLim]);
        axis([-Ax Ax -Ax Ax]);
        saveas(handler(i),[folderPath '\Velocity_X VsVelocity_Y Vs Time\Sun\' strrep(strrep(files(i).name,'NNN0',''),'.mat','')]);
        saveas(handler(i),[folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Sun\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.tiff']);
        %toPPT(handler(i),'SlideNumber',1)
        close all;
        
        handler(i) = figure('Visible','Off');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        %cm = flipud(colormap(jet));
        cm = colormap(jet);
        scatter(abs(Vxtot{i}),abs(Vytot{i}),5,timetot{i},'filled');
        title(['Vy vs Vx Absolute - ' graphs_data.title{i}]);
        xlabel(['Velocity X ' Units('Velocity_X')]);
        ylabel(['Velocity Y ' Units('Velocity_Y')]);
        hcolor = colorbar;
        xlabel(hcolor,'Time [min]');
        ax = gca;
        maxax = max([ax.XLim,ax.YLim]);
        axis([0 Ax 0 Ax]);
        saveas(handler(i),[folderPath '\Velocity_X VsVelocity_Y Vs Time\Abs\' strrep(strrep(files(i).name,'NNN0',''),'.mat','')]);
        saveas(handler(i),[folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Abs\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.tiff']);
        close all;
        
       
        handler(i) = figure('Visible','Off');
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        %cm = flipud(colormap(jet));
        cm = colormap(jet);
        t = (0:length(Vxtime{i})-1) * data.dt;
        scatter(Vxtime{i},Vytime{i},70,t,'filled');
        title(['Vy vs Vx average over time - ' graphs_data.title{i}]);
        xlabel(['Velocity X ' Units('Velocity_X')]);
        ylabel(['Velocity Y ' Units('Velocity_Y')]);
        hcolor = colorbar;
        xlabel(hcolor,'Time [min]');
        ax = gca;
        maxax = max([ax.XLim,ax.YLim]);
        axis([0 Ax/5 0 Ax/5]);
        saveas(handler(i),[folderPath '\Velocity_X VsVelocity_Y Vs Time\Time\' strrep(strrep(files(i).name,'NNN0',''),'.mat','')]);
        saveas(handler(i),[folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Time\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.tiff']);
        %toPPT(h(i),'SlideNumber',2)
        close all;
        
        
    end
    try
        Vxtime = cell2mat(Vxtime);
        Vytime = cell2mat(Vytime);
    catch
        Vxtimetemp = [];
        Vytimetemp = [];
        for i = 1 : numel(Vxtime)
             if numel(Vxtime{i}) > size(Vxtimetemp,1) && size(Vxtimetemp,1) ~= 0
                 Vxtime{i}(size(Vxtimetemp,1)+1:end) = [];
                 Vytime{i}(size(Vxtimetemp,1)+1:end) = [];
             end
             if numel(Vxtime{i}) < size(Vxtimetemp,1)
                 Vxtimetemp(numel(Vxtime{i}) + 1 : end,:) = [];
                 Vytimetemp(numel(Vytime{i}) + 1 : end,:) = [];
             end
             Vxtimetemp = [Vxtimetemp Vxtime{i}];
             Vytimetemp = [Vytimetemp Vytime{i}];
             
        end
        Vxtime = Vxtimetemp;
        Vytime = Vytimetemp;
    end
    
                
    [Row,Col] = size(Vxtime);
    t = (0:Row-1) * data.dt;
    [~,time] = meshgrid(1:Col,t);
    time = time';
    h = figure('Visible','Off');
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    
%     cmap = jet(size(Vxtime,2));
    mm = 1;
    colormap(jet);
    hold all
    for m = 1 : size(Vxtime,2)
        if mm > numel(a)
          mm = 1;
        end
        s = scatter(Vxtime(:,m),Vytime(:,m),40,t,a{mm},'filled');
        s.MarkerEdgeColor = [1 1 1];
        mm = mm + 1;
    end
    hcolor = colorbar;
    xlabel(hcolor,'Time [min]');
    hold off;
%     for i = 1 : size(Vxtime,2)
%         scatter(Vxtime(:,i),Vytime(:,i),20,cmap(i,:),'filled');
%     end

    
    Data = [nan(1,size(Vxtime,2)*2 + 1); [Vxtime nan(size(Vxtime,1),1) Vytime]];
    xlswrite([folderPath '\Velocity_X VsVelocity_Y Vs Time\Graphs Data'],Data,'Avg over Time');
    t1 = {'Vx'};
    t2 = {'Vy'};
    headers = [[graphs_data.title nan graphs_data.title]; [repmat(t1,[1 size(Vxtime,2)]) nan repmat(t2,[1 size(Vxtime,2)])]];
    xlswrite([folderPath '\Velocity_X VsVelocity_Y Vs Time\Graphs Data'],headers,'Avg over Time')
    title('Vy vs Vx');
    xlabel(['Velocity X ' Units('Velocity_X')]);
    ylabel(['Velocity Y ' Units('Velocity_Y')]);
    legend(legends,'Location','northwestoutside');
    minax = min([h.CurrentAxes.XLim,h.CurrentAxes.YLim]);
    maxax = max([h.CurrentAxes.XLim,h.CurrentAxes.YLim]);
    h.CurrentAxes.XLim = [minax maxax];
    h.CurrentAxes.YLim = [minax maxax];
%     axis([0 Ax/4 0 Ax/4]);
%     axis tight
    
    %toPPT(h,'SlideNumber',3);
    saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time\Avg\Vy vs Vx']);
    saveas(h,[folderPath '\Velocity_X VsVelocity_Y Vs Time\Images\Avg\Vy vs Vx.tiff']);
    
    %toPPT('savePath',savePath,'saveFilename',saveFilename);
    %toPPT('close',1);
end
        
        