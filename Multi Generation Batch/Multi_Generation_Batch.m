function Multi_Generation_Batch ( inputFolders, outputFolders ,Spars, normalize , ND, User_Defined_Num_Of_Groups,intensityDecision)

%% Loading parameters
    addpath(genpath(pwd));
    try
        load('Control.mat');
    catch
        errordlg('No control file was found. Please create a control file and try again');
        error('No Control file was found');
    end
    try
        verStr = strcat('Version ',Control.Version,' - ',Control.Version_Date);
    catch
        errordlg('Version not found in the control file. Please input version');
        error('Version not found');
    end
    try
        PPTsPath = Control.Location_of_PPT_Templates;
    catch
        errordlg('Power Point templates path not found in the control file. Please input path');
        error('Power Point template path not found');
    end
    tmpfiles = dir([PPTsPath '\*.pptx']);
    if isempty(tmpfiles)
       errordlg('No power point templates were found in the specified path');
       error('No power point templates were found in the specified path'); 
    end
    rmpath(genpath(pwd));
    parTD = Control.time_dependency_parameters;
    parBG = Control.bar_graph_parameters;
    par1 = cat(2,Control.par1_1_parameters,Control.par1_2_parameters);
    par2 = Control.par2_1_parameters;
    
    
    parSummaryTable = Control.summary_table_parameters;
    
%     clear('Control');
        
%% Gathering experiments
    for n = 1 : numel(inputFolders)
        GatherExps ( inputFolders{n} , outputFolders{n})
        disp('Finished gathering experiments');
    end
%% Ploting figures
    Arrange.choice = 1;
    for n = 1 : numel(outputFolders)
        if intensityDecision(n) ~= 0
            parTD = [parTD Control.intensity_parameters];
            parBG = [parBG Control.intensity_parameters];
        end
        if normalize(n) ~= 0
            norm_par = unique([parTD, parBG, par1, par2]);
            normalized_graphs (outputFolders{n},norm_par,1,0)
            folderPath = fullfile(outputFolders{n},'Normalized');
        else
            folderPath = fullfile(outputFolders{n});
        end
        Multi_Generation_Plot_Figures ( folderPath, parTD , parBG, par1 , par2, Arrange,Spars )
        parTD = Control.time_dependency_parameters;
        parBG = Control.bar_graph_parameters;
        disp('Finished plotting figures');
    end
%% PCA + Cluster
    clear folderPath
    for n = 1 : numel(outputFolders)
        if normalize(n) == 1
            normalized_graphs (outputFolders{n},parSummaryTable,1,0)
            folderPath(1) = fullfile(outputFolders(n),'Normalized');
        else
            folderPath(1) = outputFolders(n);
        end
        if ND == 3
            parSummaryTable = cat(2,parSummaryTable,summary_table_parameters_3D);
        end
        TP.choice = true;
        TP.transpose = true;
        summaryTable(folderPath,parSummaryTable,folderPath{1},TP)
        ClusterAnalysis(fullfile(folderPath{1},'Cluster Analysis'));
        xlsPath = fullfile(folderPath,'Cluster Analysis','Summary Table.xls');
        Cluster( xlsPath{1} , [] , outputFolders{n}, 0 , User_Defined_Num_Of_Groups);
        parSummaryTable = Control.summary_table_parameters;
        disp('Finished PCA + Cluster');
    end
    
    
    
end