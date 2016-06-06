function Ax = Parameter_Correlation_Time_Dependency_Maps (folderPath , par1 , par2 , varargin)


    switch nargin
        case 4
            Arrange = varargin{1};
        case 5
            Arrange = varargin{1};
            Ax_used = varargin{2};
    
    end
    
    Debug_OD = 0;
    warning('off','all');
    disp(['opening folder ' folderPath]);
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = numel(files);
    outPath = fullfile(folderPath,'Parameter Correlation Maps');
    mkdir(fullfile(outPath,'Images'));
    for i = 1 : num_of_mat_files
        disp(['loading file ' files(i).name]);
        
        legends{i} = strrep(strrep(strrep([files(i).name(12:14) files(i).name(19:end)],'NNN0',''),'.mat',''),'_',' ');
        temp = load([folderPath '\' files(i).name]);
        name = fieldnames(temp);
        At = temp.(name{1});
        for j = 1 : numel(par1)
            
            par1Data = nanmean(At.(par1{j}),2);
            if strcmp(par1{j},'Velocity_X')
                par1Data = nanmean(abs(At.(par1{j})),2);
            end
            par1Data = par1Data/nanmax(par1Data);
            
            [Row,Col] = size(At.(par1{j}));
            t = (0:Row-1) * At.dt;
            for k = 1 : numel(par2)
                par2Data = nanmean(At.(par2{k}),2);
                if strcmp(par2{k},'Velocity_Y')
                    par2Data = nanmean(abs(At.(par2{k})),2);
                end
                par2Data = par2Data/nanmax(par2Data);
                
                try
                    plot_data.(strcat(par1{j},'_',par2{k})) = padconcatenation(plot_data.(strcat(par1{j},'_',par2{k})),...
                        (par2Data./par1Data)',1);
                catch
                    plot_data.(strcat(par1{j},'_',par2{k})) = (par2Data./par1Data)';
                end
                
                
            end
            
            
        end
    end
    for j = 1 : numel(par1)
        for k = 1 : numel(par2)
            if Arrange.choice == 0
                for n = 1 : numel(Arrange.list)
                    Arrange.list{n} = strcat(Arrange.list{n}(12:14),Arrange.list{n}(19:end));
                end
                plot_data.(strcat(par1{j},'_',par2{k})) = Rearrange_Parameter_Correlation_Maps...
                    (plot_data.(strcat(par1{j},'_',par2{k})),legends,Arrange.list);
                legends = Rearrange_Parameter_Correlation_Maps...
                    (plot_data.(strcat(par1{j},'_',par2{k})),legends,Arrange.list);
            end
            [~,c] = size(plot_data.(strcat(par1{j},'_',par2{k})));
            t = (0:c-1) * At.dt;
            idx = find(sum(isnan(plot_data.(strcat(par1{j},'_',par2{k})))),1);
            t(:,idx) = [];
            plot_data.(strcat(par1{j},'_',par2{k}))(:,idx) = [];
            
            
            Data = [nan(1,size(plot_data.(strcat(par1{j},'_',par2{k})),2)); plot_data.(strcat(par1{j},'_',par2{k}))];
            Data = [nan(size(Data,1),1) Data];
            
            
            try
                xlswrite(fullfile(outPath,'Graphs Data'),Data,(strcat(par1{j},'_',par2{k})));
                xlswrite(fullfile(outPath,'Graphs Data'),[nan(1,1); legends'],(strcat(par1{j},'_',par2{k})));
                xlswrite(fullfile(outPath,'Graphs Data'),[nan(1,1) t],(strcat(par1{j},'_',par2{k})));
            catch
            end

            h = figure('Visible','Off');
            imagesc(plot_data.(strcat(par1{j},'_',par2{k})));
            colormap(jet);
            b = colorbar;
            Ax.(strcat(par1{j},'_',par2{k})) = caxis;
            if nargin > 4
                caxis(Ax_used.(strcat(par1{j},'_',par2{k})));
            end
            axis tight;
            set(gca,'XTickLabel',t(get(gca,'XTick')+1))
            set(gca,'YTick',1:numel(legends));
            set(gca,'YTickLabel',legends);
            set(gca,'FontSize',5);
            title(strcat(strrep(par2{k},'_',' '),'/',strrep(par1{j},'_',' ')));
            xlabel('Time [min]');
            xlabel(b,strcat(strrep(par2{k},'_',' '),'/',strrep(par1{j},'_',' ')));
            saveas(h,fullfile(outPath,strcat(strrep(par1{j},'_',' '),'_',strrep(par2{k},'_',' '),'.fig')));
            saveas(h,fullfile(outPath,'Images',strcat(strrep(par1{j},'_',' '),'_',strrep(par2{k},'_',' '),'.tiff')));
            if Debug_OD == 1
                
                mkdir(fullfile(outPath,'Debug'));
                
                
                h = figure('Visible','Off');
                plot(t,plot_data.(strcat(par1{j},'_',par2{k})));
                xlabel('Time');
                ylabel(strcat(par2{k},'/',par1{j}));
                saveas(h,fullfile(outPath,'Debug',(strcat(par1{j},'_',par2{k},'.tiff'))))
                
            end
            
                

        end
    end
    disp('Parameter Correlation - Done!');
end


function newData = Rearrange_Parameter_Correlation_Maps(data,curArr,newArr)
    
    newData = [];
    for i = 1 : length(newArr)
        newData = [newData data(:,strcmp(curArr,newArr(i))')];
    end
end
        
        
        
        
            
                