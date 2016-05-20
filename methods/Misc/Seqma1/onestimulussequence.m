function varargout = onestimulussequence(varargin)
% ONESTIMULUSSEQUENCE M-file for onestimulussequence.fig
%
% ONESTIMULUSSEQUENCE is a graphical user interface for creating an
% alternating sequence file.


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @onestimulussequence_OpeningFcn, ...
                   'gui_OutputFcn',  @onestimulussequence_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before onestimulussequence is made visible.
function onestimulussequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to onestimulussequence (see VARARGIN)

% Choose default command line output for onestimulussequence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes onestimulussequence wait for user response (see UIRESUME)
% uiwait(handles.onestimulussequence);

% The program begins in state 1:
handles.state = 1;
show_state1(handles);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = onestimulussequence_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in nextbutton.
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.state
  
 case 1
  show_state2(handles);
  handles.state = 2;
  
 case 2
  code = str2num(get(handles.stimcode,'String'));
  soa = str2double(get(handles.soa,'String'));
  numofstim = str2double(get(handles.numofstim,'String'));
  file = get(handles.stimfilename,'String');
  seqfile = get(handles.seqfilename,'String');

  program = get_format(handles);
  onestimulus(code, soa, numofstim, file, seqfile, program);
  show_state3(handles);
  handles.state = 3;
  
end
guidata(hObject, handles);

% --- Executes on button press in backbutton.
function backbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.state == 1)
  seqma;
  close(onestimulussequence);
else
  handles.state = 1;
  show_state1(handles);
  guidata(hObject, handles);
end

% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(onestimulussequence);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(onestimulussequence);


% --- Executes during object creation, after setting all properties.
function soa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function soa_Callback(hObject, eventdata, handles)
% hObject    handle to soa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of soa as text
%        str2double(get(hObject,'String')) returns contents of soa as a double


% --- Executes during object creation, after setting all properties.
function numofstim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function numofstim_Callback(hObject, eventdata, handles)
% hObject    handle to numofstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofstim as text
%        str2double(get(hObject,'String')) returns contents of numofstim as a double


% --- Executes during object creation, after setting all properties.
function stimcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stimcode_Callback(hObject, eventdata, handles)
% hObject    handle to stimcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimcode as text
%        str2double(get(hObject,'String')) returns contents of stimcode as a double




% --- Executes during object creation, after setting all properties.
function stim2code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim2code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim2code_Callback(hObject, eventdata, handles)
% hObject    handle to stim2code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim2code as text
%        str2double(get(hObject,'String')) returns contents of stim2code as a double


% --- Executes during object creation, after setting all properties.
function stimfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stimfilename_Callback(hObject, eventdata, handles)
% hObject    handle to stimfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimfilename as text
%        str2double(get(hObject,'String')) returns contents of stimfilename as a double

% --- Executes during object creation, after setting all properties.
function stim2filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim2filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim2filename_Callback(hObject, eventdata, handles)
% hObject    handle to stim2filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim2filename as text
%        str2double(get(hObject,'String')) returns contents of stim2filename as a double


% --- Executes during object creation, after setting all properties.
function seqfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function seqfilename_Callback(hObject, eventdata, handles)
% hObject    handle to seqfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqfilename as text
%        str2double(get(hObject,'String')) returns contents of seqfilename as a double



function stimradio_Callback(hObject, eventdata, handles)
% hObject    handle to stimradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimradio

off = [handles.brainstimradio,handles.presentationradio,handles.ptbradio];
mutual_exclude(off);

% --- Executes on button press in brainstimradio.
function brainstimradio_Callback(hObject, eventdata, handles)
% hObject    handle to brainstimradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of brainstimradio

off = [handles.stimradio,handles.presentationradio,handles.ptbradio];
mutual_exclude(off);

% --- Executes on button press in presentationradio.
function presentationradio_Callback(hObject, eventdata, handles)
% hObject    handle to presentationradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of presentationradio

off = [handles.stimradio,handles.brainstimradio,handles.ptbradio];
mutual_exclude(off);

