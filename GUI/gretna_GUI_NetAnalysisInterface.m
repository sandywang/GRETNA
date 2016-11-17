function varargout = gretna_GUI_NetAnalysisInterface(varargin)
% GRETNA_GUI_NETANALYSISINTERFACE MATLAB code for gretna_GUI_NetAnalysisInterface.fig
%      GRETNA_GUI_NETANALYSISINTERFACE, by itself, creates a new GRETNA_GUI_NETANALYSISINTERFACE or raises the existing
%      singleton*.
%
%      H = GRETNA_GUI_NETANALYSISINTERFACE returns the handle to a new GRETNA_GUI_NETANALYSISINTERFACE or the handle to
%      the existing singleton*.
%
%      GRETNA_GUI_NETANALYSISINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRETNA_GUI_NETANALYSISINTERFACE.M with the given input arguments.
%
%      GRETNA_GUI_NETANALYSISINTERFACE('Property','Value',...) creates a new GRETNA_GUI_NETANALYSISINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gretna_GUI_NetAnalysisInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gretna_GUI_NetAnalysisInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gretna_GUI_NetAnalysisInterface

% Last Modified by GUIDE v2.5 16-Nov-2016 13:13:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gretna_GUI_NetAnalysisInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @gretna_GUI_NetAnalysisInterface_OutputFcn, ...
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


% --- Executes just before gretna_GUI_NetAnalysisInterface is made visible.
function gretna_GUI_NetAnalysisInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gretna_GUI_NetAnalysisInterface (see VARARGIN)

% Choose default command line output for gretna_GUI_NetAnalysisInterface

% Init Input Structure
handles.InputMatCell=[];
handles.InputS=[];
handles.PipeLogPath=[];

% Network Configuration
%   Network Sign
handles.Para.NetSign={1,...
    {'Positive';...
    'Negative';...
    'Absolute'}};
handles.Para.ThresType={1,...
    {'Network Sparsity';...
    'Similarity Threshold'}};
handles.Para.Thres={0.05:0.05:0.5};
handles.Para.NetType={1,...
    {'Binary';...
    'Weighted'}};

% Random Network Number
handles.Para.RandNum={100};

% Init Global Network Metric Procedures
handles.GlobalModeCell={...
    'Global - Small-World',     1;...
    'Global - Efficiency',      2;...
    'Global - Rich-Club',       3;...
    'Global - Assortativity',   4;...
    'Global - Synchronization', 5;...
    'Global - Hierarchy',       6};

% Global - Small-World
handles.Para.ClustAlgor={1,...
    {'Onnela et al., 2005'; 'Barrat et al., 2009'}};
% Global - Modularity
handles.Para.ModulAlgor={1,...
    {'Modified Greedy Optimization';...
    'Spectral Optimization'}};
handles.Para.DDPcFlag={1,...
    {'TRUE'; 'FALSE'}};

% % Init Postprocess Procedures
% handles.NodalModeCell={...
%     'Nodal - Degree Centrality',       1;...
%     'Nodal - Betweenness Centrality',  2;...
%     'Nodal - Efficiency',              3;...
%     'Nodal - Eigenvector Centrality',  4;...
%     'Nodal - Subgraph Centrality',     5;...
%     'Nodal - Page-Rank Centrality',    6;...
%     'Nodal - K-Core Centrality',       7;...
%     'Nodal - Participant Coefficient', 8};
% Init Postprocess Procedures
handles.NodalModeCell={...
    'Nodal - Community Index',         1;...
    'Nodal - Participant Coefficient', 2;...
    'Modular - Interaction',           3;...
    'Nodal - Degree Centrality',       4;...
    'Nodal - Betweenness Centrality',  5;...
    'Nodal - Efficiency',              6};

handles.Para.CIndex={'<-X'};
% Init Mode List Index
handles.UnselPreInd=(1:6)';
handles.SelPreInd=[];
handles.UnselPostInd=(1:6)';
handles.SelPostInd=[];

% Init Current Item Key
handles.CurItemKey=[];

% Init Fun Parent Dir
handles.OutputDir=[];

handles.MainFig=hObject;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

UpdateConfigInterface(hObject);
% UIWAIT makes gretna_GUI_NetAnalysisInterface wait for user response (see UIRESUME)
% uiwait(handles.MainFig);


% --- Outputs from this function are returned to the command line.
function varargout = gretna_GUI_NetAnalysisInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in GlobalModeList.
function GlobalModeList_Callback(hObject, eventdata, handles)
% hObject    handle to GlobalModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GlobalModeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GlobalModeList


