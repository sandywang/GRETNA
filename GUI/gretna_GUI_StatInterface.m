function varargout = gretna_GUI_StatInterface(varargin)
% gretna_GUI_StatInterface MATLAB code for gretna_GUI_StatInterface.fig
%      gretna_GUI_StatInterface, by itself, creates a new gretna_GUI_StatInterface or raises the existing
%      singleton*.
%
%      H = gretna_GUI_StatInterface returns the handle to a new gretna_GUI_StatInterface or the handle to
%      the existing singleton*.
%
%      gretna_GUI_StatInterface('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gretna_GUI_StatInterface.M with the given input arguments.
%
%      gretna_GUI_StatInterface('Property','Value',...) creates a new gretna_GUI_StatInterface or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gretna_GUI_StatInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gretna_GUI_StatInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gretna_GUI_StatInterface

% Last Modified by GUIDE v2.5 15-Jun-2014 04:43:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gretna_GUI_StatInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @gretna_GUI_StatInterface_OutputFcn, ...
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


% --- Executes just before gretna_GUI_StatInterface is made visible.
function gretna_GUI_StatInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gretna_GUI_StatInterface (see VARARGIN)
if nargin > 3
    Flag=varargin{1};
else
    Flag='T1';
end
[handles.SampleNum, Value]=SwitchType(Flag);
set(handles.StatPopup, 'Value', Value);
handles=StatType(handles);
%handles=ClearConfigure(handles);
handles.SampleCells={};
handles.CovImageCells={};
handles.CurDir=pwd;

% Choose default command line output for gretna_GUI_StatInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gretna_GUI_StatInterface wait for user response (see UIRESUME)
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
        Prefix='T';
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
function varargout = gretna_GUI_StatInterface_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in CovImageAddButton.
function CovImageAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to CovImageAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Path=uigetdir(handles.CurDir, 'Pick Covariate Images Directory');
if isnumeric(Path)
    return
end
[handles.CurDir, Name]=fileparts(Path);

D=dir(fullfile(Path, '*.hdr'));
if isempty(D)
    D=dir(fullfile(Path, '*.nii'));
end

if isempty(D)
    D=dir(fullfile(Path, '*.nii.gz'));
end
NameCell={D.name}';
Num=numel(NameCell);
CovImageCell=cellfun(@(Name) fullfile(Path, Name), NameCell,...
    'UniformOutput', false);
handles.CovImageCells{numel(handles.CovImageCells)+1}=CovImageCell;
StringOne={sprintf('[%d] (%s) %s', Num, Name, Path)};
AddString(handles.CovImageListbox, StringOne);
guidata(hObject, handles);

% --- Executes on button press in CovImageRemoveButton.
function CovImageRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to CovImageRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.CovImageListbox, 'Value');
if Value==0
    return
end
handles.CovImageCells(Value)=[];
RemoveString(handles.CovImageListbox, Value);
guidata(hObject, handles);

% --- Executes on button press in SampleAddButton.
function SampleAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to SampleAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if numel(handles.SampleCells)==handles.SampleNum
    warndlg('Invalid Number of Groups');
    return
end

[Name, Path]=uigetfile({'*.txt;*.csv;*.tsv','Text Covariates File (*.txt;*.csv;*.tsv)';'*.*', 'All Files (*.*)';},...
    'Pick the Text Covariates');
if isnumeric(Name)
    return
end

handles.CurDir=Path;

Matrix=load(fullfile(Path, Name));
[NumOfSample, NumOfMetric]=size(Matrix);

handles.SampleCells{numel(handles.SampleCells)+1}=Matrix;
StringOne={sprintf('[%d]{%d} (%s) %s', NumOfSample, NumOfMetric, Name, Path)};
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


function MaskEntry_Callback(hObject, eventdata, handles)
% hObject    handle to MaskEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaskEntry as text
%        str2double(get(hObject,'String')) returns contents of MaskEntry as a double


% --- Executes during object creation, after setting all properties.
function MaskEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaskEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MaskButton.
function MaskButton_Callback(hObject, eventdata, handles)
% hObject    handle to MaskButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Name, Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';},...
    'Pick the Covariate Images');
if isnumeric(Name)
    return
end
set(handles.MaskEntry, 'String', fullfile(Path, Name));


function OutputDirEntry_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
handles.CurDir=fileparts(Path);
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

TextCell=get(handles.CovTextListbox, 'String');
for i=1:numel(TextCell)
    TextCell{i, 1}=load(TextCell{i, 1});
end

OutputDir=get(handles.OutputDirEntry, 'String');
if isempty(OutputDir)
    OutputDir=fileparts(handles.CurDir);
end
Prefix=get(handles.PrefixEntry, 'String');
OutputT=fullfile(OutputDir, [Prefix, '_T.txt']);
OutputP=fullfile(OutputDir, [Prefix, '_P.txt']);

