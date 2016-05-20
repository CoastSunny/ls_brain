function varargout = rovingsequence(varargin)
% ROVINGSEQUENCE M-file for rovingsequence.fig
%
% ROVINGSEQUENCE is a graphical user interface for creating a
% sequence file using the Roving standard paradigm.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rovingsequence_OpeningFcn, ...
                   'gui_OutputFcn',  @rovingsequence_OutputFcn, ...
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

% --- Executes just before rovingsequence is made visible.
function rovingsequence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rovingsequence (see VARARGIN)

% Choose default command line output for rovingsequence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% The unnecessary graphical components are hidden in the beginning.
show_simple_options(handles);
hide_code_selection(handles);
hide_program_selection(handles);
hide_property_names(handles);
hide_stimulus_file_name(handles);
hide_probability(handles);
hide_categorization(handles);
hide_finished(handles);
hide_grid(handles);
set(handles.subtitle,'Visible','off');
set(handles.directionbox,'Visible','off');

%% POSSIBLE STATES OF THE GUI:
% 0 is for simple options.
% 1 is for advanced options options.
% 22 is for property name selection.
% 23 is for property name and code selection.
% 232 is for directional code selection for properties.
% 24 is for stimulus name selection.
% 25 is for stimulus name selection and categorization.
% 26 is for stimulus name selection and code selection.
% 27 is for stimulus name and code selection (by preceding repetitions).
% 3 is for program format and sequence file name settings.

% The simple options are shown in the beginning.

% The state of the program.
handles.state = 0;
% The previous state of the program.
handles.previous_state = 0;

% The default values for options:
%% Minimum SOA
handles.soaminvalue = 1.0;
%% Maximum SOA
handles.soamaxvalue = 1.0;
%% Minimum number of repetitions
handles.repminvalue = 5;
%% Maximum number of repetitions
handles.repmaxvalue = 10;
%% Number of repetitions before a stimulus becomes a standard
handles.rep2stdvalue = 2;
%% Total number of stimuli wanted (approximative)
handles.totalstimvalue = 100;

% stimnames contains the stimulus names.
handles.stimnames = {};

% catnames contains the property names.
handles.catnames = {};

% stimuluscats contains the stimulus categorization matrix.
handles.stimuluscats = [];

% probabilities contains the stimulus probabilities.
handles.probabilities = [];

% catcodes contains the trigger codes for different properties.
handles.catcodes = [];

% stimcodes contains the trigger codes for different stimuli.
handles.stimcodes = [];

% numofstimnames is the number of stimulus names input by user.
handles.numofstimnames = 1;

% nunmofcatnames is the number of property names input by user.
handles.numofcatnames = 1;

% probability_left is the amount of percents user has left to
% allocate for stimuli. It decreases step by step by when user
% allocates probabilities for stimuli.
handles.probability_left = 100;

% A note string is not displayed in the beginning:
handles.active_note = 0;
set(handles.notetext,'Visible','off');

guidata(hObject, handles);

% UIWAIT makes rovingsequence wait for user response (see UIRESUME)
% uiwait(handles.rovingsequence);


% --- Outputs from this function are returned to the command line.
function varargout = rovingsequence_OutputFcn(hObject, eventdata, handles)
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

  
% LIS?? LAITTOMIEN ARVOJEN TARKASTUS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (handles.active_note)
  handles.active_note = 0;
else
  set(handles.notetext,'Visible','off');
end

switch handles.state
    
 case 0
  handles.soamaxvalue = handles.soaminvalue;
  set(handles.soamax,'string',get(handles.soamin,'string'));
  handles.repmaxvalue = handles.repminvalue;
  set(handles.repmax,'string',get(handles.repmin,'string'));
  handles.previous_state = handles.state;
  handles.previous_state = handles.state;
  handles.state = 24;
  hide_options(handles);
  show_stimulus_file_name(handles);
  guidata(hObject, handles);
  
 case 1
  hide_options(handles);

  % If the user wants to set the trigger codes (no properties):
  if (get(handles.triggercodebox,'Value') & ...
      ~(get(handles.propertybox,'Value')))
    
    if (get(handles.repcodebox,'Value'))
      handles.previous_state = handles.state;
      handles.state = 27;
      show_stimulus_file_name(handles);
      if (get(handles.probabilitybox,'Value') == 1)
	avprob = tune_probability(handles);
	handles.probabilities(handles.numofstimnames) = avprob;
	handles.probability_left = handles.probability_left - avprob;
	show_probability(handles);
      end

      show_grid(handles.repminvalue, handles.repmaxvalue, handles);
    else
      handles.previous_state = handles.state;
      handles.state = 26;
      show_code_selection(handles);
      show_stimulus_file_name(handles);
      if (get(handles.probabilitybox,'Value') == 1)
	avprob = tune_probability(handles);
	handles.probabilities(handles.numofstimnames) = avprob;
	handles.probability_left = handles.probability_left - avprob;
	show_probability(handles);
      end
    end
  
  else 
    % If the user wants to use properties to categorize stimuli:
    if (get(handles.propertybox,'Value'))

      if(~(get(handles.triggercodebox,'Value')))
	% Default trigger codes
	handles.previous_state = handles.state;
	handles.state = 22;
	
	hide_options(handles);
	show_property_names(handles);
	
	guidata(hObject, handles);
      else
	
	% If the user does not care about the direction of change:
	if (~(get(handles.directionbox,'Value')))
	  % User defined trigger codes
	  handles.previous_state = handles.state;
	  handles.state = 23;
	  numofcat = str2double(get(handles.numofcat,'String'));
	  if (isempty(handles.catcodes))
	    handles.catcodes = zeros(numofcat, 5);
	  end
	  if (isempty(handles.catnames))
	    handles.catnames{numofcat}=[];
	  end
	  
	  hide_options(handles);
	  show_code_selection(handles);
	  show_one_property_name(handles);
	  guidata(hObject, handles);
	else
	  
	  % If the direction of change is important
	  handles.previous_state = handles.state;
	  handles.state = 22;
	  hide_options(handles);
	  show_property_names(handles);
	  guidata(hObject, handles);
	end
	
      end
    else
      % Just stimulus names
      handles.previous_state = handles.state;
      handles.state = 24;
      
      hide_options(handles);
      show_stimulus_file_name(handles);
      if (get(handles.probabilitybox,'Value') == 1)
	avprob = tune_probability(handles);
	handles.probabilities(handles.numofstimnames) = avprob;
	handles.probability_left = handles.probability_left - avprob;

	show_probability(handles);
      end
      guidata(hObject, handles);
    end
  end
  guidata(hObject, handles);

 case 22
  %The stimulus category array is initialized with zeros.
  handles.stimuluscats = zeros(str2double(get(handles.numofstim, ...
					      'string')), ...
			       str2double(get(handles.numofcat, ...
					      'string')));

  % If the next state is 25 (stimulus name and categorization):
  if (~(get(handles.directionbox,'Value')))
    handles.numofstimnames = 1;
    handles.previous_state = handles.state;
    handles.state = 25;
    hide_property_names(handles);
    show_stimulus_file_name(handles);
    if (get(handles.probabilitybox,'Value') == 1)
      avprob = tune_probability(handles);
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
      
      show_probability(handles);
    end
    show_categorization(handles);
    set(handles.prop1radio1,'Value',1);
    set(handles.prop1radio2,'Value',0);
    set(handles.prop2radio1,'Value',1);
    set(handles.prop2radio2,'Value',0);
    set(handles.prop3radio1,'Value',1);
    set(handles.prop3radio2,'Value',0);
    set(handles.prop4radio1,'Value',1);
    set(handles.prop4radio2,'Value',0);
    set(handles.prop5radio1,'Value',1);
    set(handles.prop5radio2,'Value',0);
    
    guidata(hObject, handles);
    
  else
    % If the next state is 232 (directional code selection)
    handles.previous_state = handles.state;
    handles.state = 232;
    numofcat = str2double(get(handles.numofcat,'String'));
    if (isempty(handles.catcodes))
      handles.catcodes = zeros(numofcat*2, 5);
    end
    if (isempty(handles.catnames))
      handles.catnames{numofcat}=[];
    end
    hide_property_names(handles);    
    show_code_selection(handles);
    set(handles.titletag,'String','Trigger code selection');
    set(handles.subtitle,'String',get_subtitle(handles));
    set(handles.subtitle,'Visible','on');
    guidata(hObject, handles);
  end
    
 case 23

  
  % If user has input all probability names, let's move to the
  % stimulus name and categorization phase (state 25):
  if (handles.numofcatnames == str2double(get(handles.numofcat, ...
					       'string')))

    if (isempty(get(handles.prop1name,'String')))
      propstr = ['Property' num2str(handles.numofcatnames)];
    else
      propstr = get(handles.prop1name,'String');
    end
    if (isempty(get(handles.prop1cat1name,'String')))
      cat1str = '1';
    else
      cat1str = get(handles.prop1cat1name,'String');
    end
    if (isempty(get(handles.prop1cat2name,'String')))
      cat2str = '2';
    else
      cat2str = get(handles.prop1cat2name,'String');
    end
    
    handles.catnames{handles.numofcatnames,1} = propstr;
    handles.catnames{handles.numofcatnames,2} = cat1str;
    handles.catnames{handles.numofcatnames,3} = cat2str;

    % The stimulus category array is initialized with zeros.
    handles.stimuluscats = zeros(str2double(get(handles.numofstim, ...
						'string')), ...
				 str2double(get(handles.numofcat, ...
						'string')));
    handles.previous_state = handles.state;
    handles.state = 25;
    handles.numofstimnames = 1;
    hide_property_names(handles);
    hide_code_selection(handles);

    codes = get_codes(handles);
    for i=1:length(codes)
      handles.catcodes(handles.numofcatnames,i) = codes(i);
    end

    show_stimulus_file_name(handles);
    if (get(handles.probabilitybox,'Value') == 1)
      avprob = tune_probability(handles);
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
      show_probability(handles);
    end
    show_categorization(handles);
    set(handles.prop1radio1,'Value',1);
    set(handles.prop1radio2,'Value',0);
    set(handles.prop2radio1,'Value',1);
    set(handles.prop2radio2,'Value',0);
    set(handles.prop3radio1,'Value',1);
    set(handles.prop3radio2,'Value',0);
    set(handles.prop4radio1,'Value',1);
    set(handles.prop4radio2,'Value',0);
    set(handles.prop5radio1,'Value',1);
    set(handles.prop5radio2,'Value',0);
    
    guidata(hObject, handles);
    
    
    % User is asked for codes for the next change:
  else
    
    codes = get_codes(handles);
    for i=1:length(codes)
      handles.catcodes(handles.numofcatnames,i) = codes(i);
    end
    if (isempty(get(handles.prop1name,'String')))
      propstr = ['Property' num2str(handles.numofcatnames)];
    else
      propstr = get(handles.prop1name,'String');
    end
    if (isempty(get(handles.prop1cat1name,'String')))
      cat1str = '1';
    else
      cat1str = get(handles.prop1cat1name,'String');
    end
    if (isempty(get(handles.prop1cat2name,'String')))
      cat2str = '2';
    else
      cat2str = get(handles.prop1cat2name,'String');
    end

    handles.catnames{handles.numofcatnames,1} = propstr;
    handles.catnames{handles.numofcatnames,2} = cat1str;
    handles.catnames{handles.numofcatnames,3} = cat2str;
    handles.numofcatnames = handles.numofcatnames + 1;
    set(handles.prop1num,'String',num2str(handles.numofcatnames));
    if (size(handles.catnames,1) >= handles.numofcatnames)
      set(handles.prop1name,'String', ...
			handles.catnames{handles.numofcatnames,1});
      set(handles.prop1cat1name,'String', ...
			handles.catnames{handles.numofcatnames,2});
      set(handles.prop1cat2name,'String', ...
			handles.catnames{handles.numofcatnames,3});
    else
      set(handles.prop1name,'String',[]);
      set(handles.prop1cat1name,'String',[]);
      set(handles.prop1cat2name,'String',[]);
    end

    if (size(handles.catcodes,2)==5)
      if (size(handles.catcodes,1) >= handles.numofcatnames)
	set_devcodes(handles.catcodes(handles.numofcatnames,1),handles);
	set_firstafterdevcodes(handles.catcodes(handles.numofcatnames,2),handles);
	set_repbeforestdcodes(handles.catcodes(handles.numofcatnames,3),handles);
	set_stdcodes(handles.catcodes(handles.numofcatnames,4),handles);
	set_laststdcodes(handles.catcodes(handles.numofcatnames,5),handles);
      end
    end
    
    guidata(hObject, handles);
  end


 case 232
  
  % If user has input all directional codes, let's move to the
  % stimulus name and categorization phase (state 25):
  if (handles.numofcatnames == 2*str2double(get(handles.numofcat, ...
					       'string')))

    % The stimulus category array is initialized with zeros.
    handles.stimuluscats = zeros(str2double(get(handles.numofstim, ...
						'string')), ...
				 str2double(get(handles.numofcat, ...
						'string')));
    handles.previous_state = handles.state;
    handles.state = 25;
    handles.numofstimnames = 1;
    hide_code_selection(handles);
    set(handles.subtitle,'Visible','off');

    codes = get_codes(handles);
    for i=1:length(codes)
      handles.catcodes(handles.numofcatnames,i) = codes(i);
    end

    show_stimulus_file_name(handles);
    if (get(handles.probabilitybox,'Value') == 1)
      avprob = tune_probability(handles);
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
      show_probability(handles);
    end
    show_categorization(handles);
    set(handles.prop1radio1,'Value',1);
    set(handles.prop1radio2,'Value',0);
    set(handles.prop2radio1,'Value',1);
    set(handles.prop2radio2,'Value',0);
    set(handles.prop3radio1,'Value',1);
    set(handles.prop3radio2,'Value',0);
    set(handles.prop4radio1,'Value',1);
    set(handles.prop4radio2,'Value',0);
    set(handles.prop5radio1,'Value',1);
    set(handles.prop5radio2,'Value',0);

    guidata(hObject, handles);
    
    
    % User is asked for next codes:
  else

    codes = get_codes(handles);
    for i=1:length(codes)
      handles.catcodes(handles.numofcatnames,i) = codes(i);
    end

    handles.numofcatnames = handles.numofcatnames + 1;
    set(handles.subtitle,'String',get_subtitle(handles));
    guidata(hObject, handles);
  end
  
  
 case 24
  if (handles.numofstimnames == str2double(get(handles.numofstim, ...
					       'String')))
    
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      stimname = ['stim', num2str(handles.numofstimnames)];
      handles.stimnames{handles.numofstimnames} = stimname;
      set(handles.stimulusfile,'string',stimname);
      guidata(hObject, handles);
    end
    
    handles.previous_state = handles.state;
    handles.state = 3;
    hide_stimulus_file_name(handles);
    hide_probability(handles);
    show_program_selection(handles);
    guidata(hObject, handles);
    
  else
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      handles.stimnames{handles.numofstimnames} = ['stim' ...
		    num2str(handles.numofstimnames)];
      guidata(hObject, handles);
    end
    
    handles.numofstimnames = handles.numofstimnames + 1;
    if (get(handles.probabilitybox,'Value') == 1)
      avprob = tune_probability(handles);
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
    end
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    if ~(isempty(handles.stimnames))
      if (length(handles.stimnames) >= handles.numofstimnames)
	set(handles.stimulusfile,'string', ...
			  handles.stimnames{handles.numofstimnames});
      else
	set(handles.stimulusfile,'string',[]);    
      end
    else
      set(handles.stimulusfile,'string',[]);
    end
  end
  guidata(hObject, handles);
  
 case 25
  if (handles.numofstimnames == str2double(get(handles.numofstim, ...
					       'string')))
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      handles.stimnames{handles.numofstimnames} = ['stim' ...
		    num2str(handles.numofstimnames)];
      guidata(hObject, handles);
    end

    % If category for some property would be 0, it means it has not 
    % been changed since the beginning and thus it actually is 1.
    for i=1:str2double(get(handles.numofcat,'String'))
      if (handles.stimuluscats(handles.numofstimnames,i)) == 0
	handles.stimuluscats(handles.numofstimnames,i) = 1;
      end
    end
    
    handles.previous_state = handles.state;
    handles.state = 3;
    hide_stimulus_file_name(handles);
    hide_categorization(handles);
    hide_probability(handles);
    show_program_selection(handles);
    guidata(hObject, handles);
    
  else
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      handles.stimnames{handles.numofstimnames} = ['stim' ...
		    num2str(handles.numofstimnames)];
      guidata(hObject, handles);
    end

    % If category for some property would be 0, it means it has not 
    % been changed since the beginning and thus it actually is 1.
    for i=1:str2double(get(handles.numofcat,'String'))
      if (handles.stimuluscats(handles.numofstimnames,i)) == 0
	handles.stimuluscats(handles.numofstimnames,i) = 1;
      end
    end

    handles.numofstimnames = handles.numofstimnames + 1;
    if (get(handles.probabilitybox,'Value') == 1)
      avprob = tune_probability(handles);
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
    end
    set(handles.prop1radio1,'Value',1);
    set(handles.prop1radio2,'Value',0);
    set(handles.prop2radio1,'Value',1);
    set(handles.prop2radio2,'Value',0);
    set(handles.prop3radio1,'Value',1);
    set(handles.prop3radio2,'Value',0);
    set(handles.prop4radio1,'Value',1);
    set(handles.prop4radio2,'Value',0);
    set(handles.prop5radio1,'Value',1);
    set(handles.prop5radio2,'Value',0);
    set(handles.stimulusfiletag,'String',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    if ~(isempty(handles.stimnames))
      if (length(handles.stimnames) >= handles.numofstimnames)
	set(handles.stimulusfile,'String', ...
			  handles.stimnames{handles.numofstimnames});
      else
	set(handles.stimulusfile,'String',[]);    
      end
    else
      set(handles.stimulusfile,'String',[]);    
    end
  end
  guidata(hObject, handles);

 case 26
  if (handles.numofstimnames == str2double(get(handles.numofstim, ...
					       'string')))
    
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      stimname = ['stim', num2str(handles.numofstimnames)];
      handles.stimnames{handles.numofstimnames} = stimname;
      set(handles.stimulusfile,'string',stimname);
      guidata(hObject, handles);
    end
    codes = get_codes(handles);
    for i=1:length(codes)
      handles.stimcodes(handles.numofstimnames,i) = codes(i);
    end
    handles.previous_state = handles.state;
    handles.state = 3;
    hide_stimulus_file_name(handles);
    hide_probability(handles);
    hide_code_selection(handles);
    show_program_selection(handles);
    guidata(hObject, handles);
    
  else
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      handles.stimnames{handles.numofstimnames} = ['stim' ...
		    num2str(handles.numofstimnames)];
      guidata(hObject, handles);
    end
    codes = get_codes(handles);
    for i=1:length(codes)
      handles.stimcodes(handles.numofstimnames,i) = codes(i);
    end
    handles.numofstimnames = handles.numofstimnames + 1;
    avprob = tune_probability(handles);
    if (get(handles.probabilitybox,'Value') == 1)
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
    end
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    if ~(isempty(handles.stimnames))
      if (length(handles.stimnames) >= handles.numofstimnames)
	set(handles.stimulusfile,'string', ...
			  handles.stimnames{handles.numofstimnames});
      else
	set(handles.stimulusfile,'string',[]);    
	guidata(hObject, handles);
      end
    else
      set(handles.stimulusfile,'string',[]);
    end
  end
  guidata(hObject, handles);

 
 case 27
  if (handles.numofstimnames == str2double(get(handles.numofstim, ...
					       'string')))
    
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      stimname = ['stim', num2str(handles.numofstimnames)];
      handles.stimnames{handles.numofstimnames} = stimname;
      set(handles.stimulusfile,'string',stimname);
      guidata(hObject, handles);
    end
    codes = get_codes(handles);
    for i=1:5
      for j=1:21
	handles.stimcodes(handles.numofstimnames,i,j) = codes(i,j);
      end
    end
    handles.previous_state = handles.state;
    handles.state = 3;
    hide_stimulus_file_name(handles);
    hide_probability(handles);
    hide_grid(handles);
    show_program_selection(handles);
    guidata(hObject, handles);
    
  else
    % If user has not input any name for a stimulus, StimX is used
    % as a stimulus name, where X is the number of order of the stimulus.
    if (isempty(handles.stimnames) | length(handles.stimnames) < ...
	handles.numofstimnames)      
      handles.stimnames{handles.numofstimnames} = ['stim' ...
		    num2str(handles.numofstimnames)];
      guidata(hObject, handles);
    end
    codes = get_codes(handles);
    for i=1:5
      for j=1:21
	handles.stimcodes(handles.numofstimnames,i,j) = codes(i,j);
      end
    end
    handles.numofstimnames = handles.numofstimnames + 1;
    avprob = tune_probability(handles);
    if (get(handles.probabilitybox,'Value') == 1)
      handles.probabilities(handles.numofstimnames) = avprob;
      handles.probability_left = handles.probability_left - avprob;
    end
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    if ~(isempty(handles.stimnames))
      if (length(handles.stimnames) >= handles.numofstimnames)
	set(handles.stimulusfile,'string', ...
			  handles.stimnames{handles.numofstimnames});
      else
	set(handles.stimulusfile,'string',[]);    
	guidata(hObject, handles);
      end
    else
      set(handles.stimulusfile,'string',[]);
    end
  end
  guidata(hObject, handles);
  
end


% --- Executes on button press in backbutton.
function backbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backbutton (see GCBO)
% eventdata  reserved - to be defined in a futur  else


if (handles.active_note)
  handles.active_note = 0;
else
  set(handles.notetext,'Visible','off');
end


switch handles.state

 case 0
  seqma;
  close(handles.rovingsequence);
  
 case 1
  seqma;
  close(handles.rovingsequence);

 case 21
  show_advanced_options(handles);
  hide_code_selection(handles);
  handles.state = 1;
  handles.previous_state = 0;
  guidata(hObject, handles);

 case 22
  handles.numofstimnames = 1;
  hide_property_names(handles);
  show_advanced_options(handles);
  handles.state = 1;
  handles.previous_state = 0;
  guidata(hObject, handles);


 case 23
  if (handles.numofcatnames <= 1)  
    handles.numofcatnames = 1;
    handles.state = 1;
    handles.previous_state = 0;
    hide_property_names(handles);
    hide_code_selection(handles);
    show_advanced_options(handles);
    
  else
    handles.numofcatnames = handles.numofcatnames - 1;
    set(handles.prop1num,'String',num2str(handles.numofcatnames));
    set(handles.prop1name,'String', ...
		      handles.catnames{handles.numofcatnames,1});
    set(handles.prop1cat1name,'String', ...
		      handles.catnames{handles.numofcatnames,2});
    set(handles.prop1cat2name,'String', ...
		      handles.catnames{handles.numofcatnames,3});
    set_devcodes(handles.catcodes(handles.numofcatnames,1),handles);
    set_firstafterdevcodes(handles.catcodes(handles.numofcatnames,2),handles);
    set_repbeforestdcodes(handles.catcodes(handles.numofcatnames,3),handles);
    set_stdcodes(handles.catcodes(handles.numofcatnames,4),handles);
    set_laststdcodes(handles.catcodes(handles.numofcatnames,5),handles);
    
  end
  guidata(hObject, handles);

 case 232
  if (handles.numofcatnames <= 1)  
    handles.numofcatnames = 1;
    handles.state = 22;
    handles.previous_state = 1;
    set(handles.subtitle,'Visible','off');
    hide_code_selection(handles);
    show_property_names(handles);
    
  else
    handles.numofcatnames = handles.numofcatnames - 1;
    set(handles.subtitle,'String',get_subtitle(handles));
    
  end
  guidata(hObject, handles);
  
  
 case 24
  if (handles.numofstimnames <= 1)  
    handles.numofstimnames = 1;
    handles.state = handles.previous_state;
    handles.previous_state = 1;
    hide_stimulus_file_name(handles);
    hide_probability(handles);
    handles.probability_left = 100;
    handles.probabilities = [];
    if (handles.state == 0)
      show_simple_options(handles);
      handles.previous_state = 0;
    end
    if(handles.state == 1)
      show_advanced_options(handles);
      handles.previous_state = 0;
    end
    if (handles.state == 21)
      show_code_selection(handles);
    end
    if (handles.state == 22)
      show_property_names(handles);
    end
    if (handles.state == 23);
      show_property_names(handles);
      show_code_selection(handles);
    end
    
  else
    if (get(handles.probabilitybox,'Value'))
      handles.probability_left = handles.probability_left + ...
	  handles.probabilities(handles.numofstimnames);
      set(handles.probability,'string', ...
			num2str(handles.probabilities(handles ...
						      .numofstimnames)));
    end
    handles.numofstimnames = handles.numofstimnames - 1;
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    set(handles.stimulusfile,'string', ...
		      handles.stimnames{handles.numofstimnames});
    
    
  end
  guidata(hObject, handles);

 case 25
  if (handles.numofstimnames <= 1)
    handles.state = handles.previous_state;
    handles.previous_state = 1;
    hide_stimulus_file_name(handles);
    hide_categorization(handles);
    if (handles.state == 23)
      show_code_selection(handles);
      show_one_property_name(handles);
    end
    if (handles.state == 22)
      show_property_names(handles);
    end
    if (handles.state == 232)
      show_code_selection(handles);
      set(handles.subtitle,'Visible','on');
    end
    
  else
    handles.numofstimnames = handles.numofstimnames - 1;
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    set(handles.stimulusfile,'string', ...
		      handles.stimnames{handles.numofstimnames});
    set_property_radios(handles);
  end
  guidata(hObject, handles);


 case 26
  if (handles.numofstimnames <= 1)
    handles.numofstimnames = 1;
    handles.state = handles.previous_state;
    handles.previous_state = 1;
    hide_stimulus_file_name(handles);
    hide_code_selection(handles);
    hide_probability(handles);
    handles.probability_left = 100;
    handles.probabilities = [];
    if (handles.state == 0)
      show_simple_options(handles);
      handles.previous_state = 0;
    end
    if(handles.state == 1)
      show_advanced_options(handles);
      handles.previous_state = 0;
    end
    if (handles.state == 22)
      show_property_names(handles);
    end
    if (handles.state == 23);
      show_property_names(handles);
      show_code_selection(handles);
    end
    
  else
    if (get(handles.probabilitybox,'Value'))
      handles.probability_left = handles.probability_left + ...
	  handles.probabilities(handles.numofstimnames);
      set(handles.probability,'string', ...
			num2str(handles.probabilities(handles ...
						      .numofstimnames)));
    end
    handles.numofstimnames = handles.numofstimnames - 1;
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    set(handles.stimulusfile,'string', ...
		      handles.stimnames{handles.numofstimnames});
    
  end
  guidata(hObject, handles);

  
 case 27
  if (handles.numofstimnames <= 1)  
    handles.numofstimnames = 1;
    handles.state = handles.previous_state;
    handles.previous_state = 1;
    hide_stimulus_file_name(handles);
    hide_grid(handles);
    hide_probability(handles);
    handles.probability_left = 100;
    handles.probabilities = [];
    show_advanced_options(handles);
    handles.previous_state = 0;
    
  else
    if (get(handles.probabilitybox,'Value'))
      handles.probability_left = handles.probability_left + ...
	  handles.probabilities(handles.numofstimnames);
      set(handles.probability,'string', ...
			num2str(handles.probabilities(handles ...
						      .numofstimnames)));
    end
    handles.numofstimnames = handles.numofstimnames - 1;
    set(handles.stimulusfiletag,'string',['Stimulus ' ...
		    num2str(handles.numofstimnames)]);
    set(handles.stimulusfile,'string', ...
		      handles.stimnames{handles.numofstimnames});
    set_grid_codes(handles);
  end
  guidata(hObject, handles);

  
 case 3
  hide_program_selection(handles);
  if (handles.previous_state == 0)
    show_simple_options(handles);
    handles.state = 0;
  end
  if (handles.previous_state == 1)
    show_advanced_options(handles);
    handles.state = 1;
  end
  if (handles.previous_state == 24)
    show_stimulus_file_name(handles);
    if (get(handles.probabilitybox,'Value'))
      show_probability(handles);
    end
    handles.state = 24;
    handles.previous_state = 0;
  end
  if (handles.previous_state == 25)
    show_stimulus_file_name(handles);
    show_categorization(handles);
    if (get(handles.probabilitybox,'Value'))
      show_probability(handles);
    end
    handles.state = 25;
    if (get(handles.triggercodebox,'Value'))
      if (get(handles.directionbox,'Value'))
	handles.previous_state = 232;
      else	
	handles.previous_state = 23;
      end
    else
      handles.previous_state = 22;
    end
  end
  if (handles.previous_state == 26)
    show_code_selection(handles);
    show_stimulus_file_name(handles);
    if (get(handles.probabilitybox,'Value'))
      show_probability(handles);
    end
    handles.state = 26;
    handles.previous_state = 1;
  end
  if (handles.previous_state == 27)
    show_grid(handles.repminvalue, handles.repmaxvalue, handles);
    show_stimulus_file_name(handles);
    if (get(handles.probabilitybox,'Value'));
      show_probability(handles);
    end
    handles.state = 27;
    handles.previous_state = 1;
  end
  
  guidata(hObject, handles);
  
end


% --- Executes on button press in finishbutton.
function finishbutton_Callback(hObject, eventdata, handles)
% hObject    handle to finishbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (handles.active_note)
  handles.active_note = 0;
else
  set(handles.notetext,'Visible','off');
end

numofseqfiles = str2double(get(handles.numofseqfiles,'String'));

% If user has not defined own trigger codes, the defaults are used:
if (isempty(handles.catcodes))
  if (isempty(handles.stimcodes))
    if (get(handles.propertybox,'Value'))
      i = 1;
      for j = 1:str2double(get(handles.numofcat,'String'))
	for k = 1:5
	  codes(j,k) = i;
	  i = i+1;
	end
      end
      handles.catcodes = codes;
    else
      i = 1;
      for j = 1:str2double(get(handles.numofstim,'String'))
	for k = 1:5
	  if (get(handles.repcodebox,'Value'))
	    for m = handles.repminvalue:handles.repmaxvalue
	      codes(j,k,m) = i;
	      i = i+1;
	    end
	  else
	    codes(j,k) = i;
	    i = i+1;
	  end
	end
      end
      handles.stimcodes = codes;
    end
  else
    % If user has defined own trigger codes for stimuli:    
    codes = handles.stimcodes;
  end
else
  % If user has defined own trigger codes for properties:  
  codes = handles.catcodes;
end


% The default filename:
if ~(isfield(handles,'filenamevalue'))
  handles.filenamevalue = 'roving';
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

h = waitbar(0,'Creating the sequence...');

if (numofseqfiles == 1)

  % Settings are written to an ascii file <filename>.txt
  options_string = get_options(handles);
  file_out = [handles.filenamevalue, '.txt'];
  fid = fopen(lower([cd,'/',file_out]),'wt');
  fprintf(fid,options_string);
  fclose(fid);
  
  numoforder = [1 1];
  
  % Sequence is created.
  result = roving(handles.stimnames, handles.soaminvalue, ...
		  handles.soamaxvalue, handles.totalstimvalue, ...
		  handles.repminvalue, handles.repmaxvalue, ...
		  handles.rep2stdvalue, handles.filenamevalue, ...
		  codes, handles.stimuluscats, ...
		  handles.probabilities, program, numoforder);

else
  
  numoforder(2) = numofseqfiles;
  for seqfile = 1:numofseqfiles
    
    filename = [handles.filenamevalue, num2str(seqfile)];
    % Settings are written to an ascii file <filename>.txt
    options_string = get_options(handles);
    file_out = [filename, '.txt'];
    fid = fopen(lower([cd,file_out]),'wt');
    fprintf(fid,options_string);
    fclose(fid);
    
    numoforder(1) = seqfile;
    
    % Sequence  is created.
    result = roving(handles.stimnames, handles.soaminvalue, ...
		    handles.soamaxvalue, handles.totalstimvalue, ...
		    handles.repminvalue, handles.repmaxvalue, ...
		    handles.rep2stdvalue, filename, ...
		    codes, handles.stimuluscats, ...
		    handles.probabilities, program, numoforder);
  end
end

close(h);

if ~(result(1) == -1)
  % Final statistics are shown on the screen.
  statistics1 = ['The probability of a deviant stimulus in the sequence' ...
		 ' is: ', num2str(result(1))];
  statistics2 = ['The total amount of stimuli in the sequence is: ', ...
		 num2str(result(2))];
else
  set(handles.finishedtag,'String','The sequence could not be created.');
  
  % Error message
  switch result(2)
   case 1
    statistics1 = ['Error: Stimuli not valid.'];
    statistics2 = ['Some category does not have enough stimuli.'];
    
   otherwise
    statistics2 = ['Error: Unknown error.'];
    statistics3 = ['Try again or try to change the parameters.'];
  end
end

set(handles.stat1tag,'string',statistics1);
set(handles.stat2tag,'string',statistics2);
hide_program_selection(handles);
show_finished(handles);


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.rovingsequence);



% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'seqma') & ishandle(handles.seqma),
    close(handles.seqma);
end
close(handles.rovingsequence);


% --- Executes on button press in advancedbutton.
function advancedbutton_Callback(hObject, eventdata, handles)
% hObject    handle to advancedbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_advanced_options(handles);
handles.state = 1;
guidata(hObject, handles);


% --- Executes on button press in simplebutton.
function simplebutton_Callback(hObject, eventdata, handles)
% hObject    handle to simplebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show_simple_options(handles);
handles.state = 0;
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


function repmin_Callback(hObject, eventdata, handles)
% hObject    handle to repmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repmin as text
%        str2double(get(hObject,'String')) returns contents of repmin as a double

handles.repminvalue = str2double(get(hObject,'string'));
if isnan(handles.repminvalue)
    errordlg('You must enter a numeric value','Bad Input','modal')
end

% If new repmin is bigger than repmax, repmax is set to be
% equal to repmin.
if (handles.repminvalue > handles.repmaxvalue)
  set(handles.repmax,'string',handles.repminvalue);
  handles.repmaxvalue = handles.repminvalue;
end

guidata(hObject, handles);

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



function repmax_Callback(hObject, eventdata, handles)
% hObject    handle to repmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repmax as text
%        str2double(get(hObject,'String')) returns contents of repmax as a double

handles.repmaxvalue = str2double(get(hObject,'string'));
if isnan(handles.repmaxvalue)
    errordlg('You must enter a numeric value','Bad Input','modal')
end

if (handles.repmaxvalue < handles.repminvalue)
  set(handles.repmin,'string',handles.repmaxvalue);
  handles.repminvalue = handles.repmaxvalue;
end

guidata(hObject, handles);



% --- Executes on button press in triggercodebox.
function triggercodebox_Callback(hObject, eventdata, handles)
% hObject    handle to triggercodebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of triggercodebox
if (~get(hObject,'Value'))
  set(handles.directionbox,'Value',0);
end



% --- Executes during object creation, after setting all properties.
function rep2std_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rep2std (see GCBO)  end

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rep2std_Callback(hObject, eventdata, handles)
% hObject    handle to rep2std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rep2std as text
%        str2double(get(hObject,'String')) returns contents of rep2std as a double

handles.rep2stdvalue = str2double(get(hObject,'string'));
if isnan(handles.rep2stdvalue)
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




% --- Hides the options components.
function hide_options(handles)

set(handles.soatag,'Visible','off');
set(handles.soamin,'Visible','off');
set(handles.soamintag,'Visible','off');
set(handles.soamax,'Visible','off');
set(handles.soamaxtag,'Visible','off');
set(handles.reptag,'Visible','off');
set(handles.repmin,'Visible','off');
set(handles.repmintag,'Visible','off');
set(handles.repmax,'Visible','off');
set(handles.repmaxtag,'Visible','off');
set(handles.advancedbutton,'Visible','off');
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.rep2stdtext,'Visible','off');
set(handles.rep2std,'Visible','off');
set(handles.totalstimtag,'Visible','off');
set(handles.totalstim,'Visible','off');
set(handles.propertybox,'Visible','off');
set(handles.numofstimtag,'Visible','off');
set(handles.numofstim,'Visible','off');
set(handles.probabilitybox,'Visible','off');
set(handles.repcodebox,'Visible','off');
set(handles.directionbox,'Visible','off');
hide_cat(handles);


% --- Shows the simple options components.
function show_simple_options(handles)

set(handles.titletag,'String','Roving-standard sequence');
set(handles.soatag,'Visible','on');
set(handles.soamin,'Visible','on');
set(handles.reptag,'Visible','on');
set(handles.repmin,'Visible','on');
set(handles.advancedbutton,'Visible','on');
set(handles.rep2stdtext,'Visible','on');
set(handles.rep2std,'Visible','on');
set(handles.soamintag,'Visible','off');
set(handles.soamax,'Visible','off');
set(handles.soamaxtag,'Visible','off');
set(handles.repmintag,'Visible','off');
set(handles.repmax,'Visible','off');
set(handles.repmaxtag,'Visible','off');
set(handles.simplebutton,'Visible','off');
set(handles.triggercodebox,'Visible','off');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.propertybox,'Visible','off');
set(handles.numofstimtag,'Visible','on');
set(handles.numofstim,'Visible','on');
set(handles.probabilitybox,'Visible','off');
set(handles.repcodebox,'Visible','off');
set(handles.directionbox,'Visible','off');
hide_cat(handles);
hide_probability(handles);
set(handles.propertybox,'Value',0);
set(handles.probabilitybox,'Value',0);
set(handles.directionbox,'Value',0);
set(handles.triggercodebox,'Value',0);
set(handles.repcodebox,'Value',0);
set(handles.propertybox,'Enable','on');
set(handles.repcodebox,'Enable','on');
set(handles.probabilitybox,'Enable','on');


% --- Shows the advanced options components.
function show_advanced_options(handles)

set(handles.titletag,'String','Roving-standard sequence');
set(handles.soatag,'Visible','on');
set(handles.soamin,'Visible','on');
set(handles.soamintag,'Visible','on');
set(handles.soamax,'Visible','on');
set(handles.soamaxtag,'Visible','on');
set(handles.reptag,'Visible','on');
set(handles.repmin,'Visible','on');
set(handles.repmintag,'Visible','on');
set(handles.repmax,'Visible','on');
set(handles.repmaxtag,'Visible','on');
set(handles.advancedbutton,'Visible','off');
set(handles.simplebutton,'Visible','on');
set(handles.triggercodebox,'Visible','on');
set(handles.rep2stdtext,'Visible','on');
set(handles.rep2std,'Visible','on');
set(handles.totalstimtag,'Visible','on');
set(handles.totalstim,'Visible','on');
set(handles.propertybox,'Visible','on');
set(handles.numofstimtag,'Visible','on');
set(handles.numofstim,'Visible','on');
set(handles.probabilitybox,'Visible','on');
hide_probability(handles);
set(handles.repcodebox,'Visible','on');
if (get(handles.propertybox,'Value'))
  set(handles.directionbox,'Visible','on');
  set(handles.catframe,'Visible','on');
  set(handles.numofcat,'Visible','on');
  set(handles.numofcattag,'Visible','on');
end


% --- Shows the trigger code selection.
function show_code_selection(handles)
set(handles.backbutton,'Enable','on');

rep2std = handles.rep2stdvalue;

set(handles.stim1frame,'Visible','on');
set(handles.stim1text,'Visible','on');
set(handles.stim1code,'Visible', 'on');
set(handles.stim2frame,'Visible','on');
set(handles.stim2text,'Visible','on');
set(handles.stim2code,'Visible','on');
set(handles.stim3frame,'Visible','on');
set(handles.stim3text,'Visible','on');
set(handles.stim4frame,'Visible','on');
set(handles.stim4text,'Visible','on');
set(handles.stim5frame,'Visible','on');
set(handles.stim5text,'Visible','on');
set(handles.stim6frame,'Visible','on');
set(handles.stim6text,'Visible','on');
set(handles.stim7frame,'Visible','on');
set(handles.stim7text,'Visible','on');
set(handles.stim8frame,'Visible','on');
set(handles.stim8text,'Visible','on');
set(handles.stim9frame,'Visible','on');
set(handles.stim9text,'Visible','on');
set(handles.stim10frame,'Visible','on');
set(handles.stim10text,'Visible','on');
set(handles.stim11frame,'Visible','on');
set(handles.stim11text,'Visible','on');
set(handles.stim2frame,'BackgroundColor','magenta');

