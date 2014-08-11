function varargout = gretna_GUI_CompInterface(varargin)
% GRETNA_GUI_COMPINTERFACE MATLAB code for gretna_GUI_CompInterface.fig
%      GRETNA_GUI_COMPINTERFACE, by itself, creates a new GRETNA_GUI_COMPINTERFACE or raises the existing
%      singleton*.
%
%      H = GRETNA_GUI_COMPINTERFACE returns the handle to a new GRETNA_GUI_COMPINTERFACE or the handle to
%      the existing singleton*.
%
%      GRETNA_GUI_COMPINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRETNA_GUI_COMPINTERFACE.M with the given input arguments.
%
%      GRETNA_GUI_COMPINTERFACE('Property','Value',...) creates a new GRETNA_GUI_COMPINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gretna_GUI_CompInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gretna_GUI_CompInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gretna_GUI_CompInterface

% Last Modified by GUIDE v2.5 08-Jul-2014 15:29:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gretna_GUI_CompInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @gretna_GUI_CompInterface_OutputFcn, ...
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


% --- Executes just before gretna_GUI_CompInterface is made visible.
function gretna_GUI_CompInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gretna_GUI_CompInterface (see VARARGIN)

% Choose default command line output for gretna_GUI_CompInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gretna_GUI_CompInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gretna_GUI_CompInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in NodeButton.
function NodeButton_Callback(hObject, eventdata, handles)
% hObject    handle to NodeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gretna_GUI_StatInterface;

% --- Executes on button press in EdgeButton.
function EdgeButton_Callback(hObject, eventdata, handles)
% hObject    handle to EdgeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gretna_GUI_EdgeInterface;
