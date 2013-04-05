function varargout = CalInterface(varargin)
% CALINTERFACE MATLAB code for CalInterface.fig
%      CALINTERFACE, by itself, creates a new CALINTERFACE or raises the existing
%      singleton*.
%
%      H = CALINTERFACE returns the handle to a new CALINTERFACE or the handle to
%      the existing singleton*.
%
%      CALINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALINTERFACE.M with the given input arguments.
%
%      CALINTERFACE('Property','Value',...) creates a new CALINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalInterface

% Last Modified by GUIDE v2.5 18-Dec-2012 15:40:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @CalInterface_OutputFcn, ...
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


% --- Executes just before CalInterface is made visible.
function CalInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalInterface (see VARARGIN)

% Choose default command line output for CalInterface
handles.output = hObject;

if ~isfield(handles , 'CalList')
    handles.CalList=[];
end
if ~isfield(handles , 'DataList')
    handles.DataList=[];
end
if ~isfield(handles , 'subj_num')
    handles.subj_num=0;
end

if isempty(get(handles.OutputEntry , 'String'))
    set(handles.OutputEntry , 'String' , pwd);
end

if ~isfield(handles , 'Para')
    GUIPath=fileparts(which('CalInterface.m'));
    ParaFile=[GUIPath , filesep , 'CalPara.mat'];
    
    if exist(ParaFile , 'file')
        Para=load([GUIPath , filesep , 'CalPara.mat']);
        Para=Para.Para;
    else
        Para=[];
    end
    
    if isempty(Para)
    	Para.NumRandNet=100;
    	Para.ThresRegion='0.05 : 0.01 : 0.4';
    	Para.ThresType='correlation coefficient';
    	Para.NetType='weighted';
    	Para.ModulAlorithm='greedy optimization';
        save(ParaFile , 'Para');
    end
    handles.Para=Para;
end

CalText=CalListbox(handles);
set(handles.CalListbox , 'String' , CalText , 'Value' , 6);

if nargin==4
    if strcmpi(varargin{1},'Connect');
        handles.DataList=[];
        set(handles.DataListbox , 'Enable' , 'Off' ,...
            'String' , '' , 'Value', 0 , ...
            'Background' , get(0,'defaultUicontrolBackgroundColor'));        
        set(handles.DataButton  , 'Enable' , 'Off');
        set(handles.RunButton   , 'Enable' , 'Off');
        set(handles.RunPushtool , 'Enable' , 'Off');
        set(handles.WorkerEntry , 'Enable' , 'Off' , 'String' , ''); 
        set(handles.OutputEntry , 'Enable' , 'Off' , 'String' , '');
        set(handles.OutputButton, 'Enable' , 'Off');
        set(handles.PopupMenu   , 'Enable' , 'Off');
    elseif strcmpi(varargin{1},'UnConnect')
        close(hObject);
        return;
    end
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CalInterface wait for user response (see UIRESUME)
% uiwait(handles.CalInterface);


% --- Outputs from this function are returned to the command line.
function varargout = CalInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles , 'CalList') &&...
        isfield(handles , 'Para') &&...
        isfield(handles , 'CalInterface')
    varargout{1} = handles.CalList;
    varargout{2} = handles.Para;
    varargout{3} = handles.CalInterface;
    varargout{4} = get(handles.CalListbox  , 'String');
