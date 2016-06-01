function varargout = data2ppt_SHORT_GUI(varargin)
% DATA2PPT_SHORT_GUI MATLAB code for data2ppt_SHORT_GUI.fig
%      DATA2PPT_SHORT_GUI, by itself, creates a new DATA2PPT_SHORT_GUI or raises the existing
%      singleton*.
%
%      H = DATA2PPT_SHORT_GUI returns the handle to a new DATA2PPT_SHORT_GUI or the handle to
%      the existing singleton*.
%
%      DATA2PPT_SHORT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA2PPT_SHORT_GUI.M with the given input arguments.
%
%      DATA2PPT_SHORT_GUI('Property','Value',...) creates a new DATA2PPT_SHORT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data2ppt_SHORT_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data2ppt_SHORT_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data2ppt_SHORT_GUI

% Last Modified by GUIDE v2.5 07-Dec-2015 15:19:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data2ppt_SHORT_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @data2ppt_SHORT_GUI_OutputFcn, ...
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


% --- Executes just before data2ppt_SHORT_GUI is made visible.
function data2ppt_SHORT_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data2ppt_SHORT_GUI (see VARARGIN)

% Choose default command line output for data2ppt_SHORT_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data2ppt_SHORT_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data2ppt_SHORT_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Layout_Button.
function Layout_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Layout_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.layout{1},handles.layoutpath{1}] = uigetfile('*.*','Select layout excel file','\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\ExperimentTemplets\Excel Templates');
handles.lay{1} = fullfile(handles.layoutpath{1},handles.layout{1});
handles.Concatante = 0;
handles.intensityAnalysis = 0;
handles.ND = 2;
guidata(hObject,handles);

% --- Executes on button press in Output_Button.
function Output_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Output_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outdir{1} = uigetdir2('\\metlab21\Matlab');
guidata(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'choice')
    data2ppt_SHORT(handles.lay,handles.outdir,0,handles.intensityAnalysis,handles.Concatante);
else
    data2ppt_SHORT(handles.lay,handles.outdir,handles.choice,handles.intensityAnalysis,handles.Concatante);
end

% --- Executes on button press in ScratchScatter_Select.
function ScratchScatter_Select_Callback(hObject, eventdata, handles)
% hObject    handle to ScratchScatter_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ScratchScatter_Select
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
handles.Concatante = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
handles.ND = 3;
guidata(hObject,handles);