function varargout = RenamingTIF_GUI(varargin)
% RENAMINGTIF_GUI MATLAB code for RenamingTIF_GUI.fig
%      RENAMINGTIF_GUI, by itself, creates a new RENAMINGTIF_GUI or raises the existing
%      singleton*.
%
%      H = RENAMINGTIF_GUI returns the handle to a new RENAMINGTIF_GUI or the handle to
%      the existing singleton*.
%
%      RENAMINGTIF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RENAMINGTIF_GUI.M with the given input arguments.
%
%      RENAMINGTIF_GUI('Property','Value',...) creates a new RENAMINGTIF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RenamingTIF_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RenamingTIF_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RenamingTIF_GUI

% Last Modified by GUIDE v2.5 30-Sep-2015 12:08:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RenamingTIF_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RenamingTIF_GUI_OutputFcn, ...
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


% --- Executes just before RenamingTIF_GUI is made visible.
function RenamingTIF_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RenamingTIF_GUI (see VARARGIN)

% Choose default command line output for RenamingTIF_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RenamingTIF_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RenamingTIF_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in INPUT.
function INPUT_Callback(hObject, eventdata, handles)
% hObject    handle to INPUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.inputdir = uigetdir2('\\metlab21\MATLAB','Select input directory');
guidata(hObject,handles);

% --- Executes on button press in EXCEL.
function EXCEL_Callback(hObject, eventdata, handles)
% hObject    handle to EXCEL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.file,handles.filepath] = uigetfile('*.*','Select EXCEL file','\\metlab21\MATLAB');
guidata(hObject,handles);

% --- Executes on button press in OUTPUT.
function OUTPUT_Callback(hObject, eventdata, handles)
% hObject    handle to OUTPUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outputdir = uigetdir2('\\metlab21\MATLAB','Select output directory');
guidata(hObject,handles);

% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.excelfile = fullfile(handles.filepath,handles.file);
Renaming_tif(handles.inputdir{1},handles.outputdir{1},handles.excelfile);
