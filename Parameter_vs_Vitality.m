function Parameter_vs_Vitality ( summaryTablePath, vitalityPath , par , outputLocation)

vitalityData = Read_Vitality_Data(vitalityPath);
[~,~,summaryData] = xlsread(summaryTablePath);
plotData = [];
% for i = 2 : size( vitalityData , 1)
%     for ii = 2 : size(vitalityData,2)
%         curPlotData = [];
%         curTreat = strcat(vitalityData{i,1},vitalityData{1,ii});
%         idx = find(~cellfun(@isempty,strfind(summaryData(1,2:end),curTreat)));
%         curData = cell2mat(summaryData(2:end,idx+1));
%         for j = 2 : size(summaryData,1)
%             if ~isempty(find(~cellfun(@isempty,strfind(par,summaryData{j,1}))))
%                 curPlotData = [curPlotData curData(j)/vitalityData{i,ii}];
%             end
%         end
%         plotData = [plotData; curPlotData];
%     end
% end

for j = 1 : numel(par)
    idx = strcmp(summaryData(2:end,1),par{j});
    curParData = cell2mat(summaryData(find(idx)+1,2:end));
    plotData.(par{j}) = nan(size(vitalityData));
    for i = 2 : size( vitalityData , 1)
        for ii = 2 : size(vitalityData,2)
            idx = find(~cellfun(@isempty,strfind(summaryData(1,2:end),strcat(vitalityData{i,1},vitalityData{1,ii}))));
%             idx = idx(1); % If 2 are found, take the first one
            k = 1;
            while numel(idx) > 1
                if numel(summaryData{1,idx(k)+1}(19:end-4)) == numel(strcat(vitalityData{i,1},vitalityData{1,ii}))
                    idx = idx(k);
                end
                k = k + 1;
            end
            
            
            plotData.(par{j})(i,ii) = curParData(idx)/vitalityData{i,ii};

        end
    end
    plotData.(par{j})(1,:) = [];
    plotData.(par{j})(:,1) = [];
end
for j = 1 : numel(par)
    outPath = fullfile(outputLocation,'Parameter vs Vitality');
    mkdir(fullfile(outPath,par{j},'Images'));
    h = figure('Visible','Off');
    imagesc(plotData.(par{j}));
    set(gca,'YTick',1:(size(vitalityData,1)-1),'YTickLabel',vitalityData(2:end,1));
    set(gca,'XTick',1:(size(vitalityData,2)-1),'XTickLabel',vitalityData(1,2:end),'XTickLabelRotation',90);
    colormap jet;
    colorbar;
    ttl = sprintf(strrep(par{j},'_',' '),' vs Vitality');
    title(ttl);
    savefig(h,fullfile(outPath,par{j},ttl));
    saveas(h,fullfile(outPath,par{j},'Images',strcat(ttl,'.tiff')));
    
end
    

            






function raw = Read_Vitality_Data( xlsPath )

[~,~,raw] = xlsread(xlsPath);
nan_idx = sum(cellfun(@(V) any(isnan(V(:))), raw),2);
raw(nan_idx == size(raw,2),:) = [];

