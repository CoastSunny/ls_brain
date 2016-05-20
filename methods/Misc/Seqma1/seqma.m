function varargout = seqma(varargin)
%
%      SEQMA is the start of the Sequence Maker program.
%      It asks the user to select the sequence paradigm.
%
% ---------------------------------------------------------------
% Sequence Maker Copyright (C) 2004 Tuomas Teinonen 
%
% The software library is free software; you can redistribute it 
% and/or modify it under the terms of the GNU General Public 
% License as published by the Free Software Foundation; either 
% version 2 of the License, or any later version. 
%
% This program is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
% GNU General Public License for more details.
% ---------------------------------------------------------------

% Last Modified by GUIDE v2.5 11-Apr-2006 15:48:38

%#function oddballsequence, oddball, rovingsequence, roving, alternatingsequence, alternating, onestimulussequence, onestimulus, oddballtrainsequence, oddballtrain, oregsequence, oreg

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seqma_OpeningFcn, ...
                   'gui_OutputFcn',  @seqma_OutputFcn, ...
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


% --- Executes just before seqma is made visible.
function seqma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to seqma (see VARARGIN)

% Choose default command line output for seqma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seqma wait for user response (see UIRESUME)
% uiwait(handles.seqma);


% --- Outputs from this function are returned to the command line.
function varargout = seqma_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in oddballradio.
function oddballradio_Callback(hObject, eventdata, handles)
% hObject    handle to oddballradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of oddballradio

% Mutual exclusion (other buttons are set off).
off = [handles.rovingradio,handles.singleradio, ...
       handles.alternatingradio, handles.otrainradio, ...
       handles.optiradio, handles.levelradio, handles.oregradio];
mutual_exclude(off)

% --- Executes on button press in rovingradio.
function rovingradio_Callback(hObject, eventdata, handles)
% hObject    handle to rovingradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rovingradio

% Mutual exclusion (other buttons are set off).
off = [handles.oddballradio,handles.singleradio, ...
       handles.alternatingradio, handles.otrainradio, ...
       handles.optiradio, handles.levelradio, handles.oregradio];
mutual_exclude(off)


% --- Executes on button press in singleradio.
function singleradio_Callback(hObject, eventdata, handles)
% hObject    handle to singleradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of singleradio

% Mutual exclusion (other buttons are set off).
off = [handles.rovingradio,handles.oddballradio, ...
       handles.alternatingradio, handles.otrainradio, ...
       handles.optiradio, handles.levelradio, handles.oregradio];
mutual_exclude(off)


% --- Executes on button press in alternatingradio.
function alternatingradio_Callback(hObject, eventdata, handles)
% hObject    handle to alternatingradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of alternatingradio

% Mutual exclusion (other buttons are set off).
off = [handles.rovingradio,handles.singleradio, ...
       handles.oddballradio, handles.otrainradio, ...
       handles.optiradio, handles.levelradio, handles.oregradio];
mutual_exclude(off)


% --- Executes on button press in otrainradio.
function otrainradio_Callback(hObject, eventdata, handles)
% hObject    handle to otrainradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of otrainradio
off = [handles.rovingradio,handles.singleradio, ...
       handles.oddballradio, handles.alternatingradio, ...
       handles.optiradio, handles.levelradio, handles.oregradio];
mutual_exclude(off)


% --- Executes on button press in optiradio.
function optiradio_Callback(hObject, eventdata, handles)
% hObject    handle to optiradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of optiradio
off = [handles.oddballradio,handles.rovingradio,handles.singleradio, ...
       handles.alternatingradio, handles.otrainradio, ...
       handles.levelradio, handles.oregradio];
mutual_exclude(off)

% --- Executes on button press in levelradio.
function levelradio_Callback(hObject, eventdata, handles)
% hObject    handle to levelradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

off = [handles.oddballradio,handles.rovingradio,handles.singleradio, ...
       handles.alternatingradio, handles.otrainradio, ...
       handles.optiradio, handles.oregradio];
mutual_exclude(off)

% --- Executes on button press in oregradio.
function oregradio_Callback(hObject, eventdata, handles)
% hObject    handle to oregradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

off = [handles.oddballradio,handles.rovingradio,handles.singleradio, ...
       handles.alternatingradio, handles.otrainradio, ...
       handles.optiradio, handles.levelradio];
mutual_exclude(off)


% --- Executes on button press in nextbutton.
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.oddballradio,'Value'))
  oddballsequence;
else
  if (get(handles.rovingradio,'Value'))
    rovingsequence;
  else
    if (get(handles.alternatingradio,'Value'))
      alternatingsequence;
    else
      if (get(handles.singleradio,'Value'))
	onestimulussequence;
      else
        if (get(handles.otrainradio,'Value'))
            oddballtrainsequence;
        else
          if (get(handles.levelradio,'Value'))
              levelsequence;
          else
            if (get(handles.oregradio,'Value'))
                oregsequence;
            else
              if (get(handles.optiradio,'Value'))
                  optimumsequence;
              else
                oddballsequence;
              end
            end
          end
        end
      end
    end
  end
end

% Paradigm selection window is closed.
close(handles.seqma);

  
% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.seqma);


% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web 'http://www.cbru.helsinki.fi/~teinonen/seqma/start.html' -browser


% --- Sets the radio buttons given as a parameter off.
function mutual_exclude(off)
set(off,'Value',0)




