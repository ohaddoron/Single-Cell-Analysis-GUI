function par1_vs_par2 (folderPath , par1 , par2 , normalize)

          
    
    warning('off','all');
    disp(['opening folder ' folderPath]);
   
    
    figure('Visible','Off');
    ph = plot(1:10);
%     allLineStyles = set(ph,'LineStyle');
    allMarkers = set(ph,'Marker');
    a = allMarkers;
    a(5) = [];
    a(4) = [];
    a(3) = [];
    a(1) = [];
    a(strcmp(a,'none')) = [];
    
    
    
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
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                %h = figure;
                colormap(jet);
                scatter(curData(:,1),curData(:,2),5,curData(:,3),'filled');
                hcolor = colorbar;
                xlabel(hcolor,'Time [min]');
                xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
                ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
                
                
                if strcmp(Units(par1{j}),Units(par2{k}))
                    ax = max(abs([h.CurrentAxes.XLim h.CurrentAxes.YLim]));
                    h.CurrentAxes.XLim = [-ax,ax];
                    h.CurrentAxes.YLim = [-ax,ax];
                else
                    axx = max(abs(h.CurrentAxes.XLim));
                    axy = max(abs(h.CurrentAxes.YLim));
                    h.CurrentAxes.XLim = [-axx axx];
                    h.CurrentAxes.YLim = [-axy axy];
                end
                titleName = strrep(strrep([files(i).name(12:14) files(i).name(19:end)],'NNN0',''),'.mat','');
                title(cell2mat([par2 ' vs ' par1 ' Sun - ' titleName]));
                savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Sun\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.fig']);
                %saveas(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Sun\Images\' titleName '.tif']); 
                
                
                h = figure('Visible','Off');
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                %h = figure;
                colormap(jet);
                scatter(abs(curData(:,1)),abs(curData(:,2)),5,curData(:,3),'filled');
                hcolor = colorbar;
                xlabel(hcolor,'Time [min]');
                xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
                ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
                
                
                if strcmp(Units(par1{j}),Units(par2{k}))
                    h.CurrentAxes.XLim = [0,ax];
                    h.CurrentAxes.YLim = [0,ax];
                else
                    h.CurrentAxes.XLim = [0,axx];
                    h.CurrentAxes.YLim = [0,axy];
                end
                title(cell2mat([par2 ' vs ' par1 ' Absolute - ' titleName]));
                savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Abs\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.fig']);
                %saveas(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Abs\Images\' titleName '.tif']); 
                
                
                
                
                meanData = [nanmean(abs(At.(par1{j})),2) nanmean(abs(At.(par2{k})),2) t'];
                meanData(sum(isnan(meanData),2)>0,:) = [];
                h = figure('Visible','Off');
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                colormap(jet);
                scatter(meanData(:,1),meanData(:,2),20,meanData(:,3),'filled');
                hcolor = colorbar;
                xlabel(hcolor,'Time [min]');
                xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
                ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
                title(cell2mat([par2 ' vs ' par1 ' Average over time - ' titleName]));
                savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Time\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.fig']);
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
    
    
    
    
    
    

    for j = 1 : numel(fieldnames(data_struct.par1))
        for k = 1 : numel(fieldnames(data_struct.par2))
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg'];
            h = figure('Visible','Off');
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%             h = figure;
            cmap = jet(size(data_struct.par1.(par1{j}),1));
            
            mm = 1;
            t = (0:size(cmap,1)-1) * At.dt;
            cmap = jet(numel(t));
            colormap(jet);

            hold all
            for m = 1 : size(data_struct.par1.(par1{j}),2)
              if mm > numel(a)
                  mm = 1;
              end
              s = scatter(data_struct.par1.(par1{j})(:,m),data_struct.par2.(par2{k})(:,m),50,t,a{mm},'filled');
              s.MarkerEdgeColor = [1 1 1];
              mm = mm + 1;
            end
            hcolor = colorbar;
            xlabel(hcolor,'Time [min]');
            hold off;
%             hold all;
%             grid on;
%             mm = 1;
%             [~,Z] = meshgrid(1:size(data_struct.par1.(par1{j}),1),1:size(data_struct.par1.(par1{j}),2));
%             Z = Z - 1;
%             colormap(jet);
%             for m = 1 : size(data_struct.par1.(par1{j}),2)
%                 if mm > numel(a)
%                     mm = 1;
%                 end
%                 scatter3(data_struct.par1.(par1{j})(:,m),data_struct.par2.(par2{k})(:,m),Z(m,:),40,t,a{mm},'filled');
%                 mm = mm + 1;
%             end
%             view(3);
                
            
            
              

            xlabel(strrep([par1{j} ' ' Units(par1{j})],'_',' '));
            ylabel(strrep([par2{k} ' ' Units(par2{k})],'_',' '));
            title(strrep([par2{k} ' vs ' par1{j}],'_',' '));
            [hl,~] = legend(legends,'Location','Northwestoutside');
            savefig(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.fig']); 
            saveas(h,[folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\Avg\Images\' strrep(strrep(files(i).name,'NNN0',''),'.mat','') '.tif']); 
        end
        
    end
%     scale_axes ( par1 , par2 , folderPath, 0 , 'Avg', normalize )
    scale_axes ( par1 , par2 , folderPath, 1 , 'Sun', normalize )
    scale_axes ( par1 , par2 , folderPath, 0 , 'Abs', normalize )
    scale_axes ( par1 , par2 , folderPath, 0 , 'Time', normalize )
    
    
    
    
    

    
end

function scale_axes ( par1 , par2 , folderPath, axDec , type , normalize)
    
    
    
    for j = 1 : numel(par1)
        
        for k = 1 : numel(par2)
            ax = 0;
            axy = 0;
            axx = 0;
            curPath = [folderPath '\par1_vs_par2\' par1{j} '\' par2{k} '\' type];
            files = dir([curPath '\*.fig']);
            for i = 1 : numel(files)
                h(i) = openfig([curPath '\' files(i).name]);
                axis tight;
                if strcmp(Units(par1{j}),Units(par2{k})) || normalize ~= 0
                    ax = max([ax, abs([h(i).CurrentAxes.XLim h(i).CurrentAxes.YLim])]);
                else
                    axx = max([axx, abs(h(i).CurrentAxes.XLim)]);
                    axy = max([axy, abs(h(i).CurrentAxes.YLim)]);
                end
                    
            end
            
            for i = 1 : numel(files)
%                 h = openfig([curPath '\' files(i).name]);
                if strcmp(Units(par1{j}),Units(par2{k})) || normalize ~= 0
                    if axDec == 0
                        h(i).CurrentAxes.XLim = [0 ax];
                        h(i).CurrentAxes.YLim = [0 ax];
                    else
                        h(i).CurrentAxes.XLim = [-ax ax];
                        h(i).CurrentAxes.YLim = [-ax ax];
                    end
                else
                    if axDec == 0
                        h(i).CurrentAxes.XLim = [0 axx];
                        h(i).CurrentAxes.YLim = [0 axy];
                    else
                        h(i).CurrentAxes.XLim = [-axx axx];
                        h(i).CurrentAxes.YLim = [-axy axy];
                    end
                end
                savefig(h(i),[curPath '\' files(i).name]);
                saveas(h(i),[curPath '\Images\' strrep(files(i).name,'.fig','.tif')]);
            end
        end
        close all
    end
end

        
        
        
    