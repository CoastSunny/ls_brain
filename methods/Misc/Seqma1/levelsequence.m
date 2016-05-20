function varargout = levelsequence(varargin)
% LEVELSEQUENCE M-file for levelsequence.fig
%
% LEVELSEQUENCE is a graphical user interface for creating a
% sequence file using the Oddball paradigm.


% Last Modified by GUIDE v2.5 22-Nov-2007 19:02:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @levelsequence_OpeningFcn, ...
                   'gui_OutputFcn',  @levelsequence_OutputFcn, ...
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

% --- Executes just before levelsequence is made visible.
function levelsequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to levelsequence (see VARARGIN)

% Choose default command line output for levelsequence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% The unnecessary graphical components are hidden in the beginning.
hide_state2(handles);
hide_state21(handles);
hide_state3(handles);
hide_state4(handles);

%% POSSIBLE STATES OF THE GUI:
% 1  is for options
% 2 is for defining deviant types
% 21 is for defining trigger codes
% 3 is for program format and sequence file name settings.
% 4 is for finished state (some statistics are shown).

% The simple options are shown in the beginning.
handles.state = 1;
handles.previous_state = 1;

% The default values for options:
%% Minimum SOA
handles.soaminvalue = 1.0;
%% Maximum SOA
handles.soamaxvalue = 1.0;
%% Number of different standard stimuli
handles.numofstdvalue = 1;
%% Number of different deviant stimuli
handles.numofdevvalue = 1;
%% Total number of stimuli wanted
handles.totalstimvalue = 200;

handles.devtypes = {};
handles.numofdevtypes = 1;
handles.levels = [];
handles.codes = [];
handles.defaultcodes = [];
handles.numofcodes = 1;
handles.devtype = 1;
handles.levelcounter = 1;

show_state1(handles);
guidata(hObject, handles);

% UIWAIT makes levelsequence wait for user response (see UIRESUME)
% uiwait(handles.levelsequence);


% --- Outputs from this function are returned to the command line.
function varargout = levelsequence_OutputFcn(hObject, eventdata, handles)
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
        hide_state1(handles);

        handles.previous_state = handles.state;
        handles.state = 2;

        totalstim = 1 + str2num(get(handles.numofdev,'String'));
        if isempty(handles.codes)
            for i = 1:totalstim
                handles.codes(i) = i;
            end
        end

        set (handles.stimulustag,'String','Standard 1');
        show_state2(handles);
        guidata(hObject, handles);

case 2

    % If user has input all the deviant types, the new state is 21.

    %% STATE 2 -> STATE 21
    if (handles.numofdevtypes == str2double(get(handles.numofdev,'String')))
        if (isempty(handles.devtypes) | ...
                length(handles.devtypes) < handles.numofdevtypes)
            devtype = ['dev', num2str(handles.numofdevtypes), '-'];
            handles.devtypes{handles.numofdevtypes} = devtype;
            set(handles.stimulus,'String',devtype);
        end
        if (isempty(handles.levels) | ...
                length(handles.levels) < handles.numofdevtypes)
            % If the number of levels has not been given, it is set to 1.
            handles.levels(handles.numofdevtypes) = 1;
            set(handles.numoflevels,'String','1');
        end            
        
        % Default triggercodes are created (in case the user des not want
        % to determine the codes herself).
        defaultcodes = zeros(max(handles.levels), ...
            str2double(get(handles.numofdev,'String')));
        numofelements = size(defaultcodes,1)*size(defaultcodes,2);
        defaultcodes(1:numofelements) = 1:1:numofelements;
        defaultcodes = defaultcodes + 1;
        handles.defaultcodes = defaultcodes';
        
        % The original codes are set to -1 so that they can be separated 
        % from those that the user has set.
        handles.codes = ones(str2double(get(handles.numofdev,'String')), ...
            max(handles.levels));
        handles.codes = handles.codes * (-1);
        
        handles.previous_state = handles.state;
        handles.state = 21;
        hide_state2(handles);
        show_state21(handles);
    else

        %% DEVTYPE++

        % If the user did not input a deviant type name, it is given name
        % "devX-", where X is the number of order of the deviant type.
        if (isempty(handles.devtypes) | length(handles.devtypes) < ...
                handles.numofdevtypes)
            devtype = ['dev', num2str(handles.numofdevtypes), '-'];
            handles.devtypes{handles.numofdevtypes} = devtype;
        end

        if (isempty(handles.levels) | length(handles.levels) < ...
                handles.numofdevtypes)
            handles.levels(handles.numofdevtypes) = 1;
        end
        
        handles.numofdevtypes = handles.numofdevtypes + 1;
        set(handles.stimulustag,'String',['Deviant type '...
            num2str(handles.numofdevtypes) ' (e.g. "freq")']);

        % The text field "Stimulus" is either emptied or set to a value
        % that was given earlier (before going back).
        if ~(isempty(handles.devtypes))
            if (length(handles.devtypes) >= handles.numofdevtypes)
                set(handles.stimulus,'String', ...
                    handles.devtypes{handles.numofdevtypes});
            else
                set(handles.stimulus,'String',[]);
            end
        else
            set(handles.stimulus,'String',[]);
        end
        
        % Same with the number of levels field:
        if ~(isempty(handles.levels))
            if (length(handles.levels) >= handles.numofdevtypes)
                set(handles.numoflevels,'String', ...
                    handles.levels(handles.numofdevtypes));
            else
                set(handles.numoflevels,'String',[]);
            end
        end
    end