if (rep2std >= 2)
  set(handles.stim3code,'Visible','on');
  set(handles.stim3text,'String','X');
  set(handles.stim3frame,'BackgroundColor','magenta');
  if (rep2std >= 3)
    set(handles.stim4codetag,'Visible','on');
    set(handles.stim4text,'String','X');
    set(handles.stim4frame,'BackgroundColor','magenta');
    if (rep2std >= 4)
      set(handles.stim5codetag,'Visible','on');
      set(handles.stim5text,'String','X');
      set(handles.stim5frame,'BackgroundColor','magenta');
      if (rep2std >= 5)
	set(handles.stim6codetag,'Visible','on');
	set(handles.stim6text,'String','X');
	set(handles.stim6frame,'BackgroundColor','magenta');
      	set(handles.stim7code,'Visible','on');
	set(handles.stim7text,'String','S');
	set(handles.stim7frame,'BackgroundColor','green');
      else
	set(handles.stim6code,'Visible','on');
	set(handles.stim6text,'String','S');
	set(handles.stim6frame,'BackgroundColor','green');
	set(handles.stim7codetag,'Visible','on');
	set(handles.stim7text,'String','S');
	set(handles.stim7frame,'BackgroundColor','green');
      end
    else
      set(handles.stim5code,'Visible','on');
      set(handles.stim5text,'String','S');
      set(handles.stim5frame,'BackgroundColor','green');
      set(handles.stim6codetag,'Visible','on');
      set(handles.stim6text,'String','S');
      set(handles.stim6frame,'BackgroundColor','green');
      set(handles.stim7codetag,'Visible','on');
      set(handles.stim7text,'String','S');
      set(handles.stim7frame,'BackgroundColor','green');
    end
  else
    set(handles.stim4code,'Visible','on');
    set(handles.stim4text,'String','S');
    set(handles.stim4frame,'BackgroundColor','green');
    set(handles.stim5codetag,'Visible','on');
    set(handles.stim5text,'String','S');
    set(handles.stim5frame,'BackgroundColor','green');
    set(handles.stim6codetag,'Visible','on');
    set(handles.stim6text,'String','S');
    set(handles.stim6frame,'BackgroundColor','green');
    set(handles.stim7codetag,'Visible','on');
    set(handles.stim7text,'String','S');
    set(handles.stim7frame,'BackgroundColor','green');
  end
else
  set(handles.stim3code,'Visible','on');
  set(handles.stim3text,'String','S');
  set(handles.stim3frame,'BackgroundColor','green');
  set(handles.stim4codetag,'Visible','on');
  set(handles.stim4text,'String','S');
  set(handles.stim4frame,'BackgroundColor','green');
  set(handles.stim5codetag,'Visible','on');
  set(handles.stim5text,'String','S');
  set(handles.stim5frame,'BackgroundColor','green');
  set(handles.stim6codetag,'Visible','on');
  set(handles.stim6text,'String','S');
  set(handles.stim6frame,'BackgroundColor','green');
  set(handles.stim7codetag,'Visible','on');
  set(handles.stim7text,'String','S');
  set(handles.stim7frame,'BackgroundColor','green');
end

set(handles.stim8codetag,'Visible','on');
set(handles.stim8text,'String','S');
set(handles.stim8frame,'BackgroundColor','green');
set(handles.stim9codetag,'Visible','on');
set(handles.stim9text,'String','S');
set(handles.stim9frame,'BackgroundColor','green');
set(handles.stim10code,'Visible','on');
set(handles.stim10text,'String','S');
set(handles.stim10frame,'BackgroundColor','green');
set(handles.codetagframe,'Visible','on');
set(handles.devtag,'Visible','on');
set(handles.devcode,'Visible','on');
set(handles.firstafterdevtag,'Visible','on');
set(handles.firstafterdevcode,'Visible','on');
set(handles.repbeforestdtag,'Visible','on');
set(handles.repbeforestdcode,'Visible','on');
set(handles.stdtag,'Visible','on');
set(handles.stdcode,'Visible','on');
set(handles.laststdtag,'Visible','on');
set(handles.laststdcode,'Visible','on');


% --- Hides the trigger code selection.
function hide_code_selection(handles)
set(handles.stim1frame,'Visible','off');
set(handles.stim1text,'Visible','off');
set(handles.stim1code,'Visible', 'off');
set(handles.stim2frame,'Visible','off');
set(handles.stim2text,'Visible','off');
set(handles.stim2code,'Visible', 'off');
set(handles.stim3frame,'Visible','off');
set(handles.stim3text,'Visible','off');
set(handles.stim3code,'Visible', 'off');
set(handles.stim4frame,'Visible','off');
set(handles.stim4text,'Visible','off');
set(handles.stim4code,'Visible', 'off');
set(handles.stim5frame,'Visible','off');
set(handles.stim5text,'Visible','off');
set(handles.stim5code,'Visible', 'off');
set(handles.stim6frame,'Visible','off');
set(handles.stim6text,'Visible','off');
set(handles.stim6code,'Visible', 'off');
set(handles.stim7frame,'Visible','off');
set(handles.stim7text,'Visible','off');
set(handles.stim7code,'Visible', 'off');
set(handles.stim8frame,'Visible','off');
set(handles.stim8text,'Visible','off');
set(handles.stim8code,'Visible', 'off');
set(handles.stim9frame,'Visible','off');
set(handles.stim9text,'Visible','off');
set(handles.stim9code,'Visible', 'off');
set(handles.stim10frame,'Visible','off');
set(handles.stim10text,'Visible','off');
set(handles.stim10code,'Visible', 'off');
set(handles.stim11frame,'Visible','off');
set(handles.stim11text,'Visible','off');
set(handles.stim11code,'Visible', 'off');
set(handles.stim4codetag,'Visible','off');
set(handles.stim5codetag,'Visible','off');
set(handles.stim6codetag,'Visible','off');
set(handles.stim7codetag,'Visible','off');
set(handles.stim8codetag,'Visible','off');
set(handles.stim9codetag,'Visible','off');
set(handles.codetagframe,'Visible','off');
set(handles.devtag,'Visible','off');
set(handles.devcode,'Visible','off');
set(handles.firstafterdevtag,'Visible','off');
set(handles.firstafterdevcode,'Visible','off');
set(handles.repbeforestdtag,'Visible','off');
set(handles.repbeforestdcode,'Visible','off');
set(handles.stdtag,'Visible','off');
set(handles.stdcode,'Visible','off');
set(handles.laststdtag,'Visible','off');
set(handles.laststdcode,'Visible','off');


% --- Shows the program selection.
function show_program_selection(handles)
set(handles.titletag,'String','File settings');
set(handles.stimradio,'Visible','on');
set(handles.brainstimradio,'Visible','on');
set(handles.presentationradio,'Visible','on');
set(handles.ptbradio,'Visible','on');
set(handles.filenametag,'Visible','on');
set(handles.filename,'Visible','on');
set(handles.finishbutton,'Visible','on');
set(handles.nextbutton,'Visible','off');
set(handles.formatframe,'Visible','on');
set(handles.formattag,'Visible','on');
set(handles.catframe,'Visible','on');
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
set(handles.formatframe,'Visible','off');
set(handles.formattag,'Visible','off');
set(handles.manybox,'Visible','off');
set(handles.catframe,'Visible','off');
set(handles.numofseqfilestag,'Visible','off');
set(handles.numofseqfiles,'Visible','off');



% --- Shows the category choosing components
function show_cat(handles)
set(handles.catframe,'Visible','on');
set(handles.numofcattag,'Visible','on');
set(handles.numofcat,'Visible','on');

numofstim = str2double(get(handles.numofstim,'String'));
numofcat = str2double(get(handles.numofcat,'String'));
minstim = pow2(numofcat);
if (numofstim < minstim)
  set(handles.numofstim,'String',num2str(minstim));
  notestr = ['With ', get(handles.numofcat,'String'), ...
	     ' properties, you need to have at least ', ...
	     num2str(minstim), ' stimuli.'];
  set(handles.stimnotetag,'String',notestr);
  set(handles.stimnotetag,'Visible','on');
end



% --- Hides the category choosing components
function hide_cat(handles)
set(handles.catframe,'Visible','off');
set(handles.numofcattag,'Visible','off');
set(handles.numofcat,'Visible','off');
set(handles.stimnotetag,'Visible','off');


% --- Shows the property name choosing components
function show_property_names(handles)
set(handles.titletag,'String','Property name selection');
set(handles.propertynametag,'Visible','on');
set(handles.cat1nametag,'Visible','on');
set(handles.cat2nametag,'Visible','on');
set(handles.prop1num,'Visible','on');
set(handles.prop1name,'Visible','on');
set(handles.prop1exampletag,'Visible','on');
set(handles.prop1cat1name,'Visible','on');
set(handles.prop1cat2name,'Visible','on');
if (str2double(get(handles.numofcat,'string')) >= 2)
  set(handles.prop2num,'Visible','on');
  set(handles.prop2name,'Visible','on');
  set(handles.prop2cat1name,'Visible','on');
  set(handles.prop2cat2name,'Visible','on');
end
if (str2double(get(handles.numofcat,'string')) >= 3)
  set(handles.prop3num,'Visible','on');
  set(handles.prop3name,'Visible','on');
  set(handles.prop3cat1name,'Visible','on');
  set(handles.prop3cat2name,'Visible','on');
end
if (str2double(get(handles.numofcat,'string')) >= 4)
  set(handles.prop4num,'Visible','on');
  set(handles.prop4name,'Visible','on');
  set(handles.prop4cat1name,'Visible','on');
  set(handles.prop4cat2name,'Visible','on');
end
if (str2double(get(handles.numofcat,'string')) >= 5)
  set(handles.prop5num,'Visible','on');
  set(handles.prop5name,'Visible','on');
  set(handles.prop5cat1name,'Visible','on');
  set(handles.prop5cat2name,'Visible','on');
end


% --- Shows components for setting one property name at a time.
function show_one_property_name(handles)
set(handles.titletag,'String','Property name selection');
set(handles.prop1num,'String',num2str(handles.numofcatnames));
if (~isempty(handles.catnames{handles.numofcatnames}))
  set(handles.prop1name,'String', ...
		    handles.catnames{handles.numofcatnames,1});
  set(handles.prop1cat1name,'String', ...
		    handles.catnames{handles.numofcatnames,2});
  set(handles.prop1cat2name,'String', ...
		    handles.catnames{handles.numofcatnames,3});
else
  set(handles.prop1name,'String','');
  set(handles.prop1cat1name,'String','');
  set(handles.prop1cat2name,'String','');
end
set(handles.prop1num,'Visible','on');
set(handles.prop1name,'Visible','on');
set(handles.prop1cat1name,'Visible','on');
set(handles.prop1cat2name,'Visible','on');
set(handles.propertynametag,'Visible','on');
set(handles.cat1nametag,'Visible','on');
set(handles.cat2nametag,'Visible','on');

% --- Hides the property name choosing components
function hide_property_names(handles)
set(handles.prop1num,'Visible','off');
set(handles.prop1name,'Visible','off');
set(handles.prop2num,'Visible','off');
set(handles.prop2name,'Visible','off');
set(handles.prop3num,'Visible','off');
set(handles.prop3name,'Visible','off');
set(handles.prop4num,'Visible','off');
set(handles.prop4name,'Visible','off');
set(handles.prop5num,'Visible','off');
set(handles.prop5name,'Visible','off');
set(handles.prop1exampletag,'Visible','off');
set(handles.propertynametag,'Visible','off');
set(handles.cat1nametag,'Visible','off');
set(handles.cat2nametag,'Visible','off');
set(handles.prop1cat1name,'Visible','off');
set(handles.prop1cat2name,'Visible','off');
set(handles.prop2cat1name,'Visible','off');
set(handles.prop2cat2name,'Visible','off');
set(handles.prop3cat1name,'Visible','off');
set(handles.prop3cat2name,'Visible','off');
set(handles.prop4cat1name,'Visible','off');
set(handles.prop4cat2name,'Visible','off');
set(handles.prop5cat1name,'Visible','off');
set(handles.prop5cat2name,'Visible','off');


% --- Shows the stimulus file name settings components
function show_stimulus_file_name(handles)
set(handles.titletag,'String','Stimulus file name selection');
set(handles.stimulusfilehelptag,'Visible','on');
set(handles.stimulusfiletag,'Visible','on');
set(handles.stimulusfile,'Visible','on');


% --- Hides the stimulus file name settings components
function hide_stimulus_file_name(handles)
set(handles.stimulusfilehelptag,'Visible','off');
set(handles.stimulusfiletag,'Visible','off');
set(handles.stimulusfile,'Visible','off');



% --- Shows the categorization (property choice) components
function show_categorization(handles)
numofcat = str2double(get(handles.numofcat,'string'));
if (numofcat <= 1)
  numofcat = 1;
  set(handles.propertyselectiontag,'string',['Select property for' ...
		    ' the stimulus']);
end

if (get(handles.directionbox,'Value') |  ...
    ~get(handles.triggercodebox,'Value'))

  set(handles.propertyselectiontag,'Visible','on');
  set(handles.prop1choiceframe,'Visible','on');
  prop1name = get(handles.prop1name,'string');
  if (prop1name)
    set(handles.prop1choicetag,'string',prop1name);
  else
    set(handles.prop1choicetag,'string','Property1');
    set(handles.prop1name,'string','Property1');
  end
  prop1cat1name = get(handles.prop1cat1name,'String');
  if (prop1cat1name)
    set(handles.prop1radio1,'String',prop1cat1name);
  else
    set(handles.prop1radio1,'String','1');
    set(handles.prop1cat1name,'String','1');
  end
  prop1cat2name = get(handles.prop1cat2name,'String');
  if (prop1cat2name)
    set(handles.prop1radio2,'String',prop1cat2name);
  else
    set(handles.prop1radio2,'String','2');
    set(handles.prop1cat2name,'String','2');
  end
  set(handles.prop1choicetag,'Visible','on');
  set(handles.prop1radio1,'Visible','on');
  set(handles.prop1radio2,'Visible','on');
  
  if (numofcat >= 2)
    set(handles.prop2choiceframe,'Visible','on');
    prop2name = get(handles.prop2name,'string');
    if (prop2name)
      set(handles.prop2choicetag,'string',prop2name);
    else
      set(handles.prop2choicetag,'string','Property2');
      set(handles.prop2name,'string','Property2');
    end
    prop2cat1name = get(handles.prop2cat1name,'String');
    if (prop2cat1name)
      set(handles.prop2radio1,'String',prop2cat1name);
    else
      set(handles.prop2radio1,'String','1');
      set(handles.prop2cat1name,'String','1');
    end
    prop2cat2name = get(handles.prop2cat2name,'String');
    if (prop2cat2name)
      set(handles.prop2radio2,'String',prop2cat2name);
    else
      set(handles.prop2radio2,'String','2');
      set(handles.prop2cat2name,'String','2');
    end
    set(handles.prop2choicetag,'Visible','on');
    set(handles.prop2radio1,'Visible','on');
    set(handles.prop2radio2,'Visible','on');
  end
  
  if (numofcat >= 3)
    set(handles.prop3choiceframe,'Visible','on');
    prop3name = get(handles.prop3name,'string');
    if (prop3name)
      set(handles.prop3choicetag,'string',prop3name);
    else
      set(handles.prop3choicetag,'string','Property3');
      set(handles.prop3name,'string','Property3');
    end
    prop3cat1name = get(handles.prop3cat1name,'String');
    if (prop3cat1name)
      set(handles.prop3radio1,'String',prop3cat1name);
    else
      set(handles.prop3radio1,'String','1');
      set(handles.prop3cat1name,'String','1');
    end
    prop3cat2name = get(handles.prop3cat2name,'String');
    if (prop3cat2name)
      set(handles.prop3radio2,'String',prop3cat2name);
    else
      set(handles.prop3radio2,'String','2');
      set(handles.prop3cat2name,'String','2');
    end
    set(handles.prop3choicetag,'Visible','on');
    set(handles.prop3radio1,'Visible','on');
    set(handles.prop3radio2,'Visible','on');
  end
  
  if (numofcat >= 4)
    set(handles.prop4choiceframe,'Visible','on');
    prop4name = get(handles.prop4name,'string');
    if (prop4name)
      set(handles.prop4choicetag,'string',prop4name);
    else
      set(handles.prop4choicetag,'string','Property4');
      set(handles.prop4name,'string','Property4');
    end
    prop4cat1name = get(handles.prop4cat1name,'String');
    if (prop4cat1name)
      set(handles.prop4radio1,'String',prop4cat1name);
    else
      set(handles.prop4radio1,'String','1');
    set(handles.prop4cat1name,'String','1');
    end
    prop4cat2name = get(handles.prop4cat2name,'String');
    if (prop4cat2name)
      set(handles.prop4radio2,'String',prop4cat2name);
    else
      set(handles.prop4radio2,'String','2');
      set(handles.prop4cat2name,'String','2');
    end
    set(handles.prop4choicetag,'Visible','on');
    set(handles.prop4radio1,'Visible','on');
    set(handles.prop4radio2,'Visible','on');
  end
  
  if (numofcat >= 5)
    set(handles.prop5choiceframe,'Visible','on');
    prop5name = get(handles.prop5name,'string');
    if (prop5name)
      set(handles.prop5choicetag,'string',prop5name);
    else
      set(handles.prop5choicetag,'string','Property5');
      set(handles.prop5name,'string','Property5');
    end
    prop5cat1name = get(handles.prop5cat1name,'String');
    if (prop5cat1name)
      set(handles.prop5radio1,'String',prop5cat1name);
    else
      set(handles.prop5radio1,'String','1');
      set(handles.prop5cat1name,'String','1');
    end
    prop5cat2name = get(handles.prop5cat2name,'String');
    if (prop5cat2name)
      set(handles.prop5radio2,'String',prop5cat2name);
    else
      set(handles.prop5radio2,'String','2');
      set(handles.prop5cat2name,'String','2');
    end
    set(handles.prop5choicetag,'Visible','on');
    set(handles.prop5radio1,'Visible','on');
    set(handles.prop5radio2,'Visible','on');
  end
else
  % From state 23
  set(handles.propertyselectiontag,'Visible','on');
  set(handles.prop1choiceframe,'Visible','on');
  set(handles.prop1choicetag,'String',handles.catnames{1,1});
  set(handles.prop1radio1,'String',handles.catnames{1,2});
  set(handles.prop1radio2,'String',handles.catnames{1,3});
  set(handles.prop1choicetag,'Visible','on');
  set(handles.prop1radio1,'Visible','on');
  set(handles.prop1radio2,'Visible','on');
  
  if (numofcat >= 2)
    set(handles.prop2choiceframe,'Visible','on');
    set(handles.prop2choicetag,'String',handles.catnames{2,1});
    set(handles.prop2radio1,'String',handles.catnames{2,2});
    set(handles.prop2radio2,'String',handles.catnames{2,3});
    set(handles.prop2choicetag,'Visible','on');
    set(handles.prop2radio1,'Visible','on');
    set(handles.prop2radio2,'Visible','on');
  end
  
  if (numofcat >= 3)
    set(handles.prop3choiceframe,'Visible','on');
    set(handles.prop3choicetag,'String',handles.catnames{3,1});
    set(handles.prop3radio1,'String',handles.catnames{3,2});
    set(handles.prop3radio2,'String',handles.catnames{3,3});
    set(handles.prop3choicetag,'Visible','on');
    set(handles.prop3radio1,'Visible','on');
    set(handles.prop3radio2,'Visible','on');
  end
  
  if (numofcat >= 4)
    set(handles.prop4choiceframe,'Visible','on');
    set(handles.prop4choicetag,'String',handles.catnames{4,1});
    set(handles.prop4radio1,'String',handles.catnames{4,2});
    set(handles.prop4radio2,'String',handles.catnames{4,3});
    set(handles.prop4choicetag,'Visible','on');
    set(handles.prop4radio1,'Visible','on');
    set(handles.prop4radio2,'Visible','on');
  end
  
  if (numofcat >= 5)
    set(handles.prop5choiceframe,'Visible','on');
    set(handles.prop5choicetag,'String',handles.catnames{5,1});
    set(handles.prop5radio1,'String',handles.catnames{5,2});
    set(handles.prop5radio2,'String',handles.catnames{5,3});
    set(handles.prop5choicetag,'Visible','on');
    set(handles.prop5radio1,'Visible','on');
    set(handles.prop5radio2,'Visible','on');
  end
end  


% --- Hides the categorization (property choice) components
function hide_categorization(handles)

set(handles.propertyselectiontag,'Visible','off');
set(handles.prop1choiceframe,'Visible','off');
set(handles.prop1choicetag,'Visible','off');
set(handles.prop1radio1,'Visible','off');
set(handles.prop1radio2,'Visible','off');
set(handles.prop2choiceframe,'Visible','off');
set(handles.prop2choicetag,'Visible','off');
set(handles.prop2radio1,'Visible','off');
set(handles.prop2radio2,'Visible','off');
set(handles.prop3choiceframe,'Visible','off');
set(handles.prop3choicetag,'Visible','off');
set(handles.prop3radio1,'Visible','off');
set(handles.prop3radio2,'Visible','off');
set(handles.prop4choiceframe,'Visible','off');
set(handles.prop4choicetag,'Visible','off');
set(handles.prop4radio1,'Visible','off');
set(handles.prop4radio2,'Visible','off');
set(handles.prop5choiceframe,'Visible','off');
set(handles.prop5choicetag,'Visible','off');
set(handles.prop5radio1,'Visible','off');
set(handles.prop5radio2,'Visible','off');


