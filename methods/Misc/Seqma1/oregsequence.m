function varargout = oregsequence(varargin)
% OREGSEQUENCE M-file for oregsequence.fig
%
% OREGSEQUENCE is a graphical user interface for creating a
% sequence file using the Regulated oddball paradigm.


% Last Modified by GUIDE v2.5 22-Nov-2007 19:13:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oregsequence_OpeningFcn, ...
                   'gui_OutputFcn',  @oregsequence_OutputFcn, ...
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

% --- Executes just before oregsequence is made visible.
function oregsequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to oregsequence (see VARARGIN)

% Choose default command line output for oregsequence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% The unnecessary graphical components are hidden in the beginning.
hide_code_selection(handles);
hide_state21(handles);
hide_state22(handles);
hide_state23(handles);
hide_state3(handles);
hide_state4(handles);

%% POSSIBLE STATES OF THE GUI:
% 1  is for options (advanced / simple)
% 21 is for stimulus name and probability settings in simple case.
% 22 is for stimulus name and probability settings in adv. case.
% 23 is for stimuli between stimuli & ignored stimuli settings (adv.)
% 3 is for program format and sequence file name settings.
% 4 is for finished state (some statistics are shown).

% The simple options are shown in the beginning.
handles.state = 1;
handles.previous_state = 1;
handles.advanced = 0;

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
%% Amount of percents remaining to allocate for stimuli
handles.dev_probability_left = 100;
handles.std_probability_left = 100;

handles.stdnames = {};
handles.numofstdnames = 1;
handles.devnames = {};
handles.numofdevnames = 0;
handles.std_probabilities = [];
handles.dev_probabilities = [];
handles.codes = [];
handles.codecounter = 1;

show_state1(handles);
guidata(hObject, handles);

% UIWAIT makes oregsequence wait for user response (see UIRESUME)
% uiwait(handles.oregsequence);


% --- Outputs from this function are returned to the command line.
function varargout = oregsequence_OutputFcn(hObject, eventdata, handles)
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

