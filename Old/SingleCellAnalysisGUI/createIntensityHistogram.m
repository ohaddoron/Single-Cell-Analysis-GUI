folderPath = '\\metlab21\MATLAB\Dganit Yael\DS296\Multi';
files = dir(fullfile(folderPath,'*.mat'));

num_of_mat_files = numel(files);
intCH1 = [];
intCH2 = [];
for i = 1 : num_of_mat_files
    disp(['Opening file : ' files(i).name]);
    filePath = fullfile(folderPath,files(i).name);
    
    temp = load(filePath);
    name = fieldnames(temp);
    At = temp.(name{1});
    
    intCH1 = cat(1,intCH1,At.IntensityMeanCh1(:));
    intCH2 = cat(1,intCH2,At.IntensityMeanCh2(:));
    
end

intCH1(isnan(intCH1)) = [];
intCH2(isnan(intCH2)) = [];

h = figure;
subplot(121)
histogram(intCH1);
title('Channel 1');
line([300 300],[0 3e4]);
line([600 600],[0 3e4]);
subplot(122);
histogram(intCH2);
title('Channel 2');
line([100 100],[0 3e4]);
line([40 40],[0 3e4]);
