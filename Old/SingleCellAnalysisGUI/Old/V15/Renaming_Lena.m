function Renaming_Lena(folderPath,xlsPath,sheetName)

    mkdir([folderPath '\Old']);
    files = dir([folderPath '\*.xls']);
    [~,~,raw] = xlsread(xlsPath,sheetName);
    for k = 1 : length(files)
        fileName = files(k).name;
        index = strfind(fileName,'.xls');
        code = fileName(index-2:end);
        a = raw(4:end,1);
        a(cellfun(@(V) any(isnan(V(:))), a)) = [];
        pos = find(~cellfun(@isempty,strfind(a,code))) + 3;
        code = strrep(strrep(code,'_','0'),'.xls','');
        newName = [cell2mat(raw(2,1:5)) '0' code raw{pos,2} '.xls'];
        file1 = fullfile(folderPath,files(k).name);
        file2 = fullfile(folderPath,newName);
        copyfile(file1,[folderPath '\Old\']);
        movefile(file1,file2);
        disp(['Renaming ' strrep(files(k).name,'.xls','') ' to ' strrep(newName,'.xls','')]);
    end
end
    
    
    
    
    
    
    
