function Single_Cell_PCA_Cluster ( folderPath , outputLocation, User_Defined_Num_Of_Groups )

addpath(genpath(pwd));
load('Control.mat');
par = Control.summary_table_parameters;
rmpath(genpath(pwd));

files = dir(fullfile(folderPath,'*.mat'));

disp(['opening folder ' folderPath]);

num_of_mat_files = numel(files);
for i = 1 : num_of_mat_files 
    disp(['loading file ' files(i).name]);
    name = strrep(strrep(files(i).name([12:14 19:end]),'NNN0',''),'.mat','');
    curOutputLocation = fullfile(outputLocation,'Single Cell PCA + Cluster', name);
    mkdir(curOutputLocation);
    filePath = fullfile(folderPath,files(i).name);
    summary_table_single_cell ( filePath, curOutputLocation, par )
    summary_table_path = fullfile(curOutputLocation,'Summary Table Single Cell.xlsx');
    Cluster( summary_table_path , [] , curOutputLocation, 1 ,User_Defined_Num_Of_Groups );
end