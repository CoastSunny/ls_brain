function onestimulus(code, soa, numofstim, file, seqfile, program)

% ONESTIMULUS Produces a sequence containing only one stimulus
%
% ONESTIMULUS(code, soa, numofstim, file, seqfile, program)
%    
%    code       trigger code for stimulus
%    soa         stimulus onset asynchrony (in seconds)
%    numofstim   total number of stimuli wanted
%    file       file name of stimulus
%    seqfile     file name for sequence file
%    program     an integer: 1 for Stim, 2 for BrainStim, 3 for Presentation
%
%    CBRU / University of Helsinki, Finland

rand('state',sum(100*clock)) % The seed for the random number generator from the system clock.

% The sequence is created using the STIM notation:

for i = 1:numofstim
  seq{i,1} = i;
  seq{i,2} = 3;
  seq{i,3} = 0;
  seq{i,4} = 0;
  seq{i,5} = soa;
  seq{i,6} = 90;
  seq{i,7} = 90;
  seq{i,8} = -1;
  seq{i,9} = code;
  seq{i,10} = file;
end

wbar = waitbar(0.5,'Creating the sequence...');
%%%
% The sequence is written into a file.
sequencefile(seq, program, seqfile, wbar);

