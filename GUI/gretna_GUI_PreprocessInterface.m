function varargout = gretna_GUI_PreprocessInterface(varargin)
% GRETNA_GUI_PREPROCESSINTERFACE MATLAB code for gretna_GUI_PreprocessInterface.fig
%      GRETNA_GUI_PREPROCESSINTERFACE, by itself, creates a new GRETNA_GUI_PREPROCESSINTERFACE or raises the existing
%      singleton*.
%
%      H = GRETNA_GUI_PREPROCESSINTERFACE returns the handle to a new GRETNA_GUI_PREPROCESSINTERFACE or the handle to
%      the existing singleton*.
%
%      GRETNA_GUI_PREPROCESSINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRETNA_GUI_PREPROCESSINTERFACE.M with the given input arguments.
%
%      GRETNA_GUI_PREPROCESSINTERFACE('Property','Value',...) creates a new GRETNA_GUI_PREPROCESSINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gretna_GUI_PreprocessInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gretna_GUI_PreprocessInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gretna_GUI_PreprocessInterface

% Last Modified by GUIDE v2.5 18-Oct-2016 15:02:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gretna_GUI_PreprocessInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @gretna_GUI_PreprocessInterface_OutputFcn, ...
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


% --- Executes just before gretna_GUI_PreprocessInterface is made visible.
function gretna_GUI_PreprocessInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gretna_GUI_PreprocessInterface (see VARARGIN)

% Choose default command line output for gretna_GUI_PreprocessInterface

% Init Input Structure
handles.InputS=[];
handles.PipeLogPath=[];
% Init Preprocess Procedures
handles.PreModeCell={...
    'DICOM to NIfTI',         1;...
    'Remove First Images',    2;...
    'Slice Timing',           3;...
    'Realign',                4;...
    'Normalize',              5;...
    'Spatially Smooth',       6;...
    'Regress Out Covariates', 7;...    
    'Temporally Detrend',     8;...
    'Temporally Filter',      9;...
    'Scrubbing',              10};

SPMPath=fileparts(which('spm.m'));
GRETNAPath=fileparts(which('gretna.m'));

% DICOM to NIfTI
%   Time Points

% Remove First Images
%   Removed Images
handles.Para.DelImg={'<-X'};

% Slice Timing
%   TR
handles.Para.TR={'<-X'};
%   Slice Order
handles.Para.SliOrd={1, ...
    {'Alternating in the plus direction (starting at odd)';...
    'Alternating in the plus direction (starting at even)';...
    'Alternating in the minus direction (starting at odd)';...
    'Alternating in the minus direction (starting at even)';...
    'Sequential in the plus direction';...
    'Sequential in the minus direction'}};
%   Reference Slice
handles.Para.RefSli={2, ...
    {'First slice'; 'Middle slice'; 'Last slice'}};

% Realign
%   Num Passes
handles.Para.NumPasses={1, ...
    {'Register to first'; 'Register to mean'}};

% Normalize
handles.Para.NormSgy={3, ...
    {'EPI Template'; 'T1 Unified Segmentation'; 'DARTEL'}};

handles.Para.SourPath={'Same To Fun', '', 'D'};
handles.Para.SourPrefix={'mean*'};
handles.Para.VoxSize={[3, 3, 3]};
handles.Para.BBox={[-90, -126, -72; 90, 90, 108]};

%   EPI
if exist(fullfile(SPMPath, 'templates', 'EPI.nii'), 'file')~=2 %spm12
    handles.Para.EPITpm={'EPI.nii', fullfile(SPMPath, 'toolbox', 'OldNorm', 'EPI.nii'), 'F'};
else
    handles.Para.EPITpm={'EPI.nii', fullfile(SPMPath, 'templates', 'EPI.nii'), 'F'};
end

handles.Para.T1Path={'<-X', '', 'D'};
handles.Para.T1Dcm2NiiFlag={1, ...
    {'TRUE'; 'FALSE'}};
handles.Para.T1Prefix={'*'};

%   OldSeg
if exist(fullfile(SPMPath, 'tpm', 'grey.nii'), 'file')~=2 %spm12
    handles.Para.GMTpm={'grey.nii', fullfile(SPMPath, 'toolbox', 'OldSeg', 'grey.nii'), 'F'};
    handles.Para.WMTpm={'white.nii', fullfile(SPMPath, 'toolbox', 'OldSeg', 'white.nii'), 'F'};
    handles.Para.CSFTpm={'csf.nii', fullfile(SPMPath, 'toolbox', 'OldSeg', 'csf.nii'), 'F'};
else
    handles.Para.GMTpm={'grey.nii', fullfile(SPMPath, 'tpm', 'grey.nii'), 'F'};
    handles.Para.WMTpm={'white.nii', fullfile(SPMPath, 'tpm', 'white.nii'), 'F'};
    handles.Para.CSFTpm={'csf.nii', fullfile(SPMPath, 'tpm', 'csf.nii'), 'F'};
end
handles.Para.AffReg={2, ...
    {'No affine registration';...
    'ICBM space template - European brains';...
    'ICBM space template - East Asian brains';...
    'Average sized template';...
    'No regularisation'}};

%   NewSeg
if exist(fullfile(SPMPath, 'toolbox', 'Seg', 'TPM.nii'), 'file')~=2 %spm12
    handles.Para.TPMTpm={'TPM.nii', fullfile(SPMPath, 'tpm', 'TPM.nii'), 'F'};
else
    handles.Para.TPMTpm={'TPM.nii', fullfile(SPMPath, 'toolbox', 'Seg', 'TPM.nii'), 'F'};
end

% Spatially Smooth
handles.Para.FWHM={[4, 4, 4]};

% Regress Out Covariates
%   Global Signal
handles.Para.GSFlag={2,...
    {'TRUE'; 'FALSE'}};
handles.Para.GSMsk={'BrainMask_3mm.nii', fullfile(GRETNAPath, 'Mask', 'BrainMask_3mm.nii'), 'F'};
%   White Matter Signal
handles.Para.WMFlag={1,...
    {'TRUE'; 'FALSE'}};
handles.Para.WMMsk={'WMMask_3mm.nii', fullfile(GRETNAPath, 'Mask', 'WMMask_3mm.nii'), 'F'};
%   CSF Signal
handles.Para.CSFFlag={1,...
    {'TRUE'; 'FALSE'}};
handles.Para.CSFMsk={'CSFMask_3mm.nii', fullfile(GRETNAPath, 'Mask', 'CSFMask_3mm.nii'), 'F'};

%   Head Motion
handles.Para.HMFlag={1,...
    {'TRUE'; 'FALSE'}};
handles.Para.HMSgy={3,...
    {'Original - 6 Parameters'; 'Original and Relative - 12 Parameters'; 'Frison - 24 Parameters'}};

% Temporally Detrend
handles.Para.PolyOrd={1,...
    {'Linear'; 'Linear and Quadratic'}};

% Temporally Filter
handles.Para.Band={[0.01, 0.1]};

% Scrubbing
handles.Para.InterSgy={1,...
    {'Remove'; 'Nearest Interpolation'; 'Linear Interpolation'}};
handles.Para.FDTrd={0.5};
handles.Para.PreNum={1};
handles.Para.PostNum={2};


% Init Postprocess Procedures
handles.PostModeCell={'Static Correlation', 1;...
    'Dynamical Correlation', 2};

% SFC
handles.Para.FCAtlas={'Random1024_3mm.nii', fullfile(GRETNAPath, 'Atlas', 'Random1024_3mm.nii'), 'F'};
handles.Para.FZTFlag={2,...
    {'TRUE'; 'FALSE'}};

% DFC
handles.Para.SWL={50};
handles.Para.SWS={2};

% Init Mode List Index
handles.UnselPreInd=(1:10)';
handles.SelPreInd=[];
handles.UnselPostInd=(1:2)';
handles.SelPostInd=[];

% Init Current Item Key
handles.CurItemKey=[];

% Init Fun Parent Dir
handles.FunPDir=[];

handles.MainFig=hObject;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

UpdateConfigInterface(hObject);
% UIWAIT makes gretna_GUI_PreprocessInterface wait for user response (see UIRESUME)
% uiwait(handles.MainFig);


% --- Outputs from this function are returned to the command line.
function varargout = gretna_GUI_PreprocessInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in PreModeList.
function PreModeList_Callback(hObject, eventdata, handles)
% hObject    handle to PreModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PreModeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PreModeList


