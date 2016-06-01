function [meanData,errData,ax] = plotIFBarGraphs (intensityRawData,layerLabels,fileName,outputLocation,normalize)

mkdir(fullfile(outputLocation,'Bar Graphs','Images'));
h = figure('Visible','Off');
meanData = [];
errData = [];
for k = 1 : numel(intensityRawData)
    if normalize ~= 0
        intensityRawData{k} = intensityRawData{k}/mean(intensityRawData{1}) * 100   ;
    end
    curLayerData = intensityRawData{k};
    meanData = [meanData nanmean(curLayerData)];
    errData = [errData nanstd(curLayerData)/sqrt(sum(~isnan(curLayerData)))];
end
hold on;
X = 1 : numel(meanData);
bar(X,meanData);
errorbar(X,meanData,errData,'.');
set(gca,'XTick',X,'XTickLabel',layerLabels,'XTickLabelRotation',45)
title([fileName ' Intensity as a function of distance from scratch']);
ax = max(get(gca,'YLim'));
xlabel('Distance from scratch [\mum]');
ylabel('Intensity [AU]');
savefig(h,fullfile(outputLocation,'Bar Graphs',strcat(fileName,'.fig')));
saveas(h,fullfile(outputLocation,'Bar Graphs','Images',strcat(fileName,'.tiff')));




