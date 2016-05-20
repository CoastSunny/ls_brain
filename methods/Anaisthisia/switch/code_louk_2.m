% The data for experiment 2 can be found in
% '/Volumes/BCI_Data/own_experiments/motor_imagery/movement_detection/long_
% movements/'

% 
% First, make sure you have the following folders added to your matlab path:
% 
% 'BCI_code/toolboxes/jf_bci/'
% 'BCI_code/toolboxes/classification/'
% 'BCI_code/toolboxes/eeg_analysis/'
% 'BCI_code/toolboxes/numerical_tools'
% 'BCI_code/toolboxes/plotting'
% 'BCI_code/toolboxes/signal_processing/'
% 'BCI_code/toolboxes/utilities/'

% To load use the following loop (preprocessing steps etc. are within the loop):

global bciroot;
% N.B. add the directory where the BCI_Data is mounted to this list for the
% system to find the raw data files and the saved files,
% e.g. bciroot={bciroot{:} '/Volumes/BCI_Data/'};
%bciroot = '/Volumes/BCI_Data/'; 
bciroot = '/Users/louk/Data/Raw';
%expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
expt    = 'long_movements';
subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% choose which condition to use: either '1sec', '3sec', '9sec' or 'async'
%labels  ={'3sec'}; %condition{

for si=1:numel(subjects);
% si=1; % pick a subject number
sessi=1; ci=1; % session and condition are always the 1st

% get the info for this subject
subj=subjects{si};
session=sessions{si}{sessi};
label=labels{ci};

% load the sliced data
z=jf_load(expt,subj,label,session,-1);

% run the pre-processing (file attached)
z=preproc_anthesia(z);

% setup 1st block only folding. This was used to simulate a 'preoperative
% calibration session' or simply an online study in general. So, the first
% block of data is used for training of the classifier and the remaining
% blocks are used for testing. 
z.foldIdxs=zeros(size(z.Y,1),10);
trnInd=[z.di(n2d(z,'epoch')).extra.src]==1 | [z.di(n2d(z,'epoch')).extra.src]==2 | [z.di(n2d(z,'epoch')).extra.src]==3 | [z.di(n2d(z,'epoch')).extra.src]==4;
%trnInd=[z.di(n2d(z,'epoch')).extra.src]==1;
z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold     
z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold
% size(z.Y,1)
% 10-fold CV. Alternatively, use 10-fold cross validation (generally higher
% performance, but less relevant for eventual application than '1-st block
% only' folding).
 %z.foldIdxs=gennFold(z.Y,10);

% save copy of the data before we do more stuff to it..
oz=z; % N.B. use z=oz; to get back to 'clean' version of data to try alternative pre-processings
%z.Ydi(1).name = 'epoch';
z
% % setup 2 sub-problems, rest vs im, and rest vs. am
z.Ydi(1).name='epoch';
z=jf_addClassInfo(z,...
                  'spType',{{{nomove} {immove}}...
                            {{nomove} {ammove}}},'summary','rest vs move'); 


% remove everything but the eeg channels
z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');


% For analysis using only the ERD period, simply remove the rest of the data using:

%     % sub-set down to 9s of data from time 0-9 after the marker (or 1 or 3s, depending on condition)
%     z=jf_retain(z,'dim','time','range','between','vals',[0 9000],'valmatch','nearest','summary','1s win');
% 
%     %and then 
% %     % map to frequency domain, with 4hz frequency resolution using Welch's method
%      z=jf_welchpsd(z,'width_ms',250,'log',1,'detrend',1);
% %     
% %     % keep only the frequencies we're interested in
%      z=jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    
    
% For analysis using the combined ERD and ERS periods, use the following lines instead:    

    % use spectrogram instead of Welch when using multiple time windows: compute a spectrum every 250ms with a freq resolution of 4hz
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);

    % keep only the frequencies we're interested in
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
 
 

    % Use several time windows
%     % average this spectrum in 2 different phases of time
     tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
%     % make a filter (weighting over time) for each of the 2 phases we care about
%     %w=mkFilter(size(z.X,tD),{{[0 100 900 1000]} {[1000 1200 2800 3000]}},z.di(tD).vals);
%     %w=mkFilter(size(z.X,tD),{{[0 250 2750 3000]} {[3500 3700 4800 5000]}},z.di(tD).vals);
%     %w=mkFilter(size(z.X,tD),{{[0 500 8500 9000]} {[9500 9700 10800 11000]}},z.di(tD).vals);
     w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
     w=repop(w,'./',sum(w)); % make into means
%     % apply this filter to the data to compute the average power in each phase
     z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));

    
