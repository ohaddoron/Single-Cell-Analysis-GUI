function descreptiveStatistics(folder_path,par,genNum)

    graphs_data.plot_data = {};
    graphs_data.cell_count = [];
    graphs_data.labels = {};
    graphs_data.plot_handlers = {};
    graphs_data.names = {};
    
    mkdir([folder_path '\Descreptive Statistics']);
    disp(['opening folder ' folder_path]);
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    titles = {'Cell ID','Time Point','Reppetitions','Treatment','Value'};
    
        
    for j = 1:length(par)
        for i=1:num_of_mat_files      
            if i == 1
                xls_build = nan(1,5);
                %cellID = nan(1,5);
                cellID = {''};
            end
            if j == 1
                decoder{i,1} = strrep(strrep(files(i).name,'NNN0',''),'.mat','');
                decoder{i,2} = num2str(i);
               
            end
                
            file_path = [folder_path '\' files(i).name];
            temp = load(file_path);
            name = fieldnames(temp);
            data_struct = temp.(name{1});
            Val = data_struct.(par{j});
            t = (1:size(Val,1))';
            for k = 1 : size(Val,2)
                Value = Val(:,k);
                builder = nan(sum(~isnan(Val(:,k))),5);
                c = Coder(files(i).name,genNum,k,i);
                builder(1:sum(~isnan(Val(:,k))),1) = c;
                builder(1:sum(~isnan(Val(:,k))),2) = t(~isnan(Val(:,k)));
                builder(1:sum(~isnan(Val(:,k))),3) = 1:length(t(~isnan(Val(:,k))));
                builder(1:sum(~isnan(Val(:,k))),4) = str2double([num2str(i) num2str(genNum)]);
                builder(1:sum(~isnan(Val(:,k))),5) = Value(~isnan(Value));
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

function cellID = Coder(fileName,genNum,cellNum,expNum)

    %cellID = [num2str(double((fileName(1)))) num2str(double((fileName(2))))];
    switch length(fileName(1))
        case 1
            cellID = ['00' num2str(double(fileName(1)))];
        case 2 
            cellID = ['0' num2str(double(fileName(1)))];
        case 3
            cellID = num2str(double(fileName(1)));
    end
    switch length(fileName(2))
        case 1
            cellID = [cellID '00' num2str(double(fileName(2)))];
        case 2 
            cellID = [cellID '0' num2str(double(fileName(2)))];
        case 3
            cellID = [cellID num2str(double(fileName(2)))];
    end
        
    cellID = [cellID num2str(fileName(3:9))];
    cellID = [cellID num2str(expNum)];
    if length(num2str(expNum)) < 2
        cellID = [cellID '0' num2str(expNum)];
    else
        cellID = [cellID num2str(expNum)];
    end
    switch length(num2str(genNum))
        case 1
            cellID = [cellID '0' num2str(genNum)];
        case 2
            cellID = [cellID genNum];
    end
    switch length(num2str(cellNum))
        case 1
            cellID = [cellID '000' num2str(cellNum)];
        case 2
            cellID = [cellID '00' num2str(cellNum)];
        case 3  
            cellID = [cellID '0' num2str(cellNum)];
        case 4
            cellID = [cellID num2str(cellNum)];
    end
    
     cellID = str2num(cellID);
end
            
                
                
                
            
            
    