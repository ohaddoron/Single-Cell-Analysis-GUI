function varargout = catExps_GUI(varargin)
% CATEXPS_GUI MATLAB code for catExps_GUI.fig
%      CATEXPS_GUI, by itself, creates a new CATEXPS_GUI or raises the existing
%      singleton*.
%
%      H = CATEXPS_GUI returns the handle to a new CATEXPS_GUI or the handle to
%      the existing singleton*.
%
%      CATEXPS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CATEXPS_GUI.M with the given input arguments.
%
%      CATEXPS_GUI('Property','Value',...) creates a new CATEXPS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before catExps_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to catExps_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help catExps_GUI

% Last Modified by GUIDE v2.5 21-Mar-2016 13:04:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @catExps_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @catExps_GUI_OutputFcn, ...
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


% --- Executes just before catExps_GUI is made visible.
function catExps_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to catExps_GUI (see VARARGIN)

% Choose default command line output for catExps_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes catExps_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = catExps_GUI_OutputFcn(hObject, eventdata, handles) 
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
handles.ND = 2;
handles.intensityDecision = 0;
handles.concat = 0;
handles.folderPath = uigetdir2('\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\ExperimentTemplets\Excel Templates','');
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outputLocation = uigetdir2('\\metlab21\Matlab','');
guidata(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
catExps( handles.folderPath{1} , handles.outputLocation{1} , handles.normalize , handles.concat,handles.ND,handles.intensityDecision );

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.normalize = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.concat = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.intensityDecision = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
handles.ND = 3;
guidata(hObject,handles);
