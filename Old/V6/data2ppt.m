    function data2ppt(folderPaths,xlsLayout1,xlsLayout2,outputLocation1,outputLocation2,outputLocation3,dt,scatterDecision,intensityDescision,concat,ND)
    
    
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
    
    
    [xlsLayout2,ia,~] = unique(xlsLayout2);
    intensityDescision = intensityDescision(ia);
    %% Version 
    verStr = 'Version 6 - 07/12/2015';
    
    %% Renaming + MakeStruct
    EXPData = {};
    for i = 1 : length(xlsLayout1)
        Renaming(folderPaths{i},outputLocation1{i},xlsLayout1{i}); 
    end
    xlsLayout1 = unique(xlsLayout1);
    
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
            
            if ND(t) == 2 % Number of dimentions 
                %% 2D
                h.SunPlot = MC_Sun_plot_for_multiple(matfiles); 
                clear h;


                if intensityDescision(t) == 0
                    parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Acceleration','Acceleration_X','Acceleration_Y','Displacement2','MSD','Instantaneous_Angle'...
                        'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                        'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Coll','Eccentricity','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','Instantaneous_Speed'};
                else
                    parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Acceleration','Acceleration_X','Acceleration_Y','Displacement2','MSD','Instantaneous_Angle'...
                        'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                        'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Coll','Eccentricity','IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2',...
                        'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','Instantaneous_Speed'};
                end

                [h.TimeDependent,Ax] = MD_parameter_to_time_multiple...
                    (folder_path,parTimeDependent,scale,Arrange,concat(t)); 
                clear h;
                close all;

                scale.choice = [1 1];
                if intensityDescision(t) == 0
                    parMaps = {'Velocity','Velocity_X','Velocity_Y','Coll','Acceleration_X','Acceleration_Y'};
                else
                    parMaps = {'Velocity','Velocity_X','Velocity_Y','Coll','IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'...
                        ,'Acceleration_X','Acceleration_Y'};

                end

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
                        if ~isempty(strfind(files(k).name,temp{j}(6:end))) && ~isempty(strfind(files(k).name,temp{j}(1:5)))
                            if concat(t) ~= 0
                                ArrangeBG.list{j} = strrep(strrep([files(k).name(1:5) files(k).name(12:14) files(k).name(19:end)],'.mat',''),'NNN0','');
                            else
                                ArrangeBG.list{j} = strrep(strrep([files(k).name(1:5) files(k).name(12:14) files(k).name(16:end)],'.mat',''),'NNN0','');
                            end
                        end
                    end
                end
                if concat(t) ~= 0
                    [~,ia,~] = unique(ArrangeBG.list);
                    ArrangeBG.list = ArrangeBG.list(ia);
                end

                if intensityDescision(t) == 0
                    parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                        'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','Instantaneous_Speed','Ellipticity_oblate','Ellipticity_prolate'};
                else

                    parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                        'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC',...
                        'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'...
                        ,'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','Instantaneous_Speed','Ellipticity_oblate','Ellipticity_prolate'};
                end
                h.BarGraph = bar_graph...
                    (folder_path,parBarGraph,ArrangeBG,concat(t)); 
                close all;
                clear h;


                parLayers = {'Velocity'};
                numOfLayers = 7;
                layerWidth = 30;
                scale.choice = [1 1];
                if scatterDecision(t) == 0
                    try
                        h.Layers = Layers...
                            (folder_path,parLayers,numOfLayers,layerWidth,scale); 
                    catch
                        scatterDecision(t) = 1;
                    end
                end

                Velocity_XVsVelocity_YVsTime(folder_path);


                folder_paths{1} = folder_path;
                outputLocationCluster = folder_path;
                TP.choice = 1;
                TP.transpose = 1;
                if intensityDescision(t) == 0
                    parSummaryTable = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'};
                else
                    parSummaryTable = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'...
                        'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2','IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'};
                end
                summaryTable(folder_paths,parSummaryTable,outputLocationCluster,TP)
                folderPath = [folder_path '\Cluster Analysis'];
                ClusterAnalysis(folderPath);
                PPTfile = PPTfiles(find(~cellfun(@isempty,strfind({PPTfiles.name},PPTmasterspath{i}))));
                PPTpath = ['\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\' PPTfile.name];
                mkdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use');
                copyfile(PPTpath,'\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use')
                PPTpath = ['\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use\' PPTfile.name];
                toPowerPoint(folder_path,EXPname,EXPSUBname,curExp(3:end),PPTpath,scatterDecision(t),EXPData{t},verStr,intensityDescision(t));
                rmdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use','s') 
            else
                %% 3D
                % % Sun Plots 
                h = MC_Sun_plot_for_multiple( folder_path ); 
                h = MC_Sun_plot_for_multiple_XZ( folder_path );
                h = MC_Sun_plot_for_multiple_YZ( folder_path );
                clear h;
                
                % % Time Dependent
                if intensityDescision(t) == 0
                    parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','Displacement2','MSD','Instantaneous_Angle'...
                        'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                        'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Coll','Eccentricity','Volume','Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed'};
                else
                    parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Displacement2','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','MSD','Instantaneous_Angle'...
                        'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                        'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Coll','Eccentricity','IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2','Volume'...
                        ,'Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed'};
                end
                
                [h,Ax] = MD_parameter_to_time_multiple...
                    (folder_path,parTimeDependent,scale,Arrange,concat(t)); 
                clear h;
                close all;
                
                
                % % Maps
                
                scale.choice = [1 1];
                if intensityDescision(t) == 0
                    parMaps = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','Coll'};
                else
                    parMaps = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','Coll','IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'};

                end
                
                for k = 1 : length(parMaps)
                    l(k) = Ax.(parMaps{k});
                end
                h.Maps = scatter_plot_position_2_time_3D_multiple_par...
                    (folder_path,parMaps,l,scale);

                close all;
                clear h.Maps;
                
                % % Bar Graph
                
                ArrangeBG.choice = 0;
                ArrangeBG.list = [];
                files = dir([folder_path '\*.mat']);
                temp = curExp(3:end);
                for j = 1 : length(temp)
                    for k = 1 : length(files)
                        if ~isempty(strfind(files(k).name,temp{j}(6:end))) && ~isempty(strfind(files(k).name,temp{j}(1:5)))
                            if concat(t) ~= 0
                                ArrangeBG.list{j} = strrep(strrep([files(k).name(1:5) files(k).name(12:14) files(k).name(19:end)],'.mat',''),'NNN0','');
                            else
                                ArrangeBG.list{j} = strrep(strrep([files(k).name(1:5) files(k).name(12:14) files(k).name(16:end)],'.mat',''),'NNN0','');
                            end
                        end
                    end
                end
                if concat(t) ~= 0
                    [~,ia,~] = unique(ArrangeBG.list);
                    ArrangeBG.list = ArrangeBG.list(ia);
                end

                if intensityDescision(t) == 0
                    parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                        'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z',...
                        'Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','Instantaneous_Speed','Track_Displacement_X','Track_Displacement_Y','Track_Displacement_Z'...
                        ,'Ellipticity_oblate','Ellipticity_prolate'};
                else

                    parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                        'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC',...
                        'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'...
                        ,'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y','Instantaneous_Speed','Track_Displacement_X','Track_Displacement_Y','Track_Displacement_Z'...
                        'Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','Ellipticity_oblate','Ellipticity_prolate'};
                end
                h.BarGraph = bar_graph...
                    (folder_path,parBarGraph,ArrangeBG,concat(t)); 
                close all;
                clear h;
                
                % % Vx/Vy/Vz
                Velocity_XVsVelocity_YVsTime(folder_path)
                Velocity_XVsVelocity_ZVsTime(folder_path)
                Velocity_YVsVelocity_ZVsTime(folder_path)
                
                
                
                % % Summary Table + Cluster Analysis
                folder_paths{1} = folder_path;
                outputLocationCluster = folder_path;
                TP.choice = 1;
                TP.transpose = 1;
                if intensityDescision(t) == 0
                    parSummaryTable = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z'...
                        'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed'...
                        ,'Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'};
                else
                    parSummaryTable = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z'...
                        'Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'...
                        'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2','IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'};
                end
                summaryTable(folder_paths,parSummaryTable,outputLocationCluster,TP)
                folderPath = [folder_path '\Cluster Analysis'];
                ClusterAnalysis(folderPath);
                PPTfile = PPTfiles(find(~cellfun(@isempty,strfind({PPTfiles.name},PPTmasterspath{i}))));
                PPTpath = ['\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\' PPTfile.name];
                mkdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use');
                copyfile(PPTpath,'\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use')
                PPTpath = ['\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use\' PPTfile.name];
                toPowerPoint(folder_path,EXPname,EXPSUBname,curExp(3:end),PPTpath,scatterDecision(t),EXPData{t},verStr,intensityDescision(t),ND);
                rmdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use','s') 

                
                
            end
        end
       
        
    end
    warning('on','all')
end