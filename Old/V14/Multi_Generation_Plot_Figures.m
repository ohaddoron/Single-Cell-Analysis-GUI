function Multi_Generation_Plot_Figures ( folderPath, parTD , parBG, par1 , par2, Arrange,Spars )
    if ~isempty(par1) && ~isempty(par2) 
        par1 = cat(2,par1,'Velocity_X');
        par2 = cat(2,par2,'Velocity_Y');
        Ax_Parameter_Correlation = Parameter_Correlation_Time_Dependency_Maps (folderPath , par1 , par2, Arrange );

    end
    if ~isempty(parTD)
        scale.choice = 1;
        [~,Ax_Time_Dependency] = Time_Dependency_Maps(folderPath,parTD,scale,Arrange,0);

    end
    if ~isempty(parBG)
        MG.Spars = Spars;
        Bar_Graph_Maps(folderPath,parBG,Arrange,0,MG,parTD,Ax_Time_Dependency,par1,par2,Ax_Parameter_Correlation);

    end   
    close all;
end

    