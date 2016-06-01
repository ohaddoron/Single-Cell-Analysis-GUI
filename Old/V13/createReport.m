function Report = createReport ( xlsPath , verStr , ResultsLocation)

% % Load existing report
    
    try
        Path = '\\metlab21\Matlab\SingleCellAnalysisGUI\Report\Report.mat';
        load(Path);
        a = whos('Report');
        if a.bytes > 5e6
            mkdir('\\metlab21\Matlab\SingleCellAnalysisGUI\Report\Old');
            num_of_reports = numel(dir('\\metlab21\Matlab\SingleCellAnalysisGUI\Report\Old\*.mat'));
            movefile(Path,['\\metlab21\Matlab\SingleCellAnalysisGUI\Report\Old\Report ' num2str(num_of_reports + 1) '.mat']);
            error;
        end
    catch
        Report = cell(1,46);
        Report{1} = 'Initials';
        Report{2} = 'Experiment number';
        Report{3} = 'Date of run';
        Report{4} = 'Plate number';
        Report{5} = 'Well number';
        Report{6} = 'Channel';
        Report{7} = 'Cell type';
        for i = 8 : 13
            Report{i} = 'Treatment';
        end
        Report{14} = 'Location';
        Report{15} = 'Experiment name';
        Report{16} = 'Expeirment subname';
        for i = 17 : 26
            Report{i} = 'Protocol files';
        end
        for i = 27 : 38
            Report{i} = 'IncuCyte files';
        end
        for i = 37 : 46
            Report{i} = 'Imaris xls files';
        end
        Report{47} = 'Version';
    end
%     Report = rmfield(Report,'Report');
% % Load the current xls file
        cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
    [~,~,raw] = xlsread(xlsPath);
% % extract out of the raw data the experiments    
    [Rup,~] = find(cellfun(cellfind('Exp Num'),raw));
    [Rdown,~] = find(cellfun(cellfind('Experiment Structure Path'),raw));
    
    exps = raw(Rup:Rdown-2,:);
    exps(:,end) = [];
% % extract the experiment paths    
    Rup = Rdown;
    [Rdown,~] = find(cellfun(cellfind('Protocol file'),raw));
    Paths = raw(Rup+2:Rdown-2,2:3);
% % get initials    
    expNames = Paths(:,1);
    expNames(strcmp(expNames,'NNN0')) = [];
    expPaths = Paths(:,2);
    
% % Get 'Protocol file' 'IncuCyte files' 'Imaris xls files'
    [R,~] = find(cellfun(cellfind('Protocol file'),raw));
    Protocol_file = raw(R,2:end);
    IncuCyte_files = raw(R+1,2:end);
    Imaris_xls_files = raw(R+2,2:end);

% % Removing nans
    Protocol_file(cellfun(@(V) any(isnan(V(:))), Protocol_file)) = [];
    IncuCyte_files(cellfun(@(V) any(isnan(V(:))), IncuCyte_files)) = [];
    Imaris_xls_files(cellfun(@(V) any(isnan(V(:))), Imaris_xls_files)) = [];
    
% % Removing NNN0 from exps

    NNN0_idx = sum(cellfun(@isempty,strfind(exps(2:end,2:end-1),'NNN0')),2);
    NNN0_idx = [1; NNN0_idx];
    exps(~NNN0_idx,:) = [];
    
    
    
    
% % check if the initials exist in the report. if not, create record 
    for i = 2 :size(exps,1)
% % Get all experiments
        curExp = exps(i,4:end);
        curExp(strcmp(curExp,'NNN0')) = [];
        curExp = curExp(1:end-1);
        for j = 1 : numel(curExp)
% % Extract Initials , plate and well location
            curInitials = curExp{j}(1:5);
            curPlate = curExp{j}(end-3);
            curWell = curExp{j}(end-2:end);
            if numel(curExp{j}) <= 9
                curChannel = 'CHR';
            else
                curChannel = curExp{j}(6:8);
            end
            curPath = expPaths(strcmp(expNames,curInitials));
        
            files = dir([curPath{1} '\*.mat']);
            IndexC = strfind({files.name}, [curChannel curPlate curWell]);
            Index = find(not(cellfun('isempty', IndexC)));
            if isempty(Index)
                curPlate = '1';
                IndexC = strfind({files.name}, [curChannel curPlate curWell]);
                Index = find(not(cellfun('isempty', IndexC)));
            end
            
            
            try
                curTreatment = strrep(files(Index).name(19:end),'.mat','');
            

                curChannel = files(Index).name(12:14);
                newTreat = [];
                for j = 1 : 4 : numel(curTreatment)
                    newTreat = [newTreat {curTreatment(j:j+3)}];
                end
                curTreatment = newTreat;
                Report = [Report; [{curInitials(1:2)} {[' ' curInitials(3:end) ' ']} {datestr(datetime('today'))} {curPlate}...
                    {curWell} {curChannel} curTreatment ResultsLocation exps(i,2) {[' ' exps{i,3}]}...
                    Protocol_file IncuCyte_files Imaris_xls_files ...
                     {verStr}]];
            catch
            end
        end
    end
%     save(Report,['\\metlab21\Matlab\SingleCellAnalysisGUI\Report\Report.mat\Report.mat']);
    
    save(Path,'Report');
        
        
        
        
    
    
    
% % 
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        