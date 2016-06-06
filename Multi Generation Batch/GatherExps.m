function GatherExps ( folderPath , outputLocation)

    files = dir([folderPath '\*.xlsm']);
    num_of_xls = numel(files);
    
    disp(['opening ' folderPath]);
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    for i = 1 : num_of_xls
        disp(['opening ' files(i).name]);
        
        outPath = fullfile(outputLocation,'Templates');
        mkdir(outPath);
        copyfile(fullfile(folderPath,files(i).name),fullfile(outPath,files(i).name));
        
        filePath = [folderPath '\' files(i).name];
        
        [~,~,raw] = xlsread(filePath);
        
        [Rup,Cup] = find(cellfun(cellfind('Exp Sub Name'),raw));
        [Rdown,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
        [~,Cend] = find(cellfun(cellfind('Template'),raw));
        a = raw(Rup+1:Rdown-2,Cup+1:Cend-1);
        b = a(:);
        b(strcmp(b,'NNN0')) = [];
        [Rup,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
        [Rdown,~] = find(cellfun(cellfind('Protocol file'),raw));
        
        Paths = raw(Rup+2:Rdown-1,2:3);
        Paths(cellfun(@(x) any(isnan(x)),Paths)) = {'NNN0'};
        Paths(sum(strcmp(Paths,'NNN0'),2) == 2,:) = [];
        
        try
            expID = [expID b'];
        catch
            expID = b';
        end
        try 
            expPaths = [expPaths; Paths];
        catch
            expPaths = Paths;
        end
        
    end
    curExp = expID;
    Paths = expPaths;curExpTemp = curExp(1:end);
    curExpTemp(strcmp(curExpTemp,'NNN0')) = [];
    curExp = curExpTemp;
    curExp(cellfun(@(V) any(isnan(V(:))), curExp)) = [];
    for j = 1 : length(curExp)
        curExpName = curExp{j}(1:5);
        curExpCode = curExp{j}(6:end); 
        tmp = Paths(strcmp(Paths(:,1),curExpName),2);
        curExpFolderPath = tmp(1);
        files = dir([curExpFolderPath{1} '\*.mat']);
        for k = 1 : length(files)
            if ~isempty(strfind(files(k).name,curExpCode)) == 1
                try
                    copyfile([curExpFolderPath{1} '\' files(k).name],outputLocation);
                catch 
                    continue;
                end
            end
        end       
    end
