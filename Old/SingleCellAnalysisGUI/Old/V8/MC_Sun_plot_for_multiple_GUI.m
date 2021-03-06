function varargout = MC_Sun_plot_for_multiple_GUI(varargin)
% MC_SUN_PLOT_FOR_MULTIPLE_GUI MATLAB code for MC_Sun_plot_for_multiple_GUI.fig
%      MC_SUN_PLOT_FOR_MULTIPLE_GUI, by itself, creates a new MC_SUN_PLOT_FOR_MULTIPLE_GUI or raises the existing
%      singleton*.
%
%      H = MC_SUN_PLOT_FOR_MULTIPLE_GUI returns the handle to a new MC_SUN_PLOT_FOR_MULTIPLE_GUI or the handle to
%      the existing singleton*.
%
%      MC_SUN_PLOT_FOR_MULTIPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MC_SUN_PLOT_FOR_MULTIPLE_GUI.M with the given input arguments.
%
%      MC_SUN_PLOT_FOR_MULTIPLE_GUI('Property','Value',...) creates a new MC_SUN_PLOT_FOR_MULTIPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MC_Sun_plot_for_multiple_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MC_Sun_plot_for_multiple_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MC_Sun_plot_for_multiple_GUI

% Last Modified by GUIDE v2.5 31-Aug-2015 08:42:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MC_Sun_plot_for_multiple_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MC_Sun_plot_for_multiple_GUI_OutputFcn, ...
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


% --- Executes just before MC_Sun_plot_for_multiple_GUI is made visible.
function MC_Sun_plot_for_multiple_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MC_Sun_plot_for_multiple_GUI (see VARARGIN)

% Choose default command line output for MC_Sun_plot_for_multiple_GUI
handles.foldername = NaN;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MC_Sun_plot_for_multiple_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MC_Sun_plot_for_multiple_GUI_OutputFcn(hObject, eventdata, handles) 
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
handles.foldername = uigetdir2('\\metlab21\MATLAB','');
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MC_Sun_plot_for_multiple(handles.foldername{1});
