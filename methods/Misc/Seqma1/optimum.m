function y = optimum(stimuli, stdrep, soa, totalstim, filename, codes, format)

% OPTIMUM Produces a sequence file using the regular Optimum paradigm.
%
% OPTIMUM(stimuli, stdrep, soa, totalstim, filename, codes, format)
%    
%    stimuli     a cell containing the stimulus names (standard + deviants)
%    stdrep      number of standard stimulus repetitions between two deviants [min max]
%    soa         the stimulus onset asynchrony [min max]
%    totalstim   the total number of deviant stimuli
%    filename    the name of the resulting sequence file
%    codes       a vector containing the trigger codes
%    format      an integer telling, the format of which program to use
%
%    The probability of all the deviants in the sequence is equal.
%    
%    CBRU / University of Helsinki, Finland

rand('state',sum(100*clock)) % The seed for the random number generator from the system clock.

soamin = soa(1);
soamax = soa(2);

%%%
% A list (stimlist) containing the order, in which the stimuli are
% presented is randomly created, according the settings which the
% user has input.

% Number of different deviant stimuli:
numofdev = length(stimuli) - 1;

% The total number of deviants is made so that there will be equal number
% of all types of deviants.
if mod(totalstim,numofdev) > 0
    totalstim = numofdev*(floor(totalstim / (numofdev))) + numofdev;
end

% The needed number of deviant "arrays", in which all the deviants are
% present once:
numofarrays = ceil(totalstim / numofdev);

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

% The number of stds after each dev (stdseq):
if (stdrep(2) > stdrep(1))
    options = stdrep(2)-stdrep(1)+1;
    reps = ceil(length(devseq)/options);
    for i = 1:options
        stdseq((i-1)*reps+1:i*reps) = stdrep(1)-1+i;
    end
    stdseqorder = randperm(length(stdseq));
    stdseq = stdseq(stdseqorder);
else
    stdseq(1:length(devseq)) = stdrep(1);
end

% A list cointaining the soas for all stimuli (randomized, if
% wanted) is created.
soa = zeros(totalstim+5+sum(stdseq),1);
for k = 1:totalstim+5+sum(stdseq)
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

for i = 1:totalstim*2
  waitbar(i/(totalstim*2));
  if mod(i,2) == 0 % standard
      for j = 1:stdseq(i/2)
          stim = stim+1;
          seq{stim,1} = stim;
          seq{stim,2} = 3;
          seq{stim,3} = 0;
          seq{stim,4} = 0;
          seq{stim,5} = soa(stim);
          seq{stim,6} = 90;
          seq{stim,7} = 90;
          seq{stim,8} = -1;
          seq{stim,9} = codes(1);
          seq{stim,10} = stimuli{1};
      end
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
      seq{stim,9} = codes(devseq(ceil(i/2))+1);
      seq{stim,10} = stimuli{devseq(ceil(i/2))+1};
  end
end
      

%%%
% The sequence is written into a file.
filename = sequencefile(seq, format, filename, wbar);

y = filename;
