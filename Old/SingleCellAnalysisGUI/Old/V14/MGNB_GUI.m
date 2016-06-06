function varargout = MGNB_GUI(varargin)
% MGNB_GUI MATLAB code for MGNB_GUI.fig
%      MGNB_GUI, by itself, creates a new MGNB_GUI or raises the existing
%      singleton*.
%
%      H = MGNB_GUI returns the handle to a new MGNB_GUI or the handle to
%      the existing singleton*.
%
%      MGNB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MGNB_GUI.M with the given input arguments.
%
%      MGNB_GUI('Property','Value',...) creates a new MGNB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MGNB_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MGNB_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MGNB_GUI

% Last Modified by GUIDE v2.5 15-Feb-2016 14:09:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MGNB_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MGNB_GUI_OutputFcn, ...
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


% --- Executes just before MGNB_GUI is made visible.
function MGNB_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MGNB_GUI (see VARARGIN)

% Choose default command line output for MGNB_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MGNB_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MGNB_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Layout.
function Layout_Callback(hObject, eventdata, handles)
% hObject    handle to Layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.layout{1},handles.layoutpath{1}] = uigetfile('*.*','Select layout excel file','\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\ExperimentTemplets\Excel Templates');
handles.lay{1} = fullfile(handles.layoutpath{1},handles.layout{1});
handles.Concatante = 0;
handles.intensityAnalysis = 0;
handles.ND = 2;
handles.par1vspar2 = 0;
guidata(hObject,handles);


% --- Executes on button press in outputfolder.
function outputfolder_Callback(hObject, eventdata, handles)
% hObject    handle to outputfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outdir{1} = uigetdir2('\\metlab21\Matlab');
guidata(hObject,handles);


% --- Executes on button press in Scratch_Scatter.
function Scratch_Scatter_Callback(hObject, eventdata, handles)
% hObject    handle to Scratch_Scatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Scratch_Scatter
handles.choice = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in Intensity.
function Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Intensity
handles.intensityAnalysis = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in Concat.
function Concat_Callback(hObject, eventdata, handles)
% hObject    handle to Concat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Concat
handles.Concatante = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in ND.
function ND_Callback(hObject, eventdata, handles)
% hObject    handle to ND (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ND
handles.ND = 3;
guidata(hObject,handles);


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~isfield(handles,'choice')
    MGNB(handles.lay,handles.outdir,0,handles.intensityAnalysis,handles.Concatante,handles.ND);
else
    MGNB(handles.lay,handles.outdir,handles.choice,handles.intensityAnalysis,handles.Concatante,handles.ND);
end
