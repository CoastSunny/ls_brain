function varargout = oddballsequence(varargin)
% ODDBALLSEQUENCE M-file for oddballsequence.fig
%
% ODDBALLSEQUENCE is a graphical user interface for creating a
% sequence file using the Oddball paradigm.


% Last Modified by GUIDE v2.5 14-Nov-2007 18:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oddballsequence_OpeningFcn, ...
                   'gui_OutputFcn',  @oddballsequence_OutputFcn, ...
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

% --- Executes just before oddballsequence is made visible.
function oddballsequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to oddballsequence (see VARARGIN)

% Choose default command line output for oddballsequence
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
% 222 is for stimulus name and probability settings with categories.
% 23 is for stimuli between stimuli & ignored stimuli settings (adv.)
% 233 is for stimuli between stimuli settings with categories.
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
handles.this_cat = 1;

show_state1(handles);
guidata(hObject, handles);

% UIWAIT makes oddballsequence wait for user response (see UIRESUME)
% uiwait(handles.oddballsequence);


% --- Outputs from this function are returned to the command line.
function varargout = oddballsequence_OutputFcn(hObject, eventdata, handles)
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
    
    %% If user uses categories:
    if (get(handles.catbox,'Value'))
      handles.previous_state = handles.state;
      handles.state = 222;
      totalstim = (str2num(get(handles.numofstd,'String')) + ...
		   str2num(get(handles.numofdev,'String'))) * ...
	  str2num(get(handles.numofcat,'String'));
      
      for i = 1:totalstim
	handles.codes(i) = i;
      end
      
      avprob = tune_std_probability(handles);
      handles.std_probabilities(handles.numofstdnames) = avprob;
      handles.std_probability_left = handles.std_probability_left - ...
	  avprob;
      set (handles.stimulustag,'String','Standard 1');
      set (handles.titletag,'String','Name selection - Category 1');
      show_state22(handles);
      guidata(hObject, handles);
      
    else
      %% No categories:
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
 
 case 222
  
  % If user has input all the stimulus names, the new state is 3.
  % If user has input all stimulus names of one category, a new 
  % category is shown.
  
  stdincat = str2double(get(handles.numofstd,'String'));
  devincat = str2double(get(handles.numofdev,'String'));
  cats = str2double(get(handles.numofcat,'String'));
  
  if (handles.numofstdnames == 0)
    handles.numofstdnames = 1;
  end
  
  %% DEV -> STATE23
  if (handles.numofdevnames == devincat ...
      & handles.this_cat == cats)
    if (isempty(handles.devnames) | ...
	length(handles.devnames) < handles.numofdevnames+devincat* ...
	(handles.this_cat-1))
      devname = ['Deviant', num2str(handles.numofdevnames+devincat* ...
				    (handles.this_cat-1))];
      
      handles.devnames{handles.numofdevnames+devincat*(handles.this_cat-1)} = devname;
      set(handles.stimulus,'String',devname);
    end
    if (isempty(handles.codes) | length(handles.codes) < cats*stdincat ...
	+ cats*devincat)
      handles.codes(cats*stdincat + (handles.this_cat-1)*devincat + ...
		    handles.numofdevnames) = handles.codecounter;
    end
    handles.previous_state = handles.state;
    handles.state = 23;
    hide_state22(handles);
    set(handles.titletag,'String','Oddball sequence');
    show_state233(handles);
  else
    
    %% CAT++
    if (handles.numofdevnames == devincat)
      if (isempty(handles.devnames) | length(handles.devnames) < ...
	  handles.numofdevnames + devincat*(handles.this_cat-1))
	devname = ['Deviant', num2str(handles.numofdevnames+devincat*(handles.this_cat-1))];
	handles.devnames{handles.numofdevnames+devincat*(handles.this_cat-1)} = devname;
      end

      if (isempty(handles.codes) | length(handles.codes) < ...
	  handles.numofdevnames + handles.numofstdnames+devincat*(handles.this_cat-1)+stdincat*(handles.this_cat-1))
	handles.codes(handles.numofstdnames+handles.numofdevnames - ...
		      1+stdincat*(handles.this_cat-1)+devincat*(handles.this_cat-1)) = handles.codecounter;
	handles.codecounter = handles.codecounter + 1;
	set(handles.code,'String',[]); 	  
      end
      handles.numofstdnames = 1;
      handles.numofdevnames = 0;
      handles.this_cat = handles.this_cat + 1;
      avprob = tune_std_probability(handles);
      handles.std_probabilities(handles.numofstdnames+stdincat*(handles.this_cat-1)) = avprob;
      handles.std_probability_left = handles.std_probability_left - ...
	  avprob;
      set(handles.stimulustag,'String','Standard 1');
      set(handles.titletag,'String',['Name selection - Category' num2str(handles.this_cat)]);

      if ~(isempty(handles.stdnames))
	if (length(handles.stdnames) >= handles.numofstdnames+stdincat*(handles.this_cat-1))
	  set(handles.stimulus,'String', ...
			    handles.stdnames{handles.numofstdnames+stdincat*(handles.this_cat-1)});
	else
	  set(handles.stimulus,'String',[]);
	end
      else
	set(handles.stimulus,'String',[]);
      end

      
    else      
    
      %% STD -> DEV
      if (handles.numofstdnames >= stdincat)
	if (handles.numofdevnames == 0)
	  handles.numofdevnames = handles.numofdevnames + 1;

	  avprob = tune_dev_probability(handles);
	  handles.dev_probabilities(handles.numofdevnames+devincat*(handles.this_cat-1)) = avprob;
	  handles.dev_probability_left = handles.dev_probability_left - avprob;
  
	  if (isempty(handles.stdnames) | length(handles.stdnames) < ...
	      stdincat*(handles.this_cat-1)+handles.numofstdnames)
	    
	    stdname = ['Standard', num2str(handles.numofstdnames+ ...
					   stdincat*(handles.this_cat-1))];
	    handles.stdnames{handles.numofstdnames+stdincat*(handles.this_cat-1)} = stdname;
	  end
	  handles.numofstdnames = handles.numofstdnames + 1;
	  
	  set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(handles.numofdevnames)]);
	  if ~(isempty(handles.devnames))
	    if (length(handles.devnames) >= handles.numofdevnames+ ...
		devincat*(handles.this_cat-1))
	      
	      set(handles.stimulus,'String', ...
				handles.devnames{handles.numofdevnames+devincat*(handles.this_cat-1)});
	    else
	      set(handles.stimulus,'String',[]);
	    end
	  else
	    set(handles.stimulus,'String',[]);
	    
	  end
	  if (isempty(handles.codes) | length(handles.codes) < ...
	      handles.numofdevnames + handles.numofstdnames+devincat*(handles.this_cat-1)+stdincat*(handles.this_cat-1))
	    handles.codes(handles.numofstdnames+handles.numofdevnames - ...
			  1+stdincat*(handles.this_cat-1)+devincat*(handles.this_cat-1)) = handles.codecounter;
	    handles.codecounter = handles.codecounter + 1;
	    set(handles.code,'String',[]); 	  
	  else
	    set(handles.code,'String', ...
			     num2str(handles.codes(handles ...
						   .numofstdnames+ ...
						   handles ...
						   .numofdevnames++ ...
						   devincat* ...
						   (handles.this_cat- ...
						    1)+stdincat* ...
						   (handles.this_cat-1))))
	  end
	  
	  
	else
	  
	  %% DEV++
	  if (isempty(handles.devnames) | length(handles.devnames) < ...
	      handles.numofdevnames + devincat*(handles.this_cat-1))
	    devname = ['Deviant', num2str(handles.numofdevnames+devincat*(handles.this_cat-1))];
	    handles.devnames{handles.numofdevnames+devincat*(handles.this_cat-1)} = devname;
	  end
	  
	  handles.numofdevnames = handles.numofdevnames + 1;
	  
	  avprob = tune_dev_probability(handles);
	  handles.dev_probabilities(handles.numofdevnames+devincat*(handles.this_cat-1)) = avprob;
	  handles.dev_probability_left = handles.dev_probability_left - avprob;
	  
	  set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(handles.numofdevnames)]);
	  if ~(isempty(handles.devnames))
	    if (length(handles.devnames) >= handles.numofdevnames+devincat*(handles.this_cat-1))
	      set(handles.stimulus,'String', ...
				handles.devnames{handles.numofdevnames+devincat*(handles.this_cat-1)});
	    else
	      set(handles.stimulus,'String',[]);
	      
	    end
	  else
	    set(handles.stimulus,'String',[]);
	  end
	  if (isempty(handles.codes) | length(handles.codes) < ...
	      handles.numofdevnames + handles.numofstdnames-1+devincat*(handles.this_cat-1)+stdincat*(handles.this_cat-1))
	    handles.codes(handles.numofstdnames+handles.numofdevnames - ...
			  1+devincat*(handles.this_cat-1)+stdincat*(handles.this_cat-1)) = handles.codecounter;
	    handles.codecounter = handles.codecounter + 1;
	    set(handles.code,'String',[]);
	  else
	    set(handles.code,'String', ...
			     num2str(handles.codes(handles.numofstdnames-1 ...
						   + handles.numofdevnames+devincat*(handles.this_cat-1)+stdincat*(handles.this_cat-1))));
	  end
	  
	end
      else
	
	%%STD++
	if (isempty(handles.stdnames) | length(handles.stdnames) < ...
	    handles ...
	    .numofstdnames+stdincat*(handles.this_cat-1))
	  stdname = ['Standard', num2str(handles.numofstdnames+stdincat*(handles.this_cat-1))];
	  handles.stdnames{handles.numofstdnames+stdincat*(handles.this_cat-1)} = stdname;
	end
	
	handles.numofstdnames = handles.numofstdnames + 1;
	
	avprob = tune_std_probability(handles);
	handles.std_probabilities(handles.numofstdnames+stdincat*(handles.this_cat-1)) = avprob;
	handles.std_probability_left = handles.std_probability_left - avprob;
	
	set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
	if ~(isempty(handles.stdnames))
	  if (length(handles.stdnames) >= handles.numofstdnames+stdincat*(handles.this_cat-1))
	    set(handles.stimulus,'String', ...
			      handles.stdnames{handles.numofstdnames+stdincat*(handles.this_cat-1)});
	  else
	    set(handles.stimulus,'String',[]);
	  end
	else
	  set(handles.stimulus,'String',[]);
	  
	end
	if (isempty(handles.codes) | length(handles.codes) < ...
	    handles.numofstdnames+stdincat*(handles.this_cat-1))
	  handles.codes(handles.numofstdnames+stdincat*(handles.this_cat-1)) = handles.codecounter;
	  handles.codecounter = handles.codecounter + 1;
	  set(handles.code,'String',[]);	
	else
	  set(handles.code,'String', ...
			   num2str(handles.codes(handles.numofstdnames+stdincat*(handles.this_cat-1))));
	end
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
  close(handles.oddballsequence);
  
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
	seqprob = (100-str2double(get(handles.devprob,'String')))* ...
		  0.01*handles.std_probabilities(handles.numofstdnames);
	
	set(handles.seqprob,'String',num2str(seqprob));

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
	seqprob = (str2double(get(handles.devprob,'String')))*0.01*handles.dev_probabilities(handles.numofdevnames);
	set(handles.seqprob,'String',num2str(seqprob));
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

  
 case 222
  
  stdincat = str2double(get(handles.numofstd,'String'));
  devincat = str2double(get(handles.numofdev,'String'));
  cats = str2double(get(handles.numofcat,'String'));

  
  %% DEV -> STD
  if (handles.numofdevnames == 1)
    handles.numofdevnames = 0;
    handles.numofstdnames = handles.numofstdnames - 1;
    handles.dev_probability_left = handles.dev_probability_left + ...
	handles.dev_probabilities((handles.this_cat-1)*devincat+1);
    
    set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
    set(handles.stimulus,'String', ...
		      handles.stdnames{handles.numofstdnames+(handles.this_cat-1)*stdincat});
    set(handles.probability,'String', ...
		      num2str(handles.std_probabilities(handles.numofstdnames)));
    
    set(handles.code,'String', ...
		     num2str(handles.codes(stdincat*(handles.this_cat-1)+handles.numofstdnames)));
    
  else
    if (handles.numofstdnames == 1)
      %% STD -> STATE 1
      if (handles.this_cat == 1)
	hide_state22(handles);
	show_state1(handles);
	set(handles.titletag,'String','Oddball sequence');
	handles.state = 1;
	handles.previous_state = 0;
	handles.std_probability_left = 100;
	handles.dev_probability_left = 100;
	handles.dev_probabilities = [];
	handles.std_probabilities = [];
      
    
      %% CAT--
      else
	handles.this_cat = handles.this_cat - 1;
	handles.numofstdnames = stdincat+1;
	handles.numofdevnames = devincat;
	handles.std_probability_left = handles.std_probability_left ...
	    + handles.std_probabilities(stdincat*handles.this_cat+ ...
					1);
	set(handles.probability,'String', ...
			  num2str(handles.dev_probabilities(devincat* ...
						    handles.this_cat)));
	set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(devincat)]);
	set(handles.stimulus,'String', ...
			  handles.devnames{handles.numofdevnames+devincat*(handles.this_cat-1)});
	set(handles.code,'String', ...
			 num2str(handles.codes(devincat*handles.this_cat ...
					       + stdincat*handles.this_cat)));
	set(handles.titletag,'String',['Name selection - Category' num2str(handles.this_cat)]);
		
      end

      %% STD--
    else
      if (handles.numofdevnames == 0)
	
	handles.numofstdnames = handles.numofstdnames - 1;
	
	handles.std_probability_left = handles.std_probability_left + ...
	    handles.std_probabilities(handles.numofstdnames+(handles.this_cat-1)*stdincat);
	set(handles.probability,'String', ...
			  num2str(handles.std_probabilities(handles.numofstdnames)));
	set(handles.stimulustag,'String',['Standard ', ...
		    num2str(handles.numofstdnames)]);
	set(handles.stimulus,'String', ...
			  handles.stdnames{stdincat*(handles.this_cat-1)+handles.numofstdnames});
	
      else 
	%% DEV--
	handles.numofdevnames = handles.numofdevnames - 1;
	handles.dev_probability_left = handles.dev_probability_left + ...
	    handles.dev_probabilities(handles.numofdevnames+(handles.this_cat-1)*devincat);
	set(handles.probability,'String', ...
			  num2str(handles.dev_probabilities(handles.numofdevnames)));

	set(handles.stimulustag,'String',['Deviant ', ...
		    num2str(handles.numofdevnames)]);
	set(handles.stimulus,'String', ...
			  handles.devnames{devincat*(handles.this_cat-1)+handles.numofdevnames});
	set(handles.code,'String', ...
			 num2str(handles.codes(devincat*(handles.this_cat-1)+handles.numofdevnames)));
	
      end
    end
  end

  guidata(hObject, handles);
  
  
 case 23
  hide_state23(handles);
  show_state22(handles);
  if (handles.previous_state == 22)
    handles.state = 22;
    handles.previous_state = 1;
  else
    handles.state = 222;
    handles.previous_state = 1;
    set(handles.titletag,'String',['Name selection - Category' num2str(handles.this_cat)]);
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

