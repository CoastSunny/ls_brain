
itest=1:18;
pre_samples=40;
post_samples=40;
X=tst.trial{1}(chtst,:);

%     chtst=[1 3 11 5 13 13 7 9 2 4 12 6 14 14 8 10 17 18 15 16];
    freqband=[1 45];
    fs=250;
    len=size(X,2);
    filt=mkFilter(freqband,floor(len/2),fs/len);
    X=fftfilter(X,filt,[0 len],2,1);  
    X = repop(X,'-',mean(X,1));
    Ww=[];
    W=[];
    clsfr=[];spMx=[1 -1];spKey=[1 -1];    
    for ssi=itest        
        eval(['fsclsfr(ssi)=' subj{ssi} 'fsclsfr;']) %<<<<<<<<<-------------------------------------***!*!*!*!
    end
       
    for ssi=itest
        W(:,:,:,ssi)=fsclsfr(ssi).W(schannels,:,:,:);
        b(ssi)=fsclsfr(ssi).b;
    end
    sRw=[];
    l=pre_samples+post_samples+1;
    Ww=mean(W,4);   
    bb=mean(b);
    clsfr.W=Ww;
    clsfr.b=bb;
    clsfr.spKey=spKey;
    clsfr.spMx=spMx;
 
    for i=2*l+1:1:size(X,2)-l
       
        dv_ch=[];
        bsEEG=mean(X(:,i-2*pre_samples-1*post_samples-1:i-1*pre_samples-1),2);
        sY=repop(X(:,i-pre_samples:i+post_samples),'-',bsEEG);
        sY=ls_whiten(sY,5,0);
        sY=detrend(sY,2);
        fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);        
        dv=applyLinearClassifier(fsY,clsfr);
        sRw(i)=dv;
        
    end
    