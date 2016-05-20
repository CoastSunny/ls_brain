function y = oddballtrain(stimuli, trainset, totalstim, probs, minstim, filename, codes, format)

% ODDBALLTRAIN Produces a sequence file using the Oddball train paradigm
%
% ODDBALLTRAIN(stimuli, trainset, totalstim, probs, minstim, filename, path, codes, format)
%    
%    stimuli     a cell containing the stimulus names
%    trainset    SOA, ITI, Train length
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

% Min SOA
soamin = trainset(1);
% Max SOA
soamax = trainset(2);
% Min ITI
itimin = trainset(3);
% Max ITI
itimax = trainset(4);
% Min number of stimuli in a train
trainmin = trainset(5);
% Max number of stimuli in a train
trainmax = trainset(6);



% A list (trainlist) containing trains is randomly created.

i = 0;
j = 1;
while (i < totalstim)
  trainlength = trainmin + round(rand*(trainmax - trainmin));
  trainlist(j) = trainlength;
  i = i + trainlength;
  j = j + 1;
end
totalstim = i;

% A list cointaining the SOAs for all stimuli (randomized, if
% wanted) is created.
for k = 1:totalstim
  if (soamax > soamin)
    soa(k) = soamin + rand*(soamax - soamin);
  else
    soa(k) = soamin;
  end  
end


% A list containing the ITIs for all trains (randomized, if 
% wanted) is created.
for k = 1:length(trainlist)
  if (trainmax > trainmin)
    iti(k) = itimin + rand*(itimax - itimin);
  else
    iti(k) = itimin;
  end
end


% A list containing information about which trains begin with 
% deviant (1) and which don't (0) is created and the order is
% randomized.
devtrains = round(0.01*probs(1)*length(trainlist));
numoftrains = length(trainlist);
for i = 1:devtrains
  tc(i)=1;
end
for i = devtrains+1:numoftrains
  tc(i)=0;
end
% Order is randomized:
tc_left=numoftrains;
for i = 1:numoftrains
  randindex = ceil(rand*tc_left);
  traincodes(i) = tc(randindex);
  for j = randindex:numoftrains-1
    tc(j) = tc(j+1);
  end
  tc_left = tc_left - 1;
end




% The minimum number of stimuli between two same standard stimuli
% or if categorized stimuli, minimum number of other stimuli
% between two stimuli of same class.
r2 = minstim(1);


% The number of stimuli, the code of which is set to 0, after a
% deviant:
num0 = minstim(2);


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


% A sequence containing only standard stimuli (according to 
% given probabilities) is created and randomized:
k = 1;
for i = 1:numofstd
  num = round(0.01*stdprobs(i)*(totalstim-devtrains)*sc);
  for j = 1:num+1  % +1 to make sure there are enough
    stds(k) = i;
    k = k+1;
  end
end

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


% Do all standards have same codes?
if (size(codes,1)==1)
  same = 1;
else
  same = 0;
end

% A sequence containing only deviant stimuli (according to 
% given probabilities) is created and randomized:
k = 1;
for i = 1:numofdev
  num = round(0.01*devprobs(i)*devtrains*dc);
  if (num == 0)
    num = 1;
  end
  for j = 1:num
    devs(k) = i+numofstd;
    k = k+1;
  end
end

neworder = randperm(length(devs));
deviants = devs(neworder);

for i = 1:numofdev
  if (same)
    devcodes(i)=codes(13+i);
  else
    devcodes(i)=codes(numofstd+i,1);
  end
end


%%%
% The sequence is created:

train = 1;
dev = 1;
std = 1;
stim = 1;
previous_dev = 0;

wbar = waitbar(0,'Creating the sequence...');

for i = 1:length(trainlist)
  for j = 1:trainlist(train)
    waitbar((minstim(5)-1)/minstim(4)+stim/(minstim(4)*2*totalstim));
    seq{stim,1} = stim;
    seq{stim,2} = 3;
    seq{stim,3} = 0;
    seq{stim,4} = 0;
    if (j==1)
      seq{stim,5} = iti(train);
    else
      seq{stim,5} = soa(stim);
    end
    seq{stim,6} = 90;
    seq{stim,7} = 90;
    seq{stim,8} = -1;
    

    if (j==1)
      if (traincodes(train)) %starts with deviant
	seq{stim,9} = devcodes(deviants(dev)-numofstd);
	seq{stim,10} = stimuli{deviants(dev)};
	dev = dev+1;
	previous_dev = 1;
      else
	previous_dev = 0;
	if (same)
	  seq{stim,9} = codes(7);
	else
	  seq{stim,9} = codes(standards(std),7);
	end
	seq{stim,10} = stimuli{standards(std)};
	std = std+1;
      end
    else
      if (j<7)
	if (traincodes(train))
	  if (same)
	    if (previous_dev & j<=num0)
	      seq{stim,9} = 0;
	    else
	      seq{stim,9} = codes(standards(std),j-1);
	    end
	  else
	    if (previous_dev & j<=num0)
	      seq{stim,9} = 0;
	    else
	      seq{stim,9} = codes(standards(std),j-1);
	    end
	  end
	else
	  if (same)
	    if (previous_dev & j<=num0)
	      seq{stim,9} = 0;
	    else
	      seq{stim,9} = codes(standards(std),6+j);
	    end
	  else
	    if (previous_dev & j<=num0)
	      seq{stim,9} = 0;
	    else
	      seq{stim,9} = codes(standards(std),6+j);
	    end
	  end
	end
	seq{stim,10} = stimuli{standards(std)};
	std = std+1;
      else
	if (traincodes(train))
	  if (same)
	    seq{stim,9} = codes(6);
	  else
	    seq{stim,9} = codes(standards(std),6);
	  end
	else
	  if (same)
	    seq{stim,9} = codes(13);
	  else
	    seq{stim,9} = codes(standards(std),13);
	  end
	end
	seq{stim,10} = stimuli{standards(std)};
	std = std+1;
      end
    end
    stim = stim+1;
  end
  train = train+1;
end

% Some of the first stimuli are marked differently to
% guarantee reliability (trigger code 0).

if (minstim(3)>0)
  for j = 1:minstim(3)
    seq{j,9} = 0;
  end
end

% If same standards remained too close to each other at the 
% end of the sequence, the codes of those stimuli are set to 0.

if (r2_end_error)
  for j = totalstim-r2:totalstim
    seq{j,9} = 0;
  end
end


%%%
% The sequence is written into a file.
filename = sequencefile(seq, format, filename, wbar);


a(1) = devtrains/length(trainlist);
a(2) = totalstim;

y = a;

