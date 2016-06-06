function IF_fixed_layers_multiple (folderPath , segmentation_decision, layerWidth,...
    num_of_layers, pixelResolution,resultsLocation,Channels,normalize,treats,prots,meanPixelIntensity)

files = dir(fullfile(folderPath , '*.tif'));
num_of_images = numel(files)/(numel(Channels)+1);
mkdir(fullfile(resultsLocation,'Segmentation images\Images'))
mkdir(fullfile(resultsLocation,'Problems','DIC'))
mkdir(fullfile(resultsLocation,'Problems','Fluo'))
meanData = [];

filesNames = {files.name};
dicIdx = find(~cellfun(@isempty,strfind(filesNames,'DIC')));
for k = 1 : numel(Channels)
    Ch_idx{k} = find(~cellfun(@isempty,strfind(filesNames,Channels{k})));
end
ax = 0;
for i = 1 : num_of_images
    
    for k = 1 : numel(Channels)
        chNames = {files(Ch_idx{k}).name};
        dicTreatName = strrep(strrep(files(dicIdx(i)).name(19:end),'NNN0',''),'.tif','');
        fluoTreatNames = cellfun(@(x) x(19:end),chNames(cellfun('length',chNames) > 1),'un',0);
        fluoTreatNames = strrep(strrep(fluoTreatNames,'NNN0',''),'.tif','');
        curFluoIdx = find(~cellfun(@isempty,strfind(fluoTreatNames,dicTreatName)));
        filePathFluo = fullfile(folderPath,files(curFluoIdx).name);
        fileName{i} = strrep(strrep(strrep([files(curFluoIdx).name(12:14) files(curFluoIdx).name(19:end)],'NNN0',''),'.tif',''),'_',' ');
        
        
        filePathDIC = fullfile(folderPath,files(dicIdx(i)).name);
        
        try
            [intensityRawData,layerLabels,Segementation_Image] = IntensityAnalyzer (filePathDIC,filePathFluo,segmentation_decision,layerWidth,num_of_layers,pixelResolution,meanPixelIntensity);
        catch
            copyfile(filePathDIC,fullfile(resultsLocation,'Problems','DIC',files(dicIdx(i)).name));
            copyfile(filePathFluo,fullfile(resultsLocation,'Problems','Fluo',files(curFluoIdx).name));
            fileName(i) = [];
            continue;
        end

        savefig(Segementation_Image,fullfile(resultsLocation,'Segmentation images',strcat(fileName{i},'.fig')));
        saveas(Segementation_Image,fullfile(resultsLocation,'Segmentation images','Images',strcat(fileName{i},'.tiff')));
        [curMeanData, curErrData, curAx] = plotIFBarGraphs (intensityRawData,layerLabels,fileName{i},resultsLocation,normalize);
        ax = max(ax,curAx);
        meanData = cat(1,meanData,curMeanData);
%         errData = cat(2,errData,curErrData);
    end
    close all;
    
end

% Setting the same scale to all figures
barFolderPath = fullfile(resultsLocation,'Bar Graphs');
files = dir(fullfile(barFolderPath,'*.fig'));
% num_of_files = numel(files);
% for n = 1 : num_of_files
%     h = openfig(fullfile(barFolderPath,files(n).name));
%     set(get(h,'CurrentAxes'),'YLim',[0 ax]);
%     saveas(h,fullfile(resultsLocation,'Bar Graphs',files(n).name));
%     saveas(h,fullfile(resultsLocation,'Bar Graphs','Images',strcat(strrep(files(n).name,'.fig',''),'.tiff')));
% end
fileName(find(cellfun(@isempty,fileName))) = [];
data = nan(numel(prots),numel(treats)*num_of_layers);
for m = 1 : numel(prots)
    prots_idx = find(~cellfun(@isempty,strfind(fileName,prots{m})));
    for n = 1 : numel(treats)
        treats_idx = find(~cellfun(@isempty,strfind(fileName,treats{n})));
        combined_idx = intersect(prots_idx,treats_idx);
        if numel(combined_idx) > 1
            combined_idx = find(~cellfun(@isempty,strfind(fileName,strcat(treats{n},prots{m}))));
        end
            
        if ~isempty( combined_idx )
            data(m,(n-1)*num_of_layers + 1:n*num_of_layers) = meanData(combined_idx,:);
        end
    end
end
h = figure('Visible','on');
imagesc(data);
set(gca,'YTick',1:numel(prots),'YTickLabel',prots);
new_treats = repmat(treats,num_of_layers,1);
new_treats = new_treats(:);
layers_vec = [];
for n = 1 : numel(treats)
    for k = 1 : num_of_layers
        layers_vec = [layers_vec; {[' Layer - ' num2str(k)]}];
    end
end
for i = 1 : numel(layers_vec)
    new_treats{i} = [new_treats{i} layers_vec{i}];
end
set(gca,'XTick',1:numel(new_treats),'XTickLabel',new_treats,'XTickLabelRotation',90);
colormap(jet);
colorbar;
    
    




end
    
    
    


