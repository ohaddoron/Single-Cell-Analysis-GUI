function [handler,Ax] = MD_parameter_to_time_multiple(folder_path,par,scale,Arrange,concat)
    
    
    

    graphs_data.names = [];
    graphs_data.plot_data = {};
    graphs_data.title = [];
    graphs_data.legend = {};
    names = {};
    
    h = figure('Visible','Off');
    ph = plot(1:10);
%     allLineStyles = set(ph,'LineStyle');
    allMarkers = set(ph,'Marker');
    a = allMarkers;
    a(strcmp(a,'none')) = [];
    
    disp(['opening folder ' folder_path]);
    
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    mkdir([folder_path '\Time Dependent\Images']);
    
    
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
            %{
            if Arrange.choice == 0
                graphs_data.plot_data.(par{i}) = Rearrange_par2time(graphs_data.plot_data.(par{i}),...
                    graphs_data.legend,(Arrange.list));
                graphs_data.plot_error.(par{i}) = Rearrange_par2time(graphs_data.plot_error.(par{i}),...
                    graphs_data.legend,(Arrange.list));
                graphs_data.legend = Arrange.list;
            end
            %}
            handler.(par{i}) = figure('Visible','Off');       
            %handler.(par{i}) = figure;
%             title([graphs_data.title ' ' strrep(par{i},'_',' ') ' over time'],'FontSize',16);
            title([strrep(par{i},'_',' ') ' over time'],'FontSize',14);
            xlabel('Time [min]');
            ylabel([strrep(par{i},'_',' ') ' ' Units(par{i})]);
            hold all;
            t = (0 : size(graphs_data.plot_data.(par{i}),1) - 1)' * tint;
            l = size(graphs_data.plot_data.(par{i}),2);
            t = meshgrid(t,1:l)';
            c = colormap(jet(size(graphs_data.plot_data.(par{i}),2)));
            mm = 1;
            for j = 1 : size(c,1)
    %             errorbar(t(:,j),graphs_data.plot_data.(par{i})(:,j),...
    %                 graphs_data.plot_error.(par{i})(:,j),a{mm},'Color',c(j,:));

                    errorbar(t(:,j),graphs_data.plot_data.(par{i})(:,j),...
                         graphs_data.plot_error.(par{i})(:,j),['-' a{mm}],'color',c(j,:));

                mm = mm + 1;
                if mm > numel(a)
                    mm = 1;
                end

            end
            colormap(jet);
            %errorbar(t,graphs_data.plot_data.(par{i}),graphs_data.plot_error.(par{i}));
            handler_legend = legend(graphs_data.legend,'Location','northwestoutside','FontSize',8);
            set(h,'position',get(0,'screensize'))
