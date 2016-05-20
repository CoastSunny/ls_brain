
itest=1:numel(subj);
pre_samples=32;
post_samples=32;
for si=1:numel(subj)
    
    fprintf(num2str(si))
    try cd D:\Raw\Epilepsy
    catch err
        cd ~/Documents/Epilepsy/
    end
    load(subj{si})
    eval(['X=' subj{si} ';'])
    % freqband=[1 95];
    fs=200;
    len=size(X,2);
    filt=mkFilter(freqband,floor(len/2),fs/len);
    X=fftfilter(X,filt,[0 len],2,1);
    X=repop(X,'-',mean(X([20 21],:),1));
    X=X(sEEG_idx,:);
    X = repop(X,'-',mean(X,1));
%     X=X(iall(:,si),:);
    Ww=[];
    W=[];
    clsfr=[];spMx=[1 -1];spKey=[1 -1];
    
   % classifiyall_cv_step2
    
    for ssi=itest
        %     for chtrn=1:16
        %         eval(['fsclsfr(ssi,chtrn)=' subj{ssi} 'SCfsclsfr{iall(chtrn,ssi)};'])
        %     end
        eval(['fsclsfr(ssi)=' subj{ssi} 'fsclsfr;']) %<<<<<<<<<-------------------------------------***!*!*!*!
    end
    
    % for chtrn=1:16
    for ssi=itest
        %         W(chtrn,:,:,ssi)=fsclsfr(ssi,chtrn).W;
        %         b(ssi,chtrn)=fsclsfr(ssi,chtrn).b;
        W(:,:,:,ssi)=fsclsfr(ssi).W(schannels,:,:,:);
        b(ssi)=fsclsfr(ssi).b;
    end
    % end
    sRw=[];
    l=pre_samples+post_samples+1;
  %  itrain=setdiff(itest,[si 1 5 6 8 9 10 13 16 19 20 21 25 26]);
    itrain=setdiff(itest,[si]);
  %  itrain=setdiff(itest,[si]);
    %     for chtrn=1:16
    %         Ww(chtrn,:,:)=mean(W(chtrn,:,:,itrain),4);
    %         bb(chtrn)=mean(b(itrain,chtrn));
    %         clsfr(chtrn).W=Ww(chtrn,:,:);
    %         clsfr(chtrn).b=bb(chtrn);
    %         clsfr(chtrn).dim=4;
    %         clsfr(chtrn).spKey=spKey;
    %         clsfr(chtrn).spMx=spMx;
    %     end
    
    Ww=mean(W(:,:,:,itrain),4);   
    Ww=randn(size(Ww));
    bb=mean(b(itrain));
    clsfr.W=Ww;
    clsfr.b=bb;
    clsfr.spKey=spKey;
    clsfr.spMx=spMx;
 
    for i=2*l+1:1:size(X,2)-l
        % tic
        dv_ch=[];
        bsEEG=mean(X(:,i-2*pre_samples-1*post_samples-1:i-1*pre_samples-1),2);
        sY=repop(X(:,i-pre_samples:i+post_samples),'-',bsEEG);
        sY=ls_whiten(sY,5,0);
        sY=detrend(sY,2);
        fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
        %         for chtrn=1:16
        %             %dv_ch(ssi,chtrn)=applyNonLinearClassifier(fsY(chtrn,:,:,:),fsclsfr(ssi,chtrn));
        %             dv_ch(chtrn)=applyLinearClassifier(fsY(chtrn,:,:,:),clsfr(chtrn));
        %         end
      
        dv=applyLinearClassifier(fsY,clsfr);
        sRw(i)=dv;
        %     iRw(i)=applyLinearClassifier(iY,iclsfr);
        %     fsRw(i)=applyLinearClassifier(fsY,fsclsfr);
        %     fiRw(i)=applyLinearClassifier(fiY,ficlsfr);
        %  toc
    end
    eval([subj{si} 'sRw=sRw;'])
end