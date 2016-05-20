
fl=pre_samples+post_samples+1;
sclsfr.dim=[];iclsfr.dim=[];fsclsfr.dim=[];ficlsfr.dim=[];ssclsfr.dim=[];
for i=2*l+1:1:size(X,2)-l
    %tic
    bsEEG=mean(X(sEEG_idx,i-2*pre_samples-1*post_samples-1:i-1*pre_samples-1),2);
    sY=repop(X(sEEG_idx,i-pre_samples:i+post_samples),'-',bsEEG);
    sY=ls_whiten(sY,5,0);        
    sY=detrend(sY,2);
    fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    sRw(i)=applyLinearClassifier(fsY,fsclsfr);
  %  iRw(i)=applyLinearClassifier(iY,iclsfr);
%     fsRw(i)=applyLinearClassifier(fsY,fsclsfr);
%     fiRw(i)=applyLinearClassifier(fiY,ficlsfr);
    %toc
end