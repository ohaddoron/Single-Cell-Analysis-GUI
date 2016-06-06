function data2ppt(varargin)
    
    
    switch nargin 
        case 1
            folderPaths = varargin{1};
        case 2 
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
        case 3
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
        case 4
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
        case 5 
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
        case 6
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
        case 7 
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
            dt = varargin{7};
        case 8
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
            dt = varargin{7};
            scatterDecision = varargin{8};
        case 9 
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
            dt = varargin{7};
            scatterDecision = varargin{8};
            intensityDescision = varargin{9};
        case 10
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
            dt = varargin{7};
            scatterDecision = varargin{8};
            intensityDescision = varargin{9};
            concat = varargin{10};
        case 11 
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
            dt = varargin{7};
            scatterDecision = varargin{8};
            intensityDescision = varargin{9};
            concat = varargin{10};
            ND = varargin{11};
        case 12
            folderPaths = varargin{1};
            xlsLayout1 = varargin{2};
            xlsLayout2 = varargin{3};
            outputLocation1 = varargin{4};
            outputLocation2 = varargin{5};
            outputLocation3 = varargin{6};
            dt = varargin{7};
            scatterDecision = varargin{8};
            intensityDescision = varargin{9};
            concat = varargin{10};
            ND = varargin{11};
            normalize = varargin{12};
        
    end
        
    
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
    
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    [xlsLayout2,ia,~] = unique(xlsLayout2);
    intensityDescision = intensityDescision(ia);
    %% Version 
    verStr = 'Version 12 - 17/03/16';

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
        temp = raw(4,:);
        temp(cellfun(@(temp) any(isnan(temp)),temp)) = [];
        [Rup,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
        [Rdown,~] = find(cellfun(cellfind('Protocol file'),raw));

        Paths = raw(Rup+1:Rdown-1,1:3);
        Paths(cellfun(@(x) any(isnan(x)),Paths)) = {'NNN0'};


        R = find(cellfun(cellfind('Protocol file'),raw));
        EXPData{t} = raw(R:R+2,:);
        EXPData{t}(cellfun(@(x) any(isnan(x)),EXPData{t})) = {'NNN0'};



        [Rup,~] = find(cellfun(cellfind('Exp Num'),raw));
        [Rdown,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
        Experiments = raw(Rup:Rdown-2,1:length(temp));
        Experiments(strcmp(Experiments(:,2),'NNN0'),:) = [];
        Experiments(cellfun(@(x) any(isnan(x)),Experiments)) = {'NNN0'};
        %Paths = raw(20:30,1:3); 
        
        Idx = cellfun(@(V) any(isnan(V(:))), raw(3,:));
        raw(3,find(Idx)) = {'NNN0'};
        PPTmasterspath = raw(Rup+1:Rdown-2,find(~cellfun(@isempty,strfind(raw(3,:),'Template'))));
        
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
                tmp = Paths(strcmp(Paths(:,2),curExpName),3);
                curExpFolderPath = tmp(1);
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
            

            if nargin >= 12 && normalize(t) ~= 0 
                par = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                        'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z',...
                        'Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed','Track_Displacement_X','Track_Displacement_Y','Track_Displacement_Z'...
                        ,'Ellipticity_oblate','Ellipticity_prolate','Volume','Eccentricity','Sphericity','Instantaneous_Angle'};
                if intensityDescision(t) == 1
                    par = [par {'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                    'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'}];
                end
                normalized_graphs ( folderPath , par , 0 , 0 );
                delete( [folderPath '\*.mat' ] );
                copyfile([folderPath '\Normalized\*.mat'],folderPath);
            end

            h.SunPlot = MC_Sun_plot_for_multiple(matfiles); 
            clear h;

            if ND == 3
                h = MC_Sun_plot_for_multiple_XZ( folder_path );
                h = MC_Sun_plot_for_multiple_YZ( folder_path );
            end

            parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','Displacement2','MSD','Instantaneous_Angle'...
                    'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                    'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                    ,'Coll','Eccentricity','Volume','Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed'};

            if intensityDescision(t) ~= 0
                parTimeDependent = [parTimeDependent 'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                    'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'];
            end

            [h.TimeDependent,Ax] = MD_parameter_to_time_multiple...
                (folder_path,parTimeDependent,scale,Arrange,concat(t)); 

            scale.choice = [1 1];
            parMaps = {'Velocity','Velocity_X','Velocity_Y','Coll','Acceleration','Acceleration_X','Acceleration_Y'};
            if intensityDescision(t) ~= 0
                parMaps = [parMaps {IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1',...
                    'IntensityMaxCh2','IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1',...
                    'IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'}];
            end
            if ND == 3
                parMaps = [parMaps {'Velocity_Z','Acceleration_Z'}];
            end

            for k = 1 : length(parMaps)
                l(k) = Ax.(parMaps{k});
            end
            h.Maps = scatter_plot_position_2_time_3D_multiple_par...
                (folder_path,parMaps,l,scale);

            ArrangeBG.choice = 0;
            ArrangeBG.list = [];
            files = dir([folder_path '\*.mat']);
            temp = curExp(3:end);
            for j = 1 : length(temp)
                for k = 1 : length(files)
                    if ~isempty(strfind(files(k).name,temp{j}(6:end))) && ~isempty(strfind(files(k).name,temp{j}(1:5)))
                        if concat(t) ~= 0
                            ArrangeBG.list{j} = strrep(strrep(files(k).name,'.mat',''),'NNN0','');
                        else
                            ArrangeBG.list{j} = strrep(strrep(files(k).name,'.mat',''),'NNN0','');
                        end
                    end
                end
            end

            if concat(t) ~= 0
                [~,ia,~] = unique(ArrangeBG.list);
                ArrangeBG.list = ArrangeBG.list(ia);
            end

            parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                    'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z',...
                    'Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                    ,'Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed','Track_Displacement_X','Track_Displacement_Y','Track_Displacement_Z'...
                    ,'Ellipticity_oblate','Ellipticity_prolate','Volume','Eccentricity','Sphericity','Instantaneous_Angle'...
                    'Starting_Time','Starting_Value','Ending_Time','Ending_Value','Maximum_Height','Time_of_Maximum_Height','Full_Width_Half_Maximum'};

            if intensityDescision(t) ~= 0
                parBarGraph = [parBarGraph {'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                    'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'}];
            end

            h.BarGraph = bar_graph...
                (folder_path,parBarGraph,ArrangeBG,concat(t)); 

            parLayers = {'Velocity'};
            numOfLayers = 7;
            layerWidth = 30;
            scale.choice = [1 1];
            if scatterDecision(t) == 0 && ND ~= 3
                try
                    h.Layers = Layers...
                        (folder_path,parLayers,numOfLayers,layerWidth,scale); 
                    Vx_vs_Vy_vs_Time_Layers ( folder_path , numOfLayers, layerWidth );
                catch
                    scatterDecision(t) = 1;
                end
            end

            Velocity_XVsVelocity_YVsTime(folder_path,concat(t));
            if ND == 3
                Velocity_XVsVelocity_ZVsTime(folder_path,concat(t));
                Velocity_YVsVelocity_ZVsTime(folder_path,concat(t));
            end

            par1 = {'Area'};
            par2= {'Velocity','MSD','Coll','Sphericity'};

            par1_vs_par2 (folder_path , par1 , par2 , normalize)

            par1 = {'Velocity'};
            par2 = {'MSD','Coll','Sphericity'};

            par1_vs_par2 (folder_path , par1 , par2 , normalize)


            folder_paths{1} = folder_path;
            outputLocationCluster = folder_path;
            TP.choice = 1;
            TP.transpose = 1;
            parSummaryTable = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y',...
                    'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'...
                    'Eccentricity'};
            if intensityDescision(t) ~= 0
                parSummaryTable = [parSummaryTable {'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2','IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'}];
            end

            if ND == 3
                parSummaryTable = [parSummaryTable {'Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_Z','Ellip_Ax_C_Z',...
                    'Acceleration_Z','Velocity_Z'}];
            end

            summaryTable(folder_paths,parSummaryTable,outputLocationCluster,TP)
            folderPath = [folder_path '\Cluster Analysis'];
            ClusterAnalysis(folderPath);
            
            end
            close all force;
        end
        

        for t = 1 : length (xlsLayout2)
            try    
                createReport(xlsLayout2{t} , verStr);
            catch
            end
            for i = 1 : size(Experiments,1)-1
                PPTfile = PPTfiles(find(~cellfun(@isempty,strfind({PPTfiles.name},PPTmasterspath{i}))));
                PPTpath = ['\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\' PPTfile.name];
                mkdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use');
                copyfile(PPTpath,'\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use')
                PPTpath = ['\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use\' PPTfile.name];
                toPowerPoint(folder_path,EXPname,EXPSUBname,curExp(3:end),PPTpath,scatterDecision(t),EXPData{t},verStr,intensityDescision(t),ND(t));
                rmdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use','s') 

            end
                close all force;
        end

    warning('on','all')
end