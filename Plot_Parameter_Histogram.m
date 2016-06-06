function Plot_Parameter_Histogram ( folderPath , par , normalize )

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
    h = figure('Visible','off');
    imagesc(counts);
    set(gca,'YTick',1:numel(ttl),'YTickLabel',ttl);
    colormap(jet);
    b = colorbar;
    c = mean(centers(:,get(gca,'XTick')));
    set(gca,'XTickLabel',round(c,2));
    xlabel('Bin #');
    xlabel(b,'# of occurrences');
    title(strrep(par{j},'_',' '));
    saveas(h,fullfile(outPath,strrep(par{j},'_',' '),'Summary'));
    saveas(h,fullfile(outPath,strrep(par{j},'_',' '),'Images','Summary.tiff'));
    
    h = figure('Visible','Off');
    plot(centers',counts');
    title(strrep(par{j},'_',' '));
    xlabel([strrep(par{j},'_',' ') ' ' Units(par{j})]);
    ylabel('# of occurrences');
    legend(ttl);
    saveas(h,fullfile(outPath,strrep(par{j},'_',' '),'Overlay'));
    saveas(h,fullfile(outPath,strrep(par{j},'_',' '),'Images','Overlay.tiff'));
    ax.(par{j}) = gca;
    
    
    
end




for j = 1 : numel(par)
    ttl = [];
    h = [];
    mkdir(fullfile(outPath,strrep(par{j},'_',' '),'Images'));
    for i = 1 : num_of_mat_files
        h(i) = figure('Visible','off');
        histogram(graphs_data.(par{j})(:,i),-2:0.05:4,'Normalization','pdf');
        ttl{i} = strrep(strrep(files(i).name([12:14 19:end]),'NNN0',''),'.mat','');
        title(ttl{i});
        ylabel('# of occurrences');
        xlabel([strrep(par{j},'_',' ') ' ' Units(par{j})]);
        axis([ax.(par{j}).XLim ax.(par{j}).YLim]);
%         caxis([min(graphs_data.(par{j}){i}(:)) max(graphs_data.(par{j}){i}(:))/4])
%         c = [c; caxis];
%         linkaxes([ax.(par{j}),gca],'xy')
    end
    
    for i = 1 : num_of_mat_files
        set(0, 'CurrentFigure', h(i))
%         caxis([min(c(:,1)) max(c(:,2))]);
        saveas(h(i),fullfile(outPath,strrep(par{j},'_',' '),ttl{i}));
        saveas(h(i),fullfile(outPath,strrep(par{j},'_',' '),'Images',[ttl{i} '.tiff']));
    end
end
close all;