% --- Shows the categorization (property choice) components
function show_code_categorization(handles)
numofcat = str2double(get(handles.numofcat,'string'));
if (numofcat <= 1)
  numofcat = 1;
  set(handles.propertyselectiontag,'string',['Select property for' ...
		    ' the stimulus']);
end

set(handles.propertyselectiontag,'Visible','on');
set(handles.prop1choiceframe,'Visible','on');
prop1name = get(handles.prop1name,'string');
if (prop1name)
  set(handles.prop1choicetag,'string',prop1name);
else
  set(handles.prop1choicetag,'string','Property1');
  set(handles.prop1name,'string','Property1');
end
set(handles.prop1choicetag,'Visible','on');
set(handles.prop1radio1,'Visible','on');
set(handles.prop1radio2,'Visible','on');

if (numofcat >= 2)
  set(handles.prop2choiceframe,'Visible','on');
  prop2name = get(handles.prop2name,'string');
  if (prop2name)
    set(handles.prop2choicetag,'string',prop2name);
  else
    set(handles.prop2choicetag,'string','Property2');
    set(handles.prop2name,'string','Property2');
  end
  set(handles.prop2choicetag,'Visible','on');
  set(handles.prop2radio1,'Visible','on');
  set(handles.prop2radio2,'Visible','on');
end

if (numofcat >= 3)
  set(handles.prop3choiceframe,'Visible','on');
  prop3name = get(handles.prop3name,'string');
  if (prop3name)
    set(handles.prop3choicetag,'string',prop3name);
  else
    set(handles.prop3choicetag,'string','Property3');
    set(handles.prop3name,'string','Property3');
  end
  set(handles.prop3choicetag,'Visible','on');
  set(handles.prop3radio1,'Visible','on');
  set(handles.prop3radio2,'Visible','on');
end

if (numofcat >= 4)
  set(handles.prop4choiceframe,'Visible','on');
  prop4name = get(handles.prop4name,'string');
  if (prop4name)
    set(handles.prop4choicetag,'string',prop4name);
  else
    set(handles.prop4choicetag,'string','Property4');
    set(handles.prop4name,'string','Property4');
  end
  set(handles.prop4choicetag,'Visible','on');
  set(handles.prop4radio1,'Visible','on');
  set(handles.prop4radio2,'Visible','on');
end

if (numofcat >= 5)
  set(handles.prop5choiceframe,'Visible','on');
  prop5name = get(handles.prop5name,'string');
  if (prop5name)
    set(handles.prop5choicetag,'string',prop5name);
  else
    set(handles.prop5choicetag,'string','Property5');
    set(handles.prop5name,'string','Property5');
  end
  set(handles.prop5choicetag,'Visible','on');
  set(handles.prop5radio1,'Visible','on');
  set(handles.prop5radio2,'Visible','on');
end



% --- Shows the finished state components.
function show_finished(handles)

set(handles.titletag,'Visible','off');
set(handles.finishedtag,'Visible','on');
set(handles.stat1tag,'Visible','on');
set(handles.stat2tag,'Visible','on');
set(handles.nextbutton,'Visible','off');
set(handles.backbutton,'Visible','off');
set(handles.cancelbutton,'Visible','off');
set(handles.closebutton,'Visible','on');
set(handles.statisticsframe,'Visible','on');



% --- Hides the finished state components.
function hide_finished(handles)

set(handles.finishedtag,'Visible','off');
set(handles.stat1tag,'Visible','off');
set(handles.stat2tag,'Visible','off');
set(handles.closebutton,'Visible','off');
set(handles.statisticsframe,'Visible','off');


% --- Shows the probability selection components.
function show_probability(handles)

set(handles.probabilitytag,'Visible','on');
set(handles.probability,'Visible','on');

% --- Hides the probability selection components.
function hide_probability(handles)

set(handles.probabilitytag,'Visible','off');
set(handles.probability,'Visible','off');


% --- Shows the code grid.
% (The code grid is used, when different codes are needed depending
%  on, how many repetitions have preceded a stimulus)
function show_grid(repmin, repmax, handles)

set(handles.gridtitle,'Visible','on');
set(handles.gridtaga,'Visible','on');
set(handles.gridtagb,'Visible','on');
set(handles.gridtagc,'Visible','on');
set(handles.gridtagd,'Visible','on');
set(handles.gridtage,'Visible','on');
set(handles.gridtexta,'Visible','on');
set(handles.gridtextb,'Visible','on');
set(handles.gridtextc,'Visible','on');
set(handles.gridtextd,'Visible','on');
set(handles.gridtexte,'Visible','on');

i = 0;
for j = repmin : repmax
  show_grid_column(i,j,handles);
  i = i+1;
end


% --- Hides the code grid.
function hide_grid(handles);

set(handles.gridtitle,'Visible','off');
set(handles.gridtaga,'Visible','off');
set(handles.gridtagb,'Visible','off');
set(handles.gridtagc,'Visible','off');
set(handles.gridtagd,'Visible','off');
set(handles.gridtage,'Visible','off');
set(handles.gridtexta,'Visible','off');
set(handles.gridtextb,'Visible','off');
set(handles.gridtextc,'Visible','off');
set(handles.gridtextd,'Visible','off');
set(handles.gridtexte,'Visible','off');
set(handles.grida0,'Visible','off');
set(handles.grida1,'Visible','off');
set(handles.grida2,'Visible','off');
set(handles.grida3,'Visible','off');
set(handles.grida4,'Visible','off');
set(handles.grida5,'Visible','off');
set(handles.grida6,'Visible','off');
set(handles.grida7,'Visible','off');
set(handles.grida8,'Visible','off');
set(handles.grida9,'Visible','off');
set(handles.grida10,'Visible','off');
set(handles.grida11,'Visible','off');
set(handles.grida12,'Visible','off');
set(handles.grida13,'Visible','off');
set(handles.grida14,'Visible','off');
set(handles.grida15,'Visible','off');
set(handles.grida16,'Visible','off');
set(handles.grida17,'Visible','off');
set(handles.grida18,'Visible','off');
set(handles.grida19,'Visible','off');
set(handles.grida20,'Visible','off');
set(handles.gridb0,'Visible','off');
set(handles.gridb1,'Visible','off');
set(handles.gridb2,'Visible','off');
set(handles.gridb3,'Visible','off');
set(handles.gridb4,'Visible','off');
set(handles.gridb5,'Visible','off');
set(handles.gridb6,'Visible','off');
set(handles.gridb7,'Visible','off');
set(handles.gridb8,'Visible','off');
set(handles.gridb9,'Visible','off');
set(handles.gridb10,'Visible','off');
set(handles.gridb11,'Visible','off');
set(handles.gridb12,'Visible','off');
set(handles.gridb13,'Visible','off');
set(handles.gridb14,'Visible','off');
set(handles.gridb15,'Visible','off');
set(handles.gridb16,'Visible','off');
set(handles.gridb17,'Visible','off');
set(handles.gridb18,'Visible','off');
set(handles.gridb19,'Visible','off');
set(handles.gridb20,'Visible','off');
set(handles.gridc0,'Visible','off');
set(handles.gridc1,'Visible','off');
set(handles.gridc2,'Visible','off');
set(handles.gridc3,'Visible','off');
set(handles.gridc4,'Visible','off');
set(handles.gridc5,'Visible','off');
set(handles.gridc6,'Visible','off');
set(handles.gridc7,'Visible','off');
set(handles.gridc8,'Visible','off');
set(handles.gridc9,'Visible','off');
set(handles.gridc10,'Visible','off');
set(handles.gridc11,'Visible','off');
set(handles.gridc12,'Visible','off');
set(handles.gridc13,'Visible','off');
set(handles.gridc14,'Visible','off');
set(handles.gridc15,'Visible','off');
set(handles.gridc16,'Visible','off');
set(handles.gridc17,'Visible','off');
set(handles.gridc18,'Visible','off');
set(handles.gridc19,'Visible','off');
set(handles.gridc20,'Visible','off');
set(handles.gridd0,'Visible','off');
set(handles.gridd1,'Visible','off');
set(handles.gridd2,'Visible','off');
set(handles.gridd3,'Visible','off');
set(handles.gridd4,'Visible','off');
set(handles.gridd5,'Visible','off');
set(handles.gridd6,'Visible','off');
set(handles.gridd7,'Visible','off');
set(handles.gridd8,'Visible','off');
set(handles.gridd9,'Visible','off');
set(handles.gridd10,'Visible','off');
set(handles.gridd11,'Visible','off');
set(handles.gridd12,'Visible','off');
set(handles.gridd13,'Visible','off');
set(handles.gridd14,'Visible','off');
set(handles.gridd15,'Visible','off');
set(handles.gridd16,'Visible','off');
set(handles.gridd17,'Visible','off');
set(handles.gridd18,'Visible','off');
set(handles.gridd19,'Visible','off');
set(handles.gridd20,'Visible','off');
set(handles.gride0,'Visible','off');
set(handles.gride1,'Visible','off');
set(handles.gride2,'Visible','off');
set(handles.gride3,'Visible','off');
set(handles.gride4,'Visible','off');
set(handles.gride5,'Visible','off');
set(handles.gride6,'Visible','off');
set(handles.gride7,'Visible','off');
set(handles.gride8,'Visible','off');
set(handles.gride9,'Visible','off');
set(handles.gride10,'Visible','off');
set(handles.gride11,'Visible','off');
set(handles.gride12,'Visible','off');
set(handles.gride13,'Visible','off');
set(handles.gride14,'Visible','off');
set(handles.gride15,'Visible','off');
set(handles.gride16,'Visible','off');
set(handles.gride17,'Visible','off');
set(handles.gride18,'Visible','off');
set(handles.gride19,'Visible','off');
set(handles.gride20,'Visible','off');
set(handles.grida0tag,'Visible','off');
set(handles.grida1tag,'Visible','off');
set(handles.grida2tag,'Visible','off');
set(handles.grida3tag,'Visible','off');
set(handles.grida4tag,'Visible','off');
set(handles.grida5tag,'Visible','off');
set(handles.grida6tag,'Visible','off');
set(handles.grida7tag,'Visible','off');
set(handles.grida8tag,'Visible','off');
set(handles.grida9tag,'Visible','off');
set(handles.grida10tag,'Visible','off');
set(handles.grida11tag,'Visible','off');
set(handles.grida12tag,'Visible','off');
set(handles.grida13tag,'Visible','off');
set(handles.grida14tag,'Visible','off');
set(handles.grida15tag,'Visible','off');
set(handles.grida16tag,'Visible','off');
set(handles.grida17tag,'Visible','off');
set(handles.grida18tag,'Visible','off');
set(handles.grida19tag,'Visible','off');
set(handles.grida20tag,'Visible','off');
set(handles.gridb0tag,'Visible','off');
set(handles.gridb1tag,'Visible','off');
set(handles.gridb2tag,'Visible','off');
set(handles.gridb3tag,'Visible','off');
set(handles.gridb4tag,'Visible','off');
set(handles.gridb5tag,'Visible','off');
set(handles.gridb6tag,'Visible','off');
set(handles.gridb7tag,'Visible','off');
set(handles.gridb8tag,'Visible','off');
set(handles.gridb9tag,'Visible','off');
set(handles.gridb10tag,'Visible','off');
set(handles.gridb11tag,'Visible','off');
set(handles.gridb12tag,'Visible','off');
set(handles.gridb13tag,'Visible','off');
set(handles.gridb14tag,'Visible','off');
set(handles.gridb15tag,'Visible','off');
set(handles.gridb16tag,'Visible','off');
set(handles.gridb17tag,'Visible','off');
set(handles.gridb18tag,'Visible','off');
set(handles.gridb19tag,'Visible','off');
set(handles.gridb20tag,'Visible','off');
set(handles.gridc0tag,'Visible','off');
set(handles.gridc1tag,'Visible','off');
set(handles.gridc2tag,'Visible','off');
set(handles.gridc3tag,'Visible','off');
set(handles.gridc4tag,'Visible','off');
set(handles.gridc5tag,'Visible','off');
set(handles.gridc6tag,'Visible','off');
set(handles.gridc7tag,'Visible','off');
set(handles.gridc8tag,'Visible','off');
set(handles.gridc9tag,'Visible','off');
set(handles.gridc10tag,'Visible','off');
set(handles.gridc11tag,'Visible','off');
set(handles.gridc12tag,'Visible','off');
set(handles.gridc13tag,'Visible','off');
set(handles.gridc14tag,'Visible','off');
set(handles.gridc15tag,'Visible','off');
set(handles.gridc16tag,'Visible','off');
set(handles.gridc17tag,'Visible','off');
set(handles.gridc18tag,'Visible','off');
set(handles.gridc19tag,'Visible','off');
set(handles.gridc20tag,'Visible','off');
set(handles.gridd0tag,'Visible','off');
set(handles.gridd1tag,'Visible','off');
set(handles.gridd2tag,'Visible','off');
set(handles.gridd3tag,'Visible','off');
set(handles.gridd4tag,'Visible','off');
set(handles.gridd5tag,'Visible','off');
set(handles.gridd6tag,'Visible','off');
set(handles.gridd7tag,'Visible','off');
set(handles.gridd8tag,'Visible','off');
set(handles.gridd9tag,'Visible','off');
set(handles.gridd10tag,'Visible','off');
set(handles.gridd11tag,'Visible','off');
set(handles.gridd12tag,'Visible','off');
set(handles.gridd13tag,'Visible','off');
set(handles.gridd14tag,'Visible','off');
set(handles.gridd15tag,'Visible','off');
set(handles.gridd16tag,'Visible','off');
set(handles.gridd17tag,'Visible','off');
set(handles.gridd18tag,'Visible','off');
set(handles.gridd19tag,'Visible','off');
set(handles.gridd20tag,'Visible','off');
set(handles.gride0tag,'Visible','off');
set(handles.gride1tag,'Visible','off');
set(handles.gride2tag,'Visible','off');
set(handles.gride3tag,'Visible','off');
set(handles.gride4tag,'Visible','off');
set(handles.gride5tag,'Visible','off');
set(handles.gride6tag,'Visible','off');
set(handles.gride7tag,'Visible','off');
set(handles.gride8tag,'Visible','off');
set(handles.gride9tag,'Visible','off');
set(handles.gride10tag,'Visible','off');
set(handles.gride11tag,'Visible','off');
set(handles.gride12tag,'Visible','off');
set(handles.gride13tag,'Visible','off');
set(handles.gride14tag,'Visible','off');
set(handles.gride15tag,'Visible','off');
set(handles.gride16tag,'Visible','off');
set(handles.gride17tag,'Visible','off');
set(handles.gride18tag,'Visible','off');
set(handles.gride19tag,'Visible','off');
set(handles.gride20tag,'Visible','off');


% --- Calculates the average probability for those stimuli, to
% which no probability has yet been defined.
function y = tune_probability(handles)

numofstim = str2double(get(handles.numofstim,'string'));

avprob = handles.probability_left / (numofstim - ...
				     handles.numofstimnames + 1);

set(handles.probability,'string',num2str(avprob));

y = avprob;


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



% --- Executes during object creation, after setting all properties.
function stim1code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim1code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function stim1code_Callback(hObject, eventdata, handles)
% hObject    handle to stim1code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim1code as text
%        str2double(get(hObject,'String')) returns contents of stim1code as a double

newcode = get(hObject,'String');
set_devcodes(newcode,handles);
guidata(hObject, handles);

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

