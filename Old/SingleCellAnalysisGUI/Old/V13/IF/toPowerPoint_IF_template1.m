function toPowerPoint_IF_template1 (xlsLayoutPaths,rawPaths,binPaths,barPaths,boxPaths,outputLocations,pptPaths)
    
    warning('off','all');
    numOfExps = numel(xlsLayoutPaths);
    fh = @(x) all(isnan(x(:)));
    for i = 1 : numOfExps
        
        rawFiles = dir([rawPaths{i} '\*.tif']);
        binFiles = dir([binPaths{i} '\*.tif']);
        barFiles = dir([barPaths{i} '\*.fig']);
        boxFiles = dir([boxPaths{i} '\*.fig']);
            
        outputLocation = outputLocations{i};
        
        xlsLayout = xlsLayoutPaths{i};
        
        [~,~,raw] = xlsread(xlsLayout);
        
        row = sum(strcmp(raw,'Ab1 Channel'),2);
        col = sum(strcmp(raw,'Ab1 Channel'),1);
        Ab1Channel = raw{find(row)+1,logical(col)};
        
        row = sum(strcmp(raw,'Ab2 Channel'),2);
        col = sum(strcmp(raw,'Ab2 Channel'),1);
        
        Ab2Channel = raw{find(row)+1,logical(col)};
        
        %% cellTypes
        row = sum(strcmp(raw,'Cell types'),2);
        col = sum(strcmp(raw,'Cell types'),1);
        cellTypes = raw(find(row) + 1:end,col==1);
        cellTypes(cellfun(fh, cellTypes)) = [];
        
        %% Treatment
        row = sum(strcmp(raw,'Treatment'),2);
        col = sum(strcmp(raw,'Treatment'),1);
        Treatments = raw(find(row) + 1:end,col==1);
        Treatments(cellfun(fh, Treatments)) = [];
        
        %% Ab1
        row = sum(strcmp(raw,'Ab1'),2);
        col = sum(strcmp(raw,'Ab1'),1);
        Ab1 = raw(find(row) + 1:end,col==1);
        Ab1(cellfun(fh, Ab1)) = [];
        
        
        
        %% Ab2
        row = sum(strcmp(raw,'Ab2'),2);
        col = sum(strcmp(raw,'Ab2'),1);
        Ab2 = raw(find(row) + 1:end,col==1);
        Ab2(cellfun(fh, Ab2)) = [];
        
        
        %%
        Ab1(strcmp(Ab1,'NNN0')) = '';
        Ab2(strcmp(Ab2,'NNN0')) = '';
        for ii = 1 : numel(cellTypes)
           
            curCellType = cellTypes{ii};
            folderPath = [outputLocation '\' curCellType];
            
            mkdir([folderPath '\Raw']);
            mkdir([folderPath '\Bin']);
            mkdir([folderPath '\Bar']);
            mkdir([folderPath '\Box']);
            
            
            % Moving the raw data from the original folder path to the used
            % folder path
            
            cellIdx = find(~cellfun(@isempty,strfind({rawFiles.name},curCellType)));
            
            for iii = 1 : numel(cellIdx)
                file1 = [rawPaths{i} '\' rawFiles(cellIdx(iii)).name];
                file2 = [folderPath '\Raw\' rawFiles(cellIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                cellTypeFiles = dir([folderPath '\Raw\*.tif']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb2)));
                
                mkdir([folderPath '\Raw\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Raw\' cellTypeFiles(Ab1Idx(k)).name],[folderPath '\Raw\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            %curRawPath = [folderPath '\Raw\' curAb1 curAb2];
            
            
            % Moving the bin data from the original folder path to the used
            % folder path
            
            cellIdx = find(~cellfun(@isempty,strfind({binFiles.name},curCellType)));
            
            for iii = 1 : numel(cellIdx)
                file1 = [binPaths{i} '\' binFiles(cellIdx(iii)).name];
                file2 = [folderPath '\Bin\' binFiles(cellIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                cellTypeFiles = dir([folderPath '\Bin\*.tif']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb2)));
                
                mkdir([folderPath '\Bin\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Bin\' cellTypeFiles(Ab1Idx(k)).name],[folderPath '\Bin\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            %curBinPath = [folderPath '\Bin\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name];
            
            
            % Moving the bar data from the original folder path to the used
            % folder path
            
            cellIdx = find(~cellfun(@isempty,strfind({barFiles.name},curCellType)));
            
            for iii = 1 : numel(cellIdx)
                file1 = [barPaths{i} '\' barFiles(cellIdx(iii)).name];
                file2 = [folderPath '\Bar\' barFiles(cellIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                cellTypeFiles = dir([folderPath '\Bar\*.fig']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb2)));
                
                mkdir([folderPath '\Bar\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Bar\' cellTypeFiles(Ab1Idx(k)).name],[folderPath '\Bar\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            %curBarPath = [folderPath '\Bar\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name];
            
            
            % Moving the box data from the original folder path to the used
            % folder path
            
            cellIdx = find(~cellfun(@isempty,strfind({boxFiles.name},curCellType)));
            
            for iii = 1 : numel(cellIdx)
                file1 = [boxPaths{i} '\' boxFiles(cellIdx(iii)).name];
                file2 = [folderPath '\Box\' boxFiles(cellIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                cellTypeFiles = dir([folderPath '\Box\*.fig']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({cellTypeFiles.name},curAb2)));
                
                mkdir([folderPath '\Box\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Box\' cellTypeFiles(Ab1Idx(k)).name],[folderPath '\Box\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            
            %curBoxPath = [folderPath '\Box\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name];
                    
        end
        PPTcounter = 1;
        toPPT('openExisting',pptPaths{i});
        for ii = 1 : numel(cellTypes)
            curCellType = cellTypes{ii};
            curCellTypePath = [outputLocation '\' curCellType];
            
            for iii = 1 : numel(Ab1) 
                rawFiles = dir([curCellTypePath '\Raw\' Ab1{iii} Ab2{iii} '\*.tif']);
                binFiles = dir([curCellTypePath '\Bin\' Ab1{iii} Ab2{iii} '\*.tif']);
                barFiles = dir([curCellTypePath '\Bar\' Ab1{iii} Ab2{iii} '\*.fig']);
                boxFiles = dir([curCellTypePath '\Box\' Ab1{iii} Ab2{iii} '\*.fig']);
                ch1RawIdx = find(~cellfun(@isempty,strfind({rawFiles.name},Ab1Channel)));
                ch2RawIdx = find(~cellfun(@isempty,strfind({rawFiles.name},Ab2Channel)));
                ch1BinIdx = find(~cellfun(@isempty,strfind({binFiles.name},Ab1Channel)));
                ch2BinIdx = find(~cellfun(@isempty,strfind({binFiles.name},Ab2Channel)));
                rawFilesL = rawFiles(ch1RawIdx);
                rawFilesR = rawFiles(ch2RawIdx);
                binFilesL = binFiles(ch1BinIdx);
                binFilesR = binFiles(ch2BinIdx);
                for k = 1 : numel(Treatments)
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({rawFilesL.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        imRaw_l = imread([curCellTypePath '\Raw\' Ab1{iii} Ab2{iii} '\' rawFiles(ch1RawIdx(curFileIdx)).name]);
                        h = figure('Visible','Off');
                        colormap(gray);
                        imagesc(imRaw_l);
                        set(h.CurrentAxes,'Visible','Off');
                    catch
                        h = figure('Visible','Off');
                        
                    end
                    toPPT(h,'SlideNumber',PPTcounter);
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({binFilesL.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        imBin_l = imread([curCellTypePath '\Bin\' Ab1{iii} Ab2{iii} '\' binFiles(ch1BinIdx(curFileIdx)).name]);
                        h = figure('Visible','Off');
                        colormap(hot);
                        imagesc(imBin_l);
                        set(h.CurrentAxes,'Visible','Off');
                    catch
                        h = figure('Visible','Off');
                       
                    end
                    toPPT(h,'SlideNumber',PPTcounter);
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({rawFilesR.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        imRaw_r = imread([curCellTypePath '\Raw\' Ab1{iii} Ab2{iii} '\' rawFiles(ch2RawIdx(curFileIdx)).name]);
                        h = figure('Visible','Off');
                        colormap(gray);
                        imagesc(imRaw_r);
                        set(h.CurrentAxes,'Visible','Off');
                    catch
                        h = figure('Visible','Off');
                        
                    end
                    toPPT(h,'SlideNumber',PPTcounter);
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({binFilesR.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        imBin_r = imread([curCellTypePath '\Bin\' Ab1{iii} Ab2{iii} '\' binFiles(ch2BinIdx(curFileIdx)).name]);
                        h = figure('Visible','Off');
                        colormap(hot);
                        imagesc(imBin_r);
                        set(h.CurrentAxes,'Visible','Off');
                    catch
                        h = figure('Visible','Off');
                        
                    end
                    toPPT(h,'SlideNumber',PPTcounter);
                end
                close all;
                PPTcounter = PPTcounter + 1;
                ch1BarIdx = find(~cellfun(@isempty,strfind({barFiles.name},Ab1Channel)));
                ch2BarIdx = find(~cellfun(@isempty,strfind({barFiles.name},Ab2Channel)));
                ch1BoxIdx = find(~cellfun(@isempty,strfind({boxFiles.name},Ab1Channel)));
                ch2BoxIdx = find(~cellfun(@isempty,strfind({boxFiles.name},Ab2Channel)));
                barFilesL = barFiles(ch1RawIdx);
                barFilesR = barFiles(ch2RawIdx);
                boxFilesL = boxFiles(ch1BinIdx);
                boxFilesR = boxFiles(ch2BinIdx);
                for k = 1 : numel(Treatments)
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({barFilesL.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        h_bar_l(k) = openfig([curCellTypePath '\Bar\' Ab1{iii} Ab2{iii} '\' barFiles(ch1BarIdx(curFileIdx)).name]);
                    catch
                        h_bar_l(k) = figure('Visible','Off');
                    end
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({boxFilesL.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        h_box_l(k) = openfig([curCellTypePath '\Box\' Ab1{iii} Ab2{iii} '\' boxFiles(ch1BoxIdx(curFileIdx)).name]);
                    catch
                        h_box_l(k) = figure('Visible','Off');
                    end
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({barFilesR.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        h_bar_r(k) = openfig([curCellTypePath '\Bar\' Ab1{iii} Ab2{iii} '\' barFiles(ch2BarIdx(curFileIdx)).name]);
                    catch
                        h_bar_r(k) = figure('Visible','Off');
                    end
                    try
                        curFileIdx = find(~cellfun(@isempty,strfind({boxFilesR.name},[curCellType Treatments{k} Ab1{iii} Ab2{iii}])));
                        h_box_r(k) = openfig([curCellTypePath '\Box\' Ab1{iii} Ab2{iii} '\' boxFiles(ch2BoxIdx(curFileIdx)).name]);
                    catch
                        h_box_r(k) = figure('Visible','Off');
                    end
                end
                maxAxBarL = 0;
                maxAxBarR = 0;
                maxAxBoxL = 0;
                maxAxBoxR = 0;
                for k = 1 : numel(Treatments)
                    
                    try
                        curAxBarL = max(h_bar_l(k).CurrentAxes.YLim);
                    catch
                        curAxBarL = 0;
                    end
                    try
                        curAxBoxL = max(h_box_l(k).CurrentAxes.YLim);
                    catch
                        curAxBoxL = 0;
                    end
                    try 
                        curAxBarR = max(h_bar_r(k).CurrentAxes.YLim);
                    catch
                        curAxBarR = 0;
                    end
                    try
                        curAxBoxR = max(h_box_r(k).CurrentAxes.YLim);
                    catch
                        curAxBoxR = 0;
                    end
                    maxAxBarL = 1.1 * max([maxAxBarL curAxBarL]);
                    maxAxBarR = 1.1 * max([maxAxBarR curAxBarR]);
                    maxAxBoxL = 1.1 * max([maxAxBoxL curAxBoxL]);
                    maxAxBoxR = 1.1 * max([maxAxBoxR curAxBoxR]);
                end
                for k = 1 : numel(Treatments)
                    set(h_bar_l(k).CurrentAxes,'YLim',[0 maxAxBarL]);
                    toPPT(h_bar_l(k),'SlideNumber',PPTcounter)
                    set(h_box_l(k).CurrentAxes,'YLim',[0 maxAxBoxL]);
                    toPPT(h_box_l(k),'SlideNumber',PPTcounter)
                    set(h_bar_r(k).CurrentAxes,'YLim',[0 maxAxBarR]);
                    toPPT(h_bar_r(k),'SlideNumber',PPTcounter)
                    set(h_box_r(k).CurrentAxes,'YLim',[0 maxAxBoxR]);
                    toPPT(h_box_r(k),'SlideNumber',PPTcounter)
                end
                close all;                            
                
                PPTcounter = PPTcounter + 1;
            end
        end
                        
                    
    end
    warning('off','all');
end
            
            
            
                
                
            
        
        
        
        
        
        