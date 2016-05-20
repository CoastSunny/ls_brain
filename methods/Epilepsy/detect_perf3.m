TPR=[];FP=[];
for si=1:numel(subj)
    
    cx=[];fcx=[];
    %fprintf(num2str(si))
    try cd /media/louk/Storage/Raw/Epilepsy/
    catch err
        cd ~/Documents/Epilepsy/
    end
    load(subj{si})
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
    
    addpath ~/Dropbox/Spikes/
    load([subj{si} 'data'])
    spikes=spikes(:,spikes(2,:)>4);
    SP=round(spikes(1,:)*200);
    oSP=SP;
    eval(['f=' subj{si} 'sRw;']);
    Ff{si}=f;
    try
        Fs{si}=f(SP);
    catch err
        SP(end)=[];
        Fs{si}=f(SP);
    end
    %f=filtfilt(ones(1,1)/1,1,f);
    dwell_time=15;
    th=0.8;
    idx_det=vec_elements_product(f,dwell_time)>0;
    f_det=f.*idx_det;
    p_det=1./(1+exp(-f_det));
    idx_th=find(p_det>th);
    
    true_positive=0;
    sX=[];
    decision=[];
    
    for i=1:numel(idx_th)
    
        bsEEG=mean(X(:,idx_th(i)-post_samples-pre_samples-1),2);
        sX(:,:,i)=repop(X(:,idx_th(i)-pre_samples:idx_th(i)+post_samples),'-',bsEEG);
        
        if intersect(idx_th(i)-2:idx_th(i)+2,SP)
            
            tmp=intersect(idx_th(i)-2:idx_th(i)+2,SP);
            decision(i)=1;
            tmp2=find(SP==tmp);
            true_positives=SP(tmp2);
            
        else
            
            decision(i)=-1;
            
        end
        
    end
    
   TPD{si}=decision;
   TPX{si}=sX;
   TPfX{si}=spectrogram(sX,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    
    count=0;
    [ps pi]=sort(p);    
    NSP=pi(1:round(size(p,2)/4));
    
    while count<1000
        
        idx=datasample(NSP,1);
        if (idx<2*(pre_samples+post_samples+2)); continue; end;if (idx>size(X,2)-post_samples-1); continue; end;
        idx_set=idx-1*pre_samples:idx+1*post_samples;
        if ( sum(ismember(idx_set,SP)) > 0 )
            continue;
        end
        idx_set=idx-pre_samples:idx+post_samples;
        count=count+1;
        
        bsEEG=mean(X(:,idx_set-post_samples-pre_samples-1),2);
        %bsEEG=0;
        rsY(:,:,count)=repop(X(:,idx_set),'-',bsEEG);
        
        [dummy1 idx2remove]=intersect(NSP,idx_set);
        NSP(idx2remove)=[];
        
    end
    
    % RX{si}=detrend(ls_whiten(rsY,5,0),2);
    RX{si}=detrend((rsY),2);
    fRX{si}=spectrogram(RX{si},2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    
end