% LISÄÄ LAITTOMIEN ARVOJEN TARKASTUS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch handles.state
    
 case 1
  hide_state1(handles);

  %% If user has used simple options:
  if ~(handles.advanced)

    hide_options(handles);
    handles.previous_state = handles.state;
    handles.state = 21;
    show_state21(handles);
    guidata(hObject, handles);
  else
    %% If user has used advanced options:
    handles.previous_state = handles.state;
    handles.state = 22;
    
    totalstim = str2num(get(handles.numofstd,'String')) + ...
	str2num(get(handles.numofdev,'String'));
    for i = 1:totalstim
      handles.codes(i) = i;
    end
    
    avprob = tune_std_probability(handles);
    handles.std_probabilities(handles.numofstdnames) = avprob;
    handles.std_probability_left = handles.std_probability_left - avprob;
    
    set (handles.stimulustag,'String','Standard 1');
    show_state22(handles);
    guidata(hObject, handles);
  end

 case 21
  handles.previous_state = handles.state;
  hide_state21(handles);
  handles.state = 3;
  show_state3(handles);
  guidata(hObject, handles);
  
  
 case 22
  
  % If user has input all the stimulus names, the new state is 3.
  % If user has input all the standard stimulus names, the deviant
  % names are asked next.

  if (handles.numofstdnames == 0)
    handles.numofstdnames = 1;
  end
  
  %% DEV -> STATE3
  if (handles.numofdevnames == str2double(get(handles.numofdev,'String')))
    if (isempty(handles.devnames) | ...
	length(handles.devnames) < handles.numofdevnames)
      devname = ['Deviant', num2str(handles.numofdevnames)];
      handles.devnames{handles.numofdevnames} = devname;
      set(handles.stimulus,'String',devname);
    end
    if (isempty(handles.codes) | length(handles.codes) < handles.numofdevnames ...
	+ handles.numofstdnames-1)
      handles.codes(handles.numofstdnames+handles.numofdevnames - ...
		    1) = handles.codecounter;
    end
    handles.previous_state = handles.state;
    handles.state = 23;
    hide_state22(handles);
    show_state23(handles);
  else
    
    %% STD -> DEV
    if (handles.numofstdnames >= str2double(get(handles.numofstd, ...
						'String')))
      if (handles.numofdevnames == 0)
	handles.numofdevnames = handles.numofdevnames + 1;
	
	avprob = tune_dev_probability(handles);
	handles.dev_probabilities(handles.numofdevnames) = avprob;
	handles.dev_probability_left = handles.dev_probability_left - avprob;
	
	if (isempty(handles.stdnames) | length(handles.stdnames) < ...
					       handles ...
					       .numofstdnames)
	  stdname = ['Standard', num2str(handles.numofstdnames)];
	  handles.stdnames{handles.numofstdnames} = stdname;
	end
	handles.numofstdnames = handles.numofstdnames + 1;
	
	set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(handles.numofdevnames)]);
	if ~(isempty(handles.devnames))
	  if (length(handles.devnames) >= handles.numofdevnames)
	    set(handles.stimulus,'String', ...
			      handles.devnames{handles.numofdevnames});
	  else
	    set(handles.stimulus,'String',[]);
	  end
	else
	  set(handles.stimulus,'String',[]);

	end
	if (isempty(handles.codes) | length(handles.codes) < ...
	    handles.numofdevnames + handles.numofstdnames)
	  handles.codes(handles.numofstdnames+handles.numofdevnames - ...
			1) = handles.codecounter;
	  handles.codecounter = handles.codecounter + 1;
	  set(handles.code,'String',[]); 	  
	else
	  set(handles.code,'String', ...
			   num2str(handles.codes(handles.numofstdnames)));
	end

	
      else
	
	%% DEV++
	if (isempty(handles.devnames) | length(handles.devnames) < ...
					   handles ...
					       .numofdevnames)
	  devname = ['Deviant', num2str(handles.numofdevnames)];
	  handles.devnames{handles.numofdevnames} = devname;
	end
	
	handles.numofdevnames = handles.numofdevnames + 1;

	avprob = tune_dev_probability(handles);
	handles.dev_probabilities(handles.numofdevnames) = avprob;
	handles.dev_probability_left = handles.dev_probability_left - avprob;
	
	set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(handles.numofdevnames)]);
	if ~(isempty(handles.devnames))
	  if (length(handles.devnames) >= handles.numofdevnames)
	    set(handles.stimulus,'String', ...
			      handles.devnames{handles.numofdevnames});
	  else
	    set(handles.stimulus,'String',[]);

	  end
	else
	  set(handles.stimulus,'String',[]);
	end
	if (isempty(handles.codes) | length(handles.codes) < ...
	    handles.numofdevnames + handles.numofstdnames-1)
	  handles.codes(handles.numofstdnames+handles.numofdevnames - ...
			1) = handles.codecounter;
	  handles.codecounter = handles.codecounter + 1;
	  set(handles.code,'String',[]);
	else
	  set(handles.code,'String', ...
			   num2str(handles.codes(handles.numofstdnames-1 ...
						 + handles.numofdevnames)));
	end

      end
    else
      
      %%STD++
      if (isempty(handles.stdnames) | length(handles.stdnames) < ...
					     handles ...
					     .numofstdnames)
	stdname = ['Standard', num2str(handles.numofstdnames)];
	handles.stdnames{handles.numofstdnames} = stdname;
      end
      
      handles.numofstdnames = handles.numofstdnames + 1;

      avprob = tune_std_probability(handles);
      handles.std_probabilities(handles.numofstdnames) = avprob;
      handles.std_probability_left = handles.std_probability_left - avprob;
      
      set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
      if ~(isempty(handles.stdnames))
	if (length(handles.stdnames) >= handles.numofstdnames)
	  set(handles.stimulus,'String', ...
			    handles.stdnames{handles.numofstdnames});
	else
	  set(handles.stimulus,'String',[]);
	end
      else
	set(handles.stimulus,'String',[]);

      end
      if (isempty(handles.codes) | length(handles.codes) < ...
	  handles.numofstdnames)
	handles.codes(handles.numofstdnames) = handles.codecounter;
	handles.codecounter = handles.codecounter + 1;
	set(handles.code,'String',[]);	
      else
	set(handles.code,'String', ...
			 num2str(handles.codes(handles.numofstdnames)));
      end
      
    end
  end
 
 
 case 23
  
  hide_state23(handles);
  handles.previous_state = handles.state;
  handles.state = 3;
  show_state3(handles);
  
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
  close(handles.oregsequence);
  
 case 21
  hide_state21(handles); 
  show_state1(handles);
  handles.state = 1;
  handles.probability_left = 100;
  handles.probabilities = [];
  handles.previous_state = 0;
  guidata(hObject, handles);
  
 case 22
  if (handles.numofdevnames == 1)
    handles.numofdevnames = 0;
    handles.numofstdnames = handles.numofstdnames - 1;
    handles.std_probability_left = handles.std_probabilities(handles.numofstdnames);
    tune_std_probability(handles);
    set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
    set(handles.stimulus,'String', ...
		      handles.stdnames{handles.numofstdnames});
    set(handles.code,'String', ...
		     num2str(handles.codes(handles.numofstdnames)));
    handles.dev_probability_left = 100;
    handles.dev_probabilities = [];
    
  else
    if (handles.numofstdnames == 1)
      hide_state22(handles);
      show_state1(handles);
      handles.state = 1;
      handles.previous_state = 0;
      handles.std_probability_left = 100;
      handles.std_probabilities = [];

    else
      if (handles.numofdevnames == 0)

	handles.numofstdnames = handles.numofstdnames - 1;
	handles.std_probability_left = handles.std_probability_left + ...
	    handles.std_probabilities(handles.numofstdnames);
	set(handles.probability,'String', ...
			  num2str(handles.std_probabilities(handles.numofstdnames)));

	set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
	set(handles.stimulus,'String', ...
			  handles.stdnames{handles.numofstdnames});
	set(handles.code,'String', ...
			 num2str(handles.codes(handles.numofstdnames)));
	
      else
	
	handles.numofdevnames = handles.numofdevnames - 1;
	handles.dev_probability_left = handles.dev_probability_left + ...
	    handles.dev_probabilities(handles.numofdevnames);
	
	set(handles.probability,'String', ...
			  num2str(handles.dev_probabilities(handles.numofdevnames)));
	set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(handles.numofdevnames)]);
	set(handles.stimulus,'String', ...
			  handles.devnames{handles.numofdevnames});
	set(handles.code,'String', ...
			 num2str(handles.codes(handles.numofstdnames-1+handles.numofdevnames)));
	
      end
    end
  end

  guidata(hObject, handles);

  
 case 23
  hide_state23(handles);
  show_state22(handles);
  handles.state = 22;
  handles.previous_state = 1;
  guidata(hObject, handles);
  
  
 case 3
  hide_state3(handles);
  if (handles.advanced)
    handles.state = 23;
    handles.previous_state = 22;
    show_state23(handles);
  else
    handles.state = 21;
    handles.previous_state = 1;
    show_state21(handles);
  end
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

