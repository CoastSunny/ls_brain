% The first dataset was used to determine the optimal settings of a
% movement-based brain switch for use during surgery. In this experiment,
% auditory cues were played for subjects instructing them to perform a
% certain type of movement: 1) right-hand movement, 2) movement of both
% arms or 3) no movement. After each instruction, a sequence of nine 3-second trials
% followed (each of the same movement type).
% Initially, we compared the classification results between 'right hand
% movement' and 'both arms movement' (both using 'no movement' as the
% baseline class). We didn't find any major differences but nevertheless
% 'both arms movement' performed slightly better so we chose to use only this
% condition for further analysis.

% The data for this experiment can be found in
% '/Volumes/BCI_Data/own_experiments/motor_imagery/movement_detection/trial
% _based/offline/'

% To load use the following loop (preprocessing steps etc. are within the loop):

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

global bciroot;
% N.B. add the directory where the BCI_Data is mounted to this list for the
% system to find the raw data files and the saved files,
% e.g. bciroot={bciroot{:} '/Volumes/BCI_Data/'};
% bciroot = '/Users/louk/Data/Raw/';
bciroot = {'/Users/louk/Data/Raw/'  '/media/louk/Storage/Raw' '/home/louk/Data/' '/media/LoukStorage/Raw' '/media/F2786FA2786F63F7/loukstorage/Raw'};
expt    = 'trial_based/offline';
%expt    = 'own_experiments/motor_imagery/movement_detection/trial_based/offline';
subjects= {'linsey' 'Jorgen' 'makiko' 'lucinda' 'jason' 'moniek' 'chris' 'nienke' 'yvonne' 'rutger'}; % subj{
sessions= {{'20110112'} {'20110114'} {'20110118'} {'20110120'} {'20110131'} {'20110323'} {'20110323'} {'20110330'} {'20110406'} {'20110413'}}; % subj{ session{
labels  ={'trn'};
%condition{
timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};

%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};

%timeperiod={{[0 250 3250 3500]} {[3500 3750 5750 6000]}};

% expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
% subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik' 'makiko'}; % subj{
% sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% labels  ={'1sec'}; %condition{
%%%%%%RESULTS FOR WORST CASE SUBJECT
%clear out out_trans
for si=1:10;%[9 5 1 2 3 4 6 7 8 10]
    % si=1; % pick a subject number
    sessi=1; ci=1; % session and condition are always the 1st
    
    % get the info for this subject
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    
    % load the sliced data
    z=jf_load(expt,subj,label,session,-1);
    
    % reject all epochs which came from the 5th source file, i.e. block 5. We
    % used this because some of the subjects only did 4 experiment blocks instead of 5.
    z=jf_reject(z,'dim','epoch','idx',[z.di(3).extra.src]==5);
    
    % run the pre-processing (file attached)
    z=preproc_anthesia(z);
    z=jf_addClassInfo(z,...
        'spType',{...%{{'rest3' 'rest4' 'rest5'} {'rh3' 'rh4' 'rh5'}}...
        {{'rest3' 'rest4' 'rest5'} {'any3' 'any4' 'any5'}}},'summary','rest vs move');
    
    % setup 1st block only folding. This was used to simulate a 'preoperative
    % calibration session' or simply an online study in general. So, the first
    % block of data is used for training of the classifier and the remaining
    % blocks are used for testing.
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z=jf_retain(z,'dim','time','range','between','vals',[-1000 6000]);
    %% FFT FILTER
%     freqband=[8 24];
%     fs=128;
%     len=size(z.X,2);
%     filt=mkFilter(freqband,floor(len/2),fs/len);
%     z.X=fftfilter(z.X,filt,[0 len],2,1);
    %% whitening/normalisation
    z.X=ls_whiten(z.X,wmethod,L,T,time_window);
    %%
    %%
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w));
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));
    
    y_idx=z.Y~=0;
    X=z.X(:,:,:,y_idx);
    Y=z.Y(y_idx);
    XnomovA=X(:,:,1,Y==1);
    XnomovB=X(:,:,2,Y==1);
    hYYY(:,:,1,si)=mean(XnomovA,4);
    hYYY(:,:,2,si)=mean(XnomovB,4);
    XmovA=X(:,:,1,Y==-1);
    XmovB=X(:,:,2,Y==-1);
    hZZZ(:,:,1,si)=mean(XmovA,4);
    hZZZ(:,:,2,si)=mean(XmovB,4);
    X(:,:,1,Y==1)=XnomovA;
    X(:,:,2,Y==1)=XnomovB;
    genclsfr=zfull;
    W=genclsfr.prep(end).info.res.opt.soln{2}(1:end-1);
    % W(abs(W)<10)=0;
    clsfr.W=reshape(W,size(X,1),5,2);
    clsfr.b=genclsfr.prep(end).info.res.opt.soln{2}(end);
    clsfr.dim=4;
    %%
    %   A=clsfr.W(:,:,1);B=clsfr.W(:,:,2);
    %   A(abs(A)<.5)=0;
    %   B(abs(B)<.5)=0;
    %   clsfr.W(:,:,1)=A;clsfr.W(:,:,2)=B;
    %%
    %  clsfr.W([1 3 5 8],:,1)=0;
    %  clsfr.W([1 3 5 8],:,2)=0;
    %  clsfr.W(find(clsfr.W(:,2,1)<0),2,1)=0;
    %  clsfr.W(find(clsfr.W(:,3,2)>0),3,2)=0;
    %  clsfr.W(find(clsfr.W(:,4,2)>0),4,2)=0;
    [f]=applyLinearClassifier(X,clsfr);   
    
    fp=f(Y<0)+fi{si}(:,1);
    fn=f(Y>0)+fi{si}(:,2);
    
  
    Fp{si}=fp*0.5;
    Fn{si}=fn*0.5;
    neg_sel=0;pos_sel=0;
    %if (si==2 )
    pos_sel=Csamp+1:144;
    neg_sel=Csamp+1:144;
%          Fp{si}=fp(pos_sel);
%          Fn{si}=fn(pos_sel);
    % end
    fp=fp(pos_sel);
    fn=fn(pos_sel);
    r2_ad(si,:)= [ sum(fp<0)/numel(fp) sum(fn>=0)/numel(fn) (sum(fp<0)/numel(fp)+sum(fn>=0)/numel(fn))/2];
   
    f(Y<0)=f(Y<0)+fi{si}(:,1);
    f(Y>0)=f(Y>0)+fi{si}(:,2);
%       out{si}=dec_methods_f(f*.5,Y,'all',-1,'sav',mt2,mn2,pos_sel,neg_sel);
%       out_switch{si}=dec_methods_f(f*.5,Y,9,-1,'sav_switch',mt2,mn2,pos_sel,neg_sel);
%       out_nrow{si}=dec_methods_f(f*.5,Y,'all',-1,'nrow',mt2,mn2,pos_sel,neg_sel);
%       out_nswitch{si}=dec_methods_f(f*.5,Y,9,-1,'nrow_switch',mt2,mn2,pos_sel,neg_sel);
    %out_trans{si}=dec_methods_f(f,Y,'all',-1,'sav_trans',mt2,mn2,pos_sel,neg_sel);
    
end

%    persubject

