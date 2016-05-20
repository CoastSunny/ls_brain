function [y seq] = roving(stimuli, soamin, soamax, totalstim, repmin, repmax, rep2std, filename, codes, stimcats, probabilities, format, numoforder)

% ROVING Produces a sequence file using the Roving-standard paradigm
%
% ROVING(stimuli, soamin, soamax, totalstim, repmin, repmax, rep2std, filename, codes, stimcats, probabilities, format, numoforder)
%    
%    stimuli       a cell containing the stimulus names
%    soamin        the stimulus onset asynchrony
%    soamax        in case of random soa, the biggest possible value
%    totalstim     the total approximate amount of stimuli
%    repmin        the minimum number of standards after a deviant
%    repmax        the maximum number of standards after a deviant
%    rep2std       the number of repetitions for dev to become std
%    filename      the name of the resulting sequence file
%    codes         a vector containing the trigger codes
%    stimcats      a matrix containing stimulus categories (if any)
%    probabilities stimulus probabilities (empty array, if not defined)
%    format        an integer telling, the format of which program to use
%    numoforder    if many sequence files, which one of how many (array)
%
%    CBRU / University of Helsinki, Finland

rand('state',sum(100*clock)) % The seed for the random number generator from the system clock.

%h = waitbar(0,'Creating the sequence...');

% The probability of a stimulus being DEVIANT is calculated.

averagerep = (repmax + repmin) / 2;
probofdev = 1/(1+averagerep)

% If repetitions before a deviant have to be remembered, repcodes =
% 1, else repcodes = 0.
if (size(codes,3) > 1)
  repcodes = 1;
else
  repcodes = 0;
end

% A list (replist) containing numbers of repetitions is randomly
% created. Also if the SOA is variable, a list (soa) containing
% variable soa values is randomly created.

i = 0;
j = 1;
while (i < totalstim)
  repetitions = repmin + round(rand*(repmax - repmin));
  replist(j) = repetitions;
  i = i + repetitions + 1;
  j = j + 1;
end
  


for k = 1:i
  if (soamax > soamin)
    soa(k) = soamin + rand*(soamax - soamin);
  else
    soa(k) = soamin;
  end  
end


% The sequence is created using the STIM notation:

% If categorization IS NOT used:
if (isempty(stimcats))
  
  % If stimulus probabilites are equal (default):
  if (isempty(probabilities))
    % A list (stimlist) containing the order in which the stimuli are
    % presented is randomly created.
    stimlist(1) = ceil(length(stimuli)*rand);
    for i = 2:j
      stimlist(i) = ceil(length(stimuli)*rand);
      if (stimlist(i) == stimlist(i-1))
	random_addition = ceil((length(stimuli)-1)*rand);
	newi = mod(stimlist(i)+random_addition, length(stimuli)+1);
	if (newi < stimlist(i))
	  newi = newi + 1;
	end
	stimlist(i) = newi;
      end
    end

    
    % If stimulus probabilities are user defined:
    % NB! Same stimulus is not allowed to occur two times in a row.  
  else
    previous_stimulus = 0;
    for i = 1:j
      total_probability = 0;
      for k = 1:length(probabilities)
	if (k ~= previous_stimulus)
	  total_probability = total_probability + probabilities(k);
	end
      end
      
      % The stimulus is randomly selected from all the other
      % stimuli except for the previously selected one.
      
      select = rand*total_probability;
      found = 0;
      total_probability = 0;
      r = 1;
      while (found == 0)
	if (r == previous_stimulus)
	  r = r+1;
	end
	total_probability = total_probability + probabilities(r);
	if (total_probability >= select)
	  stimlist(i) = r;
	  previous_stimulus = r;
	  found = 1;
	else
	  r = r+1;
	end
	if (r == length(probabilities))
	  found = 1;
	  stimlist(i) = r;
	  previous_stimulus = r;
	end
      end
    end
    
  end

  i = 1; % replist counter
  j = 0; % sequence counter
  
  for i = 1:length(replist)
%     waitbar((numoforder(1)-1)/numoforder(2)+i/(numoforder(2)*2* ...
% 					       length(stimlist)));
    if (i == 1)
      prev_repetitions = -1;
    else
      prev_repetitions = repetitions;
    end
    repetitions = replist(i);
    repindex = prev_repetitions - repmin + 1;
    
    for k = 1:(repetitions+1)
      j = j+1;
      seq{j,1} = j;
      seq{j,2} = 3;
      seq{j,3} = 0;
      seq{j,4} = 0;
      seq{j,5} = soa(j);
      seq{j,6} = 90;
      seq{j,7} = 90;
      seq{j,8} = -1;

      if (prev_repetitions == -1)
	seq{j,9} = 0;
      else
	
	if (k == 1)
	  if (repcodes)
	    seq{j,9} = codes(stimlist(i),1,repindex);
	  else
	    seq{j,9} = codes(stimlist(i),1);
	  end
	else
	  if (k == 2)
	    if (repcodes)
	      seq{j,9} = codes(stimlist(i),2, repindex);
	    else
	      seq{j,9} = codes(stimlist(i),2);
	    end
	  else
	    if (k > 2 & k < rep2std+2)
	      if (repcodes)
		seq{j,9} = codes(stimlist(i),3,repindex);	      
	      else
		seq{j,9} = codes(stimlist(i),3);
	      end
	    else
	      if (k >= rep2std+2 & k < repetitions+1)
		if (repcodes)
		  seq{j,9} = codes(stimlist(i),4,repindex);
		else
		  seq{j,9} = codes(stimlist(i),4);
		end
	      else
		if (k == repetitions+1)
		  if (repcodes)
		    seq{j,9} = codes(stimlist(i),5,repindex);
		  else
		    seq{j,9} = codes(stimlist(i),5);
		  end
		else
		  seq{j,9} = 000 % Does not happen
		end
	      end
	    end
	  end
	end
      end
      seq{j,10} = stimuli{stimlist(i)};
    end
  end

  % If categorization IS used:
