function summaryTable(varargin)
    
    folder_paths = varargin{1};
    par = varargin{2};
    outputLocation = varargin{3};
    
    switch nargin
        case 4
            TP = varargin{4};
        case 5
            TP = varargin{4};
            normalize = varargin{5};
        case 6
            TP = varargin{4};
            normalize = varargin{5};
            concat = varargin{6};
    end
    
    
        

    parName = nan;
    expName = nan;
    Table = [];
    for k = 1 : length(folder_paths)
        folder_path = folder_paths{k};
        mkdir([outputLocation '\Cluster Analysis\Image']);
        if nargin >= 5 && normalize ~= 0
            normalized_graphs (folder_path, par, 0 , 0);
            copyfile([folder_path '\Normalized\*.mat'],folder_path);
            rmdir([folder_path '\Normalized'], 's');
        end
        
        files = dir([folder_path '\*.mat']);
        num_of_mat_files = length(files);
        
        
        % % Concat
        if nargin >= 6 && concat ~= 0
            for i = 1 : num_of_mat_files
                disp(['loading file ' files(i).name]);
                file_path = [folder_path '\' files(i).name];
                temp = load(file_path);
                Atname = fieldnames(temp);
                data_struct = temp.(Atname{1});
                if i == 1
                    dt = data_struct.dt;
                end
                for j = 1 : length(par)
                    name = strrep([files(i).name(1:5) files(i).name(12:14) files(i).name(19:end)],'.mat','');
                    if i == 1
                        names.(par{j}) = [];
                    end
                    if i ~= 1
                        idx = find(~cellfun(@isempty,strfind(names.(par{j}),name)));
                    else
                        idx = [];
                    end

                    if ~isempty(idx)

                        if size(data_struct.(par{j}),1) > size(graphs_data.data.(par{j}){idx},1) && ~isempty(graphs_data.data.(par{j}){idx})
                            data_struct.(par{j})(size(graphs_data.data.(par{j}){idx},1)+1:end,:) = [];
                        end
                        if size(graphs_data.data.(par{j}){idx},1) > size(data_struct.(par{j}),1) 
                            graphs_data.data.(par{j}){idx}(size(data_struct.(par{j}),1)+1:end,:) = [];
                        end
                        graphs_data.data.(par{j}){idx} = [graphs_data.data.(par{j}){idx} data_struct.(par{j})];
                    else
                        try
                            graphs_data.data.(par{j}){end+1} = data_struct.(par{j});
                            names.(par{j}){end+1} = name;
                        catch
                            graphs_data.data.(par{j}){1} = data_struct.(par{j});
                            names.(par{j}){1} = name;
                        end

                    end
                end
            end
            for j = 1 : numel(par)
                idx = find(cellfun(@isempty,graphs_data.data.(par{j})));
                graphs_data.data.(par{j})(idx) = [];
                names.(par{j})(idx) = [];
            end
        end
        
        % % End of concat
        
        if nargin < 6 || concat == 0
            len = num_of_mat_files;
        else
            len = numel(graphs_data.data.(par{1}));
        end
        
        for i = 1 : len
            
            if nargin < 6 || concat == 0
                %disp(['loading file ' files(i).name]);
                file_path = [folder_path '\' files(i).name];
                temp = load(file_path);
                Atname = fieldnames(temp);
                At = temp.(Atname{1});
            end
            
            
            cur_data = [];
            for j = 1 : length(par)
                
                if nargin >= 6 && concat ~= 0
                    data_struct.(par{j}) = graphs_data.data.(par{j}){i};
                else
                    data_struct.(par{j}) = At.(par{j});
                end
                if k == 1 && i == 1
                    parName = [parName {par{j}}]; 
                end
                
                if j == 1
                    if nargin < 6 || concat == 0
                        expName = [expName; {strrep(strrep(files(i).name,'NNN0',''),'.mat','')}];
                    else
                        expName = [expName; strrep(names.(par{j})(i),'NNN0','')];
                    end
                end
                
                if TP.choice == 1
                    cur_data = [cur_data nanmean(abs(data_struct.(par{j})(:)))];
                else
                    dat = abs(data_struct.(par{j})(TP.tl:TP.th,:));
                    cur_data = nanmean(dat(:));
                end
            end
            Table = [Table; cur_data];
        end
        
    end
    Table = [nan(1,size(Table,2));Table];
    Table = [nan(size(Table,1),1) Table];
    if TP.transpose ~= 0
        Table = Table';
        expName = expName';
        parName = parName';
    end
    outputLocation = [outputLocation '\Cluster Analysis\'];
    try
        xlswrite([outputLocation '\Summary Table'],Table);
        xlswrite([outputLocation '\Summary Table'],expName);
        xlswrite([outputLocation '\Summary Table'],parName);
    catch
        xlswrite([outputLocation '\Summary Table.xlsx'],Table);
        xlswrite([outputLocation '\Summary Table.xlsx'],expName);
        xlswrite([outputLocation '\Summary Table.xlsx'],parName);
    end
end
                
                
                    
                    
                    
                
                
                
            
            
            