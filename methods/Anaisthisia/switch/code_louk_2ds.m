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
bciroot = {'/Users/louk/Data/Raw' '~/Data/Raw' '/media/LoukStorage/Raw' '/media/F2786FA2786F63F7/loukstorage/Raw'};
%expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
expt    = 'long_movements';
subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% choose which condition to use: either '1sec', '3sec', '9sec' or 'async'
labels  ={'3sec'}; %condition{

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
    
    % blocks are used for testing.
    
    trnInd=ones(size(z.Y,1),1)>0;
    %trnInd=[z.di(n2d(z,'epoch')).extra.src]==1 | [z.di(n2d(z,'epoch')).extra.src]==2 | [z.di(n2d(z,'epoch')).extra.src]==3 | [z.di(n2d(z,'epoch')).extra.src]==4;
    %trnInd=[z.di(n2d(z,'epoch')).extra.src]==1;
    nfolds=sum(trnInd)/n_con_ex/3;
    nfolds
    z.foldIdxs=zeros(size(z.Y,1),nfolds);
    z.foldIdxs(trnInd,1:nfolds)=gennFold(z.Y(trnInd,:),nfolds); % 10-fold
    z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold
    
    % remove everything but the eeg channels
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z=jf_retain(z,'dim','time','range','between','vals',[-1000 6000]);
    
    %z.X=ls_whiten(z.X,method,L,trdim,T,time_window);
    
    % use spectrogram instead of Welch when using multiple time windows: compute a spectrum every 250ms with a freq resolution of 4hz
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    
    % keep only the frequencies we're interested in
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    
    % Use several time windows
    %     % average this spectrum in 2 different phases of time
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    %     % make a filter (weighting over time) for each of the 2 phases we care about
    %
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w)); % make into means
    %     % apply this filter to the data to compute the average power in each phase
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));
    
    % show the current state of the data
    jf_disp(z)
    
    % run the classifier (mcPerf 1: multi-class for sequence decoding)
    z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
    tstbin=squeeze(z.prep(end).info.res.tstbin);
    Res_in(si,:)=tstbin(:,z.prep(end).info.res.opt.Ci);
    
    ztype{si}=z;
    
end





