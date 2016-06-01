function Calc_PCA (summary_table_path)

    [~,~,raw] = xlsread(summary_table_path);
    
    raw = raw';
    
    names = raw(2:end,1);
    categories = strrep(raw(1,2:end),'_',' ');
    ratings = log(cell2mat(raw(2:end,2:end)));
    
    
    figure()
    boxplot(ratings,'orientation','horizontal','labels',categories);
    xlabel('Values');
    
    w = 1./var(ratings);
    [wcoeff,score,latent,tsquared,explained] = pca(zscore(ratings));

    c3 = wcoeff(:,1:3);
    
    coefforth = inv(diag(std(ratings)))*wcoeff;
     
    I = c3'*c3;
     
    cscores = zscore(ratings)*coefforth;
     
     
    figure()
    plot(score(:,1),score(:,2),'+')
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
    
    
    figure()
    pareto(explained);
    xlabel('Principal Component')
    ylabel('Variance Explained (%)')
    
    [st2,index] = sort(tsquared,'descend'); % sort in descending order
    extreme = index(1);
    names(extreme,:)
    
    figure()
    biplot(coefforth(:,1:2),'scores',score(:,1:2),'varlabels',categories,'ObsLabels',names);
    xlabel(['PC - 1 ' num2str(explained(1)) '%']);
    ylabel(['PC - 2 ' num2str(explained(2)) '%']);
    
   
    %axis([-.26 0.6 -.51 .51]);
    
end

     