else

  if(size(codes,1)==size(stimcats,2))
    directional = 0;
  else
    directional = 1;
  end
  
  % A list (stimlist) containing the order in which the stimuli are
  % presented is randomly created.
  property_change = 0;
  presentstim = 1;
  for i = 1:j
    previous_property_change = property_change;
    property_change = ceil(size(stimcats,2)*rand);

    previous_cat = stimcats(presentstim, property_change);
    
    % Two property changes of same kind are not allowed to happen
    % in a row.
    if (property_change == previous_property_change)
      property_change = mod(property_change,size(stimcats,2))+1;
    end

    newstim = change_property(property_change, presentstim, ...
			      stimcats);
    presentstim = newstim;
    if (presentstim == -1)
      disp(['Check the stimulus categories - too few stimuli of some' ...
	    ' category.']);
      a(1) = -1; % Error
      a(2) = 1;  % Error code
      close(h);
      y = a;
      return
    end
    stimlist{i,1} = newstim;
    stimlist{i,2} = property_change;
    stimlist{i,3} = previous_cat;
  end
  
  i = 1; % replist counter
  j = 0; % sequence counter

  for i = 1:length(replist)
    %waitbar((numoforder(1)-1)/numoforder(2)+i/(numoforder(2)*2*length(stimlist)));
    repetitions = replist(i);
    property_change = stimlist{i,2};
    previous_cat = stimlist{i,3};
    for k = 1:(repetitions+1)
      j = j+1;
      seq{j,1} = j;
      seq{j,2} = 3;
      seq{j,3} = 0;
      seq{j,4} = 0;
      seq{j,5} = soa(j);
      seq{j,6} = 90;
      seq{j,7} = 90;
      seq{j,8} = -1;

      if (k == 1)
	if (directional)
	  if (previous_cat == 0)
	    seq{j,9} = 0;
	  else
	    if (previous_cat == 1)
	      seq{j,9} = codes((property_change*2 - 1), 1);
	    else
	      seq{j,9} = codes((property_change*2), 1);
	    end
	  end	  
	else
	  seq{j,9} = codes(property_change, 1);
	end
      else
	if (k == 2)
	  if (directional)
	    if (previous_cat == 0)
	      seq{j,9} = 0;
	    else
	      if (previous_cat == 1)
		seq{j,9} = codes((property_change*2 - 1), 2);
	      else
		seq{j,9} = codes((property_change*2), 2);
	      end
	    end
	  else
	    seq{j,9} = codes(property_change, 2);
	  end
	else
	  if (k > 2 & k < rep2std+2)
	    if (directional)
	      if (previous_cat == 0)
		seq{j,9} = 0;
	      else
		if (previous_cat == 1)
		  seq{j,9} = codes((property_change*2 - 1), 3);
		else
		  seq{j,9} = codes((property_change*2), 3);
		end
	      end
	    else
	      seq{j,9} = codes(property_change, 3);
	    end
	  else
	    if (k >= rep2std+2 & k < repetitions+1)
	      if (directional)
		if (previous_cat == 0)
		  seq{j,9} = 0;
		else
		  if (previous_cat == 1)
		    seq{j,9} = codes((property_change*2 - 1), 4);
		  else
		    seq{j,9} = codes((property_change*2), 4);
		  end
		end
	      else
		seq{j,9} = codes(property_change, 4);
	      end
	    else
	      if (k == repetitions+1)
		if (directional)
		  if (previous_cat == 0)
		    seq{j,9} = 0;
		  else
		    if (previous_cat == 1)
		      seq{j,9} = codes((property_change*2 - 1), 5);
		    else
		      seq{j,9} = codes((property_change*2), 5);
		    end
		  end
		else
		  seq{j,9} = codes(property_change, 5);
		end
	      else
		seq{j,9} = 000 % Does not happen
	      end
	    end
	  end
	end
      end
      seq{j,10} = stimuli{stimlist{i,1}};
    end
  end 
end



% Some of the first and the last stimuli are marked ignored to
% insure reliability (trigger code is set to 0).

for i = 1:max(repmax,5)
  seq{i,9} = 0;
end
seq{j-1,9} = 0;
seq{j,9} = 0;

%%%
% The sequence is written into a file.
%filename = sequencefile(seq, format, filename, h);

  
a(1) = probofdev;
a(2) = j;

y = a;


% --- Returns the number of order of a new stimulus.
% For now, only a change of one property at a time is possible.
function stim = change_property(property, presentstim, stimcats)
% property     Number of order of the property to be changed.
% presentstim  Previous stimulus.
% stimcats     A matrix containing the categorization info.


cat_now = stimcats(presentstim, property);
if (cat_now == 1 | cat_now == 0)
  new_cat = 2;
else
  new_cat = 1;
end

numofcats = size(stimcats,2);

k = 0;
possible_stims = [];
for i=1:size(stimcats,1)
  valid = 0;

  if (stimcats(i,property) == new_cat)
    valid = 1;
    
    % Other properties should stay the same:
    for j=1:numofcats
      if (j~=property)
	if (stimcats(i,j)~=stimcats(presentstim,j))
	  valid = 0;
	end
      end
    end
    
    if (valid)
      possible_stims(k+1) = i;
      k = k+1;
    end
  end
end

% If no valid new stimulus was found, an error message is displayed.
if (isempty(possible_stims))
  disp('Change of category was not possible.');
  stim = -1;
  
% If one or more valid stimuli were found, one of them is randomly
% chosen.
else
  stim = possible_stims(ceil(length(possible_stims)*rand));
end
