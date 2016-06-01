function h = Velocitymaps(folderPath,par)
    
    warning('off','all')
    files = dir([folderPath '\*.mat']);
    num_of_mat_files = length(files);
    
    
    for l = 1 : num_of_mat_files
        for n = 1 : length(par)
            mkdir([folderPath '\Maps\' par{n}]);
            titles{l} = strrep(strrep(files(l).name,'NNN0',''),'.mat','');
            filePath = [folderPath '\' files(l).name];
            temp = load(filePath);
            name = fieldnames(temp);
            At = temp.(name{1});
            m = [];
            %n = [];
            L = {};
            xtot = At.x_Pos;
            ytot = At.y_Pos;
            vtot = At.(par{n});
            xtot(sum(~isnan(vtot),2)==0,:) = [];
            ytot(sum(~isnan(vtot),2)==0,:) = [];
            vtot(sum(~isnan(vtot),2)==0,:) = [];        
            for i = 1 : size(xtot,1)
                x = xtot(i,:);
                y = ytot(i,:);
                v = vtot(i,:);


                x(isnan(v)) = [];
                y(isnan(v)) = [];
                v(isnan(v)) = [];

                T = [x' y' v'];
                if i == 1
                    maxy = ceil(max(y));
                    maxx = ceil(max(x));
                end
                devidex(i) = max(x)/10;
                devidey(i) = maxy/20;
                L{i} = zeros(maxx,maxy);
                dx = (0:devidex(i):max(x)) + 1;
                dy = (0:devidey(i):maxy) + 1;

                for j = 1 : length(dx)-1
                    xpos = floor(dx(j)):ceil(dx(j+1));
                    for k = 1 : length(dy) - 1
                        ypos = floor(dy(k)):ceil(dy(k+1));
                        L{i}(xpos,ypos) = mean(T((x >= dx(j) & x <= dx(j+1)) & (y >= dy(k) & y <=dy(k+1)),3));
                    end

                end
                m = [m mean(L{i})'];
                t{i} = num2str(i * At.dt * 60);
                close all;
            end
            h(l) = figure('Visible','Off');
            %h(l) = figure;
            colormap jet;
            m = ndnanfilter(m,'rectwin',[6 6]);
            switch par{n}
                case 'Velocity'
                    contourf(m,[0 max(max(m))]);
                case 'Velocity_X'
                    ax = max(max(abs(m)));
                    imagesc(m,[-ax, ax]);
                case 'Velocity_Y'
                    ax = max(max(abs(m)));
                    imagesc(m,[-ax, ax]);
                case 'Acceleration'
                    imagesc(m,[0 max(max(m))]);
                case 'Acceleration_X'
                    ax = max(max(abs(m)));
                    imagesc(m,[-ax, ax]);
                case 'Acceleration_Y'
                    ax = max(max(abs(m)));
                    imagesc(m,[-ax, ax]);
                otherwise 
                    imagesc(m);
            end
                    
            set(gca,'XTickLabel',t(1:5:end));
            hbar = colorbar;
            xlabel('Time [min]');
            ylabel('Y Position [\mum]');
            title(titles{l});
            xlabel(hbar,strrep(par{n},'_',' '));
            saveas(h(l),[folderPath '\Maps\' par{n} '\' titles{l} '.tiff']);
            toPPT('setTitle',strrep(par{n},'_',' '),'SlideNumber','append');
            toPPT(h(l),'SlideNumber','Current');
            close all;
        end
    end
    warning('on','all')
end