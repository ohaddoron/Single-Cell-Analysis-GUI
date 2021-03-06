    function data2ppt(folderPaths,xlsLayout1,xlsLayout2,outputLocation1,outputLocation2,outputLocation3,dt,scatterDecision)
    
    
    warning('off','all')
    % folderPaths - cell array. in each cell is the path a folder  holding the imaris output files
    % xlsLayout1 - cell array. in each cell is the path to a xls layout
    % used to rename an experiment.
    % xlsLayout2 - cell array. in each cell is a path to a xls layout which
    % holds the experiments
    % outputLocation1 - cell array. in each cell is the path of the output
    % location where the renamed files are found
    % outputLocation2 - cell array. in each cell is the path of the output
    % location where the newly formed matfiles will be saved. 
    % outputLocation3 - cell array. in each cell is the path of the output
    % location where the experiment data is saved.
    % dt - scalar value. the time interval for the experiment.
    % scatterDecision - array of logical values. used to determine wheter said
    % experiments are scatter or scratch.
    
    
    % Version 
    verStr = 'Version 1';
    
    %% Renaming + MakeStruct
    EXPData = {};
    for i = 1 : length(xlsLayout1)
        Renaming(folderPaths{i},outputLocation1{i},xlsLayout1{i}); 
    end
    xlsLayout1 = unique(xlsLayout1);
    xlsLayout2 = unique(xlsLayout2);
    [outputLocation1,ia,~] = unique(outputLocation1);
    dt = dt(ia);
    outputLocation2 = unique(outputLocation2);
    for i = 1 : length(outputLocation1)
        MakeStructMultiple(outputLocation1{i},outputLocation2{i},dt(i))
        [~,~,raw] = xlsread(xlsLayout1{i});
        expName = char([raw{2,1} raw{2,2}]);
        [~,~,raw] = xlsread(xlsLayout2{i});
        raw{22,2} = expName;
        raw{22,3} = outputLocation2{i};
        xlswrite(xlsLayout2{i},raw);
    end
    
    PPTfiles = dir('\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\*.pptx');
    %% Main Program
    for t = 1 : length(xlsLayout2)
        % Apply macro
        xls_run_macro(xlsLayout2{t},'TRIMMING');
        [~,~,raw] = xlsread(xlsLayout2{t});
        EXPData{t} = raw(33:35,1:10);
        Experiments = raw(4:18,1:27);
        Experiments(strcmp(Experiments(:,2),'NNN0'),:) = [];
        Paths = raw(20:30,1:3);
        PPTmasterspath = raw(5:18,28);
        
        
        for i = 1 : size(Experiments,1)-1
            curExp = Experiments(i+1,2:end);
            
            if strcmp(curExp(2),'NNN0') == 1
                mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
                matfiles = [char(outputLocation3{t}) '\' char(curExp(1))];
                EXPname = curExp(1);
                EXPSUBname = '';
                mkdir(matfiles);
            else
                mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
                matfiles = [char(outputLocation3{t}) '\' char(curExp(1)) '\' char(strrep(curExp(2),':','-'))];
                EXPname = curExp(1);
                EXPSUBname = curExp(2);
                mkdir(matfiles);
            end    
            if strcmp(EXPname,'NNN0')
                error('End of files');
            end
            curExpTemp = curExp(3:end);
            curExpTemp(strcmp(curExpTemp,'NNN0')) = [];
            curExp = [curExp(1:2) curExpTemp];
            for j = 3 : length(curExp)
                curExpName = curExp{j}(1:5);
                curExpCode = curExp{j}(6:end); 
                curExpFolderPath = Paths(strcmp(Paths(:,2),curExpName),3);
                files = dir([curExpFolderPath{1} '\*.mat']);
                for k = 1 : length(files)
                    if ~isempty(strfind(files(k).name,curExpCode)) == 1
                        try
                            copyfile([curExpFolderPath{1} '\' files(k).name],matfiles);
                        catch 
                            continue;
                        end
                    end
                end       
            end
            Arrange.choice = 0;
            scale.choice = [1 1];
            Arrange.list = curExp(3:end);
            folder_path = matfiles;

            h.SunPlot = MC_Sun_plot_for_multiple(matfiles); 
            clear h;


            parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Displacement2','MSD','Instantaneous_Angle'...
                'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                ,'Coll','Eccentricity'};

            [h.TimeDependent,Ax] = MD_parameter_to_time_multiple...
                (folder_path,parTimeDependent,scale,Arrange); 
            clear h;
            close all;
            
            scale.choice = [1 1];
            parMaps = {'Velocity','Velocity_X','Velocity_Y','Coll'};  
            for k = 1 : length(parMaps)
                l(k) = Ax.(parMaps{k});
            end
            h.Maps = scatter_plot_position_2_time_3D_multiple_par...
                (folder_path,parMaps,l,scale);
            
            close all;
            clear h.Maps;
            ArrangeBG.choice = 0;
            ArrangeBG.list = [];
            files = dir([folder_path '\*.mat']);
            temp = curExp(3:end);
            for j = 1 : length(temp)
                for k = 1 : length(files)
                    if strfind(files(k).name,temp{j}(6:end))
                        ArrangeBG.list{j} = strrep(strrep([files(k).name(12:14) files(k).name(16:end)],'.mat',''),'NNN0','');
                    end
                end
            end
            parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Coll'};
            h.BarGraph = bar_graph...
                (folder_path,parBarGraph,ArrangeBG); 
            close all;
            clear h;

            parLayers = {'Velocity'};
            numOfLayers = 7;
            layerWidth = 30;
            scale.choice = [1 1];
            if scatterDecision(t) == 0
                h.Layers = Layers...
                    (folder_path,parLayers,numOfLayers,layerWidth,scale); 
            end
            
            Velocity_XVsVelocity_YVsTime(folder_path);
            
            
            folder_paths{1} = folder_path;
            outputLocationCluster = folder_path;
            TP.choice = 1;
            TP.transpose = 1;
            parSummaryTable = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'};
            summaryTable(folder_paths,parSummaryTable,outputLocationCluster,TP)
            folderPath = [folder_path '\Cluster Analysis'];
            ClusterAnalysis(folderPath);
            PPTfile = PPTfiles(find(~cellfun(@isempty,strfind({PPTfiles.name},PPTmasterspath{i}))));
            PPTpath = ['\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\' PPTfile.name];
            mkdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use');
            copyfile(PPTpath,'\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use')
            PPTpath = ['\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use\' PPTfile.name];
            toPowerPoint(folder_path,EXPname,EXPSUBname,curExp(3:end),PPTpath,scatterDecision(t),EXPData{t});
            rmdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use','s') 
        end
        
    end
    warning('on','all')
end