function varargout = oddballtrainsequence(varargin)
% ODDBALLTRAINSEQUENCE M-file for oddballtrainsequence.fig
%
% ODDBALLTRAINSEQUENCE is a graphical user interface for creating a
% sequence file using the Oddball train paradigm.


% Last Modified by GUIDE v2.5 22-Nov-2007 19:08:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oddballtrainsequence_OpeningFcn, ...
                   'gui_OutputFcn',  @oddballtrainsequence_OutputFcn, ...
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

% --- Executes just before oddballtrainsequence is made visible.
function oddballtrainsequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to oddballtrainsequence (see VARARGIN)

% Choose default command line output for oddballtrainsequence
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
% 211 is for standard code settings (same standard codes).
% 22 is for stimulus name, code & probability (different standard codes).
% 222 is for stimulus name, devcode & probability (same standard codes).
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
%% Different standards have same codes by default:
handles.popupvalue = 1;

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

% UIWAIT makes oddballtrainsequence wait for user response (see UIRESUME)
% uiwait(handles.oddballtrainsequence);


% --- Outputs from this function are returned to the command line.
function varargout = oddballtrainsequence_OutputFcn(hObject, eventdata, handles)
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

disp(handles.codes)
switch handles.state
    
 case 1
  hide_state1(handles);

  %% If user has used simple options:
  if ~(handles.advanced)

    hide_options(handles);
    handles.previous_state = handles.state;
    handles.state = 21;
    show_state21(handles);
  else
    % Different standards have different codes:
    if (handles.popupvalue == 2)
      handles.previous_state = handles.state;
      handles.state = 22;
      
      if (get(handles.triggercodebox,'Value'))
	set_train_codes('1', handles);
      else
	set_train_codes(0, handles);
      end
      avprob = tune_std_probability(handles);
      handles.std_probabilities(handles.numofstdnames) = avprob;
      handles.std_probability_left = handles.std_probability_left - avprob;
    
      set(handles.stimulustag,'String','Standard 1');
      show_state22(handles);
    else
      % Different standards have same codes:
      if (get(handles.triggercodebox,'Value'))
	handles.previous_state = handles.state;
	handles.state = 211;
	show_state211(handles);
      else
	handles.previous_state = handles.state;
	avprob = tune_std_probability(handles);
	handles.std_probabilities(handles.numofstdnames) = avprob;
	handles.std_probability_left = handles.std_probability_left ...
	    - avprob;
	for i=1:13
	  handles.codes(i) = i;
	end
	handles.state = 222;
	set(handles.stimulustag,'String','Standard 1');	
	show_state222(handles);
      end
    end
  end

  guidata(hObject, handles);
    
 case 21
  handles.previous_state = handles.state;
  hide_state21(handles);
  handles.state = 3;
  show_state3(handles);
  guidata(hObject, handles);
  

 case 211
  handles.previous_state = handles.state;
  handles.codes = get_codes(handles);
  hide_state211(handles);
  
  handles.state = 222;
  avprob = tune_std_probability(handles);
  handles.std_probabilities(handles.numofstdnames) = avprob;
  handles.std_probability_left = handles.std_probability_left - avprob;
  set(handles.stimulustag,'String','Standard 1');      
  show_state222(handles);
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

    handles.codes(handles.numofstdnames+handles.numofdevnames-1,1) = str2double(get(handles.code,'String'));

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

	hide_train_codes(handles);
	if (get(handles.triggercodebox,'Value'))
	  show_code_selection(handles);
	end

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
	if (get(handles.triggercodebox,'Value'))
	  set(handles.code,'String', ...
			   num2str(handles.numofstdnames));
	else
	  c = (handles.numofstdnames-1)* ...
	      ((str2double(get(handles.trainmax,'String')))*2-1)+ ...
	      handles.numofdevnames;
	  set(handles.code,'String',num2str(c));
	end
	  
	
	codes = get_codes(handles);
	for i=1:13
	  handles.codes(handles.numofstdnames-1,i) = codes(i);
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

        handles.codes(handles.numofstdnames+handles.numofdevnames - 2,1) = str2double(get(handles.code,'String'));
	if (get(handles.triggercodebox,'Value'))
	  set(handles.code,'String',num2str(handles.numofstdnames+ ...
					    handles.numofdevnames- ...
					    1));
	else
	  c = (handles.numofstdnames-1)* ...
	      ((str2double(get(handles.trainmax,'String')))*2-1)+ ...
	      handles.numofdevnames;
	  set(handles.code,'String',num2str(c));
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
      
      codes = get_codes(handles);
      for i=1:13
	handles.codes(handles.numofstdnames-1,i) = codes(i);
      end
      if (get(handles.triggercodebox,'Value'))
	set_train_codes(num2str(handles.numofstdnames), handles);
      else
	set_train_codes(0, handles);
      end
      
    end
  end

  
 case 222
  
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
    if (get(handles.triggercodebox,'Value'))
      handles.codes(handles.numofdevnames+13) = ...
	  str2double(get(handles.code,'String'));
    else
      handles.codes(handles.numofdevnames+13) = ...
	  handles.numofdevnames+13;
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

	if (get(handles.triggercodebox,'Value'))
	  show_code_selection(handles);
	end
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

      else
	
	%% DEV++
	if (isempty(handles.devnames) | length(handles.devnames) < ...
					   handles ...
					       .numofdevnames)
	  devname = ['Deviant', num2str(handles.numofdevnames)];
	  handles.devnames{handles.numofdevnames} = devname;
	end

	if (get(handles.triggercodebox,'Value'))
	  handles.codes(handles.numofdevnames+13) = ...
	      str2double(get(handles.code,'String'));
	else
	  handles.codes(handles.numofdevnames+13) = ...
	      handles.numofdevnames+13;
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
  close(handles.oddballtrainsequence);
  
 case 211
  hide_state211(handles);
  show_state1(handles);
  handles.state = 1;
  handles.previous_state = 0;
  guidata(hObject, handles);
  
 case 21
  hide_state21(handles); 
  show_state1(handles);
  handles.state = 1;
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
    hide_code_selection(handles);
    if (get(handles.triggercodebox,'Value'))
      show_train_codes(handles);
    end
    set_previous_train_codes(handles);
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
	set_previous_train_codes(handles);
	
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
			 num2str(handles.codes(handles.numofstdnames-1+handles.numofdevnames,1)));
	
      end
    end
  end

  guidata(hObject, handles);

 
 case 222

  if (handles.numofdevnames == 1)
    handles.numofdevnames = 0;
    handles.numofstdnames = handles.numofstdnames - 1;
    handles.std_probability_left = handles.std_probabilities(handles.numofstdnames);
    tune_std_probability(handles);
    set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
    set(handles.stimulus,'String', ...
		      handles.stdnames{handles.numofstdnames});
    hide_code_selection(handles);
    handles.dev_probability_left = 100;
    handles.dev_probabilities = [];
    
  else
    if (handles.numofstdnames == 1)
      hide_state22(handles);
      if (get(handles.triggercodebox,'Value'))
	handles.state = 211;
	show_state211(handles);
	handles.previous_state = 1;
      else
	show_state1(handles);
	handles.state = 1;
	handles.previous_state = 0;
      end
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
	
      end
    end
  end

  guidata(hObject, handles);

 
 case 23
  hide_state23(handles);
  if (handles.previous_state == 22)
    handles.state = 22;
    handles.previous_state = 1;
    show_state22(handles);
  else
    handles.state = 222;
    if (get(handles.triggercodebox,'Value'))
      handles.previous_state = 211;
    else
      handles.previous_state = 1;
    end
    show_state222(handles);      
  end
    
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

