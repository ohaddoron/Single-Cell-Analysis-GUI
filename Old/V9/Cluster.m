function Cluster ( xlsPath , folderPath , outputLocation )


    close all force;
    imPath = [outputLocation '\Figures\Images'];
    figPath = [outputLocation '\Figures'];
    mkdir(imPath);
    
    
    warning('off','all');
    
    %% Slide 1
    toPPT('close',1);
    path = '\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters';
    files = dir([path '\*.pptx']);
    IndexC = strfind({files.name}, 'PCA + Cluster');
    Index = find(not(cellfun('isempty', IndexC)));
    toPPT('openExisting',[path '\' files(Index).name]);
    toPPT('setTitle','Title');
    toPPT(outputLocation,'setBullets',0,'TeX',0)
    
    SlideNumber = 2;
    
    %% General 
    
    try
        [~,~,raw] = xlsread(xlsPath);
    catch
        xlsPath = [xlsPath 'x'];
        [~,~,raw] = xlsread(xlsPath);
    end
    
    raw = raw';
    treats = raw(2:end,1);
    pars = raw(1,2:end);
    data = cell2mat(raw(2:end,2:end));
    nanIndices = any(isnan(data),2);
    data(nanIndices) = [];
    treats(nanIndices) = [];
    
    
    MPars = {'Area','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y'...
        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate',...
        'Sphericity','Eccentricity'};
    KPars = {'Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2'...
        'Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression'...
        ,'Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD'...
        ,'Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X'	'Velocity_Y'};
    

    %% Slide 2
    
    
    h = figure('Visible','Off');
    
    boxplot(data);
    ax = gca;
    ax.XTickLabel = strrep(pars,'_',' ');
    ax.XTickLabelRotation = 90;
    ax.YScale = 'log';
    ylabel('Value - log scale');
    xlabel('Parameter');
    title('Mean value for each parameter');
    
    saveas(h,[imPath '\Mean value for each parameter.tiff']);
    savefig(h,[figPath '\Mean value for each parameter.fig']);
    
    toPPT(h,'SlideNumber',SlideNumber);
    
    
    data = zscore(data);
    h = figure('Visible','Off');
    boxplot(data);
    set(gca,'XTickLabel',strrep(pars,'_',' '));
    set(gca,'XTickLabelRotation',90);
    
    ylabel('Value');
    xlabel('Parameter');
    title('Zscore value for each parameter');
    toPPT(h,'SlideNumber',SlideNumber);
    
    saveas(h,[imPath '\ZScore value for each parameter.tiff']);
    savefig(h,[figPath '\ZScore value for each parameter.fig']);
    
   
    
    h = Calc_PCA (xlsPath);
    toPPT(h(1),'SlideNumber',SlideNumber);
    toPPT(h(2),'SlideNumber',SlideNumber);
    toPPT(h(3),'SlideNumber',SlideNumber);
    toPPT(h(4),'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;
    
    saveas(h(1),[imPath '\PCA fig 1.tiff']);
    savefig(h(1),[figPath '\PCA fig 1.fig']);
    
    saveas(h(2),[imPath '\PCA fig 2.tiff']);
    savefig(h(2),[figPath '\PCA fig 2.fig']);
    
    saveas(h(3),[imPath '\PCA fig 3.tiff']);
    savefig(h(3),[figPath '\PCA fig 3.fig']);
    
    saveas(h(4),[imPath '\PCA fig 4.tiff']);
    savefig(h(4),[figPath '\PCA fig 4.fig']);
    
    
    
    %% Slide 3
    
    StandardizeValue = 0;
    CGobj = clustergram(data,'RowLabels',treats,...
                                            'ColumnLabels',pars,'Standardize',StandardizeValue);
    
    plot(CGobj);
    h = gcf;
    toPPT(h,'SlideNumber',SlideNumber);
    SlideNumber = SlideNumber + 1;     
    
    
    
    %% Slide 4
    
    
    for num_of_groups = 4 : 8
        corrDist = pdist(data, 'corr');
        clusterTree = linkage(corrDist, 'average');
        clusters = cluster(clusterTree, 'maxclust', num_of_groups);
        
        h = figure('Visible','Off');
        for c = 1:num_of_groups
            subplot(4,2,c);
            plot(1:numel(pars),data((clusters == c),:)');
            ax = gca;
            if c == num_of_groups
                ax.XTick = 1: numel(pars);
                ax.XTickLabel = strrep(pars,'_',' ');
                ax.XTickLabelRotation = 90;

            else
                ax.XTick = [];
                ax.YTick = [];
            end
            axis tight
            axis off;
        end
        suptitle('Hierarchical Clustering of Profiles');
        xlabel('Parameters');
        set(h,'position',get(0,'screensize'),'Visible','Off')
        rng('default');
        toPPT(h,'SlideNumber',SlideNumber);
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups)]);
        
        saveas(h,[imPath '\Hierarchical Clustering of Profiles - ' num2str(num_of_groups) ' groups.tiff']);
        savefig(h,[figPath '\Hierarchical Clustering of Profiles - ' num2str(num_of_groups) ' groups.fig']);
        
        [cidx, ctrs] = kmeans(data, num_of_groups, 'dist','corr', 'rep',5,...
                                                                'disp','final');
        h = figure('Visible','Off');
        for c = 1:num_of_groups
            subplot(4,2,c);
            plot(1:numel(pars),data((cidx == c),:)');
            ax = gca;
            if c == num_of_groups
                ax.XTick = 1: numel(pars);
                ax.XTickLabel = strrep(pars,'_',' ');
                ax.XTickLabelRotation = 90;
                axis tight
            else
                ax.XTick = [];
                ax.YTick = [];
            end
            axis tight
            axis off;
        end
        suptitle('K-Means Clustering of Profiles');
        xlabel('Parameters');
        set(h,'position',get(0,'screensize'),'Visible','Off')
        toPPT(h,'SlideNumber',SlideNumber);
        saveas(h,[imPath '\K-Means Clustering of Profiles - ' num2str(num_of_groups) ' groups.tiff']);
        savefig(h,[figPath '\K-Means Clustering of Profiles - ' num2str(num_of_groups) ' groups.fig']);
        
        
        [pc, zscores, pcvars] = pca(data);
        perc = pcvars./sum(pcvars) * 100;
        pcclusters = clusterdata(zscores(:,1:2),'maxclust',num_of_groups,'linkage','av');
        
        h = figure('Visible','Off');
        for c = 1:num_of_groups
            subplot(4,2,c);
            plot(1:numel(pars),data((pcclusters == c),:)');
            ax = gca;
            if c == num_of_groups
                ax.XTick = 1: numel(pars);
                ax.XTickLabel = strrep(pars,'_',' ');
                ax.XTickLabelRotation = 90;
                axis tight
            else
                ax.XTick = [];
                ax.YTick = [];
            end
            axis tight
            axis off
        end
        suptitle('Averages by cluster group');
        xlabel('Parameters');
        set(h,'position',get(0,'screensize'),'Visible','Off')
        toPPT(h,'SlideNumber',SlideNumber);
        saveas(h,[imPath '\Averages by cluster group - ' num2str(num_of_groups) ' groups.tiff']);
        savefig(h,[figPath '\Averages by cluster group - ' num2str(num_of_groups) ' groups.fig']);
        SlideNumber = SlideNumber + 1;
        %% Slide 5
        
        h = figure('Visible','Off');
        for c = 1:num_of_groups
            subplot(4,2,c);
            plot(1:numel(pars),ctrs(c,:)');
            ax = gca;
            if c == num_of_groups
                ax.XTick = 1: numel(pars);
                ax.XTickLabel = strrep(pars,'_',' ');
                ax.XTickLabelRotation = 90;
                axis tight
            else
                ax.XTick = [];
                ax.YTick = [];
            end
            axis tight
            axis off    % turn off the axis
        end
        
        
        suptitle('K-Means Clustering of Profiles (centroids)');
        xlabel('Parameters');
        set(h,'position',get(0,'screensize'),'Visible','Off')
        toPPT(h,'SlideNumber',SlideNumber);
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups)]);
        
        
        
        clear newData
        clear newError
        for c = 1 : num_of_groups
            try
                newData = [newData; nanmean(abs(data(cidx==c,:)),1)];
                newError = [newError; nanstd(abs(data(cidx == c,:)),0,1)];
            catch
                newData = nanmean(abs(data(cidx == c,:)),1);
                newError = nanstd(abs(data(cidx == c,:)),0,1);
            end
        end
        clear newDataM;
        clear newDataK;
        clear newErrorM
        clear newErrorK
        for k = 1 : numel(MPars)
            try
                newDataM = [newDataM newData(:,strcmp(pars,MPars{k}))];
                newErrorM = [newErrorM newError(:,strcmp(pars,MPars{k}))];
            catch
                newDataM = newData(:,strcmp(pars,MPars{k}));
                newErrorM = newError(:,strcmp(pars,MPars{k}));
            end
        end
        for k = 1 : numel(KPars)
            try
                newDataK = [newDataK newData(:,strcmp(pars,KPars{k}))];
                newErrorK = [newErrorK newError(:,strcmp(pars,KPars{k}))];
            catch
                newDataK = newData(:,strcmp(pars,KPars{k}));
                newErrorK = newError(:,strcmp(pars,KPars{k}));
            end
        end
        VM = var(newDataM);
        VK = var(newDataK);


        idxM = find(strcmp(MPars,'Area')); 
        VM(idxM) = nan;
        idxK = find(strcmp(KPars,'Velocity'));
        VK(idxK) = nan;
        parNamesM = {'Area'};
        parNamesK = {'Velocity'};
        
        for k = 1 : 4 
            [~,idx] = nanmax(VM);
            parNamesM = [parNamesM MPars(idx)];
            idxM = [idxM idx];
            VM(idx) = nan;
            [~,idx] = nanmax(VK);
            parNamesK = [parNamesK KPars(idx)];
            VK(idx) = nan;
            idxK = [idxK idx];
        end
        
        errorbar_groups(newDataK(:,idxK)',newErrorK(:,idxK)')
        h = gcf;
        legend(strrep(parNamesK,'_',' '),'Location','NorthWestOutside');
        title('K-Means Clustering groups');
        toPPT(h,'SlideNumber',SlideNumber);
        
        errorbar_groups(newDataM(:,idxM)',newErrorM(:,idxM)')
        h = gcf;

        legend(strrep(parNamesM,'_',' '),'Location','NorthWestOutside');
        title('K-Means Clustering groups');

        toPPT(h,'SlideNumber',SlideNumber);
        
        
        figure('Visible','Off');
        silhouette(data,pcclusters,'s');
        h = gca;
        h.Children.EdgeColor = [.8 .8 1];
        xlabel 'Silhouette Value';
        ylabel 'Cluster';
        title('Silhouette default');
        set(gca,'XLim',[-1,1]);
        toPPT(gcf,'SlideNumber',SlideNumber);
        
        
        idx4 = kmeans(data,num_of_groups, 'Distance','sqeuclidean');
        figure('Visible','Off');
        [silh4,h] = silhouette(data,idx4,'s');
        h = gca;
        h.Children.EdgeColor = [.8 .8 1];
        xlabel 'Silhouette Value';
        ylabel 'Cluster';
        title('Silhouette k-means');
        set(gca,'XLim',[-1,1]);
        toPPT(gcf,'SlideNumber',SlideNumber);
        
        h = figure('Visible','Off');
        gscatter(zscores(:,1),zscores(:,2),pcclusters)
        xlabel(['First Principal Component ' num2str(perc(1)) '%']);
        ylabel(['Second Principal Component ' num2str(perc(2)) '%']);
        title('Principal Component Scatter Plot with Colored Clusters default');
        toPPT(h,'SlideNumber',SlideNumber);
        
        h = figure('Visible','Off');
        gscatter(zscores(:,1),zscores(:,2),idx4)
        xlabel(['First Principal Component ' num2str(perc(1)) '%']);
        ylabel(['Second Principal Component ' num2str(perc(2)) '%']);
        title('Principal Component Scatter Plot with Colored Clusters k-means');
        toPPT(h,'SlideNumber',SlideNumber);
        
        SlideNumber = SlideNumber + 1;
        
        P = zscores(:,1:2)';
        net = newsom(P,[4 4]);
        net = train(net,P);
        h = figure('Visible','Off');
        plot(P(1,:),P(2,:),'.g','markersize',20)
        hold on
        plotsom(net.iw{1,1},net.layers{1}.distances)
        hold off
        net = newsom(P,[4 4]);
        toPPT(h,'SlideNumber',SlideNumber);
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups)]);
        
        distances = dist(P',net.IW{1}');
        [d,cndx] = min(distances,[],2);
        % cndx gives the cluster index

        h = figure('Visible','Off');
        gscatter(P(1,:),P(2,:),cndx); legend off;
        hold on
        plotsom(net.iw{1,1},net.layers{1}.distances);
        hold off
        toPPT(h,'SlideNumber',SlideNumber);
        SlideNumber = SlideNumber + 1;
        
        
        len = 0;
        for c = 1 : num_of_groups
            len = max([len, sum(pcclusters == c)]);
        end


         close all force
        for c = 1 : num_of_groups
            curTreat = treats(pcclusters == c);
            if c == 1
                expID = curTreat;
            end
            if size(expID,1) < size(curTreat,1)
                expID = [expID; cell(size(curTreat,1) - size(expID,1), size(expID,2))];
            end
            if size(expID,1) > size(curTreat,1)
                curTreat = [curTreat; cell(abs(size(curTreat,1) - size(expID,1)), size(curTreat,2))];
            end
            if c ~= 1
                expID = [expID curTreat];
            end
        end
        
        for n = 1 : size(expID,2)
            
            curExpID = expID(:,n);
            cellType = cellfun(@(x) x(19:22),curExpID(cellfun('length',curExpID) > 1),'un',0);
            treatType = strrep(strrep(cellfun(@(x) x(23:end),curExpID(cellfun('length',curExpID) > 1),'un',0),'NNN0',''),'-','');
            cellType = [cellType; cell(numel(curExpID)-numel(cellType),1)];
            treatType = [treatType; cell(numel(curExpID)-numel(treatType),1)];
            
            
            val = cellfun(@(x) numel(x),treatType);
            newTreatType = cell(numel(cellType),max(val)/4);
            for k = 1 : numel(treatType)
                idx = 1;
                for kk = 1 : numel(treatType{k})/4
                    newTreatType{k,kk} = treatType{k}(idx:idx+3);
                    idx = idx + 4;
                end
            end
            
            treatType = newTreatType;
                
            
            try
                newExpID = [newExpID curExpID cellType treatType];
            catch
                newExpID =  [curExpID cellType treatType];
            end
        end
        expID = newExpID;
        xlswrite([outputLocation '\PCA and Cluster groups with ' num2str(num_of_groups) ' groups'] ,expID);
        close all force;
    end
    
    savePath = outputLocation;
    saveFilename = 'PCA and cluster';
    toPPT('savePath',savePath,'saveFilename',saveFilename);
    toPPT('close',1);
            
                
    
        
    
    
        

end

        
    
    
    
    