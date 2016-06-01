function batch_IF (dicFolderPaths,floFolderPaths,pixRess, numOfLayerss,layerWidths,outputLocations,xlsLayoutPaths)

    warning('off','all');
    
    
    for i = 1 : numel(dicFolderPaths)
        dicFolderPath = dicFolderPaths{i};
        floFolderPath = floFolderPaths{i};
        pixRes = pixRess(i);
        numOfLayers = numOfLayerss(i);
        layerWidth = layerWidths(i);
        outputLocation = outputLocations{i};
        xlsLayoutPath = xlsLayoutPaths{i};
        
        
        rawPath{1} = [outputLocation '\Raw'];
        binPath{1} = [outputLocation '\Bin'];
        boxPath{1} = [outputLocation '\Box'];
        barPath{1} = [outputLocation '\Bar'];
        
        mkdir(rawPath{1});
        mkdir([outputLocation '\Summary Table']);
        copyfile([floFolderPath '\*.tif'],rawPath{1});
        
        [retData, retLabels] = IF_fixed_layers_multiple(dicFolderPath,floFolderPath,pixRes, numOfLayers,layerWidth,outputLocation);
        
        IF_SummaryTable (retData,retLabels, xlsLayoutPath,[outputLocation '\Summary Table'])
        
        IF_ClusterAnalysis([outputLocation '\Summary Table'])
        
        
        
        Bin ( rawPath{1}, outputLocation )
        
        
        % Need to set the ppt path
        toPowerPoint_IF_template1 (xlsLayoutPath,rawPath,binPath,barPath,boxPath,outputLocation,pptPath)
        toPowerPoint_IF_template2 (xlsLayoutPath,rawPath,binPath,barPath,boxPath,outputLocation,pptPath)
    end
end
        
        