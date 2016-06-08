function varargout = Multi_Generation_Batch_GUI(varargin)
% MULTI_GENERATION_BATCH_GUI MATLAB code for Multi_Generation_Batch_GUI.fig
%      MULTI_GENERATION_BATCH_GUI, by itself, creates a new MULTI_GENERATION_BATCH_GUI or raises the existing
%      singleton*.
%
%      H = MULTI_GENERATION_BATCH_GUI returns the handle to a new MULTI_GENERATION_BATCH_GUI or the handle to
%      the existing singleton*.
%
%      MULTI_GENERATION_BATCH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTI_GENERATION_BATCH_GUI.M with the given input arguments.
%
%      MULTI_GENERATION_BATCH_GUI('Property','Value',...) creates a new MULTI_GENERATION_BATCH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Multi_Generation_Batch_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Multi_Generation_Batch_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Multi_Generation_Batch_GUI

% Last Modified by GUIDE v2.5 23-May-2016 14:19:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Multi_Generation_Batch_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Multi_Generation_Batch_GUI_OutputFcn, ...
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


% --- Executes just before Multi_Generation_Batch_GUI is made visible.
function Multi_Generation_Batch_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Multi_Generation_Batch_GUI (see VARARGIN)

% Choose default command line output for Multi_Generation_Batch_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Multi_Generation_Batch_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Multi_Generation_Batch_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Select_Imaris.
function Select_Imaris_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Imaris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnumeric(handles.loop) == 0
    disp('Input must be numeric');
end
handles.imarisdirs{1} = uigetdir2('\\metlab21\MATLAB','Select Imaris folder');
[pathstr,name,ext] = fileparts(char(handles.imarisdirs{1}));
for i = 1:handles.loop-1
    handles.imarisdirs{i+1} = uigetdir2(pathstr,'Select Imaris folder');
end
for i = 1:handles.loop
    handles.imarisdirs{i} = char(handles.imarisdirs{i});
