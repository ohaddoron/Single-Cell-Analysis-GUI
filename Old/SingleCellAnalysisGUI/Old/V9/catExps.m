function catExps ( folderPath , outputLocation , normalize , concat)


    
    files = dir([folderPath '\*.xlsm']);
    num_of_xls = numel(files);
    
    disp(['opening ' folderPath]);
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    for i = 1 : num_of_xls
        disp(['opening ' files(i).name]);
        
        filePath = [folderPath '\' files(i).name];
        
        [~,~,raw] = xlsread(filePath);
        
        [Rup,Cup] = find(cellfun(cellfind('Exp Sub Name'),raw));
        [Rdown,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
        [~,Cend] = find(cellfun(cellfind('Template'),raw));
        a = raw(Rup+1:Rdown-2,Cup+1:Cend-1);
        b = a(:);
        b(strcmp(b,'NNN0')) = [];
        [Rup,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
        [Rdown,~] = find(cellfun(cellfind('Protocol file'),raw));
        
        Paths = raw(Rup+2:Rdown-1,2:3);
        Paths(cellfun(@(x) any(isnan(x)),Paths)) = {'NNN0'};
        Paths(sum(strcmp(Paths,'NNN0'),2) == 2,:) = [];
        
        try
            expID = [expID b'];
        catch
            expID = b';
        end
        try 
            expPaths = [expPaths; Paths];
        catch
            expPaths = Paths;
        end
        
    end
    curExp = expID;
    Paths = expPaths;
%     if strcmp(curExp(2),'NNN0') == 1
%         mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
%         matfiles = [char(outputLocation3{t}) '\' char(curExp(1))];
%         EXPname = curExp(1);
%         EXPSUBname = '';
%         mkdir(matfiles);
%     else
%         mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
%         matfiles = [char(outputLocation3{t}) '\' char(curExp(1)) '\' char(strrep(curExp(2),':','-'))];
%         EXPname = curExp(1);
%         EXPSUBname = curExp(2);
%         mkdir(matfiles);
%     end    
%     if strcmp(EXPname,'NNN0')
%         error('End of files');
%     end
    curExpTemp = curExp(1:end);
    curExpTemp(strcmp(curExpTemp,'NNN0')) = [];
    curExp = curExpTemp;
    for j = 1 : length(curExp)
        curExpName = curExp{j}(1:5);
        curExpCode = curExp{j}(6:end); 
        tmp = Paths(strcmp(Paths(:,1),curExpName),2);
        curExpFolderPath = tmp(1);
        files = dir([curExpFolderPath{1} '\*.mat']);
        for k = 1 : length(files)
            if ~isempty(strfind(files(k).name,curExpCode)) == 1
                try
                    copyfile([curExpFolderPath{1} '\' files(k).name],outputLocation);
                catch 
                    continue;
                end
            end
        end       
    end
    
    
    
    folder_paths{1} = outputLocation;
    par = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'...
                        'Eccentricity'};
    TP.transpose = 1;
    TP.choice = 1;
    summaryTable(folder_paths,par,outputLocation,TP,normalize , concat)
        
    
    xlsPath = [outputLocation '\Cluster Analysis\Summary Table.xls'];
    Cluster ( xlsPath, folderPath , outputLocation );
    
end