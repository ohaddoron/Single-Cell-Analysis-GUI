function toPowerPoint(folderPath,EXPname,EXPSUBname,curExp,masterPath,scatterDecision,EXPData,verStr,intensityAnalysis,ND)

  
    Report = cell(1,6);
    Report{1} = 'File name';
    Report{2} = 'File Path';
    Report{3} = 'Presentation path';
    Report{4} = 'Slide Number';
    Report{5} = 'Experiment title';
    Report{6} = 'Figure title';
    
    

    warning('off','all');
    curExp(strcmp(curExp,'NNN0')) = [];

    
    SlideNumber = 1;
    Path = [folderPath '\Bar Graphs'];
    Mapspath = [folderPath '\Maps'];
    BarGraphpath = [folderPath '\Bar Graphs'];
    TimeDependentpath = [folderPath '\Time Dependent'];
    Layerspath = [folderPath '\Layers'];
    VelocityVxVyTimePath = [folderPath '\Velocity_X VsVelocity_Y Vs Time']; 
    VelocityVxVyTimeLayersPath = [folderPath '\Velocity_X VsVelocity_Y Vs Time Layers'];
    ClusterPath = [folderPath '\Cluster Analysis'];
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
    
    
    
    %% Intensity Analysis
    if intensityAnalysis ~= 0
        %% Flourecent Intensity Time Dependent
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh1path = [folderPath '\Time Dependent\Average IntensityCenterCh1 over time.fig'];
        IntensityCenterCh2path = [folderPath '\Time Dependent\Average IntensityCenterCh2 over time.fig'];
        IntensityMaxCh1path = [folderPath '\Time Dependent\Average IntensityMaxCh1 over time.fig'];
        IntensityMaxCh2path = [folderPath '\Time Dependent\Average IntensityMaxCh2 over time.fig'];
        IntensityMeanCh1path = [folderPath '\Time Dependent\Average IntensityMeanCh1 over time.fig'];
        IntensityMeanCh2path = [folderPath '\Time Dependent\Average IntensityMeanCh2 over time.fig'];
        IntensityMedianCh1path = [folderPath '\Time Dependent\Average IntensityMedianCh1 over time.fig'];
        IntensityMedianCh2path = [folderPath '\Time Dependent\Average IntensityMedianCh2 over time.fig'];
        IntensitySumCh1path = [folderPath '\Time Dependent\Average IntensitySumCh1 over time.fig'];
        IntensitySumCh2path = [folderPath '\Time Dependent\Average IntensitySumCh2 over time.fig'];
        h = openfig(IntensityCenterCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityCenterCh1path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMaxCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMaxCh1path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMeanCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMeanCh1path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMedianCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMedianCh1path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        
        h = openfig(IntensitySumCh1path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensitySumCh1path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityCenterCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityCenterCh2path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMaxCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMaxCh2path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMeanCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMeanCh2path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMedianCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMedianCh2path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensitySumCh2path);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensitySumCh2path);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        close all
        SlideNumber = SlideNumber + 1;
        
        %% Flourecent Intensity Bar Graph
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh1BGpath = toPowerPointBG (Path,'IntensityCenterCh1');
        IntensityCenterCh2BGpath = toPowerPointBG (Path,'IntensityCenterCh2');
        IntensityMaxCh1BGpath = toPowerPointBG (Path,'IntensityMaxCh1');
        IntensityMaxCh2BGpath = toPowerPointBG (Path,'IntensityMaxCh2');
        IntensityMeanCh1BGpath = toPowerPointBG (Path,'IntensityMeanCh1');
        IntensityMeanCh2BGpath = toPowerPointBG (Path,'IntensityMeanCh2');
        IntensityMedianCh1BGpath = toPowerPointBG (Path,'IntensityMedianCh1');
        IntensityMedianCh2BGpath = toPowerPointBG (Path,'IntensityMedianCh2');
        IntensitySumCh1BGpath = toPowerPointBG (Path,'IntensitySumCh1');
        IntensitySumCh2BGpath = toPowerPointBG (Path,'IntensitySumCh2');
        
        h = openfig(IntensityCenterCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityCenterCh1BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMaxCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMaxCh1BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMeanCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMeanCh1BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMedianCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMedianCh1BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensitySumCh1BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensitySumCh1BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];        
        
        
        h = openfig(IntensityCenterCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityCenterCh2BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMaxCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMaxCh2BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
            
        h = openfig(IntensityMeanCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMeanCh2BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensityMedianCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensityMedianCh2BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        h = openfig(IntensitySumCh2BGpath);
        toPPT(h,'SlideNumber',SlideNumber);
        
        [pathstr,name] = fileparts(IntensitySumCh2BGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        
        close all;
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Center Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh1path = [folderPath '\Maps\IntensityCenterCh1'];
        curReport = toPowerPointMaps(IntensityCenterCh1path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Center Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityCenterCh2path = [folderPath '\Maps\IntensityCenterCh2'];
        curReport = toPowerPointMaps(IntensityCenterCh2path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Max Channel 1
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMaxCh1path = [folderPath '\Maps\IntensityMaxCh1'];
        curReport = toPowerPointMaps(IntensityMaxCh1path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Max Channel 2
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMaxCh2path = [folderPath '\Maps\IntensityMaxCh2'];
        curReport = toPowerPointMaps(IntensityMaxCh2path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Mean Channel 1
        
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMeanCh1path = [folderPath '\Maps\IntensityMeanCh1'];
        curReport = toPowerPointMaps(IntensityMeanCh1path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Mean Channel 2
        
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMeanCh2path = [folderPath '\Maps\IntensityMeanCh2'];
        curReport = toPowerPointMaps(IntensityMeanCh2path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Median Channel 1
        
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMedianCh1path = [folderPath '\Maps\IntensityMedianCh1'];
        curReport = toPowerPointMaps(IntensityMedianCh1path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Median Channel 2
        
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensityMedianCh2path = [folderPath '\Maps\IntensityMedianCh2'];
        curReport = toPowerPointMaps(IntensityMedianCh2path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
         %% Intensity Sum Channel 1
        
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensitySumCh1path = [folderPath '\Maps\IntensitySumCh1'];
        curReport = toPowerPointMaps(IntensitySumCh1path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        
        %% Intensity Sum Channel 2
        
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        IntensitySumCh2path = [folderPath '\Maps\IntensitySumCh2'];
        curReport = toPowerPointMaps(IntensitySumCh2path,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    end
    %% Sun Plot XY
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    SPXYpath = [folderPath '\SunPlot'];
    curReport = toPowerPointMaps (SPXYpath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    
    %%
    if ND == 3
        %% Sun Plot XZ
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        SPXZpath = [folderPath '\SunPlotXZ'];
        curReport = toPowerPointMaps (SPXZpath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
        %% Sun Plot YZ
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        SPYZpath = [folderPath '\SunPlotYZ'];
        curReport = toPowerPointMaps (SPYZpath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    end
    close all;
    %% Velocity maps
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Vpath = [folderPath '\Maps\Velocity'];
    curReport = toPowerPointMaps (Vpath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    %% Velocity maps X
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Vxpath = [folderPath '\Maps\Velocity_X'];
    curReport = toPowerPointMaps (Vxpath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    %% Velocity maps y
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Vypath = [folderPath '\Maps\Velocity_Y'];
    curReport = toPowerPointMaps (Vypath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    %% Velocity maps z
    if ND == 3
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        Vzpath = [folderPath '\Maps\Velocity_Z'];
        curReport = toPowerPointMaps (Vzpath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    end
    close all;
    %% Velocity TD + BG
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    VTDpath = [folderPath '\Time Dependent\Average Velocity over time.fig'];
    VBGpath = toPowerPointBG (Path,'Velocity');
    h = openfig(VTDpath);
    [pathstr,name] = fileparts(VTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(VBGpath);
    [pathstr,name] = fileparts(VBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    close all;
    %% Velocity Vx Vy Vz TD + BG
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    VxTDpath = [folderPath '\Time Dependent\Average Velocity_X over time.fig'];
    VyTDpath = [folderPath '\Time Dependent\Average Velocity_Y over time.fig'];
    VzTDpath = [folderPath '\Time Dependent\Average Velocity_Z over time.fig'];
    
    VxBGpath = toPowerPointBG (Path,'Velocity_X');
    VyBGpath = toPowerPointBG (Path,'Velocity_Y');
    if ND == 3
        VzBGpath = toPowerPointBG (Path,'Velocity_Z');
    end
    
    h = openfig(VxTDpath);
    [pathstr,name] = fileparts(VxTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(VyTDpath);
    [pathstr,name] = fileparts(VyTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    if ND == 3
        
        h = openfig(VzTDpath);
        [pathstr,name] = fileparts(VzTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    
    h = openfig(VxBGpath);
    [pathstr,name] = fileparts(VxBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(VyBGpath);
    [pathstr,name] = fileparts(VyBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    if ND == 3
        h = openfig(VzBGpath);
        [pathstr,name] = fileparts(VzBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
        
    end
    SlideNumber = SlideNumber + 1;
    close all;
   
    %% Velocity Vx Vy absolute
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    VxyabsPath = [folderPath '\Velocity_X VsVelocity_Y Vs Time\Abs'];
    curReport = toPowerPointMaps (VxyabsPath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    
    if ND == 3
        %% Velocity Vx Vz absolute

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VxzabsPath = [folderPath '\Velocity_X VsVelocity_Z Vs Time\Abs'];
        curReport = toPowerPointMaps (VxzabsPath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;

        %% Velocity Vy Vz absolute

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VyzabsPath = [folderPath '\Velocity_Y VsVelocity_Z Vs Time\Abs'];
        curReport = toPowerPointMaps (VyzabsPath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    
    end
    close all;
    %% Velocity Vx Vy Sun
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    VxysunPath = [folderPath '\Velocity_X VsVelocity_Y Vs Time\Sun'];
    curReport = toPowerPointMaps (VxysunPath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    if ND == 3
        %% Velocity Vx Vz Sun

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VxzsunPath = [folderPath '\Velocity_X VsVelocity_Z Vs Time\Sun'];
        curReport = toPowerPointMaps (VxzsunPath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;

        %% Velocity Vy Vz Sun

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VyzsunPath = [folderPath '\Velocity_X VsVelocity_Y Vs Time\Sun'];
        curReport = toPowerPointMaps (VyzsunPath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    end
    close all;
    %% Velocity Vx Vy Average
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    VxytimePath = [folderPath '\Velocity_X VsVelocity_Y Vs Time\Time'];
    curReport = toPowerPointMaps (VxytimePath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    if ND == 3
        %% Velocity Vx Vz Average

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VxztimePath = [folderPath '\Velocity_X VsVelocity_Z Vs Time\Time'];
        curReport = toPowerPointMaps (VxztimePath,curExp,SlideNumber); 
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;

         %% Velocity Vy Vz Average

        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VyztimePath = [folderPath '\Velocity_Y VsVelocity_Z Vs Time\Time'];
        curPoint = toPowerPointMaps (VyztimePath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    end
    close all;
    %% Velocity Vx Vy Vz Average for treatment
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    VxyavgtreatPath = [folderPath '\Velocity_X VsVelocity_Y Vs Time\Avg'];
    
    if ND == 3
        VxzavgtreatPath = [folderPath '\Velocity_X VsVelocity_Z Vs Time\Avg'];
        VyzavgtreatPath = [folderPath '\Velocity_Y VsVelocity_Z Vs Time\Avg'];
    end
    
    file = dir([VxyavgtreatPath '\*.fig']);
    h = openfig([VxyavgtreatPath '\' file.name]);
    [pathstr,name] = fileparts([VxyavgtreatPath '\' file.name]);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    
    
    if ND == 3
        file = dir([VxzavgtreatPath '\*.fig']);
        h = openfig([VxzavgtreatPath '\' file.name]);
        [pathstr,name] = fileparts([VxzavgtreatPath '\' file.name]);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        file = dir([VyzavgtreatPath '\*.fig']);
        h = openfig([VyzavgtreatPath '\' file.name]);
        [pathstr,name] = fileparts([VyzavgtreatPath '\' file.name]);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Acceleration Map
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Apath = [folderPath '\Maps\Acceleration'];
    curReport = toPowerPointMaps (Apath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Acceleration_X Map
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Axpath = [folderPath '\Maps\Acceleration_X'];
    curReport = toPowerPointMaps (Axpath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    %% Acceleration_Y Map
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Aypath = [folderPath '\Maps\Acceleration_Y'];
    curReport = toPowerPointMaps (Aypath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    %% Acceleration_Z Map
    if ND == 3
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        Azpath = [folderPath '\Maps\Acceleration_Z'];
        curReport = toPowerPointMaps (Azpath,curExp,SlideNumber);
        curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
        Report = [Report; curReport];
        SlideNumber = SlideNumber + 1;
    end
    close all;
    %% Acceleration TD + BG
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    ATDpath = [folderPath '\Time Dependent\Average Acceleration over time.fig'];
    Path = [folderPath '\Bar Graphs'];
    ABGpath = toPowerPointBG (Path,'Acceleration');
    
    h = openfig(ATDpath);
    [pathstr,name] = fileparts(ATDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(ABGpath);
    [pathstr,name] = fileparts(ABGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    close all;
    %% Acceleration Ax Ay Az TD + BG
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    AxTDpath = [folderPath '\Time Dependent\Average Acceleration_X over time.fig'];
    AyTDpath = [folderPath '\Time Dependent\Average Acceleration_Y over time.fig'];
    AzTDpath = [folderPath '\Time Dependent\Average Acceleration_Z over time.fig'];
    
    AxBGpath = toPowerPointBG (Path,'Acceleration_X');
    AyBGpath = toPowerPointBG (Path,'Acceleration_Y');
    AzBGpath = toPowerPointBG (Path,'Acceleration_Z');
    
    h = openfig(AxTDpath);
    [pathstr,name] = fileparts(AxTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(AyTDpath);
    [pathstr,name] = fileparts(AyTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    if ND == 3
        
        h = openfig(AzTDpath);
        [pathstr,name] = fileparts(AzTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    
    h = openfig(AxBGpath);
    [pathstr,name] = fileparts(AxBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(AyBGpath);
    [pathstr,name] = fileparts(AyBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    if ND == 3
        h = openfig(AzBGpath);
        [pathstr,name] = fileparts(AzBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];  
        toPPT(h,'SlideNumber',SlideNumber);
        
    end
    SlideNumber = SlideNumber + 1;
    close all;
    %% Coordinated motility maps
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Collpath = [folderPath '\Maps\Coll'];
    curReport = toPowerPointMaps (Collpath,curExp,SlideNumber);
    curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
    Report = [Report; curReport];
    SlideNumber = SlideNumber + 1;
    close all;
    %% Coordinated motility TD + BG
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    CollTDpath = [folderPath '\Time Dependent\Average Coll over time.fig'];
    Path = [folderPath '\Bar Graphs'];
    ABGpath = toPowerPointBG (Path,'Coll');
    
    h = openfig(CollTDpath);
    [pathstr,name] = fileparts(CollTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];  
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(ABGpath);
    [pathstr,name] = fileparts(ABGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];  
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Track Displacement
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    TrackDisplacementpath = toPowerPointBG (Path,'Track_Displacement_Length');
    h = openfig(TrackDisplacementpath);
    [pathstr,name] = fileparts(TrackDisplacementpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Track Displacement X,Y,Z
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    
    TrackDisplacementXpath = toPowerPointBG (Path,'Track_Displacement_X');
    h = openfig(TrackDisplacementXpath);
    [pathstr,name] = fileparts(TrackDisplacementXpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    TrackDisplacementYpath = toPowerPointBG (Path,'Track_Displacement_Y');
    h = openfig(TrackDisplacementYpath);
    [pathstr,name] = fileparts(TrackDisplacementYpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    
    if ND == 3
        TrackDisplacementZpath = toPowerPointBG (Path,'Track_Displacement_Z');
        h = openfig(TrackDisplacementZpath);
        [pathstr,name] = fileparts(TrackDisplacementZpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);
    end
    
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Track Displacement Squared
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    TrackDisplacementSquaredTDpath = [folderPath '\Time Dependent\Average Displacement2 over time.fig'];
    TrackDisplacementSquaredBGpath = toPowerPointBG (Path,'Displacement2');
    
    h = openfig(TrackDisplacementSquaredTDpath);
    [pathstr,name] = fileparts(TrackDisplacementSquaredTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(TrackDisplacementSquaredBGpath);
    [pathstr,name] = fileparts(TrackDisplacementSquaredBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% MSD 
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    MSDTDpath = [folderPath '\Time Dependent\Average MSD over time.fig'];
    MSDBGpath = toPowerPointBG (Path,'MSD');
    
    h = openfig(MSDTDpath);
    [pathstr,name] = fileparts(MSDTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(MSDBGpath);
    [pathstr,name] = fileparts(MSDBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Directional_Change
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    
    Directional_ChangeTDpath = [folderPath '\Time Dependent\Average Directional_Change over time.fig'];
    Directional_ChangeBGDpath = toPowerPointBG (Path,'Directional_Change');
    
    h = openfig(Directional_ChangeTDpath);
    [pathstr,name] = fileparts(Directional_ChangeTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Directional_ChangeBGDpath);
    [pathstr,name] = fileparts(Directional_ChangeBGDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    close all;
    
    if ND == 3
        %% Volume
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        VolumeTDpath = [folderPath '\Time Dependent\Average Volume over time.fig'];
        VolumeBGpath = toPowerPointBG (Path,'Volume');

        h = openfig(VolumeTDpath);
        [pathstr,name] = fileparts(VolumeTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(VolumeBGpath);
        [pathstr,name] = fileparts(VolumeBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        close all;
    else
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        AreaTDpath = [folderPath '\Time Dependent\Average Area over time.fig'];
        AreaBGpath = toPowerPointBG (Path,'Area');

        h = openfig(AreaTDpath);
        [pathstr,name] = fileparts(AreaTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(AreaBGpath);
        [pathstr,name] = fileparts(AreaBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        close all;
    end
    
    %% Ellip ob & pr
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Ellipticity_oblateTDpath = [folderPath '\Time Dependent\Average Ellipticity_oblate over time.fig'];
    Ellipticity_prolateTDpath = [folderPath '\Time Dependent\Average Ellipticity_prolate over time.fig'];
    Ellipticity_oblateBGpath = toPowerPointBG (Path,'Ellipticity_oblate');
    Ellipticity_prolateBGpath = toPowerPointBG (Path,'Ellipticity_prolate');
    
    h = openfig(Ellipticity_oblateTDpath);
    [pathstr,name] = fileparts(Ellipticity_oblateTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Ellipticity_prolateTDpath);
    [pathstr,name] = fileparts(Ellipticity_prolateTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Ellipticity_oblateBGpath);
    [pathstr,name] = fileparts(Ellipticity_oblateBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Ellipticity_prolateBGpath);
    [pathstr,name] = fileparts(Ellipticity_prolateBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    close all;
    %% Eccentricity
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    EccentricityTDpath = [folderPath '\Time Dependent\Average Eccentricity over time.fig'];
    EccentricityBGpath = toPowerPointBG (Path,'Eccentricity');
    
    h = openfig(EccentricityTDpath);
    [pathstr,name] = fileparts(EccentricityTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(EccentricityBGpath);
    [pathstr,name] = fileparts(EccentricityBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    
    %% Sphericity
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    SphericityTDpath = [folderPath '\Time Dependent\Average Sphericity over time.fig'];
    SphericityBGpath = toPowerPointBG (Path,'Sphericity');
    
    h = openfig(SphericityTDpath);
    [pathstr,name] = fileparts(SphericityTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(SphericityBGpath);
    [pathstr,name] = fileparts(SphericityBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    
    %% Ellip Axis A/B/C
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    EllipAxATDpath = [folderPath '\Time Dependent\Average EllipsoidAxisLengthA over time.fig'];
    EllipAxBTDpath = [folderPath '\Time Dependent\Average EllipsoidAxisLengthB over time.fig'];
    EllipAxCTDpath = [folderPath '\Time Dependent\Average EllipsoidAxisLengthC over time.fig'];
    
    EllipAxABGpath = toPowerPointBG (Path,'EllipsoidAxisLengthA');
    EllipAxBBGpath = toPowerPointBG (Path,'EllipsoidAxisLengthB');
    EllipAxCBGpath = toPowerPointBG (Path,'EllipsoidAxisLengthC');
    
    
    if ND == 3
        h = openfig(EllipAxATDpath);
        toPPT(h,'SlideNumber',SlideNumber);
    end
    h = openfig(EllipAxBTDpath);
    [pathstr,name] = fileparts(EllipAxBTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(EllipAxCTDpath);
    [pathstr,name] = fileparts(EllipAxCTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    if ND == 3
        h = openfig(EllipAxABGpath);
        [pathstr,name] = fileparts(EllipAxABGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);
    end
    h = openfig(EllipAxBBGpath);
    [pathstr,name] = fileparts(EllipAxBBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(EllipAxCBGpath);
    [pathstr,name] = fileparts(EllipAxCBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
    toPPT(h,'SlideNumber',SlideNumber);
    
    SlideNumber = SlideNumber + 1;
    close all;
    %% Ellip Axis A
    
    
    if ND == 3
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        Ellip_Ax_A_XTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_A_X over time.fig'];
        Ellip_Ax_A_YTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_A_Y over time.fig'];
        Ellip_Ax_A_ZTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_A_Z over time.fig'];

        Ellip_Ax_A_XBGpath = toPowerPointBG (Path,'Ellip_Ax_A_X');
        Ellip_Ax_A_YBGpath = toPowerPointBG (Path,'Ellip_Ax_A_Y');
        Ellip_Ax_A_ZBGpath = toPowerPointBG (Path,'Ellip_Ax_A_Z');

        h = openfig(Ellip_Ax_A_XTDpath);
        [pathstr,name] = fileparts(Ellip_Ax_A_XTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Ellip_Ax_A_YTDpath);
        [pathstr,name] = fileparts(Ellip_Ax_A_YTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}]; 
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Ellip_Ax_A_ZTDpath);
        [pathstr,name] = fileparts(Ellip_Ax_A_ZTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Ellip_Ax_A_XBGpath);
        [pathstr,name] = fileparts(Ellip_Ax_A_XBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Ellip_Ax_A_YBGpath);
        [pathstr,name] = fileparts(Ellip_Ax_A_YBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
        h = openfig(Ellip_Ax_A_ZBGpath);
        [pathstr,name] = fileparts(Ellip_Ax_A_ZBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        SlideNumber = SlideNumber + 1;
        close all;
    end
    %% Ellip Axis B
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Ellip_Ax_B_XTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_B_X over time.fig'];
    Ellip_Ax_B_YTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_B_Y over time.fig'];
    if ND == 3
        Ellip_Ax_B_ZTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_B_Z over time.fig'];
    end
    
    Ellip_Ax_B_XBGpath = toPowerPointBG (Path,'Ellip_Ax_B_X');
    Ellip_Ax_B_YBGpath = toPowerPointBG (Path,'Ellip_Ax_B_Y');
    if ND == 3
        Ellip_Ax_B_ZBGpath = toPowerPointBG (Path,'Ellip_Ax_B_Z');
    end
    
    h = openfig(Ellip_Ax_B_XTDpath);
    [pathstr,name] = fileparts(Ellip_Ax_B_XTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Ellip_Ax_B_YTDpath);
    [pathstr,name] = fileparts(Ellip_Ax_B_YTDpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    if ND == 3
        h = openfig(Ellip_Ax_B_ZTDpath);
        [pathstr,name] = fileparts(Ellip_Ax_B_ZTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    h = openfig(Ellip_Ax_B_XBGpath);
    [pathstr,name] = fileparts(Ellip_Ax_B_XBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(Ellip_Ax_B_YBGpath);
    [pathstr,name] = fileparts(Ellip_Ax_B_YBGpath);
    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    if ND == 3
        h = openfig(Ellip_Ax_B_ZBGpath);
        [pathstr,name] = fileparts(Ellip_Ax_B_ZBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    
    SlideNumber = SlideNumber + 1;
    close all;
    
    %% Ellip Axis C
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Ellip_Ax_C_XTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_C_X over time.fig'];
    Ellip_Ax_C_YTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_C_Y over time.fig'];
    if ND == 3
        Ellip_Ax_C_ZTDpath = [folderPath '\Time Dependent\Average Ellip_Ax_C_Z over time.fig'];
    end
    
    Ellip_Ax_C_XBGpath = toPowerPointBG (Path,'Ellip_Ax_C_X');
    Ellip_Ax_C_YBGpath = toPowerPointBG (Path,'Ellip_Ax_C_Y');
    if ND == 3
        Ellip_Ax_C_ZBGpath = toPowerPointBG (Path,'Ellip_Ax_C_Z');
    end
    
    h = openfig(Ellip_Ax_C_XTDpath);
    [pathstr,name] = fileparts(Ellip_Ax_C_XTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(Ellip_Ax_C_YTDpath);
    [pathstr,name] = fileparts(Ellip_Ax_C_YTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    if ND == 3
        h = openfig(Ellip_Ax_C_ZTDpath);
        [pathstr,name] = fileparts(Ellip_Ax_C_ZTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    h = openfig(Ellip_Ax_C_XBGpath);
    [pathstr,name] = fileparts(Ellip_Ax_C_XBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(Ellip_Ax_C_YBGpath);
    [pathstr,name] = fileparts(Ellip_Ax_C_YBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    if ND == 3
        h = openfig(Ellip_Ax_C_ZBGpath);
        [pathstr,name] = fileparts(Ellip_Ax_C_ZBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
    end
    SlideNumber = SlideNumber + 1;
    close all;
    
    %% Bar Graphs
    
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    TrackLengthBGPath = toPowerPointBG (Path,'Track_Displacement_Length');
    Linearity_of_Forward_ProgressionBGpath = toPowerPointBG (Path,'Linearity_of_Forward_Progression');
    Mean_Straight_Line_SpeedBGpath = toPowerPointBG (Path,'Mean_Straight_Line_Speed');
    Mean_Curvilinear_SpeedBGpath = toPowerPointBG (Path,'Mean_Curvilinear_Speed');
    Confinement_RatioBGpath = toPowerPointBG (Path,'Confinement_Ratio');
    
    h = openfig(TrackLengthBGPath);
    [pathstr,name] = fileparts(TrackLengthBGPath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Linearity_of_Forward_ProgressionBGpath);
    [pathstr,name] = fileparts(Linearity_of_Forward_ProgressionBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Mean_Straight_Line_SpeedBGpath);
    [pathstr,name] = fileparts(Mean_Straight_Line_SpeedBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Mean_Curvilinear_SpeedBGpath);
    [pathstr,name] = fileparts(Mean_Curvilinear_SpeedBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    
    h = openfig(Confinement_RatioBGpath);
    [pathstr,name] = fileparts(Confinement_RatioBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    
    try
        
        Starting_TimeBGPath = toPowerPointBG (Path,'Starting_Time');
        Starting_ValueBGpath = toPowerPointBG (Path,'Starting_Value');
        Ending_TimeBGpath = toPowerPointBG (Path,'Ending_Time');
        Ending_ValueBGpath = toPowerPointBG (Path,'Ending_Value');
        Maximum_HeightBGpath = toPowerPointBG (Path,'Maximum_Height');
        Time_of_Maximum_HeightBGpath = toPowerPointBG (Path,'Time_of_Maximum_Height');
        Full_Width_Half_MaximumBGpath = toPowerPointBG (Path,'Full_Width_Half_Maximum');
        
        h = openfig(Starting_TimeBGPath);
        [pathstr,name] = fileparts(Starting_TimeBGPath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(Starting_ValueBGpath);
        [pathstr,name] = fileparts(Starting_ValueBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(Ending_TimeBGpath);
        [pathstr,name] = fileparts(Ending_TimeBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(Ending_ValueBGpath);
        [pathstr,name] = fileparts(Ending_ValueBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(Maximum_HeightBGpath);
        [pathstr,name] = fileparts(Maximum_HeightBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
        
        h = openfig(Time_of_Maximum_HeightBGpath);
        [pathstr,name] = fileparts(Time_of_Maximum_HeightBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);

        h = openfig(Full_Width_Half_MaximumBGpath);
        [pathstr,name] = fileparts(Full_Width_Half_MaximumBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
        toPPT(h,'SlideNumber',SlideNumber);
        toPPT('setTitle',title,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        
    catch
    end
    
    %% Instantaneous_Speed
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Instantaneous_SpeedTDpath = [folderPath '\Time Dependent\Average Instantaneous_Speed over time.fig'];
    Instantaneous_SpeedBGpath = toPowerPointBG (Path,'Instantaneous_Speed');
    
    h = openfig(Instantaneous_SpeedTDpath);
    [pathstr,name] = fileparts(Instantaneous_SpeedTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(Instantaneous_SpeedBGpath);
    [pathstr,name] = fileparts(Instantaneous_SpeedBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    %% Instantaneous_Angle
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    Instantaneous_AngleTDpath = [folderPath '\Time Dependent\Average Instantaneous_Angle over time.fig'];
    Instantaneous_AngleBGpath = toPowerPointBG (Path,'Instantaneous_Angle');
    
    h = openfig(Instantaneous_AngleTDpath);
    [pathstr,name] = fileparts(Instantaneous_AngleTDpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    h = openfig(Instantaneous_AngleBGpath);
    [pathstr,name] = fileparts(Instantaneous_AngleBGpath);
        Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    %% Layers
    if scatterDecision == 0
        try

        
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
                    [pathstr,name] = fileparts([Layerspath '\Velocity\' list{k}]);
                    Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {hup.CurrentAxes.Title.String}];
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

            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            SunPath = [VelocityVxVyTimeLayersPath '\Sun'];
            curReport = toPowerPointMaps (SunPath,curExp,SlideNumber);
            curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
            Report = [Report; curReport];
            SlideNumber = SlideNumber + 1;
            close all;

            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            AbsPath = [VelocityVxVyTimeLayersPath '\Abs'];
            curReport = toPowerPointMaps (AbsPath,curExp,SlideNumber);
            curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
            Report = [Report; curReport];
            SlideNumber = SlideNumber + 1;
            close all;

            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            AvgPath = [VelocityVxVyTimeLayersPath '\Avg'];
            curReport = toPowerPointMaps (AvgPath,curExp,SlideNumber);
            curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
            Report = [Report; curReport];
            SlideNumber = SlideNumber + 1;
            close all;
        catch
            SlideNumber = SlideNumber + 1;
        end


    end
    
    
    par1vspar2FolderPath = [folderPath '\par1_vs_par2'];
    files = dir(par1vspar2FolderPath);
    files(1:2) = [];
    dirFlags = [files.isdir];
    par1subFolders = files(dirFlags);
    
    num_of_par1 = numel(par1subFolders);
    
    for k = 1 : num_of_par1
        curFolderPath = [par1vspar2FolderPath '\' par1subFolders(k).name];
        files = dir(curFolderPath);
        files(1:2) = [];
        dirFlags = [files.isdir];
        par2subFolders = files(dirFlags);
        num_of_par2 = numel(par2subFolders);
        for kk = 1 : num_of_par2
            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            Path = [curFolderPath '\' par2subFolders(kk).name '\Abs'];
            curReport = toPowerPointMaps (Path,curExp,SlideNumber);
            curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
            Report = [Report; curReport];
            SlideNumber = SlideNumber + 1;
            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            Path = [curFolderPath '\' par2subFolders(kk).name '\Sun'];
            curReport = toPowerPointMaps (Path,curExp,SlideNumber);
            curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
            Report = [Report; curReport];
            SlideNumber = SlideNumber + 1;
            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            Path = [curFolderPath '\' par2subFolders(kk).name '\Time'];
            curReport = toPowerPointMaps (Path,curExp,SlideNumber);
            curReport = [curReport(:,1:2) repmat({[savePath '\' saveFilename]},[1,size(curReport,1)])' curReport(:,3) repmat({title},[1,size(curReport,1)])' curReport(:,end)];
            Report = [Report; curReport];
            SlideNumber = SlideNumber + 1;
            toPPT('setTitle',title,'SlideNumber',SlideNumber);
            Path = [curFolderPath '\' par2subFolders(kk).name '\Avg'];
            file = dir([Path '\*.fig']);
            h = openfig([Path '\' file.name]);
            [pathstr,name] = fileparts([Path '\' file.name]);
                Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
            toPPT(h,'SlideNumber',SlideNumber);
            SlideNumber = SlideNumber + 1;
            close all
        end
    end
    
        
    
    %% Cluster Analysis
    toPPT('setTitle',title,'SlideNumber',SlideNumber);
    h = openfig([ClusterPath '\Clustergram.fig']);
    [pathstr,name] = fileparts([ClusterPath '\Clustergram.fig']);
                Report = [Report; {name} {pathstr} {[savePath '\' saveFilename]} {num2str(SlideNumber)} {title} {h.CurrentAxes.Title.String}];
    set(h,'position',get(0,'screensize'))
    toPPT(h,'SlideNumber',SlideNumber);
    
    
    
    %% save
    xlswrite([savePath '\Report.xlsx'],Report);
    savePath = folderPath;
    saveFilename = char(strrep(EXPname,'/','-'));
    toPPT('savePath',savePath,'saveFilename',saveFilename);
    toPPT('close',1);
    close all;
        
        

end

    
function curReport = toPowerPointMaps (Path,curExp,SlideNumber)

    curReport = cell(1,4);
    files = dir([Path '\*.fig']);
    
    for k = 1 : numel(curExp)
        curFile = files(intersect(find(~cellfun(@isempty,strfind({files.name},curExp{k}(6:end)))),find(~cellfun(@isempty,strfind({files.name},curExp{k}(1:5))))));
        if ~isempty(curFile)
            list{k} = curFile.name;
            continue
        else 
            list{k} = nan;
        end
    end
    if sum(cellfun(@(V) any(isnan(V(:))), list)) == length(list)
        list = {files.name};
    end
    for k = 1 : length(list)
        try
            hup = openfig([Path '\' list{k}]);
            [pathstr,name] = fileparts([Path '\' list{k}]);
            curReport = [curReport; {name} {pathstr} {num2str(SlideNumber)} {hup.CurrentAxes.Title.String}];
        catch
            hup = figure('Visible','Off');
            h = text(0.2,0.5,sprintf(['No Data Found\n' curExp{k}]),'FontSize',34,'Units','normalized');
            set(hup.CurrentAxes,'visible','off');
        end
        toPPT(hup,'SlideNumber',SlideNumber);
        
    end
    curReport(1,:) = [];
    close all
    clear h;
end


function path = toPowerPointBG (Path,par)
    files = dir([Path '\*.fig']);
    for k = 1 : numel(files)
        if ~isempty(strfind(files(k).name,[par '.fig']));
            l = k;
        end
    end
    path = [Path '\' files(l).name];
end