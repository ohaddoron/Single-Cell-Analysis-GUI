function varargout = Multi_Parameter_Correlation_GUI(varargin)
% MULTI_PARAMETER_CORRELATION_GUI MATLAB code for Multi_Parameter_Correlation_GUI.fig
%      MULTI_PARAMETER_CORRELATION_GUI, by itself, creates a new MULTI_PARAMETER_CORRELATION_GUI or raises the existing
%      singleton*.
%
%      H = MULTI_PARAMETER_CORRELATION_GUI returns the handle to a new MULTI_PARAMETER_CORRELATION_GUI or the handle to
%      the existing singleton*.
%
%      MULTI_PARAMETER_CORRELATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTI_PARAMETER_CORRELATION_GUI.M with the given input arguments.
%
%      MULTI_PARAMETER_CORRELATION_GUI('Property','Value',...) creates a new MULTI_PARAMETER_CORRELATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Multi_Parameter_Correlation_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Multi_Parameter_Correlation_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Multi_Parameter_Correlation_GUI

% Last Modified by GUIDE v2.5 06-Jun-2016 11:21:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Multi_Parameter_Correlation_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Multi_Parameter_Correlation_GUI_OutputFcn, ...
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


% --- Executes just before Multi_Parameter_Correlation_GUI is made visible.
function Multi_Parameter_Correlation_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Multi_Parameter_Correlation_GUI (see VARARGIN)

% Choose default command line output for Multi_Parameter_Correlation_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Multi_Parameter_Correlation_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Multi_Parameter_Correlation_GUI_OutputFcn(hObject, eventdata, handles) 
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
handles.normalize = 0;
handles.folderPath = uigetdir2('\\metlab21\Matlab','');
folderPath = handles.folderPath{1};
files = dir([folderPath '\*.mat']);

temp = load([folderPath '\' files(1).name]);
name = fieldnames(temp);
At = temp.(name{1});

pars = fieldnames(At);
set(handles.par1,'String',pars);
set(handles.par2,'String',pars);
set(handles.par3,'String',pars);

guidata(hObject,handles);

% --- Executes on selection change in par1.
function par1_Callback(hObject, eventdata, handles)
% hObject    handle to par1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns par1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from par1
items = get(hObject,'String');
index_selected = get(hObject,'Value');
%item_selected = items{index_selected};
try
    handles.par1Chosen = [handles.par1Chosen; items(index_selected)];
catch
    handles.par1Chosen = items(index_selected);
end

%handles.listbox2.String(index_selected) = [];
items (index_selected) = [];
set (handles.par1_chosen, 'String', handles.par1Chosen);
set (handles.par1,'String',items);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function par1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in par1_chosen.
function par1_chosen_Callback(hObject, eventdata, handles)
% hObject    handle to par1_chosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns par1_chosen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from par1_chosen


% --- Executes during object creation, after setting all properties.
function par1_chosen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par1_chosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in par2.
function par2_Callback(hObject, eventdata, handles)
% hObject    handle to par2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns par2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from par2
items = get(hObject,'String');
index_selected = get(hObject,'Value');
%item_selected = items{index_selected};
try
    handles.par2Chosen = [handles.par2Chosen; items(index_selected)];
catch
    handles.par2Chosen = items(index_selected);
end

%handles.listbox2.String(index_selected) = [];
items (index_selected) = [];
set (handles.par2_chosen, 'String', handles.par2Chosen);
set (handles.par2,'String',items);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function par2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in par2_chosen.
function par2_chosen_Callback(hObject, eventdata, handles)
% hObject    handle to par2_chosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns par2_chosen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from par2_chosen


% --- Executes during object creation, after setting all properties.
function par2_chosen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par2_chosen (see GCBO)
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

Multi_Parameter_Correlation (handles.folderPath{1} , handles.par1Chosen , handles.par2Chosen,handles.par3Chosen,handles.normalize)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.normalize = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on selection change in par3.
function par3_Callback(hObject, eventdata, handles)
% hObject    handle to par3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns par3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from par3
items = get(hObject,'String');
index_selected = get(hObject,'Value');
%item_selected = items{index_selected};
try
    handles.par3Chosen = [handles.par3Chosen; items(index_selected)];
catch
    handles.par3Chosen = items(index_selected);
end

%handles.listbox2.String(index_selected) = [];
items (index_selected) = [];
set (handles.par3_chosen, 'String', handles.par3Chosen);
set (handles.par3,'String',items);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function par3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in par3_chosen.
function par3_chosen_Callback(hObject, eventdata, handles)
% hObject    handle to par3_chosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns par3_chosen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from par3_chosen


% --- Executes during object creation, after setting all properties.
function par3_chosen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to par3_chosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
addpath(genpath(pwd));
load('Control.mat');
handles.par3Chosen = Control.time_dependency_parameters;
guidata(hObject,handles);
