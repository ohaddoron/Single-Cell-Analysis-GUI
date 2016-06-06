for j = 1 : length(temp)
    for k = 1 : length(files)
        if ~isempty(strfind(files(k).name,temp{j}(6:end))) && ~isempty(strfind(files(k).name,temp{j}(1:5)))
            if concat(t) ~= 0
                ArrangeBG.list{j} = strrep(strrep(files(k).name,'.mat',''),'NNN0','');
            else
                ArrangeBG.list{j} = strrep(strrep(files(k).name,'.mat',''),'NNN0','');
            end
        end
    end
end