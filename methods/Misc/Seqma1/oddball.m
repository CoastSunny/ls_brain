function y = oddball(stimuli, soamin, soamax, totalstim, probs, minstim, filename, codes, format)

% ODDBALL Produces a sequence file using the Oddball paradigm
%
% ODDBALL(stimuli, soamin, soamax, totalstim, probs, minstim, filename, codes, format)
%    
%    stimuli     a cell containing the stimulus names
%    soamin      the stimulus onset asynchrony
%    soamax      in case of random soa, the biggest possible value
%    totalstim   the total approximate amount of stimuli
%    probs       a vector containing stimulus probabilities
%    minstim     a vector containing sequence settings
%    filename    the name of the resulting sequence file
%    codes       a vector containing the trigger codes
%    format      an integer telling, the format of which program to use
%
%
%    CBRU / University of Helsinki, Finland

rand('state',sum(100*clock)) % The seed for the random number generator from the system clock.

%%%
% A list (stimlist) containing the order, in which the stimuli are
% presented is randomly created, according the settings which the
% user has input.

% The minimum number of stimuli between two deviants:
r1 = minstim(1);

% The minimum number of stimuli between two same standard stimuli
% or if categorized stimuli, minimum number of other stimuli
% between two stimuli of same class.
r2 = minstim(2);

is_cat = size(stimuli,1)>1; 

if (r1 >= r2)
  totalstim = totalstim + r1;
else
  totalstim = totalstim + r2;
end


% The number of stimuli, the code of which is set to 0, after a
% deviant:
num0 = minstim(3);

% The total probability of deviants in the sequence:%%%
% A list cointaining the soas for all stimuli (randomized, if
% wanted) is created.
for k = 1:totalstim
  if (soamax > soamin)
    soa(k) = soamin + rand*(soamax - soamin);
  else
    soa(k) = soamin;
  end  
end

probofdev = probs(1);
probofstd = 100 - probofdev;

% Number of different standard stimuli:
numofstd = probs(2);


% Number of different deviant stimuli:
numofdev = probs(3);


% Standard stimulus probabilities:
for i = 1:numofstd
  stdprobs(i) = probs(i+3);
end

% Deviant stimulus probabilities:
for i = 1:numofdev
  devprobs(i) = probs(i+numofstd+3);
end


% If the total probability is less than 100%, it is corrected to be 100%.

totalprob = 0;
for i = 1:numofstd
  totalprob = totalprob + stdprobs(i);
end
sc = 100/totalprob;  % Correlation factor for the standards.

totalprob = 0;
for i = 1:numofdev
  totalprob = totalprob + devprobs(i);
end
dc = 100/totalprob;   % Correlation factor for the deviants.


% The sequence is first created according to the stimulus
% probabilities. Thereafter it is checked and, if necessary,
% modified to fulfill the r1 and r2 conditions.

k = 1;
for i = 1:numofstd
  num = round(0.01*probofstd*0.01*stdprobs(i)*totalstim*sc);
  stds(i) = num;
  for j = 1:num
    stims(k) = i;
    k = k+1;
  end
end

for i = 1:numofdev
  num = round(0.01*probofdev*0.01*devprobs(i)*totalstim*dc);
  for j = 1:num
    stims(k) = i+numofstd;
    k = k+1;
  end
end


% Now the sequence order is randomized.
numofstim = length(stims);
stims = stims(randperm(numofstim));


% r1 & r2 conditions are checked.

if ((probofstd / probofdev) < r1)
  disp(['The probability of deviant is too big. The sequence cannot' ...
	' be created so, that there would be enough standards' ...
	 ' between two deviants. To avoid this either reduce the' ...
	  ' probability of deviants or the minimum number of stimuli' ...
	   ' between two deviants.']);
  r1ok = 0;
else
  r1ok = 1;
end

if (~is_cat)
  for i = 1:numofstd
    if ((stds(i) / (length(stims) - stds(i))) < r2)
      disp(['The probability of some standard is too big. The sequence cannot' ...
	' be created so, that there would be enough stimuli' ...
	    ' between two same standards. To avoid this either reduce the' ...
	    ' probability of standards or the minimum number of stimuli' ...
	    ' between two same standards.']);
      r2ok = 0;
      break;
    else
      r2ok = 1;
    end
  end
else
  r2ok = 1;
end

if (is_cat)
  [stimlist, probofdev] = arrange_cat_sequence(stims, r1, r2, ...
					       numofstd, numofdev, ...
					       stimuli);
else
  [stimlist, probofdev] = arrange_sequence(stims, r1, r2, numofstd, ...
					   numofdev);
end

%%%
% A list cointaining the soas for all stimuli (randomized, if
% wanted) is created.
for k = 1:length(stimlist)
  if (soamax > soamin)
    soa(k) = soamin + rand*(soamax - soamin);
  else
    soa(k) = soamin;
  end  
end


%%%
% The sequence is created:
wbar = waitbar(0,'Creating the sequence...');

