close all; clear all; clc;

xlsPath = '\\metlab21\Matlab\Ohad\Yossi\Cluster + PCA\Cluster Analysis\Summary Table.xls';
toPPT('close',1);
[~,~,raw] = xlsread(xlsPath);
data = cell2mat(raw(2:end,2:end))';
V = cov(data);
SD = sqrt(diag(V));
R = V./(SD*SD');
[COEFF,latent,explained] = pcacov(R);

scores = COEFF'*data';
scores = scores';
pars = strrep(raw(2:end,1),'_',' ');
treats = raw(1,2:end);

h = figure('Visible','Off');
biplot(COEFF(:,1:2),'scores',scores(:,1:2),'varlabels',pars,'Obslabels',treats);
ax = gca;
xlabel([ax.XLabel.String ' ' num2str(round(explained(1),2)) '%'])
ylabel([ax.YLabel.String ' ' num2str(round(explained(2),2)) '%'])
title('PCA performed on the correlation matrix');
toPPT(h,'SlideNumber',1);

h = figure('Visible','Off');
pareto(explained);
xlabel('Principal Component');
ylabel('Variance Explained (%)')
toPPT(h,'SlideNumber',1);

data = cell2mat(raw(2:end,2:end))';

Zdata = zscore(data);
[coeff,score,latent,tsquared,explained,mu] = pca(Zdata);
h = figure('Visible','Off');
biplot(COEFF(:,1:2),'scores',scores(:,1:2),'varlabels',pars,'Obslabels',treats);
ax = gca;
xlabel([ax.XLabel.String ' ' num2str(round(explained(1),2)) '%'])
ylabel([ax.YLabel.String ' ' num2str(round(explained(2),2)) '%'])
title('PCA performed after zscore');
toPPT(h,'SlideNumber',2);

h = figure('Visible','Off');
pareto(explained);
xlabel('Principal Component');
ylabel('Variance Explained (%)')
toPPT(h,'SlideNumber',2);

data = cell2mat(raw(2:end,2:end))';
Mdata = data - repmat(nanmean(data),size(data,1),1);
[coeff,score,latent,tsquared,explained,mu] = pca(Mdata);
h = figure;
biplot(COEFF(:,1:2),'scores',scores(:,1:2),'varlabels',pars,'Obslabels',treats);
ax = gca;
xlabel([ax.XLabel.String ' ' num2str(round(explained(1),2)) '%'])
ylabel([ax.YLabel.String ' ' num2str(round(explained(2),2)) '%'])
title('PCA performed after mean substraction');
toPPT(h,'SlideNumber',3);

h = figure('Visible','Off');
pareto(explained);
xlabel('Principal Component');
ylabel('Variance Explained (%)')
toPPT(h,'SlideNumber',3);