set(handles.titletag,'String','Creating the sequence...');
set(handles.titletag,'Visible','on');

numofseqfiles = str2double(get(handles.numofseqfiles,'String'));

hide_program_selection(handles);

% The default filename:
if ~(isfield(handles,'filenamevalue'))
  handles.filenamevalue = 'oddballseq';
end

probabilities(1) = str2double(get(handles.devprob,'String'));

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
  if (get(handles.catbox,'Value'))
    stimuli{2,1} = str2double(get(handles.numofcat,'String'));
  end
  probabilities(2) = length(handles.stdnames);
  probabilities(3) = length(handles.devnames);
  minstim(1) = str2double(get(handles.minstimbetdev,'String'));
  minstim(2) = str2double(get(handles.minstimbetstd,'String'));
  minstim(3) = str2double(get(handles.numofstimignored,'String'));
  % stimuli ignored in the beginning (code set to 0)
  minstim(4) = str2double(get(handles.begignore,'String'));
  % number of sequence files
  minstim(5) = str2double(get(handles.numofseqfiles,'String'));  
  % which sequence file is being created
  minstim(6) = 1;
  
  for i = 1:length(handles.stdnames)
    probabilities(i+3) = handles.std_probabilities(i);
  end
  for i = 1:length(handles.devnames)
    probabilities(i+length(handles.stdnames)+3) = ...
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
  fid = fopen(lower([cd,file_out]),'wt');
  fprintf(fid,options_string);
  fclose(fid);
  
  % Sequence is created.
  result = oddball(stimuli, handles.soaminvalue, handles.soamaxvalue, ...
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
statistics1 = ['The probability of a deviant stimulus in sequence' ...
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
close(handles.oddballsequence);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.oddballsequence);



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

% Hint: get(hObject,'Value') returns toggle state of ptbradio

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
set(handles.catbox,'Visible','off');
hide_cat(handles);


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
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.probabilitytag,'Visible','off');
set(handles.probabilitytag2,'Visible','off');
set(handles.probability,'Visible','off');
set(handles.seqprobtag,'Visible','off');
set(handles.seqprobtag2,'Visible','off');
set(handles.seqprob,'Visible','off');
set(handles.devprobtag,'Visible','on');
set(handles.devprob,'Visible','on');
hide_cat(handles);
set(handles.numofstdtag,'String','One standard stimulus.');
set(handles.numofdevtag,'String','One deviant stimulus.');
set(handles.devprobtag,'String',['Probability of the deviant stimulus' ...
		    ' (0-100)']);
