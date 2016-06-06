function handler = bar_graph(folder_path,par,Arrange,concat)

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
    
    mkdir([folder_path '\Bar Graphs\Images']);
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
                graphs_data.labels.(par{j}) = [graphs_data.labels.(par{j}) {strrep(strrep(strrep([files(i).name(1:5) files(i).name(12:14) files(i).name(16:end)],'NNN0',''),'.mat',''),'_',' ')}];    
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
       
        [p.(par{i}),tbl.(par{i}),stats.(par{i})] = anova1(graphs_data.plot_data.(par{i}).anova,graphs_data.labels.(par{i}),'off');
        %saveas(gcf,[folder_path '\Bar Graphs\Tuckey Box ' graphs_data.title ' ' strrep(par{i},'_',' ') '.tiff']);
        close all;
        handler.(par{i}) = figure('Visible','Off');
        %handler.(par{i}) = figure(i);
        title([graphs_data.title ' ' strrep(par{i},'_',' ')],'FontSize',16);
        
        X = 1 : length(graphs_data.plot_data.(par{i}).mean);
        hold on;
        b = bar(X,graphs_data.plot_data.(par{i}).mean); 
        base = min(graphs_data.plot_data.(par{i}).mean);
        for k = 1 : length(b)
            b(k).BaseValue = 0.9*base;
        end
        %b.ShowBaseLine = 'Off'
        errorbar(X,graphs_data.plot_data.(par{i}).mean,graphs_data.plot_data.(par{i}).error)    
        hold off;
        %errorbar(X,graphs_data.plot_data.(par{i}).error);
        %set(gca,'XTickLabel',graphs_data.labels)
        set(gca,'XTick',1:length(graphs_data.labels.(par{i})));
        set(gca,'XTickLabel',graphs_data.labels.(par{i}));
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel([strrep(par{i},'_',' ') ' ' Units(par{i})]);
        if p.(par{i}) <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p.(par{i}));
        end
        text(0.9,1,['p value = ' Pvalue],'Units','normalized')
        saveas(handler.(par{i}) ,[folder_path '\Bar Graphs\Images\' graphs_data.title ' - ' par{i} '.tiff']);
        saveas(handler.(par{i}) ,[folder_path '\Bar Graphs\' graphs_data.title ' - ' par{i}]);
        [c.(par{i}),m.(par{i}),h.(par{i})] = multcompare(stats.(par{i}));
%         xlswrite([folder_path '\Bar Graphs\Tukey Table'],c.(par{i}),par{i});
        Data = [nan(1,size(graphs_data.plot_data.(par{i}).mean,2)); graphs_data.plot_data.(par{i}).mean ; nan(1,size(graphs_data.plot_data.(par{i}).mean,2)); graphs_data.plot_data.(par{i}).error];
        %xlswrite([folder_path '\Bar Graphs\Graphs Data'],Data,strrep(par{i},'_',''));
        %xlswrite([folder_path '\Bar Graphs\Graphs Data'],graphs_data.labels.(par{i}),strrep(par{i},'_',''));
    end
    close all      
    disp('Bar Graphs - Done!');
end

function newData = Rearrange_bar_graph(data,curArr,newArr)
    
    newData = [];
    for i = 1 : length(newArr)
        newData = [newData data(:,strcmp(curArr,newArr(i)))];
    end
end
        

        
        
        
        
            
            
            
            