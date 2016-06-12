function varargout = gretna_GUI_PlotBBVInterface(varargin)
% GRETNA_GUI_PLOTBBVINTERFACE MATLAB code for gretna_GUI_PlotBBVInterface.fig
%      GRETNA_GUI_PLOTBBVINTERFACE, by itself, creates a new GRETNA_GUI_PLOTBBVINTERFACE or raises the existing
%      singleton*.
%
%      H = GRETNA_GUI_PLOTBBVINTERFACE returns the handle to a new GRETNA_GUI_PLOTBBVINTERFACE or the handle to
%      the existing singleton*.
%
%      GRETNA_GUI_PLOTBBVINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRETNA_GUI_PLOTBBVINTERFACE.M with the given input arguments.
%
%      GRETNA_GUI_PLOTBBVINTERFACE('Property','Value',...) creates a new GRETNA_GUI_PLOTBBVINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gretna_GUI_PlotBBVInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gretna_GUI_PlotBBVInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gretna_GUI_PlotBBVInterface

% Last Modified by GUIDE v2.5 24-May-2016 16:59:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gretna_GUI_PlotBBVInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @gretna_GUI_PlotBBVInterface_OutputFcn, ...
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


% --- Executes just before gretna_GUI_PlotBBVInterface is made visible.
function gretna_GUI_PlotBBVInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gretna_GUI_PlotBBVInterface (see VARARGIN)

% Choose default command line output for gretna_GUI_PlotBBVInterface
handles.output = hObject;
handles.MainFig=hObject;
handles.TypePopupValue=1;
handles.SampleCells={};
handles.GnameCells={};
handles.LnameCells={};
handles.CurDir=pwd;
handles.OutputDir=pwd;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gretna_GUI_PlotBBVInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gretna_GUI_PlotBBVInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function OutputDirEty_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=get(handles.OutputDirEty, 'String');
if exist(Path, 'dir')~=7
    warndlg('Cannot find directory, please create it first!');
    set(handles.OutputDirEty, 'String', handles.OutputDir);    
    return
end
handles.OutputDir=Path;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of OutputDirEty as text
%        str2double(get(hObject,'String')) returns contents of OutputDirEty as a double


% --- Executes during object creation, after setting all properties.
function OutputDirEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OutputDirBtn.
function OutputDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.OutputDir, 'Pick Output Directory');
if isnumeric(Path)
    return
end
%handles.CurDir=fileparts(Path);
handles.OutputDir=Path;
set(handles.OutputDirEty, 'String', Path);
guidata(hObject, handles);

function OutputFileEty_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFileEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputFileEty as text
%        str2double(get(hObject,'String')) returns contents of OutputFileEty as a double


% --- Executes during object creation, after setting all properties.
function OutputFileEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputFileEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotBtn.
function PlotBtn_Callback(hObject, eventdata, handles)
% hObject    handle to PlotBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.SampleCells)
    warndlg('No Sample!');
    return
end

OutputDir=handles.OutputDir;
OutputFile=get(handles.OutputFileEty, 'String');
DPI=get(handles.DPIEty, 'String');

PlotValue=get(handles.TypePopup, 'Value');

EBValue=get(handles.SDPopup, 'Value');
if PlotValue==3
    switch EBValue
        case 1
            EBType='dot';
        case 2
            EBType='box';
    end
else
    switch EBValue
        case 1
            EBType='sd';
        case 2
            EBType='sem';
        case 3
            EBType='ci';
    end    
end

switch PlotValue
    case 1 %Bar
        H=figure; gretna_plot_bar(handles.SampleCells,...
            handles.GnameCells,...
            handles.LnameCells,...
            EBType)
    case 2 %Dot
        H=figure; gretna_plot_dot(handles.SampleCells,...
            handles.GnameCells,...
            handles.LnameCells,...
            EBType)
    case 3 %Violin
        H=figure; gretna_plot_violin(handles.SampleCells,...
            handles.GnameCells,...
            handles.LnameCells,...
            EBType)
    case 4 %Shade
        CNum=numel(handles.LnameCells);
        CData=1:CNum;
        H=figure; gretna_plot_shade(CData,...
            handles.SampleCells,...
            handles.GnameCells,...
            0.4,...
            EBType)
        set(gca, 'XTick', 1:CNum, 'XTickLabel', handles.LnameCells);
end
OutputFullPath=fullfile(OutputDir, [OutputFile, '.tif']);

print(OutputFullPath, '-r300', '-dtiff', '-noui', sprintf('-f%d', H));


function DPIEty_Callback(hObject, eventdata, handles)
% hObject    handle to DPIEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DPIEty as text
%        str2double(get(hObject,'String')) returns contents of DPIEty as a double