% --- Executes during object creation, after setting all properties.
function GlobalModeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GlobalModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on GlobalModeList and none of its controls.
function GlobalModeList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to GlobalModeList (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in NodalModeList.
function NodalModeList_Callback(hObject, eventdata, handles)
% hObject    handle to NodalModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NodalModeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NodalModeList


% --- Executes during object creation, after setting all properties.
function NodalModeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NodalModeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GlobalModeToRight.
function GlobalModeToRight_Callback(hObject, eventdata, handles)
% hObject    handle to GlobalModeToRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UnselModeVal=get(handles.GlobalModeList, 'Value');
UnselModeStr=get(handles.GlobalModeList, 'String');
UnselModeTar=UnselModeStr(UnselModeVal);
Msk=strcmpi(UnselModeTar{1}, handles.GlobalModeCell(:, 1));
Ind=handles.GlobalModeCell(Msk, 2);
Ind=Ind{1};

handles.UnselPreInd(handles.UnselPreInd==Ind)=[];
handles.SelPreInd=[handles.SelPreInd; Ind];

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on button press in GlobalModeToLeft.
function GlobalModeToLeft_Callback(hObject, eventdata, handles)
% hObject    handle to GlobalModeToLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelModeVal=get(handles.PipeOptList, 'Value');
SelModeStr=get(handles.PipeOptList, 'String');
SelModeTar=SelModeStr(SelModeVal);
Msk=cellfun(@(s) strncmpi(SelModeTar{1}(4:end), s, length(s)), handles.GlobalModeCell(:, 1));
Ind=handles.GlobalModeCell(Msk, 2);
Ind=Ind{1};

handles.SelPreInd(handles.SelPreInd==Ind)=[];
handles.UnselPreInd=[handles.UnselPreInd; Ind];
handles.UnselPreInd=sort(handles.UnselPreInd);

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on button press in NodalModeToRight.
function NodalModeToRight_Callback(hObject, eventdata, handles)
% hObject    handle to NodalModeToRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UnselModeVal=get(handles.NodalModeList, 'Value');
UnselModeStr=get(handles.NodalModeList, 'String');
UnselModeTar=UnselModeStr(UnselModeVal);
Msk=strcmpi(UnselModeTar{1}, handles.NodalModeCell(:, 1));
Ind=handles.NodalModeCell(Msk, 2);
Ind=Ind{1};

handles.UnselPostInd(handles.UnselPostInd==Ind)=[];
handles.SelPostInd=[handles.SelPostInd; Ind];

guidata(hObject, handles);

UpdateConfigInterface(hObject);

% --- Executes on button press in NodalModeToLeft.
function NodalModeToLeft_Callback(hObject, eventdata, handles)
% hObject    handle to NodalModeToLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelModeVal=get(handles.PipeOptList, 'Value');
SelModeStr=get(handles.PipeOptList, 'String');
SelModeTar=SelModeStr(SelModeVal);
Msk=cellfun(@(s) strncmpi(SelModeTar{1}(4:end), s, length(s)), handles.NodalModeCell(:, 1));
Ind=handles.NodalModeCell(Msk, 2);
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
% handles    structureedit  with handles and user data (see GUIDATA)
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



function OutputDirEty_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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

if ~isempty(handles.OutputDir)
    OldPath=handles.OutputDir;
else
    OldPath=pwd;
end

Path=uigetdir(OldPath, 'Path of Functional Dataset');
if isnumeric(Path)
    return
end
handles.OutputDir=Path;
set(handles.OutputDirEty, 'String', Path)
guidata(hObject, handles);

function KeyEty_Callback(hObject, eventdata, handles)
% hObject    handle to KeyEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateInputInterface(hObject, 2);
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
if ~strcmpi(get(handles.MainFig , 'SelectionType') , 'normal')
    Val=get(handles.InputList, 'Value');
    DisplayMat(handles.InputS, Val);
end
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
Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.GlobalModeCell(:, 1));

if any(Msk) % PreMod
    Ind=handles.GlobalModeCell(Msk, 2);
    Ind=Ind{1};
    
    Sel=find(handles.SelPreInd==Ind);
    handles.SelPreInd([Sel-1, Sel])=handles.SelPreInd([Sel, Sel-1]);
else % PostMode
    Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.NodalModeCell(:, 1));
    Ind=handles.NodalModeCell(Msk, 2);
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
Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.GlobalModeCell(:, 1));

if any(Msk)
    Ind=handles.GlobalModeCell(Msk, 2);
    Ind=Ind{1};
    
    Sel=find(handles.SelPreInd==Ind);
    handles.SelPreInd([Sel, Sel+1])=handles.SelPreInd([Sel+1, Sel]);
else
    Msk=cellfun(@(s) strncmpi(SelModeTar{1}, s, length(s)), handles.NodalModeCell(:, 1));
    Ind=handles.NodalModeCell(Msk, 2);
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
Thres=Para.Thres{1};
if ~isnumeric(Thres)
    Thres=str2num(Thres);
end
% Generate Interval
AUCInterval=0;
if numel(Thres)>1
    AUCInterval=Thres(2)-Thres(1);
end

GlobalStr=handles.GlobalModeCell(handles.SelPreInd);
NodalStr=handles.NodalModeCell(handles.SelPostInd);
AllStr=[GlobalStr; NodalStr];

