function lme = MixedModel (folderPath,par)
    
    warning('off','all')
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = length(files);
    mkdir([folderPath '\Mixed Model']);
    Decoder = [];
    for i = 1 : num_of_mat_files
        filePath = [folderPath '\' files(i).name];
        EXPName{i} = [strrep(num2str(files(i).name(1:22)+0),' ','') '0000'];
        Decoder = [Decoder; [{files(i).name(1:22)} {strrep(num2str(files(i).name(1:22)+0),' ','')}]];
        temp = load(filePath);
        name = fieldnames(temp);
        At = temp.(name{1});
        upperScratch = [];
        lowerScratch = [];
        
        for t = 1 : size(At.y_Pos,1)
            try
                [lowerScratch(t), upperScratch(t)] = scratchDetect(At,t);
            catch 
                lowerScratch = [lowerScratch lowerScratch(t-1)];
                upperScratch = [upperScratch upperScratch(t-1)];
            end
        end
        for j = 1 : length(par)
            ID = [];
            Rep = [];
            Time = [];
            Position_y = [];
            HGF = [];
            Par = [];
            low = [];
            high = [];
            if i == 1 
                Data.(par{j}) = [];
            end
            for k = 1 : size(At.(par{j}),2)
                curCell.HGF = [];
                curCell.(par{j}) = At.(par{j})(:,k);
                curCell.y_Pos = At.y_Pos(:,k);
                curCell.Time = (0 : length(curCell.(par{j}))-1) * At.dt;
                name = EXPName{i};
                name(length(name) - length(num2str(k)) + 1 : length(name)) = num2str(k);
                
                curCell.ID(1:length(curCell.(par{j}))) = str2num(name);
                curCell.ID(isnan(curCell.(par{j}))) = [];
                
                low = abs(lowerScratch' - curCell.y_Pos);
                high = abs(upperScratch' - curCell.y_Pos);
                low(isnan(curCell.(par{j}))) = [];
                high(isnan(curCell.(par{j}))) = [];
                curCell.Position_y = min([low,high],[],2); 
                
                curCell.y_Pos(isnan(curCell.(par{j}))) = [];
                
                curCell.Time(isnan(curCell.(par{j}))) = [];
                curCell.(par{j})(isnan(curCell.(par{j}))) = [];
                if isempty(strfind(files(i).name,'CON'))
                    curCell.HGF(1:length(curCell.(par{j}))) = str2num(files(i).name(26));
                else
                    curCell.HGF(1:length(curCell.(par{j}))) = 0;
                end
                curCell.Rep = 1 : length(curCell.(par{j}));
                
                curCell.Par = log10(curCell.(par{j}));
                ID = [ID; (curCell.ID)'];
                Rep = [Rep; (curCell.Rep)'];
                Time = [Time; (curCell.Time)'];
                Position_y = [Position_y; (curCell.Position_y)];
                HGF = [HGF; (curCell.HGF)'];
                Par = [Par; (curCell.Par)];
            end
            Data.(par{j}) = [Data.(par{j}); [ID Rep Time Position_y HGF Par]];
        end
    end
    xlswrite([folderPath '\Mixed Model\Decoder.xlsx'],Decoder);
    %{
    for j = 1 : length(par)
        Data.(par{j}) = [nan(1,size(Data.(par{j}),2)) ;Data.(par{j})];
        titles = {'ID','Rep','Time','Position_y','HGF','Value'};
        xlswrite([folderPath '\Mixed Model\' par{j} '.xlsx'],Data.(par{j}));
        xlswrite([folderPath '\Mixed Model\' par{j} '.xlsx'],titles);
    end
    %}
    FixedEffects = {'HGF','Position_y','Time','Time^2','HGF * Time',...
        'HGF * Time ^ 2','Position_y * Time', 'Position_y * Time ^ 2'};
    RandomEffects = {'Time + Time ^2'};
    RepeatedEffects = {'Rep'};
    
    for j = 1 : length(par)
        X = [];
        y = [];
        Z = [];
        
        X(:,1) = Data.(par{j})(:,5);
        X(:,2) = Data.(par{j})(:,4);
        X(:,3) = Data.(par{j})(:,3);
        X(:,4) = Data.(par{j})(:,3) .^2;
        X(:,5) = Data.(par{j})(:,5) .* Data.(par{j})(:,3);
        X(:,6) = Data.(par{j})(:,5) .* (Data.(par{j})(:,3).^2);
        X(:,7) = Data.(par{j})(:,4) .* Data.(par{j})(:,3);
        X(:,8) = Data.(par{j})(:,4) .* (Data.(par{j})(:,3).^2);
        
        Z(:,1) = Data.(par{j})(:,3) + Data.(par{j})(:,3).^2;
        
        y = Data.(par{j})(:,6);
        
        lme.(par{j}) = fitlmematrix(X,y,Z,[]);
    end
            
          
        
    
    warning('on','all')
end



function [lowerScratch, upperScratch] = scratchDetect(At,t)
    [counts,centers] = hist(At.y_Pos(t,:));
    counts(counts<10) = 0;
    posCenters = 1:length(counts);
    posCenters = posCenters(counts==0);
    lowerScratch = centers(min(posCenters)-1);
    upperScratch = centers(max(posCenters)+1);
end