newcode = get(hObject,'String');
set_firstafterdevcodes(newcode,handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stim3code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim3code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim3code_Callback(hObject, eventdata, handles)
% hObject    handle to stim3code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim3code as text
%        str2double(get(hObject,'String')) returns contents of stim3code as a double

newcode = get(hObject,'string');
if (handles.rep2std <= 1)
  set_stdcodes(newcode, handles);
else
  set_repbeforestdcodes(newcode, handles);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stim4code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim4code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim4code_Callback(hObject, eventdata, handles)
% hObject    handle to stim4code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim4code as text
%        str2double(get(hObject,'String')) returns contents of stim4code as a double

newcode = get(hObject,'String');
set_stdcodes(newcode,handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function stim5code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim5code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim5code_Callback(hObject, eventdata, handles)
% hObject    handle to stim5code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim5code as text
%        str2double(get(hObject,'String')) returns contents of stim5code as a double

newcode = get(hObject,'String');
set_stdcodes(newcode,handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function stim6code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim6code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim6code_Callback(hObject, eventdata, handles)
% hObject    handle to stim6code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim6code as text
%        str2double(get(hObject,'String')) returns contents of stim6code as a double

newcode = get(hObject,'String');
set_stdcodes(newcode,handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stim7code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim7code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim7code_Callback(hObject, eventdata, handles)
% hObject    handle to stim7code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim7code as text
%        str2double(get(hObject,'String')) returns contents of stim7code as a double

newcode = get(hObject,'String');
set_stdcodes(newcode,handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stim8code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim8code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim8code_Callback(hObject, eventdata, handles)
% hObject    handle to stim8code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim8code as text
%        str2double(get(hObject,'String')) returns contents of stim8code as a double


% --- Executes during object creation, after setting all properties.
function stim9code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim9code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stim9code_Callback(hObject, eventdata, handles)
% hObject    handle to stim9code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim9code as text
%        str2double(get(hObject,'String')) returns contents of stim9code as a double


function stim10code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std8code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.  end

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function stim10code_Callback(hObject, eventdata, handles)
% hObject    handle to std8code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std8code as text
%        str2double(get(hObject,'String')) returns contents of std8code as a double
% --- Executes during object creation, after setting all properties.

newcode = get(hObject,'String');
set_laststdcodes(newcode,handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stim11code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim1code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function stim11code_Callback(hObject, eventdata, handles)
% hObject    handle to stim1code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim1code as text
%        str2double(get(hObject,'String')) returns contents of stim1code as a double




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
if isnan(handles.rep2stdvalue)
    errordlg('You must enter a numeric value','Bad Input','modal')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function stimulusfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stimulusfile_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimulusfile as text
%        str2double(get(hObject,'String')) returns contents of stimulusfile as a double

handles.stimnames{handles.numofstimnames} = get(hObject,'string');
guidata(hObject, handles);


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
if (get(handles.propertybox,'Value'))
  numofstim = str2double(get(hObject,'String'));
  numofcat = str2double(get(handles.numofcat,'String'));
  minstim = pow2(numofcat);
  if (numofstim < minstim)
    set(hObject,'String',num2str(minstim));
    notestr = ['With ', get(handles.numofcat,'String'), ...
	       ' properties, you need to have at least ', ...
	       num2str(minstim), ' stimuli.'];
    set(handles.stimnotetag,'String',notestr);
    set(handles.stimnotetag,'Visible','on');
  end
end



% --- Executes on button press in propertybox.
function propertybox_Callback(hObject, eventdata, handles)
% hObject    handle to propertybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of propertybox
if (get(hObject,'Value'))
  show_cat(handles);
  set(handles.probabilitybox,'Enable','off');
  set(handles.probabilitybox,'Value',0);
  set(handles.directionbox,'Visible','on');
  set(handles.repcodebox,'Enable','off');
  set(handles.repcodebox,'Value',0);
else
  hide_cat(handles);
  set(handles.probabilitybox,'Enable','on');
  set(handles.repcodebox,'Enable','on');
  set(handles.directionbox,'Value',0);
  set(handles.directionbox,'Visible','off');
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
numofcat = str2double(get(hObject,'String'));
minstim = pow2(numofcat);
if (str2double(get(handles.numofstim,'String')) < minstim)
  set(handles.numofstim,'String',num2str(minstim));
  notestr = ['With ' get(handles.numofcat,'String') ...
	     ' properties, you need to have at least ' ...
	     num2str(minstim) ' stimuli.'];
  set(handles.stimnotetag,'String',notestr);
  set(handles.stimnotetag,'Visible','on');
else
  set(handles.stimnotetag,'Visible','off');
end


% --- Executes during object creation, after setting all properties.
function prop2name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop2name_Callback(hObject, eventdata, handles)
% hObject    handle to prop2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop2name as text
%        str2double(get(hObject,'String')) returns contents of prop2name as a double


% --- Executes during object creation, after setting all properties.
function prop3name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop3name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop3name_Callback(hObject, eventdata, handles)
% hObject    handle to prop3name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop3name as text
%        str2double(get(hObject,'String')) returns contents of prop3name as a double


% --- Executes during object creation, after setting all properties.
function prop4name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop4name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop4name_Callback(hObject, eventdata, handles)
% hObject    handle to prop4name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop4name as text
%        str2double(get(hObject,'String')) returns contents of prop4name as a double


% --- Executes during object creation, after setting all properties.
function prop5name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop5name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop5name_Callback(hObject, eventdata, handles)
% hObject    handle to prop5name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop5name as text
%        str2double(get(hObject,'String')) returns contents of prop5name as a double


% --- Executes during object creation, after setting all properties.
function prop1name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop1name_Callback(hObject, eventdata, handles)
% hObject    handle to prop1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop1name as text
%        str2double(get(hObject,'String')) returns contents of prop1name as a double



% --- Executes on button press in prop1radio1.
function prop1radio1_Callback(hObject, eventdata, handles)
% hObject    handle to prop1radio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop1radio1
off = handles.prop1radio2;
handles.stimuluscats(handles.numofstimnames,1) = 1;
mutual_exclude(off);
guidata(hObject, handles);



% --- Executes on button press in prop1radio2.
function prop1radio2_Callback(hObject, eventdata, handles)
% hObject    handle to prop1radio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop1radio2
off = handles.prop1radio1;
handles.stimuluscats(handles.numofstimnames,1) = 2;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop2radio1.
function prop2radio1_Callback(hObject, eventdata, handles)
% hObject    handle to prop2radio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop2radio1
off = handles.prop2radio2;
handles.stimuluscats(handles.numofstimnames,2) = 1;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop2radio2.
function prop2radio2_Callback(hObject, eventdata, handles)
% hObject    handle to prop2radio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop2radio2
off = handles.prop2radio1;
handles.stimuluscats(handles.numofstimnames,2) = 2;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop3radio1.
function prop3radio1_Callback(hObject, eventdata, handles)
% hObject    handle to prop3radio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop3radio1
off = handles.prop3radio2;
handles.stimuluscats(handles.numofstimnames,3) = 1;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop3radio2.
function prop3radio2_Callback(hObject, eventdata, handles)
% hObject    handle to prop3radio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop3radio2
off = handles.prop3radio1;
handles.stimuluscats(handles.numofstimnames,3) = 2;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop4radio1.
function prop4radio1_Callback(hObject, eventdata, handles)
% hObject    handle to prop4radio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop4radio1
off = handles.prop4radio2;
handles.stimuluscats(handles.numofstimnames,4) = 1;
mutual_exclude(off);
guidata(hObject, handles);

% --- Executes on button press in prop4radio2.
function prop4radio2_Callback(hObject, eventdata, handles)
% hObject    handle to prop4radio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop4radio2
off = handles.prop4radio1;
handles.stimuluscats(handles.numofstimnames,4) = 2;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop5radio1.
function prop5radio1_Callback(hObject, eventdata, handles)
% hObject    handle to prop5radio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop5radio1
off = handles.prop5radio2;
handles.stimuluscats(handles.numofstimnames,5) = 1;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in prop5radio2.
function prop5radio2_Callback(hObject, eventdata, handles)
% hObject    handle to prop5radio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prop5radio
off = handles.prop5radio1;
handles.stimuluscats(handles.numofstimnames,5) = 2;
mutual_exclude(off);
guidata(hObject, handles);


% --- Executes on button press in probabilitybox.
function probabilitybox_Callback(hObject, eventdata, handles)
% hObject    handle to probabilitybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of probabilitybox
if (get(hObject,'Value'))
  set(handles.propertybox,'Enable','off');
else
  if (~get(handles.repcodebox,'Value'))
    set(handles.propertybox,'Enable','on');
  end
end



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

% "Probabilities left" are recalculated because the default
% probability is changed.
totalprob = 0;
for i = 1:handles.numofstimnames-1
  totalprob = totalprob + handles.probabilities(i);
end
handles.probability_left = 100 - totalprob;

if (input > handles.probability_left)
  set(hObject,'String',num2str(handles.probability_left))
  handles.probabilities(handles.numofstimnames) = ...
      handles.probability_left;
  note('Probability changed (total probability exceeded 100%).',handles);
  handles.active_note = 1;
  handles.probability_left = 0;
else
  handles.probability_left = handles.probability_left - input;
  handles.probabilities(handles.numofstimnames) = input;
end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function devcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to devcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function devcode_Callback(hObject, eventdata, handles)
% hObject    handle to devcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of devcode as text
%        str2double(get(hObject,'String')) returns contents of devcode as a double

newcode = get(hObject,'String');
set_devcodes(newcode,handles);


% --- Executes during object creation, after setting all properties.
function firstafterdevcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstafterdevcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function firstafterdevcode_Callback(hObject, eventdata, handles)
% hObject    handle to firstafterdevcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstafterdevcode as text
%        str2double(get(hObject,'String')) returns contents of firstafterdevcode as a double

newcode = get(hObject,'String');
set_firstafterdevcodes(newcode,handles);


% --- Executes during object creation, after setting all properties.
function repbeforestdcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repbeforestdcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function repbeforestdcode_Callback(hObject, eventdata, handles)
% hObject    handle to repbeforestdcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repbeforestdcode as text
%        str2double(get(hObject,'String')) returns contents of repbeforestdcode as a double

newcode = get(hObject,'String');
set_repbeforestdcodes(newcode,handles);


% --- Executes during object creation, after setting all properties.
function stdcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stdcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function stdcode_Callback(hObject, eventdata, handles)
% hObject    handle to stdcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stdcode as text
%        str2double(get(hObject,'String')) returns contents of stdcode as a double

newcode = get(hObject,'String');
set_stdcodes(newcode,handles);


% --- Executes during object creation, after setting all properties.
function laststdcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laststdcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function laststdcode_Callback(hObject, eventdata, handles)
% hObject    handle to laststdcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laststdcode as text
%        str2double(get(hObject,'String')) returns contents of laststdcode as a double

newcode = get(hObject,'String');
set_laststdcodes(newcode,handles);


% --- Sets both the deviant codes (edit text fields) to a given code.
function set_devcodes(newcode, handles)
% newcode    new code for the deviant stimulus (in string format)
% handles    structure with handles and user data (see GUIDATA)

set(handles.devcode,'String',newcode);
set(handles.stim1code,'String',newcode);


% --- Sets both the codes after deviant (edit text fields) to a given code.
function set_firstafterdevcodes(newcode, handles)
% newcode    new code for the first stimulus after deviant
% handles    structure with handles and user data (see GUIDATA)

set(handles.firstafterdevcode,'String',newcode);
set(handles.stim2code,'String',newcode);


% --- Sets all the repetition codes (edit text fields) to a given code.
function set_repbeforestdcodes(newcode, handles)
% newcode    new code for stimuli before stimulus becomes standard
% handles    structure with handles and user data (see GUIDATA)

set(handles.repbeforestdcode,'String',newcode);
set(handles.stim3code,'String',newcode);

rep2std = handles.rep2stdvalue;
if (rep2std >= 3)
  set(handles.stim4codetag,'String',newcode);
  if (rep2std >= 4)
    set(handles.stim5codetag,'String',newcode);
    if (rep2std >= 5)
      set(handles.stim6codetag,'String',newcode);
    end
  end
end


% --- Sets all the standard codes (edit text fields) to a given code.
function set_stdcodes(newcode, handles)
% newcode    new code for standard stimuli
% handles    structure with handles and user data (see GUIDATA)

set(handles.stdcode,'String',newcode);

rep2std = handles.rep2stdvalue;
if (rep2std <= 1)
  set(handles.stim3code,'String',newcode);
  set(handles.stim4codetag,'String',newcode);
  set(handles.stim5codetag,'String',newcode);
  set(handles.stim6codetag,'String',newcode);
  set(handles.stim7codetag,'String',newcode);
  set(handles.stim8codetag,'String',newcode);
  set(handles.stim9codetag,'String',newcode);
else
  switch rep2std
   case 2
    set(handles.stim4code,'String',newcode);
    set(handles.stim5codetag,'String',newcode);
    set(handles.stim6codetag,'String',newcode);
    set(handles.stim7codetag,'String',newcode);
    set(handles.stim8codetag,'String',newcode);
    set(handles.stim9codetag,'String',newcode);
   case 3
    set(handles.stim5code,'String',newcode);
    set(handles.stim6codetag,'String',newcode);
    set(handles.stim7codetag,'String',newcode);
    set(handles.stim8codetag,'String',newcode);
    set(handles.stim9codetag,'String',newcode);
   case 4
    set(handles.stim6code,'String',newcode);
    set(handles.stim7codetag,'String',newcode);
    set(handles.stim8codetag,'String',newcode);
    set(handles.stim9codetag,'String',newcode);
   otherwise
    set(handles.stim7code,'String',newcode);
    set(handles.stim8codetag,'String',newcode);
    set(handles.stim9codetag,'String',newcode);
  end
end


% --- Sets both the last standard codes (edit text fields) to a given code.
function set_laststdcodes(newcode, handles)
% newcode    new code for standard stimuli
% handles    structure with handles and user data (see GUIDATA)

set(handles.stim10code,'String',newcode);
set(handles.laststdcode,'String',newcode);


% --- Returns a vector containing the five trigger codes.
function y = get_codes(handles)
% handles    structure with handles and user data (see GUIDATA)

% If code grid is used (only in state 27)
if (handles.state == 27)
  a(1,1) = str2double(get(handles.grida0,'String'));
  a(1,2) = str2double(get(handles.grida1,'String'));
  a(1,3) = str2double(get(handles.grida2,'String'));
  a(1,4) = str2double(get(handles.grida3,'String'));
  a(1,5) = str2double(get(handles.grida4,'String'));
  a(1,6) = str2double(get(handles.grida5,'String'));
  a(1,7) = str2double(get(handles.grida6,'String'));
  a(1,8) = str2double(get(handles.grida7,'String'));
  a(1,9) = str2double(get(handles.grida8,'String'));
  a(1,10) = str2double(get(handles.grida9,'String'));
  a(1,11) = str2double(get(handles.grida10,'String'));
  a(1,12) = str2double(get(handles.grida11,'String'));
  a(1,13) = str2double(get(handles.grida12,'String'));
  a(1,14) = str2double(get(handles.grida13,'String'));
  a(1,15) = str2double(get(handles.grida14,'String'));
  a(1,16) = str2double(get(handles.grida15,'String'));
  a(1,17) = str2double(get(handles.grida16,'String'));
  a(1,18) = str2double(get(handles.grida17,'String'));
  a(1,19) = str2double(get(handles.grida18,'String'));
  a(1,20) = str2double(get(handles.grida19,'String'));  
  a(1,21) = str2double(get(handles.grida20,'String'));  
  a(2,1) = str2double(get(handles.gridb0,'String'));
  a(2,2) = str2double(get(handles.gridb1,'String'));
  a(2,3) = str2double(get(handles.gridb2,'String'));
  a(2,4) = str2double(get(handles.gridb3,'String'));
  a(2,5) = str2double(get(handles.gridb4,'String'));
  a(2,6) = str2double(get(handles.gridb5,'String'));
  a(2,7) = str2double(get(handles.gridb6,'String'));
  a(2,8) = str2double(get(handles.gridb7,'String'));
  a(2,9) = str2double(get(handles.gridb8,'String'));
  a(2,10) = str2double(get(handles.gridb9,'String'));
  a(2,11) = str2double(get(handles.gridb10,'String'));
  a(2,12) = str2double(get(handles.gridb11,'String'));
  a(2,13) = str2double(get(handles.gridb12,'String'));
  a(2,14) = str2double(get(handles.gridb13,'String'));
  a(2,15) = str2double(get(handles.gridb14,'String'));
  a(2,16) = str2double(get(handles.gridb15,'String'));
  a(2,17) = str2double(get(handles.gridb16,'String'));
  a(2,18) = str2double(get(handles.gridb17,'String'));
  a(2,19) = str2double(get(handles.gridb18,'String'));
  a(2,20) = str2double(get(handles.gridb19,'String'));  
  a(2,21) = str2double(get(handles.gridb20,'String'));  
  a(3,1) = str2double(get(handles.gridc0,'String'));
  a(3,2) = str2double(get(handles.gridc1,'String'));
  a(3,3) = str2double(get(handles.gridc2,'String'));
  a(3,4) = str2double(get(handles.gridc3,'String'));
  a(3,5) = str2double(get(handles.gridc4,'String'));
  a(3,6) = str2double(get(handles.gridc5,'String'));
  a(3,7) = str2double(get(handles.gridc6,'String'));
  a(3,8) = str2double(get(handles.gridc7,'String'));
  a(3,9) = str2double(get(handles.gridc8,'String'));
  a(3,10) = str2double(get(handles.gridc9,'String'));
  a(3,11) = str2double(get(handles.gridc10,'String'));
  a(3,12) = str2double(get(handles.gridc11,'String'));
  a(3,13) = str2double(get(handles.gridc12,'String'));
  a(3,14) = str2double(get(handles.gridc13,'String'));
  a(3,15) = str2double(get(handles.gridc14,'String'));
  a(3,16) = str2double(get(handles.gridc15,'String'));
  a(3,17) = str2double(get(handles.gridc16,'String'));
  a(3,18) = str2double(get(handles.gridc17,'String'));
  a(3,19) = str2double(get(handles.gridc18,'String'));
  a(3,20) = str2double(get(handles.gridc19,'String'));  
  a(3,21) = str2double(get(handles.gridc20,'String'));  
  a(4,1) = str2double(get(handles.gridd0,'String'));
  a(4,2) = str2double(get(handles.gridd1,'String'));
  a(4,3) = str2double(get(handles.gridd2,'String'));
  a(4,4) = str2double(get(handles.gridd3,'String'));
  a(4,5) = str2double(get(handles.gridd4,'String'));
  a(4,6) = str2double(get(handles.gridd5,'String'));
  a(4,7) = str2double(get(handles.gridd6,'String'));
  a(4,8) = str2double(get(handles.gridd7,'String'));
  a(4,9) = str2double(get(handles.gridd8,'String'));
  a(4,10) = str2double(get(handles.gridd9,'String'));
  a(4,11) = str2double(get(handles.gridd10,'String'));
  a(4,12) = str2double(get(handles.gridd11,'String'));
  a(4,13) = str2double(get(handles.gridd12,'String'));
  a(4,14) = str2double(get(handles.gridd13,'String'));
  a(4,15) = str2double(get(handles.gridd14,'String'));
  a(4,16) = str2double(get(handles.gridd15,'String'));
  a(4,17) = str2double(get(handles.gridd16,'String'));
  a(4,18) = str2double(get(handles.gridd17,'String'));
  a(4,19) = str2double(get(handles.gridd18,'String'));
  a(4,20) = str2double(get(handles.gridd19,'String'));  
  a(4,21) = str2double(get(handles.gridd20,'String'));  
  a(5,1) = str2double(get(handles.gride0,'String'));
  a(5,2) = str2double(get(handles.gride1,'String'));
  a(5,3) = str2double(get(handles.gride2,'String'));
  a(5,4) = str2double(get(handles.gride3,'String'));
  a(5,5) = str2double(get(handles.gride4,'String'));
  a(5,6) = str2double(get(handles.gride5,'String'));
  a(5,7) = str2double(get(handles.gride6,'String'));
  a(5,8) = str2double(get(handles.gride7,'String'));
  a(5,9) = str2double(get(handles.gride8,'String'));
  a(5,10) = str2double(get(handles.gride9,'String'));
  a(5,11) = str2double(get(handles.gride10,'String'));
  a(5,12) = str2double(get(handles.gride11,'String'));
  a(5,13) = str2double(get(handles.gride12,'String'));
  a(5,14) = str2double(get(handles.gride13,'String'));
  a(5,15) = str2double(get(handles.gride14,'String'));
  a(5,16) = str2double(get(handles.gride15,'String'));
  a(5,17) = str2double(get(handles.gride16,'String'));
  a(5,18) = str2double(get(handles.gride17,'String'));
  a(5,19) = str2double(get(handles.gride18,'String'));
  a(5,20) = str2double(get(handles.gride19,'String'));  
  a(5,21) = str2double(get(handles.gride20,'String'));  

else

  a(1) = str2double(get(handles.devcode,'String'));
  a(2) = str2double(get(handles.firstafterdevcode,'String'));
  a(3) = str2double(get(handles.repbeforestdcode,'String'));
  a(4) = str2double(get(handles.stdcode,'String'));
  a(5) = str2double(get(handles.laststdcode,'String'));
  
end

y = a;


% --- Executes on button press in repcodebox.
function repcodebox_Callback(hObject, eventdata, handles)
% hObject    handle to repcodebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of repcodebox
if (get(hObject,'Value'))
  set(handles.propertybox,'Enable','off');
else
  if (~get(handles.probabilitybox,'Value'))
    set(handles.propertybox,'Enable','on');
  end
end


% --- Executes during object creation, after setting all properties.
function grida1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida1_Callback(hObject, eventdata, handles)
% hObject    handle to grida1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida1 as text
%        str2double(get(hObject,'String')) returns contents of grida1 as a double


% --- Executes during object creation, after setting all properties.
function grida2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida2_Callback(hObject, eventdata, handles)
% hObject    handle to grida2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida2 as text
%        str2double(get(hObject,'String')) returns contents of grida2 as a double


% --- Executes during object creation, after setting all properties.
function grida3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida3_Callback(hObject, eventdata, handles)
% hObject    handle to grida3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida3 as text
%        str2double(get(hObject,'String')) returns contents of grida3 as a double


% --- Executes during object creation, after setting all properties.
function grida4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida4_Callback(hObject, eventdata, handles)
% hObject    handle to grida4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida4 as text
%        str2double(get(hObject,'String')) returns contents of grida4 as a double


% --- Executes during object creation, after setting all properties.
function grida5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida5_Callback(hObject, eventdata, handles)
% hObject    handle to grida5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida5 as text
%        str2double(get(hObject,'String')) returns contents of grida5 as a double


% --- Executes during object creation, after setting all properties.
function grida6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida6_Callback(hObject, eventdata, handles)
% hObject    handle to grida6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida6 as text
%        str2double(get(hObject,'String')) returns contents of grida6 as a double


% --- Executes during object creation, after setting all properties.
function grida7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida7_Callback(hObject, eventdata, handles)
% hObject    handle to grida7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida7 as text
%        str2double(get(hObject,'String')) returns contents of grida7 as a double


% --- Executes during object creation, after setting all properties.
function grida8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida8_Callback(hObject, eventdata, handles)
% hObject    handle to grida8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida8 as text
%        str2double(get(hObject,'String')) returns contents of grida8 as a double


% --- Executes during object creation, after setting all properties.
function grida9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida9_Callback(hObject, eventdata, handles)
% hObject    handle to grida9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida9 as text
%        str2double(get(hObject,'String')) returns contents of grida9 as a double


% --- Executes during object creation, after setting all properties.
function grida10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida10_Callback(hObject, eventdata, handles)
% hObject    handle to grida10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida10 as text
%        str2double(get(hObject,'String')) returns contents of grida10 as a double


% --- Executes during object creation, after setting all properties.
function grida11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida11_Callback(hObject, eventdata, handles)
% hObject    handle to grida11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida11 as text
%        str2double(get(hObject,'String')) returns contents of grida11 as a double


% --- Executes during object creation, after setting all properties.
function grida12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida12_Callback(hObject, eventdata, handles)
% hObject    handle to grida12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida12 as text
%        str2double(get(hObject,'String')) returns contents of grida12 as a double


% --- Executes during object creation, after setting all properties.
function grida13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida13_Callback(hObject, eventdata, handles)
% hObject    handle to grida13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida13 as text
%        str2double(get(hObject,'String')) returns contents of grida13 as a double


% --- Executes during object creation, after setting all properties.
function grida14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida14_Callback(hObject, eventdata, handles)
% hObject    handle to grida14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida14 as text
%        str2double(get(hObject,'String')) returns contents of grida14 as a double


% --- Executes during object creation, after setting all properties.
function grida15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida15_Callback(hObject, eventdata, handles)
% hObject    handle to grida15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida15 as text
%        str2double(get(hObject,'String')) returns contents of grida15 as a double


% --- Executes during object creation, after setting all properties.
function grida16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida16_Callback(hObject, eventdata, handles)
% hObject    handle to grida16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida16 as text
%        str2double(get(hObject,'String')) returns contents of grida16 as a double


% --- Executes during object creation, after setting all properties.
function grida17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida17_Callback(hObject, eventdata, handles)
% hObject    handle to grida17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida17 as text
%        str2double(get(hObject,'String')) returns contents of grida17 as a double


% --- Executes during object creation, after setting all properties.
function grida18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida18_Callback(hObject, eventdata, handles)
% hObject    handle to grida18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida18 as text
%        str2double(get(hObject,'String')) returns contents of grida18 as a double


% --- Executes during object creation, after setting all properties.
function grida19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida19_Callback(hObject, eventdata, handles)
% hObject    handle to grida19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida19 as text
%        str2double(get(hObject,'String')) returns contents of grida19 as a double


% --- Executes during object creation, after setting all properties.
function grida20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida20_Callback(hObject, eventdata, handles)
% hObject    handle to grida20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida20 as text
%        str2double(get(hObject,'String')) returns contents of grida20 as a double


% --- Executes during object creation, after setting all properties.
function gridb1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb1_Callback(hObject, eventdata, handles)
% hObject    handle to gridb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb1 as text
%        str2double(get(hObject,'String')) returns contents of gridb1 as a double


% --- Executes during object creation, after setting all properties.
function gridb2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb2_Callback(hObject, eventdata, handles)
% hObject    handle to gridb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb2 as text
%        str2double(get(hObject,'String')) returns contents of gridb2 as a double


% --- Executes during object creation, after setting all properties.
function gridb3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb3_Callback(hObject, eventdata, handles)
% hObject    handle to gridb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb3 as text
%        str2double(get(hObject,'String')) returns contents of gridb3 as a double


% --- Executes during object creation, after setting all properties.
function gridb4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb4_Callback(hObject, eventdata, handles)
% hObject    handle to gridb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb4 as text
%        str2double(get(hObject,'String')) returns contents of gridb4 as a double


% --- Executes during object creation, after setting all properties.
function gridb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb_Callback(hObject, eventdata, handles)
% hObject    handle to gridb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb5 as text
%        str2double(get(hObject,'String')) returns contents of gridb5 as a double


% --- Executes during object creation, after setting all properties.
function gridb6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb6_Callback(hObject, eventdata, handles)
% hObject    handle to gridb6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb6 as text
%        str2double(get(hObject,'String')) returns contents of gridb6 as a double


% --- Executes during object creation, after setting all properties.
function gridb7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb7_Callback(hObject, eventdata, handles)
% hObject    handle to gridb7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb7 as text
%        str2double(get(hObject,'String')) returns contents of gridb7 as a double


% --- Executes during object creation, after setting all properties.
function gridb8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb8_Callback(hObject, eventdata, handles)
% hObject    handle to gridb8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb8 as text
%        str2double(get(hObject,'String')) returns contents of gridb8 as a double


% --- Executes during object creation, after setting all properties.
function gridb9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb9_Callback(hObject, eventdata, handles)
% hObject    handle to gridb9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb9 as text
%        str2double(get(hObject,'String')) returns contents of gridb9 as a double


% --- Executes during object creation, after setting all properties.
function gridb10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb10_Callback(hObject, eventdata, handles)
% hObject    handle to gridb10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb10 as text
%        str2double(get(hObject,'String')) returns contents of gridb10 as a double


% --- Executes during object creation, after setting all properties.
function gridb11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb11_Callback(hObject, eventdata, handles)
% hObject    handle to gridb11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb11 as text
%        str2double(get(hObject,'String')) returns contents of gridb11 as a double


% --- Executes during object creation, after setting all properties.
function gridb12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb12_Callback(hObject, eventdata, handles)
% hObject    handle to gridb12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb12 as text
%        str2double(get(hObject,'String')) returns contents of gridb12 as a double


% --- Executes during object creation, after setting all properties.
function gridb13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb13_Callback(hObject, eventdata, handles)
% hObject    handle to gridb13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb13 as text
%        str2double(get(hObject,'String')) returns contents of gridb13 as a double


% --- Executes during object creation, after setting all properties.
function gridb14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb14_Callback(hObject, eventdata, handles)
% hObject    handle to gridb14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb14 as text
%        str2double(get(hObject,'String')) returns contents of gridb14 as a double


% --- Executes during object creation, after setting all properties.
function gridb15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb15_Callback(hObject, eventdata, handles)
% hObject    handle to gridb15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb15 as text
%        str2double(get(hObject,'String')) returns contents of gridb15 as a double


% --- Executes during object creation, after setting all properties.
function gridb16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb16_Callback(hObject, eventdata, handles)
% hObject    handle to gridb16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb16 as text
%        str2double(get(hObject,'String')) returns contents of gridb16 as a double


% --- Executes during object creation, after setting all properties.
function gridb17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb17_Callback(hObject, eventdata, handles)
% hObject    handle to gridb17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb17 as text
%        str2double(get(hObject,'String')) returns contents of gridb17 as a double


% --- Executes during object creation, after setting all properties.
function gridb18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb18_Callback(hObject, eventdata, handles)
% hObject    handle to gridb18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb18 as text
%        str2double(get(hObject,'String')) returns contents of gridb18 as a double


% --- Executes during object creation, after setting all properties.
function gridb19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb19_Callback(hObject, eventdata, handles)
% hObject    handle to gridb19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb19 as text
%        str2double(get(hObject,'String')) returns contents of gridb19 as a double


% --- Executes during object creation, after setting all properties.
function gridb20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb20_Callback(hObject, eventdata, handles)
% hObject    handle to gridb20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb20 as text
%        str2double(get(hObject,'String')) returns contents of gridb20 as a double


% --- Executes during object creation, after setting all properties.
function gridc0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc0_Callback(hObject, eventdata, handles)
% hObject    handle to gridc0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc0 as text
%        str2double(get(hObject,'String')) returns contents of gridc0 as a double


% --- Executes during object creation, after setting all properties.
function gridb0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb0_Callback(hObject, eventdata, handles)
% hObject    handle to gridb0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb0 as text
%        str2double(get(hObject,'String')) returns contents of gridb0 as a double


% --- Executes during object creation, after setting all properties.
function grida0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grida0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function grida0_Callback(hObject, eventdata, handles)
% hObject    handle to grida0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grida0 as text
%        str2double(get(hObject,'String')) returns contents of grida0 as a double



% --- Executes during object creation, after setting all properties.
function gridb5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridb5_Callback(hObject, eventdata, handles)
% hObject    handle to gridb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridb5 as text
%        str2double(get(hObject,'String')) returns contents of gridb5 as a double


% --- Executes during object creation, after setting all properties.
function gridc20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc20_Callback(hObject, eventdata, handles)
% hObject    handle to gridc20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc20 as text
%        str2double(get(hObject,'String')) returns contents of gridc20 as a double


% --- Executes during object creation, after setting all properties.
function gridc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc1_Callback(hObject, eventdata, handles)
% hObject    handle to gridc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc1 as text
%        str2double(get(hObject,'String')) returns contents of gridc1 as a double


% --- Executes during object creation, after setting all properties.
function gridc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc2_Callback(hObject, eventdata, handles)
% hObject    handle to gridc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc2 as text
%        str2double(get(hObject,'String')) returns contents of gridc2 as a double


% --- Executes during object creation, after setting all properties.
function gridc3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc3_Callback(hObject, eventdata, handles)
% hObject    handle to gridc3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc3 as text
%        str2double(get(hObject,'String')) returns contents of gridc3 as a double


% --- Executes during object creation, after setting all properties.
function gridc4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc4_Callback(hObject, eventdata, handles)
% hObject    handle to gridc4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc4 as text
%        str2double(get(hObject,'String')) returns contents of gridc4 as a double


% --- Executes during object creation, after setting all properties.
function gridc5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc5_Callback(hObject, eventdata, handles)
% hObject    handle to gridc5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc5 as text
%        str2double(get(hObject,'String')) returns contents of gridc5 as a double


% --- Executes during object creation, after setting all properties.
function gridc6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc6_Callback(hObject, eventdata, handles)
% hObject    handle to gridc6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc6 as text
%        str2double(get(hObject,'String')) returns contents of gridc6 as a double


% --- Executes during object creation, after setting all properties.
function gridc7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc7_Callback(hObject, eventdata, handles)
% hObject    handle to gridc7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc7 as text
%        str2double(get(hObject,'String')) returns contents of gridc7 as a double


% --- Executes during object creation, after setting all properties.
function gridc8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc8_Callback(hObject, eventdata, handles)
% hObject    handle to gridc8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc8 as text
%        str2double(get(hObject,'String')) returns contents of gridc8 as a double


% --- Executes during object creation, after setting all properties.
function gridc9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc9_Callback(hObject, eventdata, handles)
% hObject    handle to gridc9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc9 as text
%        str2double(get(hObject,'String')) returns contents of gridc9 as a double


% --- Executes during object creation, after setting all properties.
function gridc10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc10_Callback(hObject, eventdata, handles)
% hObject    handle to gridc10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc10 as text
%        str2double(get(hObject,'String')) returns contents of gridc10 as a double


% --- Executes during object creation, after setting all properties.
function gridc11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc11_Callback(hObject, eventdata, handles)
% hObject    handle to gridc11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc11 as text
%        str2double(get(hObject,'String')) returns contents of gridc11 as a double


% --- Executes during object creation, after setting all properties.
function gridc12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc12_Callback(hObject, eventdata, handles)
% hObject    handle to gridc12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc12 as text
%        str2double(get(hObject,'String')) returns contents of gridc12 as a double


% --- Executes during object creation, after setting all properties.
function gridc13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc13_Callback(hObject, eventdata, handles)
% hObject    handle to gridc13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc13 as text
%        str2double(get(hObject,'String')) returns contents of gridc13 as a double


% --- Executes during object creation, after setting all properties.
function gridc14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc14_Callback(hObject, eventdata, handles)
% hObject    handle to gridc14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc14 as text
%        str2double(get(hObject,'String')) returns contents of gridc14 as a double


% --- Executes during object creation, after setting all properties.
function gridc15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc15_Callback(hObject, eventdata, handles)
% hObject    handle to gridc15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc15 as text
%        str2double(get(hObject,'String')) returns contents of gridc15 as a double


% --- Executes during object creation, after setting all properties.
function gridc16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc16_Callback(hObject, eventdata, handles)
% hObject    handle to gridc16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc16 as text
%        str2double(get(hObject,'String')) returns contents of gridc16 as a double


% --- Executes during object creation, after setting all properties.
function gridc17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc17_Callback(hObject, eventdata, handles)
% hObject    handle to gridc17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc17 as text
%        str2double(get(hObject,'String')) returns contents of gridc17 as a double


% --- Executes during object creation, after setting all properties.
function gridc18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc18_Callback(hObject, eventdata, handles)
% hObject    handle to gridc18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc18 as text
%        str2double(get(hObject,'String')) returns contents of gridc18 as a double


% --- Executes during object creation, after setting all properties.
function gridc19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridc19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridc19_Callback(hObject, eventdata, handles)
% hObject    handle to gridc19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridc19 as text
%        str2double(get(hObject,'String')) returns contents of gridc19 as a double


% --- Executes during object creation, after setting all properties.
function gridd14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd14_Callback(hObject, eventdata, handles)
% hObject    handle to gridd14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd14 as text
%        str2double(get(hObject,'String')) returns contents of gridd14 as a double


% --- Executes during object creation, after setting all properties.
function gridd0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd0_Callback(hObject, eventdata, handles)
% hObject    handle to gridd0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd0 as text
%        str2double(get(hObject,'String')) returns contents of gridd0 as a double


% --- Executes during object creation, after setting all properties.
function gridd1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd1_Callback(hObject, eventdata, handles)
% hObject    handle to gridd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd1 as text
%        str2double(get(hObject,'String')) returns contents of gridd1 as a double


% --- Executes during object creation, after setting all properties.
function gridd2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd2_Callback(hObject, eventdata, handles)
% hObject    handle to gridd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd2 as text
%        str2double(get(hObject,'String')) returns contents of gridd2 as a double


% --- Executes during object creation, after setting all properties.
function gridd3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd3_Callback(hObject, eventdata, handles)
% hObject    handle to gridd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd3 as text
%        str2double(get(hObject,'String')) returns contents of gridd3 as a double


% --- Executes during object creation, after setting all properties.
function gridd4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd4_Callback(hObject, eventdata, handles)
% hObject    handle to gridd4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd4 as text
%        str2double(get(hObject,'String')) returns contents of gridd4 as a double


% --- Executes during object creation, after setting all properties.
function gridd5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd5_Callback(hObject, eventdata, handles)
% hObject    handle to gridd5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd5 as text
%        str2double(get(hObject,'String')) returns contents of gridd5 as a double


% --- Executes during object creation, after setting all properties.
function gridd6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd6_Callback(hObject, eventdata, handles)
% hObject    handle to gridd6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd6 as text
%        str2double(get(hObject,'String')) returns contents of gridd6 as a double


% --- Executes during object creation, after setting all properties.
function gridd7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd7_Callback(hObject, eventdata, handles)
% hObject    handle to gridd7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd7 as text
%        str2double(get(hObject,'String')) returns contents of gridd7 as a double


% --- Executes during object creation, after setting all properties.
function gridd8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd8_Callback(hObject, eventdata, handles)
% hObject    handle to gridd8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd8 as text
%        str2double(get(hObject,'String')) returns contents of gridd8 as a double


% --- Executes during object creation, after setting all properties.
function gridd9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd9_Callback(hObject, eventdata, handles)
% hObject    handle to gridd9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd9 as text
%        str2double(get(hObject,'String')) returns contents of gridd9 as a double


% --- Executes during object creation, after setting all properties.
function gridd10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd10_Callback(hObject, eventdata, handles)
% hObject    handle to gridd10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd10 as text
%        str2double(get(hObject,'String')) returns contents of gridd10 as a double


% --- Executes during object creation, after setting all properties.
function gridd11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd11_Callback(hObject, eventdata, handles)
% hObject    handle to gridd11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd11 as text
%        str2double(get(hObject,'String')) returns contents of gridd11 as a double


% --- Executes during object creation, after setting all properties.
function gridd12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd12_Callback(hObject, eventdata, handles)
% hObject    handle to gridd12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd12 as text
%        str2double(get(hObject,'String')) returns contents of gridd12 as a double


% --- Executes during object creation, after setting all properties.
function gridd13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd13_Callback(hObject, eventdata, handles)
% hObject    handle to gridd13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd13 as text
%        str2double(get(hObject,'String')) returns contents of gridd13 as a double


% --- Executes during object creation, after setting all properties.
function gridd15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd15_Callback(hObject, eventdata, handles)
% hObject    handle to gridd15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd15 as text
%        str2double(get(hObject,'String')) returns contents of gridd15 as a double


% --- Executes during object creation, after setting all properties.
function gridd16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd16_Callback(hObject, eventdata, handles)
% hObject    handle to gridd16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd16 as text
%        str2double(get(hObject,'String')) returns contents of gridd16 as a double


% --- Executes during object creation, after setting all properties.
function gridd17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd17_Callback(hObject, eventdata, handles)
% hObject    handle to gridd17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd17 as text
%        str2double(get(hObject,'String')) returns contents of gridd17 as a double


% --- Executes during object creation, after setting all properties.
function gridd18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd18_Callback(hObject, eventdata, handles)
% hObject    handle to gridd18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd18 as text
%        str2double(get(hObject,'String')) returns contents of gridd18 as a double


% --- Executes during object creation, after setting all properties.
function gridd19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd19_Callback(hObject, eventdata, handles)
% hObject    handle to gridd19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd19 as text
%        str2double(get(hObject,'String')) returns contents of gridd19 as a double


% --- Executes during object creation, after setting all properties.
function gridd20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridd20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gridd20_Callback(hObject, eventdata, handles)
% hObject    handle to gridd20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridd20 as text
%        str2double(get(hObject,'String')) returns contents of gridd20 as a double


% --- Executes during object creation, after setting all properties.
function gride20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride20_Callback(hObject, eventdata, handles)
% hObject    handle to gride20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride20 as text
%        str2double(get(hObject,'String')) returns contents of gride20 as a double


% --- Executes during object creation, after setting all properties.
function gride0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride0_Callback(hObject, eventdata, handles)
% hObject    handle to gride0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride0 as text
%        str2double(get(hObject,'String')) returns contents of gride0 as a double


% --- Executes during object creation, after setting all properties.
function gride1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride1_Callback(hObject, eventdata, handles)
% hObject    handle to gride1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride1 as text
%        str2double(get(hObject,'String')) returns contents of gride1 as a double


% --- Executes during object creation, after setting all properties.
function gride2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride2_Callback(hObject, eventdata, handles)
% hObject    handle to gride2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride2 as text
%        str2double(get(hObject,'String')) returns contents of gride2 as a double


% --- Executes during object creation, after setting all properties.
function gride3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride3_Callback(hObject, eventdata, handles)
% hObject    handle to gride3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride3 as text
%        str2double(get(hObject,'String')) returns contents of gride3 as a double


% --- Executes during object creation, after setting all properties.
function gride4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride4_Callback(hObject, eventdata, handles)
% hObject    handle to gride4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride4 as text
%        str2double(get(hObject,'String')) returns contents of gride4 as a double


% --- Executes during object creation, after setting all properties.
function gride5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride5_Callback(hObject, eventdata, handles)
% hObject    handle to gride5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride5 as text
%        str2double(get(hObject,'String')) returns contents of gride5 as a double


% --- Executes during object creation, after setting all properties.
function gride6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride6_Callback(hObject, eventdata, handles)
% hObject    handle to gride6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride6 as text
%        str2double(get(hObject,'String')) returns contents of gride6 as a double


% --- Executes during object creation, after setting all properties.
function gride7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride7_Callback(hObject, eventdata, handles)
% hObject    handle to gride7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride7 as text
%        str2double(get(hObject,'String')) returns contents of gride7 as a double


% --- Executes during object creation, after setting all properties.
function gride8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride8_Callback(hObject, eventdata, handles)
% hObject    handle to gride8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride8 as text
%        str2double(get(hObject,'String')) returns contents of gride8 as a double


% --- Executes during object creation, after setting all properties.
function gride9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride9_Callback(hObject, eventdata, handles)
% hObject    handle to gride9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride9 as text
%        str2double(get(hObject,'String')) returns contents of gride9 as a double


% --- Executes during object creation, after setting all properties.
function gride10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride10_Callback(hObject, eventdata, handles)
% hObject    handle to gride10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride10 as text
%        str2double(get(hObject,'String')) returns contents of gride10 as a double


% --- Executes during object creation, after setting all properties.
function gride11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride11_Callback(hObject, eventdata, handles)
% hObject    handle to gride11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride11 as text
%        str2double(get(hObject,'String')) returns contents of gride11 as a double


% --- Executes during object creation, after setting all properties.
function gride12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride12_Callback(hObject, eventdata, handles)
% hObject    handle to gride12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride12 as text
%        str2double(get(hObject,'String')) returns contents of gride12 as a double


% --- Executes during object creation, after setting all properties.
function gride13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride13_Callback(hObject, eventdata, handles)
% hObject    handle to gride13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride13 as text
%        str2double(get(hObject,'String')) returns contents of gride13 as a double


% --- Executes during object creation, after setting all properties.
function gride14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride14_Callback(hObject, eventdata, handles)
% hObject    handle to gride14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride14 as text
%        str2double(get(hObject,'String')) returns contents of gride14 as a double


% --- Executes during object creation, after setting all properties.
function gride15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride15_Callback(hObject, eventdata, handles)
% hObject    handle to gride15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride15 as text
%        str2double(get(hObject,'String')) returns contents of gride15 as a double


% --- Executes during object creation, after setting all properties.
function gride16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride16_Callback(hObject, eventdata, handles)
% hObject    handle to gride16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride16 as text
%        str2double(get(hObject,'String')) returns contents of gride16 as a double


% --- Executes during object creation, after setting all properties.
function gride17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride17_Callback(hObject, eventdata, handles)
% hObject    handle to gride17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride17 as text
%        str2double(get(hObject,'String')) returns contents of gride17 as a double


% --- Executes during object creation, after setting all properties.
function gride18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride18_Callback(hObject, eventdata, handles)
% hObject    handle to gride18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride18 as text
%        str2double(get(hObject,'String')) returns contents of gride18 as a double


% --- Executes during object creation, after setting all properties.
function gride19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gride19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function gride19_Callback(hObject, eventdata, handles)
% hObject    handle to gride19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gride19 as text
%        str2double(get(hObject,'String')) returns contents of gride19 as a double




% --- Sets probability radio buttons according to the stimulus.
%     (needed when back button is pressed to set earlier settings)
function set_property_radios(handles)
cats = str2double(get(handles.numofcat,'string'));

if (handles.stimuluscats(handles.numofstimnames,1) == 0)
  set(handles.prop1radio1,'Value',0);
  set(handles.prop1radio2,'Value',0);
else
  if (handles.stimuluscats(handles.numofstimnames,1) == 1)
    set(handles.prop1radio1,'Value',1);
    set(handles.prop1radio2,'Value',0);
  else
    if (handles.stimuluscats(handles.numofstimnames,1) == 2)
      set(handles.prop1radio1,'Value',0);
      set(handles.prop1radio2,'Value',1);
    end
  end
end

if (cats >= 2)
  if (handles.stimuluscats(handles.numofstimnames,2) == 0)
    set(handles.prop2radio1,'Value',0);
    set(handles.prop2radio2,'Value',0);
  else
    if (handles.stimuluscats(handles.numofstimnames,2) == 1)
      set(handles.prop2radio1,'Value',1);
      set(handles.prop2radio2,'Value',0);
    else
      if (handles.stimuluscats(handles.numofstimnames,2) == 2)
	set(handles.prop2radio1,'Value',0);
	set(handles.prop2radio2,'Value',1);
      end
    end
  end
end

if (cats >= 3)
  if (handles.stimuluscats(handles.numofstimnames,3) == 0)
    set(handles.prop3radio1,'Value',0);
    set(handles.prop3radio2,'Value',0);
  else
    if (handles.stimuluscats(handles.numofstimnames,3) == 1)
      set(handles.prop3radio1,'Value',1);
      set(handles.prop3radio2,'Value',0);
    else
      if (handles.stimuluscats(handles.numofstimnames,3) == 2)
	set(handles.prop3radio1,'Value',0);
	set(handles.prop3radio2,'Value',1);
      end
    end
  end
end
  
if (cats >= 4)
  if (handles.stimuluscats(handles.numofstimnames,4) == 0)
    set(handles.prop4radio1,'Value',0);
    set(handles.prop4radio2,'Value',0);
  else
    if (handles.stimuluscats(handles.numofstimnames,4) == 1)
      set(handles.prop4radio1,'Value',1);
      set(handles.prop4radio2,'Value',0);
    else
      if (handles.stimuluscats(handles.numofstimnames,4) == 2)
	set(handles.prop4radio1,'Value',0);
	set(handles.prop4radio2,'Value',1);
      end
    end
  end
end

if (cats >= 5)
  if (handles.stimuluscats(handles.numofstimnames,5) == 0)
    set(handles.prop5radio1,'Value',0);
    set(handles.prop5radio2,'Value',0);
  else
    if (handles.stimuluscats(handles.numofstimnames,5) == 1)
      set(handles.prop5radio1,'Value',1);
      set(handles.prop5radio2,'Value',0);
    else
      if (handles.stimuluscats(handles.numofstimnames,5) == 2)
	set(handles.prop5radio1,'Value',0);
	set(handles.prop5radio2,'Value',1);
      end
    end
  end
end




% --- Shows grid column C with number N
function show_grid_column(C, N, handles)

num = num2str(N);

switch C
  
  case 0
   set(handles.grida0tag,'String',num);
   set(handles.gridb0tag,'String',num);
   set(handles.gridc0tag,'String',num);
   set(handles.gridd0tag,'String',num);
   set(handles.gride0tag,'String',num);
   set(handles.grida0tag,'Visible','on');
   set(handles.gridb0tag,'Visible','on');
   set(handles.gridc0tag,'Visible','on');
   set(handles.gridd0tag,'Visible','on');
   set(handles.gride0tag,'Visible','on');
   set(handles.grida0,'Visible','on');
   set(handles.gridb0,'Visible','on');
   set(handles.gridc0,'Visible','on');
   set(handles.gridd0,'Visible','on');
   set(handles.gride0,'Visible','on');
  
 case 1
  set(handles.grida1tag,'String',num);
  set(handles.gridb1tag,'String',num);
  set(handles.gridc1tag,'String',num);
  set(handles.gridd1tag,'String',num);
  set(handles.gride1tag,'String',num);
  set(handles.grida1tag,'Visible','on');
  set(handles.gridb1tag,'Visible','on');
  set(handles.gridc1tag,'Visible','on');
  set(handles.gridd1tag,'Visible','on');
  set(handles.gride1tag,'Visible','on');
  set(handles.grida1,'Visible','on');
  set(handles.gridb1,'Visible','on');
  set(handles.gridc1,'Visible','on');
  set(handles.gridd1,'Visible','on');
  set(handles.gride1,'Visible','on');

 case 2
  set(handles.grida2tag,'String',num);
  set(handles.gridb2tag,'String',num);
  set(handles.gridc2tag,'String',num);
  set(handles.gridd2tag,'String',num);
  set(handles.gride2tag,'String',num);
  set(handles.grida2tag,'Visible','on');
  set(handles.gridb2tag,'Visible','on');
  set(handles.gridc2tag,'Visible','on');
  set(handles.gridd2tag,'Visible','on');
  set(handles.gride2tag,'Visible','on');
  set(handles.grida2,'Visible','on');
  set(handles.gridb2,'Visible','on');
  set(handles.gridc2,'Visible','on');
  set(handles.gridd2,'Visible','on');
  set(handles.gride2,'Visible','on');

 case 3
  set(handles.grida3tag,'String',num);
  set(handles.gridb3tag,'String',num);
  set(handles.gridc3tag,'String',num);
  set(handles.gridd3tag,'String',num);
  set(handles.gride3tag,'String',num);
  set(handles.grida3tag,'Visible','on');
  set(handles.gridb3tag,'Visible','on');
  set(handles.gridc3tag,'Visible','on');
  set(handles.gridd3tag,'Visible','on');
  set(handles.gride3tag,'Visible','on');
  set(handles.grida3,'Visible','on');
  set(handles.gridb3,'Visible','on');
  set(handles.gridc3,'Visible','on');
  set(handles.gridd3,'Visible','on');
  set(handles.gride3,'Visible','on');
  
 case 4
  set(handles.grida4tag,'String',num);
  set(handles.gridb4tag,'String',num);
  set(handles.gridc4tag,'String',num);
  set(handles.gridd4tag,'String',num);
  set(handles.gride4tag,'String',num);
  set(handles.grida4tag,'Visible','on');
  set(handles.gridb4tag,'Visible','on');
  set(handles.gridc4tag,'Visible','on');
  set(handles.gridd4tag,'Visible','on');
  set(handles.gride4tag,'Visible','on');
  set(handles.grida4,'Visible','on');
  set(handles.gridb4,'Visible','on');
  set(handles.gridc4,'Visible','on');
  set(handles.gridd4,'Visible','on');
  set(handles.gride4,'Visible','on');
  
 case 5
  set(handles.grida5tag,'String',num);
  set(handles.gridb5tag,'String',num);
  set(handles.gridc5tag,'String',num);
  set(handles.gridd5tag,'String',num);
  set(handles.gride5tag,'String',num);
  set(handles.grida5tag,'Visible','on');
  set(handles.gridb5tag,'Visible','on');
  set(handles.gridc5tag,'Visible','on');
  set(handles.gridd5tag,'Visible','on');
  set(handles.gride5tag,'Visible','on');
  set(handles.grida5,'Visible','on');
  set(handles.gridb5,'Visible','on');
  set(handles.gridc5,'Visible','on');
  set(handles.gridd5,'Visible','on');
  set(handles.gride5,'Visible','on');
  
 case 6
  set(handles.grida6tag,'String',num);
  set(handles.gridb6tag,'String',num);
  set(handles.gridc6tag,'String',num);
  set(handles.gridd6tag,'String',num);
  set(handles.gride6tag,'String',num);
  set(handles.grida6tag,'Visible','on');
  set(handles.gridb6tag,'Visible','on');
  set(handles.gridc6tag,'Visible','on');
  set(handles.gridd6tag,'Visible','on');
  set(handles.gride6tag,'Visible','on');
  set(handles.grida6,'Visible','on');
  set(handles.gridb6,'Visible','on');
  set(handles.gridc6,'Visible','on');
  set(handles.gridd6,'Visible','on');
  set(handles.gride6,'Visible','on');
  
 case 7
  set(handles.grida7tag,'String',num);
  set(handles.gridb7tag,'String',num);
  set(handles.gridc7tag,'String',num);
  set(handles.gridd7tag,'String',num);
  set(handles.gride7tag,'String',num);
  set(handles.grida7tag,'Visible','on');
  set(handles.gridb7tag,'Visible','on');
  set(handles.gridc7tag,'Visible','on');
  set(handles.gridd7tag,'Visible','on');
  set(handles.gride7tag,'Visible','on');
  set(handles.grida7,'Visible','on');
  set(handles.gridb7,'Visible','on');
  set(handles.gridc7,'Visible','on');
  set(handles.gridd7,'Visible','on');
  set(handles.gride7,'Visible','on');
  
 case 8
  set(handles.grida8tag,'String',num);
  set(handles.gridb8tag,'String',num);
  set(handles.gridc8tag,'String',num);
  set(handles.gridd8tag,'String',num);
  set(handles.gride8tag,'String',num);
  set(handles.grida8tag,'Visible','on');
  set(handles.gridb8tag,'Visible','on');
  set(handles.gridc8tag,'Visible','on');
  set(handles.gridd8tag,'Visible','on');
  set(handles.gride8tag,'Visible','on');
  set(handles.grida8,'Visible','on');
  set(handles.gridb8,'Visible','on');
  set(handles.gridc8,'Visible','on');
  set(handles.gridd8,'Visible','on');
  set(handles.gride8,'Visible','on');
  
 case 9
  set(handles.grida9tag,'String',num);
  set(handles.gridb9tag,'String',num);
  set(handles.gridc9tag,'String',num);
  set(handles.gridd9tag,'String',num);
  set(handles.gride9tag,'String',num);
  set(handles.grida9tag,'Visible','on');
  set(handles.gridb9tag,'Visible','on');
  set(handles.gridc9tag,'Visible','on');
  set(handles.gridd9tag,'Visible','on');
  set(handles.gride9tag,'Visible','on');
  set(handles.grida9,'Visible','on');
  set(handles.gridb9,'Visible','on');
  set(handles.gridc9,'Visible','on');
  set(handles.gridd9,'Visible','on');
  set(handles.gride9,'Visible','on');
  
 case 10
  set(handles.grida10tag,'String',num);
  set(handles.gridb10tag,'String',num);
  set(handles.gridc10tag,'String',num);
  set(handles.gridd10tag,'String',num);
  set(handles.gride10tag,'String',num);
  set(handles.grida10tag,'Visible','on');
  set(handles.gridb10tag,'Visible','on');
  set(handles.gridc10tag,'Visible','on');
  set(handles.gridd10tag,'Visible','on');
  set(handles.gride10tag,'Visible','on');
  set(handles.grida10,'Visible','on');
  set(handles.gridb10,'Visible','on');
  set(handles.gridc10,'Visible','on');
  set(handles.gridd10,'Visible','on');
  set(handles.gride10,'Visible','on');

 case 11
  set(handles.grida11tag,'String',num);
  set(handles.gridb11tag,'String',num);
  set(handles.gridc11tag,'String',num);
  set(handles.gridd11tag,'String',num);
  set(handles.gride11tag,'String',num);
  set(handles.grida11tag,'Visible','on');
  set(handles.gridb11tag,'Visible','on');
  set(handles.gridc11tag,'Visible','on');
  set(handles.gridd11tag,'Visible','on');
  set(handles.gride11tag,'Visible','on');
  set(handles.grida11,'Visible','on');
  set(handles.gridb11,'Visible','on');
  set(handles.gridc11,'Visible','on');
  set(handles.gridd11,'Visible','on');
  set(handles.gride11,'Visible','on');
  
 case 12
  set(handles.grida12tag,'String',num);
  set(handles.gridb12tag,'String',num);
  set(handles.gridc12tag,'String',num);
  set(handles.gridd12tag,'String',num);
  set(handles.gride12tag,'String',num);
  set(handles.grida12tag,'Visible','on');
  set(handles.gridb12tag,'Visible','on');
  set(handles.gridc12tag,'Visible','on');
  set(handles.gridd12tag,'Visible','on');
  set(handles.gride12tag,'Visible','on');
  set(handles.grida12,'Visible','on');
  set(handles.gridb12,'Visible','on');
  set(handles.gridc12,'Visible','on');
  set(handles.gridd12,'Visible','on');
  set(handles.gride12,'Visible','on');
  
 case 13
  set(handles.grida13tag,'String',num);
  set(handles.gridb13tag,'String',num);
  set(handles.gridc13tag,'String',num);
  set(handles.gridd13tag,'String',num);
  set(handles.gride13tag,'String',num);
  set(handles.grida13tag,'Visible','on');
  set(handles.gridb13tag,'Visible','on');
  set(handles.gridc13tag,'Visible','on');
  set(handles.gridd13tag,'Visible','on');
  set(handles.gride13tag,'Visible','on');
  set(handles.grida13,'Visible','on');
  set(handles.gridb13,'Visible','on');
  set(handles.gridc13,'Visible','on');
  set(handles.gridd13,'Visible','on');
  set(handles.gride13,'Visible','on');
  
 case 14
  set(handles.grida14tag,'String',num);
  set(handles.gridb14tag,'String',num);
  set(handles.gridc14tag,'String',num);
  set(handles.gridd14tag,'String',num);
  set(handles.gride14tag,'String',num);
  set(handles.grida14tag,'Visible','on');
  set(handles.gridb14tag,'Visible','on');
  set(handles.gridc14tag,'Visible','on');
  set(handles.gridd14tag,'Visible','on');
  set(handles.gride14tag,'Visible','on');
  set(handles.grida14,'Visible','on');
  set(handles.gridb14,'Visible','on');
  set(handles.gridc14,'Visible','on');
  set(handles.gridd14,'Visible','on');
  set(handles.gride14,'Visible','on');

 case 15
  set(handles.grida15tag,'String',num);
  set(handles.gridb15tag,'String',num);
  set(handles.gridc15tag,'String',num);
  set(handles.gridd15tag,'String',num);
  set(handles.gride15tag,'String',num);
  set(handles.grida15tag,'Visible','on');
  set(handles.gridb15tag,'Visible','on');
  set(handles.gridc15tag,'Visible','on');
  set(handles.gridd15tag,'Visible','on');
  set(handles.gride15tag,'Visible','on');
  set(handles.grida15,'Visible','on');
  set(handles.gridb15,'Visible','on');
  set(handles.gridc15,'Visible','on');
  set(handles.gridd15,'Visible','on');
  set(handles.gride15,'Visible','on');
  
 case 16
  set(handles.grida16tag,'String',num);
  set(handles.gridb16tag,'String',num);
  set(handles.gridc16tag,'String',num);
  set(handles.gridd16tag,'String',num);
  set(handles.gride16tag,'String',num);
  set(handles.grida16tag,'Visible','on');
  set(handles.gridb16tag,'Visible','on');
  set(handles.gridc16tag,'Visible','on');
  set(handles.gridd16tag,'Visible','on');
  set(handles.gride16tag,'Visible','on');
  set(handles.grida16,'Visible','on');
  set(handles.gridb16,'Visible','on');
  set(handles.gridc16,'Visible','on');
  set(handles.gridd16,'Visible','on');
  set(handles.gride16,'Visible','on');
  
 case 17
  set(handles.grida17tag,'String',num);
  set(handles.gridb17tag,'String',num);
  set(handles.gridc17tag,'String',num);
  set(handles.gridd17tag,'String',num);
  set(handles.gride17tag,'String',num);
  set(handles.grida17tag,'Visible','on');
  set(handles.gridb17tag,'Visible','on');
  set(handles.gridc17tag,'Visible','on');
  set(handles.gridd17tag,'Visible','on');
  set(handles.gride17tag,'Visible','on');
  set(handles.grida17,'Visible','on');
  set(handles.gridb17,'Visible','on');
  set(handles.gridc17,'Visible','on');
  set(handles.gridd17,'Visible','on');
  set(handles.gride17,'Visible','on');
  
 case 18
  set(handles.grida18tag,'String',num);
  set(handles.gridb18tag,'String',num);
  set(handles.gridc18tag,'String',num);
  set(handles.gridd18tag,'String',num);
  set(handles.gride18tag,'String',num);
  set(handles.grida18tag,'Visible','on');
  set(handles.gridb18tag,'Visible','on');
  set(handles.gridc18tag,'Visible','on');
  set(handles.gridd18tag,'Visible','on');
  set(handles.gride18tag,'Visible','on');
  set(handles.grida18,'Visible','on');
  set(handles.gridb18,'Visible','on');
  set(handles.gridc18,'Visible','on');
  set(handles.gridd18,'Visible','on');
  set(handles.gride18,'Visible','on');
  
 case 19
  set(handles.grida19tag,'String',num);
  set(handles.gridb19tag,'String',num);
  set(handles.gridc19tag,'String',num);
  set(handles.gridd19tag,'String',num);
  set(handles.gride19tag,'String',num);
  set(handles.grida19tag,'Visible','on');
  set(handles.gridb19tag,'Visible','on');
  set(handles.gridc19tag,'Visible','on');
  set(handles.gridd19tag,'Visible','on');
  set(handles.gride19tag,'Visible','on');
  set(handles.grida19,'Visible','on');
  set(handles.gridb19,'Visible','on');
  set(handles.gridc19,'Visible','on');
  set(handles.gridd19,'Visible','on');
  set(handles.gride19,'Visible','on');
  
 case 20
  set(handles.grida20tag,'String',num);
  set(handles.gridb20tag,'String',num);
  set(handles.gridc20tag,'String',num);
  set(handles.gridd20tag,'String',num);
  set(handles.gride20tag,'String',num);
  set(handles.grida20tag,'Visible','on');
  set(handles.gridb20tag,'Visible','on');
  set(handles.gridc20tag,'Visible','on');
  set(handles.gridd20tag,'Visible','on');
  set(handles.gride20tag,'Visible','on');
  set(handles.grida20,'Visible','on');
  set(handles.gridb20,'Visible','on');
  set(handles.gridc20,'Visible','on');
  set(handles.gridd20,'Visible','on');
  set(handles.gride20,'Visible','on');
  
end
 

% --- Sets code grid codes to the previously input codes, when
% going back in states.
function set_grid_codes(handles)

set(handles.grida0,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,1)));
set(handles.grida1,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,2)));
set(handles.grida2,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,3)));
set(handles.grida3,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,4)));
set(handles.grida4,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,5)));
set(handles.grida5,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,6)));
set(handles.grida6,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,7)));
set(handles.grida7,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,8)));
set(handles.grida8,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,9)));
set(handles.grida9,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,10)));
set(handles.grida10,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,11)));
set(handles.grida11,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,12)));
set(handles.grida12,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,13)));
set(handles.grida13,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,14)));
set(handles.grida14,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,15)));
set(handles.grida15,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,16)));
set(handles.grida16,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,17)));
set(handles.grida17,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,18)));
set(handles.grida18,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,19)));
set(handles.grida19,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,20)));
set(handles.grida20,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,1,21)));
set(handles.gridb0,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,1)));
set(handles.gridb1,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,2)));
set(handles.gridb2,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,3)));
set(handles.gridb3,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,4)));
set(handles.gridb4,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,5)));
set(handles.gridb5,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,6)));
set(handles.gridb6,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,7)));
set(handles.gridb7,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,8)));
set(handles.gridb8,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,9)));
set(handles.gridb9,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,10)));
set(handles.gridb10,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,11)));
set(handles.gridb11,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,12)));
set(handles.gridb12,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,13)));
set(handles.gridb13,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,14)));
set(handles.gridb14,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,15)));
set(handles.gridb15,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,16)));
set(handles.gridb16,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,17)));
set(handles.gridb17,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,18)));
set(handles.gridb18,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,19)));
set(handles.gridb19,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,20)));
set(handles.gridb20,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,2,21)));
set(handles.gridc0,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,1)));
set(handles.gridc1,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,2)));
set(handles.gridc2,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,3)));
set(handles.gridc3,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,4)));
set(handles.gridc4,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,5)));
set(handles.gridc5,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,6)));
set(handles.gridc6,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,7)));
set(handles.gridc7,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,8)));
set(handles.gridc8,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,9)));
set(handles.gridc9,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,10)));
set(handles.gridc10,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,11)));
set(handles.gridc11,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,12)));
set(handles.gridc12,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,13)));
set(handles.gridc13,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,14)));
set(handles.gridc14,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,15)));
set(handles.gridc15,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,16)));
set(handles.gridc16,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,17)));
set(handles.gridc17,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,18)));
set(handles.gridc18,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,19)));
set(handles.gridc19,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,20)));
set(handles.gridc20,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,3,21)));
set(handles.gridd0,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,1)));
set(handles.gridd1,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,2)));
set(handles.gridd2,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,3)));
set(handles.gridd3,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,4)));
set(handles.gridd4,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,5)));
set(handles.gridd5,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,6)));
set(handles.gridd6,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,7)));
set(handles.gridd7,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,8)));
set(handles.gridd8,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,9)));
set(handles.gridd9,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,10)));
set(handles.gridd10,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,11)));
set(handles.gridd11,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,12)));
set(handles.gridd12,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,13)));
set(handles.gridd13,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,14)));
set(handles.gridd14,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,15)));
set(handles.gridd15,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,16)));
set(handles.gridd16,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,17)));
set(handles.gridd17,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,18)));
set(handles.gridd18,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,19)));
set(handles.gridd19,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,20)));
set(handles.gridd20,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,4,21)));
set(handles.gride0,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,1)));
set(handles.gride1,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,2)));
set(handles.gride2,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,3)));
set(handles.gride3,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,4)));
set(handles.gride4,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,5)));
set(handles.gride5,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,6)));
set(handles.gride6,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,7)));
set(handles.gride7,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,8)));
set(handles.gride8,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,9)));
set(handles.gride9,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,10)));
set(handles.gride10,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,11)));
set(handles.gride11,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,12)));
set(handles.gride12,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,13)));
set(handles.gride13,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,14)));
set(handles.gride14,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,15)));
set(handles.gride15,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,16)));
set(handles.gride16,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,17)));
set(handles.gride17,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,18)));
set(handles.gride18,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,19)));
set(handles.gride19,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,20)));
set(handles.gride20,'String', ...
		  num2str(handles.stimcodes(handles.numofstimnames,5,21)));


