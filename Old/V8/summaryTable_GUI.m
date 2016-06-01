function varargout = summaryTable_GUI(varargin)
% SUMMARYTABLE_GUI MATLAB code for summaryTable_GUI.fig
%      SUMMARYTABLE_GUI, by itself, creates a new SUMMARYTABLE_GUI or raises the existing
%      singleton*.
%
%      H = SUMMARYTABLE_GUI returns the handle to a new SUMMARYTABLE_GUI or the handle to
%      the existing singleton*.
%
%      SUMMARYTABLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUMMARYTABLE_GUI.M with the given input arguments.
%
%      SUMMARYTABLE_GUI('Property','Value',...) creates a new SUMMARYTABLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before summaryTable_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to summaryTable_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help summaryTable_GUI

% Last Modified by GUIDE v2.5 19-Jan-2016 10:54:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @summaryTable_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @summaryTable_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before summaryTable_GUI is made visible.
function summaryTable_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to summaryTable_GUI (see VARARGIN)

% Choose default command line output for summaryTable_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes summaryTable_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = summaryTable_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.folderPath = [handles.folderPath; uigetdir2('\\metlab21\Matlab','')]
catch
    handles.folderPath = uigetdir2('\\metlab21\Matlab','');
    folderPath = handles.folderPath{1};
    files = dir([folderPath '\*.mat']);
    temp = load([folderPath '\' files(1).name]);
    name = fieldnames(temp);
    At = temp.(name{1});
    pars = fieldnames(At);
    set(handles.Available_pars,'String',pars);
end
set(handles.Paths,'String',handles.folderPath);
handles.TP.transpose = 0;
handles.TP.choice = 0;
guidata(hObject,handles);


% --- Executes on selection change in Paths.
function Paths_Callback(hObject, eventdata, handles)
% hObject    handle to Paths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Paths contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Paths


% --- Executes during object creation, after setting all properties.
function Paths_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Paths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Available_pars.
function Available_pars_Callback(hObject, eventdata, handles)
% hObject    handle to Available_pars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Available_pars contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Available_pars
items = get(hObject,'String');
index_selected = get(hObject,'Value');
%item_selected = items{index_selected};
try
    handles.pars = [handles.pars; items(index_selected)];
catch
    handles.pars = [items(index_selected)];
end

%handles.listbox2.String(index_selected) = [];
items (index_selected) = [];
set (handles.Pars, 'String', handles.pars);
set (handles.Available_pars,'String',items);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Available_pars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Available_pars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Pars.
function Pars_Callback(hObject, eventdata, handles)
% hObject    handle to Pars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Pars contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Pars


% --- Executes during object creation, after setting all properties.
function Pars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.TP.choice = 1;
summaryTable(handles.folderPath,handles.pars,handles.outputLocation{1},handles.TP);

% --- Executes on button press in Tranpose.
function Tranpose_Callback(hObject, eventdata, handles)
% hObject    handle to Tranpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Tranpose
handles.TP.transpose = get(hObject,'Value');
guidata(hObject,handles);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outputLocation = uigetdir2('\\metlab21\Matlab','');
guidata(hObject,handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.pars = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'...
                        'Eccentricity'};
guidata(hObject,handles);