OutputDir=handles.OutputDir;
MatList=cellfun(@(S) S.Mat, handles.InputS, 'UniformOutput', false);
AList=cellfun(@(S) S.Alias, handles.InputS, 'UniformOutput', false);
IndList=arrayfun(@(d) sprintf('%.5d', d), (1:numel(AList))',...
    'UniformOutput', false);
Map=[IndList, AList];
OldInputStr=get(handles.InputList, 'String');
Pl=[];

% Network Construction
% Thresholding Connectivity Matrix to Construct Network
FileList=cellfun(@(S) S.File, handles.InputS, 'UniformOutput', false);
GrpID=cellfun(@(S) S.GrpID, handles.InputS);
OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'RealNet.mat'),...
    AList, 'UniformOutput', false);
PCell=cellfun(@(mat, in, out)...
    gretna_GEN_ThresMat(mat, in, out, Para.NetSign{1}, Para.ThresType{1}, Thres, Para.NetType{1}),...
    MatList, FileList, OutputMatList,...
    'UniformOutput', false);
TList=cellfun(@(i) sprintf('ThresMat%s', i), IndList,...
    'UniformOutput', false);
Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
RealNetList=cellfun(@(S) S.OutputMatFile, PCell, 'UniformOutput', false);
RandNetList=cellfun(@(S) [], PCell, 'UniformOutput', false);

if ~isempty(GlobalStr) && Para.RandNum{1}>0
    OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'RandNet.mat'),...
        AList, 'UniformOutput', false);
    PCell=cellfun(@(in, out)...
        gretna_GEN_GenRandNet(in, out, Para.NetType{1}, Para.RandNum{1}),...
        RealNetList, OutputMatList,...
        'UniformOutput', false);
    
    TList=cellfun(@(i) sprintf('GenRandNet%s', i), IndList,...
        'UniformOutput', false);
    Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
    RandNetList=cellfun(@(S) S.OutputMatFile, PCell, 'UniformOutput', false);
end
% Network Metric Estimation
AllIndiMatList=cell(numel(AllStr), 1);
AllInteMatList=cell(numel(AllStr), 1);
for n=1:numel(AllStr)
    ModeName=AllStr{n};
    switch upper(ModeName)
        case 'GLOBAL - SMALL-WORLD'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'SW.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'SmallWorld', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_SmallWorld(in, rnd, out, Para.NetType{1}, Para.ClustAlgor{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('SmallWorld%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - EFFICIENCY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'EFF.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'NetworkEfficiency', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_GEfficiency(in, rnd, out, Para.NetType{1}, AUCInterval),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('GEfficiency%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
