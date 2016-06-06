function Rename_for_Renaming (folderPath , xlsPath)


    mkdir([folderPath '\Renamed']);
    files = dir([folderPath '\*.xls']);
    if isempty(files)
        files = dir([folderPath '\*.xlsx']);
    end
    [~,~,raw] = xlsread(xlsPath);
    for i = 1 : numel(files)
        for ii = 1 : size(raw,1)
            if ~isempty(strfind(files(i).name,raw{ii,1}))
                copyfile([folderPath '\' files(i).name],[folderPath '\Renamed\' raw{ii,2} '_' files(i).name]);
            end
        end
    end
        
end