% --- Returns a string containing the subtitle for state 232.
function subtitle = get_subtitle(handles)

switch handles.numofcatnames
 case 1
  subtitle = ['Change of ', get(handles.prop1name,'String'), ',' ...
	      ' from ', get(handles.prop1cat1name,'String'), ...
	      ' to ', get(handles.prop1cat2name,'String')];
 case 2
  subtitle = ['Change of ', get(handles.prop1name,'String'), ',' ...
	      ' from ', get(handles.prop1cat2name,'String'), ...
	      ' to ', get(handles.prop1cat1name,'String')];
 case 3
  subtitle = ['Change of ', get(handles.prop2name,'String'), ',' ...
	      ' from ', get(handles.prop2cat1name,'String'), ...
	      ' to ', get(handles.prop2cat2name,'String')];
 case 4
  subtitle = ['Change of ', get(handles.prop2name,'String'), ',' ...
	      ' from ', get(handles.prop2cat2name,'String'), ...
	      ' to ', get(handles.prop2cat1name,'String')];
 case 5
  subtitle = ['Change of ', get(handles.prop3name,'String'), ',' ...
	      ' from ', get(handles.prop3cat1name,'String'), ...
	      ' to ', get(handles.prop3cat2name,'String')];
 case 6
  subtitle = ['Change of ', get(handles.prop3name,'String'), ',' ...
	      ' from ', get(handles.prop3cat2name,'String'), ...
	      ' to ', get(handles.prop3cat1name,'String')];
 case 7
  subtitle = ['Change of ', get(handles.prop4name,'String'), ',' ...
	      ' from ', get(handles.prop4cat1name,'String'), ...
	      ' to ', get(handles.prop4cat2name,'String')];
 case 8
  subtitle = ['Change of ', get(handles.prop4name,'String'), ',' ...
	      ' from ', get(handles.prop4cat2name,'String'), ...
	      ' to ', get(handles.prop4cat1name,'String')];
 case 9
  subtitle = ['Change of ', get(handles.prop5name,'String'), ',' ...
	      ' from ', get(handles.prop5cat1name,'String'), ...
	      ' to ', get(handles.prop5cat2name,'String')];
 case 10
  subtitle = ['Change of ', get(handles.prop5name,'String'), ',' ...
	      ' from ', get(handles.prop5cat2name,'String'), ...
	      ' to ', get(handles.prop5cat1name,'String')];
 otherwise
  subtitle = 'Sequence Maker: Roving Sequence';
  
