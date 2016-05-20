function varargout = Esoptron(varargin)
% ESOPTRON M-file for Esoptron.fig
%      ESOPTRON, by itself, creates a new ESOPTRON or raises the existing
%      singleton*.
%
%      H = ESOPTRON returns the handle to a new ESOPTRON or the handle to
%      the existing singleton*.
%
%      ESOPTRON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESOPTRON.M with the given input arguments.
%
%      ESOPTRON('Property','Value',...) creates a new ESOPTRON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Esoptron_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Esoptron_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Esoptron

% Last Modified by GUIDE v2.5 03-Jul-2012 08:42:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Esoptron_OpeningFcn, ...
                   'gui_OutputFcn',  @Esoptron_OutputFcn, ...
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


% --- Executes just before Esoptron is made visible.
function Esoptron_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Esoptron (see VARARGIN)

% Choose default command line output for Esoptron
handles.output = hObject;
handles.rootdir='/Users/louk/BCI_code/toolboxes/ls_bci/Esoptron/';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Esoptron wait for user response (see UIRESUME)
% uiwait(handles.Esoptron);


% --- Outputs from this function are returned to the command line.
function varargout = Esoptron_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.subject_path = uigetdir;
temp=find(handles.subject_path=='/');
handles.subject_name=handles.subject_path(temp(end)+1:end);
set(handles.subject_name_stext,'String',handles.subject_name);

handles.bdf_files=rdir(strcat(handles.subject_path,'/**/*.bdf'));

% handles.xls=rdir(strcat(handles.subject_path,'/**/*.xls'));
 for i=1:length(handles.bdf_files)
     temp2=handles.bdf_files(i).name;
     temp3=find(temp2=='/');
     temp4{i}=temp2(temp3(end)+1:end);
 end
set(handles.bdf_files_listbox,'String',temp4);

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


% --- Executes on selection change in bdf_files_listbox.
function bdf_files_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to bdf_files_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bdf_files_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bdf_files_listbox

load cfg;
cfg.dataset=handles.bdf_files(get(handles.bdf_files_listbox,'Value')).name;
temp_cfg=ft_definetrial(cfg);
temp2=struct2cell(temp_cfg.event);
temp3=unique(cell2mat(temp2(3,:,:)));
set(handles.bdf_markers_listbox,'String',temp3);


% --- Executes on selection change in bdf_markers_listbox.
function bdf_markers_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to bdf_markers_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bdf_markers_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bdf_markers_listbox


% --- Executes during object creation, after setting all properties.
function bdf_markers_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bdf_markers_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in extract_button.
function extract_button_Callback(hObject, eventdata, handles)
% hObject    handle to extract_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose('all');
marker=get(handles.selected_markers_etext,'String');
load ~/BCI_code/toolboxes/ls_bci/Esoptron/default_cfg;
paths=struct2cell(handles.bdf_files);
paths=paths(1,:);
handles.S = Subject( handles.subject_name, handles.subject_path, paths, str2num(marker), cfg);
temp5=dir(strcat(handles.subject_path,'/ls_bci/default/*.mat'));
temp6=struct2cell(temp5);
temp6=temp6(1,:);
set(handles.sliced_markers_listbox,'String',temp6);
members=properties(handles.S);
set(handles.loaded_data_listbox,'String',members);
guidata(hObject, handles);
% cfg.channel= {'Fp1','AF3','F7','F3','FC1','FC5','T7','C3','CP1','CP5','P7','P3','Pz','PO3','O1','Oz','O2','PO4'...
%     ,'P4','P8','CP6','CP2','C4','T8','FC6','FC2','F4','F8','AF4','Fp2','Fz','Cz'};
% avalldata=ft_timelockanalysis(cfg,alldata);
% figure,ft_singleplotER([],avalldata);
% title(handles.subject_name);xlabel('time (seconds)');ylabel('amplitude (mV)');
% here=pwd;
% cd(handles.subject_path);
% saveas(gcf,strcat('marker',marker),'jpg');
% cd(here);


function selected_markers_etext_Callback(hObject, eventdata, handles)
% hObject    handle to selected_markers_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_markers_etext as text
%        str2double(get(hObject,'String')) returns contents of selected_markers_etext as a double


% --- Executes during object creation, after setting all properties.
function selected_markers_etext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selected_markers_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sliced_markers_listbox.
function sliced_markers_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to sliced_markers_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sliced_markers_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sliced_markers_listbox


% --- Executes during object creation, after setting all properties.
function sliced_markers_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliced_markers_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in loaded_data_listbox.
function loaded_data_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to loaded_data_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns loaded_data_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loaded_data_listbox


% --- Executes during object creation, after setting all properties.
function loaded_data_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loaded_data_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_marker_button.
function plot_marker_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_marker_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx_selected = get(handles.loaded_data_listbox,'Value');
members = properties(handles.S);
handles.S.(members{idx_selected}).plot('avg','save');



function cfg_name_etext_Callback(hObject, eventdata, handles)
% hObject    handle to cfg_name_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cfg_name_etext as text
%        str2double(get(hObject,'String')) returns contents of cfg_name_etext as a double


% --- Executes during object creation, after setting all properties.
function cfg_name_etext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cfg_name_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function eventtype_stext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventtype_stext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function poststim_etext_Callback(hObject, eventdata, handles)
% hObject    handle to poststim_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of poststim_etext as text
%        str2double(get(hObject,'String')) returns contents of poststim_etext as a double


% --- Executes during object creation, after setting all properties.
function poststim_etext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poststim_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prestim_etext_Callback(hObject, eventdata, handles)
% hObject    handle to prestim_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prestim_etext as text
%        str2double(get(hObject,'String')) returns contents of prestim_etext as a double


% --- Executes during object creation, after setting all properties.
function prestim_etext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prestim_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eventtype_etext_Callback(hObject, eventdata, handles)
% hObject    handle to eventtype_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eventtype_etext as text
%        str2double(get(hObject,'String')) returns contents of eventtype_etext as a double


% --- Executes during object creation, after setting all properties.
function eventtype_etext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventtype_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotall_button.
function plotall_button_Callback(hObject, eventdata, handles)
% hObject    handle to plotall_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name=handles.subject_name;
figure,handles.S.plot('single',name);
if (exist(strcat(name,'.jpg'),'file'))
    saveas(gcf,strcat(name,'-2'),'jpg');
else
saveas(gcf,name,'jpg')
end
