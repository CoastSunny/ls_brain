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
timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};
labels={'3sec'};
nomove='NO3';
ammove='AM3';
global bciroot;
% N.B. add the directory where the BCI_Data is mounted to this list for the
% system to find the raw data files and the saved files,
% e.g. bciroot={bciroot{:} '/Volumes/BCI_Data/'};
%bciroot = '/Volumes/BCI_Data/';
bciroot = {'/Users/louk/Data/Raw' '~/Data/Raw' '/media/LoukStorage/Raw'};
%expt    = 'own_experiments/motor_imagery/movement_detection/long_movements/';
expt    = 'long_movements';

subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; % subj{
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj{ session{
% choose which condition to use: either '1sec', '3sec', '9sec' or 'async'
%labels  ={'3sec'}; %condition{
for si=1:numel(subjects)
    
    sessi=1; ci=1;
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    z=jf_load(expt,subj,label,session,-1);
    z=preproc_anthesia(z);
    z.Ydi(1).name='epoch';
    z=jf_addClassInfo(z,...
        'spType',{...
        {{nomove} {ammove}}},'summary','rest vs move');
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z=jf_retain(z,'dim','time','range','between','vals',[-1000 6000]);
    %% whitening/normalisation
    z.X=ls_whiten(z.X,method,L,trdim,T,time_window);
    %%   
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w));
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));
%     R=whiten(z.X,1,1,0,0,1); % symetric whiten
%     z.X=tprod(z.X,[-1 2 3],R,[1 -1]);

    zz(si)=z;
    
end
expt    = 'trial_based/offline';
%expt    = 'own_experiments/motor_imagery/movement_detection/trial_based/offline';
subjects= {'linsey' 'Jorgen' 'makiko' 'lucinda' 'jason' 'moniek' 'chris' 'nienke' 'yvonne' 'rutger'}; % subj{
sessions= {{'20110112'} {'20110114'} {'20110118'} {'20110120'} {'20110131'} {'20110323'} {'20110323'} {'20110330'} {'20110406'} {'20110413'}}; % subj{ session{
labels  ={'trn'}; 
for si=1:numel(subjects)
    
    sessi=1; ci=1;
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    z=jf_load(expt,subj,label,session,-1);
    z=jf_reject(z,'dim','epoch','idx',[z.di(3).extra.src]==5);
    z=preproc_anthesia(z);
    z.Ydi(1).name='epoch';
    z=jf_addClassInfo(z,...
                  'spType',{...%{{'rest3' 'rest4' 'rest5'} {'rh3' 'rh4' 'rh5'}}...
                    {{'rest3' 'rest4' 'rest5'} {'any3' 'any4' 'any5'}}},'summary','rest vs move'); 
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z=jf_retain(z,'dim','time','range','between','vals',[-1000 6000]);
    %% whitening/normalisation
    z.X=ls_whiten(z.X,method,L,trdim,T,time_window);
    %% 
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w));
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));
%     R=whiten(z.X,1,1,0,0,1); % symetric whiten
%     z.X=tprod(z.X,[-1 2 3],R,[1 -1]);

    zz(si+10)=z;
    
end


zall=jf_cat(zz,'dim','epoch');
clear z

for si=1:20
    fprintf(num2str(si));
    z=zall;
    z.foldIdxs=zeros(size(z.Y,1),10);
    trnInd=floor([z.di(n2d(z,'epoch')).extra.src])~=si;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
    z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold
    z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold
    
    %z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
    z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');
    
     if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
        res = cvPerf([z.Y ],...
            [z.prep(end).info.res.opt.f],...
            [1 2 3],z.outfIdxs);
        res.di(2) = z.prep(end).info.res.di(2); % update subprob info
    end
    % print the resulting test set performances
    for spi=1:size(res.trnbin,n2d(res.di,'subProb')); % loop over sub-problems
        fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,res.trnbin(:,spi),res.tstbin(:,spi));
    end   
    
    fB=z.prep(end).info.res.opt.f;
    
    FpB{si}=fB(z.Y==-1 & z.outfIdxs==1);
    FnB{si}=fB(z.Y==1 & z.outfIdxs==1);
    
    ResB_in(si,:)=z.prep(end).info.res.tstbin(:,:,z.prep(end).info.res.opt.Ci);
    ResB_out(si,:)=res.tstbin;
    ztypeb{si}=z;
    
end

    fprintf('full');
    z=zall;
    z.foldIdxs=zeros(size(z.Y,1),10);
    trnInd=ones(1,size(z.Y,1))>0;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
    z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold
    z.outfIdxs=-ones(size(z.Y,1),1);  z.outfIdxs(~trnInd)=1; % outer-fold
    
    %z=jf_cvtrain(jf_compKernel(z),'mcPerf',0);
    z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');        
    
    zfullb=z;
    genclsfrb=zfullb;
    clsfrb.W=reshape(genclsfrb.prep(end).info.res.opt.soln{1}(1:end-1),9,5,2);


 
