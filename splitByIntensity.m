close all; clear all; clc;

folderPath = '\\metlab21\MATLAB\Dganit Yael\DS296\Multi';
files = dir(fullfile(folderPath,'*.mat'));

num_of_mat_files = numel(files);
CH1edges = [0 60 300 inf];
CH2edges = [0 40 100 inf];
Data = cell(3,3);
labels = cell(3,3);
for i = 1 : num_of_mat_files
    disp(['Opening file : ' files(i).name]);
    filePath = fullfile(folderPath,files(i).name);
    
    temp = load(filePath);
    name = fieldnames(temp);
    At = temp.(name{1});
    
    CH1data = nanmean(At.IntensityMeanCh1(:));
    CH2data = nanmean(At.IntensityMeanCh2(:));
    
    discCH1 = discretize(CH1data,CH1edges);
    discCH2 = discretize(CH2data,CH2edges);
    
    Data{discCH1,discCH2} = cat(1,Data{discCH1,discCH2},(nanmean(At.Velocity,2)'));
    labels{discCH1,discCH2} = cat(1,labels{discCH1,discCH2},{strrep(strrep(files(i).name([12:14 19:end]),'NNN0',''),'.mat','')});
end


for i = 1 : size(Data,1)
    for j = 1 : size(Data,2)
        curData = Data{i,j};
        curLabels = labels{i,j};
        if ~isempty(curData);
            figure;
            imagesc(curData);
            colormap(jet);
%             axis off;
            title([num2str(i) ' - ' num2str(j)]);
            set(gca,'YTick',1:size(curData,1),'YTickLabel',curLabels);
            b = colorbar;
            xlabel(b,'Velocity');
            
        end
    end
end

    
    
    


