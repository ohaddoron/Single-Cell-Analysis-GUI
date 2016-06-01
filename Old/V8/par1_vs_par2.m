function par1_vs_par2 (folderPath , par1 , par2)

          
    
    warning('off','all');
    disp(['opening folder ' folderPath]);
    
    
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = numel(files);
    
    
    for i = 1 : num_of_mat_files
        
        
        legends{i} = strrep(strrep([files(i).name(1:5) files(i).name(12:14) files(i).name(19:end)],'.mat',''),'NNN0','');
        
        disp(['Loading file ' files(i).name]);
        temp = load([folderPath '\' files(i).name]);
        name = fieldnames(temp);
        At = temp.(name{1});
        
        for j = 1 : numel(par1)
            
            try
                data_struct.par1.(par1{j}) = [data_struct.par1.(par1{j}) nanmean(At.(par1{j}),2)];
            catch
                data_struct.par1.(par1{j}) = nanmean(At.(par1{j}),2);
            end
            
            data.par1 = At.(par1{j});
            [Row,Col] = size(At.(par1{j}));
            t = (0:Row-1) * At.dt;
            [~,time] = meshgrid(1:Col,t);
            for k = 1 : numel(par2)
                mkdir([folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Sun\Images']);
                mkdir([folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Abs\Images']);
                mkdir([folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Time\Images']);
                mkdir([folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg\Images']);
                curData = data.par1(:);
                curData = [curData At.(par2{k})(:) time(:)];
                curData(sum(isnan(curData),2) > 0,:) = [];
                h = figure('Visible','Off');
                %h = figure;
                colormap(jet);
                scatter(curData(:,1),curData(:,2),5,curData(:,3),'filled');
                hcolor = colorbar;
                xlabel(hcolor,'Time [min]');
                xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
                ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
                ax = max(abs([h.CurrentAxes.XLim h.CurrentAxes.YLim]));
                h.CurrentAxes.XLim = [-ax,ax];
                h.CurrentAxes.YLim = [-ax,ax];
                titleName = strrep(strrep(files(i).name,'NNN0',''),'.mat','');
                title(titleName);
                savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Sun\' titleName '.fig']);
                %saveas(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Sun\Images\' titleName '.tif']); 
                
                
                h = figure('Visible','Off');
                %h = figure;
                colormap(jet);
                scatter(abs(curData(:,1)),abs(curData(:,2)),5,curData(:,3),'filled');
                hcolor = colorbar;
                xlabel(hcolor,'Time [min]');
                xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
                ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
                h.CurrentAxes.XLim = [0,ax];
                h.CurrentAxes.YLim = [0,ax];
                title(titleName);
                savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Abs\' titleName '.fig']);
                %saveas(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Abs\Images\' titleName '.tif']); 
                
                
                
                
                meanData = [nanmean(abs(At.(par1{j})),2) nanmean(abs(At.(par2{k})),2) t'];
                meanData(sum(isnan(meanData),2)>0,:) = [];
                h = figure('Visible','Off');
                colormap(jet);
                scatter(meanData(:,1),meanData(:,2),20,meanData(:,3),'filled');
                hcolor = colorbar;
                xlabel(hcolor,'Time [min]');
                xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
                ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
                title(titleName);
                savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Time\' titleName '.fig']);
                %saveas(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Time\Images\' titleName '.tif']); 
                
                
                if j == 1
                    try
                        data_struct.par2.(par2{k}) = [data_struct.par2.(par2{k}) nanmean(At.(par2{k}),2)];
                    catch
                        data_struct.par2.(par2{k}) = nanmean(At.(par2{k}),2);
                    end
                end
                
                
                
               
                
            end
                
        end
        close all
        
        
    end
    for j = 1 : numel(data_struct.par1)
        for k = 1 : numel(data_struct.par2)
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg'];
            h = figure('Visible','Off');
            %h = figure;
            cmap = jet(num_of_mat_files);
            hold all;
            for m = 1 : size(data_struct.par1.(par1{j}),2)
                s = scatter(data_struct.par1.(par1{j})(:,m),data_struct.par2.(par2{k})(:,m),20,cmap(m,:),'filled');
                s.MarkerEdgeColor = s.CData;
            end
            xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
            ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
            title(strrep([par1{j} ' vs ' par2{k}],'_',' '));
            legend(legends,'Location','northwestoutside');
        end
        savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg\' titleName '.fig']);
    end
    
    
    ax = 0;
    for j = 1 : numel(par1)
        for k = 1 : numel(par2)
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Sun'];
            files = dir([curPath '\*.fig']);
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                ax = max([ax, abs([h.CurrentAxes.XLim h.CurrentAxes.YLim])]);
            end
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                h.CurrentAxes.XLim = [-ax ax];
                h.CurrentAxes.YLim = [-ax ax];
                savefig(h,[curPath '\' files(i).name]);
                saveas(h,[curPath '\Images\' strrep(files(i).name,'.fig','.tif')]);
            end
        end
        close all
    end
    ax = 0;
    
    for j = 1 : numel(par1)
        for k = 1 : numel(par2)
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Abs'];
            files = dir([curPath '\*.fig']);
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                ax = max([ax, abs([h.CurrentAxes.XLim h.CurrentAxes.YLim])]);
            end
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                h.CurrentAxes.XLim = [0 ax];
                h.CurrentAxes.YLim = [0 ax];
                savefig(h,[curPath '\' files(i).name]);
                saveas(h,[curPath '\Images\' strrep(files(i).name,'.fig','.tif')]);
            end
        end
        close all
    end
    ax = 0;
    
    for j = 1 : numel(par1)
        for k = 1 : numel(par2)
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Time'];
            files = dir([curPath '\*.fig']);
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                ax = max([ax, abs([h.CurrentAxes.XLim h.CurrentAxes.YLim])]);
            end
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                h.CurrentAxes.XLim = [0 ax];
                h.CurrentAxes.YLim = [0 ax];
                savefig(h,[curPath '\' files(i).name]);
                saveas(h,[curPath '\Images\' strrep(files(i).name,'.fig','.tif')]);
            end
        end
        close all
    end
    ax = 0;
    
    for j = 1 : numel(par1)
        for k = 1 : numel(par2)
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg'];
            files = dir([curPath '\*.fig']);
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                ax = max([ax, abs([h.CurrentAxes.XLim h.CurrentAxes.YLim])]);
            end
            for i = 1 : numel(files)
                h = openfig([curPath '\' files(i).name]);
                h.CurrentAxes.XLim = [0 ax];
                h.CurrentAxes.YLim = [0 ax];
                savefig(h,[curPath '\' files(i).name]);
                saveas(h,[curPath '\Images\' strrep(files(i).name,'.fig','.tif')]);
            end
        end
        close all
    end
                
            
    
end
            
        
        
        
        
    