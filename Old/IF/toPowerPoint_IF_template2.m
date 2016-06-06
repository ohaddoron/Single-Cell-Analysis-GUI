function toPowerPoint_IF_template2 (xlsLayoutPaths,rawPaths,binPaths,barPaths,boxPaths,outputLocations,pptPaths)
    
    warning('off','all');
    numOfExps = numel(xlsLayoutPaths);
    fh = @(x) all(isnan(x(:)));
    for i = 1 : numOfExps
        
        
            
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
        
        for ii = 1 : numel(Treatments)
            rawFiles = dir([rawPaths{i} '\*.tif']);
            binFiles = dir([binPaths{i} '\*.tif']);
            barFiles = dir([barPaths{i} '\*.fig']);
            boxFiles = dir([boxPaths{i} '\*.fig']);
           
            curTreatment = Treatments{ii};
            folderPath = [outputLocation '\' curTreatment];
            
            mkdir([folderPath '\Raw']);
            mkdir([folderPath '\Bin']);
            mkdir([folderPath '\Bar']);
            mkdir([folderPath '\Box']);
            
            
            % Moving the raw data from the original folder path to the used
            % folder path
            
            treatIdx = find(~cellfun(@isempty,strfind({rawFiles.name},curTreatment)));
            rmIdx = [];
            count = 1;
            for k = 1 : numel(treatIdx)
                flag = 0;
                for kk = 1 : numel(Ab1)
                    for kkk = 1 : numel(cellTypes)
                        if ~isempty(strfind(rawFiles(treatIdx(k)).name,[cellTypes{kkk} curTreatment Ab1{kk}]))
                            flag = 1;
                        end
                    end
                end
                if flag == 0
                    rmIdx(count) = k;
                    count = count + 1;
                end
            end
            
            if ~ isempty(rmIdx)
                treatIdx(rmIdx) = [];   
            end
                
            for iii = 1 : numel(treatIdx)
                file1 = [rawPaths{i} '\' rawFiles(treatIdx(iii)).name];
                file2 = [folderPath '\Raw\' rawFiles(treatIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                treatFiles = dir([folderPath '\Raw\*.tif']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb2)));
                
                mkdir([folderPath '\Raw\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Raw\' treatFiles(Ab1Idx(k)).name],[folderPath '\Raw\' curAb1 curAb2 '\' treatFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            
            
            
            
            % Moving the bin data from the original folder path to the used
            % folder path
            
            treatIdx = find(~cellfun(@isempty,strfind({binFiles.name},curTreatment)));
            
            count = 1;
            rmIdx = [];
            for k = 1 : numel(treatIdx)
                flag = 0;
                for kk = 1 : numel(Ab1)
                    for kkk = 1 : numel(cellTypes)
                        if ~isempty(strfind(binFiles(treatIdx(k)).name,[cellTypes{kkk} curTreatment Ab1{kk}]))
                            flag = 1;
                        end
                    end
                end
                if flag == 0
                    rmIdx(count) = k;
                    count = count + 1;
                end
            end
            
            if ~ isempty(rmIdx)
                treatIdx(rmIdx) = [];   
            end
            
            for iii = 1 : numel(treatIdx)
                file1 = [binPaths{i} '\' binFiles(treatIdx(iii)).name];
                file2 = [folderPath '\Bin\' binFiles(treatIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                treatFiles = dir([folderPath '\Bin\*.tif']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb2)));
                
                mkdir([folderPath '\Bin\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Bin\' treatFiles(Ab1Idx(k)).name],[folderPath '\Bin\' curAb1 curAb2 '\' treatFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            %curBinPath = [folderPath '\Bin\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name];
            
            
            % Moving the bar data from the original folder path to the used
            % folder path
            
            treatIdx = find(~cellfun(@isempty,strfind({barFiles.name},curTreatment)));
            
            count = 1;
            rmIdx = [];
            for k = 1 : numel(treatIdx)
                flag = 0;
                for kk = 1 : numel(Ab1)
                    for kkk = 1 : numel(cellTypes)
                        if ~isempty(strfind(barFiles(treatIdx(k)).name,[cellTypes{kkk} curTreatment Ab1{kk}]))
                            flag = 1;
                        end
                    end
                end
                if flag == 0
                    rmIdx(count) = k;
                    count = count + 1;
                end
            end
            
            if ~ isempty(rmIdx)
                treatIdx(rmIdx) = [];   
            end
            
            
            for iii = 1 : numel(treatIdx)
                file1 = [barPaths{i} '\' barFiles(treatIdx(iii)).name];
                file2 = [folderPath '\Bar\' barFiles(treatIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                treatFiles = dir([folderPath '\Bar\*.fig']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb2)));
                
                mkdir([folderPath '\Bar\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Bar\' treatFiles(Ab1Idx(k)).name],[folderPath '\Bar\' curAb1 curAb2 '\' treatFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            %curBarPath = [folderPath '\Bar\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name];
            
            
            % Moving the box data from the original folder path to the used
            % folder path
            
            treatIdx = find(~cellfun(@isempty,strfind({boxFiles.name},curTreatment)));
            
            count = 1;
            rmIdx = [];
            for k = 1 : numel(treatIdx)
                flag = 0;
                for kk = 1 : numel(Ab1)
                    for kkk = 1 : numel(cellTypes)
                        if ~isempty(strfind(boxFiles(treatIdx(k)).name,[cellTypes{kkk} curTreatment Ab1{kk}]))
                            flag = 1;
                        end
                    end
                end
                if flag == 0
                    rmIdx(count) = k;
                    count = count + 1;
                end
            end
            
            if ~ isempty(rmIdx)
                treatIdx(rmIdx) = [];   
            end
            
            for iii = 1 : numel(treatIdx)
                file1 = [boxPaths{i} '\' boxFiles(treatIdx(iii)).name];
                file2 = [folderPath '\Box\' boxFiles(treatIdx(iii)).name];
                copyfile(file1,file2);
            end
            for iii = 1 : numel(Ab1)
                treatFiles = dir([folderPath '\Box\*.fig']);
                
                curAb1 = Ab1{iii};
                curAb2 = Ab2{iii};
                
                Ab1Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb1)));
                Ab2Idx = find(~cellfun(@isempty,strfind({treatFiles.name},curAb2)));
                
                mkdir([folderPath '\Box\' curAb1 curAb2]);
                for k = 1 : numel(Ab1Idx)
                    if ismember(Ab1Idx(k),Ab2Idx)
                        movefile([folderPath '\Box\' treatFiles(Ab1Idx(k)).name],[folderPath '\Box\' curAb1 curAb2 '\' treatFiles(Ab1Idx(k)).name]);
                    end
                end
                
            end
            
            %curBoxPath = [folderPath '\Box\' curAb1 curAb2 '\' cellTypeFiles(Ab1Idx(k)).name];
                    
        end
        PPTcounter = 1;
        toPPT('openExisting',pptPaths{i});
        for ii = 1 : numel(Treatments)
            curTreatment = Treatments{ii};
            curTreatPath = [outputLocation '\' curTreatment];
            
            for iii = 1 : (numel(Ab1) + numel(Ab2))/2
                rawFiles = dir([curTreatPath '\Raw\' Ab1{iii} Ab2{iii} '\*.tif']);
                binFiles = dir([curTreatPath '\Bin\' Ab1{iii} Ab2{iii} '\*.tif']);
                barFiles = dir([curTreatPath '\Bar\' Ab1{iii} Ab2{iii} '\*.fig']);
                boxFiles = dir([curTreatPath '\Box\' Ab1{iii} Ab2{iii} '\*.fig']);
                ch1RawIdx = find(~cellfun(@isempty,strfind({rawFiles.name},Ab1Channel)));
                ch2RawIdx = find(~cellfun(@isempty,strfind({rawFiles.name},Ab2Channel)));
                ch1BinIdx = find(~cellfun(@isempty,strfind({binFiles.name},Ab1Channel)));
                ch2BinIdx = find(~cellfun(@isempty,strfind({binFiles.name},Ab2Channel)));
                ch1BarIdx = find(~cellfun(@isempty,strfind({barFiles.name},Ab1Channel)));
                ch2BarIdx = find(~cellfun(@isempty,strfind({barFiles.name},Ab2Channel)));
                ch1BoxIdx = find(~cellfun(@isempty,strfind({boxFiles.name},Ab1Channel)));
                ch2BoxIdx = find(~cellfun(@isempty,strfind({boxFiles.name},Ab2Channel)));
                
                
                rawFilesUp = rawFiles(ch1RawIdx);
                rawFilesDown = rawFiles(ch2RawIdx);
                binFilesUp = binFiles(ch1BinIdx);
                binFilesDown = binFiles(ch2BinIdx);
                barFilesUp = barFiles(ch1BarIdx);
                barFilesDown = barFiles(ch2BarIdx);
                boxFilesUp = boxFiles(ch1BoxIdx);
                boxFilesDown = boxFiles(ch2BoxIdx);
                
                for k = 1 : numel(cellTypes)
                    try
                        rawUpIdx(k) = find(~cellfun(@isempty,strfind({rawFilesUp.name},cellTypes{k})));
                    catch
                        rawUpIdx(k) = nan;
                    end
                    try
                        rawDownIdx(k) = find(~cellfun(@isempty,strfind({rawFilesDown.name},cellTypes{k}))); 
                    catch
                        rawDownIdx(k) = nan;
                    end
                    
                    try
                        binUpIdx(k) = find(~cellfun(@isempty,strfind({binFilesUp.name},cellTypes{k})));
                    catch
                        binUpIdx(k) = nan;
                    end
                    try
                        binDownIdx(k) = find(~cellfun(@isempty,strfind({binFilesDown.name},cellTypes{k})));
                    catch
                        binDownIdx(k) = nan;
                    end
                    
                    try
                        barUpIdx(k) = find(~cellfun(@isempty,strfind({barFilesUp.name},cellTypes{k})));
                    catch
                        barUpIdx(k) = nan;
                    end
                    try
                        barDownIdx(k) = find(~cellfun(@isempty,strfind({barFilesDown.name},cellTypes{k})));
                    catch
                        barDownIdx(k) = nan;
                    end
                    
                    try
                        boxUpIdx(k) = find(~cellfun(@isempty,strfind({boxFilesUp.name},cellTypes{k})));
                    catch
                        boxUpIdx(k) = nan;
                    end
                    try
                        boxDownIdx(k) = find(~cellfun(@isempty,strfind({boxFilesDown.name},cellTypes{k})));
                    catch
                        boxDownIdx(k) = nan;
                    end
                end
                
                for k = 1 : numel(cellTypes)
                    try
                        imRaw = imread([curTreatPath '\Raw\' Ab1{iii} Ab2{iii} '\' rawFilesUp(rawUpIdx(k)).name]);
                        h_raw_Up(k) = figure('Visible','Off');
                        colormap(gray);
                        imagesc(imRaw);
                        set(h_raw_Up(k).CurrentAxes,'Visible','Off');
                    catch
                        h_raw_Up(k) = figure('Visible','Off');
                    end
                    
                    try
                        imBin = imread([curTreatPath '\Bin\' Ab1{iii} Ab2{iii} '\' binFilesUp(binUpIdx(k)).name]);
                        h_bin_Up(k) = figure('Visible','Off');
                        colormap(hot);
                        imagesc(imBin);
                        set(h_bin_Up(k).CurrentAxes,'Visible','Off');
                    catch
                        h_bin_Up(k) = figure('Visible','Off');
                    end
                    
                    try
                        h_bar_Up(k) = openfig([curTreatPath '\Bar\' Ab1{iii} Ab2{iii} '\' barFilesUp(barUpIdx(k)).name]);
                    catch
                        h_bar_Up(k) = figure('Visible','Off');
                    end
                    
                    try 
                        h_box_Up(k) = openfig([curTreatPath '\Box\' Ab1{iii} Ab2{iii} '\' boxFilesUp(boxUpIdx(k)).name]);
                    catch
                        h_box_Up(k) = figure('Visible','Off');
                    end
                    
                    try
                        imRaw = imread([curTreatPath '\Raw\' Ab1{iii} Ab2{iii} '\' rawFilesDown(rawDownIdx(k)).name]);
                        h_raw_Down(k) = figure('Visible','Off');
                        colormap(gray);
                        imagesc(imRaw);
                        set(h_raw_Down(k).CurrentAxes,'Visible','Off');
                    catch
                        h_raw_Down(k) = figure('Visible','Off');
                    end
                    
                    try
                        imBin = imread([curTreatPath '\Bin\' Ab1{iii} Ab2{iii} '\' binFilesDown(binDownIdx(k)).name]);
                        h_bin_Down(k) = figure('Visible','Off');
                        colormap(hot);
                        imagesc(imBin);
                        set(h_bin_Down(k).CurrentAxes,'Visible','Off');
                    catch
                        h_bin_Down(k) = figure('Visible','Off');
                    end
                    
                    try
                        h_bar_Down(k) = openfig([curTreatPath '\Bar\' Ab1{iii} Ab2{iii} '\' barFilesDown(barDownIdx(k)).name]);
                    catch
                        h_bar_Down(k) = figure('Visible','Off');
                    end
                    try 
                        h_box_Down(k) = openfig([curTreatPath '\Box\' Ab1{iii} Ab2{iii} '\' boxFilesDown(boxDownIdx(k)).name]);
                    catch
                        h_box_Down(k) = figure('Visible','Off');
                    end
                end
                    
                maxAxBarUp = 0;
                maxAxBarDown = 0;
                maxAxBoxUp = 0;
                maxAxBoxDown = 0;
                for k = 1 : numel(cellTypes)

                    try
                        curAxBarL = max(h_bar_Up(k).CurrentAxes.YLim);
                    catch
                        curAxBarL = 0;
                    end
                    try
                        curAxBoxL = max(h_box_Up(k).CurrentAxes.YLim);
                    catch
                        curAxBoxL = 0;
                    end
                    try 
                        curAxBarR = max(h_bar_Down(k).CurrentAxes.YLim);
                    catch
                        curAxBarR = 0;
                    end
                    try
                        curAxBoxR = max(h_box_Down(k).CurrentAxes.YLim);
                    catch
                        curAxBoxR = 0;
                    end
                    maxAxBarUp = 1.1 * max([maxAxBarUp curAxBarL]);
                    maxAxBarDown = 1.1 * max([maxAxBarDown curAxBarR]);
                    maxAxBoxUp = 1.1 * max([maxAxBoxUp curAxBoxL]);
                    maxAxBoxDown = 1.1 * max([maxAxBoxDown curAxBoxR]);
                end

                toPPT('setTitle',curTreatment,'SlideNumber',PPTcounter);
                for k = 1 : numel(cellTypes)

                    toPPT(h_raw_Up(k),'SlideNumber',PPTcounter);
                    toPPT(h_bin_Up(k),'SlideNumber',PPTcounter);

                    set(h_bar_Up(k).CurrentAxes,'YLim',[0 maxAxBarUp]);
                    toPPT(h_bar_Up(k),'SlideNumber',PPTcounter);

                    set(h_box_Up(k).CurrentAxes,'YLim',[0 maxAxBoxUp]);
                    toPPT(h_box_Up(k),'SlideNumber',PPTcounter);

                end

                PPTcounter = PPTcounter + 1;
                toPPT('setTitle',curTreatment,'SlideNumber',PPTcounter);
                for k = 1 : numel(cellTypes)

                    toPPT(h_raw_Down(k),'SlideNumber',PPTcounter);
                    toPPT(h_bin_Down(k),'SlideNumber',PPTcounter);

                    set(h_bar_Down(k).CurrentAxes,'YLim',[0 maxAxBarUp]);
                    toPPT(h_bar_Down(k),'SlideNumber',PPTcounter);

                    set(h_box_Down(k).CurrentAxes,'YLim',[0 maxAxBoxUp]);
                    toPPT(h_box_Down(k),'SlideNumber',PPTcounter);

                end
                PPTcounter = PPTcounter + 1;
                close all;
        end








        end
    end

    warning('off','all');            
end
    

            
            
            
                
                
            
        
        
        
        
        
        