

global bciroot;
bciroot = {'/Users/louk/Data/Raw' 'D:/Raw' '/media/LoukStorage/Raw' '/media/louk/Storage/Raw'};
expt    = 'long_movements';

subjects= {'yvonne' 'jeroen' 'alex' 'hans' 'linsey' 'marjolein' 'fatma' 'jason' 'betul' 'rik'}; 
sessions= {{'20110719'} {'20110720'} {'20110721'} {'20111115'} {'20111121'} {'20111124'} {'20111212'} {'20111214'} {'20111216'} {'20111222'}}; % subj

%labels={'1sec'}; are set previously in the whichisbetter** scripts

%% the following section creates a zz structure containing data of all subjects
for si=5%1:numel(subjects)
    
    sessi=1; ci=1;
    subj=subjects{si};
    session=sessions{si}{sessi};
    label=labels{ci};
    z=jf_load(expt,subj,label,session,-1);
    z=preproc_anthesia(z);
    z.Ydi(1).name='epoch';
    z=jf_addClassInfo(z,...
        'spType',{{{nomove} {immove}}...
        {{nomove} {ammove}}},'summary','rest vs move');
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z=jf_retain(z,'dim','time','range','between','vals',[-1000 6000]);
    
    %% whitening/normalisation
    z.X=ls_whiten(z.X,method,L,T,time_window);%,freqband);
    %%
    z = jf_spectrogram(z,'width_ms',250,'log',0,'detrend',1);
    z = jf_retain(z,'dim','freq','range','between','vals',[8 24]);
    tD=n2d(z,'time',0,0); if ( tD==0 ) tD=n2d(z,'window'); end;
    w=mkFilter(size(z.X,tD),timeperiod,z.di(tD).vals);
    w=repop(w,'./',sum(w));
    z=jf_linMapDim(z,'dim',tD,'mx',w,'di',mkDimInfo(size(w,2),1,'movement periods',[],{'ERD' 'ERS'}));           
    zz(si)=z;
    
end

zall=jf_cat(zz,'dim','epoch');
clear z

%% this section iterates through subjects, trains a leave subject out classifier and saves some results
for si=1:numel(subjects)
    fprintf(num2str(si));
    z=zall;
    z.foldIdxs=zeros(size(z.Y,1),9);
    trnInd=floor([z.di(n2d(z,'epoch')).extra.src])~=si;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
    z.foldIdxs(trnInd,1:9)=gennFold(z.Y(trnInd,:),9); % 10-fold
    z.outfIdxs=zeros(size(z.Y,1),1); z.outfIdxs(trnInd)=-1; z.outfIdxs(~trnInd)=1; % outer-fold
    
    z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');
    
    if ( isfield(z,'outfIdxs') ) % compute outer fold performance info
        res = cvPerf([z.Y z.Y(:,1)],...
            [z.prep(end).info.res.opt.f z.prep(end).info.res.opt.f(:,2)],...
            [1 2 3],z.outfIdxs);
        res.di(2) = z.prep(end).info.res.di(2); % update subprob info
    end
    % print the resulting test set performances
    for spi=1:size(res.trnbin,n2d(res.di,'subProb')); % loop over sub-problems
        fprintf('(out/%2d*)\t%.2f/%.2f\n',spi,res.trnbin(:,spi),res.tstbin(:,spi));
    end
    
    fL=z.prep(end).info.res.opt.f(:,2);
    final{si}=fL(z.Y(:,2)~=0 & z.outfIdxs==1);
    FpL{si}=fL(z.Y(:,2)==-1 & z.outfIdxs==1);
    FnL{si}=fL(z.Y(:,2)==1 & z.outfIdxs==1);
    fp=FpL{si};
    fn=FnL{si};
    Res_in(si,:)=z.prep(end).info.res.tstbin(:,:,z.prep(end).info.res.opt.Ci);
    Res_out(si,:)=res.tstbin;
    r1(si,:)= [ sum(fp<0)/numel(fp) sum(fn>=0)/numel(fn) (sum(fp<0)/numel(fp)+sum(fn>=0)/numel(fn))/2];
    
    ztype{si}=z;
    
end

%% here a classifier is trained on all subjects
fprintf('full');
z=zall;
z.foldIdxs=zeros(size(z.Y,1),10);
trnInd=ones(1,size(z.Y,1))>0;% | [z.di(n2d(z,'epoch')).extra.src]==2;% | [z.di(n2d(z,'epoch')).extra.src]==3;
z.foldIdxs(trnInd,1:10)=gennFold(z.Y(trnInd,:),10); % 10-fold
z.outfIdxs=-ones(size(z.Y,1),1);  z.outfIdxs(~trnInd)=1; % outer-fold

z=jf_cvtrain(z,'mcPerf',0,'objFn','lr_cg');

zfull=z;