case 21
    
    % STATE 21 -> STATE 3
    if (handles.devtype == str2double(get(handles.numofdev,'String')) & ...
        handles.levelcounter == handles.levels(handles.devtype))
        if (isempty(get(handles.code,'String')) | ...
            handles.codes(handles.devtype, handles.levelcounter) == -1)
            handles.codes(handles.devtype, handles.levelcounter) = ...
            handles.defaultcodes(handles.devtype, handles.levelcounter);
        end
        handles.previous_state = handles.state;
        handles.state = 3;
        hide_state21(handles);
        show_state3(handles);
        
    % NEXT CODE    
    else
        if (isempty(get(handles.code,'String')) | ...
            handles.codes(handles.devtype, handles.levelcounter) == -1)
            handles.codes(handles.devtype, handles.levelcounter) = ...
            handles.defaultcodes(handles.devtype, handles.levelcounter);
        end
        if (handles.levelcounter == handles.levels(handles.devtype))
            handles.devtype = handles.devtype + 1;
            handles.levelcounter = 0;
        end
        
        handles.levelcounter = handles.levelcounter + 1;
        set(handles.codetag,'String',['Code for stimulus: ' ...
            handles.devtypes{handles.devtype} num2str(handles.levelcounter)]);
        
        if handles.codes(handles.devtype, handles.levelcounter) ~= -1
            set(handles.code,'String',num2str(handles.codes(handles.devtype, ...
                handles.levelcounter)));
        else
            set(handles.code,'String',[]);
        end
    end
end

guidata(hObject, handles);

% --- Executes on button press in backbutton.
function backbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.state
  
 case 1
  seqma;
  close(handles.levelsequence);
  
 case 2
  if (handles.numofdevtypes == 1)
      hide_state2(handles);
      show_state1(handles);
      handles.state = 1;
      handles.previous_state = 0;

  else
      handles.numofdevtypes = handles.numofdevtypes - 1;
      set(handles.stimulustag,'String',['Deviant type '...
          num2str(handles.numofdevtypes) ' (e.g. "freq")']);
      set(handles.stimulus,'String', ...
          handles.devtypes{handles.numofdevtypes});
      set(handles.numoflevels,'String',...
          num2str(handles.levels(handles.numofdevtypes)));

  end
  

  guidata(hObject, handles);
  
 case 21
    % STATE 21 -> STATE 2
  if handles.levelcounter == 1 & handles.devtype == 1
      hide_state21(handles);
      show_state2(handles);
      handles.state = 2;
      handles.previous_state = 1;
      
  else % PREVIOUS CODE
      if handles.levelcounter == 1
          handles.devtype = handles.devtype - 1;
          handles.levelcounter = handles.levels(handles.devtype);
          set(handles.codetag,'String',['Code for stimulus: ' ...
              handles.devtypes{handles.devtype} num2str(handles.levelcounter)]);
      else
          handles.levelcounter = handles.levelcounter - 1;
          set(handles.codetag,'String',['Code for stimulus: ' ...
              handles.devtypes{handles.devtype} num2str(handles.levelcounter)]);
      end
      set(handles.code,'String',num2str(handles.codes(handles.devtype, ...
          handles.levelcounter)));
  end
  guidata(hObject, handles);

 case 3
  hide_state3(handles);
  handles.state = 21;
  handles.previous_state = 2;
  show_state21(handles);

  guidata(hObject, handles);
