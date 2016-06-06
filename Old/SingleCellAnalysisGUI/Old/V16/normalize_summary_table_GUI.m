function varargout = normalize_summary_table_GUI(varargin)
% NORMALIZE_SUMMARY_TABLE_GUI MATLAB code for normalize_summary_table_GUI.fig
%      NORMALIZE_SUMMARY_TABLE_GUI, by itself, creates a new NORMALIZE_SUMMARY_TABLE_GUI or raises the existing
%      singleton*.
%
%      H = NORMALIZE_SUMMARY_TABLE_GUI returns the handle to a new NORMALIZE_SUMMARY_TABLE_GUI or the handle to
%      the existing singleton*.
%
%      NORMALIZE_SUMMARY_TABLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NORMALIZE_SUMMARY_TABLE_GUI.M with the given input arguments.
%
%      NORMALIZE_SUMMARY_TABLE_GUI('Property','Value',...) creates a new NORMALIZE_SUMMARY_TABLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before normalize_summary_table_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to normalize_summary_table_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help normalize_summary_table_GUI

% Last Modified by GUIDE v2.5 04-Jan-2016 16:26:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @normalize_summary_table_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @normalize_summary_table_GUI_OutputFcn, ...
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


% --- Executes just before normalize_summary_table_GUI is made visible.
function normalize_summary_table_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to normalize_summary_table_GUI (see VARARGIN)

% Choose default command line output for normalize_summary_table_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes normalize_summary_table_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = normalize_summary_table_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in summary_table_path.
function summary_table_path_Callback(hObject, eventdata, handles)
% hObject    handle to summary_table_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('\\metlab21\MATLAB','Choose file to load :','*.*');
handles.summary_table_path = [PathName '\' FileName];
[~,text,~] = xlsread(handles.summary_table_path);
t = text(1,:);
t(1) = [];
set(handles.exp_names,'String',t');
guidata(hObject,handles);

% --- Executes on selection change in exp_names.
function exp_names_Callback(hObject, eventdata, handles)
% hObject    handle to exp_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns exp_names contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exp_names
contents = cellstr(get(hObject,'String'));
exp_name = contents{get(hObject,'Value')};
handles.normalizing_exp_name = exp_name;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function exp_names_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in output_location.
function output_location_Callback(hObject, eventdata, handles)
% hObject    handle to output_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outputLocation = uigetdir2('\\metlab21\MATLAB','');
handles.outputLocation = outputLocation{1};
guidata(hObject,handles);

% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
normalize_summary_table ( handles.summary_table_path, handles.normalizing_exp_name, handles.outputLocation )
