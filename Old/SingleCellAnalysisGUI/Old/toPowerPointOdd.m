function toPowerPointOdd(folderPath,EXPname,EXPSUBname,curExp,masterPath,scatterDecision,EXPData)

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
    toPPT('setTitle',title,'SlideNumber',1);
    toPPT('setTable',{  {EXPData{1,:}} , {EXPData(2:end,:)}  },'SlideNumber',1,'Width%',100,'Height%',70,'TeX',0,'pos','N','posAnker','M');
   
   
    %% Sun Plot
   
    toPPT('setTitle',title,'SlideNumber',2);
    SPfiles = dir([SPpath '\*.fig']);
    for k = 1 : length(SPfiles)
        fileUp = SPfiles(find(~cellfun(@isempty,strfind({SPfiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
        
    end
    
    for k = 1 : length(list)
        hup = openfig([SPpath '\' list{k}]);
        toPPT(hup,'SlideNumber',2);
    end
    close all
    clear h;

    %% Velocity maps V(x,y)
    
    toPPT('setTitle',title,'SlideNumber',3);
    VelocityMapsXYpath = [Mapspath '\Velocity'];
    VelocityMapsXYfiles = dir([VelocityMapsXYpath '\*.fig']);
    for k = 1 : length(VelocityMapsXYfiles)
        fileUp = VelocityMapsXYfiles(find(~cellfun(@isempty,strfind({VelocityMapsXYfiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
        
    end
    
    for k = 1 : length(list)
        hup = openfig([VelocityMapsXYpath '\' list{k}]);
        toPPT(hup,'SlideNumber',3);
        
                
    end
    close all;
    %% Velocity maps V(x)
    
    toPPT('setTitle',title,'SlideNumber',4);
    VelocityMapsXpath = [Mapspath '\Velocity_X'];
    VelocityMapsXfiles = dir([VelocityMapsXpath '\*.fig']);
    for k = 1 : length(VelocityMapsXfiles)
        
        fileUp = VelocityMapsXfiles(find(~cellfun(@isempty,strfind({VelocityMapsXfiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
        
    end
    
    for k = 1 : length(list)
        hup = openfig([VelocityMapsXpath '\' list{k}]);
        
        toPPT(hup,'SlideNumber',4);
        
                
    end
    close all
    %% Velocity maps V(y)
    
    toPPT('setTitle',title,'SlideNumber',5);
    VelocityMapsYpath = [Mapspath '\Velocity_Y'];
    VelocityMapsYfiles = dir([VelocityMapsYpath '\*.fig']);
    for k = 1 : length(VelocityMapsYfiles)
            
        fileUp = VelocityMapsYfiles(find(~cellfun(@isempty,strfind({VelocityMapsYfiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;    

    end
    
    for k = 1 : length(list)
        hup = openfig([VelocityMapsYpath '\' list{k}]);
        toPPT(hup,'SlideNumber',5);
        
                
    end
    close all;
    clear h;
    %% Coordinated Motility
    
    toPPT('setTitle',title,'SlideNumber',6);
    CollMapspath = [Mapspath '\Coll'];
    CollMapsfiles = dir([CollMapspath '\*.fig']);
    for k = 1 : length(CollMapsfiles)
        
        fileUp = CollMapsfiles(find(~cellfun(@isempty,strfind({CollMapsfiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
    end
    
    for k = 1 : length(list)
        hup = openfig([CollMapspath '\' list{k}]);
        
        toPPT(hup,'SlideNumber',6);
        
                
    end
    close all;
    clear h;
    %% Velocity HGF
    toPPT('setTitle',title,'SlideNumber',7);
    VelocityTDpath = [TimeDependentpath '\Average Velocity over time.fig'];
    for k = 1 : length(filesBG)
        if ~isempty(strfind(filesBG(k).name,'Velocity.fig'))
            l = k;
        end
    end
    VelocityBGpath = [BarGraphpath '\' filesBG(l).name]; 
    h = openfig(VelocityTDpath);
    toPPT(h,'SlideNumber',7);
    h = openfig(VelocityBGpath);
    toPPT(h,'SlideNumber',7);
    close all
    %h = openfig(VelocityBGpath);
    %toPPT(h,'SlideNumber',6);
    %% Vx/Vy bar graphs
    toPPT('setTitle',title,'SlideNumber',8);
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
    toPPT(h,'SlideNumber',8);
    h = openfig(VelocityYBGpath);
    toPPT(h,'SlideNumber',8);
    
    %% XY absolute
    toPPT('setTitle',title,'SlideNumber',9);
    XYabsolutepath = [VelocityVxVyTimePath '\Abs'];
    XYabsolutefiles = dir([XYabsolutepath '\*.fig']);
    for k = 1 : length(XYabsolutefiles)
        fileUp = XYabsolutefiles(find(~cellfun(@isempty,strfind({XYabsolutefiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
        
    end
    
    for k = 1 : length(list)
        hup = openfig([XYabsolutepath '\' list{k}]);
        toPPT(hup,'SlideNumber',9);
        
                
    end
    close all;
    %% XY
    toPPT('setTitle',title,'SlideNumber',10);
    XYpath = [VelocityVxVyTimePath '\Sun'];
    XYfiles = dir([XYabsolutepath '\*.fig']);
    for k = 1 : length(XYfiles)
        fileUp = XYfiles(find(~cellfun(@isempty,strfind({XYfiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
        
    end
    
    for k = 1 : length(list)
        hup = openfig([XYpath '\' list{k}]);
        toPPT(hup,'SlideNumber',10);
        
                
    end
    close all;
    %% XY average
    toPPT('setTitle',title,'SlideNumber',11);
    XYAveragepath = [VelocityVxVyTimePath '\Time'];
    XYAveragefiles = dir([XYabsolutepath '\*.fig']);
    for k = 1 : length(XYAveragefiles)
        fileUp = XYAveragefiles(find(~cellfun(@isempty,strfind({XYAveragefiles.name},curExp{k}(6:end)))));
        list{k} = fileUp.name;
        
    end
    
    for k = 1 : length(list)
        hup = openfig([XYAveragepath '\' list{k}]);
        toPPT(hup,'SlideNumber',11);
        
                
    end
    %% XY Average for treatement
    toPPT('setTitle',title,'SlideNumber',12);
    XYAverageForTreatementPath = [VelocityVxVyTimePath '\Avg'];
    XYAverageForTreatementfiles = dir([XYAverageForTreatementPath '\*.fig']);
    h = openfig([XYAverageForTreatementPath '\' XYAverageForTreatementfiles(1).name]);
    toPPT(h,'SlideNumber',12);
    
    %% Displacement2
    toPPT('setTitle',title,'SlideNumber',13);
    TrackDisplacementTDpath = [TimeDependentpath '\Average Displacement2 over time.fig'];
    for k = 1 : length(filesBG)
        if ~isempty(strfind(filesBG(k).name,'Displacement2.fig'))
            l = k;
        end
    end
    TrackDisplacementBGpath = [BarGraphpath '\' filesBG(l).name]; 
    h = openfig(TrackDisplacementTDpath);
    toPPT(h,'SlideNumber',13);
    h = openfig(TrackDisplacementBGpath);
    toPPT(h,'SlideNumber',13);
    close all;
    %% MSD
    toPPT('setTitle',title,'SlideNumber',14);
    MSDTDpath = [TimeDependentpath '\Average MSD over time.fig'];
    for k = 1 : length(filesBG)
        if ~isempty(strfind(filesBG(k).name,'MSD.fig'))
            l = k;
        end
    end
    MSDBGpath = [BarGraphpath '\' filesBG(l).name]; 
    h = openfig(MSDTDpath);
    toPPT(h,'SlideNumber',14);
    h = openfig(MSDBGpath);
    toPPT(h,'SlideNumber',14);
    close all
    %% Directional Change
    toPPT('setTitle',title,'SlideNumber',15);
    DirectionalChangepath = [TimeDependentpath '\Average Directional_Change over time.fig'];
    h = openfig(DirectionalChangepath);
    toPPT(h,'SlideNumber',15);
    close all
    %% Area
    toPPT('setTitle',title,'SlideNumber',16);
    AreaTDpath = [TimeDependentpath '\Average Area over time.fig'];
    for k = 1 : length(filesBG)
        if ~isempty(strfind(filesBG(k).name,'Area.fig'))
            l = k;
        end
    end
    AreaBGpath = [BarGraphpath '\' filesBG(l).name]; 
    h = openfig(AreaTDpath);
    toPPT(h,'SlideNumber',16);
    h = openfig(AreaBGpath);
    toPPT(h,'SlideNumber',16);
    close all;
    %% Ellipsoid oblate & prolate
    toPPT('setTitle',title,'SlideNumber',17);
    EllipsoidOblateTDpath = [TimeDependentpath '\Average Ellipticity_oblate over time.fig'];
    EllipsoidProlateTDpath = [TimeDependentpath '\Average Ellipticity_prolate over time.fig'];
    h = openfig(EllipsoidOblateTDpath);
    toPPT(h,'SlideNumber',17);
    h = openfig(EllipsoidProlateTDpath);
    toPPT(h,'SlideNumber',17);
    close all;
    %% Eccenetricity
    toPPT('setTitle',title,'SlideNumber',18);
    EccentricityTDpath = [TimeDependentpath '\Average Eccentricity over time.fig'];
    h = openfig(EccentricityTDpath);
    toPPT(h,'SlideNumber',18);
    %% Sphericity
    toPPT('setTitle',title,'SlideNumber',19);
    SphericityTDpath = [TimeDependentpath '\Average Sphericity over time.fig'];
    h = openfig(SphericityTDpath);
    toPPT(h,'SlideNumber',19);
    %% Elipsoid Axis A/B/C
    toPPT('setTitle',title,'SlideNumber',20);
    EllipsoidAxisLengthBTDpath = [TimeDependentpath '\Average EllipsoidAxisLengthB over time.fig'];
    EllipsoidAxisLengthCTDpath = [TimeDependentpath '\Average EllipsoidAxisLengthC over time.fig'];
    h = openfig(EllipsoidAxisLengthBTDpath);
    toPPT(h,'SlideNumber',20);
    h = openfig(EllipsoidAxisLengthCTDpath);
    toPPT(h,'SlideNumber',20);
    close all;
    %% Bar Graphs
    toPPT('setTitle',title,'SlideNumber',21);
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
    toPPT(h,'SlideNumber',21);
    h = openfig(LinearityofForwardProgressionBGpath);
    toPPT(h,'SlideNumber',21);
    h = openfig(MeanStraightLineSpeedBGpath);
    toPPT(h,'SlideNumber',21);
    h = openfig(MeanCurvilinearSpeedBGpath);
    toPPT(h,'SlideNumber',21);
    h = openfig(ConfinementRatioBGpath);
    toPPT(h,'SlideNumber',21);    
    %% Layers
    if scatterDecision == 0
        toPPT('setTitle',title,'SlideNumber',22);
        Layersfiles = dir([Layerspath '\Velocity\*.fig']);
        for k = 1 : length(Layersfiles)

            fileUp = Layersfiles(find(~cellfun(@isempty,strfind({Layersfiles.name},curExp{k}(6:end)))));
            list{k} = fileUp.name;

        end

        for k = 1 : length(list)
            hup = openfig([Layerspath '\Velocity\' list{k}]);

            toPPT(hup,'SlideNumber',22);


        end
        close all
        clear h;
    end
    %% Cluster Analysis
    toPPT('setTitle',title,'SlideNumber',23);
    h = openfig([ClusterPath '\Clustergram.fig']);
    toPPT(h,'SlideNumber',23);
    %% save
    savePath = folderPath;
    saveFilename = char(strrep(EXPname,'/','-'));
    toPPT('savePath',savePath,'saveFilename',saveFilename);
    toPPT('close',1);
    close all;
    
    
end
    