end




% --- Executes on button press in finishbutton.
function finishbutton_Callback(hObject, eventdata, handles)
% hObject    handle to finishbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.titletag,'String','Creating the sequence...');
set(handles.titletag,'Visible','on');

numofseqfiles = str2double(get(handles.numofseqfiles,'String'));

hide_program_selection(handles);

% The default filename:

if ~(isfield(handles,'filenamevalue'))
  handles.filenamevalue = 'optseq';
end

% The stimulus file names are generated so that the name will be
% DevtypeX, where "Devtype" is the name of the deviant type and
% X the number of level.
stimuli = {};
for i = 1:length(handles.devtypes)
    levelstimuli = {};
    for j = 1:handles.levels(i)
        levelstimuli{j} = [handles.devtypes{i} num2str(j)];
    end
    stimuli{i} = levelstimuli;
end
stimuli = [{'std'} stimuli];

stdmin = str2double(get(handles.minstdbetdev,'String'));
stdmax = str2double(get(handles.maxstdbetdev,'String'));

% soa = [handles.soaminvalue handles.soamaxvalue];

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


guidata(hObject,handles);

%h = waitbar(0,'Creating the sequence...');

if (numofseqfiles == 1)

  % Settings are written to an ascii file <filename>.txt
  options_string = get_options(handles);
  file_out = [handles.filenamevalue, '.txt'];
  fid = fopen(lower([cd,file_out]),'wt');
  fprintf(fid,options_string);
  fclose(fid);

  % Sequence is created.
  result = optimumlevel(stimuli, handles.soaminvalue, handles.soamaxvalue, stdmin, stdmax, ...
    handles.totalstimvalue, handles.filenamevalue, handles.codes, program);

else
  
  result = [];
  for seqfile = 1:numofseqfiles
    
    filename = [handles.filenamevalue, num2str(seqfile)];
    % Settings are written to an ascii file <filename>.txt
    options_string = get_options(handles);
    file_out = [filename, '.txt'];
    fid = fopen(lower([cd,file_out]),'wt');
    fprintf(fid,options_string);
    fclose(fid);
    
    % Sequence is created.
        result = strvcat(result, optimumlevel(stimuli, handles.soaminvalue, handles.soamaxvalue, stdmin, ...
         stdmax, handles.totalstimvalue, filename, handles.codes, program));
  end
end

%close(h);   % Close wait bar
set(handles.titletag,'String','Sequence(s) created');
set(handles.stimulustag,'String',strvcat('File(s) created:', result));

handles.previous_state = handles.state;
handles.state = 4;
show_state4(handles);
guidata(hObject, handles);



% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.levelsequence);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.levelsequence);


% --- Executes during object creation, after setting all properties.
function soamin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soamin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function soamin_Callback(hObject, eventdata, handles)
% hObject    handle to soamin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of soamin as text
%        str2double(get(hObject,'String')) returns contents of soamin as a double

handles.soaminvalue = str2double(get(hObject,'string'));
if isnan(handles.soaminvalue)
    errordlg('You must enter a numeric value','Bad Input','modal')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function soamax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soamax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function soamax_Callback(hObject, eventdata, handles)
% hObject    handle to soamax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of soamax as text
%        str2double(get(hObject,'String')) returns contents of soamax as a double

handles.soamaxvalue = str2double(get(hObject,'string'));
if isnan(handles.soamaxvalue)
    errordlg('You must enter a numeric value','Bad Input','modal')
end
guidata(hObject, handles);



% --- Executes on button press in stimradio.
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


% --- Shows the program selection.
function show_program_selection(handles)
set(handles.stimradio,'Visible','on');
set(handles.brainstimradio,'Visible','on');
set(handles.presentationradio,'Visible','on');
set(handles.ptbradio,'Visible','on');
set(handles.filenametag,'Visible','on');
set(handles.filename,'Visible','on');
set(handles.finishbutton,'Visible','on');
set(handles.nextbutton,'Visible','off');
set(handles.programframe,'Visible','on');
set(handles.manypanel,'Visible','on');
set(handles.manybox,'Visible','on');
set(handles.numofseqfilestag,'Visible','on');
set(handles.numofseqfiles,'Visible','on');
set(handles.numofseqfiles,'Enable','off');
set(handles.manybox,'Value',0);


