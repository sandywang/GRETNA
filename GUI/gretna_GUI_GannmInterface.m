function varargout = gretna_GUI_GannmInterface(varargin)
% gretna_GUI_GannmInterface MATLAB code for gretna_GUI_GannmInterface.fig
%      gretna_GUI_GannmInterface, by itself, creates a new gretna_GUI_GannmInterface or raises the existing
%      singleton*.
%
%      H = gretna_GUI_GannmInterface returns the handle to a new gretna_GUI_GannmInterface or the handle to
%      the existing singleton*.
%
%      gretna_GUI_GannmInterface('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gretna_GUI_GannmInterface.M with the given input arguments.
%
%      gretna_GUI_GannmInterface('Property','Value',...) creates a new gretna_GUI_GannmInterface or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gretna_GUI_GannmInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gretna_GUI_GannmInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gretna_GUI_GannmInterface

% Last Modified by GUIDE v2.5 21-Feb-2017 01:55:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gretna_GUI_GannmInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @gretna_GUI_GannmInterface_OutputFcn, ...
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


% --- Executes just before gretna_GUI_GannmInterface is made visible.
function gretna_GUI_GannmInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gretna_GUI_GannmInterface (see VARARGIN)

handles.SampleNum=2;

handles.SampleCells={};
handles.CurDir=pwd;
% Choose default command line output for gretna_GUI_GannmInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gretna_GUI_GannmInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function [Lim, Value]=SwitchType(Flag)
switch upper(Flag)
    case 'T1'
        Value=1;     
        Lim=1;
    case 'T2'
        Value=2;
        Lim=2;
    case 'TP'
        Value=3;
        Lim=2;
    case 'F'
        Value=4;
        Lim=10;
    case 'FR'
        Value=5;
        Lim=10;
    case 'R'
        Value=6;
        Lim=4;
end

function handles=StatType(handles)
Value=get(handles.StatPopup, 'Value');
CorrFlag='Off';

BaseFlag='Off';
switch Value
    case 1
        handles.SampleNum=1;
        Prefix='T1';
        BaseFlag='On';
    case 2
        handles.SampleNum=2;
        Prefix='T2';
    case 3
        handles.SampleNum=2;
        Prefix='TP';
    case 4
        handles.SampleNum=10;
        Prefix='F';
    case 5
        handles.SampleNum=10;
        Prefix='FR';
    case 6
        handles.SampleNum=2;
        Prefix='R';
        
        CorrFlag='On';
end

handles=ClearConfigure(handles);

set(handles.BaseLab,   'Visible', BaseFlag);
set(handles.BaseEntry, 'Visible', BaseFlag);
set(handles.PrefixEntry, 'String', Prefix);
%set(handles.CorrSeedListbox,      'Visible', CorrFlag);
%set(handles.CorrSeedRemoveButton, 'Visible', CorrFlag);
%set(handles.CorrSeedAddButton,    'Enable', CorrFlag);
set(handles.CorrSeedFrame,        'Visible', CorrFlag); 

% --- Outputs from this function are returned to the command line.
function varargout = gretna_GUI_GannmInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in StatPopup.
function StatPopup_Callback(hObject, eventdata, handles)
% hObject    handle to StatPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=StatType(handles);

guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns StatPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StatPopup


% --- Executes during object creation, after setting all properties.
function StatPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CovTextListbox.
function CovTextListbox_Callback(hObject, eventdata, handles)
% hObject    handle to CovTextListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CovTextListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CovTextListbox


% --- Executes during object creation, after setting all properties.
function CovTextListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CovTextListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SampleListbox.
function SampleListbox_Callback(hObject, eventdata, handles)
% hObject    handle to SampleListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SampleListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SampleListbox


% --- Executes during object creation, after setting all properties.
function SampleListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CovTextAddButton.
function CovTextAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to CovTextAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Name, Path]=uigetfile({'*.txt;*.csv;*.tsv','Text Covariates File (*.txt;*.csv;*.tsv)';'*.*', 'All Files (*.*)';},...
    'Pick the Text Covariates', 'MultiSelect','on');
if isnumeric(Name)
    return
end

if ischar(Name)
    Name={Name};
end
Name=Name';
PathCell=cellfun(@(name) fullfile(Path, name), Name, 'UniformOutput', false);
AddString(handles.CovTextListbox, PathCell);

% --- Executes on button press in CovTextRemoveButton.
function CovTextRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to CovTextRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.CovTextListbox, 'Value');
if Value==0
    return
end
RemoveString(handles.CovTextListbox, Value);

% --- Executes on button press in SampleAddButton.
function SampleAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to SampleAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if numel(handles.SampleCells)==handles.SampleNum
    warndlg('Invalid Number of Groups');
    return
end

[Name, Path]=uigetfile({'*.txt;*.csv;*.tsv','Sample File (*.txt;*.csv;*.tsv)';'*.*', 'All Files (*.*)';},...
    'Pick the Text Covariates');
if isnumeric(Name)
    return
end

handles.CurDir=Path;

Matrix=load(fullfile(Path, Name));
[NumOfSample, NumOfMetric]=size(Matrix);

handles.SampleCells{numel(handles.SampleCells)+1}=Matrix;
StringOne={sprintf('[%d Samples] {%d Nodes} (%s) %s', NumOfSample, NumOfMetric, Name, Path)};
AddString(handles.SampleListbox, StringOne);
guidata(hObject, handles);

% --- Executes on button press in SampleRemoveButton.
function SampleRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SampleRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.SampleListbox, 'Value');
if Value==0
    return
