function varargout = DEMO_SHOWCASE(varargin)
% DEMO_SHOWCASE MATLAB code for DEMO_SHOWCASE.fig
%      DEMO_SHOWCASE, by itself, creates a new DEMO_SHOWCASE or raises the existing
%      singleton*.
%
%      H = DEMO_SHOWCASE returns the handle to a new DEMO_SHOWCASE or the handle to
%      the existing singleton*.
%
%      DEMO_SHOWCASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_SHOWCASE.M with the given input arguments.
%
%      DEMO_SHOWCASE('Property','Value',...) creates a new DEMO_SHOWCASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DEMO_SHOWCASE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DEMO_SHOWCASE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DEMO_SHOWCASE

% Last Modified by GUIDE v2.5 15-Jan-2018 19:06:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DEMO_SHOWCASE_OpeningFcn, ...
                   'gui_OutputFcn',  @DEMO_SHOWCASE_OutputFcn, ...
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


% --- Executes just before DEMO_SHOWCASE is made visible.
function DEMO_SHOWCASE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DEMO_SHOWCASE (see VARARGIN)

% Choose default command line output for DEMO_SHOWCASE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DEMO_SHOWCASE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DEMO_SHOWCASE_OutputFcn(hObject, eventdata, handles) 
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

cfg.Pt=str2num(handles.txpower.String);
cfg.Num_sensors=str2num(handles.sensors.String)
cfg.N_monte=str2num(handles.monte.String);
cfg.filename=handles.filename.String;
cfg.Type_Scenario=1;%str2num(handles.scenario.String);
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
if cfg.Type_Scenario==1
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

cfg.snrfolder='C:\masnet\';
MASNET_SNR(cfg)
fl = [ cfg.snrfolder 'SNR_' cfg.filename '_Time_' num2str(cfg.Time_samples)...
    '_TS_' num2str(cfg.Type_Scenario)...
    '_TE_' num2str(cfg.Type_Environment)...
    '_Num_Sensors_' num2str(cfg.Num_sensors)...
    '_Pt_' num2str(cfg.Pt)...
    'dBW_sigma_' num2str(cfg.sigm) 'dB.mat'];
if handles.protocol.Value==1
    metrics_OFDM(fl)
elseif handles.protocol.Value==2
    metrics_NOCP(fl)
end

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
handles.FileName=FileName;
handles.PathName=PathName;
handles.fname.String=[FileName];
guidata(hObject,handles)
    

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


% --- Executes on selection change in plottype.
function plottype_Callback(hObject, eventdata, handles)
% hObject    handle to plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plottype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plottype


% --- Executes during object creation, after setting all properties.
function plottype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.plottype.Value==1
    FileName=handles.FileName;
    PathName=handles.PathName;
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
  %  set(gca,'Xtick',0:8:(nsens+1))
  %  set(gca,'XtickLabel',(0:8:(nsens+1))*ff)
    set(gca,'Ytick',0:0.1:1)
    set(gca,'YtickLabel',(0:.1:1))
    xlabel('Number of Sensors'), ylabel('Probability of detection')
    pt=strfind(FileName,'Pt');pt=FileName(pt+4:pt+5);
    ts=strfind(FileName,'TS');ts=FileName(ts+3);
    title(['Pt:-' num2str(pt) ' dbW - ' 'Scenario: ' num2str(ts) ])
    legend({ 'best1' 'fusion' 'optimal'},'Location','SouthEast')
    legend boxoff
elseif handles.plottype.Value==2
    FileName=handles.FileName;
    PathName=handles.PathName;
    load(fullfile(PathName,FileName))
    pfa=0.01:0.01:0.1;
    nsens=size(pbsens_av,1);
    pt=strfind(FileName,'Pt');pt=FileName(pt+4:pt+5);
    ts=strfind(FileName,'TS');ts=FileName(ts+3);
    axes(handles.axes1)
    cla
    hold on
    for i=1:nsens
        h(i)=plot(pfa,pbsens_av(i,:))
    end
    xlim([0.01 0.1])
    xlabel('Probability of false alarm')
    ylabel('Probability of detection')
    title(['ROC:-' num2str(pt) ' dbW - ' 'Scenario: ' num2str(ts) ])
    legend([h(1) h(2) h(3)],{'1 sensor' '2 sensors' '...'},'Location','southeast')
    legend boxoff
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on selection change in protocol.
function protocol_Callback(hObject, eventdata, handles)
% hObject    handle to protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns protocol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from protocol


% --- Executes during object creation, after setting all properties.
function protocol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
