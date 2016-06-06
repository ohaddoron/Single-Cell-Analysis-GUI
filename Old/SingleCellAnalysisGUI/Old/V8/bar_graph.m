function handler = bar_graph(varargin)
    

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
            Normalize = varargin{5};
        case 6
            folder_path = varargin{1};
            par = varargin{2};
            Arrange = varargin{3};
            concat = varargin{4};
            Normalize = varargin{5};
            direction = varargin{6};
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
        flag = 1;
        if nargin >= 5 && Normalize ~=0 
            newArr = [];

            A = graphs_data.labels.(par{i});

            B = cellfun(@(x) x(16:end),A(cellfun('length',A) > 1),'un',0);
 
            idx = find(~cellfun(@isempty,strfind(B,'CON')));
            B(idx) = {'CON1'};
            idx = 1;
            while numel(B) >= 1
                simIdx = strcmp(B,B{idx});
                if i == 1 && flag == 1
                    C = A(simIdx);

                    a = cellfun(@(x) x(1:5),C(cellfun('length',C) > 1),'un',0);
                    b = cellfun(@(x) x(12:15),C(cellfun('length',C) > 1),'un',0);
                    genLabels = cell2mat([a' b']);
                    

                    
                    flag = 0;
                end
                try
                    newArr.mean = [newArr.mean; graphs_data.plot_data.(par{i}).mean(simIdx)];
                    newArr.error = [newArr.error; graphs_data.plot_data.(par{i}).error(simIdx)];
                    newArr.anova = [newArr.anova; graphs_data.plot_data.(par{i}).anova(simIdx)];
                    
                    newLabels = [newLabels B(idx)];
                catch
                    newArr.mean = graphs_data.plot_data.(par{i}).mean(simIdx);
                    newArr.error = graphs_data.plot_data.(par{i}).error(simIdx);
                    newArr.anova = graphs_data.plot_data.(par{i}).anova(simIdx);
                    newLabels = B(idx);
                end
                
                
                graphs_data.plot_data.(par{i}).mean(simIdx) = [];
                graphs_data.plot_data.(par{i}).error(simIdx) = [];
                graphs_data.plot_data.(par{i}).anova(simIdx) = [];
                B(simIdx) = [];
            end
            if nargin <6 || direction == 0 
                idx = find(~cellfun(@isempty,strfind(newLabels,'CON')));
                
                tmp = newLabels(idx);
                newLabels(idx) = [];
                newLabels = [tmp newLabels];
                
                tmp = newArr.mean(idx,:);
                newArr.mean(idx,:) = [];
                newArr.mean = [tmp; newArr.mean];
                
                tmp = newArr.error(idx,:);
                newArr.error(idx,:) = [];
                newArr.error = [tmp; newArr.error];
                
                tmp = newArr.anova(idx,:);
                newArr.anova(idx,:) = [];
                newArr.anova = [tmp; newArr.anova];
            end
           graphs_data.labels.(par{i}) = newLabels;     
           graphs_data.plot_data.(par{i}) = newArr;    
           
        end
        

        if nargin >=6 && direction ~= 0
            graphs_data.plot_data.(par{j}).mean = graphs_data.plot_data.(par{j}).mean';
            temp = graphs_data.labels.(par{i});
            graphs_data.labels.(par{i}) = genLabels;
            genLabels = temp;
        end
        


        if nargin >=5 && Normalize ~= 0
            X = 1 : size(graphs_data.plot_data.(par{i}).mean,1);
        else
            X = 1:length(graphs_data.plot_data.(par{i}).mean);
        end

        

        hold on;
        b = bar(X,graphs_data.plot_data.(par{i}).mean); 
        base = min(graphs_data.plot_data.(par{i}).mean(:));
        for k = 1 : length(b)
            b(k).BaseValue = 0.9*base;
        end
        %b.ShowBaseLine = 'Off'
        %errorbar(X,graphs_data.plot_data.(par{i}).mean,graphs_data.plot_data.(par{i}).error)    
        
        if nargin <5 || Normalize == 0
            errorbar(X,graphs_data.plot_data.(par{i}).mean,graphs_data.plot_data.(par{i}).error);
        end
        hold off;
        %set(gca,'XTickLabel',graphs_data.labels)
        set(gca,'XTick',1:length(graphs_data.labels.(par{i})));
        set(gca,'XTickLabel',graphs_data.labels.(par{i}));
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        if nargin >=5 && Normalize ~= 0
            legend(genLabels,'Location','NorthWestOutside');
        end
        if nargin >=5 && Normalize ~= 0
            ylabel([strrep(par{i},'_',' ') ' % ' ]);
        else
            ylabel([strrep(par{i},'_',' ') ' ' Units(par{i})]);
        end
        if p.(par{i}) <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p.(par{i}));
        end
        text(0.9,1,['p value = ' Pvalue],'Units','normalized')
        saveas(handler.(par{i}) ,[folder_path '\Bar Graphs\Images\' graphs_data.title ' - ' par{i} '.tiff']);
        saveas(handler.(par{i}) ,[folder_path '\Bar Graphs\' graphs_data.title ' - ' par{i}]);
        [c.(par{i}),m.(par{i}),h.(par{i})] = multcompare(stats.(par{i}));
        idxs = c.(par{i})(:,1:2);
        names = cell(size(idxs));
        for kk = 1 : length(stats.(par{i}).gnames)
            [row,col] = find(idxs == kk);
            for jj = 1 : length(row)
                names{row(jj),col(jj)} = stats.(par{i}).gnames{kk};
            end
        end
        if nargin <5 || Normalize == 0
            try
                xlswrite([folder_path '\Bar Graphs\Tukey Table'],[nan(1,size(c.(par{i}),2)); c.(par{i})],par{i});
                xlswrite([folder_path '\Bar Graphs\Tukey Table'],[cell(1,size(names,2)); names],par{i});
                xlswrite([folder_path '\Bar Graphs\Tukey Table'],{'','','Lower Confidence Interval','Estimate','Upper Confidence Interval','p-value'},par{i});
            catch
            end
        end
        try
            Data = [nan(1,size(graphs_data.plot_data.(par{i}).mean,2)); graphs_data.plot_data.(par{i}).mean ; nan(1,size(graphs_data.plot_data.(par{i}).mean,2)); graphs_data.plot_data.(par{i}).error];
            if nargin >=5 && Normalize ~= 0
                Data = [nan(size(Data,1),1) Data];
            end
            xlswrite([folder_path '\Bar Graphs\Graphs Data'],Data,strrep(par{i},'_',''));
            if nargin >=5 && Normalize ~= 0
                xlswrite([folder_path '\Bar Graphs\Graphs Data'],[nan(1,1); graphs_data.labels.(par{i})'],strrep(par{i},'_',''));
                tmp = [];
                for kk = 1 : size(genLabels,1)
                    tmp = [tmp; {genLabels(kk,:)}];
                end
                genLabels = tmp;
                xlswrite([folder_path '\Bar Graphs\Graphs Data'],[nan(1,1) genLabels'],strrep(par{i},'_',''));
            else
                xlswrite([folder_path '\Bar Graphs\Graphs Data'],graphs_data.labels.(par{i}),strrep(par{i},'_',''));
            end
        catch
            continue
        end
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
        

        
        
        
        
            
            
            
            