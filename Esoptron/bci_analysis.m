function varargout = bci_analysis(varargin)
% BCI_ANALYSIS M-file for bci_analysis.fig
%      BCI_ANALYSIS, by itself, creates a new BCI_ANALYSIS or raises the existing
%      singleton*.
%
%      H = BCI_ANALYSIS returns the handle to a new BCI_ANALYSIS or the handle to
%      the existing singleton*.
%
%      BCI_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BCI_ANALYSIS.M with the given input arguments.
%
%      BCI_ANALYSIS('Property','Value',...) creates a new BCI_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bci_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bci_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bci_analysis

% Last Modified by GUIDE v2.5 08-Aug-2012 12:33:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bci_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @bci_analysis_OutputFcn, ...
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


% --- Executes just before bci_analysis is made visible.
function bci_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bci_analysis (see VARARGIN)

% Choose default command line output for bci_analysis
handles.output = hObject;
handles.rootdir='/Users/louk/BCI_code/toolboxes/ls_bci/Esoptron/';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bci_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bci_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function select_subject_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.subject_path = uigetdir;
temp=find(handles.subject_path=='/');
handles.subject_name=handles.subject_path(temp(end)+1:end);
set(handles.subject_name_stext,'String',handles.subject_name);

handles.bdf_files_fullpath=rdir(strcat(handles.subject_path,'/**/*.bdf'));

% handles.xls=rdir(strcat(handles.subject_path,'/**/*.xls'));
 for i=1:length(handles.bdf_files_fullpath)
     temp2=handles.bdf_files_fullpath(i).name;
     temp3=find(temp2=='/');
     temp4{i}=temp2(temp3(end)+1:end);
 end
bdf_filenames=temp4;
set(handles.bdf_files_listbox,'String',bdf_filenames);

load(strcat(handles.rootdir,'default_cfg.mat'));

temp5=dir(strcat(handles.subject_path,'/ls_bci/',cfg.name,'/*.mat'))
temp6=struct2cell(temp5);
temp6=temp6(1,:);
set(handles.sliced_markers_listbox,'String',temp6);

set(handles.cfg_name_etext,'String',cellstr(cfg.name));
set(handles.eventtype_etext,'String',cellstr(cfg.trialdef.eventtype));
set(handles.prestim_etext,'String',(cfg.trialdef.prestim));
set(handles.poststim_etext,'String',(cfg.trialdef.poststim));
cd(handles.rootdir);
set(handles.loaded_data_listbox,'String',[]);
guidata(hObject,handles);


% --- Executes on selection change in bdf_files_listbox.
function bdf_files_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to bdf_files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bdf_files_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bdf_files_listbox


% --- Executes during object creation, after setting all properties.
function bdf_files_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bdf_files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
