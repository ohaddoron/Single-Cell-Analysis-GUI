function Figures_UI ( folderPath )


    
    
    files = dir([folderPath '\*.fig']);
    handles = cell(length(files));
    disp(['Opening folder ' folderPath]);
    i = 1;
    while i <= length(files)
        
        pb1 = 0;
        pb2 = 0;
        pb3 = 0;
        
        
        
        filePath = [folderPath '\' files(i).name];
        
        
        handles{i} = openfig(filePath);
        set(handles{i},'units','normalized','outerposition',[0 0 1 1]);
        
        
        ax = gca;
        maxxLim = max(ax.XLim);
        maxyLim = max(ax.YLim);
        minyLim = min(ax.YLim);
        minxLim = min(ax.XLim);
        ax.Units = 'pixels';
        
                
       minxLim = uicontrol('Style','edit','Position',[1300 550 100 20],'Callback',@min_x_Lim_Callback);
        txt1 = uicontrol('Style','text',...
        'Position',[1270 570 150 20],...
        'String','Min X Limit');
        maxxLim = uicontrol('Style','edit','Position',[1400 550 100 20],'Callback',@max_x_Lim_Callback);
        txt3 = uicontrol('Style','text',...
        'Position',[1370 570 150 20],...
        'String','Max X Limit');
    
    
        minyLim = uicontrol('Style','edit','Position',[1300 500 100 20],'Callback',@min_y_Lim_Callback);
        txt2 = uicontrol('Style','text',...
        'Position',[1270 520 150 20],...
        'String','Min Y Limit');
    
    
        
    
    
        maxyLim = uicontrol('Style','edit','Position',[1400 500 100 20],'Callback',@max_y_Lim_Callback);
        txt4 = uicontrol('Style','text',...
        'Position',[1370 520 150 20],...
        'String','Max Y Limit');
    
        xLabel = uicontrol('Style','edit','Position',[1300 700 100 20],'Callback',@X_Label_Callback);
        txt5 = uicontrol('Style','text',...
        'Position',[1270 720 150 20],...
        'String','X Label');
    
        yLabel = uicontrol('Style','edit','Position',[1400 700 100 20],'Callback',@Y_Label_Callback);
        txt6 = uicontrol('Style','text',...
        'Position',[1370 720 150 20],...
        'String','Y Label');
        
        Title = uicontrol('Style','edit','Position',[1345 750 100 20],'Callback',@Title_Callback);
        txt7 = uicontrol('Style','text',...
        'Position',[1330 770 150 20],...
        'String','Title');
        
        pb1 = uicontrol('Style','pushbutton','Position',[1350 370 100 20],'Callback',@pushbutton1_Callback,'String','Continue');
        pb2 = uicontrol('Style','pushbutton','Position',[1350 350 100 20],'Callback',@pushbutton2_Callback,'String','Break');
        pb3 = uicontrol('Style','pushbutton','Position',[1350 410 100 20],'Callback',@pushbutton3_Callback,'String','Set');
        pb4 = uicontrol('Style','pushbutton','Position',[1350 390 100 20],'Callback',@pushbutton4_Callback,'String','Reset');
        
                 
        handles{i}.Visible = 'on';
        
        
        
        uiwait(handles{i});
        
        
        
        
                
        if pb1 == 1
            title(Title);
            xlabel(xLabel);
            ylabel(yLabel);
            axis([minxLim maxxLim minyLim maxyLim]);
            txt1.Visible = 'off';
            txt2.Visible = 'off';   
            txt3.Visible = 'off';
            txt4.Visible = 'off';
            txt5.Visible = 'off';
            txt6.Visible = 'off';
            txt7.Visible = 'off';
            pb1.Visible = 'off';
            pb2.Visible = 'off';
            saveas(gcf,[folderPath '\' files(i).name]);
            saveas(gcf,[folderPath '\Images\' strrep(files(i).name,'fig','tif')]);
             continue;
        end
        if pb2 == 1
            txt1.Visible = 'off';
            txt2.Visible = 'off';   
            txt3.Visible = 'off';
            txt4.Visible = 'off';
            txt5.Visible = 'off';
            txt6.Visible = 'off';
            txt7.Visible = 'off';
            pb1.Visible = 'off';
            pb2.Visible = 'off';
            saveas(gcf,[folderPath '\' files(i).name]);
            saveas(gcf,[folderPath '\Images\' strrep(files(i).name,'fig','tif')]);
            break;
        end
        if pb3 ==1 
            axis([minxLim maxxLim minyLim maxyLim]);
            title(Title);
            xlabel(xLabel);
            ylabel(yLabel);
            saveas(gcf,[folderPath '\' files(i).name]);
            saveas(gcf,[folderPath '\Images\' strrep(files(i).name,'fig','tif')]);
            continue
            
        end
        if pb4 == 1
            close(handles{i});
            continue
        end
        
        close(handles{i});
        %handles{i} = gcf;
        
        
        i = i + 1;
       


    end
    function plotxlim(source,callbackdata)
            val = source.Value;
            xlim(ax,[-val val]);
    end
    function plotylim(source,callbackdata)
            val = source.Value;
            ylim(ax,[-val val]);
    end
    function plotzlim(source,callbackdata)
            val = 51 - source.Value;
            zlim(ax,[-val val]);
    end
    function pushbutton1_Callback(hObject, eventdata, handles)
        % hObject    handle to pushbutton1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        uiresume;
        pb1 = 1;
    end
    function pushbutton2_Callback(hObject, eventdata, handles)
        % hObject    handle to pushbutton2 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        uiresume;
        pb2 = 1;
    end
    function pushbutton3_Callback(hObject, eventdata, handles)
        % hObject    handle to pushbutton2 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        uiresume;
        pb3 = 1;
        
    end
    function pushbutton4_Callback(hObject, eventdata, handles)
        % hObject    handle to pushbutton2 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        pb4 = 1;
        uiresume;

    end
    function min_x_Lim_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        minxLim = str2num(get(hObject,'String'));
    end
    function min_y_Lim_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        minyLim = str2num(get(hObject,'String'));
    end
    function max_y_Lim_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        maxyLim = str2num(get(hObject,'String'));
    end
    function max_x_Lim_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        maxxLim = str2num(get(hObject,'String'));
    end
    function X_Label_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        xLabel = get(hObject,'String');
    end
    function Y_Label_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        yLabel = get(hObject,'String');
    end
    
    function Title_Callback(hObject, eventdata, handles)
        % hObject    handle to edit1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of edit1 as text
        %        str2double(get(hObject,'String')) returns contents as double
        Title = get(hObject,'String');
    end
    
end