% --- Hides the program selection.
function hide_program_selection(handles)
set(handles.stimradio,'Visible','off');
set(handles.brainstimradio,'Visible','off');
set(handles.presentationradio,'Visible','off');
set(handles.ptbradio,'Visible','off');
set(handles.filenametag,'Visible','off');
set(handles.filename,'Visible','off');
set(handles.finishbutton,'Visible','off');
set(handles.nextbutton,'Visible','on');
set(handles.programframe,'Visible','off');
set(handles.manybox,'Visible','off');
set(handles.manypanel,'Visible','off');
set(handles.numofseqfilestag,'Visible','off');
set(handles.numofseqfiles,'Visible','off');


% --- Shows the finished state components.
function show_finished(handles)



% --- Shows GUI components of state 1
function show_state1(handles)

set(handles.numofdevtag,'String','Number of deviant types');
set(handles.numofdevtag,'Visible','on');
set(handles.numofdev,'Visible','on');
set(handles.soatag,'Visible','on');
set(handles.soamin,'Visible','on');
set(handles.soamintag,'Visible','on');
set(handles.soamax,'Visible','on');
set(handles.soamaxtag,'Visible','on');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.minstdbetdev,'Visible','on');
set(handles.maxstdbetdev,'Visible','on');
set(handles.mdash,'Visible','on');
set(handles.minstimbetdevtag,'Visible','on');



% --- Hides GUI components of state 1
function hide_state1(handles)
set(handles.soatag,'Visible','off');
set(handles.soamin,'Visible','off');
set(handles.soamintag,'Visible','off');
set(handles.soamax,'Visible','off');
set(handles.soamaxtag,'Visible','off');
set(handles.totalstimtag,'Visible','off');
set(handles.totalstim,'Visible','off');
set(handles.numofdevtag,'Visible','off');
set(handles.numofdev,'Visible','off');
set(handles.minstdbetdev,'Visible','off');
set(handles.maxstdbetdev,'Visible','off');
set(handles.mdash,'Visible','off');
set(handles.minstimbetdevtag,'Visible','off');


% --- Shows GUI components of state 2
function show_state2(handles)
set(handles.stimulustag,'Visible','on');
if (handles.previous_state == 21)
    set(handles.stimulustag,'String',['Deviant type '...
        num2str(get(handles.numofdevtypes,'String')) ' (e.g. "freq")']);
else
    set(handles.stimulustag,'String','Deviant type 1 (e.g. "freq")');
end
set(handles.stimulus,'Visible','on');
set(handles.numoflevels,'Visible','on');
set(handles.numoflevelstag,'Visible','on');


% --- Hides GUI components of state 2
function hide_state2(handles)
set(handles.stimulustag,'Visible','off');
set(handles.stimulus,'Visible','off');
set(handles.numoflevels,'Visible','off');
set(handles.numoflevelstag,'Visible','off');


% --- Shows GUI components of state 21
function show_state21(handles)
set(handles.codetag,'String',['Code for stimulus: ' ...
    handles.devtypes{handles.devtype} num2str(handles.levelcounter)]);
set(handles.codetag,'Visible','on');
set(handles.code,'Visible','on');


% --- Hides GUI components of state 21
function hide_state21(handles)
set(handles.codetag,'Visible','off');
set(handles.code,'Visible','off');

% --- Shows GUI components of state 3
function show_state3(handles)
show_program_selection(handles);

% --- Hides GUI components of state 3
function hide_state3(handles)
hide_program_selection(handles);


% --- Shows GUI components of state 4
function show_state4(handles)
set(handles.nextbutton,'Visible','off');
set(handles.backbutton,'Visible','off');
set(handles.cancelbutton,'Visible','off');
set(handles.closebutton,'Visible','on');
set(handles.stimulustag,'Visible','on');

% --- Hide GUI components of state 4
function hide_state4(handles)
set(handles.closebutton,'Visible','off');




% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double

handles.filenamevalue = get(hObject,'string');
guidata(hObject, handles);




% --- Sets the radio buttons given as a parameter off.
function mutual_exclude(off)
set(off,'Value',0)



