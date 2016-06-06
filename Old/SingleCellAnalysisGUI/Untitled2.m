[~,~,raw] = xlsread('D:\Matlab\Ohad\Yossi\Cluster + PCA\Cluster Analysis\Summary Table.xls');
raw = raw';
categories = strrep(raw(1,2:end),'_',' ');

data = cell2mat(raw(2:end,2:end));


V = cov(data);
SD = sqrt(diag(V));
R = V./(SD*SD');


[COEFF,latent,explained] = pcacov(R);
biplot(COEFF(:,1:2),'varlabels',categories)

 