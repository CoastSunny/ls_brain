TPR=[];FP=[];
for si=1:numel(subj)
    
    cx=[];fcx=[];
    %fprintf(num2str(si))
    try cd D:\Raw\Epilepsy
    catch err
        cd([home '/Documents/Epilepsy/'])
    end
    load(subj{ci})
    eval(['X=' subj{si} ';'])
    %     freqband=[1 95];
    fs=200;
    fma=@fmax;
    len=size(X,2);
    filt=mkFilter(freqband,floor(len/2),fs/len);
    X=fftfilter(X,filt,[0 len],2,1);
    X=X(sEEG_idx,:);
    X = repop(X,'-',mean(X,1));
    X=X(iall(:,si),:);
    
%     addpath ~/Dropbox/Spikes/
    cd([home '/Dropbox/Spikes/'])   
    load([subj{si} 'data'])
    spikes=spikes(:,spikes(2,:)>4);
    SP=round(spikes(1,:)*200);
    oSP=SP;
    eval(['f=' subj{si} 'sRw;']);
   
    %f=filtfilt(ones(1,1)/1,1,f);
    p=1./(1+exp(-f));
    th=0.6;
    p_th=p(p>th);
    idx_th=find(p>th);
    tpr_offset=8;
    pdec=[];ndec=[];decision=[];
    for i=1:numel(idx_th)
%         try
%         bsEEG=mean(X(:,idx_th(i)-2*pre_samples-post_samples-1:idx_th(i)-pre_samples-1),2);
%         catch err
%             bsEEG=0;
%         end
%         sX(:,:,i)=repop(X(:,idx_th(i)-pre_samples:idx_th(i)+post_samples),'-',bsEEG);
        idx_th_lf=idx_th(i)*lf;
        if intersect(idx_th_lf-tpr_offset:idx_th_lf+tpr_offset,SP)
            
            [tmp idx]=intersect(SP,idx_th_lf-tpr_offset:idx_th_lf+tpr_offset);
            SP(idx)=[];
            decision(i)=1;  
            pdec(end+1)=p(idx_th(i));
            
        else
            
            decision(i)=-1;
            ndec(end+1)=p(idx_th(i));
            
        end
        
    end
    
    TPR(si,:)=[sum(decision==1)/numel(oSP) sum(decision==1)/numel(idx_th) sum(decision==1) sum(decision==-1)];
    TPD{si}=decision;
    Peas{si}={pdec ndec};
%    TPX{si}=sX;
%    TPfX{si}=spectrogram(sX,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%     
%     count=0;
%     [ps pi]=sort(p);    
%     NSP=pi(1:round(size(p,2)/4));
%     
%     while count<1000
%         
%         idx=datasample(NSP,1);
%         if (idx<2*(pre_samples+post_samples+2)); continue; end;if (idx>size(X,2)-post_samples-1); continue; end;
%         idx_set=idx-1*pre_samples:idx+1*post_samples;
%         if ( sum(ismember(idx_set,SP)) > 0 )
%             continue;
%         end
%         idx_set=idx-pre_samples:idx+post_samples;
%         count=count+1;
%         
%         bsEEG=mean(X(:,idx_set-post_samples-pre_samples-1),2);
%         %bsEEG=0;
%         rsY(:,:,count)=repop(X(:,idx_set),'-',bsEEG);
%         
%         [dummy1 idx2remove]=intersect(NSP,idx_set);
%         NSP(idx2remove)=[];
%         
%     end
%     
%     % RX{si}=detrend(ls_whiten(rsY,5,0),2);
%     RX{si}=detrend((rsY),2);
%     fRX{si}=spectrogram(RX{si},2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%     
end


