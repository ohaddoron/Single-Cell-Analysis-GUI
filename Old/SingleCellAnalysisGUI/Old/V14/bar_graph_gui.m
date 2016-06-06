function varargout = bar_graph_gui(varargin)
% BAR_GRAPH_GUI MATLAB code for bar_graph_gui.fig
%      BAR_GRAPH_GUI, by itself, creates a new BAR_GRAPH_GUI or raises the existing
%      singleton*.
%
%      H = BAR_GRAPH_GUI returns the handle to a new BAR_GRAPH_GUI or the handle to
%      the existing singleton*.
%
%      BAR_GRAPH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BAR_GRAPH_GUI.M with the given input arguments.
%
%      BAR_GRAPH_GUI('Property','Value',...) creates a new BAR_GRAPH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bar_graph_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bar_graph_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bar_graph_gui

% Last Modified by GUIDE v2.5 06-Jan-2016 17:15:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bar_graph_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @bar_graph_gui_OutputFcn, ...
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


% --- Executes just before bar_graph_gui is made visible.
function bar_graph_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bar_graph_gui (see VARARGIN)

% Choose default command line output for bar_graph_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bar_graph_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bar_graph_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SELECTDIR.
function SELECTDIR_Callback(hObject, eventdata, handles)
% hObject    handle to SELECTDIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.foldername = uigetdir2('\\metlab21\Matlab','');
handles.direction = 0;
handles.Normalize = 0;
handles.concat = 0;
handles.scales.choice(1) = 0;
handles.scales.choice(2) = 0;


files = dir([handles.foldername{1} '\*.mat']);
temp = load([handles.foldername{1} '\' files(1).name]);
names = fieldnames(temp);
At = temp.(names{1});
pars = fieldnames(At);
set(handles.PARALIST,'String',pars);
handles.Concatanate = 0;
guidata(hObject,handles);


% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles.Arrange,'choice')
    handles.Arrange.choice = 0;
    if ~isfield(handles,'pars')
        bar_graph(handles.foldername{1}{1},{'Velocity'},handles.Arrange,handles.concat,handles.Normalize,handles.direction);
    else
       bar_graph(handles.foldername{1}{1},handles.pars,handles.Arrange,handles.concat,handles.Normalize,handles.direction);
    end
else
    if ~isfield(handles,'pars')
        bar_graph(handles.foldername{1},{'Velocity'},handles.Arrange,handles.concat,handles.Normalize,handles.direction);
    else
        bar_graph(handles.foldername{1},handles.pars,handles.Arrange,handles.concat,handles.Normalize,handles.direction);
    end
end

% --- Executes on selection change in PARALIST.
function PARALIST_Callback(hObject, eventdata, handles)
% hObject    handle to PARALIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PARALIST contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PARALIST
items = get(hObject,'String');
index_selected = get(hObject,'Value');
%item_selected = items{index_selected};
try
    handles.pars = [handles.pars; items(index_selected)];
catch
    handles.pars = [items(index_selected)];
end
items(index_selected) = [];
set(handles.listbox4,'String',handles.pars)
set(handles.PARALIST,'String',items);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PARALIST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PARALIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AutoArrange.
function AutoArrange_Callback(hObject, eventdata, handles)
% hObject    handle to AutoArrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoArrange
handles.Arrange.choice = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on selection change in PREARRANGE.
function PREARRANGE_Callback(hObject, eventdata, handles)
% hObject    handle to PREARRANGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PREARRANGE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PREARRANGE
set(hObject,'String',handles.list');
contents = cellstr(get(hObject,'String'));
handles.Arrange.list = cellstr(contents(get(hObject,'Value')));
%{
contents = cellstr(get(hObject,'String'));
list = cellstr(contents(get(hObject,'Value')));
handles.Arrange.list = list;
%}
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PREARRANGE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PREARRANGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ARRANGE.
function ARRANGE_Callback(hObject, eventdata, handles)
% hObject    handle to ARRANGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
files = dir([char(handles.foldername{1}),'\*.mat']);
for i=1:length(files)
    handles.list{i} = strrep(strrep(files(i).name(10:length(files(i).name)),'NNN0',''),'.mat','');
end
guidata(hObject,handles);
%set(handles.PREARRANGE,'String',handles.list');

% --- Executes on selection change in POSTARRANGE.
function POSTARRANGE_Callback(hObject, eventdata, handles)
% hObject    handle to POSTARRANGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns POSTARRANGE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from POSTARRANGE
set(hObject,'String',handles.Arrange.list');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function POSTARRANGE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POSTARRANGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
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
handles.Normalize = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.direction = get(hObject,'Value');
guidata(hObject,handles);
