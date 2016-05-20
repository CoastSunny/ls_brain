function y = oreg(stimuli, soamin, soamax, totalstim, probs, minstim, filename, path, codes, format)

% OREG Produces a sequence file using the Regulated Oddball paradigm
%
% OREG(stimuli, soamin, soamax, totalstim, probs, minstim, filename, path, codes, format)
%    
%    stimuli     a cell containing the stimulus names
%    soamin      the stimulus onset asynchrony
%    soamax      in case of random soa, the biggest possible value
%    totalstim   the total approximate amount of stimuli
%    probs       a vector containing stimulus probabilities
%    minstim     a vector containing sequence settings
%    filename    the name of the resulting sequence file
%    path        the absolute path
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


% The minimum number of stimuli between two same standard stimuli
% or if categorized stimuli, minimum number of other stimuli
% between two stimuli of same class.
r2 = minstim(2);

is_cat = size(stimuli,1)>1;

totalstim = totalstim + r2;


% The number of stimuli, the code of which is set to 0, after a
% deviant:
num0 = minstim(3);

% Number of standards after a deviant:
repmin = probs(1);
repmax = probs(2);

% Number of different standard stimuli:
numofstd = probs(3);


% Number of different deviant stimuli:
numofdev = probs(4);


% A list containing standard repetitions after a deviant is
% randomly created.

i = 0;
devtot = 0;
while (i < totalstim)
  repetitions = repmin + round(rand*(repmax-repmin));
  devtot = devtot + 1;
  replist(devtot) = repetitions;
  i = i + repetitions + 1;
end

totalstim = i;


% Standard stimulus probabilities:
for i = 1:numofstd
  stdprobs(i) = probs(i+4);
end

% Deviant stimulus probabilities:
for i = 1:numofdev
  devprobs(i) = probs(i+numofstd+4);
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
% probabilities.

k = 1;
for i = 1:numofstd
  num = round(0.01*stdprobs(i)*(totalstim-devtot)*sc)+1;
  for j = 1:num
    stds(k) = i;
    k = k+1;
  end
end
k = 1;
for i = 1:numofdev
  num = round(0.01*devprobs(i)*devtot*dc)+1;
  for j = 1:num
    devs(k) = i+numofstd;
    k = k+1;
  end
end


% Sequences are randomized, resulting sequences are "standards" and
% "deviants":


numofstim = length(stds);
stimleft = numofstim;
for i = 1:numofstim
  randindex = ceil(rand*stimleft);
  standards(i) = stds(randindex);
  for j = randindex:numofstim-1
    stds(j) = stds(j+1);
  end
  stimleft = stimleft - 1;
end

numofstim = length(devs);
stimleft = numofstim;
for i = 1:numofstim
  randindex = ceil(rand*stimleft);
  deviants(i) = devs(randindex);
  for j = randindex:numofstim-1
    devs(j) = devs(j+1);
  end
  stimleft = stimleft - 1;
end

% If user has wanted to restrict same standards in a row, it 
% is checked and corrected now:
r2_end_error = 0;
if (r2>0)
  for i = 1:length(standards)
    if (i+r2 > length(standards))
      r2_end_error = 1;
      break;
    end
    
    for j=i+1:i+r2
      if (standards(j) == standards(i))
	% A same standard was found too close.
	for k = j:length(standards)
	  if (standards(k) ~= standards(j))
	    temp = standards(j);
	    standards(j) = standards(k);
	    standards(k) = temp;
	    break; % A different standard was found and swapped.
	  else
	    if (k==length(standards))
	      r2_end_error = 1;
	    end
	  end
	end
      end
    end
  end
end


% A list cointaining the soas for all stimuli (randomized, if
% wanted) is created.
for k = 1:totalstim
  if (soamax > soamin)
    soa(k) = soamin + rand*(soamax - soamin);
  else
    soa(k) = soamin;
  end  
end

%%%
% The sequence is created:

stim = 0; % Sequence counter
wbar = waitbar(0,'Creating the sequence...');

for i = 1:devtot
  waitbar((minstim(6)-1)/minstim(5)+i/(minstim(5)*2*totalstim));
  stim = stim+1;
  seq{stim,1} = stim;
  seq{stim,2} = 3;
  seq{stim,3} = 0;
  seq{stim,4} = 0;
  seq{stim,5} = soa(stim);
  seq{stim,6} = 90;
  seq{stim,7} = 90;
  seq{stim,8} = -1;
  seq{stim,9} = codes(deviants(i));
  seq{stim,10} = stimuli{deviants(i)};
  
  for j = 1:replist(i)
    stim = stim+1;
    seq{stim,1} = stim;
    seq{stim,2} = 3;
    seq{stim,3} = 0;
    seq{stim,4} = 0;
    seq{stim,5} = soa(stim);
    seq{stim,6} = 90;
    seq{stim,7} = 90;
    seq{stim,8} = -1;

    if (num0 > 0 & num0 >= j)
      seq{stim,9} = 0;
    else
      seq{stim,9} = codes(standards(stim-i));
    end
    seq{stim,10} = stimuli{standards(stim-i)};
  end
end
      
% Some of the first stimuli are marked differently to
% guarantee reliability (trigger code 0).

if (minstim(4)>0)
  for j = 1:minstim(4)
    seq{j,9} = 0;
  end
end

% If same standards remained too close to each other at the 
% end of the sequence, the codes of those stimuli are set to 0.

if (r2_end_error)
  for j = stim-r2:stim
    seq{j,9} = 0;
  end
end


%%%
% The sequence is written into a file.
filename = sequencefile(seq, format, filename, wbar);


a(1) = devtot/stim;
a(2) = stim;

y = a;