end  


% --- Displays a note text on the window.
function note(notestring, handles);
% notestring  The message to be displayed

set(handles.notetext,'String',notestring);
set(handles.notetext,'Visible','on');


% --- Executes on button press in directionbox.
function directionbox_Callback(hObject, eventdata, handles)
% hObject    handle to directionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of directionbox
if (get(hObject,'Value'))
  set(handles.triggercodebox,'Value',1);
end



% --- Executes during object creation, after setting all properties.
function prop3cat1name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop3cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop3cat1name_Callback(hObject, eventdata, handles)
% hObject    handle to prop3cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop3cat1name as text
%        str2double(get(hObject,'String')) returns contents of prop3cat1name as a double


% --- Executes during object creation, after setting all properties.
function prop1cat1name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop1cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop1cat1name_Callback(hObject, eventdata, handles)
% hObject    handle to prop1cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop1cat1name as text
%        str2double(get(hObject,'String')) returns contents of prop1cat1name as a double


% --- Executes during object creation, after setting all properties.
function prop2cat1name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop2cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop2cat1name_Callback(hObject, eventdata, handles)
% hObject    handle to prop2cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop2cat1name as text
%        str2double(get(hObject,'String')) returns contents of prop2cat1name as a double


% --- Executes during object creation, after setting all properties.
function prop4cat1name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop4cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop4cat1name_Callback(hObject, eventdata, handles)
% hObject    handle to prop4cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop4cat1name as text
%        str2double(get(hObject,'String')) returns contents of prop4cat1name as a double


