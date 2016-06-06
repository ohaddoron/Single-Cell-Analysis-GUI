function varargout = Activate_toPowerPoint_GUI(varargin)
% ACTIVATE_TOPOWERPOINT_GUI MATLAB code for Activate_toPowerPoint_GUI.fig
%      ACTIVATE_TOPOWERPOINT_GUI, by itself, creates a new ACTIVATE_TOPOWERPOINT_GUI or raises the existing
%      singleton*.
%
%      H = ACTIVATE_TOPOWERPOINT_GUI returns the handle to a new ACTIVATE_TOPOWERPOINT_GUI or the handle to
%      the existing singleton*.
%
%      ACTIVATE_TOPOWERPOINT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVATE_TOPOWERPOINT_GUI.M with the given input arguments.
%
%      ACTIVATE_TOPOWERPOINT_GUI('Property','Value',...) creates a new ACTIVATE_TOPOWERPOINT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Activate_toPowerPoint_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Activate_toPowerPoint_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Activate_toPowerPoint_GUI

% Last Modified by GUIDE v2.5 24-Feb-2016 09:11:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Activate_toPowerPoint_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Activate_toPowerPoint_GUI_OutputFcn, ...
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


% --- Executes just before Activate_toPowerPoint_GUI is made visible.
function Activate_toPowerPoint_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Activate_toPowerPoint_GUI (see VARARGIN)

% Choose default command line output for Activate_toPowerPoint_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Activate_toPowerPoint_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Activate_toPowerPoint_GUI_OutputFcn(hObject, eventdata, handles) 
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
[handles.layout{1},handles.layoutpath{1}] = uigetfile('*.*','Select layout excel file','\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\ExperimentTemplets\Excel Templates');
handles.lay{1} = fullfile(handles.layoutpath{1},handles.layout{1});
handles.Concatante = 0;
handles.choice = 0;
handles.intensityAnalysis = 0;
handles.ND = 2;
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outdir = uigetdir2('\\metlab21\Matlab');
guidata(hObject,handles);



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.choice = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.intensityAnalysis = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.ND = 3;
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Activate_toPowerPoint(handles.lay,handles.outdir,handles.choice,handles.intensityAnalysis,handles.ND);
