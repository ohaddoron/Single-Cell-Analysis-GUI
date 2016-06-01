function toPowerPoint(folderPath,EXPname,EXPSUBname,curExp,masterPath,scatterDecision,EXPData,verStr,intensityAnalysis)
    

    SlideNumber = 1;
    %intensityAnalysis = 0;
    SPpath = [folderPath '\SunPlot'];
    Mapspath = [folderPath '\Maps'];
    BarGraphpath = [folderPath '\Bar Graphs'];
    TimeDependentpath = [folderPath '\Time Dependent'];
    Layerspath = [folderPath '\Layers'];
    VelocityVxVyTimePath = [folderPath '\Velocity_X VsVelocity_Y Vs Time']; 
    ClusterPath = [folderPath '\Cluster Analysis'];
    %masterPath = '\\metlab22\F\ilants2126\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\Template 10V2.pptx';
    filesBG = dir(BarGraphpath);
    
    toPPT('openExisting',masterPath);
    savePath = folderPath;
    saveFilename = char(strrep(EXPname,'/','-'));
    toPPT('savePath',savePath,'saveFilename',saveFilename);
    
    
    %% Protocol
    title = sprintf([char(EXPname) '\n' char(EXPSUBname)]);
    EXPData = EXPData';
    EXPData(strcmp(EXPData(:,1),'NNN0'),:) = [];
    dateStr = date;
    
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    toPPT('setTable',{  {EXPData{1,:}} , {EXPData(2:end,:)}  },'SlideNumber',1,'Width%',100,'Height%',70,'TeX',0,'pos','N','posAnker','M');
    toPPT([dateStr ' ' verStr],'setBullets',0,'SlideNumber',SlideNumber)
    SlideNumber = SlideNumber + 1;
    if intensityAnalysis ~=0
        %% Flourecent Intensity Time Dependent
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh1path = [TimeDependentpath '\Average IntensityCenterCh1 over time.fig'];
        IntensityCenterCh2path = [TimeDependentpath '\Average IntensityCenterCh2 over time.fig'];
        IntensityMaxCh1path = [TimeDependentpath '\Average IntensityMaxCh1 over time.fig'];
        IntensityMaxCh2path = [TimeDependentpath '\Average IntensityMaxCh2 over time.fig'];
        IntensityMeanCh1path = [TimeDependentpath '\Average IntensityMeanCh1 over time.fig'];
        IntensityMeanCh2path = [TimeDependentpath '\Average IntensityMeanCh2 over time.fig'];
        IntensityMedianCh1path = [TimeDependentpath '\Average IntensityMedianCh1 over time.fig'];
        IntensityMedianCh2path = [TimeDependentpath '\Average IntensityMedianCh2 over time.fig'];
        IntensitySumCh1path = [TimeDependentpath '\Average IntensitySumCh1 over time.fig'];
        IntensitySumCh2path = [TimeDependentpath '\Average IntensitySumCh2 over time.fig'];
        
        
        h = openfig(IntensityCenterCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityCenterCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMaxCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMaxCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMeanCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMeanCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMedianCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMedianCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensitySumCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensitySumCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        close all
        SlideNumber = SlideNumber + 1;
        %% Flourecent Intensity Bar Graph
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityCenterCh1.fig'))
                l = k;
            end
        end
        IntensityCenterCh1BGpath = [BarGraphpath '\' filesBG(l).name]; 
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityCenterCh2.fig'))
                l = k;
            end
        end
        IntensityCenterCh2BGpath = [BarGraphpath '\' filesBG(l).name]; 
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityMaxCh1.fig'))
                l = k;
            end
        end
        IntensityMaxCh1BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityMaxCh2.fig'))
                l = k;
            end
        end
        IntensityMaxCh2BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityMeanCh1.fig'))
                l = k;
            end
        end
        IntensityMeanCh1BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityMeanCh2.fig'))
                l = k;
            end
        end
        IntensityMeanCh2BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityMedianCh1.fig'))
                l = k;
            end
        end
        IntensityMedianCh1BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensityMedianCh2.fig'))
                l = k;
            end
        end
        IntensityMedianCh2BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensitySumCh1.fig'))
                l = k;
            end
        end
        IntensitySumCh1BGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'IntensitySumCh2.fig'))
                l = k;
            end
        end
        IntensitySumCh2BGpath = [BarGraphpath '\' filesBG(l).name];
        
        
        h = openfig(IntensityCenterCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityCenterCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMaxCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMaxCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMeanCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);    
        h = openfig(IntensityMeanCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMedianCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensityMedianCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensitySumCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(IntensitySumCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Center Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh1path = [Mapspath '\IntensityCenterCh1'];
        IntensityCenterCh1files = dir([IntensityCenterCh1path '\*.fig']);
        for k = 1 : length(IntensityCenterCh1files)
            fileUp = IntensityCenterCh1files(intersect(find(~cellfun(@isempty,strfind({IntensityCenterCh1files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityCenterCh1files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityCenterCh1path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Center Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh2path = [Mapspath '\IntensityCenterCh2'];
        IntensityCenterCh2files = dir([IntensityCenterCh2path '\*.fig']);
        for k = 1 : length(IntensityCenterCh1files)
            fileUp = IntensityCenterCh2files(intersect(find(~cellfun(@isempty,strfind({IntensityCenterCh2files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityCenterCh2files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityCenterCh2path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Max Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMaxCh1path = [Mapspath '\IntensityMaxCh1'];
        IntensityMaxCh1files = dir([IntensityMaxCh1path '\*.fig']);
        for k = 1 : length(IntensityMaxCh1files)
            fileUp = IntensityMaxCh1files(intersect(find(~cellfun(@isempty,strfind({IntensityMaxCh1files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityMaxCh1files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityMaxCh1path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Max Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMaxCh2path = [Mapspath '\IntensityMaxCh2'];
        IntensityMaxCh2files = dir([IntensityMaxCh2path '\*.fig']);
        for k = 1 : length(IntensityMaxCh2files)
            fileUp = IntensityMaxCh2files(intersect(find(~cellfun(@isempty,strfind({IntensityMaxCh2files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityMaxCh2files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityMaxCh2path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        SlideNumber = SlideNumber + 1;
        close all;
        %% Intensity Mean Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMeanCh1path = [Mapspath '\IntensityMeanCh1'];
        IntensityMeanCh1files = dir([IntensityMeanCh1path '\*.fig']);
        for k = 1 : length(IntensityMeanCh1files)
            fileUp = IntensityMeanCh1files(intersect(find(~cellfun(@isempty,strfind({IntensityMeanCh1files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityMeanCh1files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityMeanCh1path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Mean Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMeanCh2path = [Mapspath '\IntensityMeanCh2'];
        IntensityMeanCh2files = dir([IntensityMeanCh2path '\*.fig']);
        for k = 1 : length(IntensityMeanCh2files)
            fileUp = IntensityMeanCh2files(intersect(find(~cellfun(@isempty,strfind({IntensityMeanCh2files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityMeanCh2files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityMeanCh2path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Median Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMedianCh1path = [Mapspath '\IntensityMedianCh1'];
        IntensityMedianCh1files = dir([IntensityMedianCh1path '\*.fig']);
        for k = 1 : length(IntensityMedianCh1files)
            fileUp = IntensityMedianCh1files(intersect(find(~cellfun(@isempty,strfind({IntensityMedianCh1files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityMedianCh1files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityMedianCh1path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        SlideNumber = SlideNumber + 1;
        close all;
        %% Intensity Median Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMedianCh2path = [Mapspath '\IntensityMedianCh2'];
        IntensityMedianCh2files = dir([IntensityMedianCh2path '\*.fig']);
        for k = 1 : length(IntensityMedianCh2files)
            fileUp = IntensityMedianCh2files(intersect(find(~cellfun(@isempty,strfind({IntensityMedianCh2files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensityMedianCh2files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensityMedianCh2path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Sum Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensitySumCh1path = [Mapspath '\IntensitySumCh1'];
        IntensitySumCh1files = dir([IntensitySumCh1path '\*.fig']);
        for k = 1 : length(IntensitySumCh1files)
            fileUp = IntensitySumCh1files(intersect(find(~cellfun(@isempty,strfind({IntensitySumCh1files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensitySumCh1files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensitySumCh1path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Intensity Sum Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensitySumCh2path = [Mapspath '\IntensitySumCh2'];
        IntensitySumCh2files = dir([IntensitySumCh2path '\*.fig']);
        for k = 1 : length(IntensitySumCh2files)
            fileUp = IntensitySumCh2files(intersect(find(~cellfun(@isempty,strfind({IntensitySumCh2files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({IntensitySumCh2files.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([IntensitySumCh2path '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
       
    end
                %% Sun Plot

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        SPfiles = dir([SPpath '\*.fig']);
        for k = 1 : length(SPfiles)
            fileUp = SPfiles(intersect(find(~cellfun(@isempty,strfind({SPfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({SPfiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            else 
                list{k} = nan;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([SPpath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end
            toPPT(hup,'SlideNumber',SlideNumber);
        end
        close all
        clear h;
        SlideNumber = SlideNumber + 1;
        %% Velocity maps V(x,y)

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VelocityMapsXYpath = [Mapspath '\Velocity'];
        VelocityMapsXYfiles = dir([VelocityMapsXYpath '\*.fig']);
        for k = 1 : length(VelocityMapsXYfiles)
            fileUp = VelocityMapsXYfiles(intersect(find(~cellfun(@isempty,strfind({VelocityMapsXYfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({VelocityMapsXYfiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([VelocityMapsXYpath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% Velocity maps V(x)

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VelocityMapsXpath = [Mapspath '\Velocity_X'];
        VelocityMapsXfiles = dir([VelocityMapsXpath '\*.fig']);
        for k = 1 : length(VelocityMapsXfiles)


            fileUp = VelocityMapsXfiles(intersect(find(~cellfun(@isempty,strfind({VelocityMapsXfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({VelocityMapsXfiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            else
                list{k} = nan;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([VelocityMapsXpath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all
        SlideNumber = SlideNumber + 1;
        %% Velocity maps V(y)

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VelocityMapsYpath = [Mapspath '\Velocity_Y'];
        VelocityMapsYfiles = dir([VelocityMapsYpath '\*.fig']);
        for k = 1 : length(VelocityMapsYfiles)

            fileUp = VelocityMapsYfiles(intersect(find(~cellfun(@isempty,strfind({VelocityMapsYfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({VelocityMapsYfiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;    
            else
                list{k} = nan;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([VelocityMapsYpath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end
            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        clear h;
        SlideNumber = SlideNumber + 1;
        %% Coordinated Motility

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        CollMapspath = [Mapspath '\Coll'];
        CollMapsfiles = dir([CollMapspath '\*.fig']);
        for k = 1 : length(CollMapsfiles)

            fileUp = CollMapsfiles(intersect(find(~cellfun(@isempty,strfind({CollMapsfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({CollMapsfiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            else
                list{k} = nan;
            end
        end

        for k = 1 : length(list)
            try
                hup = openfig([CollMapspath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end

            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        clear h;
        SlideNumber = SlideNumber + 1;
        %% Velocity HGF
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VelocityTDpath = [TimeDependentpath '\Average Velocity over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Velocity.fig'))
                l = k;
            end
        end
        VelocityBGpath = [BarGraphpath '\' filesBG(l).name]; 
        h = openfig(VelocityTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(VelocityBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        close all
        %h = openfig(VelocityBGpath);
        %toPPT(h,'SlideNumber',6);
        SlideNumber = SlideNumber + 1;
        %% Vx/Vy bar graphs
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Velocity_X.fig'))
                l = k;
            end
        end
        VelocityXBGpath = [BarGraphpath '\' filesBG(l).name]; 
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Velocity_Y.fig'))
                l = k;
            end
        end
        VelocityYBGpath = [BarGraphpath '\' filesBG(l).name]; 
        h = openfig(VelocityXBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(VelocityYBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        %% XY absolute
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        XYabsolutepath = [VelocityVxVyTimePath '\Abs'];
        XYabsolutefiles = dir([XYabsolutepath '\*.fig']);
        for k = 1 : length(XYabsolutefiles)
            fileUp = XYabsolutefiles(intersect(find(~cellfun(@isempty,strfind({XYabsolutefiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({XYabsolutefiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            else
                list{k} = nan;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([XYabsolutepath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end
            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% XY
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        XYpath = [VelocityVxVyTimePath '\Sun'];
        XYfiles = dir([XYabsolutepath '\*.fig']);
        for k = 1 : length(XYfiles)
            fileUp = XYfiles(intersect(find(~cellfun(@isempty,strfind({XYfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({XYfiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            else
                list{k} = nan;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([XYpath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end
            toPPT(hup,'SlideNumber',SlideNumber);


        end
        close all;
        SlideNumber = SlideNumber + 1;
        %% XY average
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        XYAveragepath = [VelocityVxVyTimePath '\Time'];
        XYAveragefiles = dir([XYabsolutepath '\*.fig']);
        for k = 1 : length(XYAveragefiles)
            fileUp = XYAveragefiles(intersect(find(~cellfun(@isempty,strfind({XYAveragefiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({XYAveragefiles.name},curExp{k}(1:5))))));
            if ~isempty(fileUp)
                list{k} = fileUp.name;
            else
                list{k} = nan;
            end

        end

        for k = 1 : length(list)
            try
                hup = openfig([XYAveragepath '\' list{k}]);
            catch
                hup = figure('Visible','Off');
                h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                set(hup.CurrentAxes,'visible','off');
            end
            toPPT(hup,'SlideNumber',SlideNumber);


        end
        SlideNumber = SlideNumber + 1;
        %% XY Average for treatement
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        XYAverageForTreatementPath = [VelocityVxVyTimePath '\Avg'];
        XYAverageForTreatementfiles = dir([XYAverageForTreatementPath '\*.fig']);
        h = openfig([XYAverageForTreatementPath '\' XYAverageForTreatementfiles(1).name]);
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        %% Displacement2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        TrackDisplacementTDpath = [TimeDependentpath '\Average Displacement2 over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Displacement2.fig'))
                l = k;
            end
        end
        TrackDisplacementBGpath = [BarGraphpath '\' filesBG(l).name]; 
        h = openfig(TrackDisplacementTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(TrackDisplacementBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        close all;
        SlideNumber = SlideNumber + 1;
        %% MSD
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        MSDTDpath = [TimeDependentpath '\Average MSD over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'MSD.fig'))
                l = k;
            end
        end
        MSDBGpath = [BarGraphpath '\' filesBG(l).name]; 
        h = openfig(MSDTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(MSDBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        close all
        SlideNumber = SlideNumber + 1;
        %% Directional Change
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        DirectionalChangepath = [TimeDependentpath '\Average Directional_Change over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Directional_Change.fig'))
                l = k;
            end
        end
        Directional_ChangeBGpath = [BarGraphpath '\' filesBG(l).name];
        h = openfig(DirectionalChangepath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Directional_ChangeBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        close all
        
        SlideNumber = SlideNumber + 1;
        %% Area
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        AreaTDpath = [TimeDependentpath '\Average Area over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Area.fig'))
                l = k;
            end
        end
        AreaBGpath = [BarGraphpath '\' filesBG(l).name]; 
        h = openfig(AreaTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(AreaBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        close all;
        SlideNumber = SlideNumber + 1;
        %% Ellipsoid oblate & prolate
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        EllipsoidOblateTDpath = [TimeDependentpath '\Average Ellipticity_oblate over time.fig'];
        EllipsoidProlateTDpath = [TimeDependentpath '\Average Ellipticity_prolate over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Ellipticity_oblate.fig'))
                l = k;
            end
        end
        Ellipticity_oblateBGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Ellipticity_prolate.fig'))
                l = k;
            end
        end
        Ellipticity_prolateBGpath = [BarGraphpath '\' filesBG(l).name];
        
        
        h = openfig(EllipsoidOblateTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(EllipsoidProlateTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        h = openfig(Ellipticity_oblateBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Ellipticity_prolateBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        close all;
        SlideNumber = SlideNumber + 1;
        %% Eccenetricity
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        EccentricityTDpath = [TimeDependentpath '\Average Eccentricity over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Eccentricity.fig'))
                l = k;
            end
        end
        EccentricityBGpath = [BarGraphpath '\' filesBG(l).name];
        h = openfig(EccentricityTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(EccentricityBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        %% Sphericity
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        SphericityTDpath = [TimeDependentpath '\Average Sphericity over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Sphericity.fig'))
                l = k;
            end
        end
        SphericityBGpath = [BarGraphpath '\' filesBG(l).name];
        
        h = openfig(SphericityTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(SphericityBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        %% Elipsoid Axis A/B/C
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        EllipsoidAxisLengthBTDpath = [TimeDependentpath '\Average EllipsoidAxisLengthB over time.fig'];
        EllipsoidAxisLengthCTDpath = [TimeDependentpath '\Average EllipsoidAxisLengthC over time.fig'];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'EllipsoidAxisLengthB.fig'))
                l = k;
            end
        end
        EllipsoidAxisLengthBBGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'EllipsoidAxisLengthC.fig'))
                l = k;
            end
        end
        EllipsoidAxisLengthCBBGpath = [BarGraphpath '\' filesBG(l).name];
        
        h = openfig(EllipsoidAxisLengthBTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(EllipsoidAxisLengthCTDpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        h = openfig(EllipsoidAxisLengthBBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(EllipsoidAxisLengthCBBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        close all;
        SlideNumber = SlideNumber + 1;
        %% Bar Graphs
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Track_Displacement_Length.fig'))
                l = k;
            end
        end
        TrackLengthBGpath = [BarGraphpath '\' filesBG(l).name]; 
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Linearity_of_Forward_Progression.fig'))
                l = k;
            end
        end
        LinearityofForwardProgressionBGpath = [BarGraphpath '\' filesBG(l).name]; 
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Mean_Straight_Line_Speed.fig'))
                l = k;
            end
        end
        MeanStraightLineSpeedBGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,' Mean_Curvilinear_Speed.fig'))
                l = k;
            end
        end
        MeanCurvilinearSpeedBGpath = [BarGraphpath '\' filesBG(l).name];
        for k = 1 : length(filesBG)
            if ~isempty(strfind(filesBG(k).name,'Confinement_Ratio.fig'))
                l = k;
            end
        end
        ConfinementRatioBGpath = [BarGraphpath '\' filesBG(l).name];
        h = openfig(TrackLengthBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(LinearityofForwardProgressionBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(MeanStraightLineSpeedBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(MeanCurvilinearSpeedBGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(ConfinementRatioBGpath);
        toPPT(h,'SlideNumber',SlideNumber); 
        SlideNumber = SlideNumber + 1;
        %% Layers
        if scatterDecision == 0
            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            Layersfiles = dir([Layerspath '\Velocity\*.fig']);
            for k = 1 : length(Layersfiles)

                fileUp = Layersfiles(intersect(find(~cellfun(@isempty,strfind({Layersfiles.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({Layersfiles.name},curExp{k}(1:5))))));
                if ~isempty(fileUp)
                    list{k} = fileUp.name;
                else
                    list{k} = nan;
                end

            end

            for k = 1 : length(list)
                try
                    hup = openfig([Layerspath '\Velocity\' list{k}]);
                catch
                    hup = figure('Visible','Off');
                    h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
                    set(hup.CurrentAxes,'visible','off');
                end

                toPPT(hup,'SlideNumber',SlideNumber);


            end
            close all
            clear h;
        end
        SlideNumber = SlideNumber + 1;
        %% Cluster Analysis
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        h = openfig([ClusterPath '\Clustergram.fig']);
        set(h,'position',get(0,'screensize'))
        toPPT(h,'SlideNumber',SlideNumber);
        
        %% save
        savePath = folderPath;
        saveFilename = char(strrep(EXPname,'/','-'));
        toPPT('savePath',savePath,'saveFilename',saveFilename);
        toPPT('close',1);
        close all;
    end

    

    
