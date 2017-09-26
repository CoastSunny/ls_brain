function varargout = demo(varargin)
% DEMO MATLAB code for demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO.M with the given input arguments.
%
%      DEMO('Property','Value',...) creates a new DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo

% Last Modified by GUIDE v2.5 26-Sep-2017 07:00:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
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


% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cfg.Pt=str2num(handles.txpower.String)
cfg.Num_sensors=str2num(handles.sensors.String)
cfg.N_monte=str2num(handles.monte.String);
cfg.filename=handles.filename.String;
cfg.Type_Scenario=str2num(handles.scenario.String);
cfg.Type_Environment=str2num(handles.env.String);
cfg.NF=str2num(handles.nf.String);
cfg.sigm=str2num(handles.shadowing.String);

cfg.Time_samples=1;
cfg.Fc=2.4e9;
cfg.Size_Scenario=2000;
cfg.Size_EZ_x=200;
cfg.Size_EZ_y=200;
cfg.Size_FZ1_x=200;
cfg.Size_FZ1_y=2000;
cfg.Size_FZ2_x=1800;
cfg.Size_FZ2_y=200;
cfg.Sep_sensors=500;
cfg.hs=1.5;
cfg.ht=3;
cfg.Vel_sensors=0.01;
cfg.Vel_target=0.01;
cfg.dist=0.0625;
cfg.NAz=120;
cfg.Antenna_slant=0;
cfg.Sample_Density=64;
cfg.Fs=30.72e6;
if cfg.Type_Scenario==0
    cfg.Int_target_x=500;
    cfg.Int_target_y=500;
else
    cfg.Int_target_x=50;
    cfg.Int_target_y=50;
end
cfg.n=3;
cfg.d_0=200;
cfg.BW=20e6;

cfg.Tc=144;
cfg.Td=2048;
cfg.AC_sample=6;
cfg.Pfa=0.1;

cfg.snrfolder='~/Documents/projects/ls_brain/results/masnet/snr/';
ls_SNR_generation(cfg)
fl=[cfg.snrfolder cfg.filename '_Time_' num2str(Time_samples)...
    '_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment)...
    '_Num_Sensors_' num2str(Num_sensors) '_SepTar_' num2str(Int_target_x)...
    '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigm) 'dB.mat'];
ls_sensor_numbers(fl)

function sensors_Callback(hObject, eventdata, handles)
% hObject    handle to sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensors as text
%        str2double(get(hObject,'String')) returns contents of sensors as a double


% --- Executes during object creation, after setting all properties.
function sensors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txpower_Callback(hObject, eventdata, handles)
% hObject    handle to txpower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txpower as text
%        str2double(get(hObject,'String')) returns contents of txpower as a double


% --- Executes during object creation, after setting all properties.
function txpower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txpower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monte_Callback(hObject, eventdata, handles)
% hObject    handle to monte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monte as text
%        str2double(get(hObject,'String')) returns contents of monte as a double


% --- Executes during object creation, after setting all properties.
function monte_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monte (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
snrfolder='~/Documents/projects/ls_brain/results/masnet/probs/';
[FileName,PathName] = uigetfile([snrfolder '*.mat'],'Select the simulation output file');
load(fullfile(PathName,FileName))
idx=1;
ff=1;
nsens=size(pbsens_av,1);
sens=(1:nsens);
axes(handles.axes1)
cla
hold on
% errorbar(sens,pall_av(:,idx),pall_std(:,idx),'b')
% plot(sens,pall_av(:,idx),'b')
if handles.errorbars.Value==1
    errorbar(sens,pbsens_av(:,idx),pbsens_std(:,idx),'r')
    errorbar(sens,pmean_av(:,idx),pmean_std(:,idx),'m')
    errorbar(sens,psum_av(:,idx),psum_std(:,idx),'g')
else
    plot(sens,pbsens_av(:,idx),'r')
    plot(sens,pmean_av(:,idx),'m')
    plot(sens,psum_av(:,idx),'g')
end
xlim([1 nsens])
ylim([0 1.2])
set(gca,'Xtick',0:8:(nsens+1))
set(gca,'XtickLabel',(0:8:(nsens+1))*ff)
set(gca,'Ytick',0:0.1:1)
set(gca,'YtickLabel',(0:.1:1))
xlabel('Number of Sensors'), ylabel('Probability of detection')
pt=strfind(FileName,'Pt');pt=FileName(pt+4:pt+5);
ts=strfind(FileName,'TS');ts=FileName(ts+3);
title(['Pt:-' num2str(pt) ' dbW - ' 'Scenario: ' num2str(ts) ])
legend({ 'best1' 'fusion' 'optimal'},'Location','NorthWest')
legend boxoff 

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function scenario_Callback(hObject, eventdata, handles)
% hObject    handle to scenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scenario as text
%        str2double(get(hObject,'String')) returns contents of scenario as a double


% --- Executes during object creation, after setting all properties.
function scenario_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scenario (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function env_Callback(hObject, eventdata, handles)
% hObject    handle to env (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of env as text
%        str2double(get(hObject,'String')) returns contents of env as a double


% --- Executes during object creation, after setting all properties.
function env_CreateFcn(hObject, eventdata, handles)
% hObject    handle to env (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nf_Callback(hObject, eventdata, handles)
% hObject    handle to nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nf as text
%        str2double(get(hObject,'String')) returns contents of nf as a double


% --- Executes during object creation, after setting all properties.
function nf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function shadowing_Callback(hObject, eventdata, handles)
% hObject    handle to shadowing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shadowing as text
%        str2double(get(hObject,'String')) returns contents of shadowing as a double


% --- Executes during object creation, after setting all properties.
function shadowing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shadowing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in errorbars.
function errorbars_Callback(hObject, eventdata, handles)
% hObject    handle to errorbars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of errorbars