disp(handles.codes);

set(handles.titletag,'String','Creating the sequence...');
set(handles.titletag,'Visible','on');

numofseqfiles = str2double(get(handles.numofseqfiles,'String'));

hide_program_selection(handles);

% The default filename:
if ~(isfield(handles,'filenamevalue'))
  handles.filenamevalue = 'train';
end

probabilities(1) = str2double(get(handles.devprob,'String'));

soamin = handles.soaminvalue;
soamax = handles.soamaxvalue;
itimin = str2double(get(handles.itimin,'String'));
itimax = str2double(get(handles.itimax,'String'));
trainmin = str2double(get(handles.trainmin,'String'));
trainmax = str2double(get(handles.trainmax,'String'));

% Simple options
if (~handles.advanced)
  if ~(isfield(handles,'standardfilename'))
    handles.standardfilename = 'standard';
  end
  if ~(isfield(handles,'deviantfilename'))
    handles.deviantfilename = 'deviant';
  end
  stimuli{1} = handles.standardfilename;
  stimuli{2} = handles.deviantfilename;
  probabilities(2) = 1;
  probabilities(3) = 1;
  probabilities(4) = 100;
  probabilities(5) = 100;
  minstim(1) = 1;
  minstim(2) = 0;
  minstim(3) = 0;
  minstim(4) = 5;
  minstim(5) = str2double(get(handles.numofseqfiles,'String'));
  minstim(6) = 1;
  for i=1:13
    handles.codes(i)=1;
  end
  handles.codes(14)=2;

  %Advanced options