set(handles.catbox,'Visible','off');



% --- Shows the advanced options components.
function show_advanced_options(handles)

set(handles.numofstdtag,'String',['Number of different standard' ...
		    ' stimuli']);
set(handles.numofdevtag,'String',['Number of different deviant' ...
		    ' stimuli']);
set(handles.devprobtag,'String',['Total probability of deviants in' ...
		    ' the sequence (0-100)']);
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
set(handles.seqprobtag,'Visible','off');
set(handles.seqprobtag2,'Visible','off');
set(handles.seqprob,'Visible','off');
set(handles.devprobtag,'Visible','on');
set(handles.devprob,'Visible','on');
set(handles.catbox,'Visible','on');


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


% --- Shows category settings.
function show_cat(handles)

set(handles.numofstdtag,'String','Standard stimuli in a category');
set(handles.numofdevtag,'String','Deviant stimuli in a category');
set(handles.numofcattag,'Visible','on');
set(handles.numofcat,'Visible','on');


% --- Hides category settings.
function hide_cat(handles)


set(handles.numofstdtag,'String',['Number of different standard' ...
		    ' stimuli']);
set(handles.numofdevtag,'String',['Number of different deviant' ...
		    ' stimuli']);
set(handles.numofcattag,'Visible','off');
set(handles.numofcat,'Visible','off');




