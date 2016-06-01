function varargout = ClusterAnalysis_GUI(varargin)
% CLUSTERANALYSIS_GUI MATLAB code for ClusterAnalysis_GUI.fig
%      CLUSTERANALYSIS_GUI, by itself, creates a new CLUSTERANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = CLUSTERANALYSIS_GUI returns the handle to a new CLUSTERANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      CLUSTERANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLUSTERANALYSIS_GUI.M with the given input arguments.
%
%      CLUSTERANALYSIS_GUI('Property','Value',...) creates a new CLUSTERANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ClusterAnalysis_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ClusterAnalysis_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ClusterAnalysis_GUI

% Last Modified by GUIDE v2.5 25-May-2016 20:50:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ClusterAnalysis_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ClusterAnalysis_GUI_OutputFcn, ...
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


% --- Executes just before ClusterAnalysis_GUI is made visible.
function ClusterAnalysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ClusterAnalysis_GUI (see VARARGIN)

% Choose default command line output for ClusterAnalysis_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ClusterAnalysis_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ClusterAnalysis_GUI_OutputFcn(hObject, eventdata, handles) 
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
addpath(genpath(pwd));
try
    load('Control.mat');
catch
    errordlg('No control file was found in path. Please create control file');
    error('No control file found');
end

handles.folderPath = uigetdir2(Control.Location_of_Outputs,'Select Imaris folder');
rmpath(genpath(pwd));
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ClusterAnalysis(handles.folderPath{1},1);
