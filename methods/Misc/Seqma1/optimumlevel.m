function y = optimumlevel(stimuli, soamin, soamax, stdmin, stdmax, totaldev, filename, codes, format)

% OPTIMUMLEVEL Produces a sequence file using the Optimum paradigm with levels.
%
% OPTIMUMLEVEL(stimuli, soamin, stdmin, stdmax, soamax, totaldev, filename, codes, format)
%    
%    stimuli     a cell containing the stimulus names (standard + deviants, levels in cells)
%    soamin      the stimulus onset asynchrony (num)
%    soamax      in case of random soa, the biggest possible value (num)
%    stdmin      minimum number of standards between deviants (num)
%    stdmax      maximum number of standards between deviants (num)
%    totaldev    the total number of deviants (num)
%    filename    the name of the resulting sequence file (string)
%    codes       a matrix containing the trigger codes (type x level)
%    format      an integer telling, the format of which program to use
%
%    The probability of standard in the sequence is 50%. The probability of
%    all the deviant types in the sequence is equal.
%    
%    CBRU / University of Helsinki, Finland

rand('state',sum(100*clock)) % The seed for the random number generator from the system clock.

%%%
% A list (stimlist) containing the order, in which the stimuli are
% presented is randomly created, according the settings which the
% user has input.

% Number of different deviant stimuli:
numofdev = length(stimuli) - 1;

% The total number of deviants is corrected so that there will be equal number
% of all types of deviants.
if mod(totaldev,numofdev) > 0
    totaldev = numofdev*(floor(totaldev / numofdev)) + 2*numofdev;
end

% The needed number of deviant "arrays", in which all the deviants are
% present once:
numofarrays = ceil(totaldev / numofdev);

% The deviant arrays are created, randomized in order, and put into a
% sequence.
devseq = randperm(numofdev);
for i = 1:numofarrays
    newarray = randperm(numofdev);
    if newarray(1) == devseq(length(devseq)) % two deviants in a row
        swap = ceil(rand*(numofdev-1))+1; % the first one is changed with this one
        newarray(1) = newarray(swap);
        newarray(swap) = devseq(length(devseq));
    end
    devseq = [devseq newarray];
end

% An array containing different levels is created for each deviant type and
% randomized in order.

numoftype = (totaldev/numofdev);
levels = zeros(numofdev,numoftype);
for i = 1:numofdev
    numoflevels = length(stimuli{i+1});
    for j = 1:numoftype
        levels(i,j) = mod(j,numoflevels)+1;
    end
    temp = levels(i,:);
    levels(i,:) = temp(randperm(numoftype)); % the order is randomized
end

% The array containing the (potential) standard repetitions is created.
if stdmin == stdmax & stdmax == 1
    stdseq = ones(1,totaldev);
else
    if stdmax < stdmin
        stdmax = stdmin;
    end
    stdseq = zeros(1,totaldev);    
    for i = 1:totaldev
        stdseq(i) = mod(i,stdmax-stdmin + 1);
    end
    stdseq = stdseq + stdmin;
    stdseq = stdseq(randperm(totaldev));
end

% A list cointaining the soas for all stimuli (randomized, if
% wanted) is created.
totalstim = totaldev + sum(stdseq) + 5;
soa = zeros(totalstim,1);
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

% The first five stimuli are standards (code 0)
for i = 1:5
  stim = stim+1;
  seq{stim,1} = stim;
  seq{stim,2} = 3;
  seq{stim,3} = 0;
  seq{stim,4} = 0;
  seq{stim,5} = soa(stim);
  seq{stim,6} = 90;
  seq{stim,7} = 90;
  seq{stim,8} = -1;
  seq{stim,9} = 0;
  seq{stim,10} = stimuli{1};
end

wbar = waitbar(0,'Creating the sequence...');
counter = ones(numofdev,1);
stdcounter = 1;

for i = 1:totaldev*2
  waitbar(i/(totalstim*2));
  if mod(i,2) ~= 0 % standard
      for j = 1:stdseq(stdcounter)
            stim = stim+1;
            seq{stim,1} = stim;
            seq{stim,2} = 3;
            seq{stim,3} = 0;
            seq{stim,4} = 0;
            seq{stim,5} = soa(stim);
            seq{stim,6} = 90;
            seq{stim,7} = 90;
            seq{stim,8} = -1;
            seq{stim,9} = 1;
            seq{stim,10} = stimuli{1};
      end
      stdcounter = stdcounter + 1;
  else % deviant
      stim = stim+1;
      seq{stim,1} = stim;
      seq{stim,2} = 3;
      seq{stim,3} = 0;
      seq{stim,4} = 0;
      seq{stim,5} = soa(stim);
      seq{stim,6} = 90;
      seq{stim,7} = 90;
      seq{stim,8} = -1;
      type = devseq(i/2);
      level = levels(type,counter(type));
      counter(type) = counter(type) + 1;
      names = stimuli{type+1};
      seq{stim,9} = codes(type,level);
      seq{stim,10} = names{level};
  end
end
      

%%%
% The sequence is written into a file.
filename = sequencefile(seq, format, filename, wbar);

y = filename;