% --- Shows GUI components of state 1
function show_state1(handles)
if (handles.advanced)
  if (get(handles.catbox,'Value'))
    show_cat(handles);
  else
    hide_cat(handles);
  end
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
set(handles.seqprobtag,'Visible','on');
set(handles.seqprobtag2,'Visible','on');
set(handles.seqprob,'Visible','on');
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
set(handles.seqprobtag,'Visible','off');
set(handles.seqprobtag2,'Visible','off');
set(handles.seqprob,'Visible','off');
hide_code_selection(handles);


% --- Shows GUI components of state 23
function show_state23(handles)
set(handles.minstimbetdevtag,'Visible','on');
set(handles.minstimbetstdtag,'Visible','on');
set(handles.minstimbetdev,'Visible','on');
set(handles.minstimbetstd,'Visible','on');
set(handles.numofstimignored,'Visible','on');
set(handles.numofstimignoredtag,'Visible','on');
set(handles.begignoretag,'Visible','on');
set(handles.begignore,'Visible','on');
set(handles.minstimbetstdtag,'String',['Minimum number of' ...
		    ' stimuli between two same standards']);


% --- Hides GUI components of state 23
function hide_state23(handles)
set(handles.minstimbetdevtag,'Visible','off');
set(handles.minstimbetstdtag,'Visible','off');
set(handles.minstimbetdev,'Visible','off');
set(handles.minstimbetstd,'Visible','off');
set(handles.numofstimignoredtag,'Visible','off');
set(handles.numofstimignored,'Visible','off');
set(handles.begignoretag,'Visible','off');
set(handles.begignore,'Visible','off');