Value=get(handles.StatPopup, 'Value');
switch Value
    case 1 %One-Sample
        Base=str2double(get(handles.BaseEntry, 'String'));
        if isnan(Base)
            errordlg('Invalid Base Value');
            return
        end
        [T, P]=gretna_TTest1(S, TextCell, Base);
    case 2 %Two-Sample
        [T, P]=gretna_TTest2(S, TextCell);
    case 3 %Paired
        [T, P]=gretna_TTestPaired(S, TextCell);      
    case 4 %ANCOVA
        [T, P]=gretna_ANCOVA1(S, TextCell);
        OutputT=fullfile(OutputDir, [Prefix, '_F.txt']);
    case 5 %ANCOVA Repeat
        [T, P]=gretna_ANCOVA1_Repeated(S, TextCell);
        OutputT=fullfile(OutputDir, [Prefix, '_F.txt']);
    case 6 %Corr
        SeedFile=get(handles.CorrSeedListbox, 'String');
        if iscell(SeedFile)
            SeedFile=SeedFile{1};
        end
        SeedSeries={load(SeedFile)};        
        [T, P]=gretna_Correlation(S, SeedSeries, TextCell);
        OutputT=fullfile(OutputDir, [Prefix, '_R.txt']);
end

Correct=get(handles.CorrectPopup, 'Value');
PThrd=str2double(get(handles.PEntry, 'String'));
if isnan(PThrd)
    errordlg('Invalid P Value');
    return
end

switch Correct
    case 1 %None
        Index = P < PThrd;
        T(~Index)=0;
        P(~Index)=0;
    case 2 %FDR
        [pID, pN]=gretna_FDR(P, PThrd);
        if isempty(pID)
            warndlg('NO Corrected P Values');
            %T=zeros(size(T));
            %P=ones(size(P));
            return
        end
        Index = P < pID;
        T(~Index)=0;
        P(~Index)=0;
    case 3 %Bonferroni
        NumOfMetric=size(S{1}, 2);
        PThrd=PThrd/NumOfMetric;
        Index = P < PThrd;
        T(~Index)=0;
        P(~Index)=0;
end

save(OutputT, 'T', '-ASCII', '-DOUBLE', '-TABS');
save(OutputP, 'P', '-ASCII', '-DOUBLE', '-TABS');

% --- Executes on button press in HelpButton.
function HelpButton_Callback(hObject, eventdata, handles)
% hObject    handle to HelpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.StatPopup, 'Value');
switch Value
    case 1
        msgbox({'One-Sample T-Test:';...
            'Please specify the group images (Only one group)';...
            'Base means the null hypothesis is that the group mean equals to the base value. Default: 0';...
            'The degree of freedom information is stored in the header of the output image file.';...
            },'Help');
    case 2
        msgbox({'Two-Sample T-Test:';...
            'If only the group images are specified, then perform voxel-wise Two-Sample T-Test.';...
            'If the covariate images are also specified (e.g. gray matter proportion images), then voxel-wise Two-Sample T-Test is performed while take each voxel in the covariate images as a covaraite. Please make sure the correspondence between the group images and the covariate images.';...
            'Text covariate can be also specified as text files. (E.g. age, brain size, IQ etc.)';...
            'The value of each voxel in the output image is a T statistic value (positive means the mean of Group 1 is greater than the mean of Group 2). The degree of freedom information is stored in the header of the output image file.';...
            },'Help');
    case 3
        msgbox({'Paired T-Test:';...
            'Paired T-Test is performed between the two conditions. Please make sure the correspondence of the images between the two paired conditions.';...
            'The value of each voxel in the output image is a T statistic value (positive means Condition 1 is greater than Condition 2). The degree of freedom information is stored in the header of the output image file.';...
            },'Help');        
    case 4
        msgbox({'ANOVA or ANCOVA analysis:';...
            'If only the group images are specified, then perform voxel-wise ANOVA analysis.';...
            'If the covariate images are also specified (e.g. gray matter proportion images), then voxel-wise ANCOVA analysis is performed while take each voxel in the covariate images as a covaraite. Please make sure the correspondence between the group images and the covariate images.';...
            'Text covariate can be also specified as text files. (E.g. age, brain size, IQ etc.)';...
            'The value of each voxel in the output image is an F statistic value. The degree of freedom information is stored in the header of the output image file.';...
            },'Help');
    case 6
        msgbox({'Correlation Analysis:';...
            'If only the group images and the seed variate are specified, then perform Pearson''s correlation analysis.';...
            'If the covariate images are also specified (e.g. gray matter proportion images), then partial correlation analysis is performed while take each voxel in the covariate images as a covaraite. Please make sure the correspondence between the group images and the covariate images.';...
            'Text covariate can be also specified as text files. (E.g. age, brain size, IQ etc.)';...
            'The value of each voxel in the output image is an R statistic value. The degree of freedom information is stored in the header of the output image file.';...
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


% --- Executes on button press in CorrSeedAddButton.
function CorrSeedAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to CorrSeedAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if numel(handles.SampleCells)==handles.SampleNum
    warndlg('Invalid Number of Groups');
    return
end

[Name, Path]=uigetfile({'*.txt;*.csv;*.tsv','Correlation Seed Series File (*.txt;*.csv;*.tsv)';'*.*', 'All Files (*.*)';},...
    'Pick the Text Covariates');
if isnumeric(Name)
    return
end

PathCell={fullfile(Path, Name)};
AddString(handles.CorrSeedListbox, PathCell);

handles.SampleCells{numel(handles.SampleCells)+1}=fullfile(Path, Name);
guidata(hObject, handles);

% --- Executes on button press in CorrSeedRemoveButton.
function CorrSeedRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to CorrSeedRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value=get(handles.CorrSeedListbox, 'Value');
if Value==0
    return
end

index=0;
for i=1:numel(handles.SampleCells)
    if ischar(handles.SampleCells{i})
        index=i;
        break
    end
end

handles.SampleCells(index)=[];

RemoveString(handles.CorrSeedListbox, Value);
guidata(hObject, handles);



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
