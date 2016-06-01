function FWHM ( varargin )


    warning('Off','all');
    folderPath = varargin{1};
    par = varargin{2};
    
    if nargin >= 3
        Arrange = varargin{3};
    end
    
    
%     I row - FWHM
%     II row - End Time
%     III row - Height of maximum
%     IV row - Time of maximum
    disp(['opening folder ' folderPath]);

    files = dir([folderPath '\*.mat']);
    
    num_of_mat_files = numel(files);
    labels = cell(1,num_of_mat_files);
    % Average
    for i = 1 : num_of_mat_files
        disp(['loading file ' files(i).name]);
        filePath = [folderPath '\' files(i).name];
        temp = load(filePath);
        
        labels{i} = strrep(strrep(files(i).name,'NNN0',''),'.mat','');
        
        name = fieldnames(temp);
        At = temp.(name{1});
        
        for j = 1 : numel(par)
            
            if i == 1
                graphs_data.(par{j}) = nan(4,num_of_mat_files);
            end
            
            curMean = nanmean(At.(par{j}),2);
            time = (0:numel(curMean)-1)*At.dt;
            
            
            [maxVal,maxIdx] = nanmax(curMean);
            
            firstIdx = time(curMean(1:maxIdx) <= maxVal/2);
            endIdx = time(curMean(maxIdx:end) <= maxVal/2);
            
            if ~isempty(endIdx) && ~isempty(firstIdx)
                FWHM = endIdx(1) - firstIdx(end);
            end
            if isempty(firstIdx) && ~isempty(endIdx)
                FWHM = 2 * abs(maxIdx - endIdx(1));
                firstIdx = nan;
            end
            
            if isempty(endIdx) && ~isempty(firstIdx)
                FWHM = 2 * abs(maxIdx - firstIdx(end));
                endIdx = nan;
            end
            
            if sum(~isnan(endIdx)) == 0 && sum(~isnan(firstIdx)) == 0
                FWHM = nan;
            end
            
            graphs_data.(par{j})(1,i) = FWHM;
            if ~isempty(endIdx)
                graphs_data.(par{j})(2,i) = endIdx(1);
            else
                graphs_data.(par{j})(2,i) = nan;
            end
            graphs_data.(par{j})(3,i) = maxVal;
            graphs_data.(par{j})(4,i) = maxIdx * At.dt;
        end
    end
    mkdir([folderPath '\FWHM\Average\Image']);
    mkdir([folderPath '\End Time\Average\Image']);
    mkdir([folderPath '\Height of maximum\Average\Image']);
    mkdir([folderPath '\Time of maximum\Average\Image']);
    for j = 1 : numel(par)
        if nargin >=3 && Arrange.choice ~= 0 
            graphs_data.(par{j}) = Rearrange_bar_graph(graphs_data.(par{j}),labels,Arrange.list);
            labelstmp = labels;
            labels = Arrange.list;
        end
        % I FWHM

        h = figure('Visible','Off');

        bar(1:size((graphs_data.(par{j})),2),graphs_data.(par{j})(1,:))

        title(['Full Width Half Maximum - ' strrep(par{j},'_',' ')]);
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel('\Delta Time [min]');

        saveas(h,[folderPath '\FWHM\Average\Image' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\FWHM\Average\' strrep(par{j},'_',' ')],'fig');

        % II End Time

        h = figure('Visible','Off');

        bar(1:(size((graphs_data.(par{j})),2)),graphs_data.(par{j})(2,:))

        title(['End Time - ' strrep(par{j},'_',' ')]);
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel('Time [min]');

        saveas(h,[folderPath '\End Time\Average\Image' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\End Time\Average\' strrep(par{j},'_',' ')],'fig');

        % III Height of maximum

        h = figure('Visible','Off');

        bar(1:size((graphs_data.(par{j})),2),graphs_data.(par{j})(3,:))

        title(['Height of maximum - ' strrep(par{j},'_',' ')]);
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel(['Height of wave ' Units(par{j})]);

        saveas(h,[folderPath '\Height of maximum\Average\Image\' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\Height of maximum\Average\' strrep(par{j},'_',' ')],'fig');

        % IV Time of maximum


        h = figure('Visible','Off');

        bar(1:size((graphs_data.(par{j})),2),graphs_data.(par{j})(4,:))

        title(['Time of maximum - ' strrep(par{j},'_',' ')]);
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel('Time [min]');

        saveas(h,[folderPath '\Time of maximum\Average\Image\' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\Time of maximum\Average\' strrep(par{j},'_',' ')],'fig');

    end
    if nargin >=3 && Arrange.choice == 1
        labels = labelstmp;
    end
    close all
    % Single Cell
    for i = 1 : num_of_mat_files
        
        filePath = [folderPath '\' files(i).name];
        temp = load(filePath);
        
        labels{i} = strrep(strrep(files(i).name,'NNN0',''),'.mat','');
        
        name = fieldnames(temp);
        At = temp.(name{1});    
        for j = 1 : numel(par)
            
            if i == 1
                graphs_data.(par{j}) = nan(4,num_of_mat_files);
                graphs_error.(par{j}) = nan(4,num_of_mat_files);
                graphs_anova.(par{j}).FWHM = [];
                graphs_anova.(par{j}).endIdx = [];
                graphs_anova.(par{j}).maxVal = [];
                graphs_anova.(par{j}).maxIdx = [];
            end
            
            time = (0:size(At.(par{j}),1)-1)*At.dt;
            [max,idx] = nanmax(At.(par{j}),[],1);
            maxVal = nanmean(max);
            maxIdx = nanmean(idx);
            firstIdx = nan(1,size(At.(par{j}),2));
            endIdx = nan(1,size(At.(par{j}),2));
            under = bsxfun(@lt,At.(par{j}),max/2);
            for ii = 1 : size(under,2)
                if ~isempty(time(find(under(1:idx,ii),1,'last')))
                    firstIdx(ii) = time(find(under(1:idx,ii),1,'last'));
                else
                    firstIdx(ii) = nan;
                end
                try
                    if ~isempty(time(numel(1:idx) + find(under(idx:end,ii),1,'first')-1))
                        under(1:idx,ii) = 0;
                        endIdx(ii) = time(find(under(:,ii) ,1,'first'));
                    else
                        endIdx(ii) = nan;
                    end
                catch
                    a = 1;
                end
            end
            FWHM = (endIdx - firstIdx)';
            
                
            graphs_anova.(par{j}).FWHM = padconcatenation(FWHM,graphs_anova.(par{j}).FWHM,2);
            graphs_anova.(par{j}).endIdx = padconcatenation(endIdx',graphs_anova.(par{j}).endIdx,2);
            graphs_anova.(par{j}).maxVal = padconcatenation(max',graphs_anova.(par{j}).maxVal,2);
            graphs_anova.(par{j}).maxIdx = padconcatenation(idx',graphs_anova.(par{j}).maxIdx,2);
            

            graphs_error.(par{j})(1,i) = nanstd(FWHM)./(sum(~isnan(FWHM).^0.5));
            graphs_error.(par{j})(2,i) = nanstd(endIdx)./(sum(~isnan(endIdx).^0.5));
            graphs_error.(par{j})(3,i) = nanstd(max)./(sum(~isnan(max).^0.5));
            graphs_error.(par{j})(4,i) = nanstd(idx * At.dt)./(sum(~isnan(idx * At.dt).^0.5));

%             graphs_error.(par{j})(1,i) = nanstd(FWHM);
%             graphs_error.(par{j})(2,i) = nanstd(endIdx);
%             graphs_error.(par{j})(3,i) = nanstd(max);
%             graphs_error.(par{j})(4,i) = nanstd(idx * At.dt);
            
            FWHM = nanmean(endIdx - firstIdx);
            %firstIdx = nanmean(firstIdx);
            endIdx = nanmean(endIdx);
            
           
            
            
            graphs_data.(par{j})(1,i) = FWHM;
            graphs_data.(par{j})(2,i) = endIdx;
            graphs_data.(par{j})(3,i) = maxVal;
            graphs_data.(par{j})(4,i) = maxIdx * At.dt;    
            
        end
    end
    
    
    
    mkdir([folderPath '\FWHM\Single cell\Image']);
    mkdir([folderPath '\End Time\Single cell\Image']);
    mkdir([folderPath '\Height of maximum\Single cell\Image']);
    mkdir([folderPath '\Time of maximum\Single cell\Image']);
    for j = 1 : numel(par)
        if nargin >=3 && Arrange.choice ==1 
            graphs_data.(par{j}) = Rearrange_bar_graph(graphs_data.(par{j}),labels,Arrange.list);
            graphs_error.(par{j}) = Rearrange_bar_graph(graphs_error.(par{j}),labels,Arrange.list);
            graphs_anova.(par{j}) = Rearrange_bar_graph(graphs_anova.(par{j}),labels,Arrange.list);
            labels = Arrange.list;
        end
        % I FWHM
        
        
        
        h = figure('Visible','Off');
        X = 1:size((graphs_data.(par{j})),2);
        
        hold all;
        
        bar(X,graphs_data.(par{j})(1,:))
        errorbar(X,graphs_data.(par{j})(1,:),graphs_error.(par{j})(1,:));
        
        
        title(['Full Width Half Maximum - ' strrep(par{j},'_',' ')]);
        set(gca,'XTick',1:length(labels));
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel('\Delta Time [min]');
        
        
        [p,tbl,stats] = anova1(graphs_anova.(par{j}).FWHM,labels,'off');
        if p <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p);
        end
        text(0.9,1,['p value = ' Pvalue],'Units','normalized')
        
        
        saveas(h,[folderPath '\FWHM\Single cell\Image\' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\FWHM\Single cell\' strrep(par{j},'_',' ')],'fig');
        
        % II End Time
        
        h = figure('Visible','Off');
        
        hold all;
        
        bar(1:(size((graphs_data.(par{j})),2)),graphs_data.(par{j})(2,:))
        errorbar(X,graphs_data.(par{j})(2,:),graphs_error.(par{j})(2,:));
        
        title(['End Time - ' strrep(par{j},'_',' ')]);
        set(gca,'XTick',1:length(labels));
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel('Time [min]');
        
        [p,tbl,stats] = anova1(graphs_anova.(par{j}).endIdx,labels,'off');
        if p <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p);
        end
        text(0.9,1,['p value = ' Pvalue],'Units','normalized')
        
        saveas(h,[folderPath '\End Time\Single cell\Image\' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\End Time\Single cell\' strrep(par{j},'_',' ')],'fig');
        
        % III Height of maximum
        
        h = figure('Visible','Off');
        
        hold all;
        
         bar(1:size((graphs_data.(par{j})),2),graphs_data.(par{j})(3,:))
        errorbar(X,graphs_data.(par{j})(3,:),graphs_error.(par{j})(3,:));
        
        title(['Height of maximum - ' strrep(par{j},'_',' ')]);
        set(gca,'XTick',1:length(labels));
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel(['Height of wave ' Units(par{j})]);
        
        [p,tbl,stats] = anova1(graphs_anova.(par{j}).maxVal,labels,'off');
        if p <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p);
        end
        text(0.9,1,['p value = ' Pvalue],'Units','normalized')
        
        saveas(h,[folderPath '\Height of maximum\Single cell\Image\' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\Height of maximum\Single cell\' strrep(par{j},'_',' ')],'fig');
        
        % IV Time of maximum
        
        
        h = figure('Visible','Off');
        
        hold all;
        
        bar(1:size((graphs_data.(par{j})),2),graphs_data.(par{j})(4,:))
        errorbar(X,graphs_data.(par{j})(4,:),graphs_error.(par{j})(4,:));
        
        title(['Time of maximum - ' strrep(par{j},'_',' ')]);
        set(gca,'XTick',1:length(labels));
        set(gca,'XTickLabel',labels);
        set(gca,'XTickLabelRotation',45);
        xlabel('Treatment');
        ylabel('Time [min]');
        
        [p,tbl,stats] = anova1(graphs_anova.(par{j}).maxIdx,labels,'off');
        if p <= 1e-5
            Pvalue = '0.00001';
        else
            Pvalue = num2str(p);
        end
        text(0.9,1,['p value = ' Pvalue],'Units','normalized')
        
        saveas(h,[folderPath '\Time of maximum\Single cell\Image\' strrep(par{j},'_',' ')],'tiff');
        saveas(h,[folderPath '\Time of maximum\Single cell\' strrep(par{j},'_',' ')],'fig');
        
    end
    close all
end
        

function newData = Rearrange_bar_graph(data,curArr,newArr)
    
    newData = [];
    for i = 1 : length(newArr)
        newData = [newData data(:,strcmp(curArr,newArr(i)))];
    end
end

        
        
    
            
            
            
        
        