for i = 1:length(stimlist)
  waitbar((minstim(6)-1)/minstim(5)+i/(minstim(5)*2*length(stimlist)));
  seq{i,1} = i;
  seq{i,2} = 3;
  seq{i,3} = 0;
  seq{i,4} = 0;
  seq{i,5} = soa(i);
  seq{i,6} = 90;
  seq{i,7} = 90;
  seq{i,8} = -1;

  if (num0 > 0)
    deviant_found = 0;
    if (i-num0 < 1)
      for j = 1:i-1
        if (stimlist(j) > numofstd)
          seq{i,9} = 0;
          deviant_found = 1;
          break;
     	end
      end
    else
      for j = i-num0:i-1
    	if (stimlist(j) > numofstd)
    	  seq{i,9} = 0;
    	  deviant_found = 1;
    	  break;
    	end
      end
    end
    if (~deviant_found)
      seq{i,9} = codes(stimlist(i));
    end
  else
    seq{i,9} = codes(stimlist(i));
  end
  if (is_cat)
    seq{i,10} = stimuli{1,stimlist(i)};
  else
    seq{i,10} = stimuli{stimlist(i)};
  end
end

% Some of the first and the last stimuli are marked differently to
% guarantee reliability (trigger code 0).

if (minstim(4)>0)
  for j = 1:minstim(4)
    seq{j,9} = 0;
  end
end


%%%
% The sequence is written into a file.
filename = sequencefile(seq, format, filename, wbar);


a(1) = probofdev;
a(2) = length(stimlist);

y = a;





% --- Function arranges the sequence according to the conditions:
%
% stims      a vector containing the sequence (stimulus numbers).
% r1         minimum number of stimuli between two deviants.
% r2         minimum number of stimuli between two same standards.
% numofstd   number of different standard stimuli.
% numofdev   number of different deviant stimuli.
function [stimlist, probofdev] = arrange_sequence(stims, r1, r2, numofstd, numofdev)

i = 1;
stds = 0;
devs = 0;

while (i ~= length(stims))
  
  if (i+r1 > length(stims) | i+r2 > length(stims))
    break;
  end
  
  stim = stims(i);
  
  if (stim > numofstd) % Stimulus is deviant
    devs = devs + 1;
    for j = i+1:i+r1
      if (stims(j) > numofstd)  % A deviant was found too close.
	for k = j:length(stims)
	  if (stims(k) <= numofstd)
	    temp = stims(j);
	    stims(j) = stims(k);
	    stims(k) = temp;
	    break;   % A standard was found and swapped with the deviant.
	  end
	end
      end
    end
    
  else % Stimulus is standard
    stds = stds + 1;
    for j = i+1:i+r2
      if (stims(j) == stim)   % A same kind of standard was found
                              % too close.
	for k = j:length(stims)
	  if (stims(k) ~= stim)
	    temp = stims(j);
	    stims(j) = stims(k);
	    stims(k) = temp;
	    break;  % A different stimulus was found and swapped.
	  end
	end
      end

    end
  end
  
  i = i+1;
end
	 
probofdev = devs / stds;

for j = 1:i
  stimlist(j) = stims(j);
end



% --- Function arranges the sequence according to the conditions:
%
% stims      a vector containing the sequence (stimulus numbers).
% r1         minimum number of stimuli between two deviants.
% r2         minimum number of stimuli between two same class stimuli.
% numofstd   number of different standard stimuli.
% numofdev   number of different deviant stimuli.
% stimuli    stimulus names {class, std(1)/dev(2), numofstim}
function [stimlist, probofdev] = arrange_cat_sequence(stims, r1, r2, ...
						  numofstd, numofdev, stimuli)

classes = size(stimuli,1);


i = 1;
stds = 0;
devs = 0;

while (i ~= length(stims))
  
  if (i+r1 > length(stims) | i+r2 > length(stims))
    break;
  end
  
  stim = stims(i);
  
  if (stim > numofstd) % Stimulus is deviant
    devs = devs + 1;
    for j = i+1:i+r1
      if (stims(j) > numofstd)  % A deviant was found too close.
	for k = j:length(stims)
	  if (stims(k) <= numofstd)
	    temp = stims(j);
	    stims(j) = stims(k);
	    stims(k) = temp;
	    break;   % A standard was found and swapped with the deviant.
	  end
	end
      end
    end
  end
  
  % Same classes are checked not to be too close (r2-condition):
    
    stds = stds + 1;
    for j = i+1:i+r2
      if (is_same_class(stims(j), stim, stimuli, numofstd, numofdev)) 
	% A same class standard was found too close.

	for k = j:length(stims)
	  if (~is_same_class(stims(k), stim, stimuli, numofstd, numofdev))
	    temp = stims(j);
	    stims(j) = stims(k);
	    stims(k) = temp;
	    break;  % A different stimulus was found and swapped.
	  end
	end
      end

    end
  
  
  i = i+1;
end
	 
probofdev = devs / stds;

for j = 1:i
  stimlist(j) = stims(j);
end


% --- Checks if two stimuli are of same class.
function y = is_same_class(a, b, stimuli, numofstd, numofdev)
% a   number of order of the first stimulus
% b   number of order of the second stimulus
% stimuli   the stimuli in a cell{a,b,c}

classes = stimuli{2,1};

% stimuli in a class:
stds = numofstd / classes;
devs = numofdev / classes;

a_std = a <= numofstd;
b_std = b <= numofstd;

a_class = 1;
if (a_std)
  for i = 1:classes
    if a <= i*stds
      break;
    else
      a_class = a_class + 1;
    end
  end
else
  for i = 1:classes
    if a <= classes*stds + i*devs
      break;
    else
      a_class = a_class + 1;
    end
  end
end

b_class = 1;
if (b_std)
  for i = 1:classes
    if b <= i*stds
      break;
    else
      b_class = b_class + 1;
    end
  end
else
  for i = 1:classes
    if b <= classes*stds + i*devs
      break;
    else
      b_class = b_class + 1;
    end
  end
end

y = (a_class == b_class);