% --- Shows GUI components of state 233
function show_state233(handles)
set(handles.minstimbetdevtag,'Visible','on');
set(handles.minstimbetstdtag,'Visible','on');
set(handles.minstimbetdev,'Visible','on');
set(handles.minstimbetstd,'Visible','on');
set(handles.numofstimignored,'Visible','on');
set(handles.numofstimignoredtag,'Visible','on');
set(handles.minstimbetstdtag,'String',['Minimum number of' ...
		    ' stimuli between two same class stimuli']);
set(handles.begignoretag,'Visible','on');
set(handles.begignore,'Visible','on');


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
  if (get(handles.catbox,'Value'))
    if (handles.numofstdnames == str2double(get(handles.numofstd, ...
						'String'))+1)
      handles.devnames{handles.numofdevnames+str2double(get(handles.numofdev,'String'))*(handles.this_cat-1)} = get(hObject, ...
						    'String');
    else
      handles.stdnames{handles.numofstdnames+str2double(get(handles.numofstd,'String'))*(handles.this_cat-1)} = get(hObject, ...
						    'String');
    end
  else
    if (handles.numofstdnames == str2double(get(handles.numofstd, ...
						'String'))+1)
      handles.devnames{handles.numofdevnames} = get(hObject, ...
						    'String');
    else
      handles.stdnames{handles.numofstdnames} = get(hObject, ...
						    'String');
    end
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
cats = str2double(get(handles.numofcat,'String'));

