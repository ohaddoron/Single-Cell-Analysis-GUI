function addPrefix (folderPath,ExpType)

    files = dir([folderPath '\*.xlsx']);
    num_of_xls_files = numel(files);
    mkdir([folderPath '\Old']);
    
    for i = 1 : num_of_xls_files 
        [~,~,raw] = xlsread([folderPath '\' files(i).name]);
        raw{1,6} = 'Exp Type';
        raw(2,6) = ExpType;
        copyfile([folderPath '\' files(i).name],[folderPath '\Old\' files(i).name]);
        xlswrite([folderPath '\' files(i).name],raw);
        
    end
end