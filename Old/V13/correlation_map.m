function correlation_map ( xlsPath )

[data,text] = xlsread(xlsPath);
text = strrep(text,'_',' ');

[rho,pval] = corr(data,data);
h(1) = figure;
colormap hot;

imagesc(rho);
colorbar;
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'FontSize',6,'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end),'FontSize',6);
title('Correlation map');
h(2) = figure;
colormap hot;

imagesc(pval);
colorbar; 
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'FontSize',6,'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end),'FontSize',6);
title('p values');

data = data';
text = text';
[rho,pval] = corr(data,data);
h(3) = figure;
title('Correlation map');
colormap hot;

imagesc(rho);
colorbar;
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end));
h(4) = figure;
title('p values');
colormap hot;

imagesc(pval);
colorbar; 
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end));


