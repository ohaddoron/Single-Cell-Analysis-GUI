function IF_ClusterAnalysis(folderPath)

    files = dir([folderPath '\*.xlsx']);
    numOfXLS = length(files);
    mkdir([folderPath '\Clustergram\Image\']);
    for i = 1 : numOfXLS
        filePath = [folderPath '\' files(i).name];
        [data,text,~] = xlsread(filePath);
        RowLabelsValue = strrep(text(2:end,1),'_',' ');
        RowLabelsValue(sum(isnan(data),2)>0,:) = [];
        data(sum(isnan(data),2)>0,:) = [];
        name = strrep(strrep(files(i).name,' ','_'),'.xlsx','');
        
        ColumnLabelsValue = strrep(text(1,2:end),'_',' ');
        OptimalLeafOrderValue = 'true';
        StandardizeValue = 2;
        CGobj.(name) = clustergram(data,'RowLabels',RowLabelsValue,...
            'ColumnLabels',ColumnLabelsValue,'OptimalLeafOrder',...
            OptimalLeafOrderValue,'Standardize',StandardizeValue);
        HFig(i) = figure('Visible','Off');
        HFig(i) = plot(CGobj.(name));
        %set(gcf,'position',get(0,'screensize'))
        saveas(HFig(i),[folderPath '\Clustergram\Image\' strrep(files(i).name,'.xlsx','') ' - Clustergram.tiff']);
        saveas(HFig(i),[folderPath '\Clustergram\' strrep(files(i).name,'.xlsx','') ' - Clustergram']);
        
        close all;
        close all hidden;
    end
    files = dir([folderPath '\Clustergram\*.fig']);
    for i = 1 : length(files)
        h = openfig([folderPath '\Clustergram\' files(i).name]);
        set(h,'position',get(0,'screensize'))
        toPPT('setTitle',strrep(files(i).name,'.fig',''),'SlideNumber','Append');
        toPPT(h,'SlideNumber','Current');
    end
end