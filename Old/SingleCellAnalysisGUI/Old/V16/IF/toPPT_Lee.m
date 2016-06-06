function toPPT_Lee ( folderPath , xlsPath, pptPath )

    [data,~,raw] = xlsread(xlsPath);
    counter = 1;
    boxPath = [folderPath '\Box'];
    barPath = [folderPath '\Bar'];
    binPath = [folderPath '\Bin'];
    rawPath = [folderPath '\Raw'];
    boxFiles = dir([boxPath '\*.fig']);
    barFiles = dir([barPath '\*.fig']);
    binFiles = dir([binPath '\*.tif']);
    rawFiles = dir([rawPath '\*.tif']);
    
    toPPT('openExisting',pptPath);
    for i = 1 : nanmax(data);
        curData = raw(data == i,1:4);
        switch mod(i,2)
            case 1
                for ii = 1 : size(curData,1)
                    for iii = 1 : size(curData,2)
                        switch mod(iii,2)
                            case 1
                                chData = strrep(curData{ii,iii}(1:3),' ','');
                                treatData = strrep(curData{ii,iii}(4:end),' ','');
                                
                                
                                
                                x = strfind({rawFiles.name},chData);
                                chIndex = find(~cellfun(@isempty,x));
                                
                                x = strfind({rawFiles.name},treatData);
                                treatIndex = find(~cellfun(@isempty,x));
                                
                                if ~isempty(treatIndex)
                                    for k = 1 : length(treatIndex)
                                        if find(chIndex == treatIndex(k))
                                            index = treatIndex(k);
                                        end
                                    end
                                else
                                    index = nan;
                                end
                                try 
                                    rawImage = imread([rawPath '\' rawFiles(index).name]);
                                    h = figure('Visible','Off');
                                    
                                    colormap(gray);
                                    imagesc(rawImage);
                                    set(h.CurrentAxes,'Visible','Off');
                                catch
                                    h = figure('Visible','Off');
                                    colormap(gray);
                                    imagesc(ones(1000));
                                end
                                counter = counter + 1;
                                toPPT(h,'SlideNumber',i);
                                close all;
                            case 0
                                chData = strrep(curData{ii,iii}(1:3),' ','');
                                treatData = strrep(curData{ii,iii}(4:end),' ','');
                                
                                
                                
                                x = strfind({binFiles.name},chData);
                                chIndex = find(~cellfun(@isempty,x));
                                
                                x = strfind({binFiles.name},treatData);
                                treatIndex = find(~cellfun(@isempty,x));
                                
                                if ~isempty(treatIndex)
                                    for k = 1 : length(treatIndex)
                                        if find(chIndex == treatIndex(k))
                                            index = treatIndex(k);
                                        end
                                    end
                                else 
                                    index = nan;
                                end
                                
                                
                                
                               try 
                                    binImage = imread([binPath '\' binFiles(index).name]);
                                    h = figure('Visible','Off');
                                    
                                    colormap(hot);
                                    imagesc(binImage);
                                    set(h.CurrentAxes,'Visible','Off');
                                catch
                                    h = figure('Visible','Off');
                                    colormap(gray);
                                    imagesc(ones(1000));
                               end
                                toPPT(h,'SlideNumber',i);
                                close all;
                        end
                    end
                end
            case 0
                for ii = 1 : size(curData,1)
                    for iii = 1 : size(curData,2)
                        chData = strrep(curData{ii,iii}(1:3),' ','');
                        treatData = strrep(curData{ii,iii}(4:end),' ','');

                        
                        x = strfind({barFiles.name},chData);
                        chIndex= find(~cellfun(@isempty,x));

                        x = strfind({barFiles.name},treatData);
                        treatIndex = find(~cellfun(@isempty,x));

                        
                        if ~isempty(treatIndex)
                            for k = 1 : length(treatIndex)
                                if find(chIndex == treatIndex(k))
                                    index = treatIndex(k);
                                end
                            end
                        else
                            index = nan;
                        end
                        switch mod(iii,2)
                            case 1
                                try
                                    h(ii,iii) = openfig([barPath '\' barFiles(index).name]);
                                catch
                                    h(ii,iii) = figure('Visible','Off');
                                end
                            case 0
                                try
                                    h(ii,iii) = openfig([boxPath '\' boxFiles(index).name]);
                                catch
                                    h(ii,iii) = figure('Visible','Off');
                                end
                            end
                        
                    end
                end
                for iii = 1 : size(h,2)
                    maxAx = 0;
                    for ii = 1 : size(h,1)
                        try
                            curAx = h(ii,iii).CurrentAxes.YLim;
                        catch
                            curAx = 0;
                        end
                        maxAx = max([maxAx curAx]);
                    end
                    for ii = 1 : size(h,1)
                        set(h(ii,iii).CurrentAxes,'YLim',[0 maxAx]);
                    end
                end
                for ii = 1 : size(h,1)
                    for iii = 1 : size(h,2)
                        toPPT(h(ii,iii),'SlideNumber',i);
                    end
                end
        end
    end
end
                                