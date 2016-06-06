function h = correlation_map ( xlsPath )

[data,text] = xlsread(xlsPath);
text = strrep(text,'_',' ');
for i = 1 : size(text,1)
    for j = 1 : size(text,2)
        text{i,j} = num2str(text{i,j});
    end
end

[rho,pval] = corr(data,data);
h(1) = figure('Visible','Off');
colormap hot;
pval(pval >= 0.05) = 0.05;

imagesc(rho);
colorbar;
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'FontSize',6,'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end),'FontSize',6);
title('Correlation map treatments');
h(2) = figure('Visible','Off');
cmap = colormap(hot);
colormap(flipud(cmap));

imagesc(pval);
colorbar; 
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'FontSize',6,'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end),'FontSize',6);
title('p values treatments');

data = data';
text = text';
[rho,pval] = corr(data,data);
h(3) = figure('Visible','Off');
colormap hot;
pval(pval >= 0.05) = 0.05;


imagesc(rho);
title('Correlation map parameters');

colorbar;
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end));
h(4) = figure('Visible','Off');

cmap = colormap(hot);
colormap(flipud(cmap));

imagesc(pval);
title('p values parameters');
colorbar; 
set(gca,'XTick',1:size(data,2),'XTickLabel',text(1,2:end),'XTickLabelRotation',90,...
    'YTick',1:size(data,2),'YTickLabel',text(1,2:end));


