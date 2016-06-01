function [handler,Ax] = Time_Dependency_Maps(folder_path,par,scale,Arrange,concat,varargin)
    

    if nargin > 5
        Ax_used = varargin{1};
    end
    
    

    graphs_data.names = [];
    graphs_data.plot_data = {};
    graphs_data.title = [];
    graphs_data.legend = {};
    names = {};
    
        
    disp(['opening folder ' folder_path]);
    
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    outFolder = [folder_path '\Time Dependent Maps'];
    mkdir(fullfile(outFolder,'Images'));
    
    
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
            
        
        graphs_data.names{i} = strrep(strrep(files(i).name,'NNN0',''),'.mat','');
        graphs_data.title = graphs_data.names{i}(1:22);
        if concat ~= 0
            graphs_data.legend = strrep(names.(par{1}),'NNN0','');
        else
            graphs_data.legend{i} = strrep(strrep(strrep([files(i).name(12:14) files(i).name(19:end)],'NNN0',''),'.mat',''),'_',' ');
        end
        for j = 1 : length(par)
            if scale.choice(1) == 0
                At.(par{j}) = [nan(scale.Ax(1)/At.dt,size(At.(par{j}),2)); At.(par{j})];
                scale.Ax(2) = size(At.(par{j}),1)*At.dt;
            end
            if i == 1
                graphs_data.plot_data.(par{j}) = [];
                graphs_data.plot_error.(par{j}) = [];
                graphs_data.max.(par{j}) = [];
                graphs_data.min.(par{j}) = [];
            end
            if concat ~= 0
                data_struct.(par{j}) = graphs_data.data.(par{j}){i};
            else
                data_struct.(par{j}) = At.(par{j});
                dt = At.dt;
            end
            tint = dt;
            data = nanmean(abs(data_struct.(par{j})),2);
            stdev = nanstd(abs(data_struct.(par{j})),0,2)...
                ./(sum(~isnan(data_struct.(par{j})),2).^0.5);
            if size(graphs_data.plot_data.(par{j}),1) > size(data,1)
                graphs_data.plot_data.(par{j})(size(data,1)+1:end,:) = [];
                graphs_data.plot_error.(par{j})(size(data,1)+1:end,:) = [];
            end
            if size(graphs_data.plot_data.(par{j}),1) < size(data,1) && size(graphs_data.plot_data.(par{j}),1)~=0
                data(size(graphs_data.plot_data.(par{j}),1)+1:end,:) = [];
                stdev(size(graphs_data.plot_data.(par{j}),1)+1:end,:) = [];
            end
            graphs_data.plot_data.(par{j}) = [graphs_data.plot_data.(par{j}) data];
            graphs_data.plot_error.(par{j}) = [graphs_data.plot_error.(par{j}) stdev];
            graphs_data.max.(par{j}) = [graphs_data.max.(par{j}) nanmax(abs(data_struct.(par{j})))];
            graphs_data.min.(par{j}) = [graphs_data.min.(par{j}) nanmin(abs(data_struct.(par{j})))];
            Ax.(par{j}) = nanmean(graphs_data.max.(par{j}));
        end
        
    end
    
    for i = 1 : length(fieldnames(graphs_data.plot_data))
        if size(graphs_data.plot_data.(par{i}),1) > 1
            if Arrange.choice == 0
                for k = 1 : numel(Arrange.list)
                    Arrange.list{k} = strcat(Arrange.list{k}(12:14),Arrange.list{k}(19:end));
                end
                graphs_data.plot_data.(par{i}) = Rearrange_par2time(graphs_data.plot_data.(par{i}),...
                    graphs_data.legend,(Arrange.list));
                graphs_data.legend = Rearrange_par2time(graphs_data.legend,...
                    graphs_data.legend,(Arrange.list));
                
            end
            handler.(par{i}) = figure('Visible','Off');       
            title([strrep(par{i},'_',' ') ' over time'],'FontSize',14);
            xlabel('Time [min]');
            hold all;
            t = (0 : size(graphs_data.plot_data.(par{i}),1) - 1)' * tint;
            plotData = flipud(graphs_data.plot_data.(par{i})');
            t(sum(isnan(plotData)) > 0) = [];
            plotData(:,sum(isnan(plotData)) > 0) = [];
            imagesc(plotData);
            if nargin > 5 
                caxis(Ax_used.(par{i}))
            end
            axis tight;
            Ax.(par{i}) = caxis;
            if ~isempty(t)
                set(gca,'XTickLabel',t(get(gca,'XTick')))
            end
            set(gca,'YTick',1:size(plotData,1));
            set(gca,'YTickLabel',fliplr(graphs_data.legend));
            set(gca,'FontSize',5);
            
            
            b = colorbar;
            xlabel(b,[strrep(par{i},'_',' ') ' ' Units(par{i})]);
            colormap(jet);
            saveas(handler.(par{i}),[outFolder '\Images\Average ' par{i} ' over time.tiff']);
            saveas(handler.(par{i}),[outFolder '\Average ' par{i} ' over time']);


            Data = ([nan(1,size(plotData,1))' plotData]);
            Data = [nan(1,size(Data,2)); Data];
            
            
            try
                xlswrite(fullfile(outFolder,'Graphs Data'),Data,par{i});
                xlswrite(fullfile(outFolder,'Graphs Data'),[nan(1,1); graphs_data.names'],par{i});
                xlswrite(fullfile(outFolder,'Graphs Data'),[nan(1,1) t'],par{i});
            catch
            end

            
        end
    end
    disp('Time Dependency - Done!');
end 
function newData = Rearrange_par2time(data,curArr,newArr)
    
    newData = [];
    for i = 1 : length(newArr)
        newData = [newData data(:,strcmp(curArr,newArr(i))')];
    end
end