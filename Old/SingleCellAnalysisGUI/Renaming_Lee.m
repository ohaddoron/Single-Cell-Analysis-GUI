function Renaming_Lee ( folderPath , cellType , Ch ,xlsPath )

    Exp = ['LH001040115' Ch '000' cellType];
    files = dir([folderPath '\*.tif']);
    mkdir([folderPath '\Renamed']);
    mkdir([folderPath '\Old']);
    for i = 1 : length(files)
        index = strfind(files(i).name,'mix');
        mix = files(i).name(index + 3);
        [~,~,raw] = xlsread(xlsPath);
        curExp = Exp;
        curExp(18 - length(num2str(i)) + 1: 18) = num2str(i);
        filePath = [folderPath '\' files(i).name];
        mixRes = raw(strcmp(raw,mix),2:3);
        if strfind(files(i).name,'HGF+PHA')
            curExp = [curExp 'HGF1PHA1' strrep([mixRes{1} mixRes{2}],' ','') 'NNN0'];
            copyfile(filePath,[folderPath '\Old\' files(i).name]);
            movefile(filePath,[folderPath '\Renamed\' curExp '.tif']);
        else
            if strfind(files(i).name,'HGF')
                curExp = [curExp 'HGF1' strrep([mixRes{1} mixRes{2}],' ','') 'NNN0NNN0'];
                copyfile(filePath,[folderPath '\Old\' files(i).name]);
                movefile(filePath,[folderPath '\Renamed\' curExp '.tif']);
            end
            if strfind(files(i).name,'PHA')
                curExp = [curExp 'PHA1' strrep([mixRes{1} mixRes{2}],' ','') 'NNN0NNN0'];
                copyfile(filePath,[folderPath '\Old\' files(i).name]);
                movefile(filePath,[folderPath '\Renamed\' curExp '.tif']);
            end
            if strfind(files(i).name,'NT')
                curExp = [curExp 'CON1' strrep([mixRes{1} mixRes{2}],' ','') 'NNN0NNN0'];
                copyfile(filePath,[folderPath '\Old\' files(i).name]);
                movefile(filePath,[folderPath '\Renamed\' curExp '.tif']);
            end
        end
    end
end
        
        
            
        