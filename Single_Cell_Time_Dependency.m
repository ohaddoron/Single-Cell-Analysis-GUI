function Single_Cell_Time_Dependency ( folderPath , par , sort_y , num_of_cells,outputLocation )

files = dir(fullfile(folderPath,'*.mat'));
disp(['opening ' folderPath]);
num_of_mat_files = numel(files);
outPath = fullfile(outputLocation,'Single Cell Time Dependency');
mkdir(outPath);
for i = 1 : num_of_mat_files
    filePath = fullfile(folderPath,files(i).name);
    disp(['loading ' files(i).name])
    temp = load(filePath);
    name = fieldnames(temp);
    At = temp.(name{1});
    
    for j = 1 : numel(par)
        % Sorting by occurence
        occ = sum(~isnan(At.(par{j})),1);
        [~,idx] = sort(occ,'descend');
        try
            idx = idx(1:num_of_cells);
        catch
            warndlg('Unable to select this many cells');
            idx = idx(1:end);
        end
        data = At.(par{j})(:,idx);
        y_Pos = At.y_Pos(:,idx);
        mean_data = nanmean(data);
        [~,idx] = sort(mean_data,'descend');
        data = data(:,idx);
        data = data';
        y_Pos = y_Pos(:,idx)';
        y_Pos(:,sum(~isnan(data)) == 0 ) = [];
        data(:,sum(~isnan(data)) == 0) = [];
        if sort_y
            [~,idx] = sort(y_Pos,2);
            for k = 1 : size(idx,1)
                data(k,:) = data(k,idx(k,:));
            end
        end
        graphs_data.(par{j}){i} = data;
    end
end

for j = 1 : numel(par)
    c = [];
    ttl = [];
    h = [];
    mkdir(fullfile(outPath,strrep(par{j},'_',' '),'Images'));
    for i = 1 : num_of_mat_files
        h(i) = figure('Visible','off');
        imagesc(graphs_data.(par{j}){i});
        ttl{i} = strrep(strrep(files(i).name([12:14 19:end]),'NNN0',''),'.mat','');
        title(ttl{i});
        xlabel('Time');
        if sort_y
            xlabel('Y Position');
            
        else
            set(gca,'XTickLabel',get(gca,'XTick')*At.dt);
        end
        ylabel('Cell #');
        ax(i) = gca;
        colormap jet;
        b = colorbar;
        xlabel(b,[strrep(par{j},'_',' ') ' ' Units(par{j})]);
        caxis([min(graphs_data.(par{j}){i}(:)) max(graphs_data.(par{j}){i}(:))/4])
        c = [c; caxis];
    end
    for i = 1 : num_of_mat_files
        set(0, 'CurrentFigure', h(i))
        caxis([min(c(:,1)) max(c(:,2))]);
        saveas(h(i),fullfile(outPath,strrep(par{j},'_',' '),ttl{i}));
        saveas(h(i),fullfile(outPath,strrep(par{j},'_',' '),'Images',[ttl{i} '.tiff']));
    end
end
disp('Single Cell Time Dependency - Done!');
        
        
        