else
  for j=1:length(handles.stdnames)
    stimuli{j} = handles.stdnames{j};
  end
  for j = length(handles.stdnames)+1:length(handles.stdnames)+ ...
	  length(handles.devnames)
    stimuli{j} = handles.devnames{j-length(handles.stdnames)};
  end
  probabilities(2) = length(handles.stdnames);
  probabilities(3) = length(handles.devnames);
  minstim(1) = str2double(get(handles.minstimbetstd,'String'));
  minstim(2) = str2double(get(handles.numofstimignored,'String'));
  % stimuli ignored in the beginning (code set to 0)
  minstim(3) = str2double(get(handles.begignore,'String'));
  % number of sequence files
  minstim(4) = str2double(get(handles.numofseqfiles,'String'));  
  % which sequence file is being created
  minstim(5) = 1;
  
  for i = 1:length(handles.stdnames)
    probabilities(i+3) = handles.std_probabilities(i);
  end
  for i = 1:length(handles.devnames)
    probabilities(i+length(handles.stdnames)+3) = ...
      handles.dev_probabilities(i);
  end

  if (isempty(handles.codes))
    numofdev = str2double(get(handles.numofdev,'String'));
    if (handles.popupvalue == 1)
      for i=1:13
	handles.codes(i) = i;
      end
      for i = 14:14+numofdev-1
	handles.codes(i) = i;
      end
    else
      numofstd = str2double(get(handles.numofstd,'String'));
      index = 1;
      for i = 1:numofstd
	for j = 1:trainmax
	  handles.codes(i,j)=index;
	  index = index+1;
	end
	if (trainmax < 13)
	  for j = trainmax+1:13
	    handles.codes(i,j) = 0;
	  end
	end
      end
      for i = numofstd+1:numofstd+numofdev
	handles.codes(i,1) = index;
	index = index+1;
      end
    end
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


trainset = [soamin, soamax, itimin, itimax, trainmin, trainmax];

guidata(hObject,handles);

h = waitbar(0,'Creating the sequence...');

if (numofseqfiles == 1)

  % Settings are written to an ascii file <filename>.txt
  options_string = get_options(handles);
  file_out = [handles.filenamevalue, '.txt'];
  fid = fopen(lower([cd,file_out]),'wt');
  fprintf(fid,options_string);
  fclose(fid);
  
  % Sequence is created.
  result = oddballtrain(stimuli, trainset, ...
		   handles.totalstimvalue, probabilities, minstim, ...
		   handles.filenamevalue, handles.codes, ...
		   program);

else
  
  for seqfile = 1:numofseqfiles
    
    minstim(6) = seqfile;
    filename = [handles.filenamevalue, num2str(seqfile)];
    % Settings are written to an ascii file <filename>.txt
    options_string = get_options(handles);
    file_out = [filename, '.txt'];
    fid = fopen(lower([cd,file_out]),'wt');
    fprintf(fid,options_string);
    fclose(fid);
    
    % Sequence is created.
    result = oddball(stimuli, handles.soaminvalue, handles.soamaxvalue, ...
		     handles.totalstimvalue, probabilities, minstim, ...
		     filename, handles.codes, ...
		     program);
  end
end

close(h);   % Close wait bar
set(handles.titletag,'String','Sequence created');

% Final statistics are shown on the screen.
statistics1 = ['The probability of a train beginning with deviant stimulus in the sequence' ...
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
close(handles.oddballtrainsequence);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.oddballtrainsequence);



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


% --- Shows the trigger code selection.
function show_code_selection(handles)
set(handles.codetag,'Visible','on');
set(handles.code,'Visible','on');



% --- Hides the trigger code selection.
function hide_code_selection(handles)
set(handles.codetag,'Visible','off');
set(handles.code,'Visible','off');


% --- Shows the train code selection.
function show_train_codes(handles)
trainmax = str2double(get(handles.trainmax,'String'));
set(handles.triggercodetitle,'Visible','on');
set(handles.devtraintag,'Visible','on');
set(handles.dev1frame,'Visible','on');
set(handles.dev1tag,'Visible','on');
set(handles.dev2frame,'Visible','on');
set(handles.dev2tag,'Visible','on');
set(handles.dev2,'Visible','on');
set(handles.stdtraintag,'Visible','on');
set(handles.std1frame,'Visible','on');
set(handles.std1tag,'Visible','on');
set(handles.std1,'Visible','on');
set(handles.std2frame,'Visible','on');
set(handles.std2tag,'Visible','on');
set(handles.std2,'Visible','on');

if (trainmax > 2)
  set(handles.dev3frame,'Visible','on');
  set(handles.dev3tag,'Visible','on');
  set(handles.dev3,'Visible','on');
  set(handles.std3frame,'Visible','on');
  set(handles.std3tag,'Visible','on');
  set(handles.std3,'Visible','on');
end
if (trainmax > 3)
  set(handles.dev4frame,'Visible','on');
  set(handles.dev4tag,'Visible','on');
  set(handles.dev4,'Visible','on');
  set(handles.std4frame,'Visible','on');
  set(handles.std4tag,'Visible','on');
  set(handles.std4,'Visible','on');
end
if (trainmax > 4)
  set(handles.dev5frame,'Visible','on');
  set(handles.dev5tag,'Visible','on');
  set(handles.dev5,'Visible','on');
  set(handles.std5frame,'Visible','on');
  set(handles.std5tag,'Visible','on');
  set(handles.std5,'Visible','on');
end
if (trainmax > 5)
  set(handles.dev6frame,'Visible','on');
  set(handles.dev6tag,'Visible','on');
  set(handles.dev6,'Visible','on');
  set(handles.std6frame,'Visible','on');
  set(handles.std6tag,'Visible','on');
  set(handles.std6,'Visible','on');
