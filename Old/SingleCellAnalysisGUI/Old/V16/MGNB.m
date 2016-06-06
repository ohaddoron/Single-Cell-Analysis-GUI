function MGNB (varargin) % Multi-Generation-Normalized-Batch

    switch nargin 
        case 1
            xlsLayout2 = varargin{1};
        case 2
            xlsLayout2 = varargin{1};
            outputLocation3 = varargin{2};
        case 3
            xlsLayout2 = varargin{1};
            outputLocation3 = varargin{2};
            scatterDecision = varargin{3};
        case 4 
            xlsLayout2 = varargin{1};
            outputLocation3 = varargin{2};
            scatterDecision = varargin{3};
            intensityDescision = varargin{4};
        case 5
            xlsLayout2 = varargin{1};
            outputLocation3 = varargin{2};
            scatterDecision = varargin{3};
            intensityDescision = varargin{4};
            concat = varargin{5};
        case 6
            xlsLayout2 = varargin{1};
            outputLocation3 = varargin{2};
            scatterDecision = varargin{3};
            intensityDescision = varargin{4};
            concat = varargin{5};
            ND = varargin{6};
       
    end
    
    
    verStr = 'Version 9 - 15/02/16';
    warning('off','all')
    PPTfiles = dir('\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\*.pptx');
    
    %% Main Program
    for t = 1 : length(xlsLayout2)
        
        % Apply macro
        xls_run_macro(xlsLayout2{t},'TRIMMING');
        [~,~,raw] = xlsread(xlsLayout2{t});
        temp = raw(4,:);
        temp(cellfun(@(temp) any(isnan(temp)),temp)) = [];
        EXPData{t} = raw(33:35,1:10);
        Experiments = raw(4:18,1:length(temp));
        Experiments(strcmp(Experiments(:,2),'NNN0'),:) = [];
        Paths = raw(20:30,1:3);
        
        
        
        Idx = cellfun(@(V) any(isnan(V(:))), raw(3,:));
        raw(3,find(Idx)) = {'NNN0'};
        PPTmasterspath = raw(5:18,find(~cellfun(@isempty,strfind(raw(3,:),'Template'))));
        
        
        for i = 1 : size(Experiments,1)-1
            curExp = Experiments(i+1,2:end);
            
            if strcmp(curExp(2),'NNN0') == 1
                mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
                matfiles = [char(outputLocation3{t}) '\' char(curExp(1)) '\Original mat files'];
                folderPath = [char(outputLocation3{t}) '\' char(curExp(1))];
                EXPname = curExp(1);
                EXPSUBname = '';
                mkdir(matfiles);
            else
                mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
                matfiles = [char(outputLocation3{t}) '\' char(curExp(1)) '\' char(strrep(curExp(2),':','-')) '\Original mat files'];
                folderPath = [char(outputLocation3{t}) '\' char(curExp(1)) '\' char(strrep(curExp(2),':','-'))];
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
            
            
            par = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Displacement2','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','MSD','Instantaneous_Angle'...
                        'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                        'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Coll','Eccentricity','Volume'...
                        ,'Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed'};
            if intensityDescision ~= 0
                par = [par {'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'}];
            end
            
            Normalize_mat_files(matfiles,par,folderPath)
            
            parTimeDependent = {'Velocity','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z','Displacement2','MSD','Instantaneous_Angle'...
                        'Directional_Change','Area','Ellipticity_oblate','Ellipticity_prolate',...
                        'Sphericity','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Coll','Eccentricity','Volume','Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed'};
                    
            if intensityDescision(t) ~= 0
                parTimeDependent = [parTimeDependent {'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1'}];
            end
            
            
                        
            
            [h.TimeDependent,Ax] = MD_parameter_to_time_multiple...
                    (folderPath,parTimeDependent,scale,Arrange,concat(t)); 
                
            ArrangeBG.choice = 0;
            ArrangeBG.list = [];
            files = dir([folderPath '\*.mat']);
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
                idx = find(cellfun(@isempty,ArrangeBG.list));
                ArrangeBG.list(idx) = [];
                [~,ia,~] = unique(ArrangeBG.list);
                ArrangeBG.list = ArrangeBG.list(ia);
            end
            
            parBarGraph = {'Velocity','Displacement2','MSD','Area','Linearity_of_Forward_Progression','Mean_Straight_Line_Speed','Mean_Curvilinear_Speed',...
                        'Confinement_Ratio','Track_Displacement_Length','Velocity_X','Velocity_Y','Velocity_Z','Acceleration','Acceleration_X','Acceleration_Y','Acceleration_Z',...
                        'Coll','Directional_Change','EllipsoidAxisLengthA','EllipsoidAxisLengthB','EllipsoidAxisLengthC'...
                        ,'Ellip_Ax_A_X','Ellip_Ax_A_Y','Ellip_Ax_A_Z','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_B_Z','Ellip_Ax_C_X','Ellip_Ax_C_Y','Ellip_Ax_C_Z','Instantaneous_Speed','Track_Displacement_X','Track_Displacement_Y','Track_Displacement_Z'...
                        ,'Ellipticity_oblate','Ellipticity_prolate','Volume','Eccentricity','Sphericity','Instantaneous_Angle'};
            if intensityDescision(t) ~= 0
                parBarGraph = [parBarGraph {'IntensityCenterCh1','IntensityCenterCh2','IntensityMaxCh1','IntensityMaxCh2',...
                        'IntensityMeanCh1','IntensityMeanCh2','IntensityMedianCh1','IntensityMedianCh2','IntensitySumCh1','IntensitySumCh2'}];
            end
            
            h.BarGraph = bar_graph...
                    (folderPath,parBarGraph,ArrangeBG,concat(t)); 
            close all;
            clear h;
            
            par1 = {'Area','Velocity'};
            par2 = {'Velocity','MSD','Coll','Sphericity'};
            
            par1_vs_par2 (folderPath , par1 , par2);
            
            
                
                
            
            
            
        end
    end
end

function Normalize_mat_files (varargin)

    folderPath = varargin{1};
    par = varargin{2};
    outputLocation = varargin{3};
    
    
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = numel(files);
    
    for i = 1 : num_of_mat_files
        filePath = [folderPath '\' files(i).name];
        temp = load(filePath);
        name = fieldnames(temp);
        At = temp.(name{1});
        
        A = find(~cellfun(@isempty,strfind({files.name},files(i).name(1:5))));
        %B = find(~cellfun(@isempty,strfind({files.name},'SK00CON')));
        B = find(~cellfun(@isempty,strfind({files.name},'CON')));
        
        conIdx = intersect(A,B);
        conFilePath = [folderPath '\' files(conIdx).name];
        temp = load(conFilePath);
        name = fieldnames(temp);
        conAt = temp.(name{1});
        
        
        for j = 1 : numel(par)
            At.(par{j}) = At.(par{j}) / nanmean(abs(conAt.(par{j})(:))) * 100;
        end
        
        save([outputLocation '\' files(i).name],'At');
    end
end

    


            
            
            
            