% The default path and filenames:
if ~(isfield(handles,'pathvalue'))
  handles.pathvalue = 'C:\';
end
if ~(isfield(handles,'filenamevalue'))
  handles.filenamevalue = 'oddball';
end

probabilities(1) = str2double(get(handles.repmin,'String'));
probabilities(2) = str2double(get(handles.repmax,'String'));

if (~handles.advanced)
  if ~(isfield(handles,'standardfilename'))
    handles.standardfilename = 'standard';
  end
  if ~(isfield(handles,'deviantfilename'))
    handles.deviantfilename = 'deviant';
  end
  stimuli{1} = handles.standardfilename;
  stimuli{2} = handles.deviantfilename;
  probabilities(3) = 1;
  probabilities(4) = 1;
  probabilities(5) = 100;
  probabilities(6) = 100;
  minstim(1) = 0;
  minstim(2) = 0;
  minstim(3) = 0;
  minstim(4) = 5;
  minstim(5) = str2double(get(handles.numofseqfiles,'String'));
  minstim(6) = 1;
  handles.codes(1) = 1;
  handles.codes(2) = 2;
  
else
  for j=1:length(handles.stdnames)
    stimuli{j} = handles.stdnames{j};
  end
  for j = length(handles.stdnames)+1:length(handles.stdnames)+ ...
	  length(handles.devnames)
    stimuli{j} = handles.devnames{j-length(handles.stdnames)};
  end
  probabilities(3) = length(handles.stdnames);
  probabilities(4) = length(handles.devnames);
  minstim(1) = 0; %deprecated
  minstim(2) = str2double(get(handles.minstimbetstd,'String'));
  minstim(3) = str2double(get(handles.numofstimignored,'String'));
  % stimuli ignored in the beginning (code set to 0)
  minstim(4) = str2double(get(handles.begignore,'String'));
  % number of sequence files
  minstim(5) = str2double(get(handles.numofseqfiles,'String'));  
  % which sequence file is being created
  minstim(6) = 1;
  
  for i = 1:length(handles.stdnames)
    probabilities(i+4) = handles.std_probabilities(i);
  end
  for i = 1:length(handles.devnames)
    probabilities(i+length(handles.stdnames)+4) = ...
      handles.dev_probabilities(i);
  end

