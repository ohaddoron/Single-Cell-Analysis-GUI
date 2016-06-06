function Multi_Generation_Plot_Figures ( folderPath, parTD , parBG, par1 , par2, Arrange,Spars )
    if ~isempty(par1) && ~isempty(par2) 
        par1 = cat(2,par1,'Velocity_X','EllipsoidAxisLengthB');
        par2 = cat(2,par2,'Velocity_Y','EllipsoidAxisLengthC');
        Ax_Parameter_Correlation = Parameter_Correlation_Time_Dependency_Maps (folderPath , par1 , par2, Arrange );
%         close all;

    end
    if ~isempty(parTD)
        scale.choice = 1;
        [~,Ax_Time_Dependency] = Time_Dependency_Maps(folderPath,parTD,scale,Arrange,0);
%         close all;

    end
    if ~isempty(parBG)
        MG.Spars = Spars;
        Bar_Graph_Maps(folderPath,parBG,Arrange,0,MG,parTD,Ax_Time_Dependency,par1,par2,Ax_Parameter_Correlation);
%         close all;

    end 
    for i = 1 : numel(MG.Spars)
        if strcmp(MG.Spars{i},'CON')
            cur_folderPath = fullfile(folderPath,'Control');
        else
            cur_folderPath = fullfile(folderPath,MG.Spars{i});
        end
        files = dir(fullfile(cur_folderPath,'*.mat'));
        if ~isempty(files)
            Arrange.choice = 1;
            concat = 0;
            Time_Dependency_Maps(cur_folderPath,parTD,scale,Arrange,concat,Ax_Time_Dependency);
            Parameter_Correlation_Time_Dependency_Maps (cur_folderPath , par1 , par2 , Arrange,Ax_Parameter_Correlation);
            delete(fullfile(cur_folderPath,'*.mat'));
%             close all;
        end
    end
    
    
end

    