end

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
        if isempty(handles.CalList)
            set(handles.ModeListbox , 'Value' , 0);
            set(handles.CalListbox ,  'Value' , 6);
        else
            set(handles.ModeListbox , 'Value' , 1);
            set(handles.CalListbox ,  'Value' , 7);
        end
        set(handles.ModeListbox , 'String' , ModeList);
        CalText=CalListbox(handles);
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
        if isempty(handles.CalList)
            set(handles.ModeListbox , 'Value' , 0);
            set(handles.CalListbox ,  'Value' , 6);
        else
            set(handles.ModeListbox , 'Value' , 1);
            set(handles.CalListbox ,  'Value' , 7);
        end
        set(handles.ModeListbox , 'String' , ModeList);
        CalText=CalListbox(handles);
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
        IsMode=0;
        for i=1:size(handles.CalList, 1)
            if strcmp(CalText{SelectValue} , ['. ' , handles.CalList{i}])
                IsMode=1;
                break;
            end
        end
        if ~IsMode
            return;
        end
        ModeList=get(handles.ModeListbox , 'String');
        ModeList=[ModeList ; CalText{SelectValue}(3:end)];
        for i=1:size(handles.CalList , 1)
            if strcmp(['. ',handles.CalList{i}] , CalText{SelectValue})
                temp_order=i;
            end
        end
        handles.CalList(temp_order)=[];
        CalText=CalListbox(handles);
        if isempty(handles.CalList)
            set(handles.CalListbox , 'Value' , 6)
        else
            set(handles.CalListbox , 'Value' , 7)
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
        if ~isempty(handles.CalList)
            for i=1:size(handles.CalList, 1)
                if strcmp(CalText{SelectValue} , ['. ' , handles.CalList{i}])
                    IsMode=1;
                    break;
                end
            end
        end
        ConfigText=[];
        if ~IsMode
        	if ~isempty(strfind(CalText{SelectValue} , 'Random Networks (n):'))
                ConfigText={sprintf('%d' , handles.Para.NumRandNet)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Threshold Region'))
                ThresRegion=str2num(handles.Para.ThresRegion);
                ConfigText={sprintf('%1.3f ' , ThresRegion)};
                set(handles.ConfigListbox , 'String' , ConfigText);
                set(handles.ConfigListbox , 'Value'  , 1);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Threshold Type'))
                if strcmpi(handles.Para.ThresType , 'correlation coefficient');
                    ConfigText={'*correlation coefficient';...
                        'sparsity'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'correlation coefficient';...
                        '*sparsity'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Network Type'))
                if strcmpi(handles.Para.NetType , 'binarize');
                    ConfigText={'*binarize';...
                        'weighted'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'binarize';...
                        '*weighted'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'algorithm'))
                if strcmpi(handles.Para.ModulAlorithm , 'greedy optimization');
                    ConfigText={'*greedy optimization';...
                        'spectral optimization'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    ConfigText={'greedy optimization';...
                        '*spectral optimization'};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Network Metrics:'))
                set(handles.ConfigListbox , 'String' , [] , 'Value' , 0);
            elseif ~isempty(strfind(CalText{SelectValue} , 'Selected Mode:'))
                set(handles.ConfigListbox , 'String' , [] , 'Value' , 0);
            end
        else
            set(handles.ConfigListbox , 'String' , [] , 'Value' , 0);
        end
        
        return;
    end
elseif strcmp(get(gcf , 'SelectionType') , 'open')
    CalText=get(handles.CalListbox , 'String');
    if ~isempty(CalText)
        SelectValue=get(handles.CalListbox , 'Value');
        ModeList=get(handles.ModeListbox , 'String');
        IsMode=0;
        if ~isempty(handles.CalList)
            for i=1:size(handles.CalList, 1)
                if strcmp(CalText{SelectValue} , ['. ' , handles.CalList{i}])
                    IsMode=1;
                    break;
                end
            end
        end
        if ~IsMode
        	if ~isempty(strfind(CalText{SelectValue} , 'Random Networks (n):'))
                NumRandNet=inputdlg('Enter the number of random network:',...
                    'The Number of Random Network',...
                    1,...
                    {num2str(handles.Para.NumRandNet)});
                if ~isempty(NumRandNet)
                    handles.Para.NumRandNet=str2num(NumRandNet{1});
                    ConfigText={sprintf('%d' , handles.Para.NumRandNet)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Threshold Region'))
                ThresRegion=inputdlg('Enter the Threshold:',...
                    'Threshold Region',...
                    1,...
                    {handles.Para.ThresRegion});
                if ~isempty(ThresRegion)
                    handles.Para.ThresRegion=ThresRegion{1};
                    ThresRegion=str2num(handles.Para.ThresRegion);
                    ConfigText={sprintf('%1.3f ' , ThresRegion)};
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Threshold Type'))
                if strcmp(handles.Para.ThresType , 'correlation coefficient')
                    handles.Para.ThresType='sparsity';
                    ConfigText=[{'correlation coefficient'};...
                        {'*sparsity'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.ThresType='correlation coefficient';
                    ConfigText=[{'*correlation coefficient'};...
                        {'sparsity'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'Network Type'))
                if strcmp(handles.Para.NetType , 'weighted')
                    handles.Para.NetType='binarize';
                    ConfigText=[{'*binarize'};...
                        {'weighted'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 1);
                else
                    handles.Para.NetType='weighted';
                    ConfigText=[{'binarize'};...
                        {'*weighted'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                end
            elseif ~isempty(strfind(CalText{SelectValue} , 'algorithm'))
                if strcmp(handles.Para.ModulAlorithm , 'greedy optimization')
                    handles.Para.ModulAlorithm='spectral optimization';
                    ConfigText=[{'greedy optimization'};...
                        {'*spectral optimization'}];
                    set(handles.ConfigListbox , 'String' , ConfigText);
                    set(handles.ConfigListbox , 'Value'  , 2);
                else
                    handles.Para.ModulAlorithm='greedy optimization';
                    ConfigText=[{'*greedy optimization'};...
                        {'spectral optimization'}];
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
        
        ModeList=[ModeList ; CalText{SelectValue}(3:end)];
        for i=1:size(handles.CalList , 1)
        	if strcmp(['. ',handles.CalList{i}] , CalText{SelectValue})
            	temp_order=i;
            else
            	continue;
            end
        end
        handles.CalList(temp_order)=[];
        
        CalText=CalListbox(handles);
        if isempty(handles.CalList)
            set(handles.CalListbox , 'Value' , 6)
        else
            set(handles.CalListbox , 'Value' , 7)
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
    Result=[Result ; ...
        {'Network Metrics:'};...
        {sprintf('. Network Type:  %s' , AHandle.Para.NetType)};...
        {sprintf('. Threshold Type:  %s' , AHandle.Para.ThresType)};...        
        {sprintf('. Threshold Region:  %s' , AHandle.Para.ThresRegion)};...        
        {sprintf('. Random Networks (n):  %d' , AHandle.Para.NumRandNet)};...
        {'Selected Mode:'}];
    if isempty(AHandle.CalList)
        return;
    end
    
    for i=1:size(AHandle.CalList , 1)
        Mode=AHandle.CalList{i};
        if strcmpi(Mode , 'Network - Modularity')
            Result=[Result ; ...
                {['. ',Mode]} ; ...
                {sprintf('. . algorithm:  %s' , AHandle.Para.ModulAlorithm)}];
        else
            Result=[Result ; ...
                {['. ',Mode]}];
        end
    end


% --- Executes on selection change in DataListbox.
function DataListbox_Callback(hObject, eventdata, handles)
% hObject    handle to DataListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcf , 'SelectionType') , 'normal')
    return;
elseif strcmp(get(gcf , 'SelectionType') , 'open')
    DataText=get(handles.DataListbox , 'String');
    SelectedValue=get(handles.DataListbox , 'Value');
    ShowMatrix=0;
    if isempty(SelectedValue)
        return;
    end
    while SelectedValue
        if ~isempty(strfind(DataText{SelectedValue} , '--->#'))
            ShowMatrix=ShowMatrix+1;
        else
            break;
        end
        SelectedValue=SelectedValue-1;
    end
    
    if ShowMatrix
        [Path Name Ext]=fileparts(DataText{SelectedValue});
        if strcmp(Ext , '.mat')
            TempStruct=load([Path , filesep , Name , Ext]);
            F=fieldnames(TempStruct);
            TempMat=getfield(TempStruct , F{1});
            if size(TempMat , 2)~=1
                TempMat={TempMat};
            end
        else
            TempMat=load([Path , filesep , Name , Ext]);
            TempMat={TempMat};
        end
        figure('Name', sprintf('%s%s%s%s  $%.4d',...
            Path , filesep , Name , Ext  , ShowMatrix), ...
            'NUmbertitle' , 'Off'),...
            imagesc(TempMat{ShowMatrix});
        daspect([1,1,1]);
        colorbar;
    else
        SelectedFile=DataText{SelectedValue};
        temp_order=0;
        for i=1:size(handles.DataList , 1)
            if strcmp(handles.DataList{i} , SelectedFile)
                temp_order=i;
                break;
            else
                continue;
            end
        end
        handles.DataList(temp_order)=[];
        handles=DataListbox(handles);
        if isempty(handles.DataList)
            set(handles.DataListbox , 'Value' , 0);
        else
            set(handles.DataListbox , 'Value' , 1);
        end
    end
    guidata(hObject , handles);
end
% Hints: contents = cellstr(get(hObject,'String')) returns DataListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataListbox


% --- Executes during object creation, after setting all properties.
function DataListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DataButton.
function DataButton_Callback(hObject, eventdata, handles)
% hObject    handle to DataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [input_filename , input_pathname]=...
        uigetfile({'*.txt;*.mat','Brain Network Matrix (*.txt;*.mat)';'*.*', 'All Files (*.*)';}, ...
            'Pick brain network matrix' , 'MultiSelect' , 'On');
    if (ischar(input_filename) || iscell(input_filename)) &&...
            ischar(input_pathname)
        if ischar(input_filename)
            input_filename={input_filename};
        end
        
        for i=1:size(input_filename , 2)
            IsExist=0;
            if ~isempty(handles.DataList)
                for j=1:size(handles.DataList , 1)
                    if strcmp([input_pathname , input_filename{i}] , handles.DataList{j})
                        IsExist=1;
                        break;
                    end
                end
            end
            if ~IsExist
                handles.DataList=[handles.DataList ; ...
                    {[input_pathname , input_filename{i}]}];
            end
        end
        
        if isempty(handles.DataList)
            set(handles.DataListbox , 'Value' , 0);
        else
            set(handles.DataListbox , 'Value' , 1);
        end
        
        handles=DataListbox(handles);
        guidata(hObject , handles);
    end
    
function handles=DataListbox(handles)
    present_list=[];
    subj_num=0;
    if ~isempty(handles.DataList)
        for j=1:size(handles.DataList , 1)
        	[Path , File , Ext]=...
            	fileparts(handles.DataList{j});
            if strcmp(Ext , '.txt')
            	TempMat=load([Path , filesep , File , Ext]);
                subj_num=subj_num+1;
                present_list=[present_list ;...
                	{sprintf('%s%s%s%s',...
                    Path , filesep , File , Ext)}];
                present_list=[present_list ; ...
                	{sprintf('--->#%.4d: (%d -- %d)',...
                    subj_num , size(TempMat , 1),...
                    size(TempMat , 2))}];
            elseif strcmp(Ext , '.mat')
            	TempStruct=load([Path , filesep , File , Ext]);
                F=fieldnames(TempStruct);
                TempMat=getfield(TempStruct , F{1});
                if size(TempMat , 2)==1
                    present_list=[present_list ; ...
                    	{sprintf('%s%s%s%s',...
                        Path , filesep,...
                        File , Ext)}];
                    for i=1:size(TempMat , 1)
                    	subj_num=subj_num+1;
                        present_list=[present_list ; ...
                        	{sprintf('--->#%.4d: (%d -- %d)',...
                            subj_num , size(TempMat{i} , 1),...
                            size(TempMat{i} , 2))}];
                    end
                else
                	subj_num=subj_num+1;
                    present_list=[present_list ;...
                    	{sprintf('%s%s%s%s',...
                        Path , filesep , File , Ext)}];
                    present_list=[present_list ; ...
                    	{sprintf('--->#%.4d: (%d -- %d)',...
                        subj_num , size(TempMat , 1),...
                        size(TempMat , 2))}];
                end
            end
        end
    end
    set(handles.DataListbox , 'String' , present_list);
    handles.subj_num=subj_num;

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ModeListbox.
function ModeListbox_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ModeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function OutputEntry_Callback(hObject, eventdata, handles)
% hObject    handle to OutputEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputEntry as text
%        str2double(get(hObject,'String')) returns contents of OutputEntry as a double


% --- Executes during object creation, after setting all properties.
function OutputEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OutputButton.
function OutputButton_Callback(hObject, eventdata, handles)
% hObject    handle to OutputButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OutputDir=uigetdir('Please pick a directory to output results');
if ischar(OutputDir)
    set(handles.OutputEntry , 'String' , OutputDir);
end


% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RunEvent(hObject , handles);

function RunEvent(hObject , handles)
    if isempty(handles.CalList)
        CheckWarning(handles.CalListbox);
        return;
    end
    
    if isempty(handles.DataList)
        CheckWarning(handles.DataListbox);
        return;
    end
    
    MatrixList=[];
    for i=1:size(handles.DataList)
        [Path , Name , Ext]=fileparts(handles.DataList{i});
        if strcmp(Ext , '.txt')
            TempMat=load([Path , filesep , Name , Ext]);
            MatrixList=[MatrixList ;...
                {TempMat}];
        elseif strcmp(Ext , '.mat')
            TempStruct=load([Path , filesep , Name , Ext]);
            F=fieldnames(TempStruct);
            TempMat=getfield(TempStruct , F{1});
            if iscell(TempMat)
                MatrixList=[MatrixList ;...
                    TempMat];
            else
                MatrixList=[MatrixList ;...
                    {TempMat}];
            end
        end
    end
    
    CalList=handles.CalList;
    Para=handles.Para;
    OutputDir=get(handles.OutputEntry , 'String');
    
    LogDir = [OutputDir , filesep , 'GretnaLogs' , filesep];
    handles.LogDir=LogDir;
    guidata(hObject , handles);
    
    if ~(exist(LogDir , 'dir')==7)
        mkdir(LogDir);
    end
    
    %Time
    Time=clock;
    Date=sprintf('%d-%d-%d, %d:%d:%02.0f' , Time(1) , Time(2) , Time(3) , ...
    	Time(4) , Time(5) , Time(6));
    
    CalText=get(handles.CalListbox , 'String');
    fid=fopen([LogDir , 'NetworkMetricsConfigure.txt'] , 'a');
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

    InputText=get(handles.DataListbox , 'String');
    fid=fopen([LogDir , 'MatrixList.txt'] , 'a');
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
    
    pipeline=[];
    tmpDir=[OutputDir , filesep , 'tmp'];
    if (exist(tmpDir , 'dir')==7)
        rmdir(tmpDir , 's');
    end
    mkdir(tmpDir);
    
    WorkList=[];
    for i=1:size(MatrixList , 1)
        WorkList=[WorkList ; {sprintf('Fork%.4d' , i)}];
        Matrix=MatrixList{i};
        fid=fopen(sprintf('%s%s%.4d.in' , tmpDir , filesep , i) , 'w');
        fclose(fid);
        command='gretna_ForkProcess(opt.Matrix , opt.CalList , opt.Para , opt.OutputDir , opt.SubjNum)';
        pipeline.(sprintf('Fork%.4d' , i)).command=command;
        pipeline.(sprintf('Fork%.4d' , i)).opt.Matrix=Matrix;
        pipeline.(sprintf('Fork%.4d' , i)).opt.CalList=CalList;
        pipeline.(sprintf('Fork%.4d' , i)).opt.Para=Para;
        pipeline.(sprintf('Fork%.4d' , i)).opt.OutputDir=OutputDir;
        pipeline.(sprintf('Fork%.4d' , i)).opt.SubjNum=i;
        pipeline.(sprintf('Fork%.4d' , i)).files_in={sprintf('%s%s%.4d.in' , tmpDir , filesep , i)};
        %pipeline.(sprintf('Fork%.4d' , i)).files_out={sprintf('%s%s%.4d.out' , tmpDir , filesep , i)};
    end

    opt.path_logs = [handles.LogDir , filesep ,  'NetworkMetrics_logs'];
    handles.PipelineLog=opt.path_logs;
    handles.WorkList=WorkList;
    guidata(hObject , handles);
    
    set(handles.DataListbox , 'Enable' , 'inactive');
    set(handles.RunButton       , 'Enable' , 'Off');
    set(handles.RunPushtool     , 'Enable' , 'Off');
    set(handles.StopPushtool    , 'Enable' , 'On');
    set(handles.RefreshPushtool , 'Enable' , 'On');
    
    opt.mode = 'batch';
    opt.mode_pipeline_manager = 'batch';
    opt.max_queued = str2num(get(handles.WorkerEntry , 'String'));
    opt.flag_verbose = 0;
    opt.flag_pause = 0;
    opt.flag_update = 1;
    psom_run_pipeline(pipeline,opt);
    RefreshStatus(handles);
    
function RefreshStatus(handles)
    WorkList=handles.WorkList;
    StatusStruct=load([handles.PipelineLog , filesep , 'PIPE_status']);
    StatusName=fieldnames(StatusStruct);
    StatusText=[];
    for i=1:size(WorkList , 1)
        StatusNow=[];
        for j=1:size(StatusName)
            if strcmp(WorkList{i} ,...
                StatusName{j})
                StatusNow=sprintf('%s: %s' , ...
                    WorkList{i} , StatusStruct.(StatusName{j}));
                    break;
            end
        end
        
        StatusText=[StatusText ; {StatusNow}];
    end
    set(handles.DataListbox , 'String' , StatusText , 'Value' , 1);
    drawnow;
  
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
        if strcmpi(PopupText{2} , 'Connect to GRETNA Preprocess')
            set(handles.DataListbox , 'Enable' , 'Off' ,...
                'String' , '' , 'Value', 0 , ...
                'Background' , get(0,'defaultUicontrolBackgroundColor'));
            handles.DataList=[];
            set(handles.DataButton  , 'Enable' , 'Off');
            set(handles.RunButton   , 'Enable' , 'Off');
            set(handles.RunPushtool , 'Enable' , 'Off');
            set(handles.WorkerEntry , 'Enable' , 'Off' , 'String' , ''); 
            set(handles.OutputEntry , 'Enable' , 'Off' , 'String' , '');
            set(handles.OutputButton, 'Enable' , 'Off');
            PopupText{2}='Select to UnConnect from GRETNA Preprocess';
            set(handles.PopupMenu , 'String' , PopupText);
            guidata(hObject , handles);
            PreprocessInterface('Connect');
        else
            set(handles.DataListbox , 'Enable' , 'Off' ,...
                'String' , '' , 'Value', 0 , ...
                'Background' , 'White');
            handles.DataList=[];
            set(handles.DataButton  , 'Enable' , 'On');
            set(handles.RunButton   , 'Enable' , 'On');
            set(handles.RunPushtool , 'Enable' , 'On');
            set(handles.WorkerEntry , 'Enable' , 'On' , 'String' , '3');
            set(handles.OutputEntry , 'Enable' , 'On' , 'String' , pwd);
            set(handles.OutputButton, 'Enable' , 'On');
            PopupText{2}='Connect to GRETNA Preprocess';
            set(handles.PopupMenu , 'String' , PopupText);
            guidata(hObject , handles);
            PreprocessInterface('UnConnect');
        end
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



function WorkerEntry_Callback(hObject, eventdata, handles)
% hObject    handle to WorkerEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WorkerEntry as text
%        str2double(get(hObject,'String')) returns contents of WorkerEntry as a double


% --- Executes during object creation, after setting all properties.
function WorkerEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkerEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function DefaultPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to DefaultPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.DefaultPushtool , 'Enable' , 'Off');
    GUIPath=fileparts(which('CalInterface.m'));
    Para=handles.Para;
    save([GUIPath , filesep , 'CalPara.mat'] , 'Para');


% --------------------------------------------------------------------
function HelpPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to HelpPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    GUIPath=fileparts(which('PreprocessInterface.m'));
    ManualFile=[GUIPath , filesep , 'GretnaManual.pdf'];
    open(ManualFile);

% --------------------------------------------------------------------
function LoadPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to LoadPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName , PathName] = uigetfile('*.mat' , 'Pick a configure mat for CalInterface');
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
        set(handles.CalListbox , 'Value' , 6);
    else
        set(handles.CalListbox , 'Value' , 7);
    end
    guidata(hObject , handles);
end

% --------------------------------------------------------------------
function SavePushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to SavePushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName , PathName]=uiputfile('*.mat', 'Save a configure mat for CalInterface' , 'MyCalConfig.mat' );
if ischar(FileName)
    SaveName=[PathName , FileName];
    ModeList=get(handles.ModeListbox , 'String');
    CalList=handles.CalList;
    Para=handles.Para;
    save(SaveName , 'ModeList' , 'CalList' , 'Para');
end


% --------------------------------------------------------------------
function RunPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to RunPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RunEvent(hObject , handles);

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


% --------------------------------------------------------------------
function RefreshPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to RefreshPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RefreshStatus(handles);
    if ~(isempty(dir([handles.PipelineLog , filesep , 'jobs.finish'])) &&...
            ~isempty(dir([handles.PipelineLog , filesep , 'PIPE.lock'])))
        set(handles.DataListbox     , 'Enable' , 'On');
        set(handles.RunPushtool     , 'Enable' , 'On');
        set(handles.StopPushtool    , 'Enable' , 'Off');
        set(handles.RunButton       , 'Enable' , 'On');
        set(handles.RefreshPushtool , 'Enable' , 'Off');
    end

% --------------------------------------------------------------------
function StopPushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to StopPushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DataListbox     , 'Enable' , 'On');
set(handles.RunButton       , 'Enable' , 'On');
set(handles.RunPushtool     , 'Enable' , 'On');
set(handles.StopPushtool    , 'Enable' , 'Off');
set(handles.RefreshPushtool , 'Enable' , 'Off');
StopFlag=dir([handles.PipelineLog , filesep , 'PIPE.lock']);
if ~isempty(StopFlag)
    delete([handles.PipelineLog , filesep , 'PIPE.lock']);
end