end

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

h = waitbar(0,'Creating the sequence...');

if (numofseqfiles == 1)

  % Settings are written to an ascii file <filename>.txt
  options_string = get_options(handles);
  file_out = [handles.filenamevalue, '.txt'];
  fid = fopen(lower([handles.pathvalue,file_out]),'wt');
  fprintf(fid,options_string);
  fclose(fid);
  
  % Sequence is created.
  result = oreg(stimuli, handles.soaminvalue, handles.soamaxvalue, ...
		   handles.totalstimvalue, probabilities, minstim, ...
		   handles.filenamevalue, handles.pathvalue, handles.codes, ...
		   program);

else
  
  for seqfile = 1:numofseqfiles
    
    minstim(6) = seqfile;
    filename = [handles.filenamevalue, num2str(seqfile)];
    % Settings are written to an ascii file <filename>.txt
    options_string = get_options(handles);
    file_out = [filename, '.txt'];
    fid = fopen(lower([handles.pathvalue,file_out]),'wt');
    fprintf(fid,options_string);
    fclose(fid);
    
    % Sequence is created.
    result = oreg(stimuli, handles.soaminvalue, handles.soamaxvalue, ...
		     handles.totalstimvalue, probabilities, minstim, ...
		     filename, handles.pathvalue, handles.codes, ...
		     program);
  end
end

close(h);   % Close wait bar
set(handles.titletag,'String','Sequence created');

% Final statistics are shown on the screen.
statistics1 = ['The probability of a deviant stimulus in the sequence' ...
	       ': ', num2str(result(1))];
statistics2 = ['The total amount of stimuli in the sequence: ', ...
	       num2str(result(2))];

set(handles.stat1tag,'string',statistics1);
set(handles.stat2tag,'string',statistics2);

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
close(handles.oregsequence);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.oregsequence);



% --- Executes on button press in advancedbutton.
function advancedbutton_Callback(hObject, eventdata, handles)
% hObject    handle to advancedbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_advanced_options(handles);
handles.advanced = 1;
guidata(hObject, handles);


% --- Executes on button press in simplebutton.
function simplebutton_Callback(hObject, eventdata, handles)
% hObject    handle to simplebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_simple_options(handles);
handles.advanced = 0;
set(handles.numofstd,'String','1');
set(handles.numofdev,'String','1');
guidata(hObject, handles);




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



% --- Executes during object creation, after setting all properties.
function numofstd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofstd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function numofstd_Callback(hObject, eventdata, handles)
% hObject    handle to numofstd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofstd as text
%        str2double(get(hObject,'String')) returns contents of numofstd as a double



% --- Executes on button press in triggercodebox.
function triggercodebox_Callback(hObject, eventdata, handles)
% hObject    handle to triggercodebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of triggercodebox




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


% --- Shows the trigger code selection.
function show_code_selection(handles)
set(handles.codetag,'Visible','on');
set(handles.code,'Visible','on');


% --- Hides the trigger code selection.
function hide_code_selection(handles)
set(handles.codetag,'Visible','off');
set(handles.code,'Visible','off');