end
set(handles.ImarisList,'String',handles.imarisdirs');
guidata(hObject,handles);

% --- Executes on button press in Outdir_matfiles.
function Outdir_matfiles_Callback(hObject, eventdata, handles)
% hObject    handle to Outdir_matfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnumeric(handles.loop) == 0
    disp('Input must be numeric');
end
handles.matdirs{1} = uigetdir2(handles.outpathstr,'Select Output directory for the matlab files');
[handles.outpathstr,name,ext] = fileparts(char(handles.matdirs{1}));
for i = 1:handles.loop-1
    handles.matdirs{i+1} = uigetdir2(handles.outpathstr,'Select Output directory for the matlab files');
end
for i = 1: handles.loop
    handles.matdirs{i} = char(handles.matdirs{i});
end
set(handles.OutmatList,'String',handles.matdirs');
guidata(hObject,handles);

% --- EXECUTES!!! on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%{
handles.Tint = handles.Tint(:);
handles.Tint(isnan(handles.Tint)) = [];
handles.Decision = handles.Decision(:);
handles.Decision(isnan(handles.Decision)) = [];
%}
Multi_Generation_Batch ( handles.FullLayName, handles.datadirs ,handles.Spars, cell2mat(handles.normalize) , cell2mat(handles.ND),handles.User_Defined_Num_Of_Groups,cell2mat(handles.IntensityAnalysis))
rmpath(genpath(pwd));

% --- Executes on button press in Select_Renaming.
function Select_Renaming_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Renaming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnumeric(handles.loop) == 0
    disp('Input must be numeric');
end
[handles.FileReName{1},handles.PathReName{1}] = uigetfile('*.*','Choose file to load :','\\metlab22\G\RawGigaData\GigaDataLayout\Software\ImarisMatlabSPSS\ExperimentTemplets\Excel Templates');
handles.PathReName{1} = handles.PathReName{1}(1:end-1);
for i = 2:handles.loop
    [handles.FileReName{i},handles.PathReName{i}] = uigetfile('*.*','Choose file to load :',handles.PathReName{i-1});
end
set(handles.RenamingList,'String',handles.FileReName);
guidata(hObject,handles);

% --- Executes on button press in Select_Layout.
function Select_Layout_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath(pwd));
try
    load('Control.mat');
catch
    errordlg('No control file was found in path. Please create control file');
    error('No control file found');
end
if isnumeric(handles.loop) == 0
    disp('Input must be numeric');
end
handles.FullLayName{1} = uigetdir2(Control.Location_of_Layout_Excels,'Select input directory');
for i = 1:handles.loop-1
    handles.FullLayName{i+1} = uigetdir2(Control.Location_of_Layout_Excels,'Select input directory');
end
for i = 1:handles.loop
    handles.FullLayName{i} = char(handles.FullLayName{i});
end
set(handles.LayoutList,'String',handles.FullLayName');
guidata(hObject,handles);

% --- Executes on button press in Outdir_data.
function Outdir_data_Callback(hObject, eventdata, handles)
% hObject    handle to Outdir_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath(genpath(pwd));
try
    load('Control.mat');
catch
    errordlg('No control file was found in path. Please create control file');
    error('No control file found');
end
if isnumeric(handles.loop) == 0
    disp('Input must be numeric');
end
handles.datadirs{1} = uigetdir2(Control.Location_of_Outputs,'Select output location for the data');
for i = 1:handles.loop-1
    handles.datadirs{i+1} = uigetdir2(Control.Location_of_Outputs,'Select output directory for the data');
end
for i = 1:handles.loop
    handles.datadirs{i} = char(handles.datadirs{i});
end
set(handles.OutdataList,'String',handles.datadirs');

guidata(hObject,handles);

% --- Executes on selection change in ImarisList.
function ImarisList_Callback(hObject, eventdata, handles)
% hObject    handle to ImarisList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImarisList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImarisList
%{
for i = 1:handles.loop
    imarislist(i) = handles.imarisdirs{i};
end
%}
set(hObject,'String',handles.imarisdirs');
%{
contents = cellstr(get(hObject,'String'));
handles.Arrange.pick = cellstr(contents(get(hObject,'Value')));
%}
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ImarisList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImarisList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RenamingList.
function RenamingList_Callback(hObject, eventdata, handles)
% hObject    handle to RenamingList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RenamingList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RenamingList
%set(hObject,'String',handles.FileReName);
contents = cellstr(get(hObject,'String'));
handles.ArrangeRename = cellstr(contents(get(hObject,'Value')));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function RenamingList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RenamingList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OutdataList.
function OutdataList_Callback(hObject, eventdata, handles)
% hObject    handle to OutdataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OutdataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OutdataList
%{
for i = 1:handles.loop
    outdatalist(i) = handles.datadirs{i}
end
%}
%set(handles.OutdataList,'String',handles.datadirs');
%{
contents = cellstr(get(hObject,'String'));
handles.Arrange.pick = cellstr(contents(get(hObject,'Value')));
%}
%guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function OutdataList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutdataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OutmatList.
function OutmatList_Callback(hObject, eventdata, handles)
% hObject    handle to OutmatList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OutmatList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OutmatList
%{
for i = 1:handles.loop
    outmatlist(i) = handles.matdirs{i};
end
%}
%set(handles.OutmatList,'String',handles.matdirs');
%{
contents = cellstr(get(hObject,'String'));
handles.Arrange.pick = cellstr(contents(get(hObject,'Value')));
%}
%guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function OutmatList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutmatList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LayoutList.
function LayoutList_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LayoutList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LayoutList
%set(hObject,'String',handles.FileLayName);
%{
contents = cellstr(get(hObject,'String'));
handles.Arrange.pick = cellstr(contents(get(hObject,'Value')));
%}
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function LayoutList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LayoutList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnumeric(handles.loop) == 0
    disp('Input must be numeric');
end
handles.outRename{1} = uigetdir2('\\Metlab21\MATLAB','Choose directory');
[handles.outpathstr,~,~] = fileparts(char(handles.outRename{1}));
for i = 1:handles.loop-1
    handles.outRename{i+1} = uigetdir2(handles.outpathstr,'Select output directory for renaming process');
end
for i = 1:handles.loop
    handles.outRename{i} = char(handles.outRename{i});
end
set(handles.OutRenameList,'String',handles.outRename');
guidata(hObject,handles);

% --- Executes on selection change in OutRenameList.
function OutRenameList_Callback(hObject, eventdata, handles)
% hObject    handle to OutRenameList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OutRenameList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OutRenameList
%{
for i = 1:handles.loop
    outrename(i) = handles.outRename{i};
end
%}
%set(handles.OutRenameList,'String',handles.outRename');
%guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function OutRenameList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutRenameList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Loop_Callback(hObject, eventdata, handles)
% hObject    handle to Loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Loop as text
%        str2double(get(hObject,'String')) returns contents of Loop as a double
handles.loop = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Loop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%{
% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Tint = get(hObject,'data');
Tint = Tint(:);
Tint(strcmp(Tint,'NaN')) = [];
handles.Tint = str2double(Tint);
guidata(hObject,handles);


% --- Executes when entered data in editable cell(s) in ScatterTable.
function ScatterTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ScatterTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Decision = get(hObject,'data');
Decision = Decision(:);
Decision(strcmp(Decision,'NaN')) = [];
handles.Decision = str2double(Decision);
guidata(hObject,handles);
%}

% --- Executes on button press in ScatterScratch.
function ScatterScratch_Callback(hObject, eventdata, handles)
% hObject    handle to ScatterScratch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loop
    prompt = 'Enter 1 for Scatter or 0 for Scratch';
    title = 'Scatter\Scratch';
    answer = inputdlg(prompt,title);
    handles.ss{i} = str2double(answer{1});
end
set(handles.sslist,'String',handles.ss');
guidata(hObject,handles);

% --- Executes on button press in TimeIntervals.
function TimeIntervals_Callback(hObject, eventdata, handles)
% hObject    handle to TimeIntervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loop
    prompt = 'Enter one time interval';
    title = 'Time Interval';
    answer = inputdlg(prompt,title);
    handles.int{i} = str2double(answer{1});
end
set(handles.tilist,'String',handles.int');
guidata(hObject,handles);


% --- Executes on selection change in sslist.
function sslist_Callback(hObject, eventdata, handles)
% hObject    handle to sslist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sslist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sslist
%set(handles.sslist,'String',handles.ss');
%guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sslist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sslist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tilist.
function tilist_Callback(hObject, eventdata, handles)
% hObject    handle to tilist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tilist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tilist
%set(handles.tilist,'String',handles.int');
%guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function tilist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tilist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loop
    prompt = 'Enter 1 if you wish to perform intensity analysis, enter 0 otherwise';
    title = 'Intensity Analysis';
    answer = inputdlg(prompt,title);
    handles.IntensityAnalysis{i} = str2double(answer{1});
end
set(handles.listbox10,'String',handles.IntensityAnalysis');
guidata(hObject,handles);

% --- Executes on selection change in listbox10.
function listbox10_Callback(hObject, eventdata, handles)
% hObject    handle to listbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox10


% --- Executes during object creation, after setting all properties.
function listbox10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox11.
function listbox11_Callback(hObject, eventdata, handles)
% hObject    handle to listbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox11


% --- Executes during object creation, after setting all properties.
function listbox11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loopTreats
    prompt = 'Enter treatment name';
    title = 'Treatments';
    answer = inputdlg(prompt,title);
    handles.Spars{i} = answer{1};
end
set(handles.listbox11,'String',handles.Spars');
guidata(hObject,handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loop
    prompt = 'Enter number of dimentions';
    title = 'Number Of Dimentions';
    answer = inputdlg(prompt,title);
    handles.ND{i} = str2double(answer{1});
end
set(handles.listbox12,'String',handles.ND');
guidata(hObject,handles);


% --- Executes on selection change in listbox12.
function listbox12_Callback(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox12


% --- Executes during object creation, after setting all properties.
function listbox12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loop
    prompt = 'Enter 1 for parmeter comparision';
    title = 'Par1 vs Par2';
    answer = inputdlg(prompt,title);
    handles.par1vspar2{i} = str2double(answer{1});
end
set(handles.listbox13,'String', handles.par1vspar2');
guidata(hObject,handles);

% --- Executes on selection change in listbox13.
function listbox13_Callback(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox13


% --- Executes during object creation, after setting all properties.
function listbox13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:handles.loop
    prompt = 'Enter 1 to normalize or 0 otherwise';
    title = 'Normalize';
    answer = inputdlg(prompt,title);
    handles.normalize{i} = str2double(answer{1});
end
set(handles.listbox14,'String',handles.normalize');
guidata(hObject,handles);

% --- Executes on selection change in listbox14.
function listbox14_Callback(hObject, eventdata, handles)
% hObject    handle to listbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox14


% --- Executes during object creation, after setting all properties.
function listbox14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
handles.loopTreats = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox16.
function listbox16_Callback(hObject, eventdata, handles)
% hObject    handle to listbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox16


% --- Executes during object creation, after setting all properties.
function listbox16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1 : 3
    prompt = 'Enter group size';
    title = 'Group size';
    answer = inputdlg(prompt,title);
    handles.User_Defined_Num_Of_Groups(i) = str2double(answer{1});
end
set(handles.listbox17,'String',handles.User_Defined_Num_Of_Groups');
guidata(hObject,handles);

% --- Executes on selection change in listbox17.
function listbox17_Callback(hObject, eventdata, handles)
% hObject    handle to listbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox17


% --- Executes during object creation, after setting all properties.
function listbox17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
