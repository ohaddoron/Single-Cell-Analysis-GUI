function summary_table_single_cell ( file_path, outputLocation, par )

%     files = dir([folderPath '\*.mat']);
%     num_of_mat_files = numel(files);
    
%     disp(['opening folder ' folderPath]);
    
%     disp(['loading file ' files(i).name]);
%     file_path = [folderPath '\' files(i).name];
    temp = load(file_path);
    Atname = fieldnames(temp);
    At = temp.(Atname{1});


    for j = 1 : numel(par)
        data.(par{j}) = [];
        if size(At.(par{j}),1) == 1
            cur_par = repmat(At.(par{j})(:),size(At.x_Pos,1),1);
        else
            cur_par = At.(par{j})(:);
        end
        data.(par{j}) = [data.(par{j}); cur_par];
    end
    newData = [];
    for j = 1 : numel(par)
        newData = padconcatenation(newData,data.(par{j}),2);
    end
    newData(sum(isnan(newData),2)~= 0,:) = [];
    
    data = [cell(1,size(newData,2)) ;num2cell(newData)];
    data = [num2cell((0:size(data,1)-1)') data];
    xlswrite([outputLocation '\Summary Table Single Cell.xlsx'],data);
    xlswrite([outputLocation '\Summary Table Single Cell.xlsx'],[nan par]);
end