%         case 'GLOBAL - MODULARITY'
%             OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'MOD.mat'),...
%                 AList, 'UniformOutput', false);
%             InterMat=fullfile(OutputDir, 'Modularity', 'Modularity.mat');                        
%             PCell=cellfun(@(in, rnd, out)...
%                 gretna_GEN_Modularity(in, rnd, out, Para.NetType{1}, Para.ModulAlgor{1}),...
%                 RealNetList, RandNetList, OutputMatList,...
%                 'UniformOutput', false);
%     
%             TList=cellfun(@(i) sprintf('Modularity%s', i), IndList,...
%                 'UniformOutput', false);
%             Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - RICH-CLUB'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'RC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'RichClub', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_RichClub(in, rnd, out, Para.NetType{1}),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('RichClub%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - ASSORTATIVITY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'ASS.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'Assortativity', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_Assortativity(in, rnd, out, Para.NetType{1}),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('Assortativity%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'GLOBAL - SYNCHRONIZATION'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'SYN.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'Synchronization', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_Synchronization(in, rnd, out, Para.NetType{1}),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('Synchronization%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);            
        case 'GLOBAL - HIERARCHY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'HIE.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'Hierarchy', GrpID);
            PCell=cellfun(@(in, rnd, out)...
                gretna_GEN_Hierarchy(in, rnd, out, Para.NetType{1}),...
                RealNetList, RandNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('Hierarchy%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);   
        case 'NODAL - COMMUNITY INDEX'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'CI.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'CommunityIndex', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_CommunityIndex(in, out, Para.NetType{1}, Para.ModulAlgor{1}, Para.DDPcFlag{1}),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('CommunityIndex%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'NODAL - PARTICIPANT COEFFICIENT'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'PC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'ParticipantCoefficient', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_ParticipantCoefficient(in, out, Para.CIndex{1}),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('CommunityIndex%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);  
        case 'MODULAR - INTERACTION'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'MI.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'ModularInteraction', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_ModularInteraction(in, out, Para.NetType{1}, Para.CIndex{1}),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('ModularInteraction%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
        case 'NODAL - DEGREE CENTRALITY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'DC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'DegreeCentrality', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_DegreeCentrality(in, out, Para.NetType{1}, AUCInterval),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('DegreeCentrality%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);             
        case 'NODAL - BETWEENNESS CENTRALITY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'BC.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'BetweennessCentrality', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_BetweennessCentrality(in, out, Para.NetType{1}, AUCInterval),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('BetweennessCentrality%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);             
        case 'NODAL - EIGENVECTOR CENTRALITY'
        case 'NODAL - SUBGRAPH CENTRALITY'
        case 'NODAL - PAGE-RANK CENTRALITY'
        case 'NODAL - K-CORE CENTRALITY'
        case 'NODAL - PARTICIPANT CENTRALITY'
        case 'NODAL - EFFICIENCY'
            OutputMatList=cellfun(@(a) fullfile(OutputDir, a, 'NE.mat'),...
                AList, 'UniformOutput', false);
            InterMat=GenInterMat(OutputDir, 'NodalEfficiency', GrpID);
            PCell=cellfun(@(in, out)...
                gretna_GEN_NodalEfficiency(in, out, Para.NetType{1}, AUCInterval),...
                RealNetList, OutputMatList,...
                'UniformOutput', false);
    
            TList=cellfun(@(i) sprintf('NodalEfficiency%s', i), IndList,...
                'UniformOutput', false);
            Pl=gretna_FUN_Cell2Pipe(Pl, TList, PCell);
    end
    AllIndiMatList{n, 1}=GenIndiMat(OutputMatList, GrpID);
    AllInteMatList{n, 1}=InterMat;
end
Pl.ResultIntegrating=gretna_GEN_ResultIntegrating(AllIndiMatList, AllInteMatList);

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
PPath=fileparts(handles.OutputDir);
PipeLogPath=fullfile(PPath, 'GretnaLogs', 'NetAnalysis');
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
            ALab=AList(strcmpi(IndList, Ind));
            SubjString=ALab{1};
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


% --- Executes on button press in RmMatBtn.
function RmMatBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RmMatBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Val=get(handles.InputList, 'Value');
if isempty(Val)
    return
end
%handles.InputMatCell(Val)=[];
CurS=handles.InputS{Val};
handles.InputS(Val)=[];

SInd=cellfun(@(S) strcmpi(S.File, CurS.File), handles.InputS);
if ~any(SInd)
    FInd=strcmpi(handles.InputMatCell, CurS.File);
    handles.InputMatCell(FInd)=[];
end
guidata(hObject, handles);

UpdateInputInterface(hObject, 2);

% --- Executes on button press in SaveBtn.
function SaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File , Path]=uiputfile('*.mat', 'Save configure' ,...
    'MyNetAnalysisConfig.mat' );
if ischar(File)
    SaveName=fullfile(Path, File);
    
    Input=[];Mode=[];
    % Input Config
    Input.InputS=handles.InputS;
    Input.InputMatCell=handles.InputMatCell;
    %Input.InputKey=get(handles.KeyEty, 'String');
    Output.OutputDir=handles.OutputDir;
    % Mode Config
    Mode.CurItemKey=handles.CurItemKey;
    
    Mode.UnselPreInd=handles.UnselPreInd;
    Mode.SelPreInd=handles.SelPreInd;
    
    Mode.UnselPostInd=handles.UnselPostInd;
    Mode.SelPostInd=handles.SelPostInd;
    
    Para=handles.Para;
    
    save(SaveName , 'Input', 'Output', 'Mode', 'Para');
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
    handles.InputMatCell=Input.InputMatCell;
    handles.OutputDir=Output.OutputDir;
    set(handles.OutputDirEty, 'String', Output.OutputDir);
    
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

% --- Executes on button press in InputMatBtn.
function InputMatBtn_Callback(hObject, eventdata, handles)
% hObject    handle to InputMatBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File, Path] = uigetfile({'*.txt;*.mat','Brain Connectivity Matrix (*.txt;*.mat)';'*.*', 'All Files (*.*)';}, ...
            'Pick brain connectivity matrices' , 'MultiSelect' , 'On');
if ischar(File)
    File={File};
end

if iscell(File)
    File=File';
    MatCell=cellfun(@(f) fullfile(Path, f), File, 'UniformOutput', false);
    handles.InputMatCell=[handles.InputMatCell; MatCell];
    
    set(handles.InputList, 'BackgroundColor', [0, 0.9, 0]);
    drawnow;

    FileS=cellfun(@(f) GenMatFileS(f, handles.InputList) , MatCell, 'UniformOutput', false);

    InputS=[];
    for i=1:numel(FileS)
        if iscell(FileS{i})
           tmp=FileS{i};
        else
           tmp=FileS(i);
        end
        InputS=[InputS; tmp];
    end
    handles.InputS=[handles.InputS; InputS];
    guidata(hObject, handles);
    
    UpdateInputInterface(hObject, 2);
end

% --- Executes on button press in GrpIDBtn.
function GrpIDBtn_Callback(hObject, eventdata, handles)
% hObject    handle to GrpIDBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Val=get(handles.InputList, 'Value');
if Val==0
    return
end
InputS=handles.InputS;

GrpID=cellfun(@(S) S.GrpID, InputS);

Ans=inputdlg({'Input Current Item'}, 'Current Item',...
    1, {num2str(GrpID')});
if isempty(Ans)
    return
end
GrpID=str2num(Ans{1})';

for i=1:numel(InputS)
    InputS{i}.GrpID=GrpID(i);
end
handles.InputS=InputS;
guidata(hObject, handles);

UpdateInputInterface(hObject, 2);



% --- Executes on button press in ShowAllBtn.
function ShowAllBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAllBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IndList=(1:numel(handles.InputS));
DisplayMat(handles.InputS, IndList)

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
UnselGlobalStr=handles.GlobalModeCell(handles.UnselPreInd, 1);
PreToRight=UpdateModeList(handles.GlobalModeList, UnselGlobalStr);

UnselNodalStr=handles.NodalModeCell(handles.UnselPostInd, 1);
PostToRight=UpdateModeList(handles.NodalModeList, UnselNodalStr);

% Update Option List
SelGlobalStr=handles.GlobalModeCell(handles.SelPreInd, 1);
SelNodalStr=handles.NodalModeCell(handles.SelPostInd, 1);
[PreToLeft, PostToLeft, OptToUp, OptToDown]=UpdateOptList(handles.PipeOptList, ...
    SelGlobalStr, SelNodalStr, handles.Para);

% Update Item List
%UpdateItemList(handles.OptItemList, handles.PipeOptList, handles.Para);
Key=GenItemKey(handles.PipeOptList);
UpdateItemList(handles.OptItemList, handles.Para, Key);
handles.CurItemKey=Key;

% Enable All Obj
StateObj(handles, 'On');

% Update Button
set(handles.GlobalModeToLeft, 'Enable', PreToLeft);
set(handles.GlobalModeToRight, 'Enable', PreToRight);

set(handles.NodalModeToLeft, 'Enable', PostToLeft);
set(handles.NodalModeToRight, 'Enable', PostToRight);

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

function [PreToLeft, PostToLeft, OptToUp, OptToDown]=UpdateOptList(ListObj, GlobalStr, NodalStr, Para)
% Get Offset
if ~isempty(GlobalStr)
    OptOffset=11;
else
    OptOffset=9;
end

GlobalStr=cellfun(@(s) [' . ', s], GlobalStr, 'UniformOutput', false);
NodalStr=cellfun(@(s) [' . ', s], NodalStr, 'UniformOutput', false);

PreToLeft='On';
PostToLeft='On';
OptToUp='On';
OptToDown='On';

if isempty(GlobalStr)
    PreToLeft='Off';
end

if isempty(NodalStr)
    PostToLeft='Off';
end

if isempty([GlobalStr; NodalStr])
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
            [GlobalStr; NodalStr]), 1);
        if isempty(ModeVal)
            TmpOldVal=OldVal-1;
            while TmpOldVal>0
                TmpOldTar=OldStr(TmpOldVal);
                ModeVal=find(cellfun(@ (s) strncmpi(s, TmpOldTar{1}, length(s)), ...
                    [GlobalStr; NodalStr]), 1);
                if ~isempty(ModeVal)
                    break
                end
                TmpOldVal=TmpOldVal-1;
            end
            
            if isempty(ModeVal)
                ModeVal=1;
            end
            
            if (~strncmpi(OldTar{1}, ' . Global', 9)) &&...
                    (~strncmpi(OldTar{1}, ' . Nodal', 8)) &&...
                    (~strncmpi(OldTar{1}, ' . Modular', 7))
                PreToLeft='Off';
                PostToLeft='Off';
                OptToUp='Off';
                OptToDown='Off';
            end
        end
    end
    
    % Justify To Whether To Left
    AllStr=[GlobalStr; NodalStr];
    ModeStr=AllStr(ModeVal);
    if isempty(find(strcmpi(ModeStr{1}, GlobalStr), 1))
        PreToLeft='Off';
    end
    if isempty(find(strcmpi(ModeStr{1}, NodalStr), 1))
        PostToLeft='Off';
    end
    
%     % Justify Whether Up or Down
%     if ModeVal<=numel(GlobalStr) % Pre
%         if ModeVal==1
%             OptToUp='Off';
%             if strcmpi(GlobalStr{ModeVal}, 'DICOM TO NIFTI')
%                 OptToDown='Off';
%             end
%         elseif ModeVal==2 && strcmpi(GlobalStr{1}, 'DICOM TO NIFTI')
%             OptToUp='Off';
%         elseif ModeVal==numel(GlobalStr)
%             OptToDown='Off';
%         end
%     else % Post
%         if ModeVal==numel(GlobalStr)+1
%             OptToUp='Off';
%         end
%         if ModeVal==numel([GlobalStr; NodalStr])
%             OptToDown='Off';
%         end 
%         
%         % Disabled Up Down Now;
%         OptToUp='Off';
%         OptToDown='Off';
%     end
    
    % Generate PipeOptStr
    [NameStr, DataStr]=GenOptStr([GlobalStr; NodalStr], ModeVal, Para);
    
    FinalStr=ListTextFill(ListObj, NameStr, DataStr, true);
    
    if numel(FinalStr)==numel(OldStr) && ~any(cellfun(@(s) strncmpi(s, OldTar{1}, length(s)), [GlobalStr; NodalStr]))
        % Dirty Code
        FinalVal=OldVal;
    else
        if isempty(OldTar)
            FinalVal=1+OptOffset;
        else
            FinalVal=find(cellfun(@(s) strncmpi(s, OldTar{1}, length(s)), NameStr), 1);
        end
        if isempty(FinalVal)
            if TmpOldVal==0
                FinalVal=1+OptOffset;
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

if isempty(Str)
   return 
end

% Network Configuration
NameStr=[NameStr; {'Network Configuration'}];
DataStr=[DataStr; {''}];

NameStr=[NameStr; {' . Identify How to Manipulate the Sign of Matrix'}];
DataStr=[DataStr; {''}];    
[tmp_name_str, tmp_data_str]=GenOptionalStr(Para.NetSign, ' . . Sign:  ');
NameStr=[NameStr; tmp_name_str];
DataStr=[DataStr; tmp_data_str];
    
NameStr=[NameStr; {' . Identify the Method to Thresholding'}];
DataStr=[DataStr; {''}];     
[tmp_name_str, tmp_data_str]=GenOptionalStr(Para.ThresType, ' . . Method:  ');
NameStr=[NameStr; tmp_name_str];
DataStr=[DataStr; tmp_data_str];

NameStr=[NameStr; {' . . Threshold Sequence:  '}]; 
tmp_data_str=Para.Thres{1};
if numel(tmp_data_str)>2
    tmp_data_str=sprintf('%d x %d %s', size(tmp_data_str, 1), size(tmp_data_str, 2), class(tmp_data_str) );
else
    tmp_data_str=num2str(tmp_data_str);
end
DataStr=[DataStr; {tmp_data_str}]; 

NameStr=[NameStr; {' . Identify Network Type'}];
DataStr=[DataStr; {''}];    
[tmp_name_str, tmp_data_str]=GenOptionalStr(Para.NetType, ' . . Type:  ');
NameStr=[NameStr; tmp_name_str];
DataStr=[DataStr; tmp_data_str]; 
if any(~cellfun(@isempty, strfind(Str, 'Global -')))
    NameStr=[NameStr; {' . Generate Random Networks'}];
    DataStr=[DataStr; {''}]; 
    NameStr=[NameStr; {' . . Random Network Number:  '}];  
    DataStr=[DataStr; {num2str(Para.RandNum{1})}]; 
end

NameStr=[NameStr; {'Network Metrics'}];
DataStr=[DataStr; {''}]; 

for s=1:numel(Str)
    NameStr=[NameStr; Str(s)];
    DataStr=[DataStr; {''}];
    %if s==ModeVal
    switch upper(Str{s}(4:end))
        case 'GLOBAL - SMALL-WORLD'
            %if Para.NetType{1}==2
            %    [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.ClustAlgor, ' . . Clustering Algorithm:  ');
            %    NameStr=[NameStr; tmp_name_str];
            %    DataStr=[DataStr; tmp_data_str];
            %end
        case 'GLOBAL - EFFICIENCY'
%         case 'GLOBAL - MODULARITY'
%             [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.ModulAlgor, ' . . Modularity Algorithm:  ');
%             NameStr=[NameStr; tmp_name_str];
%             DataStr=[DataStr; tmp_data_str];            
        case 'GLOBAL - RICH-CLUB'
        case 'GLOBAL - ASSORTATIVITY'
        case 'GLOBAL - SYNCHRONIZATION'
        case 'GLOBAL - HIERARCHY'
        case 'NODAL - COMMUNITY INDEX'
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.ModulAlgor, ' . . Modularity Algorithm:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];
            [tmp_name_str, tmp_data_str]=GenOptionalStr(Para.DDPcFlag, ' . . Estimating Participant Coefficient:  ');
            NameStr=[NameStr; tmp_name_str];
            DataStr=[DataStr; tmp_data_str];            
        case 'NODAL - PARTICIPANT COEFFICIENT'
            NameStr=[NameStr; {' . . Community Index:  '}]; 
            tmp_data_str=Para.CIndex{1};
            if isnumeric(tmp_data_str)
                if numel(tmp_data_str)>2
                    tmp_data_str=sprintf('%d x %d %s', ...
                        size(tmp_data_str, 1), size(tmp_data_str, 2), class(tmp_data_str) );
                else
                    tmp_data_str=num2str(tmp_data_str);
                end
            end
            DataStr=[DataStr; {tmp_data_str}];        
        case 'MODULAR - INTERACTION'
            NameStr=[NameStr; {' . . Community Index:  '}]; 
            tmp_data_str=Para.CIndex{1};
            if isnumeric(tmp_data_str)
                if numel(tmp_data_str)>2
                    tmp_data_str=sprintf('%d x %d %s', ...
                        size(tmp_data_str, 1), size(tmp_data_str, 2), class(tmp_data_str) );
                else
                    tmp_data_str=num2str(tmp_data_str);
                end
            end
            DataStr=[DataStr; {tmp_data_str}]; 
        case 'NODAL - DEGREE CENTRALITY'
        case 'NODAL - BETWEENNESS CENTRALITY'
        case 'NODAL - CLOSENESS CENTRALITY'
        case 'NODAL - EIGENVECTOR CENTRALITY'
        case 'NODAL - SUBGRAPH CENTRALITY'
        case 'NODAL - PAGE-RANK CENTRALITY'
        case 'NODAL - K-CORE CENTRALITY'
        case 'NODAL - PARTICIPANT CENTRALITY'
        case 'NODAL - EFFICIENCY'
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
    if strfind(PipeTar{1}, ' . . Sign:  ')
        Key='NetSign';
    elseif strfind(PipeTar{1}, ' . . Method:  ')
        Key='ThresType';
    elseif strfind(PipeTar{1}, ' . . Type:  ')
        Key='NetType';
    elseif strfind(PipeTar{1}, ' . . Random Network Number:  ')
        Key='RandNum';
    elseif strfind(PipeTar{1}, ' . . Modularity Algorithm:  ')
        Key='ModulAlgor';
    elseif strfind(PipeTar{1}, ' . . Clustering Algorithm:  ')
        Key='ClustAlgor';        
    elseif strfind(PipeTar{1}, ' . . Threshold Sequence:  ')
        Key='Thres';
    elseif strfind(PipeTar{1}, ' . . Community Index:  ')
        Key='CIndex';
    elseif strfind(PipeTar{1}, ' . . Estimating Participant Coefficient:  ')
        Key='DDPcFlag';
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
    set(handles.InputList, 'BackgroundColor', [0, 0.9, 0]);
    drawnow;
    MatCell=handles.InputMatCell;

    FileS=cellfun(@(f) GenMatFileS(f, handles.InputList) , MatCell, 'UniformOutput', false);

    InputS=[];
    for i=1:numel(FileS)
        if iscell(FileS{i})
           tmp=FileS{i};
        else
           tmp=FileS(i);
        end
        InputS=[InputS; tmp];
    end
    handles.InputS=InputS;
    guidata(hObject, handles);

    TextL=cellfun(@(S) sprintf('%s', S.Lab),...
        InputS, 'UniformOutput', false);
    TextR=cellfun(@(S) sprintf('(%d - %d)', S.Size(1, 1), S.Size(1, 2)),...
        InputS, 'UniformOutput', false);

elseif Mode==2
    InputS=handles.InputS;
    TextL=cellfun(@(S) sprintf('[Group: %d] %s', S.GrpID, S.Lab),...
        InputS, 'UniformOutput', false);
    TextR=cellfun(@(S) sprintf('(%d - %d)', S.Size(1, 1), S.Size(1, 2)),...
        InputS, 'UniformOutput', false);
end

%Check
if isempty(TextL) || isempty(TextR)
    Text=[];
else
    Text=ListTextFill(handles.InputList, TextL, TextR, true);
end

if ~isempty(Text)
    DisplayFlag='On';
    Val=1;
else
    Val=[];
    %warndlg('Cannot find data, check again!');
    DisplayFlag='Off';
end
set(handles.ShowAllBtn, 'Enable', DisplayFlag);
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

function DisplayMat(AllS, IndList)

Max=max(cellfun(@(S) max(S.Mat(:)), AllS(IndList)));
Min=max(cellfun(@(S) min(S.Mat(:)), AllS(IndList)));
H=figure;
for i=1:numel(IndList)
    Ind=IndList(i);
    CurS=AllS{Ind};
    Mat=CurS.Mat;
    Lab=CurS.Lab;
    File=CurS.File;

    I=imagesc(Mat, [Min, Max]);
    A=get(I, 'Parent');
    axis(A, 'image');
    colorbar;
    set(H, 'Name', File, 'Numbertitle' , 'Off');
    title(A, Lab);
    drawnow;
    pause(1);
end


% Extent Function
function S=GenMatFileS(in, ListObj)
set(ListObj, 'String', sprintf('%s%s Loaded', in), 'Value', 1,...
    'BackgroundColor', [0, 0.9, 0]);
drawnow;

M=load(in);
S=GenMatS(M, in);

function S=GenMatS(M, in)
[Path, File, Ext]=fileparts(in);
FileExt=[File, Ext];
S=[];
if isnumeric(M)
    S.File=in;
    S.Type='T';
    S.Alias=File;
    S.Size=size(M);
    S.Lab=sprintf('%s', FileExt);
    S.Mat=M;
    S.GrpID=1;
elseif isstruct(M)
    FN=fieldnames(M);
    for n=1:numel(FN)
        TmpM=M.(FN{n});
        if iscell(TmpM)
            TmpM=reshape(TmpM, [], 1);
            TmpC=cell(size(TmpM));
            for i=1:numel(TmpC)
                TmpS=[];
                TmpS.File=in;
                TmpS.Type='C';
                TmpS.Size=size(TmpM{i});
                TmpS.Lab=sprintf('%s: [%s]%s - %.5d',...
                    FileExt, TmpS.Type, FN{n}, i);
                TmpS.Alias=sprintf('%s_%s_%s%.5d', ...
                    File, TmpS.Type, FN{n}, i);
                TmpS.GrpID=1;
                TmpS.Mat=TmpM{i};
                TmpC{i, 1}=TmpS;
            end
            S=[S; TmpC];
        elseif isstruct(TmpM)
            SubFN=fieldnames(TmpM);
            TmpC=cell(size(SubFN));
            for i=1:numel(SubFN)
                TmpS=[];
                TmpS.File=in;
                TmpS.Type='S';
                TmpS.Size=size(TmpM.(SubFN{i}));
                TmpS.Lab=sprintf('%s: [%s]%s - %s',...
                    FileExt, TmpS.Type, FN{n}, SubFN{i});
                TmpS.Alias=sprintf('%s_%s_%s_%s',...
                    File, TmpS.Type, FN{n}, SubFN{i});
                TmpS.GrpID=1;
                TmpS.Mat=TmpM.(SubFN{i});
                TmpC{i, 1}=TmpS;
            end
            S=[S; TmpC];
        elseif isnumeric(TmpM)
            TmpS=[];
            TmpS.File=in;
            TmpS.Type='V';
            TmpS.Size=size(TmpM);
            TmpS.Lab=sprintf('%s: [%s]%s',...
                FileExt, TmpS.Type, FN{n});
            TmpS.Alias=sprintf('%s_%s_%s', File, TmpS.Type, FN{n});
            TmpS.GrpID=1;
            TmpS.Mat=TmpM;
            S=[S; {TmpS}];
        else
            warning('Error: Invalid Matrix Found, Check again!');
        end
    end
end

% State Objs
function StateObj(handles, State)
set(handles.GlobalModeToLeft,   'Enable', State);
set(handles.GlobalModeToRight,  'Enable', State);
set(handles.NodalModeToLeft,    'Enable', State);
set(handles.NodalModeToRight,   'Enable', State);
set(handles.GlobalModeList,     'Enable', State);
set(handles.NodalModeList,      'Enable', State);
set(handles.PipeOptDown,        'Enable', State);
set(handles.PipeOptUp,          'Enable', State);
set(handles.PipeOptList,        'Enable', State);

set(handles.InputList,          'Enable', State);
set(handles.KeyEty,             'Enable', State);
set(handles.OutputDirEty,       'Enable', State);
set(handles.OutputDirBtn,       'Enable', State);

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

function InterCell=GenInterMat(OutputDir, Alias, GrpID)
U=unique(GrpID);
if numel(U)==1
    InterCell={fullfile(OutputDir, Alias, sprintf('%s.mat', Alias))};
else
    InterCell=cell(numel(U), 1);
    for i=1:numel(U)
        InterCell{i, 1}=fullfile(OutputDir, Alias, sprintf('Group%d', U(i)), sprintf('%s.mat', Alias));
    end
end

function IndiCell=GenIndiMat(OutputMatList, GrpID)
U=unique(GrpID);
if numel(U)==1
    IndiCell={OutputMatList};
else
    IndiCell=cell(numel(U), 1);
    for i=1:numel(U)
        IndiCell{i, 1}=OutputMatList(GrpID==U(i), 1);
    end
end

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
if isempty(InputS)
    ExitCode=1;
    warndlg('Please select the connectivity matrices first!');
    WarningObj(handles.InputList);
    return;
end

OutputDir=handles.OutputDir;
if isempty(OutputDir)
    ExitCode=1;
    warndlg('Please select the output directory!');
    WarningObj(handles.OutputDirEty);
    return;
end
    

Para=handles.Para;
OptStr=get(handles.PipeOptList, 'String');

GlobalStr=handles.GlobalModeCell(handles.SelPreInd, 1);
NodalStr=handles.NodalModeCell(handles.SelPostInd, 1);
AllStr=[GlobalStr; NodalStr];
if isempty(AllStr)
    ExitCode=1;
    warndlg('Please select the metrics to estimate!');
    WarningObj(handles.PipeOptList);
    return
end
for s=1:numel(AllStr)
    switch upper(AllStr{s})
        case 'NODAL - PARTICIPANT COEFFICIENT'
            Num=Para.CIndex{1};
            if ~isnumeric(Num)
                ExitCode=1;
                warndlg('Error: Invalid ''Community Index''');
                Val=find(~cellfun(...
                    @isempty, ...
                    strfind(OptStr, ' . Community Index:  ')...
                    )...
                    );
                CurItemKey='CIndex';
                break;
            end 
        case 'MODULAR - INTERACTION'
            Num=Para.CIndex{1};
            if ~isnumeric(Num)
                ExitCode=1;
                warndlg('Error: Invalid ''Community Index''');
                Val=find(~cellfun(...
                    @isempty, ...
                    strfind(OptStr, ' . Community Index:  ')...
                    )...
                    );
                CurItemKey='CIndex';
                break;
            end             
    end
end

if ~ExitCode
    return
end
handles.CurItemKey=CurItemKey;
guidata(hObject, handles);
set(handles.PipeOptList, 'Value', Val);
WarningObj(handles.PipeOptList);
