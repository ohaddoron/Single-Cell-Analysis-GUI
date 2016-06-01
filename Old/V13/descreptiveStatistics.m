function descreptiveStatistics(folder_path,par)

    graphs_data.plot_data = {};
    graphs_data.cell_count = [];
    graphs_data.labels = {};
    graphs_data.plot_handlers = {};
    graphs_data.names = {};
    
    mkdir([folder_path '\Descreptive Statistics']);
    disp(['opening folder ' folder_path]);
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    
    
    Treats = {''};
    for i = 1 : numel(files)
%         curChannel = files(i).name(12:14);
        curTreats = strrep(strrep(files(i).name(23:end),'NNN0',''),'.mat','');
        curTreats = curTreats(1:end-4); % Removing the SA/WH/AM part of the name. 
% % This segment should be used if you wish to use the channel as a
% % parameter as well

%         IndexC = strfind(Treats, curChannel);
%         Index = find(not(cellfun('isempty', IndexC)));
%         if isempty(Index)
%             Treats = [curChannel Treats];
%         end


        for k = 1 : 4 : numel(curTreats)
            IndexC = strfind(Treats,curTreats(k:k+2));
            Index = find(not(cellfun('isempty',IndexC)));
            if isempty(Index)
                Treats = [Treats curTreats(k:k+2)];
            end
        end
        Treats(strcmp(Treats,'')) = [];
    end
    titles = {'Cell ID','Time Point','Reppetitions','Y Position',Treats{:},'Value'};
        
    for j = 1:length(par)
        for i=1:num_of_mat_files      
            if i == 1
                xls_build = cell(1,5+numel(Treats));
                %cellID = nan(1,5);
                cellID = {''};
            end
            indicator = zeros(1,numel(Treats));
            curName = files(i).name;
            curChannel = curName(12:14);
            curTreats = strrep(strrep(curName(19:end),'NNN0',''),'.mat','');
            for n = 1 : 4 : numel(curTreats)
                indicator(strcmp(Treats,curTreats(n:n+2))) = str2num(curTreats(n+3));
            end
            indicator(strcmp(Treats,curChannel)) = 1;
            
            if j == 1
                decoder{i,1} = strrep(strrep(files(i).name,'NNN0',''),'.mat','');
                decoder{i,2} = num2str(i);
               
            end
                
            file_path = [folder_path '\' files(i).name];
            temp = load(file_path);
            name = fieldnames(temp);
            data_struct = temp.(name{1});
            YPos = data_struct.y_Pos;
            Val = data_struct.(par{j});
            t = (1:size(Val,1))';
            for k = 1 : size(Val,2)
                Value = Val(:,k);
                y_Pos = YPos(:,k);
                builder = [];
                c = Coder(indicator,files,i,k);
%                 builder(1:sum(~isnan(Val(:,k))),1) = repmat({c},sum(~isnan(Val(:,k))),1);
%                 builder(1:sum(~isnan(Val(:,k))),2) = num2cell(t(~isnan(Val(:,k))));
%                 builder(1:sum(~isnan(Val(:,k))),3) = num2cell(1:length(t(~isnan(Val(:,k)))));
%                 builder(1:sum(~isnan(Val(:,k))),4) = num2cell(str2double([num2str(i) num2str(genNum)]));
%                 builder(1:sum(~isnan(Val(:,k))),5) = num2cell(Value(~isnan(Value)));
                
                
                
                builder = [builder repmat({c},sum(~isnan(Val(:,k))),1)]; % ID
                builder = [builder num2cell(t(~isnan(Val(:,k))));]; % Time
                builder = [builder num2cell(1:length(t(~isnan(Val(:,k)))))'];% Rep
                builder = [builder num2cell(y_Pos(~isnan(Val(:,k))))];
                builder = [builder num2cell(repmat(indicator,sum(~isnan(Val(:,k))),1))];
                builder = [builder num2cell(Value(~isnan(Value)))];
                
                xls_build = [xls_build; builder];
                %c = Coder(files(i).name,genNum,k,i);
                %ID(1:sum(~isnan(Val(:,k))),1) = {c};
                %cellID = [cellID; ID];
                
                
                
            end
        end
        xlswrite([folder_path '\Descreptive Statistics\' par{j} '.xlsx'],xls_build);
        %xlswrite([folder_path '\Descreptive Statistics\' par{j} '.xlsx'],'Sheet1','a:a',cellID);
        xlswrite([folder_path '\Descreptive Statistics\' par{j} '.xlsx'],titles)
    end
    xlswrite([folder_path '\Descreptive Statistics\Decode.xlsx'],decoder);
    
    
    
end

function cellID = Coder(indicator,files,i,k)

n = numel(files);
if n < 3
    cellID = 1*10^(2 + n+numel(indicator));
else
    cellID = 1*10^(n+numel(indicator));
end
if ~isempty (str2num(files(i).name(3:5)));
    cellID = cellID * (str2num(files(i).name(3:5)));
else
    cellID = cellID * (str2num(files(i).name(4:5)));
end

for m = 1 : numel(indicator)
    cellID = cellID + indicator(m)*10^(3 + numel(indicator)-m);
end
cellID = cellID + k;
end
                
    