if (~get(handles.catbox,'Value'))
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
else
  
  if (handles.numofdevnames == 0)
    % "Probabilities left" are recalculated because the default
    % probability is changed.
    totalprob = 0;
    for i = 1:(stds*(handles.this_cat-1)+handles.numofstdnames - 1)
      totalprob = totalprob + handles.std_probabilities(i);
    end
    handles.std_probability_left = 100 - totalprob;
    
    if (input > handles.std_probability_left)
      set(hObject,'String',num2str(handles.std_probability_left))
      handles.std_probabilities(handles.numofstdnames+stds* ...
				(handles.this_cat-1)) = handles.std_probability_left;
      handles.std_probability_left = 0;
    else
      handles.std_probability_left = handles.std_probability_left - input;
      handles.std_probabilities(handles.numofstdnames+stds* ...
				(handles.this_cat-1)) = input;
    end
      
  else
    % "Probabilities left" are recalculated because the default
    % probability is changed.
    totalprob = 0;
    for i = 1:(stds*(handles.this_cat-1)+handles.numofdevnames - 1)
      totalprob = totalprob + handles.dev_probabilities(i);
    end
    handles.dev_probability_left = 100 - totalprob;
    
    if (input > handles.dev_probability_left)
      set(hObject,'String',num2str(handles.dev_probability_left))
      handles.dev_probabilities(handles.numofdevnames+devs* ...
				(handles.this_cat-1)) = handles.dev_probability_left;
      handles.dev_probability_left = 0;
    else
      handles.dev_probability_left = handles.dev_probability_left - input;
      handles.dev_probabilities(handles.numofdevnames+devs* ...
				(handles.this_cat-1)) = input;
    end
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