% --- Executes during object creation, after setting all properties.
function DPIEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DPIEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TypePopup.
function TypePopup_Callback(hObject, eventdata, handles)
% hObject    handle to TypePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.TypePopup, 'Value');
if handles.TypePopupValue==Value
    return
end

handles.TypePopupValue=Value;
if Value==3
    SDList={'Error Bar -> Dot';...
        'Error Bar => Box'};    
else
    SDList={'Error Bar -> Standard Deviation (SD)';...
        'Error Bar -> Standard Error of the Mean (SEM)';...
        'Error Bar -> 95% Confidence Interval (CI)'};
end
%handles.SampleCells={};
%handles.GnameCells={};
if isempty(handles.SampleCells)
    set(handles.InputListbox, 'Value', 0);
else
    set(handles.InputListbox, 'Value', 1);
end
set(handles.SDPopup, 'Value', 1, 'String', SDList);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns TypePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TypePopup


% --- Executes during object creation, after setting all properties.
function TypePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in InputListbox.
function InputListbox_Callback(hObject, eventdata, handles)
% hObject    handle to InputListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InputListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InputListbox


% --- Executes during object creation, after setting all properties.
function InputListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GroupNameBtn.
function GroupNameBtn_Callback(hObject, eventdata, handles)
% hObject    handle to GroupNameBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NameCells=handles.GnameCells;
if isempty(NameCells)
    warndlg('No Sample!');
    return
end
NumOfVar=numel(NameCells);
Title='Group Names';
Prompt=[];
for i=1:NumOfVar
    Prompt=[Prompt, {sprintf('Group %d:', i)}];
end
Answer=inputdlg(Prompt, Title, 1, NameCells);
if isempty(Answer)
    return
end
handles.GnameCells=Answer';
guidata(hObject, handles);

% --- Executes on button press in VarNameBtn.
function VarNameBtn_Callback(hObject, eventdata, handles)
% hObject    handle to VarNameBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NameCells=handles.LnameCells;
if isempty(NameCells)
    warndlg('No Sample!');
    return
end
NumOfVar=numel(NameCells);
Title='Group Names';
Prompt=[];
for i=1:NumOfVar
    Prompt=[Prompt, {sprintf('Variable %d:', i)}];
end
Answer=inputdlg(Prompt, Title, 1, NameCells);
if isempty(Answer)
    return
end
handles.LnameCells=Answer';
guidata(hObject, handles);

% --- Executes on button press in RemoveBtn.
function RemoveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.InputListbox, 'Value');
if Value==0
    return
end
handles.SampleCells(Value)=[];
handles.GnameCells(Value)=[];
if isempty(handles.SampleCells)
    handles.LnameCells={};
end
RemoveString(handles.InputListbox, Value);
guidata(hObject, handles);

% --- Executes on button press in AddBtn.
function AddBtn_Callback(hObject, eventdata, handles)
% hObject    handle to AddBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Name, Path]=uigetfile({'*.txt;*.csv;*.tsv','Sample File (*.txt;*.csv;*.tsv)';'*.*', 'All Files (*.*)';},...
    'Pick the sample you want to plot.', handles.CurDir);
if isnumeric(Name) && Name==0
    return
end

handles.CurDir=Path;

Matrix=load(fullfile(Path, Name));
[NumOfSample, NumOfMetric]=size(Matrix);

handles.SampleCells{numel(handles.SampleCells)+1}=Matrix;
handles.GnameCells{numel(handles.GnameCells)+1}='';
if isempty(handles.LnameCells)
    EmptyCells=cell(1, size(Matrix, 2));
    handles.LnameCells=cellfun(@ (x) '', EmptyCells, 'UniformOutput', false);
end
StringOne={sprintf('[%d]{%d} (%s) %s', NumOfSample, NumOfMetric, Name, Path)};
AddString(handles.InputListbox, StringOne);
guidata(hObject, handles);

% --- Executes on selection change in SDPopup.
function SDPopup_Callback(hObject, eventdata, handles)
% hObject    handle to SDPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SDPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SDPopup


% --- Executes during object creation, after setting all properties.
function SDPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AddString(ListboxHandle, NewCell)
StringCell=get(ListboxHandle, 'String');
StringCell=[StringCell; NewCell];
set(ListboxHandle, 'String', StringCell, 'Value', numel(StringCell));

function RemoveString(ListboxHandle, Value)
StringCell=get(ListboxHandle, 'String');
StringCell(Value)=[];
if isempty(StringCell)
    Value=0;
end
if Value > numel(StringCell)
    Value=Value-1;
end
set(ListboxHandle, 'String', StringCell, 'Value', Value);