end
if (trainmax > 6)
  set(handles.dev7frame,'Visible','on');
  set(handles.dev7tag,'Visible','on');
  set(handles.dev7,'Visible','on');
  set(handles.std7frame,'Visible','on');
  set(handles.std7tag,'Visible','on');
  set(handles.std7,'Visible','on');
end

% --- Hides the train code selection.
function hide_train_codes(handles)
set(handles.triggercodetitle,'Visible','off');
set(handles.devtraintag,'Visible','off');
set(handles.dev1frame,'Visible','off');
set(handles.dev1tag,'Visible','off');
set(handles.dev1,'Visible','off');
set(handles.dev2frame,'Visible','off');
set(handles.dev2tag,'Visible','off');
set(handles.dev2,'Visible','off');
set(handles.dev3frame,'Visible','off');
set(handles.dev3tag,'Visible','off');
set(handles.dev3,'Visible','off');
set(handles.dev4frame,'Visible','off');
set(handles.dev4tag,'Visible','off');
set(handles.dev4,'Visible','off');
set(handles.dev5frame,'Visible','off');
set(handles.dev5tag,'Visible','off');
set(handles.dev5,'Visible','off');
set(handles.dev6frame,'Visible','off');
set(handles.dev6tag,'Visible','off');
set(handles.dev6,'Visible','off');
set(handles.dev7frame,'Visible','off');
set(handles.dev7tag,'Visible','off');
set(handles.dev7,'Visible','off');
set(handles.stdtraintag,'Visible','off');
set(handles.std1frame,'Visible','off');
set(handles.std1tag,'Visible','off');
set(handles.std1,'Visible','off');
set(handles.std2frame,'Visible','off');
set(handles.std2tag,'Visible','off');
set(handles.std2,'Visible','off');
set(handles.std3frame,'Visible','off');
set(handles.std3tag,'Visible','off');
set(handles.std3,'Visible','off');
set(handles.std4frame,'Visible','off');
set(handles.std4tag,'Visible','off');
set(handles.std4,'Visible','off');
set(handles.std5frame,'Visible','off');
set(handles.std5tag,'Visible','off');
set(handles.std5,'Visible','off');
set(handles.std6frame,'Visible','off');
set(handles.std6tag,'Visible','off');
set(handles.std6,'Visible','off');
set(handles.std7frame,'Visible','off');
set(handles.std7tag,'Visible','off');
set(handles.std7,'Visible','off');

% --- Sets train code strings to some value.
function set_train_codes(code, handles)
% code   New value as a string
if (code ~= 0)
  set(handles.std1,'String',code);
  set(handles.std2,'String',code);
  set(handles.std3,'String',code);
  set(handles.std4,'String',code);
  set(handles.std5,'String',code);
  set(handles.std6,'String',code);
  set(handles.std7,'String',code);
  set(handles.dev2,'String',code);
  set(handles.dev3,'String',code);
  set(handles.dev4,'String',code);
  set(handles.dev5,'String',code);
  set(handles.dev6,'String',code);
  set(handles.dev7,'String',code);
else
  stdnames = handles.numofstdnames;
  trainmax = str2double(get(handles.trainmax,'String'));
  c = (handles.numofstdnames-1)*(trainmax*2-1)+1;
  set(handles.std1,'String',num2str(c));
  c = c+1;
  
  switch trainmax
    
   case 2
    set(handles.std2,'String',num2str(c));
    c = c+1;
    set(handles.dev2,'String',num2str(c));
    c = c+1;
    
   case 3
    set(handles.std2,'String',num2str(c));
    c = c+1;
    set(handles.std3,'String',num2str(c));
    c = c+1;
    set(handles.dev2,'String',num2str(c));
    c = c+1;
    set(handles.dev3,'String',num2str(c));
    c = c+1;
    
   case 4
    set(handles.std2,'String',num2str(c));
    c = c+1;
    set(handles.std3,'String',num2str(c));
    c = c+1;
    set(handles.std4,'String',num2str(c));
    c = c+1;
    set(handles.dev2,'String',num2str(c));
    c = c+1;
    set(handles.dev3,'String',num2str(c));
    c = c+1;
    set(handles.dev4,'String',num2str(c));
    c = c+1;
    
   case 5
    set(handles.std2,'String',num2str(c));
    c = c+1;
    set(handles.std3,'String',num2str(c));
    c = c+1;
    set(handles.std4,'String',num2str(c));
    c = c+1;
    set(handles.std5,'String',num2str(c));
    c = c+1;
    set(handles.dev2,'String',num2str(c));
    c = c+1;
    set(handles.dev3,'String',num2str(c));
    c = c+1;
    set(handles.dev4,'String',num2str(c));
    c = c+1;
    set(handles.dev5,'String',num2str(c));
    c = c+1;
    
   case 6
    set(handles.std2,'String',num2str(c));
    c = c+1;
    set(handles.std3,'String',num2str(c));
    c = c+1;
    set(handles.std4,'String',num2str(c));
    c = c+1;
    set(handles.std5,'String',num2str(c));
    c = c+1;
    set(handles.std6,'String',num2str(c));
    c = c+1;
    set(handles.dev2,'String',num2str(c));
    c = c+1;
    set(handles.dev3,'String',num2str(c));
    c = c+1;
    set(handles.dev4,'String',num2str(c));
    c = c+1;
    set(handles.dev5,'String',num2str(c));
    c = c+1;
    set(handles.dev6,'String',num2str(c));
    c = c+1;

   otherwise
    set(handles.std2,'String',num2str(c));
    c = c+1;
    set(handles.std3,'String',num2str(c));
    c = c+1;
    set(handles.std4,'String',num2str(c));
    c = c+1;
    set(handles.std5,'String',num2str(c));
    c = c+1;
    set(handles.std6,'String',num2str(c));
    c = c+1;
    set(handles.std7,'String',num2str(c));
    c = c+1;
    set(handles.dev2,'String',num2str(c));
    c = c+1;
    set(handles.dev3,'String',num2str(c));
    c = c+1;
    set(handles.dev4,'String',num2str(c));
    c = c+1;
    set(handles.dev5,'String',num2str(c));
    c = c+1;
    set(handles.dev6,'String',num2str(c));
    c = c+1;
    set(handles.dev7,'String',num2str(c));
    c = c+1;
    
  end
