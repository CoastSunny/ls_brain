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
bciroot = {'/Users/louk/Data/Raw' '~/Data/Raw' '/media/LoukStorage/Raw'};
%expt    = 'own_experiments/motor_imagery/movement_detection/long_movements';
expt    = 'long_movements';
subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% choose which condition to use: either '1sec', '3sec', '9sec' or 'async'
labels  =label_win; %condition{

for si=1:10;%[1:3  5:10];%1:numel(subjects)
    % si=1; % pick a subject number
    sessi=1; ci=1; % session and condition are always the 1st
    
    % get the info for this subject
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    
    % load the sliced data
    z=jf_load(expt,subj,label,session,-1);
    if ( isempty(z) ) continue; end;
    
    % run the pre-processing (file attached)
    z=preproc_anthesia(z);
    
    % setup 1st block only folding. This was used to simulate a 'preoperative
    % calibration session' or simply an online study in general. So, the first
    % block of data is used for training of the classifier and the remaining
    % blocks are used for testing.
    
    out=foldstuff(z,trblocks,exblocks);
    z.foldIdxs=out.foldIdxs;
    z.outfIdxs=out.outfIdxs;
    
    % save copy of the data before we do more stuff to it..
    oz=z; % N.B. use z=oz; to get back to 'clean' version of data to try alternative pre-processings
    
    
    % remove everything but the eeg channels
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    
    
    % % For analysis using the combined ERD and ERS periods, use the following lines instead:
    z.X=ls_whiten(z.X,4,20,trdim,T,time_window);%,freqband);
    %     % use spectrogram instead of Welch when using multiple time windows: compute a spectrum every 250ms with a freq resolution of 4hz
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    %
    % %     % keep only the frequencies we're interested in
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    %     % make a filter (weighting over time) for each of the 2 phases we care about
    %
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w)); % make into means
    %     % apply this filter to the data to compute the average power in each phase
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'1swin'}));
    %
    
    
    % run the classifier (mcPerf 1: multi-class for sequence decoding)
    z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');
    Ci=z.prep(end).info.res.opt.Ci;
    
    if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
        res = cvPerf([z.Y z.Y(:,1)],...
            [z.prep(end).info.res.opt.f z.prep(end).info.res.opt.f(:,2)],...
            [1 2 3],z.outfIdxs,'bal');
        res.di(2) = z.prep(end).info.res.di(2); % update subprob info
    end
    
    % print the resulting test set performances
    
    for spi=1:size(res.trnbin,n2d(res.di,'subProb')); % loop over sub-problems
        fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,res.trnbin(:,spi),res.tstbin(:,spi));
    end
    tstbin=squeeze(z.prep(end).info.res.tstbin);
    Res_in(si,:)=tstbin(:,z.prep(end).info.res.opt.Ci);
    
    Res_out(si,:)=res.tstbin;
    fI=z.prep(end).info.res.opt.f(:,2);
    FpI{si}=fI(z.Y(:,2)==-1 & z.outfIdxs==1);
    FnI{si}=fI(z.Y(:,2)==1 & z.outfIdxs==1);
    dmsav{si}=dec_methods( z , 'all' , -1 , 1 ,'sav' , 1,32,1);
    dmnrow{si}=dec_methods( z , n_con_ex , -1 , 1 ,'asynch_dec_nrow' , 1);
    ztype{si}=z;
    
    
end



