bciroot = {'/media/LoukStorage/Raw' '/Users/louk/Data/Raw/'}
expt    = 'OR_real_experiment';

subjects= { 'S1' 'S2' 'S3' 'S5' 'S4'}; 
% sessions = {{''}};
labels  ={'trn'}; %condition{

global bciroot;

%condition{
timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};

%clear out2 out2_trans
for si=[1 2 3 4 5]
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
    %z=jf_reject(z,'dim','epoch','idx',[z.di(3).extra.src]==5);
    
    % run the pre-processing (file attached)
    z=preproc_anthesia(z);
    z=jf_addClassInfo(z,...
        'spType',{...%{{'rest3' 'rest4' 'rest5'} {'rh3' 'rh4' 'rh5'}}...
        {{'post_NO'} {'post_AM'}}},'summary','rest vs move');
    
    % setup 1st block only folding. This was used to simulate a 'preoperative
    % calibration session' or simply an online study in general. So, the first
    % block of data is used for training of the classifier and the remaining
    % blocks are used for testing.
    z=jf_retain(z,'dim','ch','idx',[z.di(1).extra.iseeg],'summary','eeg-only');
    z=jf_retain(z,'dim','time','range','between','vals',[-1000 6000]);
%% FFT FILTER
%         freqband=[8 24];
%         fs=128;
%         len=size(z.X,2);
%         filt=mkFilter(freqband,floor(len/2),fs/len);
%         z.X=fftfilter(z.X,filt,[0 len],2,1);    
%% whitening/normalisation
z.X=ls_whiten(z.X,method,L,trdim,T,time_window);
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
YYY2(:,:,1,si)=mean(XnomovA,4);
YYY2(:,:,2,si)=mean(XnomovB,4);
XmovA=X(:,:,1,Y==-1);
XmovB=X(:,:,2,Y==-1);
ZZZ2(:,:,1,si)=mean(XmovA,4);
ZZZ2(:,:,2,si)=mean(XmovB,4);
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

fp=f(Y<0);
fn=f(Y>0);
Fp2{si}=fp;
Fn2{si}=fn;
%TPs are negative, TNs are positive.... I know...
r2(si,:)= [ sum(fp<0)/numel(fp) sum(fn>=0)/numel(fn) (sum(fp<0)/numel(fp)+sum(fn>=0)/numel(fn))/2];
neg_sel=0;pos_sel=0;

out2{si}=dec_methods_f(f,Y,'all',-1,'sav',mt2,mn2,pos_sel,neg_sel);
out2_nrow{si}=dec_methods_f(f,Y,'all',-1,'nrow',mt2,mn2,pos_sel,neg_sel);
%out2_trans{si}=dec_methods_f(f,Y,'all',-1,'sav_trans',mt2,mn2);

end

%    persubject

