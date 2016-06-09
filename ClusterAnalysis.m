function ClusterAnalysis(folderPath,varargin)

    files = dir([folderPath '\*.xls']);
    if isempty(files)
        files = dir([folderPath '\*.xlsx']);
    end
    numOfXLS = length(files);
    for i = 1 : numOfXLS
        Names = [];
        filePath = [folderPath '\' files(i).name];
        [data,text,~] = xlsread(filePath);
        data = data';
        name = strrep(strrep(files(i).name,' ','_'),'.xls','');
        ColumnLabelsValue = strrep(text(2:end,1),'_',' ');
        RowLabelsValue = strrep(text(1,2:end),'_',' ');
        OptimalLeafOrderValue = 'true';
        StandardizeValue = 0;
%         CGobj.(name) = clustergram(data','RowLabels',RowLabelsValue,...
%             'ColumnLabels',ColumnLabelsValue,'OptimalLeafOrder',...
%             OptimalLeafOrderValue,'Standardize',StandardizeValue);
        CGobj = clustergram(zscore(data),'ColumnLabels',ColumnLabelsValue,'RowLabels',RowLabelsValue,'Standardize',StandardizeValue);
        if nargin > 1
            f = figure;
            h = uicontrol('Position',[20 20 200 40],'String','Continue',...
                          'Callback','uiresume(gcbf)');

            uiwait(gcf); 

            close(f);
        end
        HFig(i) = figure('Visible','Off');
        HFig(i) = plot(CGobj);
        set(HFig(i),'position',get(0,'screensize'))
        saveas(HFig(i),[folderPath '\Image\Clustergram.tiff']);
        saveas(HFig(i),[folderPath '\Clustergram']);
        mkdir(fullfile(folderPath,'Row Names'));
%         xlswrite(fullfile(folderPath,'Row Names','Names'),);
        Names = flipud(CGobj.RowLabels);
        treatType = strrep(strrep(cellfun(@(x) x(23:end-4),Names(cellfun('length',Names) > 1),'un',0),'NNN0',''),'-','');
        val = cellfun(@(x) numel(x),treatType);
        cellType = cellfun(@(x) x(19:22),Names(cellfun('length',Names) > 1),'un',0);
        newTreatType = cell(numel(cellType),max(val)/4);
        for k = 1 : numel(treatType)
            idx = 1;
            for kk = 1 : numel(treatType{k})/4
                newTreatType{k,kk} = treatType{k}(idx:idx+3);
                idx = idx + 4;
            end
        end

        treatType = newTreatType;
        
        Names = [Names cellType treatType cellfun(@(x) x(end-3:end),Names(cellfun('length',Names) > 1),'un',0)];
        xlswrite(fullfile(folderPath,'Row Names','Names'),Names);
        close all;
        close all hidden;
    end
end