% --- Executes during object creation, after setting all properties.
function prop5cat1name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop5cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop5cat1name_Callback(hObject, eventdata, handles)
% hObject    handle to prop5cat1name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop5cat1name as text
%        str2double(get(hObject,'String')) returns contents of prop5cat1name as a double


% --- Executes during object creation, after setting all properties.
function prop3cat2name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop3cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop3cat2name_Callback(hObject, eventdata, handles)
% hObject    handle to prop3cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop3cat2name as text
%        str2double(get(hObject,'String')) returns contents of prop3cat2name as a double


% --- Executes during object creation, after setting all properties.
function prop1cat2name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop1cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop1cat2name_Callback(hObject, eventdata, handles)
% hObject    handle to prop1cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop1cat2name as text
%        str2double(get(hObject,'String')) returns contents of prop1cat2name as a double


% --- Executes during object creation, after setting all properties.
function prop2cat2name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop2cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop2cat2name_Callback(hObject, eventdata, handles)
% hObject    handle to prop2cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop2cat2name as text
%        str2double(get(hObject,'String')) returns contents of prop2cat2name as a double


% --- Executes during object creation, after setting all properties.
function prop4cat2name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop4cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop4cat2name_Callback(hObject, eventdata, handles)
% hObject    handle to prop4cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop4cat2name as text
%        str2double(get(hObject,'String')) returns contents of prop4cat2name as a double


% --- Executes during object creation, after setting all properties.
function prop5cat2name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop5cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop5cat2name_Callback(hObject, eventdata, handles)
% hObject    handle to prop5cat2name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop5cat2name as text
%        str2double(get(hObject,'String')) returns contents of prop5cat2name as a double


% --- Executes during object creation, after setting all properties.
function prop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop_Callback(hObject, eventdata, handles)
% hObject    handle to prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop as text
%        str2double(get(hObject,'String')) returns contents of prop as a double


% --- Executes during object creation, after setting all properties.
function prop5cat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop5cat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prop5cat_Callback(hObject, eventdata, handles)
% hObject    handle to prop5cat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop5cat as text
%        str2double(get(hObject,'String')) returns contents of prop5cat as a double



% --- Returns a string containing sequence's settings.
function optstring = get_options(handles)
% handles    structure with handles and user data (see GUIDATA)

opt = 'ROVING SEQUENCE SETTINGS\n\n';

if (~get(handles.propertybox,'Value'))
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
  
  % Minimum number of repetitions:
  o1 = '\nMinimum number of repetitions: ';
  o2 = num2str(handles.repminvalue);
  opt = cat(2, opt, o1, o2);
  
  % Maximum  number of repetitions:
  o1 = '\nMaximum number of repetitions: ';
  o2 = num2str(handles.repmaxvalue);
  opt = cat(2, opt, o1, o2);
  
  % Number of repetitions before stimulus becomes standard:
  o1 = '\nNumber of repetitions before stimulus becomes standard: ';
  o2 = num2str(handles.rep2stdvalue);
  opt = cat(2, opt, o1, o2);
  
  % Check boxes:
  o1 = '\n\nUser defined trigger codes: ';
  if (get(handles.triggercodebox,'Value'))
    o1 = cat(2, o1, 'yes\n');
  else
    o1 = cat(2, o1, 'no\n');
  end
  if (get(handles.probabilitybox,'Value'))
    o1 = cat(2, o1, 'User defined probabilities for stimuli: yes\n');
  else
        o1 = cat(2, o1, 'User defined probabilities for stimuli: no\n');
  end
  if (get(handles.repcodebox,'Value'))
    o1 = cat(2, o1, 'Different codes according to preceding reperitions: yes\n');
  else
    o1 = cat(2, o1, 'Different codes according to preceding reperitions: no\n');
  end
  if (get(handles.propertybox,'Value'))
    o1 = cat(2, o1, ['Stimuli are divided into property categories:' ...
		     ' yes\n']);
  else
    o1 = cat(2, o1, ['Stimuli are divided into property categories:' ...
		     ' no\n']);
  end
  
    % Stimuli:
  opt = cat(2, opt, o1, '\n\nSTIMULI:\n');
  
  for i = 1:handles.numofstimnames
    o1 = handles.stimnames{i};
    if (handles.previous_state == 24 | ~get(handles.probabilitybox, ...
					    'Value'))
      % simple options (equal probabilities)
      o2 = [];
      o3 = [];
    else
      o2 = '\nProbability: ';
      o3 = num2str(handles.probabilities(i));
    end
    o4 = '\nTrigger codes: ';
    if (get(handles.repcodebox,'Value'))
      o4 = cat(2, o4, '\n');
      o5 = [];
      for k = 1:5
	for m = 1:handles.repmaxvalue-handles.repminvalue+1

	  o5 = cat(2, o5, ' ', num2str(handles.stimcodes(i,k,m)));
	end
	o5 = cat(2, o5, '\n');
      end
    else
      o5 = num2str(handles.stimcodes(i,1));
      for k = 2:5
	cat(2, o5, ', ', num2str(handles.stimcodes(i,k)));
      end
    end
    o6 = '\n\n';
    opt = cat(2, opt, o1, o2, o3, o4, o5, o6);
  end

  
else % Categorization

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
  
  % Minimum number of repetitions:
  o1 = '\nMinimum number of repetitions: ';
  o2 = num2str(handles.repminvalue);
  opt = cat(2, opt, o1, o2);
  
  % Maximum  number of repetitions:
  o1 = '\nMaximum number of repetitions: ';
  o2 = num2str(handles.repmaxvalue);
  opt = cat(2, opt, o1, o2);
  
  % Number of repetitions before stimulus becomes standard:
  o1 = '\nNumber of repetitions before stimulus becomes standard: ';
  o2 = num2str(handles.rep2stdvalue);
  opt = cat(2, opt, o1, o2);
  
  % Stimuli:
  opt = cat(2, opt, '\n\nSTIMULI:\n\n');
  
  for i = 1:handles.numofstimnames
    o1 = handles.stimnames{i};
    o2 = '\nProperties:\n';
    for j = 1:str2double(get(handles.numofcat,'String'))
      ct = handles.stimuluscats(i,j)
      o2 = cat(2, o2, get_prop_name(j,ct,handles),'\n');
    end
    o6 = '\n\n';
    opt = cat(2, opt, o1, o2, o6);
  end
  
  opt = cat(2, opt, '\nTRIGGER CODES:\n\n');

  % Direction not important:
  if (size(handles.catcodes,1) == str2double(get(handles.numofcat, ...
						 'String')))
    for i = 1:str2double(get(handles.numofcat,'String'))
      o1 = get_prop_name(i, 0, handles);
      o2 = num2str(handles.catcodes(i,:));
      opt = cat(2, opt, o1, o2, '\n');
    end
  % Direction is important:
  else

    s = [get(handles.prop1name,'String'), ',', ...
	 ' ', get(handles.prop1cat1name,'String'), ' -> ', ...
	 get(handles.prop1cat2name,'String'), ':  '];
    t = num2str(handles.catcodes(1,:));
    opt = cat(2, opt, s, t, '\n');

    s = [get(handles.prop1name,'String'), ',', ...
	 ' ', get(handles.prop1cat2name,'String'), ' -> ', ...
	 get(handles.prop1cat1name,'String'), ':  '];
    t = num2str(handles.catcodes(2,:));
    opt = cat(2, opt, s, t, '\n');

    if (str2double(get(handles.numofcat,'String')) > 1)
      s = [get(handles.prop2name,'String'), ',', ...
	   ' ', get(handles.prop2cat1name,'String'), ' -> ', ...
	   get(handles.prop2cat2name,'String'), ':  '];
      t = num2str(handles.catcodes(3,:));
      opt = cat(2, opt, s, t, '\n');
      
      s = [get(handles.prop2name,'String'), ',', ...
	   ' ', get(handles.prop2cat2name,'String'), ' -> ', ...
	   get(handles.prop2cat1name,'String'), ':  '];
      t = num2str(handles.catcodes(4,:));
      opt = cat(2, opt, s, t, '\n');
    end
    if (str2double(get(handles.numofcat,'String')) > 2)
      s = [get(handles.prop3name,'String'), ',', ...
	   ' ', get(handles.prop3cat1name,'String'), ' -> ', ...
	   get(handles.prop3cat2name,'String'), ':  '];
      t = num2str(handles.catcodes(5,:));
      opt = cat(2, opt, s, t, '\n');
      
      s = [get(handles.prop3name,'String'), ',', ...
	   ' ', get(handles.prop3cat2name,'String'), ' -> ', ...
	   get(handles.prop3cat1name,'String'), ':  '];
      t = num2str(handles.catcodes(6,:));
      opt = cat(2, opt, s, t, '\n');
    end
    if (str2double(get(handles.numofcat,'String')) > 3)
      s = [get(handles.prop4name,'String'), ',', ...
	   ' ', get(handles.prop4cat1name,'String'), ' -> ', ...
	   get(handles.prop4cat2name,'String'), ':  '];
      t = num2str(handles.catcodes(7,:));
      opt = cat(2, opt, s, t, '\n');
      
      s = [get(handles.prop4name,'String'), ',', ...
	   ' ', get(handles.prop4cat2name,'String'), ' -> ', ...
	   get(handles.prop4cat1name,'String'), ':  '];
      t = num2str(handles.catcodes(8,:));
      opt = cat(2, opt, s, t, '\n');
    end
    if (str2double(get(handles.numofcat,'String')) > 4)
      s = [get(handles.prop5name,'String'), ',', ...
	   ' ', get(handles.prop5cat1name,'String'), ' -> ', ...
	   get(handles.prop5cat2name,'String'), ':  '];
      t = num2str(handles.catcodes(9,:));
      opt = cat(2, opt, s, t, '\n');
      
      s = [get(handles.prop5name,'String'), ',', ...
	   ' ', get(handles.prop5cat2name,'String'), ' -> ', ...
	   get(handles.prop5cat1name,'String'), ':  '];
      t = num2str(handles.catcodes(10,:));
      opt = cat(2, opt, s, t, '\n');
    end
  end
end

opt = cat(2, opt, '\n\n---END---');
optstring = opt;


% -- Returns a string containing a property and category name.
function propstring = get_prop_name(prop, ct, handles)
% prop    number of order for the property (1-5)
% cat     number of order for the category (1 or 2)
% handles structure with handles and the user data (see GUIDATA)


% Names have been input in state 22
if (get(handles.directionbox,'Value') |  ...
    ~get(handles.triggercodebox,'Value'))
  
  if (prop == 1)
    propstr = get(handles.prop1name,'String');
    if (ct == 1)
      catstr = get(handles.prop1cat1name,'String');
    else
      if (ct == 2)
	catstr = get(handles.prop1cat2name,'String');
      else
	catstr = [];
      end
    end
  else 
    if (prop == 2)
      propstr = get(handles.prop2name,'String');
      if (ct == 1)
	catstr = get(handles.prop2cat1name,'String');
      else
	if (ct == 2)
	  catstr = get(handles.prop2cat2name,'String');
	else
	  catstr = [];
	end
      end
    else 
      if (prop == 3)
	propstr = get(handles.prop3name,'String');
	if (ct == 1)
	  catstr = get(handles.prop3cat1name,'String');
	else
	  if (ct == 2)
	    catstr = get(handles.prop3cat2name,'String');
	  else
	    catstr = [];
	  end
	end
      else 
	if (prop == 4)
	  propstr = get(handles.prop4name,'String');
	  if (ct == 1)
	    catstr = get(handles.prop4cat1name,'String');
	  else
	    if (ct == 2)
	      catstr = get(handles.prop4cat2name,'String');
	    else
	      catstr = [];
	    end
	  end
	else
	  propstr = get(handles.prop5name,'String');
	  if (ct == 1)
	    catstr = get(handles.prop5cat1name,'String');
	  else
	    if (ct == 2)
	      catstr = get(handles.prop5cat2name,'String');
	    else
	      catstr = [];
	    end
	  end
	end
      end
    end
  end
  propstring = cat(2, propstr, ': ', catstr);

% Names have been input in state 23
else
  propstr = handles.catnames{prop,1};
  if (ct == 1)
    catstr = handles.catnames{prop,2};
  else
    if (ct == 2)
      catstr = handles.catnames{prop,3};
    else
      catstr = [];
    end
  end
  propstring = cat(2, propstr, ': ', catstr);
end


% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.state

 case 0
  web 'http://www.cbru.helsinki.fi/seqma/rovingsimple.html' -browser
   
 case 1
  web 'http://www.cbru.helsinki.fi/seqma/rovingadvanced.html' ...
      -browser
  
 case 22
  if (~get(handles.directionbox,'Value'))
    web 'http://www.cbru.helsinki.fi/seqma/prop.html' -browser
  else
    web 'http://www.cbru.helsinki.fi/seqma/direction.html' ...
	-browser
  end
  
 case 23
  web 'http://www.cbru.helsinki.fi/seqma/propcode.html' ...
      -browser
  
 case 232
  web 'http://www.cbru.helsinki.fi/seqma/direction2.html' ...
      -browser
  
 case 24
  web 'http://www.cbru.helsinki.fi/seqma/rovingsimple2.html' ...
      -browser
  
 case 25
  if (~get(handles.directionbox,'Value'))
    if (get(handles.triggercodebox,'Value'))
      web 'http://www.cbru.helsinki.fi/seqma/prop2.html' - ...
	  browser
    else
      web 'http://www.cbru.helsinki.fi/seqma/prop2.html' - ...
	  browser
    end
  else
    web 'http://www.cbru.helsinki.fi/seqma/direction3.html' ...
	-browser
  end
  
 case 26
  web 'http://www.cbru.helsinki.fi/seqma/rovingadvanced2.html' ...
      -browser
  
 case 27
  web 'http://www.cbru.helsinki.fi/seqma/repcode.html' -browser
  
 case 3
  if (handles.previous_state == 24) 
    web 'http://www.cbru.helsinki.fi/seqma/rovingsimple3.html' ...
	-browser
  else
    if (get(handles.propertybox,'Value'))
      if (get(handles.triggercodebox,'Value'))
	if (get(handles.directionbox,'Value'))
	  web 'http://www.cbru.helsinki.fi/seqma/direction4.html' ...
	      -browser
	else
	  web 'http://www.cbru.helsinki.fi/seqma/propcode3.html' ...
	      -browser
	end
      else
	web 'http://www.cbru.helsinki.fi/seqma/prop3.html' - ...
	    browser
      end
    else
      web 'http://www.cbru.helsinki.fi/seqma/rovingadvanced3.html' ...
	  -browser
    end
  end
  
 otherwise
  web 'http://www.cbru.helsinki.fi/seqma/roving.html' -browser

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


