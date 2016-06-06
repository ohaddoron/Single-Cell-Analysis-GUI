function ClusterAnalysis(folderPath)

    files = dir([folderPath '\*.xls']);
    numOfXLS = length(files);
    for i = 1 : numOfXLS
        filePath = [folderPath '\' files(i).name];
        [data,text,~] = xlsread(filePath);
        name = strrep(strrep(files(i).name,' ','_'),'.xls','');
        RowLabelsValue = strrep(text(2:end,1),'_',' ');
        ColumnLabelsValue = strrep(text(1,2:end),'_',' ');
        OptimalLeafOrderValue = 'true';
        StandardizeValue = 2;
        CGobj.(name) = clustergram(data,'RowLabels',RowLabelsValue,...
            'ColumnLabels',ColumnLabelsValue,'OptimalLeafOrder',...
            OptimalLeafOrderValue,'Standardize',StandardizeValue);
        HFig(i) = figure('Visible','Off');
        HFig(i) = plot(CGobj.(name));
        saveas(HFig(i),[folderPath '\Image\Clustergram.tiff']);
        saveas(HFig(i),[folderPath '\Clustergram']);
        close all;
        close all hidden;
    end
end