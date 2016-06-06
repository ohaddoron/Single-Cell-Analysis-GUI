function varargout = Rename_for_Renaming_GUI(varargin)
% RENAME_FOR_RENAMING_GUI MATLAB code for Rename_for_Renaming_GUI.fig
%      RENAME_FOR_RENAMING_GUI, by itself, creates a new RENAME_FOR_RENAMING_GUI or raises the existing
%      singleton*.
%
%      H = RENAME_FOR_RENAMING_GUI returns the handle to a new RENAME_FOR_RENAMING_GUI or the handle to
%      the existing singleton*.
%
%      RENAME_FOR_RENAMING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RENAME_FOR_RENAMING_GUI.M with the given input arguments.
%
%      RENAME_FOR_RENAMING_GUI('Property','Value',...) creates a new RENAME_FOR_RENAMING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rename_for_Renaming_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rename_for_Renaming_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Rename_for_Renaming_GUI

% Last Modified by GUIDE v2.5 15-Dec-2015 17:34:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rename_for_Renaming_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Rename_for_Renaming_GUI_OutputFcn, ...
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


% --- Executes just before Rename_for_Renaming_GUI is made visible.
function Rename_for_Renaming_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rename_for_Renaming_GUI (see VARARGIN)

% Choose default command line output for Rename_for_Renaming_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Rename_for_Renaming_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Rename_for_Renaming_GUI_OutputFcn(hObject, eventdata, handles) 
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
folderPath = uigetdir2('\\metlab21\MATLAB','');
handles.folderPath = folderPath{1};
guidata(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,filePath] = uigetfile('*.*');
handles.xlsPath = [filePath fileName];
guidata(hObject,handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Rename_for_Renaming(handles.folderPath,handles.xlsPath);
