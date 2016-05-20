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
    p=1./(1+exp(-f));
    P{si}=p;
    %th=0.7;
    
    tdecision=[];
    offset=64;
    tpr_offset=8;
    tpsY=[];tpfsY=[];tprY=[];tpfrY=[];
    pdecision=[];
    for i=1:numel(SP)
        
        [tmp_pred tmp_idx]=max(p(SP(i)-tpr_offset:SP(i)+tpr_offset));
        if tmp_pred>th
            tdecision(i)=SP(i);
            pdecision(end+1)=tmp_pred;
        else
            tdecision(i)=0;
            
        end
        %bsEEG=mean(X(:,SP(i)-2*pre_samples-1*post_samples-1:SP(i)-1*pre_samples-1),2);
        
        try
            bsEEG=0;
            sY=repop(X(:,SP(i)-pre_samples:SP(i)+post_samples),'-',bsEEG);
            %  sY=ls_whiten(sY,5,0);
            sY=detrend(sY,2);
            fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
            tpsY(:,:,i)=sY;
            tpfsY(:,:,:,i)=fsY;
        catch err
        end
    end
    
    TPR(si,:)=[(numel(unique(tdecision))-1)/numel(oSP) sum(tdecision~=0)];
    PD{si}=pdecision;
    PSP{si}=p(SP);
    decision=[];pdec=[];ndec=[];
    for i=2:round((size(X,2)-l-offset)/offset)-2
        
        [tmp_pred tmp_idx]=max(p((i-1)*offset+offset+1-pre_samples:(i-1)*offset+offset+1+post_samples));
        pred_idx=tmp_idx+(i-1)*offset+offset-pre_samples;
        dd=(pred_idx-tpr_offset:pred_idx+tpr_offset);
        bsEEG=0;
        sY=repop(X(:,pred_idx-pre_samples:pred_idx+post_samples),'-',bsEEG);
        %  sY=ls_whiten(sY,5,0);
        sY=detrend(sY,2);
        fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
        tprY(:,:,i)=sY;
        tpfrY(:,:,:,i)=fsY;
        
        if p(pred_idx)>th
            if  ~isempty(intersect(dd,SP))
                [sp_val sp_idx]=intersect(SP,dd);
                SP(sp_idx)=[];
                decision(i)=1;
                pdec(end+1)=p(pred_idx);
                
            else
                %bsEEG=mean(X(:,pred_idx-2*pre_samples-1*post_samples-1:pred_idx-1*pre_samples-1),2);
                decision(i)=-1;
                ndec(end+1)=p(pred_idx);
            end
        else
            decision(i)=0;
        end
        
    end
    
    TPR2(si,:)=[sum(decision==1)/numel(oSP) sum(decision==1)];
    FP(si)=sum(decision==-1);
    Peas{si}={pdec ndec};
    TD{si}=tdecision;
    TRD{si}=decision;
    TPX{si}=tpsY;
    TPRX{si}=tprY;
    TPfX{si}=tpfsY;
    TPfRX{si}=tpfrY;
    
    count=0;
    frsY=[];rsY=[];
    [ps pi]=sort(p);
    % NSP=find(p<0.5);
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
        
        %bsEEG=mean(X(:,idx_set-post_samples-pre_samples-1),2);
        bsEEG=0;
        rsY(:,:,count)=repop(X(:,idx_set),'-',bsEEG);
        
        [dummy1 idx2remove]=intersect(NSP,idx_set);
        NSP(idx2remove)=[];
        
    end
    
    % RX{si}=detrend(ls_whiten(rsY,5,0),2);
    RX{si}=detrend((rsY),2);
    fRX{si}=spectrogram(RX{si},2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    
end


