function Color_Box (xlsPath,outputLocation) 

    [data,text] = xlsread(xlsPath);
    h = figure('Visible','Off');
    imagesc(data)
    set(gca,'YTick',1:size(text,1),'YTickLabel',text(2:end,1));
    set(gca,'XTick',1:size(text,2),'XTickLabel',text(1,2:end));
    colormap jet
    colorbar;
    
    for k = 1 : size(data,1)
        curData = data(k,:);
        [~,~,stats] = anova1(curData);
        
    