end
handles.SampleCells(Value)=[];
RemoveString(handles.SampleListbox, Value);
guidata(hObject, handles);


function OutputDirEntry_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=get(handles.OutputDirEntry, 'String');
if exist(Path, 'dir')~=7
    warndlg('Cannot find directory, please create it first!');
    set(handles.OutputDirEntry, 'String', handles.CurDir);
    return
end
handles.CurDir=Path;
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of OutputDirEntry as text
%        str2double(get(hObject,'String')) returns contents of OutputDirEntry as a double


% --- Executes during object creation, after setting all properties.
function OutputDirEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputDirEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OutputDirButton.
function OutputDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.CurDir, 'Pick Output Directory');
if isnumeric(Path)
    return
end
handles.CurDir=Path;
set(handles.OutputDirEntry, 'String', Path);
guidata(hObject, handles);


function PrefixEntry_Callback(hObject, eventdata, handles)
% hObject    handle to PrefixEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PrefixEntry as text
%        str2double(get(hObject,'String')) returns contents of PrefixEntry as a double


% --- Executes during object creation, after setting all properties.
function PrefixEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PrefixEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ComputeButton.
function ComputeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.SampleCells)
    return
end
S=handles.SampleCells;

C=get(handles.CovTextListbox, 'String');
for i=1:numel(C)
    C{i, 1}=load(C{i, 1});
end

NumPerm=str2num(get(handles.PermEntry, 'String'));
if isempty(NumPerm)
    errordlg('Invalid Perm Num');
end

OutputDir=get(handles.OutputDirEntry, 'String');
if isempty(OutputDir)
    OutputDir=fileparts(handles.CurDir);
end
Prefix=get(handles.PrefixEntry, 'String');

gretna_RUN_GANNM(S, C, NumPerm, OutputDir, Prefix)


% --- Executes on button press in HelpButton.
function HelpButton_Callback(hObject, eventdata, handles)
% hObject    handle to HelpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.StatPopup, 'Value');
switch Value
    case 1
        msgbox({'One-Sample T-Test:';...
            'Please specify only one group metric file and corresponding covariate file (e.g., age, if yes).';...
            'Base means the null hypothesis is that the group mean equals to the base value.';...
            },'Help');
    case 2
        msgbox({'Two-Sample T-Test:';...
            'Please specify two group metric files and corresponding covariate files (e.g., brain size, IQ etc., if yes).';...
            'The value of each metric in the output files is a T statistic value (positive means the mean of Group 1 is greater than the mean of Group 2).';...
            },'Help');
    case 3
        msgbox({'Paired T-Test:';...
            'Please specify two paired group metric files and corresponding covariate files (e.g., training scores etc., if yes)';...
            'The value of each metric in the output file is a T statistic value (positive means Condition 1 is greater than Condition 2).';...
            },'Help');        
    case 4
        msgbox({'ANOVA or ANCOVA analysis:';...
            'Please specify three or more group metric files and corresponding covariate files (e.g., brain size, IQ etc., if yes).';...            
            'The value of each metric in the output file is an F statistic value.';...
            },'Help');
    case 5
        msgbox({'ANOVA or ANCOVA analysis (Repeated Measure):';...
            'Please specify three or more paired group metric files and corresponding covariate files (e.g., brain size, IQ etc., if yes).';...            
            'The value of each metric in the output file is an F statistic value.';...
            },'Help');        
    case 6
        msgbox({'Correlation Analysis:';...
            'Please specify only one group metric file, corresponding covariate file (e.g., age, if yes) and also the series correlated with group metric.';...            
            'The value of each metric in the output image is an R statistic value.';...
            },'Help');
end

function handles=ClearConfigure(handles)
set(handles.SampleListbox,   'String', '', 'Value', 0);
handles.SampleCells={};

set(handles.CovTextListbox,  'String', '', 'Value', 0);
set(handles.CorrSeedListbox, 'String', '', 'Value', 0);

set(handles.OutputDirEntry,  'String', '');

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


% --- Executes on selection change in CorrSeedListbox.
function CorrSeedListbox_Callback(hObject, eventdata, handles)
% hObject    handle to CorrSeedListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CorrSeedListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CorrSeedListbox


% --- Executes during object creation, after setting all properties.
function CorrSeedListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CorrSeedListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function BaseEntry_Callback(hObject, eventdata, handles)
% hObject    handle to BaseEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaseEntry as text
%        str2double(get(hObject,'String')) returns contents of BaseEntry as a double


% --- Executes during object creation, after setting all properties.
function BaseEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaseEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PEntry_Callback(hObject, eventdata, handles)
% hObject    handle to PEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PEntry as text
%        str2double(get(hObject,'String')) returns contents of PEntry as a double


% --- Executes during object creation, after setting all properties.
function PEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CorrectPopup.
function CorrectPopup_Callback(hObject, eventdata, handles)
% hObject    handle to CorrectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.CorrectPopup, 'Value');
PorQString='p';
if Value==2 %FDR
    PorQString='q';
end
set(handles.PLabel, 'String', PorQString);
% Hints: contents = cellstr(get(hObject,'String')) returns CorrectPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CorrectPopup


% --- Executes during object creation, after setting all properties.
function CorrectPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CorrectPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PermEntry_Callback(hObject, eventdata, handles)
% hObject    handle to PermEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PermEntry as text
%        str2double(get(hObject,'String')) returns contents of PermEntry as a double


% --- Executes during object creation, after setting all properties.
function PermEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PermEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
