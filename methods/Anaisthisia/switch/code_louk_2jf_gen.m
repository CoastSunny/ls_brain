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

for si=1:10;
    
    sessi=1; ci=1;
    
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    
    % load the sliced data
    z=jf_load(expt,subj,label,session,-1);
    if ( isempty(z) ) continue; end;
    
    % run the pre-processing (file attached)
    z=preproc_anthesia(z);
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w)); % make into means
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'1swin'}));
    
    zz(si)=z;
    
end

zall=jf_cat(zz,'dim','epoch');
clear z

for si=1:10
    fprintf(num2str(si));
    z=zall;
    
    out=foldstuff_gen(z,si,trblocks,exblocks);
    z.foldIdxs=out.foldIdxs;
    z.outfIdxs=out.outfIdxs;
    
    z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
    
    if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
        res = cvPerf(z.Y,z.prep(end).info.res.opt.f,[1 2 3],z.outfIdxs,'bal');
        res.di(2) = z.prep(end).info.res.di(2); % update subprob info
    end
    % print the resulting test set performances
    ores=res;
    for spi=1:size(ores.trnbin,n2d(ores.di,'subProb')); % loop over sub-problems
        fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,ores.trnbin(:,spi),ores.tstbin(:,spi));
    end
    cs{si}=constant_shifts_new( z ,n_con_ex, -1 );
    Res_in(si,:)=z.prep(end).info.res.tstbin(:,z.prep(end).info.res.opt.Ci);
    Res_out(si,:)=[ores.tstbin(:,1) ores.tstbin(:,2)];
    cAb{si}=z.prep(end).info.res.calAb;
    decision_values{si}=z.prep(end).info.res.tstf(:,:,Ci);
    Y{si}=z.Y;
    outfIdxs{si}=z.outfIdxs;
    foldIdxs{si}=z.foldIdxs;
        
end