end

% --- Sets train code strings to user set values.
function set_previous_train_codes(handles)
set(handles.dev2,'String', ...
		 num2str(handles.codes(handles.numofstdnames,1)));
set(handles.dev3,'String', ...
		 num2str(handles.codes(handles.numofstdnames,2)));
set(handles.dev4,'String', ...
		 num2str(handles.codes(handles.numofstdnames,3)));
set(handles.dev5,'String', ...
		 num2str(handles.codes(handles.numofstdnames,4)));
set(handles.dev6,'String', ...
		 num2str(handles.codes(handles.numofstdnames,5)));
set(handles.dev7,'String', ...
		 num2str(handles.codes(handles.numofstdnames,6)));
set(handles.std1,'String', ...
		 num2str(handles.codes(handles.numofstdnames,7)));
set(handles.std2,'String', ...
		 num2str(handles.codes(handles.numofstdnames,8)));
set(handles.std3,'String', ...
		 num2str(handles.codes(handles.numofstdnames,9)));
set(handles.std4,'String', ...
		 num2str(handles.codes(handles.numofstdnames,10)));
set(handles.std5,'String', ...
		 num2str(handles.codes(handles.numofstdnames,11)));
set(handles.std6,'String', ...
		 num2str(handles.codes(handles.numofstdnames,12)));
set(handles.std7,'String', ...
		 num2str(handles.codes(handles.numofstdnames,13)));



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


% --- Hides the options components.
function hide_options(handles)

set(handles.soatag,'Visible','off');
set(handles.soamin,'Visible','off');
set(handles.soamintag,'Visible','off');
set(handles.soamax,'Visible','off');
set(handles.soamaxtag,'Visible','off');
set(handles.ititag,'Visible','off');
set(handles.itimin,'Visible','off');
set(handles.itimax,'Visible','off');
set(handles.itimintag,'Visible','off');
set(handles.itimaxtag,'Visible','off');
set(handles.advancedbutton,'Visible','off');
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.totalstimtag,'Visible','off');
set(handles.totalstim,'Visible','off');
set(handles.numofstdtag,'Visible','off');
set(handles.numofstd,'Visible','off');
set(handles.numofdevtag,'Visible','off');
set(handles.numofdev,'Visible','off');
set(handles.devprobtag,'Visible','off');
set(handles.devprob,'Visible','off');
set(handles.traintag,'Visible','off');
set(handles.trainmin,'Visible','off');
set(handles.trainmintag,'Visible','off');
set(handles.trainmax,'Visible','off');
set(handles.trainmaxtag,'Visible','off');
set(handles.popupmenu,'Visible','off');


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
set(handles.ititag,'Visible','on');
set(handles.itimin,'Visible','on');
set(handles.itimintag,'Visible','off');
set(handles.itimax,'Visible','off');
set(handles.itimaxtag,'Visible','off');
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.devprobtag,'Visible','on');
set(handles.devprob,'Visible','on');
set(handles.numofstdtag,'String','One standard stimulus.');
set(handles.numofdevtag,'String','One deviant stimulus.');
set(handles.traintag,'Visible','on');
set(handles.trainmin,'Visible','on');
set(handles.trainmintag,'Visible','on');
set(handles.trainmax,'Visible','on');
set(handles.trainmaxtag,'Visible','on');
set(handles.popupmenu,'Visible','off');


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
set(handles.ititag,'Visible','on');
set(handles.itimin,'Visible','on');
set(handles.itimintag,'Visible','on');
set(handles.itimax,'Visible','on');
set(handles.itimaxtag,'Visible','on');
set(handles.advancedbutton,'Visible','off');
set(handles.simplebutton,'Visible','on');
set(handles.triggercodebox,'Visible','on');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.devprobtag,'Visible','on');
set(handles.devprob,'Visible','on');
set(handles.traintag,'Visible','on');
set(handles.trainmin,'Visible','on');
set(handles.trainmintag,'Visible','on');
set(handles.trainmax,'Visible','on');
set(handles.trainmaxtag,'Visible','on');
set(handles.popupmenu,'Visible','on');


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


