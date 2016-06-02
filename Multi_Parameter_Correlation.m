function Multi_Parameter_Correlation ( folderPath , par1, par2, par3,normalize)


files = dir(fullfile(folderPath,'*.mat'));
num_of_mat_files = numel(files);
disp(['Opening : ' folderPath]);
ax_sun = [];
ax_abs = [];
ax_avg = [];
ax_time = [];



% mkdir(fullfile(folderPath,'Parameter Correlation - Multiple','Time'));
for i = 1 : num_of_mat_files
    ttl = strrep(strrep(files(i).name([12:14 19:end]),'.mat',''),'NNN0','');
    filePath = fullfile(folderPath,files(i).name);
    disp(['Opening file : ' files(i).name]);
    
    temp = load(filePath);
    name = fieldnames(temp);
    At = temp.(name{1});
    
    for l = 1 : numel(par1)
        par1Data = At.(par1{l});
        if normalize ~= 0
            par1mean = nanmean(par1Data(:));
            par1Data = par1Data./par1mean;
        end
        for m = 1 : numel(par2)
            par2Data = At.(par2{m});
            if normalize ~= 0
                par2mean = nanmean(par2Data(:));
                par2Data = par2Data./par2mean;
            end
            for n = 1 : numel(par3)
                outPath = fullfile(folderPath,'Parameter Correlation - Multiple',par1{l},par2{m},par3{n});
                mkdir(fullfile(outPath,'Sun','Images'));
                mkdir(fullfile(outPath,'Abs','Images'));
                mkdir(fullfile(outPath,'Avg','Images'));
                par3Data = At.(par3{n});
                if normalize ~= 0
                    par3mean = nanmean(par3Data(:));
                    par3Data = par3Data./par3mean;
                end
                
                
% %                 Sun
                par1_sun = par1Data(:);
                par2_sun = par2Data(:);
                par3_sun = par3Data(:);
% %                 
                par2_sun(isnan(par1_sun)) = [];
                par3_sun(isnan(par1_sun)) = [];
                par1_sun(isnan(par1_sun)) = [];
% %                 
                par1_sun(isnan(par2_sun)) = [];
                par3_sun(isnan(par2_sun)) = [];
                par2_sun(isnan(par2_sun)) = [];
% %                 
                par1_sun(isnan(par3_sun)) = [];
                par2_sun(isnan(par3_sun)) = [];
                par3_sun(isnan(par3_sun)) = [];
                
                h = plotFigure ( par1_sun, par2_sun, par3_sun,ttl,par1{l},par2{m},par3{n});
                savefig(h,fullfile(outPath,'Sun',ttl));


                
                
                
% %                 Abs
                
                par1_abs = abs(par1_sun);
                par2_abs = abs(par2_sun);
                par3_abs = abs(par3_sun);
                h = plotFigure ( par1_abs, par2_abs, par3_abs,ttl,par1{l},par2{m},par3{n});
                savefig(h,fullfile(outPath,'Abs',ttl));
                
                
% %                 Avg
                par1_avg = nanmean(abs(par1Data),2);
                par2_avg = nanmean(abs(par2Data),2);
                par3_avg = nanmean(abs(par3Data),2);
                
% %                 
                par2_avg(isnan(par1_avg)) = [];
                par3_avg(isnan(par1_avg)) = [];
                par1_avg(isnan(par1_avg)) = [];
% %                 
                par1_avg(isnan(par2_avg)) = [];
                par3_avg(isnan(par2_avg)) = [];
                par2_avg(isnan(par2_avg)) = [];
% %                 
                par1_avg(isnan(par3_avg)) = [];
                par2_avg(isnan(par3_avg)) = [];
                par3_avg(isnan(par3_avg)) = [];
                h = plotFigure ( par1_avg, par2_avg, par3_avg,ttl,par1{l},par2{m},par3{n});
                for k = 1 : size(par1_avg,1)
                    txt = ['\leftarrow ' num2str(k * At.dt) ];
                    text(par1_avg(k),par2_avg(k),txt)
                end
                savefig(h,fullfile(outPath,'Avg',ttl));
                if i == num_of_mat_files
                    scaleFigures(fullfile(outPath,'Sun'));
                    scaleFigures(fullfile(outPath,'Abs'));
                    scaleFigures(fullfile(outPath,'Avg'));
                end
            end
        end
    end
    close all;
end

function scaleFigures (folderPath)

    files = dir(fullfile(folderPath,'*.fig'));
    ax = [];
    for i = 1 : numel(files)
        h(i) = openfig(fullfile(folderPath,files(i).name));
        ax = cat(1,ax,[get(gca,'XLim') get(gca,'YLim')]);
    end
    for i = 1 : numel(files)
%         set(get(h(i),'CurrentAxes'),'XLim',[min(ax(:)) max(ax(:))],'YLim',[min(ax(:)) max(ax(:))]);
        ttl = get(get(h(i),'CurrentAxes'),'title');
        ttl = ttl.String;
        savefig(h(i),fullfile(folderPath,ttl));
        saveas(h(i),fullfile(folderPath,'Images',[ttl '.tiff']));
    end
    close all;

function h = plotFigure ( par1, par2, par3,ttl,par1_name, par2_name, par3_name)

h = figure('Visible','Off');
scatter(par1,par2,8,par3,'filled');
colormap(jet);
b = colorbar;
xlabel(strrep(par1_name,'_',' '));
ylabel(strrep(par2_name,'_',' '));
xlabel(b,strrep(par3_name,'_',' '))
title(ttl);
axis tight;
ax = [get(gca,'XLim'); get(gca,'YLim')];
% set(gca,'XLim',[min(ax(:)) max(ax(:))],'YLim',[min(ax(:)) max(ax(:))]);
                
                
                
                
                