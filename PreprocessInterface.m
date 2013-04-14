function varargout = PreprocessInterface(varargin)
% PREPROCESSINTERFACE MATLAB code for PreprocessInterface.fig
%      PREPROCESSINTERFACE, by itself, creates a new PREPROCESSINTERFACE or raises the existing
%      singleton*.
%
%      H = PREPROCESSINTERFACE returns the handle to a new PREPROCESSINTERFACE or the handle to
%      the existing singleton*.
%
%      PREPROCESSINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCESSINTERFACE.M with the given input arguments.
%
%      PREPROCESSINTERFACE('Property','Value',...) creates a new PREPROCESSINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreprocessInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreprocessInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreprocessInterface

% Last Modified by Sandy Wang 20121127

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreprocessInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @PreprocessInterface_OutputFcn, ...
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


% --- Executes just before PreprocessInterface is made visible.
function PreprocessInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreprocessInterface (see VARARGIN)

% Choose default command line output for PreprocessInterface
handles.output = hObject;

if nargin==4
    if strcmpi(varargin{1},'Connect');
        handles.ConnectFlag=1;
    elseif strcmpi(varargin{1},'UnConnect')
        close(hObject);
        return;
    end
elseif ~isfield(handles , 'ConnectFlag')
    handles.ConnectFlag=0;
end

if ~isfield(handles , 'CalList')
    handles.CalList=[];
end

if ~isfield(handles , 'DataList')
    handles.DataList=[];
end

if ~isfield(handles , 'subj_num')
    handles.subj_num=0;
end
if ~isfield(handles , 'Para')
    GUIPath=fileparts(which('PreprocessInterface.m'));
    ParaFile=[GUIPath , filesep , 'PreprocessPara.mat'];
    if exist(ParaFile , 'file')
        Para=load([GUIPath , filesep , 'PreprocessPara.mat']);
        Para=Para.Para;
        if ~isfield(Para, 'DCMask') ||...
            ~isfield(Para, 'DCRthr') ||...
            ~isfield(Para, 'DCDis') ||...
            ~isfield(Para, 'QueueSize')
            Para=[];
        end
    else
        Para=[];
    end
    
    if isempty(Para)
    %DICOM to Nifti
        %-Output
        Para.NiiDir='';
        Para.TimePoint=240;
    %Remove first time points
        %-The number of images to be deleted
        Para.DeleteType='Delete';
        Para.ImageNum=10;
    %Slice Timing
        %-Number of Slices
        Para.SliceNum=33;
        %-TR (s)
        Para.TR=2;
        %-Slice order
        Para.SliOrd='1:2:33,2:2:32';
        %-Reference Slice
        Para.RefSlice=33;
    %Normalize
        Para.NormType='EPI';
        Para.T1Path='';
        Para.T1D2NBool='FALSE';
        Para.T1NiiDir='';
        Para.CorBool='TRUE';
        Para.SegBool='TRUE';
        Para.T1Prefix='co*';
        Para.T1Template='mni';
        Para.MatSuffix='*_seg_sn.mat';
        Para.RefPath='';
        Para.RefPrefix='mean*';
        Para.VoxelSize='[3 3 3]';
        Para.BB='[-90 , -126 , -72 ; 90 , 90 , 108]';
    %Smooth
        %-The full width half maximum of the Gaussian smoothing kernel (mm)
        Para.FWHM='[4 4 4]';
    %Detrend
        %-The degrees of polynomial curve fitting (1 for linear trend)
        Para.DetrendOrd=1;
        %-Remain (TRUE) or Remove (no) the mean of time course
        Para.RemainMean='TRUE';
        %Filter
        %-Frequency-band
        Para.FreBand='[0.01 0.08]';
    %Covarites
        %-Global Signal
        Para.GSBool='TRUE';
        Para.GSMask=[GUIPath , filesep ,...
            'mask' , filesep , 'BrainMask_05_61x73x61.img'];
        %-White Matter Signal
        Para.WMBool='TRUE';
        Para.WMMask=[GUIPath , filesep ,...
            'mask' , filesep , 'WhiteMask_09_61x73x61.img'];
        %-CSF Signal
        Para.CSFBool='TRUE';
        Para.CSFMask=[GUIPath , filesep ,...
            'mask' , filesep , 'CsfMask_07_61x73x61.img'];
        %-Head Motion
        Para.HMBool='TRUE';
        Para.HMPath='';
        Para.HMPrefix='rp_*';
    %Voxel-wise Degree
        Para.DCMask=[GUIPath , filesep ,...
            'mask' , filesep , 'BrainMask_05_61x73x61.img'];
        Para.DCRthr=0.3;
        Para.DCDis=75;
    %Queue Size
        Para.QueueSize=2;
    %FC
        Para.LabMask=[GUIPath , filesep ,...
            'Templates' , filesep , 'AAL_90_3mm.nii'];
        save(ParaFile , 'Para');
    end
    set(handles.QueueEntry, 'String', num2str(Para.QueueSize));
    handles.Para=Para;
end
handles.StopFlag=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PreprocessInterface wait for user response (see UIRESUME)
% uiwait(handles.PreprocessInterface);


% --- Outputs from this function are returned to the command line.
function varargout = PreprocessInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on selection change in ModeListbox.
function ModeListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ModeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcf , 'SelectionType') , 'normal')
    return;