%             set(handler_legend,'FontSize',6);
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
            axis([0 max(max(t)) 0 1])


            axis('manual','auto y');
            hold off;
            graphs_data.plot_data.(par{i})((sum(isnan(graphs_data.plot_data.(par{i})'))>1)',:) = [];
            cur_data = graphs_data.plot_data.(par{i});
            cur_data(sum(isnan(cur_data),2) >= 0,:) =[];
            [p.(par{i}),table.(par{i})] = anova_rm(cur_data','off');
            if p.(par{i}) <= 0.00001
                Pvalue = '0.00001';
            else
                Pvalue = num2str(p.(par{i}));
            end
            text(0.75,1,['p value = ' Pvalue],'Units','normalized')
            %xlswrite([folder_path '\Time Dependent\Anova Table ' p.(par{i}) '.xls'],table.(par{i}));
            saveas(handler.(par{i}) ,[folder_path '\Time Dependent\Images\Average ' par{i} ' over time'],'tiff');    
            saveas(handler.(par{i}) ,[folder_path '\Time Dependent\Average ' par{i} ' over time']);   


            Data = [nan(1,size(graphs_data.plot_data.(par{i}),2)); graphs_data.plot_data.(par{i}) ; nan(1,size(graphs_data.plot_data.(par{i}),2)); graphs_data.plot_error.(par{i})];
            %xlswrite([folder_path '\Time Dependent\Graphs Data'],Data,par{i});
            %xlswrite([folder_path '\Time Dependent\Graphs Data'],graphs_data.names,par{i});

            %{
            data = graphs_data.plot_data.(par{i});
            [p,table] = permAnova(data);
            p_table = [];
            for j = 1 : (size(p,2)-1)
                cur_index = [];
                cur_p = [];
                for k = j + 1 : size(p,2)
                    cur_index = [cur_index;[j,k]];
                    cur_p = [cur_p; p{j,k}];
                end
                p_table = [p_table; [cur_index cur_p]];
            end
            p_table = [nan(1,size(p_table,2)); p_table];
            Titles = {'Index 1','Index 2','p value 1','p value 2'};
            xlswrite([folder_path '\Plots\Multcompare Time Dependent ' par{i}],p_table);
            xlswrite([folder_path '\Plots\Multcompare Time Dependent ' par{i}],Titles);
            %}
            %}
        end
    end
    disp('Time Dependency - Done!');
end 
function [p,table] = permAnova(data)
    data = data'; 
    p = cell(size(data,1)-1);
    table = cell(size(data,1)-1);
    for i = 1 : size(data,1)-1
        for j = i+1 : size(data,1)
            [p{i,j},table{i,j}] = anova_rm([data(i,:);data(j,:)],'Off');
            cur_index = [i j];            
        end
    end
end

    

function newData = Rearrange_par2time(data,curArr,newArr)
    
    newData = [];
    for i = 1 : length(newArr)
        newData = [newData data(:,strcmp(curArr,newArr(i))')];
    end
end

function [p, table] = anova_rm(X, displayopt)
%   [p, table] = anova_rm(X, displayopt)
%   Single factor, tepeated measures ANOVA.
%
%   [p, table] = anova_rm(X, displayopt) performs a repeated measures ANOVA
%   for comparing the means of two or more columns (time) in one or more
%   samples(groups). Unbalanced samples (i.e. different number of subjects 
%   per group) is supported though the number of columns (followups)should 
%   be the same. 
%
%   DISPLAYOPT can be 'on' (the default) to display the ANOVA table, or 
%   'off' to skip the display. For a design with only one group and two or 
%   more follow-ups, X should be a matrix with one row for each subject. 
%   In a design with multiple groups, X should be a cell array of matrixes.
% 
%   Example: Gait-Cycle-times of a group of 7 PD patients have been
%   measured 3 times, in one baseline and two follow-ups:
%
%   patients = [
%    1.1015    1.0675    1.1264
%    0.9850    1.0061    1.0230
%    1.2253    1.2021    1.1248
%    1.0231    1.0573    1.0529
%    1.0612    1.0055    1.0600
%    1.0389    1.0219    1.0793
%    1.0869    1.1619    1.0827 ];
%
%   more over, a group of 8 controls has been measured in the same protocol:
%
%   controls = [
%     0.9646    0.9821    0.9709
%     0.9768    0.9735    0.9576
%     1.0140    0.9689    0.9328
%     0.9391    0.9532    0.9237
%     1.0207    1.0306    0.9482
%     0.9684    0.9398    0.9501
%     1.0692    1.0601    1.0766
%     1.0187    1.0534    1.0802 ];
%
%   We are interested to see if the performance of the patients for the
%   followups were the same or not:
%  
%   p = anova_rm(patients);
%
%   By considering the both groups, we can also check to see if the 
%   follow-ups were significantly different and also check two see that the
%   two groups had a different performance:
%
%   p = anova_rm({patients controls});
%
%
%   ref: Statistical Methods for the Analysis of Repeated Measurements, 
%     C. S. Daivs, Springer, 2002
%
%   Copyright 2008, Arash Salarian
%   mailto://arash.salarian@ieee.org
%

if nargin < 2
    displayopt = 'on';
end

if ~iscell(X)
    X = {X};
end

%number of groups
s = size(X,2);  

%subjects per group 
n_h = zeros(s, 1);
for h=1:s
    n_h(h) = size(X{h}, 1);    
end
n = sum(n_h);

%number of follow-ups
t = size(X{1},2);   

% overall mean
y = 0;
for h=1:s
    y = y + sum(sum(X{h}));
end
y = y / (n * t);

% allocate means
y_h = zeros(s,1);
y_j = zeros(t,1);
y_hj = zeros(s,t);
y_hi = cell(s,1);
for h=1:s
    y_hi{h} = zeros(n_h(h),1);
end

% group means
for h=1:s
    y_h(h) = sum(sum(X{h})) / (n_h(h) * t);
end

% follow-up means
for j=1:t
    y_j(j) = 0;
    for h=1:s
        y_j(j) = y_j(j) + sum(X{h}(:,j));
    end
    y_j(j) = y_j(j) / n;
end

% group h and time j mean
for h=1:s
    for j=1:t
        y_hj(h,j) = sum(X{h}(:,j) / n_h(h));
    end
end

% subject i'th of group h mean
for h=1:s
    for i=1:n_h(h)
        y_hi{h}(i) = sum(X{h}(i,:)) / t;
    end
end

% calculate the sum of squares
ssG = 0;
ssSG = 0;
ssT = 0;
ssGT = 0;
ssR = 0;

for h=1:s
    for i=1:n_h(h)
        for j=1:t
            ssG  = ssG  + (y_h(h) - y)^2;
            ssSG = ssSG + (y_hi{h}(i) - y_h(h))^2;
            ssT  = ssT  + (y_j(j) - y)^2;
            ssGT = ssGT + (y_hj(h,j) - y_h(h) - y_j(j) + y)^2;
            ssR  = ssR  + (X{h}(i,j) - y_hj(h,j) - y_hi{h}(i) + y_h(h))^2;
        end
    end
end

% calculate means
if s > 1
    msG  = ssG  / (s-1);
    msGT = ssGT / ((s-1)*(t-1));
end
msSG = ssSG / (n-s);
msT  = ssT  / (t-1);
msR  = ssR  / ((n-s)*(t-1));


% calculate the F-statistics
if s > 1
    FG  = msG  / msSG;
    FGT = msGT / msR;
end
FT  = msT  / msR;
FSG = msSG / msR;


% single or multiple sample designs?
if s > 1
    % case for multiple samples
    pG  = 1 - fcdf(FG, s-1, n-s);
    pT  = 1 - fcdf(FT, t-1, (n-s)*(t-1));
    pGT = 1 - fcdf(FGT, (s-1)*(t-1), (n-s)*(t-1));
    pSG = 1 - fcdf(FSG, n-s, (n-s)*(t-1));

    p = [pT, pG, pSG, pGT];

    table = { 'Source' 'SS' 'df' 'MS' 'F' 'Prob>F'
        'Time'  ssT t-1 msT FT pT
        'Group' ssG s-1 msG FG pG
        'Ineratcion' ssGT (s-1)*(t-1) msGT FGT pGT
        'Subjects (matching)' ssSG n-s msSG FSG pSG
        'Error' ssR (n-s)*(t-1) msR  [] []
        'Total' [] [] [] [] []
        };
    table{end, 2} = sum([table{2:end-1,2}]);
    table{end, 3} = sum([table{2:end-1,3}]);

    if (isequal(displayopt, 'on'))
        digits = [-1 -1 0 -1 2 4];
        statdisptable(table, 'multi-sample repeated measures ANOVA', 'ANOVA Table', '', digits);
    end
else
    % case for only one sample
    pT  = 1 - fcdf(FT, t-1, (n-s)*(t-1));
    pSG = 1 - fcdf(FSG, n-s, (n-s)*(t-1));

    p = [pT, pSG];

    table = { 'Source' 'SS' 'df' 'MS' 'F' 'Prob>F'
        'Time'  ssT t-1 msT FT pT
        'Subjects (matching)' ssSG n-s msSG FSG pSG
        'Error' ssR (n-s)*(t-1) msR  [] []
        'Total' [] [] [] [] []
        };
    table{end, 2} = sum([table{2:end-1,2}]);
    table{end, 3} = sum([table{2:end-1,3}]);

    if (isequal(displayopt, 'on'))
        digits = [-1 -1 0 -1 2 4];
        statdisptable(table, 'repeated measures ANOVA', 'ANOVA Table', '', digits);
    end
end
end