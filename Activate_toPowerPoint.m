function Activate_toPowerPoint(xlsLayout2,outputLocation3,scatterDecision,intensityDescision,ND)
    

    %% Loading control file
    
    addpath(genpath(pwd));
    try
        load('Control.mat');
    catch
        errordlg('No control file was found. Please create a control file and try again');
        error('No Control file was found');
    end
    try
        verStr = strcat('Version ',Control.Version,' - ',Control.Version_Date);
    catch
        errordlg('Version not found in the control file. Please input version');
        error('Version not found');
    end
    try
        PPTsPath = Control.Location_of_PPT_Templates;
    catch
        errordlg('Power Point templates path not found in the control file. Please input path');
        error('Power Point template path not found');
    end
    tmpfiles = dir([PPTsPath '\*.pptx']);
    if isempty(tmpfiles)
       errordlg('No power point templaes were found in the specified path');
       error('No power point templates were found in the specified path'); 
    end
    rmpath(genpath(pwd));
    clear('Control');

    
    warning('off','all')
    PPTfiles = dir(strcat(PPTsPath,'\*.pptx'));
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
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
        cidx = strfind(raw(3,:),'Template');
        cidx = find(~cellfun(@isempty,cidx));
        if isempty(cidx)
            Idx = cellfun(@(V) any(isnan(V(:))), raw(4,:));
            raw(4,find(Idx)) = {'NNN0'};
            cidx = strfind(raw(4,:),'Template');
        end
        
        PPTmasterspath = raw(Rup+1:Rdown-2,cidx);
        
        
        for i = 1 : size(Experiments,1)-1
            curExp = Experiments(i+1,2:end);
            
            if strcmp(curExp(2),'NNN0') == 1
                mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
                %matfiles = [char(outputLocation3{t}) '\' char(curExp(1))];
                EXPname = curExp(1);
                EXPSUBname = {''};
                %mkdir(matfiles);
            else
                mkdir([char(outputLocation3{t}) '\' char(curExp(1))]);
                %matfiles = [char(outputLocation3{t}) '\' char(curExp(1)) '\' char(strrep(curExp(2),':','-'))];
                EXPname = curExp(1);
                EXPSUBname = strrep(curExp(2),':','-');
                %mkdir(matfiles);
            end    
            
            
           
                
            PPTfile = PPTfiles(find(~cellfun(@isempty,strfind({PPTfiles.name},PPTmasterspath{i}))));
            PPTpath = strcat(PPTsPath,'\',PPTfile(end).name);
            InUse = strcat(pwd,'\In Use');
            mkdir(InUse);            
            copyfile(PPTpath,InUse)
            PPTpath = strcat(InUse,'\',PPTfile(end).name);
            toPowerPoint([outputLocation3{t} '\' EXPname{1} '\' EXPSUBname{1}],EXPname,EXPSUBname,curExp(3:end),PPTpath,scatterDecision{t},EXPData{t},verStr,intensityDescision{t},ND{t});
            
            rmdir(InUse,'s') 
            
                
        end
        createReport(xlsLayout2{t} , verStr , outputLocation3{t});
        
             

    end
    warning('on','all')
end