function Renaming(folderPath,outputLocation,xlsTemplatePath)

    %mkdir([folderPath '\Old'])
    files = dir([folderPath '\*.xls']);
    if isempty(files)
        files = dir([folderPath '\*.xlsx']);
    end
    %files = dir([folderPath '\*.tif']);
    [data,~,raw] = xlsread(xlsTemplatePath);
    for k = 1 : length(files)
        c = [];
        for i = 65 : 72
            for j = 1 : 12
                c = strfind(files(k).name,[char(i) num2str(j)]);
                if (~isempty(c)==1)
                    rowLoc = strcmp(raw(:,1),char(i));
                    colLoc = (data(1,:) == j);
                    remi = i;
                    remj = j;
                    if ~isempty(str2num(files(k).name(c+2))) == 1 && j<10
                        rowLoc = [];
                        colLoc = [];
                        remi = i;
                        remj = j;
                    end
                end
            end
        end
        if remj >= 10
            EXPname = cell2mat([raw(2,1:5) char(remi) num2str(remj) raw((find(rowLoc,1,'first'):find(rowLoc,1,'first')+5),find(colLoc,1,'first')+2)' raw{2,6}]);
        else
            EXPname = cell2mat([raw(2,1:5) char(remi) '0' num2str(remj) raw((find(rowLoc,1,'first'):find(rowLoc,1,'first')+5),find(colLoc,1,'first')+2)' raw{2,6}]);
        end
        file1 = fullfile(folderPath,files(k).name);
        file2 = [char(outputLocation) '\' EXPname '.xls'];
        %copyfile(file1,[folderPath '\Old\']);
        disp(['Renaming ' strrep(files(k).name,'.xls','') ' to ' strrep(EXPname,'.xls','')]);
        copyfile(file1,file2);
    end
    %if ~strcmp(folderPath,outputLocation)
    %        copyfile([folderPath '\Old\*.xls'],folderPath);
    %        rmdir([folderPath '\Old'],'s');
    %end
end
         