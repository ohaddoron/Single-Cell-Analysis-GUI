function toPPT_Lee_2 (  folderPath , xlsPath, pptPath )

    [data,~,raw] = xlsread(xlsPath);
    
    boxPath = [folderPath '\Box'];
    barPath = [folderPath '\Bar'];
    binPath = [folderPath '\Bin'];
    rawPath = [folderPath '\Raw'];
    boxFiles = dir([boxPath '\*.fig']);
    barFiles = dir([barPath '\*.fig']);
    binFiles = dir([binPath '\*.tif']);
    rawFiles = dir([rawPath '\*.tif']);
    toPPT('openExisting',pptPath);
    for i = 1 : nanmax(data)
        curData = raw(data == i,1);
        curTitle = unique(raw(data == i, 3));
        toPPT('setTitle',curTitle,'SlideNumber',i);
        
        for ii = 1 : size(curData,1)
            %% raw
            chData = strrep(curData{ii,1}(1:3),' ','');
            treatData = strrep(curData{ii,1}(4:end),' ','');
            
            
            
            x = strfind({rawFiles.name},chData);
            chIndex = find(~cellfun(@isempty,x));

            x = strfind({rawFiles.name},treatData);
            treatIndex = find(~cellfun(@isempty,x));
            if ~isempty(treatIndex)
                for k = 1 : length(treatIndex)
                    if find(chIndex == treatIndex(k))
                        rawIndex = treatIndex(k);
                    end
                end
            else
                rawIndex = nan;
            end

            %% bin
            
            chData = strrep(curData{ii,1}(1:3),' ','');
            treatData = strrep(curData{ii,1}(4:end),' ','');

            x = strfind({binFiles.name},chData);
            chIndex = find(~cellfun(@isempty,x));

            x = strfind({binFiles.name},treatData);
            treatIndex = find(~cellfun(@isempty,x));

            
            if ~isempty(treatIndex)
                for k = 1 : length(treatIndex)
                    if find(chIndex == treatIndex(k))
                        binIndex = treatIndex(k);
                    end
                end
            else
                binIndex = nan;
            end
            
            %% bar
            chData = strrep(curData{ii,1}(1:3),' ','');
            treatData = strrep(curData{ii,1}(4:end),' ','');

            x = strfind({barFiles.name},chData);
            chIndex = find(~cellfun(@isempty,x));

            x = strfind({barFiles.name},treatData);
            treatIndex = find(~cellfun(@isempty,x));

            if ~isempty(treatIndex)
                for k = 1 : length(treatIndex)
                    if find(chIndex == treatIndex(k))
                        barIndex = treatIndex(k);
                    end
                end
            else
                barIndex = nan;
            end
            
            
            %% box
            chData = strrep(curData{ii,1}(1:3),' ','');
            treatData = strrep(curData{ii,1}(4:end),' ','');

            chIndex = nan(length(boxFiles));
            treatIndex = nan(length(boxFiles));

            x = strfind({boxFiles.name},chData);
            chIndex = find(~cellfun(@isempty,x));

            x = strfind({boxFiles.name},treatData);
            treatIndex = find(~cellfun(@isempty,x));

            if ~isempty(treatIndex)
                for k = 1 : length(treatIndex)
                    if find(chIndex == treatIndex(k))
                        boxIndex = treatIndex(k);
                    end
                end
            else
                boxIndex = nan;
            end

            
            %%
            try 
                rawImage = imread([rawPath '\' rawFiles(rawIndex).name]);
                h_raw(ii) = figure('Visible','Off');
                colormap(gray);
                imagesc(rawImage);
                set(h_raw(ii).CurrentAxes,'visible','off');
            catch
                h_raw(ii) = figure('Visible','Off');
                colormap(gray);
                imagesc(ones(1000));
            end
            try 
                binImage = imread([binPath '\' binFiles(binIndex).name]);
                h_bin(ii) = figure('Visible','Off');
                colormap(hot);
                imagesc(binImage);
                set(h_bin(ii).CurrentAxes,'visible','off');
            catch
                h_bin(ii) = figure('Visible','Off');
                colormap(gray);
                imagesc(ones(1000));
            end
            try 
                h_bar(ii) = openfig([barPath '\' barFiles(barIndex).name]);
            catch
                h_bar(ii) = figure('Visible','Off');
            end
            try
                h_box(ii) = openfig([boxPath '\' boxFiles(boxIndex).name]);
            catch
                h_box(ii) = figure('Visible','Off');
            end
            
            
        end
        maxBox = 0;
        maxBar = 0;
        for ii = 1 : size(curData,1)
            maxBox = max([maxBox max(get(h_box(ii).CurrentAxes,'YLim'))]);
            maxBar = max([maxBar max(get(h_bar(ii).CurrentAxes,'YLim'))]);
        end
        for ii = 1 : size(curData,1)
            set(h_bar(ii).CurrentAxes,'YLim',[0 maxBar]);
            set(h_box(ii).CurrentAxes,'YLim',[0 maxBox]);
        end
        for ii = 1 : size(curData,1)
            toPPT(h_raw(ii),'SlideNumber',i);
            toPPT(h_bin(ii),'SlideNumber',i)
            toPPT(h_bar(ii),'SlideNumber',i)
            toPPT(h_box(ii),'SlideNumber',i)
        end
        close all;
    end
end
            
           
        
        

