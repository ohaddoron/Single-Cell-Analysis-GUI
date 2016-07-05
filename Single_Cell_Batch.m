function Single_Cell_Batch (folderPaths,outputLocations , normalize , par)

% Single Cell Time Dependency
for k = 1 : numel(folderPaths)
    Single_Cell_Time_Dependency ( folderPaths{k} , par , 1 , num_of_cells, outputLocations{k})
end
% Single Cell Histograms
for k = 1 : numel(folderPaths)
    Plot_Parameter_Histogram ( folderPaths{k} , par , normalize(k) , outputLocations{k})
end
% Single Cell Cluster + PCA
for k = 1 : numel(folderPaths)
    files = dir(fullfile(folderPaths{k},'*.mat'));
    for i = 1 : numel(files)
        summary_table_single_cell( file_path, outputLocations{k}, par );
    end
end

        