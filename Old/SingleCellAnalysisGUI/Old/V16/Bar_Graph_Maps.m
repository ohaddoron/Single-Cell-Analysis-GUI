function handler = Bar_Graph_Maps(varargin)
    

    switch nargin
        case 4
            folder_path = varargin{1};
            par = varargin{2};
            Arrange = varargin{3};
            concat = varargin{4};
        case 5
            folder_path = varargin{1};
            par = varargin{2};
            Arrange = varargin{3};
            concat = varargin{4};
            MG = varargin{5};
        case 6
            folder_path = varargin{1};
            par = varargin{2};
            Arrange = varargin{3};
            concat = varargin{4};
            MG = varargin{5};
            parTD = varargin{6};
        case 7
            folder_path = varargin{1};
            par = varargin{2};
            Arrange = varargin{3};
            concat = varargin{4};
            MG = varargin{5};
            parTD = varargin{6};
            Ax_used_Time_Dependency = varargin{7};
        case 10
            folder_path = varargin{1};
            par = varargin{2};
            Arrange = varargin{3};
            concat = varargin{4};
            MG = varargin{5};
            parTD = varargin{6};
            Ax_used_Time_Dependency = varargin{7};
            par1 = varargin{8};
            par2 = varargin{9};
            Ax_used_Parameter_Correlation = varargin{10};
            
            
    end
    
    
    graphs_data.plot_data = {};
    graphs_data.cell_count = [];
    graphs_data.labels = {};
    graphs_data.plot_handlers = {};
    graphs_data.names = {};
    graphs_data.title = {};
    p = [];
    tbl = [];
    stats = [];
    c = [];
    m = [];
    h = [];
    outpath = fullfile(folder_path,'Bar Graph Maps');
    
    mkdir(fullfile(outpath,'Images'));
    disp(['opening folder ' folder_path]);
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    % % Concatanating duplicates 07.12.2015
    
    
    if concat ~= 0 
        for i = 1 : num_of_mat_files
            disp(['loading file ' files(i).name]);
            file_path = [folder_path '\' files(i).name];
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
    % % End of concatanate    
    
    
    if concat == 0
        len = num_of_mat_files;
    else
        len = numel(graphs_data.data.(par{1}));
    end
    
    for i=1:len
        if concat == 0 
            disp(['loading file ' files(i).name]);
            file_path = [folder_path '\' files(i).name];
            temp = load(file_path);
            Atname = fieldnames(temp);
            At = temp.(Atname{1});
        end
        for j = 1:length(par)
            if i == 1
                graphs_data.labels.(par{j}) = [];
            end
            if concat ~= 0
                data_struct.(par{j}) =  graphs_data.data.(par{j}){i};
            else
                data_struct.(par{j}) = At.(par{j});
            end
            
            graphs_data.names{i} = files(i).name;
            graphs_data.title = graphs_data.names{i}(1:9);
            
            if i == 1
                graphs_data.plot_data.(par{j}).mean = [];
                graphs_data.plot_data.(par{j}).error = [];
                graphs_data.plot_data.(par{j}).anova = [];
            end
            data = nanmean(abs(data_struct.(par{j})(:)));
            stdev = nanstd(data_struct.(par{j})(:))./(sum(~isnan(data_struct.(par{j})(:)).^0.5));
            graphs_data.plot_data.(par{j}).mean = [graphs_data.plot_data.(par{j}).mean data];
            graphs_data.plot_data.(par{j}).error = [graphs_data.plot_data.(par{j}).error stdev];
            if concat == 0
                graphs_data.labels.(par{j}) = [graphs_data.labels.(par{j}) {strrep(strrep(strrep(files(i).name,'NNN0',''),'.mat',''),'_',' ')}];    
            else
                graphs_data.labels.(par{j}) = strrep(strrep(strrep(names.(par{j}),'NNN0',''),'.mat',''),'_',' ');
            end

            anova = abs(data_struct.(par{j})(:));
            anova(isnan(anova)) = [];
            if length(anova)>size(graphs_data.plot_data.(par{j}).anova,1)
                graphs_data.plot_data.(par{j}).anova = [graphs_data.plot_data.(par{j}).anova;...
                    nan(length(anova) - size(graphs_data.plot_data.(par{j}).anova,1),size(graphs_data.plot_data.(par{j}).anova,2))];
            end
            anova = [anova; nan(size(graphs_data.plot_data.(par{j}).anova,1)-length(anova),1)];
            graphs_data.plot_data.(par{j}).anova = [graphs_data.plot_data.(par{j}).anova anova];
        end
    end
    
    for i = 1 : length(par)
        
        if Arrange.choice == 0
            graphs_data.plot_data.(par{i}).mean = Rearrange_bar_graph(graphs_data.plot_data.(par{i}).mean,...
                graphs_data.labels.(par{i}),(Arrange.list));
            graphs_data.plot_data.(par{i}).error = Rearrange_bar_graph(graphs_data.plot_data.(par{i}).error,...
                graphs_data.labels.(par{i}),(Arrange.list));
            graphs_data.labels.(par{i}) = Rearrange_bar_graph(graphs_data.labels.(par{i}),...
                graphs_data.labels.(par{i}),(Arrange.list));
            graphs_data.plot_data.(par{i}).anova = Rearrange_bar_graph(graphs_data.plot_data.(par{i}).anova,...
                graphs_data.labels.(par{i}),(Arrange.list));
        end
                
        Spars = MG.Spars;
        Names = graphs_data.labels.(par{i});


        for k = 1 : numel(files)
            names{k} = strrep(strrep([Names{k}(12:14) Names{k}(19:end)],'NNN0',''),'.mat','');
            for kk = 1 : numel(Spars)
                if k == 1
                    if strcmp(Spars{kk},'CON')
                        mkdir(fullfile(folder_path,'Control'));
                    else
                        mkdir(fullfile(folder_path,Spars{kk}));
                    end
                end
                idx = strfind(names{k},Spars{kk});
                if ~isempty(idx)
                    if strcmp(Spars{kk},'CON')
                        copyfile(fullfile(folder_path,files(k).name),fullfile(folder_path,'Control',files(k).name));
                    else
                        copyfile(fullfile(folder_path,files(k).name),fullfile(folder_path,Spars{kk},files(k).name));
                    end
                end
                names{k}(idx:idx+3) = '';
            end
        end
%         if nargin > 5
%             if i == 1
%                 for kk = 1 : numel(Spars)
%                     scale.choice = 1;
%                     Arrange.choice = 1;
%                     concat = 0;
%                     if strcmp(Spars{kk},'CON')
%                         folderPath = fullfile(folder_path,'Control');
%                     else
%                         folderPath = fullfile(folder_path,Spars{kk});
%                     end
%                     try
%                         files = dir(fullfile(folderPath,'*.mat'));
%                         if ~isempty(files)
%                             Time_Dependency_Maps(folderPath,parTD,scale,Arrange,concat,Ax_used_Time_Dependency);
%                             Parameter_Correlation_Time_Dependency_Maps (folderPath , par1 , par2 , Arrange,Ax_used_Parameter_Correlation);
%                         end
%                     catch
%                     end
%                 end
%             end
%         end
            
        names = unique(names);

        data = nan(num_of_mat_files,numel(Spars));
        for k = 1 : numel(files)
            name = strrep(strrep([Names{k}(12:14) Names{k}(19:end)],'NNN0',''),'.mat','');
            for kk = 1 : numel(Spars)
                idx = strfind(name,Spars{kk});
                name(idx:idx+3) = '';
            end
            idx = strcmp(names,name);
            for kk = 1 : numel(Spars)
                if strfind(files(k).name,Spars(kk))
                    data(idx,kk) = graphs_data.plot_data.(par{i}).mean(k);
                end
            end
        end
            
            
            
        data(sum(isnan(data),2) == numel(Spars),:) = [];
        names(sum(isnan(data),2) == numel(Spars)) = [];
        handler = figure('Visible','Off');
        [nr,nc] = size(data);
        try
            pcolor([data nan(nr,1); nan(1,nc+1)]);
            colormap(jet);
            axis tight;
            title(['Average cell ',strrep(par{i},'_',' ')])
            set(gca,'YTick',1.5:size(data,1)+0.5,'YTickLabel',names)
            set(gca,'XTick',1.5:numel(Spars)+0.5,'XTickLabel',Spars,'XTickLabelRotation',45);
            set(gca,'FontSize',5);
            b = colorbar;
            xlabel(b,[strrep(par{i},'_',' ') ' ' Units(par{i})]);
            ttl = strrep(par{i},'_',' ');
            saveas(handler,fullfile(outpath,strcat(ttl,'.fig')));
            saveas(handler,fullfile(outpath,'Images',strcat(ttl,'.tiff')));
            close(handler);
        catch
            warndlg(['Unable to generate ' strrep(par{i},'_',' ')]);
        end
        try
            Data = [nan(1,size(data,2)); data];
            Data = [nan(size(Data,1),1) Data];
            
            xlswrite(fullfile(outpath,'Graphs Data'),Data,strrep(par{i},'_',''));
            xlswrite(fullfile(outpath,'Graphs Data'),[nan(1,1); names'],strrep(par{i},'_',''));
            xlswrite(fullfile(outpath,'Graphs Data'),[nan(1,1) Spars],strrep(par{i},'_',''));
                
            
        catch
            continue
        end
        
    end
    close all;
    
        
    disp('Bar Graphs Maps - Done!');
end

function newData = Rearrange_bar_graph(data,curArr,newArr)
    
    newData = [];
    for i = 1 : length(newArr)
        newData = [newData data(:,strcmp(curArr,newArr(i)))];
    end
end
        

        
        
        
        
            
            
            
            