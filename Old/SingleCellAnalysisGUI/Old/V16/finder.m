clear all; close all; clc;


imfolderPath = 'D:\Matlab\Ohad\Dganit\DS292\D03GGAB\tif';
imfiles = dir([imfolderPath '\*.tif']);
% for i = 1 : length(files);
% im = imread([folderPath '\' files(i).name]);
% h = figure('Visible','Off');
% imagesc(im);
% colormap hot
% colorbar
% F(i) = getframe(h);
% end
% % implay(F)

pixRes = 1.22;

folderPath = 'D:\Matlab\Ohad\Dganit\DS292\D03GGAB\mat';
file = dir([folderPath '\*.mat']);

filePath = [folderPath '\' file.name];

load(filePath);

x_Pos = At.x_Pos/pixRes;
y_Pos = At.y_Pos/pixRes;

r = 3;

for t = 1 : size(x_Pos,1)
    
    cur_x = x_Pos(t,~isnan(x_Pos(t,:)));
    cur_y = y_Pos(t,~isnan(y_Pos(t,:)));
    
    for i = 1 : size(cur_x,2)-1
        xDist = abs(cur_x([1:i-1,i+1:end]) - cur_x(i));
    	yDist = abs(cur_y([1:i-1,i+1:end]) - cur_y(i));
        if sum(xDist<r) == 0 && sum(yDist<r) == 0
            im = imread([imfolderPath '\' imfiles(t).name]);
            cropped_im = im(round(cur_y(t,i))-r:round(cur_y(t,i))+r,round(cur_x(t,i))-r:round(cur_x(t,i))+r);
            figure;
            imagesc(cropped_im)
            colormap hot
        end    
    end
end