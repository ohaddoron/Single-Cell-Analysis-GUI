function handler = MC_Sun_plot_for_multiple_3D( folder_path )
    
    graphs_data.plot_data = {};
    graphs_data.cell_count = [];
    graphs_data.min_x = [];
    graphs_data.min_y = [];
    graphs_data.min_z = [];
    graphs_data.max_x = [];
    graphs_data.max_y = [];
    graphs_data.max_z = [];
    graphs_data.plot_handlers = {};
    graphs_data.names = {};
    graphs_data.title = {};



    % opening folder and getting mat files
    disp(['opening folder ' folder_path]);
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    
    for i=1:num_of_mat_files 
        file_path = [folder_path '\' files(i).name];
         
        disp(['loading file ' files(i).name]);
        
        temp = load(file_path);
        true_name = files(i).name;
        name = fieldnames(temp);
        data_struct = temp.(name{1});
        data_struct.name = true_name;
        graphs_data.names{i} = data_struct.name;
        graphs_data.title{i} = strrep([files(i).name(1:9) strrep(files(i).name(10:length(files(i).name)),'NNN0','')],'.mat','');
        x_Pos = data_struct.x_Pos;
        y_Pos = data_struct.y_Pos;
        z_Pos = data_struct.z_Pos;
        
        [numOfRows,numOfCols]=size(x_Pos);
        
        cur_graph_data = [];
        
        for j=1:numOfCols            
            if (sum(~isnan(x_Pos(:,j)),1))
                % getting index of first number (and not NaN)
                idx_first = find(sum(~isnan(x_Pos(:,j)),1) > 0, 1 ,'first');
                
                % setting first point to (0,0)
                temp = x_Pos(idx_first:numOfRows,j);
                cur_cell_points.x = temp - temp(1);

                temp = y_Pos(idx_first:numOfRows,j);
                cur_cell_points.y = temp - temp(1);
                
                temp = x_Pos(idx_first:numOfRows,j);
                cur_cell_points.z = temp - temp(1);

                
                %removing NaNs
                cur_cell_points.x=cur_cell_points.x(isfinite(cur_cell_points.x));
                cur_cell_points.y=cur_cell_points.y(isfinite(cur_cell_points.y));
                cur_cell_points.z=cur_cell_points.z(isfinite(cur_cell_points.z));
                
                if ~isempty(cur_cell_points.x)              
                    cur_graph_data = [cur_graph_data cur_cell_points];
                end
                
            end;
        end;
        [~, firstIdxs] = max(~isnan(x_Pos));
        [~,d] = meshgrid(1:size(x_Pos,1),diag(x_Pos(firstIdxs,1:size(x_Pos,2))));
        d = d';
        tmpx = x_Pos - d;
        [~, firstIdxs] = max(~isnan(y_Pos));
        [~,d] = meshgrid(1:size(y_Pos,1),diag(y_Pos(firstIdxs,1:size(y_Pos,2))));
        d = d';
        tmpy = y_Pos - d;
        [~, firstIdxs] = max(~isnan(z_Pos));
        [~,d] = meshgrid(1:size(z_Pos,1),diag(z_Pos(firstIdxs,1:size(z_Pos,2))));
        d = d';
        tmpz = z_Pos - d;
        
        graphs_data.min_x = [graphs_data.min_x nanmin(tmpx)];
        graphs_data.min_y = [graphs_data.min_y nanmin(tmpy)];
        graphs_data.min_z = [graphs_data.min_z nanmin(tmpz)];
        graphs_data.max_x = [graphs_data.max_x nanmax(tmpx)];
        graphs_data.max_y = [graphs_data.max_y nanmax(tmpy)];
        graphs_data.min_z = [graphs_data.min_z nanmax(tmpz)];
        
        [~, num_of_cells] = size(cur_graph_data);
                
        graphs_data.plot_data{i} = cur_graph_data;
        graphs_data.cell_count = [graphs_data.cell_count num_of_cells];
        
    end;

    [~,num_of_graphs] = size(graphs_data.cell_count);

    min_cell_count = min(graphs_data.cell_count);
    cmap = hsv(min_cell_count);  %# Creates a numOfCols-by-3 set of colors from the HSV colormap
    
    mkdir(folder_path,'SunPlot\Images');
    %mkdir(folder_path,'SunPlot\Figs');

    
    for i=1:num_of_graphs
         cur_graph_data = graphs_data.plot_data{i};
         cur_cell_count = graphs_data.cell_count(i);
         cur_graph_name = graphs_data.title{i};
         
         random_permutation = randperm(cur_cell_count);
        
        selected_cells_indices = random_permutation(1:min_cell_count);
        
        handler(i) = figure('Visible','Off');
        %handler = figure(i);
        hold on;
        Ax = max([abs(mean(graphs_data.min_x)-4*std(graphs_data.min_x)),...
                abs((mean(graphs_data.max_x)+4*std(graphs_data.max_x))),...
                abs((mean(graphs_data.min_y)-4*std(graphs_data.min_y))),...
                abs((mean(graphs_data.max_y)+4*std(graphs_data.max_y)))]);
        for j=1:min_cell_count
            x = cur_graph_data(selected_cells_indices(j)).x;
            y = cur_graph_data(selected_cells_indices(j)).y;
            z = cur_graph_data(selected_cells_indices(j)).z;
            axis([-Ax Ax -Ax Ax -Ax Ax]);
            
            cur_plot_handler = plot3(x,y,z,'Color',cmap(j,:));
        end;
        %title(['num of cells: ' num2str(min_cell_count)]);
        title(cur_graph_name, 'interpreter','none','FontSize',16);
        xlabel('X Position [\mum]');
        ylabel('Y Position [\mum]');     
        zlabel('Z Position [\mum]');
        hold off;        
        view(3);
        saveas(handler(i) ,[folder_path '\SunPlot\Images\' cur_graph_name],'tif');
        saveas(handler(i) ,[folder_path '\SunPlot\' cur_graph_name]);
        close all;
        
    end;
    
    disp('Done!');
    %close all;
end