% --- Shows the program selection.
function show_program_selection(handles)
set(handles.stimradio,'Visible','on');
set(handles.brainstimradio,'Visible','on');
set(handles.presentationradio,'Visible','on');
set(handles.ptbradio,'Visible','on');
set(handles.pathtag,'Visible','on');
set(handles.path,'Visible','on');
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
set(handles.pathtag,'Visible','off');
set(handles.path,'Visible','off');
set(handles.filenametag,'Visible','off');
set(handles.filename,'Visible','off');
set(handles.finishbutton,'Visible','off');
set(handles.nextbutton,'Visible','on');
set(handles.programframe,'Visible','off');
set(handles.manybox,'Visible','off');
set(handles.manypanel,'Visible','off');
set(handles.numofseqfilestag,'Visible','off');
set(handles.numofseqfiles,'Visible','off');


% --- Hides the options components.
function hide_options(handles)

set(handles.soatag,'Visible','off');
set(handles.soamin,'Visible','off');
set(handles.soamintag,'Visible','off');
set(handles.soamax,'Visible','off');
set(handles.soamaxtag,'Visible','off');
set(handles.advancedbutton,'Visible','off');
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.totalstimtag,'Visible','off');
set(handles.totalstim,'Visible','off');
set(handles.numofstdtag,'Visible','off');
set(handles.numofstd,'Visible','off');
set(handles.numofdevtag,'Visible','off');
set(handles.numofdev,'Visible','off');
set(handles.reptag,'Visible','off');
set(handles.reptag,'Visible','off');
set(handles.repmin,'Visible','off');
set(handles.repmintag,'Visible','off');
set(handles.repmax,'Visible','off');
set(handles.repmaxtag,'Visible','off');


% --- Shows the simple options components.
function show_simple_options(handles)

set(handles.numofstdtag,'Visible','on');
set(handles.numofstd,'Visible','off');
set(handles.numofdevtag,'Visible','on');
set(handles.numofdev,'Visible','off');
set(handles.soatag,'Visible','on');
set(handles.soamin,'Visible','on');
set(handles.advancedbutton,'Visible','on');
set(handles.soamintag,'Visible','off');
set(handles.soamax,'Visible','off');
set(handles.soamaxtag,'Visible','off');
set(handles.reptag,'Visible','on');
set(handles.repmin,'Visible','on');
set(handles.repmintag,'Visible','on');
set(handles.repmax,'Visible','on');
set(handles.repmaxtag,'Visible','on');
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.reptag,'Visible','on');
set(handles.numofstdtag,'String','One standard stimulus.');
set(handles.numofdevtag,'String','One deviant stimulus.');



% --- Shows the advanced options components.
function show_advanced_options(handles)

set(handles.numofstdtag,'String',['Number of different standard' ...
		    ' stimuli']);
set(handles.numofdevtag,'String',['Number of different deviant' ...
		    ' stimuli']);
set(handles.numofstdtag,'Visible','on');
set(handles.numofstd,'Visible','on');
set(handles.numofdevtag,'Visible','on');
set(handles.numofdev,'Visible','on');
set(handles.soatag,'Visible','on');
set(handles.soamin,'Visible','on');
set(handles.soamintag,'Visible','on');
set(handles.soamax,'Visible','on');
set(handles.soamaxtag,'Visible','on');
set(handles.advancedbutton,'Visible','off');
set(handles.simplebutton,'Visible','on');
set(handles.triggercodebox,'Visible','on');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.reptag,'Visible','on');
set(handles.reptag,'Visible','on');
set(handles.repmin,'Visible','on');
set(handles.repmintag,'Visible','on');
set(handles.repmax,'Visible','on');
set(handles.repmaxtag,'Visible','on');


% --- Hides the finished state components.
function hide_finished(handles)

set(handles.stat1tag,'Visible','off');
set(handles.stat2tag,'Visible','off');
set(handles.closebutton,'Visible','off');
set(handles.statisticsframe,'Visible','off');


% --- Shows the finished state components.
function show_finished(handles)

set(handles.stat1tag,'Visible','on');
set(handles.stat2tag,'Visible','on');
set(handles.nextbutton,'Visible','off');
set(handles.backbutton,'Visible','off');
set(handles.cancelbutton,'Visible','off');
set(handles.closebutton,'Visible','on');
set(handles.statisticsframe,'Visible','on');



% --- Shows GUI components of state 1
function show_state1(handles)
if (handles.advanced)
  show_advanced_options(handles);
else
  show_simple_options(handles);
end



% --- Hides GUI components of state 1
function hide_state1(handles)
hide_options(handles);


