function varargout = normalized_graphs_GUI(varargin)
% NORMALIZED_GRAPHS_GUI MATLAB code for normalized_graphs_GUI.fig
%      NORMALIZED_GRAPHS_GUI, by itself, creates a new NORMALIZED_GRAPHS_GUI or raises the existing
%      singleton*.
%
%      H = NORMALIZED_GRAPHS_GUI returns the handle to a new NORMALIZED_GRAPHS_GUI or the handle to
%      the existing singleton*.
%
%      NORMALIZED_GRAPHS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NORMALIZED_GRAPHS_GUI.M with the given input arguments.
%
%      NORMALIZED_GRAPHS_GUI('Property','Value',...) creates a new NORMALIZED_GRAPHS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before normalized_graphs_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to normalized_graphs_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help normalized_graphs_GUI

% Last Modified by GUIDE v2.5 25-Feb-2016 13:31:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @normalized_graphs_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @normalized_graphs_GUI_OutputFcn, ...
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


% --- Executes just before normalized_graphs_GUI is made visible.
function normalized_graphs_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to normalized_graphs_GUI (see VARARGIN)

% Choose default command line output for normalized_graphs_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes normalized_graphs_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = normalized_graphs_GUI_OutputFcn(hObject, eventdata, handles) 
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
handles.folderPath = uigetdir2('\\metlab21\matlab','');
handles.direction = 0;
handles.bar_dec = 0;
folderPath = handles.folderPath{1};
files = dir([folderPath '\*.mat']);
filePath = [folderPath '\' files(1).name];

temp = load(filePath);
names = fieldnames(temp);
At = temp.(names{1});

pars = fieldnames(At);
set(handles.listbox1,'String',pars);
guidata(hObject,handles);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
items = get(hObject,'String');
index_selected = get(hObject,'Value');
%item_selected = items{index_selected};
try
    handles.pars = [handles.pars; items(index_selected)];
catch
    handles.pars = items(index_selected);
end

%handles.listbox2.String(index_selected) = [];
items (index_selected) = [];
set (handles.listbox2, 'String', handles.pars);
set (handles.listbox1,'String',items);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
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
normalized_graphs(handles.folderPath{1},handles.pars,handles.direction,handles.bar_dec);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.direction = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.pars = {'Area','Acceleration','Coll','Confinement_Ratio','Directional_Change','Displacement','Displacement2','Ellip_Ax_B_X','Ellip_Ax_B_Y','Ellip_Ax_C_X','Ellip_Ax_C_Y',...
                        'EllipsoidAxisLengthB','Ellipticity_oblate','Ellipticity_prolate','Instantaneous_Angle','Instantaneous_Speed','Linearity_of_Forward_Progression','Mean_Curvilinear_Speed','Mean_Straight_Line_Speed','MSD','Sphericity','Track_Displacement_Length','Track_Displacement_X','Track_Displacement_Y','Velocity','Velocity_X','Velocity_Y'...
                        'Eccentricity'};
guidata(hObject,handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.bar_dec = get(hObject,'Value');
guidata(hObject,handles);
