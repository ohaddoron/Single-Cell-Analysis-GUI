function SunPlot (folderPath)


    warning('off','all');
    graphs_data.plot_data = {};
    graphs_data.cell_count = [];
    graphs_data.plot_handlers = {};
    graphs_data.names = {};
    graphs_data.title = {};
    tint = 45;
    files = dir([folderPath '\*.mat']);
    
    num_of_mat_files = length(files);
    
    for i = 1 : num_of_mat_files
        file_path = [folderPath '\' files(i).name];
         
        disp(['loading file ' files(i).name]);
        
        temp = load(file_path);
        name = fieldnames(temp);
        At = temp.(name{1});
        graphs_data.title{i} = [files(i).name(1:9) ' ' strrep(files(i).name(10:29),'NNN0','')];
        
        x_Pos = At.x_Pos;
        y_Pos = At.y_Pos;
        
        [numOfRows,numOfCols]=size(x_Pos);
        
        cur_graph_data = [];
        
        for ii=1 : numOfCols
            if (sum(~isnan(x_Pos(:,ii)),1))
                % getting index of first number (and not NaN)
                idx_first = find(sum(~isnan(x_Pos(:,ii)),1) > 0, 1 ,'first');
                
                % setting first point to (0,0)
                temp = x_Pos(idx_first:numOfRows,ii);
                cur_cell_points.x = temp - temp(1);

                temp = y_Pos(idx_first:numOfRows,ii);
                cur_cell_points.y = temp - temp(1);
                
                cur_cell_points.time = (1 : size(cur_cell_points.x))*tint;
                
                cur_cell_points.time(isnan(cur_cell_points.x)) = [];
                
                cur_cell_points.x=cur_cell_points.x(isfinite(cur_cell_points.x));
                cur_cell_points.y=cur_cell_points.y(isfinite(cur_cell_points.y));
                if ~isempty(cur_cell_points.x)
                    cur_graph_data = [cur_graph_data [cur_cell_points.x'; cur_cell_points.y'; cur_cell_points.time]];
                end
            end
        end
        [~, num_of_cells] = size(cur_graph_data);
        graphs_data.plot_data{i} = cur_graph_data;
        graphs_data.cell_count = [graphs_data.cell_count num_of_cells];
        end;

        [~,num_of_graphs] = size(graphs_data.cell_count);

        min_cell_count = min(graphs_data.cell_count);
        
        mkdir(folderPath,'SunPlot new\Images');
        
        for i=1:num_of_graphs
             cur_graph_data = graphs_data.plot_data{i};
             cur_cell_count = graphs_data.cell_count(i);
             cur_graph_name = graphs_data.title{i};
             
             random_permutation = randperm(cur_cell_count);
        
             selected_cells_indices = random_permutation(1:min_cell_count);
             
             
             x = cur_graph_data(1,1:min_cell_count);
             y = cur_graph_data(2,1:min_cell_count);
             z = zeros(size(x));
             col = cur_graph_data(3,1:min_cell_count);
             handler = figure('Visible','Off');
             %handler = figure;
             colormap jet;
             surface([x;x],[y;y],[z;z],[col;col],...
                'facecol','no',...
                'edgecol','interp',...
                'linew',1);
             %title(['num of cells: ' num2str(min_cell_count)]);
            hb = colorbar;
            xlabel(hb,'Time [min]');
            axis([-250 250 -250 250]);
            title(cur_graph_name, 'interpreter','none');
            xlabel('X Position [\mum]');
            ylabel('Y Position [\mum]');        
            hold off;

            saveas(handler ,[folderPath '\SunPlot new\Images\' cur_graph_name],'tiff');
            saveas(handler, [folderPath '\SunPlot new\' cur_graph_name]);
        end;
        warning ('on','all');
        disp('Done!');
end
         
