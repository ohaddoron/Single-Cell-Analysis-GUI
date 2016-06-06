function handler = scatter_plot_position_2_time_3D_multiple_par(varargin)
    

    folder_path = varargin{1};
    par = varargin{2};
    l = varargin{3};
    scale = varargin{4};
    
    
    switch nargin
        case 5
            scatterDecision = varargin{5};
    end
    graphs_data.plot_data = {};
    graphs_data.cell_count = [];
    graphs_data.plot_handlers = {};
    graphs_data.names = {};
    graphs_data.title = {};
    
    
    mkdir([folder_path '\Maps\Images']);
    % opening folder and getting mat files
    disp(['opening folder ' folder_path]);
    files = dir([folder_path '\*.mat']);
    num_of_mat_files = length(files);
    for i=1:num_of_mat_files
        disp(['loading file ' files(i).name]);
        for j = 1:length(par)
            if i == 1
                mkdir([folder_path '\Maps\' par{j}])
                mkdir([folder_path '\Maps\Images\' par{j}])
            end
            file_path = [folder_path '\' files(i).name];
            temp = load(file_path);
            name = fieldnames(temp);
            data_struct = temp.(name{1});
            tint = data_struct.dt;
            data_struct.name = name{1};
            graphs_data.names{i} = files(i).name;
            graphs_data.plot_data.y_Pos{i} = data_struct.y_Pos;
            graphs_data.plot_data.x_Pos{i} = data_struct.x_Pos;
            if nargin >= 5
                if scatterDecision ~= 0
                    graphs_data.plot_data.Ry{i} = data_struct.Ry;
                    graphs_data.plot_data.Rx{i} = data_struct.Rx;
                end
            end
            graphs_data.plot_data.y_Pos{i}(graphs_data.plot_data.y_Pos{i}<0) = nan;
            data_struct.(par{j})(data_struct.(par{j})>l(j)) = l(j);
            data_struct.(par{j})(data_struct.(par{j})<-l(j)) = -l(j);
            if strcmp(par{j},'Coll')
                data_struct.(par{j})(data_struct.(par{j})<0) = 0;
            end
            graphs_data.plot_data.(par{j}){i} = data_struct.(par{j});
            graphs_data.title.(par{j}){i} = [strrep(strrep(strrep(graphs_data.names{i},'NNN0',''),'.mat',''),'_',' ') ' ' strrep(par{j},'_',' ')];
            
        end
    end
    for i = 1 : num_of_mat_files
        [Row,Col] = size(graphs_data.plot_data.y_Pos{i});
        
        for j = 1 : length(par)
            t = (0:Row-1) *tint;
            [time,~] = meshgrid(t,1:Col);
            time = time';
            handler.(par{j})(i) = figure('Visible','Off');
            %handler.(par{j})(i) = figure;
            colormap jet
            time = time(:);
            
            
            if nargin >= 5
                if scatterDecision ~= 0
                    try                      
                        %graphs_data.plot_data.y_Pos{i} = sqrt((graphs_data.plot_data.y_Pos{i} - repmat(graphs_data.plot_data.Ry{i},1,size(graphs_data.plot_data.y_Pos{i},2))).^2 + ...
                        %    (graphs_data.plot_data.x_Pos{i} - repmat(graphs_data.plot_data.Rx{i},1,size(graphs_data.plot_data.x_Pos{i},2))).^2);
                        graphs_data.plot_data.y_Pos{i} = sqrt((graphs_data.plot_data.y_Pos{i} - graphs_data.plot_data.Ry{i}(1)).^2 + ...
                            (graphs_data.plot_data.x_Pos{i} - graphs_data.plot_data.Rx{i}(1)).^2);
                    catch
                        graphs_data.plot_data.y_Pos{i} = graphs_data.plot_data.y_Pos{i};
                    end
                end
            
            end
            graphs_data.plot_data.y_Pos{i} = graphs_data.plot_data.y_Pos{i}(:);
            graphs_data.plot_data.(par{j}){i} = graphs_data.plot_data.(par{j}){i}(:);
            time(isnan(graphs_data.plot_data.(par{j}){i})) = [];
            x = graphs_data.plot_data.y_Pos{i};
            y = graphs_data.plot_data.(par{j}){i};
            x(isnan(graphs_data.plot_data.(par{j}){i})) = [];
            y(isnan(graphs_data.plot_data.(par{j}){i})) = [];
            
            scatter(time,x,50,y,'filled');
            h_colorbar = colorbar;
            xlabel(h_colorbar,[strrep(par{j},'_',' ') ' ' Units(par{j})]);
            xlabel('Time [min]');
            ylabel('Y Position [\mum]');
            if nargin >= 5
                if scatterDecision ~= 0 
                    ylabel('Distance from center of mass [\mum]');
                end
            end
            title(graphs_data.title.(par{j}){i},'FontSize',16);
            if scale.choice(1) == 1 && scale.choice(2) == 1
                axis([0 max(max(t)) 0 1])
                axis('manual','auto y');
            end
            if scale.choice(1) == 1 && scale.choice(2) == 0
                axis([0 max(max(t)) scale.Ax(3) scale.Ax(4)]);
            end
            if scale.choice(1) == 0 && scale.choice(2) == 1
                axis([scale.Ax(1) scale.Ax(2) 0 1]);
                axis('manual','auto y');
            end
            if scale.choice(1) == 0 && scale.choice(2) == 0
                axis(scale.Ax);
            end
            F = getframe(handler.(par{j})(i));
%             imwrite(F.cdata,[folder_path '\Maps\Images\' par{j} '\' graphs_data.title.(par{j}){i} '.tiff']);
            saveas(handler.(par{j})(i) ,[folder_path '\Maps\' par{j} '\' graphs_data.title.(par{j}){i}]);    
            saveas(handler.(par{j})(i) ,[folder_path '\Maps\Images\' par{j} '\' graphs_data.title.(par{j}){i} '.tiff']);    
            close all;
        end
        close all;
    end
    close all;
    disp('Maps - Done!');
end
            
            
    
            
            
            
            
  
            
            