function Cluster( xlsPath , folderPath , outputLocation, single,User_Defined_Num_Of_Groups )


    
    
    warning('off','all');
    toPPT('close',1);
    path = '\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\PPTMasters';
    files = dir([path '\*.pptx']);
    IndexC = strfind({files.name}, 'PCA + Cluster');
    Index = find(not(cellfun('isempty', IndexC)));
    toPPT('openExisting',[path '\' files(Index).name]);
    toPPT('setTitle','Title');
    toPPT(outputLocation,'setBullets',0,'TeX',0)
    
    SlideNumber = 2;
    %%
    outputLocationtmp = outputLocation;
    outputLocation = [outputLocation '\Substruct mean'];
    imPath = [outputLocation '\Figures\Images'];
    figPath = [outputLocation '\Figures'];
    mkdir(imPath);
    try
        [~,~,raw] = xlsread(xlsPath);
    catch
        xlsPath = [xlsPath 'x'];
        [~,~,raw] = xlsread(xlsPath);
    end
    
    if nargin >= 4 && single ~= 0
        
        treats = raw(2:end,1);
        pars = raw(1,2:end);
        data = cell2mat(raw(2:end,2:end));
        treats = treats(~any(isnan(data),2),:);
        data = data(~any(isnan(data),2),:);
        
    else
        raw = raw';
        treats = raw(2:end,1);
        pars = raw(1,2:end);
        data = cell2mat(raw(2:end,2:end));
%         nanIndices = any(isnan(data),2);
        [~,c] = find(isnan(data));
        data(:,c) = [];
        pars(:,c) = [];
    end
    
    MPars = {'Area','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y'...
        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate',...
        'Sphericity','Eccentricity'};
    KPars = {'Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2'...
        'Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression'...
        ,'Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD'...
        ,'Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X'	'Velocity_Y'};
    

    

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

%     data = data - repmat(nanmean(data),size(data,1),1);
%     data = zscore(data);

    h = figure('Visible','Off');
    boxplot(zscore(data));
    set(gca,'XTickLabel',strrep(pars,'_',' '));
    set(gca,'XTickLabelRotation',90);

    ylabel('Value');
    xlabel('Parameter');
    title('Zscore value for each parameter');
    toPPT(h,'SlideNumber',SlideNumber);

    saveas(h,[imPath '\ZScore value for each parameter.tiff']);
    savefig(h,[figPath '\ZScore value for each parameter.fig']);



    h = Calc_PCA (xlsPath,single,1);
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
    
    for i = 1 : numel(h)
        close(h(i));
    end

    StandardizeValue = 0;
    try
        CGobj = clustergram(zscore(data),'ColumnLabels',pars,'RowLabels',treats,'Standardize',StandardizeValue);
    catch
        treats = cellstr(num2str(cell2mat(treats)));
        CGobj = clustergram(zscore(data),'ColumnLabels',pars,'RowLabels',treats,'Standardize',StandardizeValue);
    end
    

    plot(CGobj);
    h_cluster = gcf;
    set(gca,'FontSize',5);
    set(h_cluster,'position',get(0,'screensize'))
    saveas(h_cluster,[imPath '\Clustergram.tiff']);
    savefig(h_cluster,[figPath '\Clustergram.fig']);
    
    toPPT(h_cluster,'SlideNumber',SlideNumber);
    close(h_cluster)
    RowLabels = get(CGobj, 'RowLabels');
    xlswrite(fullfile(outputLocation,'Clustergram row names'),RowLabels);
    SlideNumber = SlideNumber + 1;    


    data = data - repmat(nanmean(data),size(data,1),1);
    if single == 0
        eva = evalclusters(data,'kmeans','Gap','KList',1:15,'ReferenceDistribution','PCA');
    else
        eva.OptimalK = 15;
    end
    
    num_of_groups = cat(2,eva.OptimalK,User_Defined_Num_Of_Groups);
    for mn = 1 : numel(num_of_groups)
        corrDist = pdist(data, 'corr');
        clusterTree = linkage(corrDist, 'average');
        clusters = cluster(clusterTree, 'maxclust', num_of_groups(mn));

        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),data((clusters == c),:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups(mn))]);

        saveas(h,[imPath '\Hierarchical Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.tiff']);
        savefig(h,[figPath '\Hierarchical Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.fig']);

        [cidx, ctrs] = kmeans(data, num_of_groups(mn), 'dist','corr', 'rep',5,...
                                                                'disp','final');
        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),data((cidx == c),:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        saveas(h,[imPath '\K-Means Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.tiff']);
        savefig(h,[figPath '\K-Means Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.fig']);


        [pc, zscores, pcvars] = pca(data);
        perc = pcvars./sum(pcvars) * 100;
        pcclusters{mn} = clusterdata(zscores(:,1:2),'maxclust',num_of_groups(mn),'linkage','av');

        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),data((pcclusters{mn} == c),:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        saveas(h,[imPath '\Averages by cluster group - ' num2str(num_of_groups(mn)) ' groups.tiff']);
        savefig(h,[figPath '\Averages by cluster group - ' num2str(num_of_groups(mn)) ' groups.fig']);
        SlideNumber = SlideNumber + 1;


        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),ctrs(c,:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups(mn))]);



        clear newData
        clear newError
        for c = 1 : num_of_groups(mn)
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
        try
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
        catch
        end
        


        figure('Visible','Off');
        silhouette(data,pcclusters{mn},'s');
        h = gca;
        h.Children.EdgeColor = [.8 .8 1];
        xlabel 'Silhouette Value';
        ylabel 'Cluster';
        title('Silhouette default');
        set(gca,'XLim',[-1,1]);
        toPPT(gcf,'SlideNumber',SlideNumber);


        idx4 = kmeans(data,num_of_groups(mn), 'Distance','sqeuclidean');
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
        gscatter(zscores(:,1),zscores(:,2),pcclusters{mn})
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
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups(mn))]);

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
    end



    h = correlation_map ( xlsPath );

    toPPT(h(1),'SlideNumber',SlideNumber);
    saveas(h(1),[imPath '\' h(1).CurrentAxes.Title.String '.tiff'])
    savefig(h(1),[figPath '\' h(1).CurrentAxes.Title.String]);

    toPPT(h(2),'SlideNumber',SlideNumber);
    saveas(h(2),[imPath '\' h(2).CurrentAxes.Title.String '.tiff'])
    savefig(h(2),[figPath '\' h(2).CurrentAxes.Title.String]);


    SlideNumber = SlideNumber + 1;

    toPPT(h(3),'SlideNumber',SlideNumber);
    saveas(h(3),[imPath '\' h(3).CurrentAxes.Title.String '.tiff'])
    savefig(h(3),[figPath '\' h(3).CurrentAxes.Title.String]);

    toPPT(h(4),'SlideNumber',SlideNumber);
    saveas(h(4),[imPath '\' h(4).CurrentAxes.Title.String '.tiff'])
    savefig(h(4),[figPath '\' h(4).CurrentAxes.Title.String]);

    SlideNumber = SlideNumber + 1;


    try
        for mn = 1 : numel(num_of_groups)
            len = 0;
            for c = 1 : num_of_groups(mn)
                len = max([len, sum(pcclusters{mn} == c)]);
            end


             close all force
            for c = 1 : num_of_groups(mn)
                curTreat = treats(pcclusters{mn} == c);
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

            ClusterGroup = [];
            ClusterGroupIdx = [];
            for k = 1 : size(expID,2)
                curCluster = expID(:,k);
                idx = find(cellfun(@isempty,curCluster));
                curCluster(idx) = [];
                ClusterGroupIdx = [ClusterGroupIdx; repmat(k,length(curCluster),1)];
                ClusterGroup = [ClusterGroup; curCluster];
            end
            ClusterGroupIdx = num2cell(ClusterGroupIdx);
            ClusterGroup = [ClusterGroupIdx ClusterGroup];
            Names = ClusterGroup(:,2);
            cellLine = cellfun(@(x) x(19:22),Names(cellfun('length',Names) > 1),'un',0);
            ClusterGroup = [ClusterGroup cellLine];
            treatType = strrep(strrep(cellfun(@(x) x(23:end-4),Names(cellfun('length',Names) > 1),'un',0),'NNN0',''),'-','');
            val = cellfun(@(x) numel(x),treatType);
            cellType = cellfun(@(x) x(19:22),Names(cellfun('length',Names) > 1),'un',0);
            newTreatType = cell(numel(cellType),max(val)/4);
            for k = 1 : numel(treatType)
                idx = 1;
                for kk = 1 : numel(treatType{k})/4
                    newTreatType{k,kk} = treatType{k}(idx:idx+3);
                    idx = idx + 4;
                end
            end

            treatType = newTreatType;

            ClusterGroup = [ClusterGroup treatType];
            ClusterGroup = [ClusterGroup cellfun(@(x) x(end-3:end),Names(cellfun('length',Names) > 1),'un',0)];
            xlswrite(fullfile(outputLocation,['Excel for pivot table ' num2str(num_of_groups(mn)) ' groups.xlsx']),ClusterGroup)


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
            xlswrite(fullfile(outputLocation,['PCA and Cluster groups with ' num2str(num_of_groups(mn)) ' groups']) ,expID);
            close all force;


        end
    catch
    end
    outputLocation = outputLocationtmp;
    
    %%
    
    outputLocationtmp = outputLocation;
    outputLocation = [outputLocation '\ZScore'];
    imPath = [outputLocation '\Figures\Images'];
    figPath = [outputLocation '\Figures'];
    mkdir(imPath);
    try
        [~,~,raw] = xlsread(xlsPath);
    catch
        xlsPath = [xlsPath 'x'];
        [~,~,raw] = xlsread(xlsPath);
    end
    
    if nargin >= 4 && single ~= 0
        
        treats = raw(2:end,1);
        pars = raw(1,2:end);
        data = cell2mat(raw(2:end,2:end));
        data = data(~any(isnan(data),2),:);
    else
        raw = raw';
        treats = raw(2:end,1);
        pars = raw(1,2:end);
        data = cell2mat(raw(2:end,2:end));
%         nanIndices = any(isnan(data),2);
        [~,c] = find(isnan(data));
        data(:,c) = [];
        pars(:,c) = [];
    end
    
    MPars = {'Area','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y'...
        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate',...
        'Sphericity','Eccentricity'};
    KPars = {'Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2'...
        'Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression'...
        ,'Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD'...
        ,'Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X'	'Velocity_Y'};
    

    

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

%     data = data - repmat(nanmean(data),size(data,1),1);
%     data = zscore(data);

    h = figure('Visible','Off');
    boxplot(zscore(data));
    set(gca,'XTickLabel',strrep(pars,'_',' '));
    set(gca,'XTickLabelRotation',90);

    ylabel('Value');
    xlabel('Parameter');
    title('Zscore value for each parameter');
    toPPT(h,'SlideNumber',SlideNumber);

    saveas(h,[imPath '\ZScore value for each parameter.tiff']);
    savefig(h,[figPath '\ZScore value for each parameter.fig']);



    h = Calc_PCA (xlsPath,single,2);
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







    
    plot(CGobj);
    h_cluster = gcf;
    set(gca,'FontSize',5);
    set(h_cluster,'position',get(0,'screensize'))
    saveas(h_cluster,[imPath '\Clustergram.tiff']);
    savefig(h_cluster,[figPath '\Clustergram.fig']);
    set(gca,'FontSize',5);
    toPPT(h_cluster,'SlideNumber',SlideNumber);
    close(h_cluster)
    RowLabels = flipud(get(CGobj,'RowLabels'));
    xlswrite(fullfile(outputLocation,'Clustergram row names'),RowLabels);
    SlideNumber = SlideNumber + 1;    


    data = zscore(data);
    eva = evalclusters(data,'kmeans','Gap','KList',1:15,'ReferenceDistribution','PCA');

    num_of_groups = cat(2,eva.OptimalK,User_Defined_Num_Of_Groups);
    for mn = 1 : numel(num_of_groups)
        corrDist = pdist(data, 'corr');
        clusterTree = linkage(corrDist, 'average');
        clusters = cluster(clusterTree, 'maxclust', num_of_groups(mn));

        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),data((clusters == c),:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups(mn))]);

        saveas(h,[imPath '\Hierarchical Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.tiff']);
        savefig(h,[figPath '\Hierarchical Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.fig']);

        [cidx, ctrs] = kmeans(data, num_of_groups(mn), 'dist','corr', 'rep',5,...
                                                                'disp','final');
        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),data((cidx == c),:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        saveas(h,[imPath '\K-Means Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.tiff']);
        savefig(h,[figPath '\K-Means Clustering of Profiles - ' num2str(num_of_groups(mn)) ' groups.fig']);


        [pc, zscores, pcvars] = pca(data);
        perc = pcvars./sum(pcvars) * 100;
        pcclusters{mn} = clusterdata(zscores(:,1:2),'maxclust',num_of_groups(mn),'linkage','av');

        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),data((pcclusters{mn} == c),:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        saveas(h,[imPath '\Averages by cluster group - ' num2str(num_of_groups(mn)) ' groups.tiff']);
        savefig(h,[figPath '\Averages by cluster group - ' num2str(num_of_groups(mn)) ' groups.fig']);
        SlideNumber = SlideNumber + 1;


        h = figure('Visible','Off');
        for c = 1:num_of_groups(mn)
            subplot(5,3,c);
            plot(1:numel(pars),ctrs(c,:)');
            ax = gca;
            if c == num_of_groups(mn)
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
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups(mn))]);



        clear newData
        clear newError
        for c = 1 : num_of_groups(mn)
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
        try
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
        catch
        end


        figure('Visible','Off');
        silhouette(data,pcclusters{mn},'s');
        h = gca;
        h.Children.EdgeColor = [.8 .8 1];
        xlabel 'Silhouette Value';
        ylabel 'Cluster';
        title('Silhouette default');
        set(gca,'XLim',[-1,1]);
        toPPT(gcf,'SlideNumber',SlideNumber);


        idx4 = kmeans(data,num_of_groups(mn), 'Distance','sqeuclidean');
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
        gscatter(zscores(:,1),zscores(:,2),pcclusters{mn})
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
        toPPT('setTitle',['Number of groups: ' num2str(num_of_groups(mn))]);

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
    end



    h = correlation_map ( xlsPath );

    toPPT(h(1),'SlideNumber',SlideNumber);
    saveas(h(1),[imPath '\' h(1).CurrentAxes.Title.String '.tiff'])
    savefig(h(1),[figPath '\' h(1).CurrentAxes.Title.String]);

    toPPT(h(2),'SlideNumber',SlideNumber);
    saveas(h(2),[imPath '\' h(2).CurrentAxes.Title.String '.tiff'])
    savefig(h(2),[figPath '\' h(2).CurrentAxes.Title.String]);


    SlideNumber = SlideNumber + 1;

    toPPT(h(3),'SlideNumber',SlideNumber);
    saveas(h(3),[imPath '\' h(3).CurrentAxes.Title.String '.tiff'])
    savefig(h(3),[figPath '\' h(3).CurrentAxes.Title.String]);

    toPPT(h(4),'SlideNumber',SlideNumber);
    saveas(h(4),[imPath '\' h(4).CurrentAxes.Title.String '.tiff'])
    savefig(h(4),[figPath '\' h(4).CurrentAxes.Title.String]);

    SlideNumber = SlideNumber + 1;



    for mn = 1 : numel(num_of_groups)
        len = 0;
        for c = 1 : num_of_groups(mn)
            len = max([len, sum(pcclusters{mn} == c)]);
        end


         close all force
        for c = 1 : num_of_groups(mn)
            curTreat = treats(pcclusters{mn} == c);
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
ClusterGroup = [];
        ClusterGroupIdx = [];
        for k = 1 : size(expID,2)
            curCluster = expID(:,k);
            idx = find(cellfun(@isempty,curCluster));
            curCluster(idx) = [];
            ClusterGroupIdx = [ClusterGroupIdx; repmat(k,length(curCluster),1)];
            ClusterGroup = [ClusterGroup; curCluster];
        end
        ClusterGroupIdx = num2cell(ClusterGroupIdx);
        ClusterGroup = [ClusterGroupIdx ClusterGroup];
        Names = ClusterGroup(:,2);
        cellLine = cellfun(@(x) x(19:22),Names(cellfun('length',Names) > 1),'un',0);
        ClusterGroup = [ClusterGroup cellLine];
        treatType = strrep(strrep(cellfun(@(x) x(23:end-4),Names(cellfun('length',Names) > 1),'un',0),'NNN0',''),'-','');
        val = cellfun(@(x) numel(x),treatType);
        cellType = cellfun(@(x) x(19:22),Names(cellfun('length',Names) > 1),'un',0);
        newTreatType = cell(numel(cellType),max(val)/4);
        for k = 1 : numel(treatType)
            idx = 1;
            for kk = 1 : numel(treatType{k})/4
                newTreatType{k,kk} = treatType{k}(idx:idx+3);
                idx = idx + 4;
            end
        end

        treatType = newTreatType;
        
        ClusterGroup = [ClusterGroup treatType];
        ClusterGroup = [ClusterGroup cellfun(@(x) x(end-3:end),Names(cellfun('length',Names) > 1),'un',0)];
        xlswrite(fullfile(outputLocation,['Excel for pivot table ' num2str(num_of_groups(mn)) ' groups.xlsx']),ClusterGroup)


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
        xlswrite(fullfile(outputLocation,['PCA and Cluster groups with ' num2str(num_of_groups(mn)) ' groups']) ,expID);
        close all force;

        
    end
    outputLocation = outputLocationtmp;
    savePath = outputLocation;
    saveFilename = 'PCA and cluster';
    toPPT('savePath',savePath,'saveFilename',saveFilename);
    toPPT('close',1);
            
                
    
        
    
    
        

end
