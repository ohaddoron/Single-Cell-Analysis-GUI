function Plot_Parameter_Histogram ( folderPaths , par , normalize , outputLocation)


for k = 1 : numel(folderPaths)
    folderPath = folderPaths{k};
    files = dir(fullfile(folderPath,'*.mat'));
    disp(['opening ' folderPath]);
    num_of_mat_files = numel(files);
    outPath = fullfile(folderPath,'Histograms');
    mkdir(outPath);
    for i = 1 : num_of_mat_files
        filePath = fullfile(folderPath,files(i).name);
        disp(['loading ' files(i).name])
        temp = load(filePath);
        name = fieldnames(temp);
        At = temp.(name{1});

        for j = 1 : numel(par)
            if i == 1
                graphs_data.(par{j}) = [];
            end
            data = At.(par{j})(:);
            if normalize ~= 0
                data = (data-nanmean(data))/(nanstd(data));
            end

            graphs_data.(par{j}) = padconcatenation(graphs_data.(par{j}),data,2);
        end
    end

    for j = 1 : numel(par)

        ttl = [];
        h = [];
        counts = [];
        centers = [];
        mkdir(fullfile(outPath,strrep(par{j},'_',' '),'Images'));
        for i = 1 : num_of_mat_files

            [cur_counts,cur_centers] = hist(graphs_data.(par{j})(:,i),-2:0.05:4);
            cur_counts = cur_counts/sum(~isnan(graphs_data.(par{j})(:,i))) * 100;
            counts = [counts; cur_counts];
            centers = [centers; cur_centers];
            ttl{i} = strrep(strrep(files(i).name([12:14 19:end]),'NNN0',''),'.mat','');
    %         title(ttl{i});
    %         ylabel('# of occurrences');
    %         xlabel([strrep(par{j},'_',' ') ' ' Units(par{j})]);
    %         ax(i) = gca;

    %         caxis([min(graphs_data.(par{j}){i}(:)) max(graphs_data.(par{j}){i}(:))/4])
    %         c = [c; caxis];
        end
        handler(k,j) = figure('Visible','off');
        imagesc(counts);
        set(gca,'YTick',1:numel(ttl),'YTickLabel',ttl);
        colormap(jet);
        b = colorbar;
        c = mean(centers(:,get(gca,'XTick')));
        set(gca,'XTickLabel',round(c,2));
        xlabel('Bin #');
        xlabel(b,'# of occurrences');
        title(strrep(par{j},'_',' '));
%         saveas(handler(k),fullfile(outPath,strrep(par{j},'_',' '),'Summary'));
%         saveas(handler(k),fullfile(outPath,strrep(par{j},'_',' '),'Images','Summary.tiff'));

        handler2(k,j) = figure('Visible','Off');
        plot(centers',counts');
        title(strrep(par{j},'_',' '));
        xlabel([strrep(par{j},'_',' ') ' ' Units(par{j})]);
        ylabel('# of occurrences');
        legend(ttl);
%         saveas(h,fullfile(outPath,strrep(par{j},'_',' '),'Overlay'));
%         saveas(h,fullfile(outPath,strrep(par{j},'_',' '),'Images','Overlay.tiff'));
        ax.(par{j}) = gca;



    end




    for j = 1 : numel(par)
        ttl = [];
        mkdir(fullfile(outPath,strrep(par{j},'_',' '),'Images'));
        for i = 1 : num_of_mat_files
            h = figure('Visible','off');
            histogram(graphs_data.(par{j})(:,i),-5:0.05:5,'Normalization','pdf');
            ttl{i} = strrep(strrep(files(i).name([12:14 19:end]),'NNN0',''),'.mat','');
            title(ttl{i});
            ylabel('# of occurrences');
            xlabel([strrep(par{j},'_',' ') ' ' Units(par{j})]);
            axis([ax.(par{j}).XLim ax.(par{j}).YLim]);
%             caxis([min(graphs_data.(par{j}){i}(:)) max(graphs_data.(par{j}){i}(:))/4])
%             c = [c; caxis];
            linkaxes([ax.(par{j}),gca],'xy')
        end

        for i = 1 : num_of_mat_files
            set(0, 'CurrentFigure', h(i))
    %         caxis([min(c(:,1)) max(c(:,2))]);
            saveas(h(i),fullfile(outPath,strrep(par{j},'_',' '),ttl{i}));
            saveas(h(i),fullfile(outPath,strrep(par{j},'_',' '),'Images',[ttl{i} '.tiff']));
        end
    end
end

for k = 1 : numel(handler)
    cax{j} = [];
    for j = 1 : numel(par)
        cax{j} = [cax{j}; handler(k,j).CurrentAxes.CLim];
    end
end
if numel(folderPaths) == 1 
    outputLocation = folderPaths{1};
end
for k = 1 : numel(handler)
    for j = 1 : numel(par)
        if k == 1
            mkdir(fullfile(outputLocation,strrep(par{j},'_',' '),'Images'));
        end
        set(0, 'CurrentFigure', handler(k,j))
        caxis([min(cax{j}(:,1)),max(cax{j}(:,2))]);
        saveas(handler(k),fullfile(outputLocation,strrep(par{j},'_',' '),['Summary - ' num2str(k)]));
        saveas(handler(k),fullfile(outputLocation,strrep(par{j},'_',' '),'Images',['Summary - ' num2str(k) '.tiff']));
    end
end


for k = 1 : numel(handler2)
    axx{j} = [];
    axy{j} = [];
    for j = 1 : numel(par)

        axx{j} = [axx{j}; handler2(k,j).CurrentAxes.XLim];
        axy{j} = [axy{j}; handler2(k,j).CurrentAxes.YLim];
        
    end
end
if numel(folderPaths) == 1 
    outputLocation = folderPaths{1};
end
for k = 1 : numel(handler)
    for j = 1 : numel(par)
        if k == 1
            mkdir(fullfile(outputLocation,strrep(par{j},'_',' '),'Images'));
        end
        set(0, 'CurrentFigure', handler(k,j))
        axis([min(axx{j}(:,1)),max(axx{j}(:,2)) min(axy{j}(:,1)),max(axy{j}(:,2))]);
        saveas(handler(k),fullfile(outputLocation,strrep(par{j},'_',' '),['Overlay - ' num2str(k)]));
        saveas(handler(k),fullfile(outputLocation,strrep(par{j},'_',' '),'Images',['Overylay - ' num2str(k) '.tiff']));
    end
end


    
close all;