if (~get(handles.catbox,'Value'))  
  if (handles.numofstdnames > str2double(get(handles.numofstd, ...
					     'String')))
    handles.codes(handles.numofstdnames + handles.numofdevnames - 1) ...
      = str2double(get(hObject,'String'));
  else
    handles.codes(handles.numofstdnames + handles.numofdevnames) = ...
      str2double(get(hObject,'String'));
  end
else
  stds = str2double(get(handles.numofstd,'String'));
  devs = str2double(get(handles.numofdev,'String'));
  cats = str2double(get(handles.numofcat,'String'));
  if (handles.numofstdnames > str2double(get(handles.numofstd, ...
					     'String')))
    handles.codes((devs+stds)*(handles.this_cat-1)+handles.numofstdnames + handles.numofdevnames - 1) ...
      = str2double(get(hObject,'String'));
  else
    handles.codes((devs+stds)*(handles.this_cat-1)+handles.numofstdnames + handles.numofdevnames) = ...
      str2double(get(hObject,'String'));
  end
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
function minstimbetdev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minstimbetdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function minstimbetdev_Callback(hObject, eventdata, handles)
% hObject    handle to minstimbetdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minstimbetdev as text
%        str2double(get(hObject,'String')) returns contents of minstimbetdev as a double


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

cats = str2double(get(handles.numofcat,'String'));
devs = str2double(get(handles.numofdev,'String'));
stds = str2double(get(handles.numofstd,'String'));
devprob = str2double(get(handles.devprob,'String'));

if (get(handles.catbox,'Value'))
  numofstim = devs*cats;
  numofstimnames = (handles.this_cat-1)*devs+handles.numofdevnames;
else
  numofstim = str2double(get(handles.numofdev,'String'));
  numofstimnames = handles.numofdevnames;
end

set(handles.probabilitytag,'String','Probability among deviants');
avprob = handles.dev_probability_left / (numofstim - numofstimnames + 1);
set(handles.probability,'String',num2str(avprob));

seqprob = avprob*devprob*(0.01);
set(handles.seqprob,'String',num2str(seqprob));

y = avprob;


% --- Calculates the average probability for those stimuli, to
%     which no probability has yet been defined.
function y = tune_std_probability(handles)

cats = str2double(get(handles.numofcat,'String'));
devs = str2double(get(handles.numofdev,'String'));
stds = str2double(get(handles.numofstd,'String'));
devprob = str2double(get(handles.devprob,'String'));

if (get(handles.catbox,'Value'))
  numofstim = stds * cats;
  numofstimnames = (handles.this_cat-1)*stds + handles.numofstdnames;
else
  numofstim = str2double(get(handles.numofstd,'String'));
  numofstimnames = handles.numofstdnames;
end

set(handles.probabilitytag,'String','Probability among standards');
avprob = handles.std_probability_left / (numofstim - numofstimnames + 1);
set(handles.probability,'String',num2str(avprob));

seqprob = (100-devprob)*avprob*(0.01);
set(handles.seqprob,'String', num2str(seqprob));

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

