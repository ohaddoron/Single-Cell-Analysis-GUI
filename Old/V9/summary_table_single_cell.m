function summary_table_single_cell ( folderPath, outputLocation, par )

    files = dir([folderPath '\*.mat']);
    num_of_mat_files = numel(files);
    
    disp(['opening folder ' folderPath]);
    
    for i = 1 : num_of_mat_files
        disp(['loading file ' files(i).name]);
        file_path = [folderPath '\' files(i).name];
        temp = load(file_path);
        Atname = fieldnames(temp);
        At = temp.(Atname{1});
        
        
        for j = 1 : numel(par)
            if i == 1
                data.(par{j}) = [];
            end
            cur_par = At.(par{j})(:);
            data.(par{j}) = [data.(par{j}); cur_par];
        end
        newData = [];
        for j = 1 : numel(par)
            newData = padconcatenation(newData,data.(par{j}),2);
        end
    end
    
    data = [cell(1,size(newData,2)) ;num2cell(newData)];
    data = [num2cell((1:size(data,1))') data];
    xlswrite([outputLocation '\Summary Table Single Cell.xlsx'],data);
    xlswrite([outputLocation '\Summary Table Single Cell.xlsx'],[nan par]);
end