function normalize_summary_table ( summary_table_path , normalizing_exp_name, outputLocation )

    [data,text,~] = xlsread(summary_table_path);
    norm_idx = find(~cellfun(@isempty,strfind(text(1,:),normalizing_exp_name)));
    norm_fact = repmat(data(:,norm_idx-1),1,size(data,2));
    data = data ./ norm_fact * 100;
    
    data = [nan(size(data,1),1) data];
    data = [nan(1,size(data,2)); data];
    xlswrite([outputLocation '\Normalized summary table'],data);
    xlswrite([outputLocation '\Normalized summary table'],text(1,:));
    xlswrite([outputLocation '\Normalized summary table'],text(:,1));
end
   