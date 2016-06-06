function IF_SummaryTable (retData,retLabels, xlsPath,outputFolder)


    fh = @(x) all(isnan(x(:)));
    rowNames = {};
    [~,~,raw] = xlsread(xlsPath);
    rowAb1 = sum(strcmp(raw,'Ab1'),2);
    colAb1 = sum(strcmp(raw,'Ab1'),1);
    
    rowAb2 = sum(strcmp(raw,'Ab2'),2);
    colAb2 = sum(strcmp(raw,'Ab2'),1);
    
    Ab1 = raw(find(rowAb1)+1:end,find(colAb1));
    Ab2 = raw(find(rowAb2)+1:end,find(colAb2));
    
    Ab1(cellfun(fh, Ab1)) = [];
    Ab2(cellfun(fh, Ab2)) = [];
    
    
    prots = [Ab1 Ab2];
    
    tbl = table(cat(1,prots(:)));
    
    for i = 1 : height(tbl)
        tblRowNames = [];
        curProt = tbl{i,1};
        a = strfind(prots,curProt{1});
        a(cellfun(@isempty,a)) = {nan};
        a = cell2mat(a);
        
        if ~isempty(find(~cellfun(@isempty,strfind(Ab1,curProt{1}))))
            chData = raw{5,7};
        else
            chData = raw{5,8};
        end
        
        
        chIndex = find(~cellfun(@isempty,strfind(retLabels,chData)));
        protIndex = find(~cellfun(@isempty,strfind(retLabels,curProt{1})));
        count = 1;
        for k = 1 : length(protIndex)
            if sum(chIndex == protIndex(k)) == 1
                index(count) = protIndex(k);
                count = count + 1;
            end
        end
        
        
        curData = retData(index);
        curLabels = retLabels(index);
        tblData = cat(1,curData{:})';
        for j = 1 : length(curLabels)
            
            
            a = 1 : length(curData{j});
            b = num2str(a');
            c = 'Layer';
            d = repmat(c,[length(curData{j}),1]);
            e = '';
            f = repmat(e,[length(curData{j}),1]);
            g = [d f b];
            curTreat = curLabels{j}(4:end - 8);
            if ~isempty(tblRowNames(:))
                if find(~cellfun(@isempty,strfind(tblRowNames(:),curTreat)))
                    curTreat = [curTreat ' ' num2str(j) ' '];
                end
            end
            
            curTreat = repmat(curTreat,[length(curData{j}),1]);
            tblRowNames = [tblRowNames cellstr([curTreat g])];
        end
        T{i} = tblData(:);
        prot{i} = curProt;
        rowNames{i} = tblRowNames(:);
        
        
    end
    
    for i = 1 : length(T)
        s(i) = length(T{i});
    end
    [~,I] = sort(s,'descend');
    T = T(I);
    rowNames = rowNames(I);
    prots = prots(:);
    prots = prots(I);
    xlsWriter = [nan prots'];
    xlsWriter = [xlsWriter; cell(length(T{1}),length(xlsWriter))];
    xlsWriter(2:end,1) = rowNames{1};
    for i = 1 : length(T)
        curData = T{i};
        for j = 1 : length(curData)
            if ~isempty(strcmp(xlsWriter(:,1),rowNames{i}{j}))
                xlsWriter(strcmp(xlsWriter(:,1),rowNames{i}{j}),find(strcmp(xlsWriter(1,:),prots{i}))) = {curData(j)};
            else
                xlsWriter = [xlsWriter; rowNames{i}{j} cell(1,size(xlsWriter,2)-1)];
                xlsWriter(strcmp(xlsWriter(:,1),rowNames{i}{j}),find(strcmp(xlsWriter(1,:),prots{i}))) = {curData(j)};
            end
        end
    end
    xlsWriter(find(cellfun(@isempty,xlsWriter))) = {nan};
    
    xlswrite([outputFolder '\Summary Table.xlsx'],xlsWriter);
        
        
    
end