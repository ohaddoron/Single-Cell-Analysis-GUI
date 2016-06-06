function Activate_toPowerPoint(xlsLayout2,outputLocation3,scatterDecision,intensityDescision,ND)
    

    verStr = 'Version Unknown - ##/##/##';
    warning('off','all')
    PPTfiles = dir('\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters\*.pptx');
    for t = 1 : length(xlsLayout2)
        % Apply macro
        xls_run_macro(xlsLayout2{t},'TRIMMING');
        [~,~,raw] = xlsread(xlsLayout2{t});
        EXPData{t} = raw(33:35,1:10);
        Experiments = raw(4:18,1:27);
        Experiments(strcmp(Experiments(:,2),'NNN0'),:) = [];
        PPTmasterspath = raw(5:18,28);
        
        
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