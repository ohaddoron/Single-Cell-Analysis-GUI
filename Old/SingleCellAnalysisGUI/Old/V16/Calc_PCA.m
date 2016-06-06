function h = Calc_PCA (summary_table_path,single,varargin)

switch nargin
    case 3
        m = varargin{1};
    otherwise 
        m = 1;
end


% m is the number of normalization method. 
% If m = 1 then the normalization method is simply substracting the mean.
% if m = 2 then the normalization method is zscore
    [~,~,raw] = xlsread(summary_table_path);
    if nargin >= 2 && single ~= 0
    else
        raw = raw';
    end
    
    names = raw(2:end,1);
    for i = 1 : numel(names)
        names{i} = num2str(names{i});
    end
    categories = strrep(raw(1,2:end),'_',' ');

    ratings = cell2mat(raw(2:end,2:end));
    
    
    h(1) = figure('Visible','Off');
    boxplot(ratings,'orientation','horizontal','labels',categories);
    xlabel('Values');
    set(gca,'XScale','log');
    
    names = names(~any(isnan(ratings),2),:);    
    ratings = ratings(~any(isnan(ratings),2),:);
    w = 1./var(ratings);
    
    switch m
        case 1
            ratings = ratings - repmat(nanmean(ratings),size(ratings,1),1);
        case 2
            ratings = zscore(ratings);
    end
        

    
    
        
    [wcoeff,score,latent,tsquared,explained] = pca(ratings);
    

    c3 = wcoeff(:,1:3);
    
    coefforth = inv(diag(std(ratings)))*wcoeff;
     
    I = c3'*c3;
     
    cscores = zscore(ratings)*coefforth;
     
     
    h(2) = figure('Visible','Off');
    plot(score(:,1),score(:,2),'+');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');
    
    
    h(3) = figure('Visible','Off');
    pareto(explained);
    xlabel('Principal Component');
    ylabel('Variance Explained (%)')
    
    [st2,index] = sort(tsquared,'descend'); % sort in descending order
    extreme = index(1);
    names(extreme,:);
    
    
%     if nargin >= 2 && single ~= 0
%         biplot(coefforth(:,1:2),'scores',score(:,1:2),'varlabels',categories)
%     else
%         biplot(coefforth(:,1:2),'scores',score(:,1:2),'varlabels',categories,'ObsLabels',names);
%     end
    
    h(4) = figure('Visible','on');
    biplot(coefforth(:,1:2),'scores',score(:,1:2),'varlabels',categories,'ObsLabels',names);
%     contrib = [];
%     for i = 1 : size(score,2)
%         cur_contrib = [];
%         for j = 1 : size(wcoeff,2)
%             cur_contrib = cat(1,cur_contrib,dot(score(:,i),wcoeff(:,j)));
%         end
%         contrib = cat(2,contrib,cur_contrib);
%     end
    
    
   
    %axis([-.26 0.6 -.51 .51]);
    
end

     