% --- Shows GUI components of state 211
function show_state211(handles)
set(handles.triggercodetitle,'String',['Trigger codes for standard' ...
		    ' stimuli:']);
show_train_codes(handles);


% --- Hides GUI components of state 211
function hide_state211(handles)
set(handles.triggercodetitle,'String','Trigger codes:');
hide_train_codes(handles);


% --- Shows GUI components of state 22
function show_state22(handles)
set(handles.stimulustag,'Visible','on');
set(handles.stimulus,'Visible','on');
set(handles.probability,'Visible','on');
set(handles.probabilitytag,'Visible','on');
set(handles.probabilitytag2,'Visible','on');
if (get(handles.triggercodebox,'Value'))
  if (handles.popupvalue == 2)
    if (handles.numofdevnames == 0)
      show_train_codes(handles);
    else
      show_code_selection(handles);
    end
  end
end


% --- Hides GUI components of state 22
function hide_state22(handles)
set(handles.stimulustag,'Visible','off');
set(handles.stimulus,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
hide_code_selection(handles);
hide_train_codes(handles);

% --- Shows GUI components of state 222
function show_state222(handles)
set(handles.stimulustag,'Visible','on');
set(handles.stimulus,'Visible','on');
set(handles.probability,'Visible','on');
set(handles.probabilitytag,'Visible','on');
set(handles.probabilitytag2,'Visible','on');


% --- Hides GUI components of state 222
function hide_state222(handles)
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
codes(1) = str2double(get(handles.dev2,'String'));
codes(2) = str2double(get(handles.dev3,'String'));
codes(3) = str2double(get(handles.dev4,'String'));
codes(4) = str2double(get(handles.dev5,'String'));
codes(5) = str2double(get(handles.dev6,'String'));
codes(6) = str2double(get(handles.dev7,'String'));
codes(7) = str2double(get(handles.std1,'String'));
codes(8) = str2double(get(handles.std2,'String'));
codes(9) = str2double(get(handles.std3,'String'));
codes(10) = str2double(get(handles.std4,'String'));
codes(11) = str2double(get(handles.std5,'String'));
codes(12) = str2double(get(handles.std6,'String'));
codes(13) = str2double(get(handles.std7,'String'));


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


%if (handles.numofstdnames > str2double(get(handles.numofstd, ...
%					   'String')))
%  handles.codes(handles.numofstdnames + handles.numofdevnames - 1) ...
%      = str2double(get(hObject,'String'));
%else
%  handles.codes(handles.numofstdnames + handles.numofdevnames) = ...
%      str2double(get(hObject,'String'));
%end
%  
%guidata(hObject, handles);



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
devprob = str2double(get(handles.devprob,'String'));

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
devprob = str2double(get(handles.devprob,'String'));

numofstim = str2double(get(handles.numofstd,'String'));
numofstimnames = handles.numofstdnames;

set(handles.probabilitytag,'String','Probability among standards');
avprob = handles.std_probability_left / (numofstim - numofstimnames + 1);
set(handles.probability,'String',num2str(avprob));

y = avprob;


% --- Executes during object creation, after setting all properties.
function devprob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to devprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function devprob_Callback(hObject, eventdata, handles)
% hObject    handle to devprob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of devprob as text
%        str2double(get(hObject,'String')) returns contents of devprob as a double


% --- Returns a string containing sequence's settings.
function optstring = get_options(handles)
% handles    structure with handles and user data (see GUIDATA)

opt = 'ODDBALL TRAIN SEQUENCE SETTINGS\n\n';

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
  
  % ITI
  o1 = '\nMinimum ITI: ';
  o2 = get(handles.itimin,'String');
  opt = cat(2, opt, o1, o2);
  o1 = '\nMaximum ITI: ';
  o2 = get(handles.itimax,'String');
  opt = cat(2, opt, o1, o2);
  
  % Train length:
  o1 = '\nStimuli in a train: ';
  o2 = get(handles.trainmin,'String');
  o3 = ' - ';
  o4 = get(handles.trainmax,'String');
  opt = cat(2, opt, o1, o2, o3, o4);
  
  % Probability of deviant
  o1 = '\nProbability of trains beginning with a deviant stimulus: ';
  o2 = get(handles.devprob,'String');
  opt = cat(2, opt, o1, o2);
  
  % Number of different standard stimuli:
  o1 = '\nNumber of different standards: ';
  o2 = num2str(handles.numofstdnames-1);
  opt = cat(2, opt, o1, o2);
  
  % Number of different standard stimuli:
  o1 = '\nNumber of different deviants: ';
  o2 = num2str(handles.numofdevnames);
  opt = cat(2, opt, o1, o2);
  
  % Popup-menu selection:
  popupstring = get(handles.popupmenu,'String');
  o1 = popupstring{get(handles.popupmenu,'Value')};
  opt = cat(2, opt, '\n\n', o1, '\n');

  
  % Minimum number of stimuli between two same standards:
  o1 = '\nMinimum number of stimuli between two same standards: ';
  o2 = get(handles.minstimbetstd,'String');
  opt = cat(2, opt, o1, o2);
  
  % Number of stimuli ignored after a deviant:
  o1 = '\nNumber of stimuli ignored after a deviant: ';
  o2 = get(handles.numofstimignored,'String');
  opt = cat(2, opt, o1, o2);
  
  % Stimuli:
  opt = cat(2, opt, '\n\nSTANDARD STIMULI:\n\n');

  trainmax = str2double(get(handles.trainmax,'String'));  
  for i = 1:handles.numofstdnames-1
    o1 = handles.stdnames{i};
    o2 = '\nProbability: ';
    o3 = num2str(handles.std_probabilities(i));
    if (handles.popupvalue == 2)
      o4 = '\nTrigger codes: ';

      if (trainmax > 7)
	oo4 = 'Train beginning with a deviant stimulus:\n';
	o5 = ['D  ', num2str(handles.codes(i,1:6)), '\nTrain', ...
	      ' beginning with a standard stimulus:\n', ...
	      num2str(handles.codes(i,7:13)), '\n'];
      else
	oo4 = 'Train beginning with a deviant stimulus:\n';
	o5 = ['D  ', num2str(handles.codes(i,1:trainmax-1)), '\nTrain' ...
		    ' beginning with a standard stimulus:\n', ...
		    num2str(handles.codes(i,7:6+trainmax))];
      end
    else
      oo4 = [];
      o4 = [];
      o5 = [];
    end
    o6 = '\n\n';
    opt = cat(2, opt, o1, o2, o3, o4, oo4, o5, o6);
  end
  
  if (handles.popupvalue == 1)
    o1 = '\nTRIGGER CODES FOR STANDARD STIMULI:\n\n';
    o2 = 'Train beginning with a deviant stimulus:\n';
    if (trainmax > 7)
      o3 = ['D  ', num2str(handles.codes(1:6)), '\n'];
      o4 = 'Train beginning with a standard stimulus:\n';
      o5 = [num2str(handles.codes(7:13)), '\n'];
    else
      o3 = ['D  ', num2str(handles.codes(1:trainmax-1)), '\n'];
      o4 = 'Train beginning with a standard stimulus:\n';
      o5 = [num2str(handles.codes(7:6+trainmax)), '\n'];
    end
    opt = cat(2, opt, o1, o2, o3, o4, o5);
  end

  opt = cat(2, opt, '\n\nDEVIANT STIMULI:\n\n');  
  
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
  opt = cat(2, opt, o1, o2);
  
  % ITI
  o1 = '\nITI: ';
  o2 = get(handles.itimin,'String');
  opt = cat(2, opt, o1, o2);
  
  % Train length:
  o1 = 'Stimuli in a train: ';
  o2 = get(handles.trainmin,'String');
  o3 = ' - ';
  o4 = get(handles.trainmax,'String');
  opt = cat(2, opt, o1, o2, o3, o4);
  
  
  % Probability of deviant
  o1 = '\nProbability of trains beginning with a deviant stimulus: ';
  o2 = get(handles.devprob,'String');
  o3 = '%';
  opt = cat(2, opt, o1, o2, o3);

  
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

% 1  is for options (advanced / simple)
% 21 is for stimulus name and probability settings in simple case.
% 211 is for standard code settings (same standard codes).
% 22 is for stimulus name, code & probability (different standard codes).
% 222 is for stimulus name, devcode & probability (same standard codes).
% 23 is for stimuli between stimuli & ignored stimuli settings (adv.)
% 3 is for program format and sequence file name settings.
% 4 is for finished state (some statistics are shown).


switch handles.state

 case 1
  web 'http://www.cbru.helsinki.fi/seqma/otrain.html' ...
      -browser
  
 case 21
  web 'http://www.cbru.helsinki.fi/seqma/otrainsimple2.html' ...
      -browser
 
 case 211
  web 'http://www.cbru.helsinki.fi/seqma/otrainadvanced2.html' ...
      -browser
  
 case 22
  web 'http://www.cbru.helsinki.fi/seqma/otrainadvanced2.html' -browser
  
 case 222
  web 'http://www.cbru.helsinki.fi/seqma/otrainadvanced2.html' -browser
  
 case 23
  web 'http://www.cbru.helsinki.fi/seqma/otrainadvanced3.html' -browser  
 case 3
  if (handles.previous_state == 21) 
    web 'http://www.cbru.helsinki.fi/seqma/otrainsimple3.html' ...
	-browser
  else
    web 'http://www.cbru.helsinki.fi/seqma/otrainadvanced4.html' -browser
  end
  
 otherwise
  web 'http://www.cbru.helsinki.fi/seqma/otrain.html' -browser

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



function itimin_Callback(hObject, eventdata, handles)
% hObject    handle to itimin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itimin as text
%        str2double(get(hObject,'String')) returns contents of itimin as a double


% --- Executes during object creation, after setting all properties.
function itimin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itimin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function itimax_Callback(hObject, eventdata, handles)
% hObject    handle to itimax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itimax as text
%        str2double(get(hObject,'String')) returns contents of itimax as a double


% --- Executes during object creation, after setting all properties.
function itimax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itimax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit89_Callback(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit89 as text
%        str2double(get(hObject,'String')) returns contents of edit89 as a double


% --- Executes during object creation, after setting all properties.
function edit89_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit90_Callback(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit90 as text
%        str2double(get(hObject,'String')) returns contents of edit90 as a double


% --- Executes during object creation, after setting all properties.
function edit90_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function trainmin_Callback(hObject, eventdata, handles)
% hObject    handle to trainmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainmin as text
%        str2double(get(hObject,'String')) returns contents of trainmin as a double


% --- Executes during object creation, after setting all properties.
function trainmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function trainmax_Callback(hObject, eventdata, handles)
% hObject    handle to trainmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainmax as text
%        str2double(get(hObject,'String')) returns contents of trainmax as a double


% --- Executes during object creation, after setting all properties.
function trainmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu

switch get(hObject,'Value')
 case 1
  handles.popupvalue = 1;
 case 2
  handles.popupvalue = 2;
 otherwise
  disp('No such value.');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev1_Callback(hObject, eventdata, handles)
% hObject    handle to dev1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev1 as text
%        str2double(get(hObject,'String')) returns contents of dev1 as a double


% --- Executes during object creation, after setting all properties.
function dev1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev2_Callback(hObject, eventdata, handles)
% hObject    handle to dev2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev2 as text
%        str2double(get(hObject,'String')) returns contents of dev2 as a double


% --- Executes during object creation, after setting all properties.
function dev2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev3_Callback(hObject, eventdata, handles)
% hObject    handle to dev3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev3 as text
%        str2double(get(hObject,'String')) returns contents of dev3 as a double


% --- Executes during object creation, after setting all properties.
function dev3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev4_Callback(hObject, eventdata, handles)
% hObject    handle to dev4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev4 as text
%        str2double(get(hObject,'String')) returns contents of dev4 as a double


% --- Executes during object creation, after setting all properties.
function dev4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev5_Callback(hObject, eventdata, handles)
% hObject    handle to dev5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev5 as text
%        str2double(get(hObject,'String')) returns contents of dev5 as a double


% --- Executes during object creation, after setting all properties.
function dev5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev6_Callback(hObject, eventdata, handles)
% hObject    handle to dev6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev6 as text
%        str2double(get(hObject,'String')) returns contents of dev6 as a double


% --- Executes during object creation, after setting all properties.
function dev6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dev7_Callback(hObject, eventdata, handles)
% hObject    handle to dev7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev7 as text
%        str2double(get(hObject,'String')) returns contents of dev7 as a double


% --- Executes during object creation, after setting all properties.
function dev7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std1_Callback(hObject, eventdata, handles)
% hObject    handle to std1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std1 as text
%        str2double(get(hObject,'String')) returns contents of std1 as a double


% --- Executes during object creation, after setting all properties.
function std1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std2_Callback(hObject, eventdata, handles)
% hObject    handle to std2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std2 as text
%        str2double(get(hObject,'String')) returns contents of std2 as a double


% --- Executes during object creation, after setting all properties.
function std2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std3_Callback(hObject, eventdata, handles)
% hObject    handle to std3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std3 as text
%        str2double(get(hObject,'String')) returns contents of std3 as a double


% --- Executes during object creation, after setting all properties.
function std3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std4_Callback(hObject, eventdata, handles)
% hObject    handle to std4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std4 as text
%        str2double(get(hObject,'String')) returns contents of std4 as a double


% --- Executes during object creation, after setting all properties.
function std4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std5_Callback(hObject, eventdata, handles)
% hObject    handle to std5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std5 as text
%        str2double(get(hObject,'String')) returns contents of std5 as a double


% --- Executes during object creation, after setting all properties.
function std5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std6_Callback(hObject, eventdata, handles)
% hObject    handle to std6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std6 as text
%        str2double(get(hObject,'String')) returns contents of std6 as a double


% --- Executes during object creation, after setting all properties.
function std6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function std7_Callback(hObject, eventdata, handles)
% hObject    handle to std7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std7 as text
%        str2double(get(hObject,'String')) returns contents of std7 as a double


% --- Executes during object creation, after setting all properties.
function std7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