% --- Shows GUI components of state 21
function show_state21(handles)
set(handles.stimulustag,'Visible','on');
set(handles.stimulus,'Visible','on');
set(handles.stimulus,'String','stim1');
set(handles.stimulustag,'String','Standard');
set(handles.stimulustag2,'Visible','on');
set(handles.stimulustag2,'String','Deviant');
set(handles.stimulus2,'Visible','on');
set(handles.stimulus2,'String','stim2');


% --- Hides GUI components of state 21
function hide_state21(handles)
set(handles.stimulustag,'Visible','off');
set(handles.stimulus,'Visible','off');
set(handles.stimulustag,'Visible','off');
set(handles.stimulus2,'Visible','off');
set(handles.stimulustag2,'Visible','off');


% --- Shows GUI components of state 22
function show_state22(handles)
set(handles.stimulustag,'Visible','on');
set(handles.stimulus,'Visible','on');
set(handles.probability,'Visible','on');
set(handles.probabilitytag,'Visible','on');
set(handles.probabilitytag2,'Visible','on');
if (get(handles.triggercodebox,'Value'))
  show_code_selection(handles);
end


% --- Hides GUI components of state 22
function hide_state22(handles)
set(handles.stimulustag,'Visible','off');
set(handles.stimulus,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
hide_code_selection(handles);


% --- Shows GUI components of state 23
function show_state23(handles)
set(handles.minstimbetstdtag,'Visible','on');
set(handles.minstimbetstd,'Visible','on');
set(handles.numofstimignored,'Visible','on');
set(handles.numofstimignoredtag,'Visible','on');
set(handles.begignoretag,'Visible','on');
set(handles.begignore,'Visible','on');
set(handles.minstimbetstdtag,'String',['Minimum number of' ...
		    ' stimuli between two same standards']);


% --- Hides GUI components of state 23
function hide_state23(handles)
set(handles.minstimbetstdtag,'Visible','off');
set(handles.minstimbetstd,'Visible','off');
set(handles.numofstimignoredtag,'Visible','off');
set(handles.numofstimignored,'Visible','off');
set(handles.begignoretag,'Visible','off');
set(handles.begignore,'Visible','off');



% --- Shows GUI components of state 3
function show_state3(handles)
show_program_selection(handles);

% --- Hides GUI components of state 3
function hide_state3(handles)
hide_program_selection(handles);


% --- Shows GUI components of state 4
function show_state4(handles)
show_finished(handles);

% --- Hide GUI components of state 4
function hide_state4(handles)
hide_finished(handles);



% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double

handles.pathvalue = get(hObject,'string');
guidata(hObject, handles);


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

handles.totalstimvalue = str2double(get(hObject,'string'));
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

if (handles.advanced)
  if (handles.numofstdnames == str2double(get(handles.numofstd, ...
					      'String'))+1)
    handles.devnames{handles.numofdevnames} = get(hObject, ...
						  'String');
  else
    handles.stdnames{handles.numofstdnames} = get(hObject, ...
						    'String');
  end
else
  handles.stdnames{1} = get(hObject,'String');
end

guidata(hObject, handles);


% --- Returns a vector containing the trigger codes in the proper form.
function codes = get_codes(handles)
% handles    structure with handles and user data (see GUIDATA)

codes = 1;


% --- Executes during object creation, after setting all properties.
function probability_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function probability_Callback(hObject, eventdata, handles)
% hObject    handle to probability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of probability as text
%        str2double(get(hObject,'String')) returns contents of probability as a double

input = str2double(get(hObject,'String'));
stds = str2double(get(handles.numofstd,'String'));
devs = str2double(get(handles.numofdev,'String'));

if (handles.numofdevnames == 0)
  
  % "Probabilities left" are recalculated because the default
  % probability is changed.
  totalprob = 0;
  for i = 1:(handles.numofstdnames - 1)
    totalprob = totalprob + handles.std_probabilities(i);
  end
  handles.std_probability_left = 100 - totalprob;
  
  if (input > handles.std_probability_left)
    set(hObject,'String',num2str(handles.std_probability_left))
    handles.std_probabilities(handles.numofstdnames) = handles.std_probability_left;
    handles.std_probability_left = 0;
  else
    handles.std_probability_left = handles.std_probability_left - input;
    handles.std_probabilities(handles.numofstdnames) = input;
  end
  
else
  
  % "Probabilities left" are recalculated because the default
  % probability is changed.
  totalprob = 0;
  for i = 1:(handles.numofdevnames - 1)
    totalprob = totalprob + handles.dev_probabilities(i);
  end
  handles.dev_probability_left = 100 - totalprob;
  
  if (input > handles.dev_probability_left)
    set(hObject,'String',num2str(handles.dev_probability_left))
    handles.dev_probabilities(handles.numofdevnames) = handles.dev_probability_left;
    handles.dev_probability_left = 0;
  else
    handles.dev_probability_left = handles.dev_probability_left - input;
    handles.dev_probabilities(handles.numofdevnames) = input;
  end
end

guidata(hObject, handles);



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

if (handles.numofstdnames > str2double(get(handles.numofstd, ...
					   'String')))
    handles.codes(handles.numofstdnames + handles.numofdevnames - 1) ...
	= str2double(get(hObject,'String'));
else
  handles.codes(handles.numofstdnames + handles.numofdevnames) = ...
      str2double(get(hObject,'String'));
end

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
function stimulus2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stimulus2_Callback(hObject, eventdata, handles)
% hObject    handle to stimulus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimulus2 as text
%        str2double(get(hObject,'String')) returns contents of stimulus2 as a double

handles.devnames{1} = get(hObject,'String');



% --- Executes during object creation, after setting all properties.
function minstimbetstd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minstimbetstd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minstimbetstd_Callback(hObject, eventdata, handles)
% hObject    handle to minstimbetstd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minstimbetstd as text
%        str2double(get(hObject,'String')) returns contents of minstimbetstd as a double


% --- Executes during object creation, after setting all properties.
function numofstimignored_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofstimignored (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function numofstimignored_Callback(hObject, eventdata, handles)
% hObject    handle to numofstimignored (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofstimignored as text
%        str2double(get(hObject,'String')) returns contents of numofstimignored as a double


% --- Calculates the average probability for those stimuli, to
%     which no probability has yet been defined.
function y = tune_dev_probability(handles)

devs = str2double(get(handles.numofdev,'String'));
stds = str2double(get(handles.numofstd,'String'));

numofstim = str2double(get(handles.numofdev,'String'));
numofstimnames = handles.numofdevnames;

set(handles.probabilitytag,'String','Probability among deviants');
avprob = handles.dev_probability_left / (numofstim - numofstimnames + 1);
set(handles.probability,'String',num2str(avprob));

y = avprob;


% --- Calculates the average probability for those stimuli, to
%     which no probability has yet been defined.
function y = tune_std_probability(handles)

devs = str2double(get(handles.numofdev,'String'));
stds = str2double(get(handles.numofstd,'String'));

numofstim = str2double(get(handles.numofstd,'String'));
numofstimnames = handles.numofstdnames;

set(handles.probabilitytag,'String','Probability among standards');
avprob = handles.std_probability_left / (numofstim - numofstimnames + 1);
set(handles.probability,'String',num2str(avprob));

y = avprob;



% --- Returns a string containing sequence's settings.
function optstring = get_options(handles)
% handles    structure with handles and user data (see GUIDATA)

opt = 'REGULATED ODDBALL SEQUENCE SETTINGS\n\n';

if (handles.advanced)
  % Total number of stimuli
  o1 = 'Total number of stimuli: ';
  o2 = num2str(handles.totalstimvalue);
  opt = cat(2, opt, o1, o2);
  
  % SOA
  o1 = '\nMinimum SOA: ';
  o2 = num2str(handles.soaminvalue);
  opt = cat(2, opt, o1, o2);
  o1 = '\nMaximum SOA: ';
  o2 = num2str(handles.soamaxvalue);
  opt = cat(2, opt, o1, o2);
  
  % Number of standards after a deviant
  o1 = '\nNumber of standards after a deviant: ';
  o2 = [get(handles.repmin,'String'), ' - ', get(handles.repmax,'String')];
  opt = cat(2, opt, o1, o2);
  
  % Number of different standard stimuli:
  o1 = '\nNumber of different standards: ';
  o2 = num2str(handles.numofstdnames-1);
  opt = cat(2, opt, o1, o2);
  
  % Number of different standard stimuli:
  o1 = '\nNumber of different deviants: ';
  o2 = num2str(handles.numofdevnames);
  opt = cat(2, opt, o1, o2);
  
  % Minimum number of stimuli between two same standards:
  o1 = '\nMinimum number of stimuli between two same standards: ';
  o2 = get(handles.minstimbetstd,'String');
  opt = cat(2, opt, o1, o2);
  
  % Number of stimuli ignored after a deviant:
  o1 = '\nNumber of stimuli ignored after a deviant: ';
  o2 = get(handles.numofstimignored,'String');
  opt = cat(2, opt, o1, o2);
  
  % Stimuli:
  opt = cat(2, opt, '\n\nSTIMULI:\n');
  
  for i = 1:handles.numofstdnames-1
    o1 = handles.stdnames{i};
    o2 = '\nProbability: ';
    o3 = num2str(handles.std_probabilities(i));
    o4 = '\nTrigger code: ';
    o5 = num2str(handles.codes(i));
    o6 = '\n\n';
    opt = cat(2, opt, o1, o2, o3, o4, o5, o6);
  end
  
  for j = 1:handles.numofdevnames
    o1 = handles.devnames{j};
    o2 = '\nProbability: ';
    o3 = num2str(handles.dev_probabilities(j));
    o4 = '\nTrigger code: ';
    o5 = num2str(handles.codes(i+j));
    o6 = '\n\n';
    opt = cat(2, opt, o1, o2, o3, o4, o5, o6);
  end

else % Simple options
    
  % Total number of stimuli
  o1 = 'Total number of stimuli: ';
  o2 = num2str(handles.totalstimvalue);
  opt = cat(2, opt, o1, o2);
  
  % SOA
  o1 = '\nSOA: ';
  o2 = num2str(handles.soaminvalue);
  o3 = 's';
  opt = cat(2, opt, o1, o2, o3);
  
  % Number of standards after a deviant
  o1 = '\nNumber of standards after a deviant: ';
  o2 = [get(handles.repmin,'String'), ' - ', get(handles.repmax,'String')];
  opt = cat(2, opt, o1, o2);
  % Stimuli:
  opt = cat(2, opt, '\n\nSTIMULI:\n\n');
  
  o1 = handles.standardfilename;
  o2 = '\nCode: 1\n\n';
  o3 = handles.deviantfilename;
  o4 = '\nCode : 2\n';
  opt = cat(2, opt, o1, o2, o3, o4);
  
end

opt = cat(2, opt, '\n\n---END---');
optstring = opt;

% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.state

 case 1
  web 'http://www.cbru.helsinki.fi/seqma/oddball.html' ...
      -browser
  
 case 21
  web 'http://www.cbru.helsinki.fi/seqma/oddballsimple2.html' ...
      -browser
  
 case 22
  web 'http://www.cbru.helsinki.fi/seqma/oddballadvanced2.html' -browser
  
 case 23
  web 'http://www.cbru.helsinki.fi/seqma/oddballadvanced3.html' -browser  
  
 case 3
  if (handles.previous_state == 21) 
    web 'http://www.cbru.helsinki.fi/seqma/oddballsimple3.html' ...
	-browser
  else
    web ['http://www.cbru.helsinki.fi/seqma/' ...
	 'oddballadvanced4.html'] -browser
  end
  
 otherwise
  web 'http://www.cbru.helsinki.fi/seqma/oddball.html' -browser

end



function begignore_Callback(hObject, eventdata, handles)
% hObject    handle to begignore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of begignore as text
%        str2double(get(hObject,'String')) returns contents of begignore as a double


% --- Executes during object creation, after setting all properties.
function begignore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to begignore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


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



function repmin_Callback(hObject, eventdata, handles)
% hObject    handle to repmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repmin as text
%        str2double(get(hObject,'String')) returns contents of repmin as a double


% --- Executes during object creation, after setting all properties.
function repmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function repmax_Callback(hObject, eventdata, handles)
% hObject    handle to repmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repmax as text
%        str2double(get(hObject,'String')) returns contents of repmax as a double


% --- Executes during object creation, after setting all properties.
function repmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