opt = 'ODDBALL SEQUENCE SETTINGS\n\n';

if (handles.advanced & ~get(handles.catbox,'Value'))
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
  
  % Probability of deviant
  o1 = '\nProbability of deviant: ';
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
  
  % Minimum number of stimuli between deviants:
  o1 = '\nMinimum number of stimuli between two deviants: ';
  o2 = get(handles.minstimbetdev,'String');
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

else
  if (handles.advanced & get(handles.catbox,'Value'))
 
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
    
    % Probability of deviant
    o1 = '\nProbability of deviant: ';
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
    
    % Minimum number of stimuli between deviants:
    o1 = '\nMinimum number of stimuli between two deviants: ';
    o2 = get(handles.minstimbetdev,'String');
    opt = cat(2, opt, o1, o2);
    
    % Minimum number of stimuli between two same standards:
    if (get(handles.catbox,'Value'))
      o1 = ['\nMinimum number of stimuli between two same class' ...
	    ' stimuli: '];
    else
      o1 = '\nMinimum number of stimuli between two same standards: ';
    end
    o2 = get(handles.minstimbetstd,'String');
    opt = cat(2, opt, o1, o2);
    
    % Number of stimuli ignored after a deviant:
    o1 = '\nNumber of stimuli ignored after a deviant: ';
    o2 = get(handles.numofstimignored,'String');
    opt = cat(2, opt, o1, o2);
    
    % Stimuli:
    opt = cat(2, opt, '\n\nSTIMULI:\n\n');
    std = 1;
    dev = 1;
    stds = str2double(get(handles.numofstd,'String'));
    devs = str2double(get(handles.numofdev,'String'));
    cats = str2double(get(handles.numofcat,'String'));
    for i = 1:cats
      opt = cat(2, opt, 'Category ', num2str(i), ':\n\n\nStandards:', ...
		    '\n\n');
      std_a = std;
      for j = std_a:std_a+stds-1
	o1 = handles.stdnames{j};
	o2 = '\nProbability: ';
	o3 = num2str(handles.std_probabilities(j));
	o4 = '\nTrigger code: ';
	o5 = num2str(handles.codes(std+dev-1));
	o6 = '\n\n';
	opt = cat(2, opt, o1, o2, o3, o4, o5, o6);
	std = std + 1;
      end
      
      opt = cat(2, opt, 'Deviants:\n\n');
      
      dev_a = dev;
      for j = dev_a:dev_a+devs-1
	o1 = handles.devnames{j};
	o2 = '\nProbability: ';
	o3 = num2str(handles.dev_probabilities(j));
	o4 = '\nTrigger code: ';
	o5 = num2str(handles.codes(std+dev-1));
	o6 = '\n\n';
	opt = cat(2, opt, o1, o2, o3, o4, o5, o6);
	dev = dev + 1;
      end
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
    
    % Probability of deviant
    o1 = '\nProbability of deviant: ';
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
end

opt = cat(2, opt, '\n\n---END---');
optstring = opt;


% --- Executes on button press in catbox.
function catbox_Callback(hObject, eventdata, handles)
% hObject    handle to catbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of catbox
if (get(hObject,'Value'))
  show_cat(handles);
else
  hide_cat(handles);
end




% --- Executes during object creation, after setting all properties.
function numofcat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofcat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function numofcat_Callback(hObject, eventdata, handles)
% hObject    handle to numofcat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofcat as text
%        str2double(get(hObject,'String')) returns contents of numofcat as a double


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
  
 case 222
  web ['http://www.cbru.helsinki.fi/seqma/' ...
       ' oddballcategories2.html'] -browser
  
 case 23
  web 'http://www.cbru.helsinki.fi/seqma/oddballadvanced3.html' -browser  
  
 case 233
  web ['http://www.cbru.helsinki.fi/seqma/' ...
       'oddballcategories3.html'] -browser
  
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