% --- Executes during object creation, after setting all properties.
function totalstim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function totalstim_Callback(hObject, eventdata, handles)
% hObject    handle to totalstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totalstim as text
%        str2double(get(hObject,'String')) returns contents of totalstim as a double

handles.totalstimvalue = str2double(get(hObject,'String'));
if isnan(handles.totalstimvalue)
    errordlg('You must enter a numeric value','Bad Input','modal')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stimulus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stimulus_Callback(hObject, eventdata, handles)
% hObject    handle to stimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimulus as text
%        str2double(get(hObject,'String')) returns contents of stimulus as a double

handles.devtypes{handles.numofdevtypes} = get(hObject,'String');
guidata(hObject, handles);


function numoflevels_Callback(hObject, eventdata, handles)
% hObject    handle to numoflevels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numoflevels as text
%        str2double(get(hObject,'String')) returns contents of numoflevels as a double
handles.levels(handles.numofdevtypes) = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function numoflevels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numoflevels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function code_Callback(hObject, eventdata, handles)
% hObject    handle to code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of code as text
%        str2double(get(hObject,'String')) returns contents of code as a double

handles.codes(handles.devtype, handles.levelcounter) = str2double(get(hObject,'String'));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function numofdev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function numofdev_Callback(hObject, eventdata, handles)
% hObject    handle to numofdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofdev as text
%        str2double(get(hObject,'String')) returns contents of numofdev as a double


% --- Executes during object creation, after setting all properties.
function maxstdbetdev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxstdbetdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxstdbetdev_Callback(hObject, eventdata, handles)
% hObject    handle to maxstdbetdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxstdbetdev as text
%        str2double(get(hObject,'String')) returns contents of maxstdbetdev as a double


% --- Returns a string containing sequence's settings.
function optstring = get_options(handles)
% handles    structure with handles and user data (see GUIDATA)

opt = 'Optimum SEQUENCE SETTINGS\n\n';

% Total number of stimuli
o1 = 'Total number of deviants: ';
o2 = num2str(handles.totalstimvalue);
opt = cat(2, opt, o1, o2);

% SOA
o1 = '\nMinimum SOA: ';
o2 = num2str(handles.soaminvalue);
opt = cat(2, opt, o1, o2);
o1 = '\nMaximum SOA: ';
o2 = num2str(handles.soamaxvalue);
opt = cat(2, opt, o1, o2);

% Number of standards between deviants:
o1 = '\nMinimum mumber of standards between deviants: ';
o2 = get(handles.minstdbetdev, 'String');
opt = cat(2, opt, o1, o2);
o1 = '\nMaximum number of standards between deviants: ';
o2 = get(handles.maxstdbetdev, 'String');
opt = cat(2, opt, o1, o2);



% Number of different standard stimuli:
o1 = '\nNumber of different deviants: ';
o2 = get(handles.numofdev,'String');
opt = cat(2, opt, o1, o2);

% Stimuli:
opt = cat(2, opt, '\n\nSTIMULI:\n');

for i = 1:length(handles.devtypes)
    for j = 1:handles.levels(i)
        o1 = [handles.devtypes{i} num2str(j) '\t' ...
            num2str(handles.codes(i,j)) '\n'];
        opt = cat(2, opt, o1);
    end
end


opt = cat(2, opt, '\n\n---END---');
optstring = opt;


% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web 'http://www.cbru.helsinki.fi/seqma/level.html' -browser





% --- Executes on button press in manybox.
function manybox_Callback(hObject, eventdata, handles)
% hObject    handle to manybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manybox
if (get(hObject,'Value'))
  set(handles.numofseqfiles,'Enable','on');
  set(handles.numofseqfilestag,'Visible','on');
else
  set(handles.numofseqfiles,'Enable','off');
  set(handles.numofseqfiles,'String','1');
end


function numofseqfiles_Callback(hObject, eventdata, handles)
% hObject    handle to numofseqfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofseqfiles as text
%        str2double(get(hObject,'String')) returns contents of numofseqfiles as a double


% --- Executes during object creation, after setting all properties.
function numofseqfiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofseqfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minstdbetdev_Callback(hObject, eventdata, handles)
% hObject    handle to minstdbetdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minstdbetdev as text
%        str2double(get(hObject,'String')) returns contents of minstdbetdev as a double


% --- Executes during object creation, after setting all properties.
function minstdbetdev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minstdbetdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


