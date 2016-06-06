function Activate_toPowerPoint(xlsLayout2,outputLocation3,scatterDecision,intensityDescision,ND)
    

    verStr = 'Version Unknown - ##/##/##';
    warning('off','all')
    PPTfiles = dir('\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\*.pptx');
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
        PPTmasterspath = raw(Rup+1:Rdown-2,find(~cellfun(@isempty,strfind(raw(3,:),'Template'))));
        
        
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
                EXPSUBname = curExp(2);
                %mkdir(matfiles);
            end    
            
            
           
                
            PPTfile = PPTfiles(find(~cellfun(@isempty,strfind({PPTfiles.name},PPTmasterspath{i}))));
            PPTpath = ['\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\' PPTfile(end).name];
            mkdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use');
            copyfile(PPTpath,'\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use')
            PPTpath = ['\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use\' PPTfile(end).name];
            toPowerPoint([outputLocation3{t} '\' EXPname{1} '\' EXPSUBname{1}],EXPname,EXPSUBname,curExp(3:end),PPTpath,scatterDecision(t),EXPData{t},verStr,intensityDescision(t),ND(t));
            rmdir('\\metlab21\MATLAB\SingleCellAnalysisGUI\In Use','s') 
            
                
        end
        
             

    end
    warning('on','all')
end