% --- Executes during object creation, after setting all properties.
function PreModeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on PreModeList and none of its controls.
function PreModeList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to PreModeList (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in PostModeList.
function PostModeList_Callback(hObject, eventdata, handles)
% hObject    handle to PostModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PostModeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PostModeList


% --- Executes during object creation, after setting all properties.
function PostModeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PostModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PreModeToRight.
function PreModeToRight_Callback(hObject, eventdata, handles)
% hObject    handle to PreModeToRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UnselModeVal=get(handles.PreModeList, 'Value');
UnselModeStr=get(handles.PreModeList, 'String');
UnselModeTar=UnselModeStr(UnselModeVal);
Msk=strcmpi(UnselModeTar{1}, handles.PreModeCell(:, 1));
Ind=handles.PreModeCell(Msk, 2);
Ind=Ind{1};

handles.UnselPreInd(handles.UnselPreInd==Ind)=[];
handles.SelPreInd=[handles.SelPreInd; Ind];

Dcm2NiiMsk=handles.SelPreInd==1;
if any(Dcm2NiiMsk)
    handles.SelPreInd(Dcm2NiiMsk)=[];
    handles.SelPreInd=[1; handles.SelPreInd];
end
guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on button press in PreModeToLeft.
function PreModeToLeft_Callback(hObject, eventdata, handles)
% hObject    handle to PreModeToLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelModeVal=get(handles.PipeOptList, 'Value');
SelModeStr=get(handles.PipeOptList, 'String');
SelModeTar=SelModeStr(SelModeVal);
Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.PreModeCell(:, 1));
Ind=handles.PreModeCell(Msk, 2);
Ind=Ind{1};

handles.SelPreInd(handles.SelPreInd==Ind)=[];
handles.UnselPreInd=[handles.UnselPreInd; Ind];
handles.UnselPreInd=sort(handles.UnselPreInd);

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on button press in PostModeToRight.
function PostModeToRight_Callback(hObject, eventdata, handles)
% hObject    handle to PostModeToRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UnselModeVal=get(handles.PostModeList, 'Value');
UnselModeStr=get(handles.PostModeList, 'String');
UnselModeTar=UnselModeStr(UnselModeVal);
Msk=strcmpi(UnselModeTar{1}, handles.PostModeCell(:, 1));
Ind=handles.PostModeCell(Msk, 2);
Ind=Ind{1};

handles.UnselPostInd(handles.UnselPostInd==Ind)=[];
handles.SelPostInd=sort([handles.SelPostInd; Ind]);

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on button press in PostModeToLeft.
function PostModeToLeft_Callback(hObject, eventdata, handles)
% hObject    handle to PostModeToLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelModeVal=get(handles.PipeOptList, 'Value');
SelModeStr=get(handles.PipeOptList, 'String');
SelModeTar=SelModeStr(SelModeVal);
Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.PostModeCell(:, 1));
Ind=handles.PostModeCell(Msk, 2);
Ind=Ind{1};

handles.SelPostInd(handles.SelPostInd==Ind)=[];
handles.UnselPostInd=[handles.UnselPostInd; Ind];
handles.UnselPostInd=sort(handles.UnselPostInd);

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on selection change in PipeOptList.
function PipeOptList_Callback(hObject, eventdata, handles)
% hObject    handle to PipeOptList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(handles.MainFig , 'SelectionType') , 'normal')
    UpdateConfigInterface(hObject);
else
    ChangedAction(hObject);
end

% Hints: contents = cellstr(get(hObject,'String')) returns PipeOptList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PipeOptList


% --- Executes during object creation, after setting all properties.
function PipeOptList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PipeOptList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InputDirEty_Callback(hObject, eventdata, handles)
% hObject    handle to InputDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputDirEty as text
%        str2double(get(hObject,'String')) returns contents of InputDirEty as a double


% --- Executes during object creation, after setting all properties.
function InputDirEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in InputDirBtn.
function InputDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to InputDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.FunPDir)
    OldPath=handles.FunPDir;
else
    OldPath=pwd;
end

Path=uigetdir(OldPath, 'Path of Functional Dataset');
if isnumeric(Path)
    return
end
handles.FunPDir=Path;
set(handles.InputDirEty, 'String', Path)
guidata(hObject, handles);
UpdateInputInterface(hObject, 1);

function KeyEty_Callback(hObject, eventdata, handles)
% hObject    handle to KeyEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateInputInterface(hObject, 1);
% Hints: get(hObject,'String') returns contents of KeyEty as text
%        str2double(get(hObject,'String')) returns contents of KeyEty as a double


% --- Executes during object creation, after setting all properties.
function KeyEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KeyEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in InputList.
function InputList_Callback(hObject, eventdata, handles)
% hObject    handle to InputList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InputList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InputList


% --- Executes during object creation, after setting all properties.
function InputList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OptItemList.
function OptItemList_Callback(hObject, eventdata, handles)
% hObject    handle to OptItemList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Val=get(handles.OptItemList, 'Value');
Str=get(handles.OptItemList, 'String');

Tar=Str(Val);
if isempty(Tar)
    return
end

Key=handles.CurItemKey;
if isempty(Key)
    return
end

ItemCell=handles.Para.(Key);
if numel(ItemCell)==1;
    if ~strcmpi(get(handles.MainFig , 'SelectionType') , 'normal')
        ChangedAction(hObject);
        return
    end
elseif numel(ItemCell)==2 && iscell(ItemCell{1, 2})
        ItemCell{1, 1}=Val;
elseif numel(ItemCell)==3
    if ~strcmpi(get(handles.MainFig , 'SelectionType') , 'normal')
        ChangedAction(hObject);
        return
    end
end
handles.Para.(Key)=ItemCell;

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% Hints: contents = cellstr(get(hObject,'String')) returns OptItemList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OptItemList


% --- Executes during object creation, after setting all properties.
function OptItemList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OptItemList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in HelpList.
function HelpList_Callback(hObject, eventdata, handles)
% hObject    handle to HelpList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HelpList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HelpList


% --- Executes during object creation, after setting all properties.
function HelpList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HelpList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PipeOptUp.
function PipeOptUp_Callback(hObject, eventdata, handles)
% hObject    handle to PipeOptUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelModeVal=get(handles.PipeOptList, 'Value');
SelModeStr=get(handles.PipeOptList, 'String');
SelModeTar=SelModeStr(SelModeVal);
Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.PreModeCell(:, 1));

if any(Msk) % PreMod
    Ind=handles.PreModeCell(Msk, 2);
    Ind=Ind{1};
    
    Sel=find(handles.SelPreInd==Ind);
    handles.SelPreInd([Sel-1, Sel])=handles.SelPreInd([Sel, Sel-1]);
else % PostMode
    Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.PostModeCell(:, 1));
    Ind=handles.PostModeCell(Msk, 2);
    Ind=Ind{1};
    
    Sel=find(handles.SelPostInd==Ind);
    handles.SelPostInd([Sel-1, Sel])=handles.SelPostInd([Sel, Sel-1]);    
end

guidata(hObject, handles);
UpdateConfigInterface(hObject);

% --- Executes on button press in PipeOptDown.
function PipeOptDown_Callback(hObject, eventdata, handles)
% hObject    handle to PipeOptDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelModeVal=get(handles.PipeOptList, 'Value');
SelModeStr=get(handles.PipeOptList, 'String');
SelModeTar=SelModeStr(SelModeVal);
Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.PreModeCell(:, 1));

if any(Msk)
    Ind=handles.PreModeCell(Msk, 2);
    Ind=Ind{1};
    
    Sel=find(handles.SelPreInd==Ind);
    handles.SelPreInd([Sel, Sel+1])=handles.SelPreInd([Sel+1, Sel]);
else
    Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.PostModeCell(:, 1));
    Ind=handles.PostModeCell(Msk, 2);
    Ind=Ind{1};
    
    Sel=find(handles.SelPostInd==Ind);
    handles.SelPostInd([Sel, Sel+1])=handles.SelPostInd([Sel+1, Sel]);    
end

guidata(hObject, handles);
UpdateConfigInterface(hObject);

% --- Executes on button press in RunBtn.
function RunBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RunBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ExitCode=CheckBeforeRun(hObject);
if ExitCode
    return;
end
Para=handles.Para;
PreStr=handles.PreModeCell(handles.SelPreInd);
PostStr=handles.PostModeCell(handles.SelPostInd);
AllStr=[PreStr; PostStr];

FileList=cellfun(@(S) S.FileList, handles.InputS, 'UniformOutput', false);
SList=cellfun(@(S) GenSubjLab(S.Lab), handles.InputS, 'UniformOutput', false);
IndList=arrayfun(@(d) sprintf('%.5d', d), (1:numel(SList))',...
    'UniformOutput', false);