elseif strcmp(get(gcf , 'SelectionType') , 'open')
    ModeList=get(handles.ModeListbox , 'String');
    if ~isempty(ModeList)
        SelectValue=get(handles.ModeListbox , 'Value');
        handles.CalList=[handles.CalList ; ModeList(SelectValue')];
        ModeList(SelectValue')=[];
        if isempty(ModeList)
            set(handles.ModeListbox , 'Value' , 0)
        else
            set(handles.ModeListbox , 'Value' , 1)
        end
        set(handles.ModeListbox , 'String' , ModeList);
        for i=size(handles.CalList , 1):-1:1
            if strcmp(handles.CalList{i} , 'DICOM to NIFTI')
                handles.CalList(i)=[];
                handles.CalList=[ {'DICOM to NIFTI'} ; handles.CalList];
                break;
            end
        end
    
        for i=size(handles.CalList , 1):-1:1
            if strcmp(handles.CalList{i} , 'Functional Connectivity Matrix')
                handles.CalList(i)=[];
                handles.CalList=[handles.CalList ; {'Functional Connectivity Matrix'}];
                break;
            end
        end           
        CalText=CalListbox(handles);
        set(handles.CalListbox , 'Value' , 1);
        set(handles.CalListbox , 'String' , CalText);
        guidata(hObject,handles);
    end
end
% Hints: contents = cellstr(get(hObject,'String')) returns ModeListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModeListbox


% --- Executes during object creation, after setting all properties.
function ModeListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in toleftbutton.
function ToRightButton_Callback(hObject, eventdata, handles)
% hObject    handle to toleftbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ModeList=get(handles.ModeListbox , 'String');
    if ~isempty(ModeList)
        SelectValue=get(handles.ModeListbox , 'Value');
        handles.CalList=[handles.CalList ; ModeList(SelectValue')];
        ModeList(SelectValue')=[];
        if isempty(ModeList)
            set(handles.ModeListbox , 'Value' , 0)
        else
            set(handles.ModeListbox , 'Value' , 1)
        end
        set(handles.ModeListbox , 'String' , ModeList);
        for i=size(handles.CalList , 1):-1:1
            if strcmp(handles.CalList{i} , 'DICOM to NIFTI')
                handles.CalList(i)=[];
                handles.CalList=[ {'DICOM to NIFTI'} ; handles.CalList];
                break;
            end
        end
    
        for i=size(handles.CalList , 1):-1:1
            if strcmp(handles.CalList{i} , 'Functional Connectivity Matrix')
                handles.CalList(i)=[];
                handles.CalList=[handles.CalList ; {'Functional Connectivity Matrix'}];
                break;
            end
        end   
        CalText=CalListbox(handles);
        set(handles.CalListbox , 'Value' , 1);
        set(handles.CalListbox , 'String' , CalText);
        guidata(hObject,handles);
    end

% --- Executes on button press in ToLeftButton.
function ToLeftButton_Callback(hObject, eventdata, handles)
% hObject    handle to ToLeftButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    CalText=get(handles.CalListbox , 'String');
    if ~isempty(CalText)
        SelectValue=get(handles.CalListbox , 'Value');
        ModeList=get(handles.ModeListbox , 'String');
        IsMode=0;
        for i=1:size(handles.CalList, 1)
            if strcmp(CalText{SelectValue} , handles.CalList{i})
                IsMode=1;
                break;
            end
        end
        if ~IsMode
            return;
        end
        
        ModeList=[ModeList ; CalText{SelectValue}];
        for i=1:size(handles.CalList , 1)
        	if strcmp([handles.CalList{i}] , CalText{SelectValue})
            	temp_order=i;
            else
            	continue;
            end
        end
        handles.CalList(temp_order)=[];
        
        CalText=CalListbox(handles);
        if isempty(handles.CalList)
            set(handles.CalListbox , 'Value' , 0)
        else
            set(handles.CalListbox , 'Value' , 1)
        end
        set(handles.CalListbox , 'String' , CalText);
        set(handles.ModeListbox , 'String' , ModeList);
        set(handles.ModeListbox , 'Value' , 1)
        guidata(hObject,handles);
    end
    
% --- Executes on selection change in CalListbox.
function CalListbox_Callback(hObject, eventdata, handles)
% hObject    handle to CalListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcf , 'SelectionType') , 'normal')
    CalText=get(handles.CalListbox , 'String');
    if ~isempty(CalText)
        SelectValue=get(handles.CalListbox , 'Value');
        IsMode=0;
        for i=1:size(handles.CalList, 1)
            if strcmp(CalText{SelectValue} , handles.CalList{i})
                IsMode=1;
                break;
            end
        end
        if ~IsMode
            if ~isempty(strfind(CalText{SelectValue} , 'Time Point:'))
                ConfigText={sprintf('%d' , handles.Para.TimePoint)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'The delete type:'))
                if strcmp(handles.Para.DeleteType , 'Delete')
                    ConfigText=[{'*Delete'};...
                        {'Retain'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText=[{'Delete'};...
                        {'*Retain'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'time points'))
                ConfigText={sprintf('%d' , handles.Para.ImageNum)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Number of Slices:'))
                ConfigText={sprintf('%d' , handles.Para.SliceNum)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'TR (s):'))
                ConfigText={sprintf('%d' , handles.Para.TR)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Slice order:'))
                SliOrdNum=str2num(handles.Para.SliOrd);
                ConfigText={sprintf('%-3d' , SliOrdNum)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Reference Slice:'))
                ConfigText={sprintf('%d' , handles.Para.RefSlice)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Normlize Method:'))
                if strcmp(handles.Para.NormType , 'EPI')
                    ConfigText=[{'*EPI'};...
                        {'T1'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText=[{'EPI'};...
                        {'*T1'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Source Image Path:'))
                if ~isempty(handles.Para.RefPath)
                    ConfigText={sprintf('%s' , handles.Para.RefPath)};
                else
                    ConfigText={'Same with Functional Dataset'};
                end
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Source Image Prefix:'))
                ConfigText={sprintf('%s' , handles.Para.RefPrefix)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'T1 Path   <-X'))
                if ~isempty(handles.Para.T1Path)
                    ConfigText={sprintf('%s' , handles.Para.T1Path)};
                else
                    ConfigText={'Please pick your T1 Directory'};
                end
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'DICOM to Nifti:'))
                if strcmp(handles.Para.T1D2NBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Coregister:'))
                if strcmp(handles.Para.CorBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Segment:'))
                if strcmp(handles.Para.SegBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'T1 Images Prefix:'))
                ConfigText={sprintf('%s' , handles.Para.T1Prefix)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Mat Suffix:'))
                ConfigText={sprintf('%s' , handles.Para.MatSuffix)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Affine Regularisation:'))
                if strcmp(handles.Para.T1Template , 'mni')
                    ConfigText={'*mni';...
                        'estern'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'mni';...
                        '*estern'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Voxel Sizes (mm):'))
                VoxelSize=str2num(handles.Para.VoxelSize);
                ConfigText={sprintf('%-2d' , VoxelSize)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Bounding box:'))
                BB=str2num(handles.Para.BB);
                ConfigText=[{sprintf('%-10d' , BB(1,:))};...
                    {sprintf('%-10d' , BB(2,:))}];
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'FWHM (mm):'))
                FWHM=str2num(handles.Para.FWHM);
                ConfigText={sprintf('%-2d' , FWHM)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'The degrees of polynomial curve fitting:'))
                ConfigText={sprintf('%d' , handles.Para.DetrendOrd)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Remain Mean'))
                if strcmp(handles.Para.RemainMean , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Band (Hz):'))
                FreBand=str2num(handles.Para.FreBand);
                ConfigText={sprintf('%-10.2f' , FreBand)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Global signal:'))
                if strcmp(handles.Para.GSBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Brain Mask:'))
                ConfigText={sprintf('%s' , handles.Para.GSMask)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'White matter signal:'))
                if strcmp(handles.Para.WMBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'White Mask:'))
                ConfigText={sprintf('%s' , handles.Para.WMMask)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'CSF signal:'))
                if strcmp(handles.Para.CSFBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'CSF Mask:'))
                ConfigText={sprintf('%s' , handles.Para.CSFMask)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Head Motion:'))
                if strcmp(handles.Para.HMBool , 'TRUE');
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Text Parent Path:')) 
                if ~isempty(handles.Para.HMPath)
                    ConfigText={sprintf('%s' , handles.Para.HMPath)};
                else
                    ConfigText={'Same with Functional Dataset'};
                end
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Text Prefix:'))
                ConfigText={sprintf('%s' , handles.Para.HMPrefix)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Label Mask:'))
                ConfigText={sprintf('%s' , handles.Para.LabMask)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Output Directory:')) 
                ConfigText={sprintf('%s' , handles.Para.MatOutput)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Degree Mask:'))
                ConfigText={sprintf('%s' , handles.Para.DCMask)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Connectional Threshold:'))
                ConfigText={sprintf('%s' , num2str(handles.Para.DCRthr))};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Connectional Distance:'))
                ConfigText={sprintf('%s' , num2str(handles.Para.DCDis))};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            end
            guidata(hObject,handles);
        else
            ConfigText=[];
            set(handles.ConfigListbox , 'String' , ConfigText);
            set(handles.ConfigListbox , 'Value'  , 0);
        end
        return;
    end
elseif strcmp(get(gcf , 'SelectionType') , 'open')
    CalText=get(handles.CalListbox , 'String');
    if ~isempty(CalText)
        SelectValue=get(handles.CalListbox , 'Value');
        ModeList=get(handles.ModeListbox , 'String');
        IsMode=0;
        for i=1:size(handles.CalList, 1)
            if strcmp(CalText{SelectValue} , handles.CalList{i})
                IsMode=1;
                break;
            end
        end
        if ~IsMode
            if ~isempty(strfind(CalText{SelectValue} , 'Time Point:'))
                TimePoint=inputdlg('Enter Time Point of time series:',...
                    'The time points',...
                    1,...
                    {num2str(handles.Para.TimePoint)});
                if ~isempty(TimePoint)
                    handles.Para.TimePoint=str2num(TimePoint{1});
                    ConfigText={sprintf('%d' , handles.Para.TimePoint)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'The delete type:'))
                if strcmp(handles.Para.DeleteType , 'Delete')
                    handles.Para.DeleteType='Retain';
                    ConfigText=[{'Delete'};...
                        {'*Retain'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.DeleteType='Delete';
                    ConfigText=[{'*Delete'};...
                        {'Retain'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'time points'))
                ImageNum=inputdlg('Enter the number of images:',...
                    'The time points',...
                    1,...
                    {num2str(handles.Para.ImageNum)});
                if ~isempty(ImageNum)
                    handles.Para.ImageNum=str2num(ImageNum{1});
                    ConfigText={sprintf('%d' , handles.Para.ImageNum)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Number of Slices:'))
                SliceNum=inputdlg('Enter Number of Slices:',...
                    'The slices in a volume',...
                    1,...
                    {num2str(handles.Para.SliceNum)});
                if ~isempty(SliceNum)
                    handles.Para.SliceNum=str2num(SliceNum{1});
                    ConfigText={handles.Para.SliceNum};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'TR (s):'))
                TR=inputdlg('Enter TR:',...
                    'TR (s)',...
                    1,...
                    {num2str(handles.Para.TR)});
                if ~isempty(TR)
                    handles.Para.TR=str2num(TR{1});
                    ConfigText={sprintf('%d' , handles.Para.TR)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Slice order:'))
                SliOrd=inputdlg('Enter Slice order:',...
                    'Slice order',...
                    1,...
                    {handles.Para.SliOrd});
                if ~isempty(SliOrd)
                    handles.Para.SliOrd=SliOrd{1};
                    SliOrdNum=str2num(handles.Para.SliOrd);
                    ConfigText={sprintf('%-3d ' , SliOrdNum)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end 
            elseif ~isempty(strfind(CalText{SelectValue} , 'Reference Slice:'))
                RefSlice=inputdlg('Enter Reference Slice:',...
                    'Reference Slice',...
                    1,...
                    {num2str(handles.Para.RefSlice)});
                if ~isempty(RefSlice)
                    handles.Para.RefSlice=str2num(RefSlice{1});
                    ConfigText={sprintf('%d' , handles.Para.RefSlice)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Normlize Method:'))
                if strcmp(handles.Para.NormType , 'EPI')
                    handles.Para.NormType='T1';
                    ConfigText=[{'EPI'};...
                        {'*T1'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.NormType='EPI';
                    ConfigText=[{'*EPI'};...
                        {'T1'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Source Image Path:'))
                RefPath=uigetdir(pwd , 'Pick a parent directory for reference images');
                if ischar(RefPath)
                    handles.Para.RefPath=RefPath;
                    ConfigText={sprintf('%s' , handles.Para.RefPath)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Source Image Prefix:'))
                RefPrefix=inputdlg('Enter Source Image Prefix:',...
                    'Source Image Prefix',...
                    1,...
                    {handles.Para.RefPrefix});
                if ~isempty(RefPrefix)
                    handles.Para.RefPrefix=RefPrefix{1};
                    ConfigText={sprintf('%s' , handles.Para.RefPrefix)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'T1 Path   <-X')) 
                T1Path=uigetdir(pwd , 'Pick a parent directory for T1 images');
                if ischar(T1Path)
                    handles.Para.T1Path=T1Path;
                    ConfigText={sprintf('%d' , handles.Para.T1Path)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'DICOM to Nifti:'))
                if strcmp(handles.Para.T1D2NBool , 'TRUE');
                    handles.Para.T1D2NBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.T1D2NBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Coregister:'))
                if strcmp(handles.Para.CorBool , 'TRUE')
                    handles.Para.CorBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.CorBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end    
            elseif ~isempty(strfind(CalText{SelectValue} , 'Segment:'))
                if strcmp(handles.Para.SegBool , 'TRUE')
                    handles.Para.SegBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.SegBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end    
            elseif ~isempty(strfind(CalText{SelectValue} , 'T1 Images Prefix:'))
                T1Prefix=inputdlg('Enter T1 Images Prefix:',...
                    'T1 Images Prefix',...
                    1,...
                    {handles.Para.T1Prefix});
                if ~isempty(T1Prefix)
                    handles.Para.T1Prefix=T1Prefix{1};
                    ConfigText={sprintf('%s' , handles.Para.T1Prefix)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Mat Suffix:'))
                MatSuffix=inputdlg('Enter the prefix of MAT:',...
                    'The prefix of MAT',...
                    1,...
                    {handles.Para.MatSuffix});
                if ~isempty(MatSuffix)
                    handles.Para.MatSuffix=MatSuffix{1};
                    ConfigText={sprintf('%s' , handles.Para.MatSuffix)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Affine Regularisation:'))
                if strcmp(handles.Para.T1Template , 'mni')
                    handles.Para.T1Template='eastern';
                    ConfigText={'mni';...
                        '*estern'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.T1Template='mni';
                    ConfigText={'*mni';...
                        'estern'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end    
            elseif ~isempty(strfind(CalText{SelectValue} , 'Voxel Sizes (mm):'))
                VoxelSize=inputdlg('Enter the Voxel Sizes (mm):',...
                    'The Voxel Sizes',...
                    1,...
                    {handles.Para.VoxelSize});
                if ~isempty(VoxelSize)
                    handles.Para.VoxelSize=VoxelSize{1};
                    VoxelSize=str2num(handles.Para.VoxelSize);
                    ConfigText={sprintf('%-2d' , VoxelSize)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Bounding box:'))
                BB=inputdlg('Enter the bounding box:',...
                    'The bounding box',...
                    1,...
                    {handles.Para.BB});
                if ~isempty(BB)
                    handles.Para.BB=BB{1};
                    BB=str2num(handles.Para.BB);
                    ConfigText=[{sprintf('%-10d' , BB(1,:))};...
                        {sprintf('%-10d' , BB(2,:))}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'FWHM (mm):'))
                FWHM=inputdlg('Enter FWHM (mm):',...
                    'FWHM (mm)',...
                    1,...
                    {handles.Para.FWHM});
                if ~isempty(FWHM)
                    handles.Para.FWHM=FWHM{1};
                    FWHM=str2num(handles.Para.FWHM);
                    ConfigText={sprintf('%-2d' , FWHM)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'The degrees of polynomial curve fitting:'))
                DetrendOrd=inputdlg('Enter the degrees of polynomial curve fitting:',...
                    'The degree of polynomial curve fitting',...
                    1,...
                    {num2str(handles.Para.DetrendOrd)});
                if ~isempty(DetrendOrd)
                    handles.Para.DetrendOrd=str2num(DetrendOrd{1});
                    ConfigText={sprintf('%d' , handles.Para.DetrendOrd)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Remain Mean'))
                if strcmp(handles.Para.RemainMean , 'TRUE')
                    handles.Para.RemainMean='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.RemainMean='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Band (Hz):'))
                FreBand=inputdlg('Enter the Band (Hz):',...
                    'The Band (Hz)',...
                    1,...
                    {handles.Para.FreBand});
                if ~isempty(FreBand)
                    handles.Para.FreBand=FreBand{1};
                    FreBand=str2num(handles.Para.FreBand);
                    ConfigText={sprintf('%-10.2f' , FreBand)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Global signal:'))
                if strcmp(handles.Para.GSBool , 'TRUE')
                    handles.Para.GSBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.GSBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Brain Mask:'))
                [Path , Name , Ext]=fileparts(handles.Para.GSMask);
                [File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
                    'Pick one mask file' , [Path , filesep , Name , Ext]);
                if ischar(File)
                    handles.Para.GSMask=[Path , File];
                    ConfigText={sprintf('%s' , handles.Para.GSMask)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'White matter signal:'))
                if strcmp(handles.Para.WMBool , 'TRUE')
                    handles.Para.WMBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.WMBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'White Mask:'))
                [Path , Name , Ext]=fileparts(handles.Para.WMMask);
                [File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
                    'Pick one mask file' , [Path , filesep , Name , Ext]);
                if ischar(File)
                    handles.Para.WMMask=[Path , File];
                    ConfigText={sprintf('%s' , handles.Para.WMMask)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'CSF signal:'))
                if strcmp(handles.Para.CSFBool , 'TRUE')
                    handles.Para.CSFBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.CSFBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'CSF Mask:'))
                [Path , Name , Ext]=fileparts(handles.Para.CSFMask);
                [File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
                    'Pick one mask file' , [Path , filesep , Name , Ext]);
                if ischar(File)
                    handles.Para.CSFMask=[Path , File];
                    ConfigText={sprintf('%s' , handles.Para.CSFMask)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Head Motion:'))
                if strcmp(handles.Para.HMBool , 'TRUE')
                    handles.Para.HMBool='FALSE';
                    ConfigText={'TRUE';...
                        '*FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.HMBool='TRUE';
                    ConfigText={'*TRUE';...
                        'FALSE'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Text Parent Path:')) 
                HMPath=uigetdir(pwd , 'Pick a parent directory for head motion text');
                if ischar(HMPath)
                    handles.Para.HMPath=HMPath;
                    ConfigText={sprintf('%s' , handles.Para.HMPath)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Text Prefix:'))
                HMPrefix=inputdlg('Enter the Text prefix:',...
                    'The prefix of head motion text',...
                    1,...
                    {handles.Para.HMPrefix});
                if ~isempty(HMPrefix)
                    handles.Para.HMPrefix=HMPrefix{1};
                    ConfigText={sprintf('%s' , handles.Para.HMPrefix)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Label Mask:'))
                [Path , Name , Ext]=fileparts(handles.Para.LabMask);
                [File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
                    'Pick one mask file' , [Path , filesep , Name , Ext]);
                if ischar(File)
                    handles.Para.LabMask=[Path , File];
                    ConfigText={sprintf('%s' , handles.Para.LabMask)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Output Directory:')) 
                MatOutput=uigetdir(pwd , 'Pick a directory for output matrixs');
                if ischar(MatOutput)
                    handles.Para.MatOutput=MatOutput;
                    ConfigText={sprintf('%s' , handles.Para.MatOutput)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Degree Mask:'))
                [Path , Name , Ext]=fileparts(handles.Para.DCMask);
                [File , Path]=uigetfile({'*.img;*.nii;*.nii.gz','Brain Image Files (*.img;*.nii;*.nii.gz)';'*.*', 'All Files (*.*)';}, ...
                    'Pick one mask file' , [Path , filesep , Name , Ext]);
                if ischar(File)
                    handles.Para.DCMask=[Path , File];
                    ConfigText={sprintf('%s' , handles.Para.DCMask)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Connectional Threshold:'))
                DCRthr=inputdlg('Enter the Threshold of r:',...
                    'Connectional Threshold',...
                    1,...
                    {num2str(handles.Para.DCRthr)});
                if ~isempty(DCRthr)
                    handles.Para.DCRthr=str2num(DCRthr{1});
                    ConfigText={sprintf('%s' , DCRthr{1})};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Connectional Distance:'))
                DCDis=inputdlg('Enter the Threshold of Distance:',...
                    'Connectional Distance',...
                    1,...
                    {num2str(handles.Para.DCDis)});
                if ~isempty(DCDis)
                    handles.Para.DCDis=str2num(DCDis{1});
                    ConfigText={sprintf('%s' , DCDis{1})};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            end
         
            CalText=CalListbox(handles);
            set(handles.DefaultPushtool , 'Enable' , 'On');
            set(handles.CalListbox , 'String' , CalText);
            guidata(hObject,handles);
            return;
        end
        
        ModeList=[ModeList ; CalText{SelectValue}];
        for i=1:size(handles.CalList , 1)
        	if strcmp([handles.CalList{i}] , CalText{SelectValue})
            	temp_order=i;
            else
            	continue;
            end
        end
        handles.CalList(temp_order)=[];
        
        CalText=CalListbox(handles);
        if isempty(handles.CalList)
            set(handles.CalListbox , 'Value' , 0)
        else
            set(handles.CalListbox , 'Value' , 1)
        end
        set(handles.CalListbox , 'String' , CalText);
        set(handles.ModeListbox , 'String' , ModeList);
        set(handles.ModeListbox , 'Value' , 1)
        guidata(hObject,handles);
    end
end
% Hints: contents = cellstr(get(hObject,'String')) returns CalListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CalListbox


% --- Executes during object creation, after setting all properties.
function CalListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CalListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Result=CalListbox(AHandle)
    Result=[];
    
    if isempty(AHandle.CalList)
        return;
    end
     
    for i=1:size(AHandle.CalList , 1)
        MODE=upper(AHandle.CalList{i});
        Mode=AHandle.CalList{i};
        switch(MODE)
            case 'DICOM TO NIFTI'
                Result=[Result ;...
                    {Mode};...
                    {sprintf('. Time Point:  %d' , AHandle.Para.TimePoint)}];
            case 'DELETE IMAGES'
                Result=[Result ; ...
                    {Mode};...
                    {sprintf('. The delete type:  %s', AHandle.Para.DeleteType)}];
                if strcmp(AHandle.Para.DeleteType , 'Delete')    
                    Result=[Result ; ...
                        {sprintf('. . %s first %d time points' , AHandle.Para.DeleteType,...
                        AHandle.Para.ImageNum)}];
                else
                    Result=[Result ; ...
                        {sprintf('. . %s end %d time points' , AHandle.Para.DeleteType,...
                        AHandle.Para.ImageNum)}];
                end
            case 'SLICE TIMING'
                Result=[Result ; ...
                    {Mode};...
                    {sprintf('. Number of Slices:  %d', AHandle.Para.SliceNum)};...
                    {sprintf('. TR (s):  %d' , AHandle.Para.TR)};...
                    {sprintf('. Slice order:  %s' , AHandle.Para.SliOrd)};...
                    {sprintf('. Reference Slice:  %d' , AHandle.Para.RefSlice)}];
            case 'REALIGN'
                Result=[Result ; ...
                    {Mode}];
            case 'NORMALIZE'
                Result=[Result ; ...
                    {Mode} ; ...
                    {sprintf('. Normlize Method:  %s' , AHandle.Para.NormType)}];
                if strcmp(AHandle.Para.NormType , 'T1')
                    Result=[Result ; ...
                        {sprintf('. . T1 Path   <-X  %s' , AHandle.Para.T1Path)} ; ...
                        {sprintf('. . DICOM to Nifti:  %s' , AHandle.Para.T1D2NBool)}];
                    Result=[Result ; ...
                        {sprintf('. . Coregister:  %s' , AHandle.Para.CorBool)} ; ...
                        {sprintf('. . Segment:  %s' , AHandle.Para.SegBool)}];
                    if strcmp(AHandle.Para.CorBool , 'TRUE') || strcmp(AHandle.Para.SegBool , 'TRUE')
                        if strcmp(AHandle.Para.CorBool , 'TRUE')
                            if isempty(AHandle.Para.RefPath)
                                Result=[Result ; ...
                                    {'    - Source Image Path:  Same with Functional Dataset'}];
                            else
                                Result=[Result ; ...
                                    {sprintf('    - Source Image Path:  %s' , AHandle.Para.RefPath)}];
                            end
                            Result=[Result ; ...
                                {sprintf('    - Source Image Prefix:  %s' , AHandle.Para.RefPrefix)}];
                        end
                        Result=[Result ; ...
                            {sprintf('    - T1 Images Prefix:  %s' , AHandle.Para.T1Prefix)}];
                        if strcmp(AHandle.Para.SegBool , 'TRUE')
                            Result=[Result ; ...
                                {sprintf('    - Affine Regularisation:  %s' , AHandle.Para.T1Template)}];
                        end
                    end
                    Result=[Result ; ...
                        {sprintf('. . Mat Suffix:  %s' , AHandle.Para.MatSuffix)}];
                else
                    if isempty(AHandle.Para.RefPath)
                        Result=[Result ; ...
                            {'. Source Image Path:  Same with Functional Dataset'}];
                    else
                        Result=[Result ; ...
                            {sprintf('. Source Image Path:  %s' , AHandle.Para.RefPath)}];
                    end
                    Result=[Result ; ...
                        {sprintf('. Source Image Prefix:  %s' , AHandle.Para.RefPrefix)}];
                end
                Result=[Result ; ...
                    {sprintf('. Voxel Sizes (mm):  %s' , AHandle.Para.VoxelSize)} ; ...
                    {sprintf('. Bounding box:  %s' , AHandle.Para.BB)}];
            case 'SMOOTH'
                Result=[Result ; ...
                    {Mode} ; ...
                    {sprintf('. FWHM (mm):  %s' , AHandle.Para.FWHM)}];
            case 'DETREND'
                Result=[Result ; ...
                    {Mode}; ...
                    {sprintf('. The degrees of polynomial curve fitting:  %d' , AHandle.Para.DetrendOrd)};...
                    {sprintf('. Remain Mean:  %s' , AHandle.Para.RemainMean)}];
            case 'FILTER'
                Result=[Result ; ...
                    {Mode}; ...
                    {sprintf('. TR (s):  %d' , AHandle.Para.TR)};...
                    {sprintf('. Band (Hz):  %s' , AHandle.Para.FreBand)}];
            case 'COVARIATES REGRESSION'
                [Path , Name , Ext]=fileparts(AHandle.Para.GSMask);
                Result=[Result ; ...
                    {Mode} ; ...
                    {sprintf('. Brain Mask:  %s' , [Name , Ext])} ; ...
                    {sprintf('. Global signal:  %s' , AHandle.Para.GSBool)}];
                if strcmp(AHandle.Para.GSBool , 'TRUE')
                    [Path , Name , Ext]=fileparts(AHandle.Para.GSMask);
                    Result=[Result ;...
                        {sprintf('. . Brain Mask:  %s' , [Name , Ext])}];
                end
                Result=[Result ; ...
                    {sprintf('. White matter signal:  %s' , AHandle.Para.WMBool)}];
                if strcmp(AHandle.Para.WMBool , 'TRUE')
                    [Path , Name , Ext]=fileparts(AHandle.Para.WMMask);
                    Result=[Result ;...
                        {sprintf('. . White Mask:  %s' , [Name , Ext])}];
                end
                Result=[Result ; ...
                    {sprintf('. CSF signal:  %s' , AHandle.Para.CSFBool)}];
                if strcmp(AHandle.Para.CSFBool , 'TRUE')
                    [Path , Name , Ext]=fileparts(AHandle.Para.CSFMask);
                    Result=[Result ;...
                        {sprintf('. . CSF Mask:  %s' , [Name , Ext])}];
                end
                Result=[Result ; ...
                    {sprintf('. Head Motion:  %s' , AHandle.Para.HMBool)}];
                if strcmp(AHandle.Para.HMBool , 'TRUE')
                    if isempty(AHandle.Para.HMPath)
                    	Result=[Result ;...
                            {'. . Text Parent Path:  Same with Functional Dataset'};...
                            {sprintf('. . Text Prefix:  %s' , AHandle.Para.HMPrefix)}];
                    else
                        Result=[Result ;...
                            {sprintf('. . Text Parent Path:  %s' , AHandle.Para.HMPath)};...
                            {sprintf('. . Text Prefix:  %s' , AHandle.Para.HMPrefix)}];
                    end
                end
            case 'FUNCTIONAL CONNECTIVITY MATRIX'
                Result=[Result ;...
                    {Mode}];
                [Path , Name , Ext]=fileparts(AHandle.Para.LabMask);
                Result=[Result ;...
                    {sprintf('. Label Mask:  %s' , [Name , Ext])} ];
            case 'VOXEL-BASED DEGREE'
                Result=[Result ;...
                    {Mode}];
                [Path, Name, Ext]=fileparts(AHandle.Para.DCMask);
                Result=[Result ;...
                    {sprintf('. Degree Mask:  %s' , [Name , Ext])} ];
                Result=[Result ; ...
                    {sprintf('. Connectional Threshold:  %s' , num2str(AHandle.Para.DCRthr))}];
                Result=[Result ; ...
                    {sprintf('. Connectional Distance:  %d' , AHandle.Para.DCDis)}];
        end
    end
    
    if isfield(AHandle , 'NetCalText')
        Result=[Result ; AHandle.NetCalText];
    end


function PrefixEntry_Callback(hObject, eventdata, handles)
% hObject    handle to PrefixEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles=UpdateInputListbox(handles);
    InputText=get(handles.InputListbox , 'String');
    if isempty(handles.DataList) && ~isempty(InputText)
        Choose=questdlg(['There are no *.nii or *img file in the directory! ',...
            'If you want to select Dicom file, please click "Dicom to Nifti", ',...
            'else click Quit'],...
            'Dicom to Nifti?',...
            'Dicom to Nifti' ,...
            'Quit' ,...
            'Dicom to Nifti');
        if strcmpi(Choose , 'Dicom to Nifti')
            ModeList=get(handles.ModeListbox , 'String');
            SelectValue=0;
            for i=1:size(ModeList , 1)
                if strcmpi(ModeList{i} , 'DICOM to NIFTI')
                    SelectValue=i;
                    break;
                end
            end
            ModeList(SelectValue)=[];
            set(handles.ModeListbox , 'String' , ModeList);
            if isempty(ModeList)
                set(handles.ModeListbox , 'Value' , 0);
            else
                set(handles.ModeListbox , 'Value' , 1);
            end
            handles.CalList=[{'DICOM to NIFTI'};handles.CalList];
            CalText=CalListbox(handles);
            set(handles.CalListbox , 'Value' , 1 ,'String' , CalText);
            handles=UpdateInputListbox(handles);
        end
    end
    guidata(hObject , handles);
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

    

function InputEntry_Callback(hObject, eventdata, handles)
% hObject    handle to InputEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles=UpdateInputListbox(handles);
    InputText=get(handles.InputListbox , 'String');
    if isempty(handles.DataList) && ~isempty(InputText)
        Choose=questdlg(['There are no *.nii or *img file in the directory! ',...
            'If you want to select Dicom file, please click "Dicom to Nifti", ',...
            'else click Quit'],...
            'Dicom to Nifti?',...
            'Dicom to Nifti' ,...
            'Quit' ,...
            'Dicom to Nifti');
        if strcmpi(Choose , 'Dicom to Nifti')
            ModeList=get(handles.ModeListbox , 'String');
            SelectValue=0;
            for i=1:size(ModeList , 1)
                if strcmpi(ModeList{i} , 'DICOM to NIFTI')
                    SelectValue=i;
                    break;
                end
            end
            ModeList(SelectValue)=[];
            set(handles.ModeListbox , 'String' , ModeList);
            if isempty(ModeList)
                set(handles.ModeListbox , 'Value' , 0);
            else
                set(handles.ModeListbox , 'Value' , 1);
            end
            handles.CalList=[{'DICOM to NIFTI'};handles.CalList];
            CalText=CalListbox(handles);
            set(handles.CalListbox , 'Value' , 1 ,'String' , CalText);
            handles=UpdateInputListbox(handles);
        end
    end
    guidata(hObject , handles);
% Hints: get(hObject,'String') returns contents of InputEntry as text
%        str2double(get(hObject,'String')) returns contents of InputEntry as a double


% --- Executes during object creation, after setting all properties.
function InputEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in InputButton.
function InputButton_Callback(hObject, eventdata, handles)
% hObject    handle to InputButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ParentDir=uigetdir(pwd , 'Pick parent directory of dataset');
    if ischar(ParentDir)
        set(handles.InputEntry , 'String' , ParentDir);
        handles=UpdateInputListbox(handles);
        InputText=get(handles.InputListbox , 'String');
        if isempty(handles.DataList) && ~isempty(InputText)
            Choose=questdlg(['There are no *.nii or *img file in the directory! ',...
                'If you want to select Dicom file, please click "Dicom to Nifti", ',...
                'else click Quit'],...
                'Dicom to Nifti?',...
                'Dicom to Nifti' ,...
                'Quit' ,...
                'Dicom to Nifti');
            if strcmpi(Choose , 'Dicom to Nifti')
                ModeList=get(handles.ModeListbox , 'String');
                SelectValue=0;
                for i=1:size(ModeList , 1)
                    if strcmpi(ModeList{i} , 'DICOM to NIFTI')
                        SelectValue=i;
                        break;
                    end
                end
                ModeList(SelectValue)=[];
                set(handles.ModeListbox , 'String' , ModeList);
                if isempty(ModeList)
                    set(handles.ModeListbox , 'Value' , 0);
                else
                    set(handles.ModeListbox , 'Value' , 1);
                end
                handles.CalList=[{'DICOM to NIFTI'};handles.CalList];
                CalText=CalListbox(handles);
                set(handles.CalListbox , 'Value' , 1 ,'String' , CalText);
                handles=UpdateInputListbox(handles);
            end
        end
        guidata(hObject , handles);
    end
    
function handles=UpdateInputListbox(handles)
        set(handles.InputListbox , 'BackgroundColor' , 'Green');
        handles.DataList=[];
        ParentDir=get(handles.InputEntry , 'String');
        Prefix=get(handles.PrefixEntry , 'String');
        InputListbox=[];
        Subj=dir(ParentDir);
        if isempty(Prefix)
            Prefix=inputdlg({'Enter key of files searched'},...
                'Key Words', 1 , {'*'});
            Prefix=Prefix{1};
            set(handles.PrefixEntry , 'String' , Prefix);
        end
        
        if ~isempty(handles.CalList)
            if strcmp(handles.CalList{1} , 'DICOM to NIFTI')
                for i=1:size(Subj , 1)
                    if Subj(i).isdir && ...
                            ~strcmp(Subj(i).name , '.') &&...
                            ~strcmp(Subj(i).name , '..') &&...
                            ~strcmp(Subj(i).name , '.DS_Store')
                        SubjImage=dir([ParentDir , filesep , Subj(i).name,...
                            filesep , Prefix]);
                        ImageList=[];
                        if strcmp(SubjImage(1).name , '.')
                           SubjImage(1)=[];
                        	if strcmp(SubjImage(1).name , '..')
                                SubjImage(1)=[];
                                if strcmp(SubjImage(1).name , '.DS_Store')
                                   SubjImage(1)=[];
                                end
                            end
                        end
                        FileNum=size(SubjImage , 1);
                        [Path , Name , Ext]=fileparts([ParentDir , filesep , Subj(i).name,...
                            filesep , SubjImage(1).name]);
                        if ~strcmp(Ext , '.nii') && ~strcmp(Ext , '.img') ...
                                && ~strcmp(Ext , '.hdr') && ~strcmp(Ext , '.gz')
                            ImageList=[Path , filesep , Name , Ext];
                        end
    
                        if isempty(ImageList)
                            InputListbox=[InputListbox;...
                                    {sprintf('DICOM File: [Empty!] Subject Directory: %s%s' ,...
                                    Subj(i).name , filesep)}];
                        else
                            handles.DataList=...
                                setfield(handles.DataList ,...
                                ['DCM3D', Subj(i).name] , ImageList);
                            InputListbox=[InputListbox;...
                                {sprintf('DICOM File: [ %.5d ] DICOM Directory: %s%s' ,...
                                FileNum,...
                                Subj(i).name)}];
                        end
                        set(handles.InputListbox , 'String' , InputListbox);
                        set(handles.InputListbox , 'Value'  , size(InputListbox , 1));
                        drawnow;
                    end
                end
                set(handles.InputListbox , 'String' , InputListbox ,...
                    'BackgroundColor' , 'White');
                if isempty(InputListbox)
                    set(handles.InputListbox , 'Value' , 0);
                else
                    set(handles.InputListbox , 'Value' , 1);
                end
                return;
            end
        end
        
        for i=1:size(Subj , 1)
            if ~strcmp(Subj(i).name , '.') && ~strcmp(Subj(i).name , '..')...
                    && ~strcmp(Subj(i).name , '.DS_Store')
                if Subj(i).isdir
                    SubjImage=dir([ParentDir , filesep , Subj(i).name,...
                        filesep , Prefix , '.img']);
                    if isempty(SubjImage)
                        SubjImage=dir([ParentDir , filesep , Subj(i).name,...
                            filesep , Prefix , '.nii']);
                    end
                    
                    if isempty(SubjImage)
                        ImageList=[];
                    elseif size(SubjImage , 1)==1
                    	[Path , Name ,Ext]=...
                        	fileparts([ParentDir , filesep ,...
                            Subj(i).name , filesep , SubjImage(1).name]);
                        if strcmp(Ext , '.img')
                            fid=fopen([Path , filesep , Name , '.hdr']);
                        else
                            fid=fopen([Path , filesep , Name , Ext]);
                        end
                        fseek(fid , 48 , 'bof');
                        TimePoint=fread(fid , 1 , 'int16');
                        fclose(fid);
                        ImageList=[Path , filesep , Name , Ext];
                    else
                        ImageList=cell(size(SubjImage , 1) , 1);
                        for j=1:size(SubjImage , 1)
                            [Path , Name ,Ext]=...
                                fileparts([ParentDir , filesep ,...
                                Subj(i).name , filesep , SubjImage(j).name]);
                            ImageList{j}=[Path , filesep , Name , Ext];
                        end
                        TimePoint=size(ImageList , 1);
                    end
                        
                    if isempty(ImageList)    
                        InputListbox=[InputListbox;...
                            {sprintf('Time Points: [Empty!] Subject Directory: %s%s' ,...
                            Subj(i).name , filesep)}];
                    else
                        if iscell(ImageList)
                            TimePoint=size(ImageList,1);
                            InputListbox=[InputListbox;...
                                {sprintf('Time Points: [ %.4d ] Subject Directory: %s%s' ,...
                                TimePoint,...
                                Subj(i).name , filesep)}];
                            handles.DataList.(['DIR3D', Subj(i).name])=ImageList;
                        else
                          	InputListbox=[InputListbox;...
                                {sprintf('Time Points: [ %.4d ] Subject Directory: %s%s' ,...
                                TimePoint,...
                                [Subj(i).name , filesep , Name , Ext])}];
                            handles.DataList.(['DIR4D' , Subj(i).name])=ImageList;
                        end
                    end
                else
                    break;
                end
               
                set(handles.InputListbox , 'String' , InputListbox);
                set(handles.InputListbox , 'Value' , size(InputListbox , 1));
                drawnow;
            else
                continue;
            end
        end
        %find 4DNii
        Subj=dir([ParentDir , filesep , Prefix]);
        for i=1:size(Subj , 1)
            if ~strcmp(Subj(i).name , '.') && ~strcmp(Subj(i).name , '..')...
                    && ~strcmp(Subj(i).name , '.DS_Store')
                if Subj(i).isdir
                    continue;
                else
                    [Path , Name , Ext]=...
                    fileparts([ParentDir , filesep , Subj(i).name]);
                    if strcmp(Ext , '.nii') || strcmp(Ext , '.img')
                        NiiName=[Path , filesep , Name , Ext];
                        
                        if strcmp(Ext , '.img')
                            fid=fopen([Path , filesep , Name , '.hdr']);
                        else
                            fid=fopen([Path , filesep , Name , Ext]);
                        end
                        fseek(fid , 48 , 'bof');
                        TimePoint=fread(fid , 1 , 'int16');
                        fclose(fid);
                        
                        if TimePoint~=1
                            InputListbox=[InputListbox;...
                                {sprintf('Time Points: [ %.4d ] Subject 4DNiiFile: %s%s' , ...
                                TimePoint,...
                                Name, Ext)}];
                            handles.DataList.(['Nii4D',Name])=NiiName;
                        else 
                            continue;
                        end 
                    end
                end
                
                set(handles.InputListbox , 'String' , InputListbox);
                set(handles.InputListbox , 'Value'  , size(InputListbox , 1));
                drawnow;
            else
                continue;
            end
        end
        
        set(handles.InputListbox , 'String' , InputListbox ,...
            'BackgroundColor' , 'White');
        if isempty(InputListbox)
        	set(handles.InputListbox , 'Value' , 0);
        else
        	set(handles.InputListbox , 'Value' , 1);
        end

% --- Executes on selection change in InputListbox.
function InputListbox_Callback(hObject, eventdata, handles)
% hObject    handle to InputListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcf , 'SelectionType') , 'normal')
    return;
elseif strcmp(get(gcf , 'SelectionType') , 'open')
    InputListbox=get(handles.InputListbox , 'String');
    SelectedValue=get(handles.InputListbox , 'Value');
    if isempty(SelectedValue)
        return;
    end
    FieldName=fieldnames(handles.DataList);
    handles.DataList=rmfield(handles.DataList , FieldName{SelectedValue});
    InputListbox(SelectedValue)=[];
    set(handles.InputListbox , 'String' , InputListbox);
    if size(InputListbox , 1) < SelectedValue
        set(handles.InputListbox , 'Value' , SelectedValue-1);
    else
        set(handles.InputListbox , 'Value' , SelectedValue);
    end
    guidata(hObject , handles);
end
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

function pipeline=PreprocessFork(DataFile , CalList , Para , FieldName , pipeline)
GUIPath=fileparts(which('PreprocessInterface.m'));
SPMPath=fileparts(which('spm.m'));

SliOrd=str2num(Para.SliOrd);
VoxelSize=str2num(Para.VoxelSize);
BB=str2num(Para.BB);
FWHM=str2num(Para.FWHM);
FreBand=str2num(Para.FreBand);
T1Image=[];
MatName=[];
DelMsg='';
TimePoint=[];
if ~strcmpi(CalList{1} , 'DICOM TO NIFTI')
    if ischar(DataFile)
        [Path , Name , Ext]=fileparts(DataFile);
       	if strcmp(Ext , '.img')
        	fid=fopen([Path , filesep , Name , '.hdr']);
        else
        	fid=fopen([Path , filesep , Name , Ext]);
        end
        fseek(fid , 48 , 'bof');
        TimePoint=fread(fid , 1 , 'int16');
        fclose(fid);
    end
end
    for j=1:size(CalList , 1)
        Mode=upper(CalList{j});
        switch(Mode)
            case 'DICOM TO NIFTI'
                Output=[Para.NiiDir , filesep , FieldName(6:end)];
                if ~(exist(Output , 'dir')==7)
                    mkdir(Output);
                end
                command='gretna_EPI_dcm2nii(opt.DataFile , opt.Output , opt.SubjName , opt.TimePoint)';
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).command=command;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.DataFile=DataFile;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.Output=Output;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.SubjName=FieldName(6:end);
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.TimePoint=Para.TimePoint;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).files_in={DataFile};
                DataFile=[];
                for i=1:Para.TimePoint
                    DataFile=[DataFile ;...
                        {sprintf('%s%s%s_%.4d.nii' , Output , filesep , FieldName(6:end) , i)}];
                end
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).files_out=DataFile;
                Para.EPIPath=Para.NiiDir;
            case 'DELETE IMAGES'
                if strcmp(Para.DeleteType , 'Delete')
                    ImageNum=Para.ImageNum;
                else
                    if iscell(DataFile)
                        ImageNum=size(DataFile , 1 )-ImageNum;
                    else
                        ImageNum=TimePoint-ImageNum;
                    end
                end
                TimePoint=TimePoint-ImageNum;
                if iscell(DataFile)
                    DataFile(1:ImageNum)=[];
                    DelMsg='_DeleteImage';
                else
                    command='gretna_DeleteImage(opt.DataFile , opt.DeleteNum , opt.Prefix)';
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).command=command;
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).opt.DataFile=DataFile;
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).opt.DeleteNum=ImageNum;
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).opt.Prefix='n';
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).files_in={DataFile};
                    [Path , File , Ext]=fileparts(DataFile);
                    DataFile=[Path , filesep , 'n' , File , Ext];
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).files_out={DataFile};
                end
            case 'SLICE TIMING'
                SPMJOB=load([GUIPath , filesep ,...
                    'Jobsman' , filesep , 'gretna_Slicetiming.mat']);
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('a' , DataFile , TimePoint);
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.scans{1}=FileList;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.nslices=Para.SliceNum;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.so=SliOrd;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.refslice=Para.RefSlice;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.tr=Para.TR;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.ta=...
                                                Para.TR-(Para.TR/Para.SliceNum);
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.prefix='a';           
                command='spm_jobman(''run'',opt.SliceTimingBatch)';
                pipeline.([FieldName , DelMsg , '_SliceTiming']).command=command;
                pipeline.([FieldName , DelMsg , '_SliceTiming']).opt.SliceTimingBatch=SPMJOB.matlabbatch;
                pipeline.([FieldName , DelMsg , '_SliceTiming']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_SliceTiming']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'REALIGN'
                SPMJOB=load([GUIPath , filesep ,...
                    'Jobsman' , filesep , 'gretna_Realignment.mat']);
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('r' , DataFile , TimePoint);
                SPMJOB.matlabbatch{1,1}.spm.spatial.realign.estwrite.data{1}=FileList;
                SPMJOB.matlabbatch{1,1}.spm.spatial.realign.estwrite.roptions.prefix='r';
                HMLogDir=[Para.LogDir , filesep , 'HeadMotion'];
                
                command='gretna_Realign(opt.RealignBatch , opt.HMLogDir , opt.SubjName , opt.EPIPath)';
                pipeline.([FieldName , DelMsg , '_Realign']).command=command;
                pipeline.([FieldName , DelMsg , '_Realign']).opt.RealignBatch=SPMJOB.matlabbatch;
                pipeline.([FieldName , DelMsg , '_Realign']).opt.HMLogDir=HMLogDir;
                pipeline.([FieldName , DelMsg , '_Realign']).opt.SubjName=FieldName(6:end);
                pipeline.([FieldName , DelMsg , '_Realign']).opt.EPIPath=Para.EPIPath;
                pipeline.([FieldName , DelMsg , '_Realign']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Realign']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'NORMALIZE'
                if isempty(Para.RefPath) || ~(exist(Para.RefPath , 'dir')==7)
                    Para.RefPath=Para.EPIPath;
                end
                [FileList , files_in , files_out , DataFile]=...
                	UpdateDataList('w' , DataFile , TimePoint);
                if strcmp(Para.NormType , 'EPI')
                    SPMJOB=load([GUIPath , filesep ,...
                        'Jobsman' , filesep , 'gretna_Normalization_EPI.mat']);
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.eoptions.template=...
                        {[SPMPath , filesep , 'templates' , filesep , 'EPI.nii,1']};
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.subj.resample=FileList;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.roptions.bb=BB;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.roptions.vox=VoxelSize;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.roptions.prefix='w';
                    command='gretna_NormalizeEPI(opt.NormalizeEPIBatch , opt.RefPath , opt.RefPrefix , opt.SubjName)';
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).command=command;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.NormalizeEPIBatch=SPMJOB.matlabbatch;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.RefPath=Para.RefPath;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.RefPrefix=Para.RefPrefix;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.SubjName=FieldName(6:end);
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).files_in=files_in;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).files_out=files_out;
                    if ~isempty(DelMsg)
                        DelMsg=[];
                    end
                else
                    %DICOM TO NII
                    if strcmp(Para.T1D2NBool , 'TRUE')
                        Output=[Para.T1NiiDir , filesep , FieldName(6:end)];
                        if ~(exist(Output,'dir')==7)
                            mkdir(Output);
                        end
                        T1DcmFile=GetNeedDcmFile(Para.T1Path , FieldName(6:end));
                        command='gretna_T1_dcm2nii(opt.T1DcmFile , opt.Output , opt.SubjName)';
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).command=command;
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).opt.T1DcmFile=T1DcmFile;
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).opt.Output=Output;
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).opt.SubjName=FieldName(6:end);
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).files_in={T1DcmFile};
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).files_out={[Output , ...
                            filesep , 'coNifti_' , FieldName(6:end) , '.nii']};
                        if ~isempty(DelMsg)
                            DelMsg=[];
                        end
                        Para.T1Path=Para.T1NiiDir;
                        T1Image={[Output , filesep , 'coNifti_' , FieldName(6:end) , '.nii']};
                    end
                    
                    %Coregister
                    if strcmp(Para.CorBool , 'TRUE')
                        if isempty(T1Image)
                            T1Image  = gretna_GetNeedFile(Para.T1Path  , Para.T1Prefix  , FieldName(6:end));
                        end
                        SPMJOB=load([GUIPath , filesep ,...
                            'Jobsman' , filesep , 'gretna_Coregister.mat']);
                        SPMJOB.matlabbatch{1,1}.spm.spatial.coreg.estimate.source = T1Image;
                        command='gretna_Coregister(opt.CoregisterBatch , opt.RefPath , opt.RefPrefix , opt.SubjName , opt.T1Image)';
                        pipeline.([FieldName , DelMsg , '_Coregister']).command=command;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.CoregisterBatch=SPMJOB.matlabbatch;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.RefPath=Para.RefPath;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.RefPrefix=Para.RefPrefix;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.SubjName=FieldName(6:end);
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.T1Image=T1Image;
                        pipeline.([FieldName , DelMsg , '_Coregister']).files_in=[files_in ; T1Image];
                        if ~isempty(DelMsg)
                            DelMsg=[];
                        end
                        [Path , File , Ext]=fileparts(T1Image{1});
                        pipeline.([FieldName , DelMsg , '_Coregister']).files_out=[Path , filesep , 'co' , File , Ext];
                        T1Image={[Path , filesep , 'co' , File , Ext]};
                    end
                    %Segment
                    if strcmp(Para.SegBool , 'TRUE')
                        if isempty(T1Image)
                            T1Image  = gretna_GetNeedFile(Para.T1Path  , Para.T1Prefix  , FieldName(6:end));
                        end
                        SPMJOB=load([GUIPath , filesep ,...
                            'Jobsman' , filesep , 'gretna_Segmentation.mat']);
                        SPMJOB.matlabbatch{1,1}.spm.spatial.preproc.opts.tpm=...
                            {[SPMPath , filesep , 'tpm' , filesep , 'grey.nii'];...
                            [SPMPath , filesep , 'tpm' , filesep , 'white.nii'];...
                            [SPMPath , filesep , 'tpm' , filesep , 'csf.nii']};
                        SPMJOB.matlabbatch{1,1}.spm.spatial.preproc.data=T1Image;
                        SPMJOB.matlabbatch{1,1}.spm.spatial.preproc.opts.regtype=Para.T1Template;
                        command='spm_jobman(''run'' , opt.SegmentBatch)';
                        pipeline.([FieldName , DelMsg , '_Segment']).command=command;
                        pipeline.([FieldName , DelMsg , '_Segment']).opt.SegmentBatch=SPMJOB.matlabbatch;
                        pipeline.([FieldName , DelMsg , '_Segment']).files_in=[files_in ; T1Image];
                        if ~isempty(DelMsg)
                            DelMsg=[];
                        end
                        [Path , File , Ext]=fileparts(T1Image{1});
                        pipeline.([FieldName , DelMsg , '_Segment']).files_out=[Path , filesep , File , '_seg_sn.mat'];
                        MatName={[Path , filesep , File , '_seg_sn.mat']};
                    end
                    %Normalize
                    SPMJOB=load([GUIPath , filesep ,...
                        'Jobsman' , filesep , 'gretna_Normalization_write.mat']);
                    if isempty(MatName)    
                        MatName=GetNeedFile(Para.T1Path , Para.MatSuffix , FieldName(6:end));
                    end    
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.subj.matname=MatName;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.subj.resample=FileList;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.roptions.bb=BB;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.roptions.vox=VoxelSize;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.roptions.prefix='w';
                    command='spm_jobman(''run'',opt.NormalizeT1Batch)';
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).command=command;
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).opt.NormalizeT1Batch=SPMJOB.matlabbatch;
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).files_in=[files_in ; MatName];
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).files_out=files_out;
                    if ~isempty(DelMsg)
                        DelMsg=[];
                    end
                end
                %command='gretna_PicForCheck(opt.FileList , opt.PicDir , opt.SubjName)';
                %pipeline([FieldName , '_CheckNormalize']).command=command;
                %pipeline([FieldName , '_CheckNormalize']).opt.FileList=files_out;
                %pipeline([FieldName , '_CheckNormalize']).opt.PicDir=Para.PicDir;
                %pipeline([FieldName , '_CheckNormalize']).opt.SubjName=FieldName(6:end);
                %pipeline([FieldName , '_CheckNormalize']).files_in=files_out;
                %pipeline([FieldName , '_CheckNormalize']).files_out=[Para.PicDir , filesep , FieldName(6:end) , '.tif'];
            case 'SMOOTH'
                SPMJOB=load([GUIPath , filesep ,...
                    'Jobsman' , filesep , 'gretna_Smooth.mat']);
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('s' , DataFile , TimePoint);
                SPMJOB.matlabbatch{1,1}.spm.spatial.smooth.fwhm=FWHM;
                SPMJOB.matlabbatch{1,1}.spm.spatial.smooth.data=FileList;
                SPMJOB.matlabbatch{1,1}.spm.spatial.smooth.prefix='s';
                command='spm_jobman(''run'',opt.SmoothBatch)';
                pipeline.([FieldName , DelMsg , '_Smooth']).command=command;
                pipeline.([FieldName , DelMsg , '_Smooth']).opt.SmoothBatch=SPMJOB.matlabbatch;
                pipeline.([FieldName , DelMsg , '_Smooth']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Smooth']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'DETREND'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('d' , DataFile , TimePoint);
                command='gretna_detrend(opt.FileList , opt.Prefix , opt.DetrendOrd , opt.RemainMean)';
                pipeline.([FieldName , DelMsg , '_Detrend']).command=command;
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.Prefix='d';
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.DetrendOrd=Para.DetrendOrd;
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.RemainMean=Para.RemainMean;
                pipeline.([FieldName , DelMsg , '_Detrend']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Detrend']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'FILTER'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('b' , DataFile , TimePoint);
                command='gretna_bandpass(opt.FileList , opt.Prefix , opt.Band , opt.TR)';
                pipeline.([FieldName , DelMsg , '_BandPass']).command=command;
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.Prefix='b';
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.Band=FreBand;
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.TR=Para.TR;
                pipeline.([FieldName , DelMsg , '_BandPass']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_BandPass']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'COVARIATES REGRESSION'    
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('c' , DataFile , TimePoint);
                %Cov
                CovCell=[];
                if strcmpi(Para.GSBool , 'TRUE')
                    CovCell=[CovCell ; {Para.GSMask}];
                end
                if strcmpi(Para.WMBool , 'TRUE')
                    CovCell=[CovCell ; {Para.WMMask}];
                end
                if strcmpi(Para.CSFBool, 'TRUE')
                    CovCell=[CovCell ; {Para.CSFMask}];
                end

                if strcmpi(Para.HMBool , 'TRUE')
                    if isempty(Para.HMPath) || ~(exist(Para.HMPath , 'dir')==7)
                        Para.HMPath=Para.EPIPath;
                    end
                end
                Config.BrainMask = Para.GSMask;
                Config.HMBool    = Para.HMBool;
                Config.HMPath    = Para.HMPath;
                Config.HMPrefix  = Para.HMPrefix;
                Config.Name      = FieldName(6:end);
                Config.CovCell   = CovCell;
                command='gretna_regressout(opt.FileList , opt.Prefix , opt.CovConfig)';
                pipeline.([FieldName , DelMsg , '_Regressout']).command=command;
                pipeline.([FieldName , DelMsg , '_Regressout']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_Regressout']).opt.Prefix='c';
                pipeline.([FieldName , DelMsg , '_Regressout']).opt.CovConfig=Config;
                pipeline.([FieldName , DelMsg , '_Regressout']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Regressout']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
                
            case 'VOXEL-BASED DEGREE'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('' , DataFile , TimePoint);
                %Voxel-based Degree
                DCDir=[Para.ParentDir , 'GretnaVoxelDegree'];
                if ~(exist(DCDir , 'dir')==7)
                    mkdir(DCDir);
                end
                DCOutput=[DCDir , filesep , FieldName(6:end)];
                command='gretna_voxel_based_degree_pipeuse(opt.FileList, opt.DCOutput, opt.DCMask, opt.DCRthr, opt.DCDis, opt.SubjName)';
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).command=command;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCOutput=DCOutput;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCMask=Para.DCMask;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCRthr=Para.DCRthr;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCDis=Para.DCDis;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.SubjName=FieldName(6:end);
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).files_out=...
                    {[DCOutput, filesep, 'degree_abs_wei_', FieldName(6:end), '.nii']};
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
                
            case 'FUNCTIONAL CONNECTIVITY MATRIX'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('' , DataFile , TimePoint);
                %FC
                MatOutput=[Para.ParentDir , 'GretnaMatrixResult'];
                if ~(exist(MatOutput , 'dir')==7)
                    mkdir(MatOutput);
                end
                OutputName=[MatOutput , filesep ,  FieldName(6:end) , '.txt'];
                command='gretna_fc(opt.FileList , opt.LabMask , opt.OutputName)';
                pipeline.([FieldName , DelMsg , '_FC']).command=command;
                pipeline.([FieldName , DelMsg , '_FC']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_FC']).opt.LabMask=Para.LabMask;
                pipeline.([FieldName , DelMsg , '_FC']).opt.OutputName=OutputName;
                pipeline.([FieldName , DelMsg , '_FC']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_FC']).files_out={OutputName};
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
        end
    end

function [FileList , FilesIn , FilesOut , NewDataList]=...
    UpdateDataList(Prefix , OldDataList , TimePoint)
    FileList=[];
    NewDataList=[];
    if iscell(OldDataList)
        FileList=OldDataList;
        FilesIn=OldDataList;
        for i=1:size(OldDataList , 1)
            [Path , File , Ext]=fileparts(OldDataList{i});
            NewDataList=[NewDataList ; ...
                {[Path , filesep , Prefix , File , Ext]}];
        end
        FilesOut=NewDataList;
    else
        FilesIn={OldDataList};
        for i=1:TimePoint
            FileList=[FileList ;... 
                {sprintf('%s,%d' , OldDataList , i)}];
        end
        [Path , File , Ext]=fileparts(OldDataList);
        NewDataList=[Path , filesep , Prefix , File , Ext];
        FilesOut={NewDataList};
    end
    
function DcmFile=GetNeedDcmFile(ParentDir , SubjName)
        FirstChar=1;
        while FirstChar<=size(SubjName , 2)
            SubjDir=[ParentDir , filesep , SubjName(FirstChar:end)];
            if ~(exist(SubjDir , 'dir')==7)
                FirstChar=FirstChar+1;
            else
                SubjFile=dir(SubjDir);
                if ~isempty(SubjFile)
                    if strcmp(SubjFile(1).name , '.')
                        SubjFile(1)=[];
                        if strcmp(SubjFile(2).name , '..')
                            SubjFile(1)=[];
                            if strcmp(SubjFile(1).name , '.DS_Store')
                                SubjFile(1)=[];
                            end
                        end
                    end
                end
                DcmFile=[SubjDir , filesep , SubjFile(1).name];
                break;
            end
        end

function CheckWarning(UIcontrol)
        set(UIcontrol , 'BackgroundColor' , 'Red');
        pause(0.08);
        set(UIcontrol , 'BackgroundColor' , 'White');
        pause(0.08);
        set(UIcontrol , 'BackgroundColor' , 'Red');
        pause(0.08);       
        set(UIcontrol , 'BackgroundColor' , 'White');
        pause(0.08);
        set(UIcontrol , 'BackgroundColor' , 'Red');
        pause(0.08);       
        set(UIcontrol , 'BackgroundColor' , 'White');
        pause(0.08);
        set(UIcontrol , 'BackgroundColor' , 'Red');
        pause(0.08);       
        set(UIcontrol , 'BackgroundColor' , 'White');        
    
% --------------------------------------------------------------------
function RunPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to RunPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RunEvent(hObject , handles);

function RunEvent(hObject , handles)
if isempty(handles.CalList)
    CheckWarning(handles.CalListbox);
    return;
end

if isempty(handles.DataList)
    CheckWarning(handles.InputListbox);
    return;
end

handles.Para.EPIPath=get(handles.InputEntry , 'String');
ParentDir=handles.Para.EPIPath;
if strcmp(ParentDir(end) , filesep)
    ParentDir=ParentDir(1:end-1);
end
while ~strcmp(ParentDir(end) , filesep)
  	ParentDir=ParentDir(1:end-1);
end
handles.Para.ParentDir=ParentDir;

if handles.ConnectFlag
    if ~isfield(handles , 'NetCalList') || ~isfield(handles , 'NetPara')
        [NetCalList , NetPara , Netfig , NetCalText ]=CalInterface;
        handles.NetCalList = NetCalList;
        handles.NetPara    = NetPara;
        handles.NetCalText = NetCalText;
        CalText=get(handles.CalListbox , 'String');
        CalText=[CalText ; NetCalText];
        set(handles.CalListbox , 'String' , CalText);
        drawnow;
        close(Netfig);
    else
        NetCalList = handles.NetCalList;
        NetPara    = handles.NetPara;
    end
    
    NetworkDir=[ParentDir , 'GretnaNetworkMetrics'];
    if ~(exist(NetworkDir , 'dir')==7)
        mkdir(NetworkDir);
    end
    TempDir=[NetworkDir , filesep , 'tmp'];
    if ~(exist(TempDir , 'dir')==7)
        mkdir(TempDir);
    end
end

%Time
Time=clock;
Date=sprintf('%d-%d-%d, %d:%d:%02.0f' , Time(1) , Time(2) , Time(3) , ...
            Time(4) , Time(5) , Time(6));

LogDir=[ParentDir , 'GretnaLogs' , filesep];
if ~(exist(LogDir , 'dir')==7)
    mkdir(LogDir);
end

CalText=get(handles.CalListbox , 'String');
fid=fopen([LogDir , 'PreprocessConfigure.txt'] , 'a');
fprintf(fid , [Date]);
if ispc
    fprintf(fid , '\r\n');
else
    fprintf(fid , '\n');
end
fprintf(fid , '-------------------------------------------------------');
if ispc
    fprintf(fid , '\r\n');
else
    fprintf(fid , '\n');
end
for i=1:size(CalText , 1)
    TempText=strrep(CalText{i} , '\' , '\\');
    if ispc
        fprintf(fid , [TempText , '\r\n']);
    else
        fprintf(fid , [TempText , '\n']);
    end
end
if ispc
    fprintf(fid , '\r\n');
else
    fprintf(fid , '\n');
end
fclose(fid);

if isfield(handles , 'InputText')
    InputText = handles.InputText;
else
    InputText=get(handles.InputListbox , 'String');
    handles.InputText = InputText;
end

fid=fopen([LogDir , 'InputDataList.txt'] , 'a');
fprintf(fid , [Date]);
if ispc
    fprintf(fid , '\r\n');
else
    fprintf(fid , '\n');
end
fprintf(fid , '-------------------------------------------------------');
if ispc
    fprintf(fid , '\r\n');
else
    fprintf(fid , '\n');
end
for i=1:size(InputText , 1)
    TempText=strrep(InputText{i} , '\' , '\\');
    if ispc
        fprintf(fid , [TempText , '\r\n']);
    else
        fprintf(fid , [TempText , '\n']);
    end
end
if ispc
    fprintf(fid , '\r\n');
else
    fprintf(fid , '\n');
end
fclose(fid);

handles.Para.LogDir=LogDir;

if strcmp(handles.CalList{1} , 'DICOM to NIFTI')
    NiiDir=[ParentDir , 'GretnaNifti'];
    if ~(exist(NiiDir , 'dir')==7)
        mkdir(NiiDir);
    end
    handles.Para.NiiDir=NiiDir;
end

if strcmp(handles.Para.T1D2NBool , 'TRUE') && strcmp(handles.Para.NormType , 'T1')
	T1ParentDir=handles.Para.T1Path;
    if strcmp(T1ParentDir(end) , filesep)
        T1ParentDir=T1ParentDir(1:end-1);
    end
    while ~strcmp(T1ParentDir(end) , filesep)
    	T1ParentDir=T1ParentDir(1:end-1);
    end
    T1NiiDir=[T1ParentDir , 'GretnaT1Nifti'];
    if ~(exist(T1NiiDir , 'dir')==7)
        mkdir(T1NiiDir);
    end
    handles.Para.T1NiiDir=T1NiiDir;
end

set(handles.RunButton       , 'Enable' , 'Off');
set(handles.RunPushtool     , 'Enable' , 'Off');
set(handles.StopPushtool    , 'Enable' , 'On');
set(handles.RefreshPushtool , 'Enable' , 'On');
set(handles.InputListbox , 'Enable' , 'inactive');

handles.PipelineLog=[LogDir , 'pipeline_logs'];

%MatOutput

%if ~isempty(strfind(handles.CalList , 'Normalize'))
%    handles.Para.PicDir=[ParentDir , 'GretnaPicForCheck'];
%    if ~(exist(handles.Para.PicDir , 'dir')==7)
%        mkdir(handles.Para.PicDir);
%    end
%end

pipeline=[];
CalList=handles.CalList;
DataList=handles.DataList;
SubjField=fieldnames(DataList);
Para=handles.Para;

guidata(hObject , handles);

for i=1:size(SubjField , 1)
    SubjData=getfield(DataList , SubjField{i});
    pipeline=PreprocessFork(SubjData , CalList , Para , SubjField{i} , pipeline);
    if handles.ConnectFlag
        command='gretna_ForkProcess(opt.Matrix , opt.CalList , opt.Para , opt.OutputDir , opt.SubjNum)';
        pipeline.([SubjField{i} , '_NetworkMetrics']).command=command;
        pipeline.([SubjField{i} , '_NetworkMetrics']).opt.Matrix=[Para.ParentDir , 'GretnaMatrixResult' , filesep , SubjField{i}(6:end) , '.txt'];
        pipeline.([SubjField{i} , '_NetworkMetrics']).opt.CalList=NetCalList;
        pipeline.([SubjField{i} , '_NetworkMetrics']).opt.Para=NetPara;
        pipeline.([SubjField{i} , '_NetworkMetrics']).opt.OutputDir=NetworkDir;
        pipeline.([SubjField{i} , '_NetworkMetrics']).opt.SubjNum=['_',SubjField{i}(6:end)];
        pipeline.([SubjField{i} , '_NetworkMetrics']).files_in={[Para.ParentDir , 'GretnaMatrixResult' , filesep , SubjField{i}(6:end) , '.txt']};
        %pipeline.([SubjField{i} , '_NetworkMetrics']).files_out={sprintf('%s%s%s.out' , TempDir , filesep , ['_',SubjField{i}(6:end)])};
    end
end
opt.path_logs = [LogDir , 'pipeline_logs'];
opt.mode = 'batch';
opt.mode_pipeline_manager = 'batch';
opt.max_queued = str2num(get(handles.QueueEntry , 'String'));
opt.flag_verbose = 0;
opt.flag_pause = 0;
opt.flag_update = 1;
psom_run_pipeline(pipeline,opt);
RefreshStatus(handles);

function RefreshStatus(handles)
    SubjField=fieldnames(handles.DataList);
    StatusStruct=load([handles.PipelineLog , filesep , 'PIPE_status']);
    StatusName=fieldnames(StatusStruct);
    StatusText=[];
    for i=1:size(SubjField , 1)
        StatusNow=[];
        Leng=size(SubjField{i} , 2);
        for j=1:size(StatusName)
            if strcmp(SubjField{i} ,...
                    StatusName{j}(1:Leng))
                LastMission=StatusName{j}(Leng+2:end);
                if ~strcmp(StatusStruct.(StatusName{j}) , 'finished')
                	StatusNow=sprintf('(%s/%s): %s' , ...
                        SubjField{i}(6:Leng) , LastMission ,...
                        StatusStruct.(StatusName{j}));
                    break;
                end
            end
        end
        
        if isempty(StatusNow);
            StatusNow=sprintf('(%s/%s): finished' , ...
                SubjField{i}(6:Leng) , LastMission);
        end
        StatusText=[StatusText ; {StatusNow}];
    end
    set(handles.InputListbox , 'String' , StatusText , 'Value' , 1);
    drawnow;
    
% --------------------------------------------------------------------
function DefaultPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to DefaultPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.DefaultPushtool , 'Enable' , 'Off');
    GUIPath=fileparts(which('PreprocessInterface.m'));
    Para=handles.Para;
    save([GUIPath , filesep , 'PreprocessPara.mat'] , 'Para');
% --------------------------------------------------------------------
function HelpPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to HelpPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    GUIPath=fileparts(which('PreprocessInterface.m'));
    ManualFile=[GUIPath , filesep , 'GretnaManual.pdf'];
    open(ManualFile);

% --- Executes on selection change in ConfigListbox.
function ConfigListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ConfigListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ConfigListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ConfigListbox


% --- Executes during object creation, after setting all properties.
function ConfigListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConfigListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RunEvent(hObject , handles);

% --------------------------------------------------------------------
function LoadPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to LoadPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName , PathName] = uigetfile('*.mat' , 'Pick a configure mat for Preprocess');
if ischar(FileName)
    ConfigMat=load([PathName , FileName]);
    handles.Para=ConfigMat.Para;
    handles.CalList=ConfigMat.CalList;
    set(handles.ModeListbox , 'String' , ConfigMat.ModeList);
    if isempty(ConfigMat.ModeList)
        set(handles.ModeListbox , 'Value' , 0);
    else
        set(handles.ModeListbox , 'Value' , 1);
    end
    CalText=CalListbox(handles);
    set(handles.CalListbox , 'String' , CalText);
    if isempty(ConfigMat.CalList)
        set(handles.CalListbox , 'Value' , 0);
    else
        set(handles.CalListbox , 'Value' , 1);
    end
    guidata(hObject , handles);
end

% --------------------------------------------------------------------
function SavePushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to SavePushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName , PathName]=uiputfile('*.mat', 'Save a configure mat for Preprocess' , 'MyPreprocessConfig.mat' );
if ischar(FileName)
    SaveName=[PathName , FileName];
    ModeList=get(handles.ModeListbox , 'String');
    CalList=handles.CalList;
    Para=handles.Para;
    save(SaveName , 'ModeList' , 'CalList' , 'Para');
end


% --------------------------------------------------------------------
function StopPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to StopPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.RunButton   , 'Enable' , 'On');
set(handles.RunPushtool , 'Enable' , 'On');
set(handles.StopPushtool, 'Enable' , 'Off');
set(handles.RefreshPushtool , 'Enable' , 'Off');
set(handles.InputListbox    , 'Enable' , 'On' , 'String' , handles.InputText);

StopFlag=dir([handles.PipelineLog , filesep , 'PIPE.lock']);
if ~isempty(StopFlag)
    delete([handles.PipelineLog , filesep , 'PIPE.lock']);
end

function QueueEntry_Callback(hObject, eventdata, handles)
% hObject    handle to QueueEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QueueSize=get(handles.QueueEntry, 'String');
handles.Para.QueueSize=str2num(QueueSize);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of QueueEntry as text
%        str2double(get(hObject,'String')) returns contents of QueueEntry as a double


% --- Executes during object creation, after setting all properties.
function QueueEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QueueEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function RefreshPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to RefreshPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RefreshStatus(handles);
if ~(isempty(dir([handles.PipelineLog , filesep , 'jobs.finish'])) &&...
        ~isempty(dir([handles.PipelineLog , filesep , 'PIPE.lock'])))
    set(handles.RunButton       , 'Enable' , 'On');
    set(handles.RunPushtool     , 'Enable' , 'On');
    set(handles.StopPushtool    , 'Enable' , 'Off');
    set(handles.RefreshPushtool , 'Enable' , 'Off');
    set(handles.InputListbox    , 'Enable' , 'On');
end


% --- Executes on selection change in PopupMenu.
function PopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.PopupMenu , 'Value')
    case 1
        return;
    case 2
        PopupText=get(handles.PopupMenu , 'String');
        if strcmpi(PopupText{2} , 'Connect to GRETNA Calculate')
            PopupText{2}='Select to UnConnect from GRETNA Calculate';
            set(handles.PopupMenu , 'String' , PopupText);
            CalInterface('Connect');
            handles.ConnectFlag=1;
        else
            PopupText{2}='Connect to GRETNA Calculate';
            set(handles.PopupMenu , 'String' , PopupText);
            CalInterface('UnConnect');
            handles.ConnectFlag=0;
        end
        guidata(hObject , handles);
end
% Hints: contents = cellstr(get(hObject,'String')) returns PopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopupMenu


% --- Executes during object creation, after setting all properties.
function PopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