% --- Executes on button press in ptbradio.
function ptbradio_Callback(hObject, eventdata, handles)
% hObject    handle to ptbradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of presentationradio

off = [handles.stimradio,handles.brainstimradio,handles.presentationradio];
mutual_exclude(off);


% --- Shows GUI State 1 components (and hides others):
function show_state1(handles)
% handles    structure with handles and user data (see GUIDATA)

set(handles.soatag,'Visible','on');
set(handles.soa,'Visible','on');
set(handles.numofstimtag,'Visible','on');
set(handles.numofstim,'Visible','on');
set(handles.stimcodetag,'Visible','on');
set(handles.stimcode,'Visible','on');

set(handles.stimfilenametag,'Visible','off');
set(handles.stimfilename,'Visible','off');
set(handles.formattag,'Visible','off');
set(handles.formatframe,'Visible','off');
set(handles.stimradio,'Visible','off');
set(handles.brainstimradio,'Visible','off');
set(handles.presentationradio,'Visible','off');
set(handles.ptbradio,'Visible','off');
set(handles.closebutton,'Visible','off');
set(handles.seqfilenametag,'Visible','off');
set(handles.seqfilename,'Visible','off');
set(handles.finishedtag,'Visible','off');


% --- Shows GUI State 2 components (and hides others):
function show_state2(handles)
% handles    structure with handles and user data (see GUIDATA)

set(handles.stimfilenametag,'Visible','on');
set(handles.stimfilename,'Visible','on');
set(handles.formatframe,'Visible','on');
set(handles.formattag,'Visible','on');
set(handles.stimradio,'Visible','on');
set(handles.brainstimradio,'Visible','on');
set(handles.presentationradio,'Visible','on');
set(handles.ptbradio,'Visible','on');
set(handles.cancelbutton,'Visible','on');
set(handles.seqfilenametag,'Visible','on');
set(handles.seqfilename,'Visible','on');

set(handles.closebutton,'Visible','off');
set(handles.soatag,'Visible','off');
set(handles.soa,'Visible','off');
set(handles.numofstimtag,'Visible','off');
set(handles.numofstim,'Visible','off');
set(handles.stimcodetag,'Visible','off');
set(handles.stimcode,'Visible','off');
set(handles.finishedtag,'Visible','off');


% --- Shows GUI State 3 components (and hides others):
function show_state3(handles)
% handles    structure with handles and user data (see GUIDATA)

set(handles.closebutton,'Visible','on');
set(handles.finishedtag,'Visible','on');

set(handles.stimfilenametag,'Visible','off');
set(handles.stimfilename,'Visible','off');
set(handles.formatframe,'Visible','off');
set(handles.formattag,'Visible','off');
set(handles.stimradio,'Visible','off');
set(handles.brainstimradio,'Visible','off');
set(handles.presentationradio,'Visible','off');
set(handles.ptbradio,'Visible','off');
set(handles.backbutton,'Visible','off');
set(handles.nextbutton,'Visible','off');
set(handles.cancelbutton,'Visible','off');
set(handles.soatag,'Visible','off');
set(handles.soa,'Visible','off');
set(handles.numofstimtag,'Visible','off');
set(handles.numofstim,'Visible','off');
set(handles.stimcodetag,'Visible','off');
set(handles.stimcode,'Visible','off');
set(handles.seqfilenametag,'Visible','off');
set(handles.seqfilename,'Visible','off');


% --- Sets the radio buttons given as a parameter off.
function mutual_exclude(off)
set(off,'Value',0)


% --- Returns the number of the programs the radio button of which
% is set.
function program = get_format(handles)

program = 1;
if (get(handles.stimradio,'Value') == 1)
  program = 1;
else
  if (get(handles.brainstimradio,'Value') == 1)
    program = 2;
  else
    if (get(handles.presentationradio,'Value') == 1)
      program = 3;
    else 
      if (get(handles.ptbradio,'Value') == 1)
        program = 4;      
      end
    end
  end
end