% show the current state of the data
jf_disp(z)

% %Sequence decoding
% % create a new sequence dimension, by grouping epochs into sequences
% z=jf_splitDim(z,'dim','epoch','seqLen', 3, 'seqFold',1);
% % Then setup to automatically do sequence decoding
% spD=n2d(z.Ydi,'subProb');
% z.Ydi(spD).info.mcSp=1; % treat as multiclass problem
% z.Ydi(spD).info.spMx=repmat(shiftdim(z.Ydi(spD).info.spMx,-1),[size(z.X,n2d(z,'epoch')),1,1]);
% z.Ydi(spD).info.spD ={'subProb' 'epoch'};

% run the classifier (mcPerf 1: multi-class for sequence decoding)
z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
Y{si}=z.Y;
% in case of 1st block folding: compute the test blocks performance
% if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
%   z.prep(end).info.res.opt.res = cvPerf(z.Y,z.prep(end).info.res.opt.f,[1 2 3],z.outfIdxs);
%   z.prep(end).info.res.opt.res.di(2) = z.prep(end).info.res.di(2); % update subprob info
% end
% %print the resulting test set performances
% ores=z.prep(end).info.res.opt.res;
% for spi=1:size(ores.trnbin,n2d(ores.di,'subProb')); % loop over sub-problems
%   fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,ores.trnbin(:,spi),ores.tstbin(:,spi));
% end
% Res(si,:)=[ores.tstbin(:,1) ores.tstbin(:,2)];

tstbin=squeeze(z.prep(end).info.res.tstbin);
Res_in(si,:)=tstbin(:,z.prep(end).info.res.opt.Ci);

cs{si}=constant_shifts_new( z ,n_con_ex, -1 );
%     % run the classifier with automatic channel selection
%     z=jf_compKernel(z,'grpDim','ch'); % compute a kernel per channel
%     z=jf_cvtrain(z,'objFn','mkKLR','seedNm','alphabB','Cscale','l1');
% 
%       % plot the channel importance map
%       clf;jplot([z.prep(m2p(z,'jf_compKernel')).info.odi(1).extra.pos2d],z.prep(end).info.res.opt.soln{2}{2},'clim','cent0'); colorbar; colormap ikelvin
%     
    % run the classifier with automatic frequency selection
%     z=jf_compKernel(z,'grpDim','freq'); % compute a kernel per frequency
%     z=jf_cvtrain(z,'objFn','mkKLR','seedNm','alphabB','Cscale','l1');
    
    %   plot the frequency importance map
%       clf;plot([z.prep(m2p(z,'jf_compKernel')).info.odi(2).vals],z.prep(end).info.res.opt.soln{2}{2});
    
    %   plot the frequency/channel importance topoplot 
%       clf;jf_topoplot(jf_clsfrWeights(z),'clim','cent0','layout',[2
%       6],'labels',wghts.di(2).vals(:)*[1 1]); colormap ikelvin
%   
%   clf;jf_topoplot(jf_clsfrWeights(z),'clim',[-5 5],'layout',[2
%       6],'labels',wghts.di(2).vals(:)*[1 1]); colormap ikelvin

end




% Plotting options

%    % plot classifier weights, per frequency bin, per condition
%     wghts = jf_clsfrWeights(z);
%     clf;jf_topoplot(wghts,'clim','cent0','layout',[2 6])

%    % or alternatively   
%      clf;jplot([wghts.di(1).extra.pos2d],wghts.X,'clim','cent0','layout',
%      [2 6],'labels',wghts.di(2).vals(:)*[1 1]); colormap ikelvin
%     


