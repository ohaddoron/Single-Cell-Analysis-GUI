function normalized_graphs (varargin)


    folderPath = varargin{1};
    par = varargin{2};
    direction = varargin{3};
    
    if nargin > 3
        bar_dec = varargin{4};
    end
    mkdir(folderPath,'Normalized');
    
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = numel(files);
    
    A = {files.name}; % Gets the names of all the files in the folder
    B = cellfun(@(x) x(1:5),A(cellfun('length',A) > 1),'un',0); % Extracts the first 5 characters of all files 
    
    plateNames = unique(B); 
    
    
    
    
    for i = 1 : num_of_mat_files
        filePath = [folderPath '\' files(i).name];
        temp = load(filePath);
        name = fieldnames(temp);
        At = temp.(name{1});
        
        A = find(~cellfun(@isempty,strfind({files.name},files(i).name(1:5))));
        %B = find(~cellfun(@isempty,strfind({files.name},'SK00CON')));
        B = find(~cellfun(@isempty,strfind({files.name},'CON')));
        
        conIdx = intersect(A,B);
        conFilePath = [folderPath '\' files(conIdx).name];
        temp = load(conFilePath);
        name = fieldnames(temp);
        conAt = temp.(name{1});
        
        
        for j = 1 : numel(par)
            At.(par{j}) = At.(par{j}) / nanmean(abs(conAt.(par{j})(:))) * 100;
        end
        
        save([folderPath '\Normalized\' files(i).name],'At');
    end
    folder_path = [folderPath '\Normalized'];
    
    Arrange.choice = 1;
    scale.choice = [1 1];
    
    %{
    try
        [handler,Ax] = MD_parameter_to_time_multiple(folder_path,par,scale,Arrange,0);
    catch
        continue
    end
    %}
    %try
        if nargin <= 3 || bar_dec ~= 0
            h.BarGraph = bar_graph...
                        (folder_path,par,Arrange,0,1,direction); 
            [handler,Ax] = MD_parameter_to_time_multiple(folder_path,par,scale,Arrange,0);
        end
    %catch
    %end
end
            
        
        