Map=[IndList, SList];
OldInputStr=get(handles.InputList, 'String');
Pl=[];
InputSoFileList={};
InputFDFileList={};
InputHMFileList={};
for i=1:numel(AllStr)
    ModeName=AllStr{i};
    switch upper(ModeName)
        case 'DICOM TO NIFTI'
            PPath=fileparts(handles.FunPDir);
            OutputFileList=cellfun(...
                @(s) {fullfile(PPath, 'GretnaFunNIfTI', s, 'rest.nii')},...
                SList, 'UniformOutput', false);
            PCell=cellfun(@(in, out) gretna_GEN_EpiDcm2Nii(in, out),...
                FileList, OutputFileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('EpiDcm2Nii%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'REMOVE FIRST IMAGES'
            PCell=cellfun(@(in) gretna_GEN_RmFstImg(in, Para.DelImg{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('RmFstImg%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);            
        case 'SLICE TIMING'
            PCell=cellfun(...
                @(in) gretna_GEN_SliTim(in, Para.TR{1}, Para.SliOrd{1}, Para.RefSli{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('SliTim%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);   
        case 'REALIGN'
            PCell=cellfun(...
                @(in) gretna_GEN_Realign(in, Para.NumPasses{1}),...
                FileList, 'UniformOutput', false);
            TList=cellfun(@(i) sprintf('Realign%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
            
            InputSoFileList=cellfun(@(S) S.SoFile, PCell,...
                'UniformOutput', false);
            InputHMFileList=cellfun(@(S) S.HMFile, PCell,...
                'UniformOutput', false);
            InputFDFileList=cellfun(@(S) S.FDFile, PCell,...
                'UniformOutput', false);
            
            ChkCell=cellfun(...
                @(in, lab) gretna_GEN_ChkHM(in, lab, handles.FunPDir),...
                FileList, SList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('ChkHM%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, ChkCell); 
        case 'NORMALIZE'
            SourPrefix=Para.SourPrefix{1};            
            if isempty(InputSoFileList);    
                InputSoFileList=cellfun(...
                    @(in) GenSoFile(in, SourPrefix),...
                    FileList, 'UniformOutput', false);
                if any(cellfun(@isempty, InputSoFileList))
                    errordlg('Cannot find source image (e.g. mean*.nii in Functional Directory), Please Check again OR add ''Realign'' step!');
                    return;
                end
            end 
            
            if Para.NormSgy{1}==1 % EPI
                PCell=cellfun(...
                    @(in, inSo) gretna_GEN_EpiNorm(...
                    in, inSo, Para.EPITpm{2},...
                    Para.BBox{1}, Para.VoxSize{1}...
                    ),...
                    FileList, InputSoFileList,...
                    'UniformOutput', false);
                
                TList=cellfun(@(i) sprintf('EpiNorm%s', i), IndList,...
                    'UniformOutput', false);
                Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
            else
                % T1 Dicom to NIfTI
                T1Path=Para.T1Path{2};
                T1Prefix=Para.T1Prefix{1};
                T1Dcm2NiiFlag=Para.T1Dcm2NiiFlag{1};
                InputT1FileList=[];
                if T1Dcm2NiiFlag==1; 
                    PPath=fileparts(handles.FunPDir);
                    InputT1DirList=cellfun(...
                        @(s) fullfile(T1Path, s),...
                        SList, 'UniformOutput', false);
                    InputT1FileList=cellfun(...
                        @(p) GenT1Dcm(p, T1Prefix), InputT1DirList,...
                        'UniformOutput', false);
                    
                    if any(cellfun(@isempty, InputT1FileList))
                        errordlg('Cannot find T1 image (e.g. *.dcm in T1 Directory), Please Check again!');
                        return;
                    end
                    
                    OutputT1FileList=cellfun(...
                        @(s) {fullfile(PPath, 'GretnaT1NIfTI', s, 'T1.nii')},...
                        SList, 'UniformOutput', false);
                    TDNCell=cellfun(@(in, out) gretna_GEN_T1Dcm2Nii(in, out),...
                        InputT1FileList, OutputT1FileList, 'UniformOutput', false);
            
                    TList=cellfun(@(i) sprintf('T1Dcm2Nii%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, TDNCell);

                    InputT1FileList=OutputT1FileList;
                end
                
                % Normalize
                if isempty(InputT1FileList)
                    InputT1DirList=cellfun(...
                        @(s) fullfile(T1Path, s),...
                        SList, 'UniformOutput', false);
                    InputT1FileList=cellfun(...
                        @(p) GenT1Nii(p, T1Prefix), InputT1DirList,...
                        'UniformOutput', false);
                    if any(cellfun(@isempty, InputT1FileList))
                        errordlg(sprintf('Cannot find T1 image (e.g. %s.nii in T1 Directory), Please Check again!', T1Prefix));
                        return;
                    end
                end
                
                if Para.NormSgy{1}==2 % T1 Unified Segmentation
                    PCell=cellfun(...
                        @(in, inSo, inT1) gretna_GEN_T1CoregSegNorm(...
                        in, inSo,...
                        inT1,...
                        Para.GMTpm{2}, Para.WMTpm{2}, Para.CSFTpm{2},...
                        Para.BBox{1}, Para.VoxSize{1}...
                        ),...
                        FileList, InputSoFileList, InputT1FileList,...
                        'UniformOutput', false);
                    
                    TList=cellfun(@(i) sprintf('T1CoregSegNorm%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
                else % DARTEL
                    % Coregister and New Segment
                    CNSCell=cellfun(...
                        @(in, inSo, inT1) gretna_GEN_T1CoregNewSeg(...
                        in, inSo, inT1,...
                        Para.TPMTpm{2}...
                        ),...
                        FileList, InputSoFileList, InputT1FileList,...
                        'UniformOutput', false);
                    TList=cellfun(@(i) sprintf('T1CoregNewSeg%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, CNSCell);
                    
                    C1FileList=cellfun(@(S) S.C1File, CNSCell,...
                        'UniformOutput', false);
                    C2FileList=cellfun(@(S) S.C2File, CNSCell,...
                        'UniformOutput', false);
                    C3FileList=cellfun(@(S) S.C3File, CNSCell,...
                        'UniformOutput', false);
                    RC1FileList=cellfun(@(S) S.RC1File, CNSCell,...
                        'UniformOutput', false);
                    RC2FileList=cellfun(@(S) S.RC2File, CNSCell,...
                        'UniformOutput', false);
                    
                    Pl.DartelNormT1=gretna_GEN_DartelNormT1(...
                        RC1FileList, RC2FileList,...
                        C1FileList, C2FileList, C3FileList...
                        );
                    % Dartel Template List
                    DTFile=Pl.DartelNormT1.DTFile;
                    FFFileList=Pl.DartelNormT1.FFFileList;
            
                    PCell=cellfun(...
                        @(in, inSo, inFF) gretna_GEN_DartelNormEpi(in, inSo, inFF, DTFile,...
                        Para.BBox{1}, Para.VoxSize{1}...
                        ),...
                        FileList, InputSoFileList, FFFileList, 'UniformOutput', false);
            
                    TList=cellfun(@(i) sprintf('DartelNormEpi%s', i), IndList,...
                        'UniformOutput', false);
                    Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
                end
            end
            OutputSoFileList=cellfun(@(S) S.OutputSoFile, PCell, 'UniformOutput', false);
            ChkCell=cellfun(...
                @(normSo, lab) gretna_GEN_ChkNorm(normSo, lab, handles.FunPDir),...
                OutputSoFileList, SList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('ChkNorm%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, ChkCell);         
        case 'SPATIALLY SMOOTH'
            PCell=cellfun(...
                @(in) gretna_GEN_Smooth(in, Para.FWHM{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('Smooth%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'REGRESS OUT COVARIATES'
            % Global Signal
            GSMsk='';
            if Para.GSFlag{1}==1  % TRUE
                GSMsk=Para.GSMsk{1, 2};
            end
            % White Matter
            WMMsk='';
            if Para.WMFlag{1}==1  % TRUE
                WMMsk=Para.WMMsk{1, 2};
            end 
            % CSF
            CSFMsk='';
            if Para.CSFFlag{1}==1 % TRUE
                CSFMsk=Para.CSFMsk{1, 2};
            end
            % HeadMotion
            if Para.HMFlag{1}==1  % TRUE
                HMInd=Para.HMSgy{1};
                if isempty(InputHMFileList)
                    InputHMFileList=cellfun(...
                        @(in) GenHMFile(in),...
                        FileList, 'UniformOutput', false);
                    if any(cellfun(@isempty, InputHMFileList))
                        errordlg('Cannot find head motion parameter file (e.g. HeadMotionParameter.txt in Functional Directory), Please Check again OR add ''Realign'' step!');
                        return;
                    end
                end
            else
                HMInd=0;
                % Do Not Used
                InputHMFileList=cellfun(@(in) [],...
                    FileList, 'UniformOutput', false);
            end
            
            PCell=cellfun(...
                @(in, inHM) gretna_GEN_RegressOut(in, GSMsk, WMMsk, CSFMsk, HMInd, inHM),...
                FileList, InputHMFileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('RegressOut%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'TEMPORALLY DETREND'
            PCell=cellfun(...
                @(in) gretna_GEN_Detrend(in, Para.PolyOrd{1, 1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('Detrend%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'TEMPORALLY FILTER'
            PCell=cellfun(...
                @(in) gretna_GEN_Filter(in, Para.TR{1}, Para.Band{1}),...
                FileList, 'UniformOutput', false);
            
            TList=cellfun(@(i) sprintf('Filter%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'SCRUBBING'
            if isempty(InputFDFileList);    
                InputFDFileList=cellfun(...
                    @(in) GenFDFile(in),...
                    FileList, 'UniformOutput', false);
                if any(cellfun(@isempty, InputFDFileList))
                    errordlg('Cannot find source image (e.g. PowerFD.txt in Functional Directory), Please Check again OR add ''Realign'' step!');
                    return;
                end
            end            
            PCell=cellfun(...
                @(in, inFD) gretna_GEN_Scrubbing(...
                in, inFD, Para.InterSgy{1}, Para.FDTrd{1},...
                Para.PreNum{1}, Para.PostNum{1}...
                ),...
                FileList, InputFDFileList, 'UniformOutput', false); 
            
            TList=cellfun(@(i) sprintf('Scrubbing%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'STATIC CORRELATION'
            PCell=cellfun(...
                @(in, lab) gretna_GEN_StaticFC(...
                in, lab, handles.FunPDir,...
                Para.FCAtlas{2}, Para.FZTFlag{1}...
                ),...
                FileList, SList, 'UniformOutput', false);
            TList=cellfun(@(i) sprintf('StaticFC%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell); 
        case 'DYNAMICAL CORRELATION'
            PCell=cellfun(...
                @(in, lab) gretna_GEN_DynamicalFC(...
                in, lab, handles.FunPDir,...
                Para.FCAtlas{2}, Para.FZTFlag{1},...
                Para.SWL{1}, Para.SWS{1}...
                ),...
                FileList, SList, 'UniformOutput', false);
            TList=cellfun(@(i) sprintf('DynamicalFC%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
    end
    % Update Input    
    FileList=cellfun(@(S) S.OutputImgFile, PCell, 'UniformOutput', false);
end

CInd=get(handles.CTypePopup, 'Value');
switch CInd
    case 1 %session
        CTyp='session';
    case 2 %local
        if ismac
            CTyp='background';
        else
            CTyp='batch';
        end
    case 3 %sqe
        CTyp='qsub';
end
% Option
Opt.mode               =CTyp;
Queue=str2num(get(handles.QueueEty, 'String'));
if isempty(Queue)
    errordlg('Error: Invalid Queue Number!');
    return
end
Opt.max_queued         =Queue;
Opt.flag_verbose       =true;
Opt.flag_pause         =false;
Opt.flag_update        =false;
Opt.time_between_checks=5;
PPath=fileparts(handles.FunPDir);
PipeLogPath=fullfile(PPath, 'GretnaLogs', 'FunPreproAndNetCon');
if exist(PipeLogPath, 'dir')==7
    ans=rmdir(PipeLogPath, 's');
end
mkdir(PipeLogPath);
Opt.path_logs=PipeLogPath;

handles.PipeLogPath=PipeLogPath;
handles.Map=Map;
handles.OldInputStr=OldInputStr;

guidata(hObject, handles);

psom_run_pipeline(Pl, Opt);
PipeStatus=load(fullfile(PipeLogPath, 'PIPE_status.mat'));
PipeLogs=load(fullfile(PipeLogPath, 'PIPE_logs.mat'));

FStatus=structfun(@(s) strcmpi(s, 'failed'), PipeStatus);
if any(FStatus)
    FN=fieldnames(PipeLogs);
    FFN=FN(FStatus);
    Str=[];
    for i=1:numel(FFN)
        if strcmpi(FFN{i}, 'DartelNormT1')
            SubjString=[];
        else
            Ind=FFN{i}(end-4:end);
            SubjLab=SList(strcmpi(IndList, Ind));
            SubjString=SubjLab{1};
        end
        Str=[Str,'\n', SubjString, '\n',...
            psom_pipeline_visu(PipeLogPath, 'log', FFN{i}, false)];
    end
    error(Str);
end

% --- Executes on selection change in CTypePopup.
function CTypePopup_Callback(hObject, eventdata, handles)
% hObject    handle to CTypePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CTypePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CTypePopup

% --- Executes during object creation, after setting all properties.
function CTypePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CTypePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveBtn.
function SaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File , Path]=uiputfile('*.mat', 'Save configure' ,...
    'MyFunPreproAndNetConConfig.mat' );
if ischar(File)
    SaveName=fullfile(Path, File);
    
    Input=[];Mode=[];
    % Input Config
    Input.InputS=handles.InputS;
    Input.InputKey=get(handles.KeyEty, 'String');
    Input.FunPDir=handles.FunPDir;
    % Mode Config
    Mode.CurItemKey=handles.CurItemKey;
    
    Mode.UnselPreInd=handles.UnselPreInd;
    Mode.SelPreInd=handles.SelPreInd;
    
    Mode.UnselPostInd=handles.UnselPostInd;
    Mode.SelPostInd=handles.SelPostInd;
    
    Para=handles.Para;
    
    save(SaveName , 'Input', 'Mode', 'Para');
    msgbox('Configuration Saved!');
end

% --- Executes on button press in LoadBtn.
function LoadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to LoadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File, Path] = uigetfile('*.mat' , 'Pick configuration');
if ischar(File)
    load(fullfile(Path, File));
    % Input
    handles.InputS=Input.InputS;
    handles.FunPDir=Input.FunPDir;
    set(handles.InputDirEty, 'String', Input.FunPDir);
    set(handles.KeyEty, 'String', Input.InputKey);
    
    guidata(hObject, handles);
    UpdateInputInterface(hObject, 2);
    drawnow;
    handles=guidata(hObject);
    
    % Mode
    handles.SelPreInd=Mode.SelPreInd;
    handles.SelPostInd=Mode.SelPostInd;
    
    handles.UnselPreInd=Mode.UnselPreInd;
    handles.UnselPostInd=Mode.UnselPostInd;
    
    handles.CurItemKey=Mode.CurItemKey;
    
    handles.Para=Para;
    
    guidata(hObject, handles);
    UpdateConfigInterface(hObject);
    drawnow;
    
    msgbox('Configuration Loaded!');
end

% --- Executes during object deletion, before destroying properties.
function MainFig_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to MainFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PipeLogPath=handles.PipeLogPath;
if ~isempty(PipeLogPath)
    LockFile=fullfile(PipeLogPath, 'PIPE.lock');
    if exist(LockFile, 'file')==2
        delete(LockFile);
    end
end

% --- Executes on button press in QuitBtn.
function QuitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to QuitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.MainFig);


function QueueEty_Callback(hObject, eventdata, handles)
% hObject    handle to QueueEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QueueEty as text
%        str2double(get(hObject,'String')) returns contents of QueueEty as a double


% --- Executes during object creation, after setting all properties.
function QueueEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QueueEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateConfigInterface(hObject)
% Get Handles
handles=guidata(hObject);

% Update Mode List
UnselPreStr=handles.PreModeCell(handles.UnselPreInd, 1);
PreToRight=UpdateModeList(handles.PreModeList, UnselPreStr);

UnselPostStr=handles.PostModeCell(handles.UnselPostInd, 1);
PostToRight=UpdateModeList(handles.PostModeList, UnselPostStr);

% Update Option List
SelPreStr=handles.PreModeCell(handles.SelPreInd, 1);
SelPostStr=handles.PostModeCell(handles.SelPostInd, 1);
[PreToLeft, PostToLeft, OptToUp, OptToDown]=UpdateOptList(handles.PipeOptList, ...
    SelPreStr, SelPostStr, handles.Para);

% Update Item List
%UpdateItemList(handles.OptItemList, handles.PipeOptList, handles.Para);
Key=GenItemKey(handles.PipeOptList);
UpdateItemList(handles.OptItemList, handles.Para, Key);
handles.CurItemKey=Key;

% Enable All Obj
StateObj(handles, 'On');

% Update Button
set(handles.PreModeToLeft, 'Enable', PreToLeft);
set(handles.PreModeToRight, 'Enable', PreToRight);

set(handles.PostModeToLeft, 'Enable', PostToLeft);
set(handles.PostModeToRight, 'Enable', PostToRight);

set(handles.PipeOptUp, 'Enable', OptToUp);
set(handles.PipeOptDown, 'Enable', OptToDown);
guidata(hObject, handles);

function BtnToRight=UpdateModeList(ListObj, Str)
BtnToRight='On';
if isempty(Str)
    Val=[];
    BtnToRight='Off';
else
    OldVal=get(ListObj, 'Value');
    OldStr=get(ListObj, 'String');

    OldTar=OldStr(OldVal);
    if isempty(OldTar)
        Val=1;
    else
        Val=find(strcmpi(OldTar{1}, Str));
        if isempty(Val)
            if OldVal<numel(Str)
                Val=OldVal;
            else
                Val=numel(Str);
            end
        end
    end
end
set(ListObj, 'String', Str, 'Value', Val);

function [PreToLeft, PostToLeft, OptToUp, OptToDown]=UpdateOptList(ListObj, PreStr, PostStr, Para)
PreToLeft='On';
PostToLeft='On';
OptToUp='On';
OptToDown='On';

if isempty(PreStr)
    PreToLeft='Off';
end

if isempty(PostStr)
    PostToLeft='Off';
end

if isempty([PreStr; PostStr])
    PreToLeft='Off';
    PostToLeft='Off';    
    OptToUp='Off';
    OptToDown='Off';
    FinalVal=[];
    FinalStr=[];
else
    OldVal=get(ListObj, 'Value');
    OldStr=get(ListObj, 'String');

    OldTar=OldStr(OldVal);
    if isempty(OldTar)
        ModeVal=1;
    else
        % Find Current Mode
        ModeVal=find(cellfun(@(s) strncmpi(s, OldTar{1}, length(s)), ...
            [PreStr; PostStr]), 1);
        if isempty(ModeVal)
            TmpOldVal=OldVal-1;
            while TmpOldVal>0
                TmpOldTar=OldStr(TmpOldVal);
                ModeVal=find(cellfun(@ (s) strncmpi(s, TmpOldTar{1}, length(s)), ...
                    [PreStr; PostStr]), 1);
                if ~isempty(ModeVal)
                    break
                end
                TmpOldVal=TmpOldVal-1;
            end
            
            if isempty(ModeVal)
                ModeVal=1;
            end
            
            if strcmpi(OldTar{1}(1:2), ' .')
                PreToLeft='Off';
                PostToLeft='Off';
                OptToUp='Off';
                OptToDown='Off';
            end
        end
    end
    
    % Justify To Whether To Left
    AllStr=[PreStr; PostStr];
    ModeStr=AllStr(ModeVal);
    if isempty(find(strcmpi(ModeStr{1}, PreStr), 1))
        PreToLeft='Off';
    end
    if isempty(find(strcmpi(ModeStr{1}, PostStr), 1))
        PostToLeft='Off';
    end
    
    % Justify Whether Up or Down
    if ModeVal<=numel(PreStr) % Pre
        if ModeVal==1
            OptToUp='Off';
            if strcmpi(PreStr{ModeVal}, 'DICOM TO NIFTI')
                OptToDown='Off';
            end
        elseif ModeVal==2 && strcmpi(PreStr{1}, 'DICOM TO NIFTI')
            OptToUp='Off';
        elseif ModeVal==numel(PreStr)
            OptToDown='Off';
        end
    else % Post
        if ModeVal==numel(PreStr)+1
            OptToUp='Off';
        end
        if ModeVal==numel([PreStr; PostStr])
            OptToDown='Off';
        end 
        
        % Disabled Up Down Now;
        OptToUp='Off';
        OptToDown='Off';
    end
    
    % Generate PipeOptStr
    [NameStr, DataStr]=GenOptStr([PreStr; PostStr], ModeVal, Para);
    
    FinalStr=ListTextFill(ListObj, NameStr, DataStr, true);
    
    if numel(FinalStr)==numel(OldStr) && ~any(cellfun(@(s) strncmpi(s, OldTar{1}, length(s)), [PreStr; PostStr]))
        % Dirty Code
        FinalVal=OldVal;
    else
        if isempty(OldTar)
            FinalVal=1;
        else
            FinalVal=find(cellfun(@(s) strncmpi(s, OldTar{1}, length(s)), NameStr), 1);
        end
        if isempty(FinalVal)
            if TmpOldVal==0
                FinalVal=1;
            else
                FinalVal=TmpOldVal;
            end
        end
    end    
end

set(ListObj, 'String', FinalStr, 'Value', FinalVal);

function [NameStr, DataStr]=GenOptStr(Str, ModeVal, Para)
NameStr=[];
DataStr=[];
for s=1:numel(Str)
    NameStr=[NameStr; Str(s)];
    DataStr=[DataStr; {''}];
    %if s==ModeVal
    switch upper(Str{s})
        case 'DICOM TO NIFTI'
            % TP
            %NameStr=[NameStr;...
            %    {' . Time Point Number:  '}];
            %DataStr=[DataStr;...
            %    {num2str(Para.TP{1})}];
        case 'REMOVE FIRST IMAGES'
            % TP to Remove
            NameStr=[NameStr;...
                {' . Time Point Number to Remove:  '}];
            DataStr=[DataStr;...
                {num2str(Para.DelImg{1})}];
        case 'SLICE TIMING'
            % TR
            NameStr=[NameStr;...
                {' . TR (s):  '}];
            DataStr=[DataStr;...
                {num2str(Para.TR{1})}];
            % Slice Order
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.SliOrd, ' . Slice Order:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            % Reference Slice
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.RefSli, ' . Reference Slice:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
        case 'REALIGN'
            % Num Passes
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.NumPasses, ' . Num Passes:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
        case 'NORMALIZE'
            % Data
            %NameStr=[NameStr; {' . Source Data '}];
            %DataStr=[DataStr; {''}];
            
            %NameStr=[NameStr; {' . . Source Image Path:  '}];
            %if isempty(Para.SourPath{1, 2})
            %    Para.SourPath{1, 1}={'Same to Fun'};
            %end
            %DataStr=[DataStr; Para.SourPath{1}];
            
            %NameStr=[NameStr; {' . . Source Image Prefix:  '}];
            %DataStr=[DataStr; Para.SourPrefix];
            
            % Normalizing Strategy
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.NormSgy, ' . Normalizing Strategy:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            if Para.NormSgy{1, 1}==1 % EPI
                % DO NOTHING
            else % T1 Segment OR DARTEL
                NameStr=[NameStr; {' . . T1 Data '}];
                DataStr=[DataStr; {''}];
                
                NameStr=[NameStr; {' . . . T1 Image Path:  '}];
                DataStr=[DataStr; Para.T1Path(1, 1)];  
                
                NameStr=[NameStr; {' . . . T1 Image Prefix:  '}];
                DataStr=[DataStr; Para.T1Prefix]; 
                
                [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.T1Dcm2NiiFlag,...
                    ' . . . T1 DICOM to NIfTI:  ');
                NameStr=[NameStr; tmp_name_str];
                DataStr=[DataStr; tmp_data_str];
                
                
                NameStr=[NameStr; {' . . Coregister  '}];
                DataStr=[DataStr; {''}];
            end
            
            switch Para.NormSgy{1, 1}
                case 1 % DO NOTHING
                    NameStr=[NameStr; {' . . EPI Template:  '}];
                    DataStr=[DataStr; Para.EPITpm(1, 1)];                    
                case 2 % T1 Segment
                    NameStr=[NameStr; {' . . Segment  '}];
                    DataStr=[DataStr; {''}];  
                    
                    NameStr=[NameStr; {' . . . Grey Matter Template:  '}];
                    DataStr=[DataStr; Para.GMTpm(1, 1)];
                    
                    NameStr=[NameStr; {' . . . White Matter Template:  '}];
                    DataStr=[DataStr; Para.WMTpm(1, 1)];
                    
                    NameStr=[NameStr; {' . . . CSF Template:  '}];
                    DataStr=[DataStr; Para.CSFTpm(1, 1)];
                case 3 % DARTEL
                    NameStr=[NameStr; {' . . Segment  '}];
                    DataStr=[DataStr; {''}];
                    NameStr=[NameStr; {' . . . Tissue Template:  '}];
                    DataStr=[DataStr; Para.TPMTpm(1, 1)];                    
            end
            
            % Write
            NameStr=[NameStr; {' . Writing Options  '}];
            DataStr=[DataStr; {''}];     
            
            NameStr=[NameStr; {' . . Bounding Box:  '}];
            tmp_data_str=Para.BBox{1};
            DataStr=[DataStr; ...
                {sprintf('%d x %d %s', size(tmp_data_str, 1), size(tmp_data_str, 2), class(tmp_data_str) )}];  
                        
            NameStr=[NameStr; {' . . Voxel Sizes (mm):  '}];
            DataStr=[DataStr; {['[',num2str(Para.VoxSize{1}), ']']}];
        case 'SPATIALLY SMOOTH'
            NameStr=[NameStr; {' . FWHM (mm):  '}];
            DataStr=[DataStr; {['[',num2str(Para.FWHM{1}), ']']}];            
        case 'REGRESS OUT COVARIATES'
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.GSFlag,...
                ' . Global Signal:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            if Para.GSFlag{1}==1
                NameStr=[NameStr; {' . . Mask:  '}];
                DataStr=[DataStr; Para.GSMsk(1, 1)];
            end
            
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.WMFlag,...
                ' . White Matter Signal:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            if Para.WMFlag{1}==1
                NameStr=[NameStr; {' . . Mask:  '}];
                DataStr=[DataStr; Para.WMMsk(1, 1)];
            end
            
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.CSFFlag,...
                ' . CSF Signal:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            if Para.CSFFlag{1}==1
                NameStr=[NameStr; {' . . Mask:  '}];
                DataStr=[DataStr; Para.CSFMsk(1, 1)];
            end    
           
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.HMFlag,...
                ' . Head Motion:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            if Para.HMFlag{1}==1
                [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.HMSgy,...
                    ' . . Regressing Out Strategy:  ');
                NameStr=[NameStr; tmp_name_str];
                DataStr=[DataStr; tmp_data_str];
            end              
        case 'TEMPORALLY DETREND'
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.PolyOrd,...
                ' . Detrending Order:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
        case 'TEMPORALLY FILTER'
            NameStr=[NameStr; {' . TR (s):  '}];  
            DataStr=[DataStr; {num2str(Para.TR{1})}];            
            NameStr=[NameStr; {' . Band (Hz):  '}];
            DataStr=[DataStr; {['[',num2str(Para.Band{1}), ']']}];
        case 'SCRUBBING'
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.InterSgy,...
                ' . Interpolation Strategy:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            
            NameStr=[NameStr; {' . FD Threshold:  '}];
            DataStr=[DataStr; {num2str(Para.FDTrd{1})}];    
            
            NameStr=[NameStr; {' . Previous Time Point Number:  '}];
            DataStr=[DataStr; {num2str(Para.PreNum{1})}];
            
            NameStr=[NameStr; {' . Subsequent Time Point Number:  '}];
            DataStr=[DataStr; {num2str(Para.PostNum{1})}];
        case 'STATIC CORRELATION'
            NameStr=[NameStr; {' . Atlas:  '}];
            DataStr=[DataStr; Para.FCAtlas(1, 1)];  
            
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.FZTFlag,...
                ' . Fisher''s Z Transform:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];            
        case 'DYNAMICAL CORRELATION'
            NameStr=[NameStr; {' . Atlas:  '}];
            DataStr=[DataStr; Para.FCAtlas(1, 1)];  
            
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.FZTFlag,...
                ' . Fisher''s Z Transform:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str]; 
            
            NameStr=[NameStr; {' . Sliding Window Length (time point):  '}];
            DataStr=[DataStr; {num2str(Para.SWL{1})}];
            
            NameStr=[NameStr; {' . Sliding Window Step (time point):  '}];
            DataStr=[DataStr; {num2str(Para.SWS{1})}];
    end
end

function UpdateItemList(ListObj, Para, Key)
if isempty(Key)
    Str=[];
    Val=[];
else
    ItemCell=Para.(Key);
    if numel(ItemCell)==1
        Str=num2str(ItemCell{1});
        Val=1;
        if any(strcmpi(Str, '<-X'))
            Str='';
        end
    else
        if iscell(ItemCell{1, 2})
            Val=ItemCell{1, 1};
            Str=ItemCell{1, 2};
            Str{Val, 1}=['*', Str{Val, 1}];
        else
            Str=ItemCell{1, 2};
            Val=1;
            if isempty(Str)
                Val=[];
            end
        end
    end
end
set(ListObj, 'String', Str, 'Value', Val);

function Key=GenItemKey(PipeListObj)
Key=[];

PipeVal=get(PipeListObj, 'Value');
PipeStr=get(PipeListObj, 'String');

PipeTar=PipeStr(PipeVal);
if ~isempty(PipeTar)
    if strfind(PipeTar{1}, ' . Time Point Number:  ')
        Key='TP';
    elseif strfind(PipeTar{1}, ' . Time Point Number to Remove:  ')
        Key='DelImg';
    elseif strfind(PipeTar{1}, ' . TR (s):  ')
        Key='TR';
    elseif strfind(PipeTar{1}, ' . Slice Order:  ')
        Key='SliOrd';
    elseif strfind(PipeTar{1}, ' . Reference Slice:  ')
        Key='RefSli';
    elseif strfind(PipeTar{1}, ' . Num Passes:  ')
        Key='NumPasses';
    elseif strfind(PipeTar{1}, ' . . Source Image Path:  ')
        Key='SourPath';
    elseif strfind(PipeTar{1}, ' . . Source Image Prefix:  ')
        Key='SourPrefix';        
    elseif strfind(PipeTar{1}, ' . Normalizing Strategy:  ')
        Key='NormSgy';
    elseif strfind(PipeTar{1}, '. . EPI Template:  ')
        Key='EPITpm';
    elseif strfind(PipeTar{1}, ' . . . T1 Image Path:  ')
        Key='T1Path'; 
    elseif strfind(PipeTar{1}, ' . . . T1 Image Prefix:  ')
        Key='T1Prefix';        
    elseif strfind(PipeTar{1}, ' . . . T1 DICOM to NIfTI:  ')
        Key='T1Dcm2NiiFlag';
    elseif strfind(PipeTar{1}, ' . . . Grey Matter Template:  ')
        Key='GMTpm';
    elseif strfind(PipeTar{1}, ' . . . White Matter Template:  ')
        Key='WMTpm';        
    elseif strfind(PipeTar{1}, ' . . . CSF Template:  ')
        Key='CSFTpm';
    elseif strfind(PipeTar{1}, ' . . . Tissue Template:  ')
        Key='TPMTpm';
    elseif strfind(PipeTar{1}, ' . . Bounding Box:  ')
        Key='BBox';
    elseif strfind(PipeTar{1}, ' . . Voxel Sizes (mm):  ')
        Key='VoxSize';
    elseif strfind(PipeTar{1}, ' . FWHM (mm):  ')
        Key='FWHM';
    elseif strfind(PipeTar{1}, ' . Global Signal:  ')
        Key='GSFlag';
    elseif strfind(PipeTar{1}, ' . White Matter Signal:  ')
        Key='WMFlag';
    elseif strfind(PipeTar{1}, ' . CSF Signal:  ')
        Key='CSFFlag';
    elseif strfind(PipeTar{1}, ' . . Mask:  ')
        TmpTar=PipeStr(PipeVal-1);
        if strfind(TmpTar{1}, ' . Global Signal:  ')
            Key='GSMsk';
        elseif strfind(TmpTar{1}, ' . White Matter Signal:  ')
            Key='WMMsk';
        elseif strfind(TmpTar{1}, ' . CSF Signal:  ')
            Key='CSFMsk';
        end
    elseif strfind(PipeTar{1}, ' . Head Motion:  ')
        Key='HMFlag';
    elseif strfind(PipeTar{1}, ' . . Regressing Out Strategy:  ')
        Key='HMSgy';
    elseif strfind(PipeTar{1}, ' . Detrending Order:  ')
        Key='PolyOrd';
    elseif strfind(PipeTar{1}, ' . Band (Hz):  ')
        Key='Band';
    elseif strfind(PipeTar{1}, ' . Interpolation Strategy:  ')
        Key='InterSgy';        
    elseif strfind(PipeTar{1}, ' . FD Threshold:  ')
        Key='FDTrd';
    elseif strfind(PipeTar{1}, ' . Previous Time Point Number:  ')
        Key='PreNum';
    elseif strfind(PipeTar{1}, ' . Subsequent Time Point Number:  ')
        Key='PostNum';
    elseif strfind(PipeTar{1}, ' . Atlas:  ')
        Key='FCAtlas';
    elseif strfind(PipeTar{1}, ' . Fisher''s Z Transform:  ')
        Key='FZTFlag'; 
    elseif strfind(PipeTar{1}, ' . Sliding Window Length (time point):  ')
        Key='SWL';
    elseif strfind(PipeTar{1}, ' . Sliding Window Step (time point):  ')
        Key='SWS';         
    end
end

function [NameStr, DataStr]=GenOptionalStr(ItemCell, Title)
ItemTyp=ItemCell{2};
ItemStr=ItemTyp{ItemCell{1}};
NameStr={Title};
DataStr={ItemStr};

function UpdateInputInterface(hObject, Mode)
handles=guidata(hObject);
if Mode==1
    Prefix=get(handles.KeyEty, 'String');
    if isempty(Prefix)
        Prefix='*';
        set(handles.KeyEty, 'String', Prefix);
    end
    FunPDir=handles.FunPDir;

    if isempty(FunPDir)
        return
    end

    SubStruct=dir(FunPDir);
    SubInd=cellfun(...
        @ (NotDot) (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
        {SubStruct.name});
    SubStruct=SubStruct(SubInd);

    SubDirInd=cell2mat({SubStruct.isdir});
    SubFileInd=~SubDirInd;

    SubDirStr=cellfun(@(s) fullfile(FunPDir, s), {SubStruct(SubDirInd).name}',...
        'UniformOutput', false);
    SubFileStr=cellfun(@(s) fullfile(FunPDir, s), {SubStruct(SubFileInd).name}',...
        'UniformOutput', false);

    SubDirS=cellfun(@(p) GenSubDirS(p, Prefix, handles.InputList), SubDirStr,...
        'UniformOutput', false);
    SubFileS=cellfun(@(p) GenSubFileS(p, Prefix, handles.InputList), SubFileStr,...
        'UniformOutput', false);

    TmpInd=cellfun(@isempty, SubDirS);
    SubDirS=SubDirS(~TmpInd);
    TmpInd=cellfun(@isempty, SubFileS);
    SubFileS=SubDirS(~TmpInd);

    handles.InputS=[SubDirS; SubFileS];
    guidata(hObject, handles);

    TextL1=cellfun(@(S) sprintf('%s', S.Lab),...
        SubDirS, 'UniformOutput', false);
    TextR1=cellfun(@(S) sprintf('%s (%d Files)', S.Alias, S.Num),...
        SubDirS, 'UniformOutput', false);
    TextL2=cellfun(@(S) sprintf('%s', S.Lab),...
        SubFileS, 'UniformOutput', false);
    TextR2=cellfun(@(S) sprintf('%s (%d Files)', S.Alias, S.Num),...
        SubFileS, 'UniformOutput', false);

    TextL=[TextL1; TextL2];
    TextR=[TextR1; TextR2];
elseif Mode==2
    InputS=handles.InputS;
    TextL=cellfun(@(S) sprintf('%s', S.Lab),...
        InputS, 'UniformOutput', false);
    TextR=cellfun(@(S) sprintf('%s (%d Files)', S.Alias, S.Num),...
        InputS, 'UniformOutput', false);
end

%Check
if isempty(TextL) || isempty(TextR)
    Text=[];
else
    Text=ListTextFill(handles.InputList, TextL, TextR, true);
end

if ~isempty(Text)
    Val=1;
else
    Val=[];
    warndlg('Cannot find data, check again!');
end
set(handles.InputList, 'String', Text, 'Value', Val, 'BackgroundColor', [1, 1, 1]);

function ChangedAction(hObject)
handles=guidata(hObject);

ItemKey=handles.CurItemKey;
if ~isempty(ItemKey)
    Para=handles.Para;
    ItemCell=Para.(ItemKey);
    if numel(ItemCell)==1
        if strcmpi(ItemCell{1}, '<-X');
            Def={''};
            Num=1;
        else
            Def={num2str(ItemCell{1})};
            Num=size(Def{1}, 1);
        end
        Ans=inputdlg({'Input Current Item'}, 'Current Item',...
            Num, Def);
        if isempty(Ans)
            return
        end
        Out=str2num(Ans{1});
        if isempty(Out)
            Out=Ans{1};
        end
        handles.Para.(ItemKey)={Out};
        guidata(hObject, handles);
        
        UpdateConfigInterface(hObject)
    else
        if iscell(ItemCell{1, 2})
            StateObj(handles, 'Off');
        else
            if strcmpi(ItemCell{1, 3}, 'F')
                [File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
                    'Select Brain Image File' , ItemCell{1, 2});
                if ~ischar(File)
                    return
                end
                ItemCell{1, 1}=File;
                ItemCell{1, 2}=fullfile(Path, File);
                handles.Para.(ItemKey)=ItemCell;
                guidata(hObject, handles);
                UpdateConfigInterface(hObject);
            elseif strcmpi(ItemCell{1, 3}, 'D')
                Path=ItemCell{1, 2};
                if isempty(Path)
                    Path=pwd;
                end
                Path=uigetdir(Path);
                if ischar(Path)
                    ItemCell{1, 1}=Path;
                    ItemCell{1, 2}=Path;
                    handles.Para.(ItemKey)=ItemCell;
                    guidata(hObject, handles);
                    UpdateConfigInterface(hObject);
                end
            end
        end
    end
end

% Extent Function
function SoFile=GenSoFile(in, Prefix)
Path=fileparts(in{1});
D=dir(fullfile(Path, [Prefix, '.nii']));
if isempty(D)
    D=dir(fullfile(Path, [Prefix, '.img']));
end
SoFile={};
if ~isempty(D)
    SoFile={fullfile(Path, D(1).name)};
end

function FDFile=GenFDFile(in)
Path=fileparts(in{1});
D=dir(fullfile(Path, 'PowerFD.txt'));

FDFile={};
if ~isempty(D)
    FDFile={fullfile(Path, D(1).name)};
end

function HMFile=GenHMFile(in)
Path=fileparts(in{1});
D=dir(fullfile(Path, 'HeadMotionParameter.txt'));

HMFile={};
if ~isempty(D)
    HMFile={fullfile(Path, D(1).name)};
end

function SubjLab=GenSubjLab(Lab)
if ~isempty(strfind(Lab, filesep))
    SubjLab=fileparts(Lab);
else
    if ~isempty(strfind(Lab, '.nii')) ||...
            ~isempty(strfind(Lab, '.img'))
        SubjLab=Lab(1:end-4);
    else
        SubjLab=Lab;
    end
end

function FileList=GenT1Nii(Path, Prefix)

D=dir(fullfile(Path, [Prefix, '.nii'])); % Nii
if isempty(D)
    D=dir(fullfile(Path, [Prefix, '.img']));
end

if ~isempty(D)
    C={D.name}';
    FileList={fullfile(Path, C{1})};
else
    FileList={};
end

function FileList=GenT1Dcm(Path, Prefix)
% DICOM
D=dir(fullfile(Path, [Prefix, '.dcm'])); % DCM
if ~isempty(D)
    C={D.name}';
    FileList={fullfile(Path, C{1})};
    return
end

D=dir(fullfile(Path, [Prefix, '*.IMA'])); % DCM
if ~isempty(D)
    C={D.name}';
    FileList={fullfile(Path, C{1})};
    return
end

D=dir(fullfile(Path, Prefix)); % Unknown
Ind=cellfun(...
    @(IsDir, NotDot) IsDir && (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
    {D.isdir}, {D.name});
D=D(Ind);
if ~isempty(D)
    C={D.name}';
    FileList={fullfile(Path, C{1})};
else
    FileList=[];
end

function S=GenSubFileS(File, Prefix, ListObj)
S=[];
[PPath, Name, Ext]=fileparts(File);

% Update Display
set(ListObj, 'String', sprintf('%s Loaded', [Name, Ext]), 'Value', 1,...
    'BackgroundColor', [0, 0.9, 0]);
drawnow;

if strncmpi(Name, Prefix(1:end-1), length(Prefix(1:end-1))) &&...
        (strcmpi(Ext, '.nii') || strcmpi(Ext, '.img'))
    Nii=nifti(File);
    S.Num=size(Nii.dat, 4);
    S.FileList={File};
    S.Alias='NII4D';
    S.Lab=[Name, Ext];
end

function S=GenSubDirS(Path, Prefix, ListObj)
S=[];
[PPath, SPath]=fileparts(Path);    
% NIfTI File
D=dir(fullfile(Path, [Prefix, '.nii'])); % Nii

% Update Display
set(ListObj, 'String', sprintf('%s Loaded', SPath), 'Value', 1,...
    'BackgroundColor', [0, 0.9, 0]);
drawnow;

if ~isempty(D)
    S.Alias='NII';
else
    D=dir(fullfile(Path, [Prefix, '.img']));
    if ~isempty(D)
        S.Alias='PAIRS';
    end
end

%   3D OR 4D
if ~isempty(D)
    C={D.name}';
    if numel(C)==1
        Nii=nifti(fullfile(Path, C{1}));
        S.Num=size(Nii.dat, 4);
        S.FileList={fullfile(Path, C{1})};
        S.Alias=[S.Alias, '4D'];
        S.Lab=fullfile(SPath, C{1});
    else
        S.Num=numel(C);
        S.FileList=cellfun(@(s) fullfile(Path, s), C, 'UniformOutput', false);
        S.Alias=[S.Alias, '3D'];
        S.Lab=SPath;
    end
    return
end

% DICOM
D=dir(fullfile(Path, [Prefix, '.dcm'])); % DCM
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='DCM';
    S.Lab=SPath;
    return
end

D=dir(fullfile(Path, [Prefix, '*.IMA'])); % DCM
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='IMA';
    S.Lab=SPath;
    return
end

D=dir(fullfile(Path, Prefix)); % Unknown
Ind=cellfun(...
    @(IsDir, NotDot) IsDir && (~strcmpi(NotDot, '.') && ~strcmpi(NotDot, '..') && ~strcmpi(NotDot, '.DS_Store')),...
    {D.isdir}, {D.name});
D=D(Ind);
if ~isempty(D)
    C={D.name}';
    S.Num=numel(C);
    S.FileList={fullfile(Path, C{1})};
    S.Alias='UNKNOWN';
    S.Lab=SPath;
    return
end

% State Objs
function StateObj(handles, State)
set(handles.PreModeToLeft,   'Enable', State);
set(handles.PreModeToRight,  'Enable', State);
set(handles.PostModeToLeft,  'Enable', State);
set(handles.PostModeToRight, 'Enable', State);
set(handles.PreModeList,     'Enable', State);
set(handles.PostModeList,    'Enable', State);
set(handles.PipeOptDown,     'Enable', State);
set(handles.PipeOptUp,       'Enable', State);
set(handles.PipeOptList,     'Enable', State);

set(handles.InputList,       'Enable', State);
set(handles.KeyEty,          'Enable', State);
set(handles.InputDirEty,     'Enable', State);
set(handles.InputDirBtn,     'Enable', State);

function str=ListTextFill(obj, left, right, tflag)

% function str = cfg_textfill(obj, left, right)
% Fill a text object, so that the left part is left justified and the
% right part right justified. If tflag is set, try to fit text in widget
% by truncating right until at least 5 characters are displayed.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_textfill.m 2138 2008-09-22 13:27:44Z volkmar $
% Inherit from SPM8 by Sandy (cfg_textfill)

% Set OBJ TO POINTS
set(obj, 'units', 'points')

TempObj=copyobj(obj,get(obj,'Parent'));
set(TempObj,'Visible','off','Max',100);

% Find max extent of left string
lext = cfg_maxextent(TempObj, left);
mlext = max(lext);

% Find max extent of right string
rext = cfg_maxextent(TempObj, right);
mrext = max(rext);

% Find extent of single space
% Work around MATLAB inaccuracy by measuring 100 spaces and dividing by 100
spext = cfg_maxextent(TempObj, {repmat(' ',1,100)})/100;

% try to work out slider size
pos = get(TempObj,'Position');
oldun = get(TempObj,'units');

set(TempObj,'units','points');
ppos = get(TempObj,'Position');
set(TempObj,'units',oldun);
sc = 1;%pos(3)/ppos(3);
% assume slider width of 15 points
swidth=10*sc;

pos = get(obj,'Position');
width = max(mlext+mrext,pos(3)-swidth);
if tflag && mlext+mrext > pos(3)-swidth
    newrext = max(5*spext, pos(3)-swidth-mlext);
    trind = find(rext > newrext);
    for k = 1:numel(trind)
        tright = right{trind(k)};
        set(TempObj,'String',['...' tright]);
        ext = get(TempObj,'Extent');
        while ext(3) > newrext
            tright = tright(2:end);
            set(TempObj,'String',['...' tright]);
            ext = get(TempObj,'Extent');
        end;
        right{trind(k)} = ['...' tright];
        rext(trind(k)) = ext(3);
    end;
    % Re-estimate max extent of trimmed right string
    rext = cfg_maxextent(TempObj, right);
    mrext = max(rext);
    width = mlext+mrext;
end;

fillstr = cell(size(left));
for k = 1:numel(left)
    fillstr{k} = repmat(' ',1,floor((width-(lext(k)+rext(k)))/spext));
end;
str = strcat(left, fillstr, right);
delete(TempObj);
set(obj,'units','normalized');

function ext = cfg_maxextent(obj, str)

% CFG_MAXEXTENT Returns the maximum extent of cellstr STR 
% Returns the maximum extent of obj OBJ when the cellstr STR will be
% rendered in it. MATLAB is not able to work this out correctly on its own
% for multiline strings. Therefore each line will be tried separately and
% its extent will be returned. To avoid 'flicker' appearance, OBJ should be
% invisible. The extent does not include the width of a scrollbar.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: cfg_maxextent.m 3282 2009-07-23 07:44:16Z volkmar $
% Inherit from SPM8 by Sandy

rev = '$Rev: 3282 $'; %#ok
ext = zeros(size(str));
for k = 1:numel(str)
    set(obj,'String',str(k));
    next = get(obj, 'Extent');
    ext(k) = next(3);
end;

function WarningObj(Obj)

for i=1:5
    set(Obj, 'BackgroundColor' , 'Red');
    pause(0.08);
    set(Obj, 'BackgroundColor' , 'White');
    pause(0.08);
end


function ExitCode=CheckBeforeRun(hObject)
ExitCode=0;

handles=guidata(hObject);

InputS=handles.InputS;
if isempty(InputS);
    ExitCode=1;
    warndlg('Please select the directory of functional dataset first!');
    WarningObj(handles.InputList);
    return;
end

Para=handles.Para;
OptStr=get(handles.PipeOptList, 'String');

PreStr=handles.PreModeCell(handles.SelPreInd, 1);
PostStr=handles.PostModeCell(handles.SelPostInd, 1);
AllStr=[PreStr; PostStr];

if isempty(AllStr)
    ExitCode=1;
    WarningObj(handles.PipeOptList);
    return
end
for s=1:numel(AllStr)
    switch upper(AllStr{s})
        case 'DICOM TO NIFTI'
        case 'REMOVE FIRST IMAGES'
            Num=Para.DelImg{1};
            if ~isnumeric(Num)
                ExitCode=1;
                warndlg('Error: Invalid ''Time Point Number to Remove''');
                Val=find(~cellfun(...
                    @isempty, ...
                    strfind(OptStr, ' . Time Point Number to Remove:  ')...
                    )...
                    );
                CurItemKey='DelImg';
                break;
            end            
        case 'SLICE TIMING'
            Num=Para.TR{1};
            if ~isnumeric(Num)
                ExitCode=1;
                warndlg('Error: Invalid ''TR (s)''');
                Val=find(~cellfun(...
                    @isempty, ...
                    strfind(OptStr, ' . TR (s):  ')...
                    )...
                    );
                CurItemKey='TR';
                break;
            end  
        case 'REALIGN'
        case 'NORMALIZE'
            NormInd=Para.NormSgy{1};
            if NormInd~=1
                Path=Para.T1Path{2};
                if isempty(Path)
                    ExitCode=1;
                    warndlg('Error: Invalid ''T1 Image Path''');
                    Val=find(~cellfun(...
                        @isempty, ...
                        strfind(OptStr, ' . . . T1 Image Path:  ')...
                        )...
                        );
                    CurItemKey='TR';
                    break;
                end
            end
        case 'SPATIALLY SMOOTH'         
        case 'REGRESS OUT COVARIATES'           
        case 'TEMPORALLY DETREND'
        case 'TEMPORALLY FILTER'
            Num=Para.TR{1};
            if ~isnumeric(Num)
                ExitCode=1;
                warndlg('Error: Invalid ''TR (s)''');
                Val=find(~cellfun(...
                    @isempty, ...
                    strfind(OptStr, ' . TR (s):  ')...
                    )...
                    );
                CurItemKey='TR';
                break;
            end
        case 'SCRUBBING'
        case 'STATIC CORRELATION'
        case 'DYNAMICAL CORRELATION'
    end
end

if ~ExitCode
    return
end
handles.CurItemKey=CurItemKey;
guidata(hObject, handles);
set(handles.PipeOptList, 'Value', Val);
WarningObj(handles.PipeOptList);
