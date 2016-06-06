function varargout = Velocity_XVsVelocity_YVsTime_GUI(varargin)
% VELOCITY_XVSVELOCITY_YVSTIME_GUI MATLAB code for Velocity_XVsVelocity_YVsTime_GUI.fig
%      VELOCITY_XVSVELOCITY_YVSTIME_GUI, by itself, creates a new VELOCITY_XVSVELOCITY_YVSTIME_GUI or raises the existing
%      singleton*.
%
%      H = VELOCITY_XVSVELOCITY_YVSTIME_GUI returns the handle to a new VELOCITY_XVSVELOCITY_YVSTIME_GUI or the handle to
%      the existing singleton*.
%
%      VELOCITY_XVSVELOCITY_YVSTIME_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VELOCITY_XVSVELOCITY_YVSTIME_GUI.M with the given input arguments.
%
%      VELOCITY_XVSVELOCITY_YVSTIME_GUI('Property','Value',...) creates a new VELOCITY_XVSVELOCITY_YVSTIME_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Velocity_XVsVelocity_YVsTime_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Velocity_XVsVelocity_YVsTime_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Velocity_XVsVelocity_YVsTime_GUI

% Last Modified by GUIDE v2.5 09-Dec-2015 15:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Velocity_XVsVelocity_YVsTime_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Velocity_XVsVelocity_YVsTime_GUI_OutputFcn, ...
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


% --- Executes just before Velocity_XVsVelocity_YVsTime_GUI is made visible.
function Velocity_XVsVelocity_YVsTime_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Velocity_XVsVelocity_YVsTime_GUI (see VARARGIN)

% Choose default command line output for Velocity_XVsVelocity_YVsTime_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Velocity_XVsVelocity_YVsTime_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Velocity_XVsVelocity_YVsTime_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FolderSelection.
function FolderSelection_Callback(hObject, eventdata, handles)
% hObject    handle to FolderSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.folder = uigetdir2;
handles.Concatante = 0;
guidata(hObject,handles);


% --- Executes on button press in EXECUTE.
function EXECUTE_Callback(hObject, eventdata, handles)
% hObject    handle to EXECUTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Velocity_XVsVelocity_YVsTime(handles.folder{1},handles.Concatante);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.Concatanate = get(hObject,'Value');
guidata(hObject,handles);
