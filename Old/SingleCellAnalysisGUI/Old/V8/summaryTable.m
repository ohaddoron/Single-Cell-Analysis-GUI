function summaryTable(folder_paths,par,outputLocation,TP)
    
    
    parName = nan;
    expName = nan;
    Table = [];
    for k = 1 : length(folder_paths)
        folder_path = folder_paths{k};
        mkdir([outputLocation '\Cluster Analysis\Image']);
        files = dir([folder_path '\*.mat']);
        num_of_mat_files = length(files);
        for i = 1 : num_of_mat_files
            file_path = [folder_path '\' files(i).name];
            temp = load(file_path);
            name = fieldnames(temp);
            data_struct = temp.(name{1});
            cur_data = [];
            for j = 1 : length(par)
                if k == 1 && i == 1
                    parName = [parName {par{j}}]; 
                end
                
                if j == 1
                    expName = [expName; {strrep(strrep(files(i).name,'NNN0',''),'.mat','')}];
                end
                
                if TP.choice == 1
                    cur_data = [cur_data nanmean(abs(data_struct.(par{j})(:)))];
                else
                    dat = abs(data_struct.(par{j})(TP.tl:TP.th,:));
                    cur_data = nanmean(dat(:));
                end
            end
            Table = [Table; cur_data];
        end
        
    end
    Table = [nan(1,size(Table,2));Table];
    Table = [nan(size(Table,1),1) Table];
    if TP.transpose ~= 0
        Table = Table';
        expName = expName';
        parName = parName';
    end
    outputLocation = [outputLocation '\Cluster Analysis\Summary Table'];
    xlswrite(outputLocation,Table);
    xlswrite(outputLocation,expName);
    xlswrite(outputLocation,parName);
end
                
                
                    
                    
                    
                
                
                
            
            
            