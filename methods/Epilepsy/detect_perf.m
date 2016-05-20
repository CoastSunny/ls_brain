TPR=[];FP=[];
for si=itest
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
    spikes=spikes(:,spikes(2,:)>6);
    SP=round(spikes(1,:)*200);
    eval(['f=' subj{si} 'sRw;']);
    Ff{si}=f;
    try
    Fs{si}=f(SP);
    catch err
        SP(end)=[];
        Fs{si}=f(SP);
    end
    f=filter(ones(1,1)/1,1,f);
    p=1./(1+exp(-f));
    %th=0.5;
    pp=find(p>th);
    ppdiff=diff(pp);
    ppdiff=[-1 ppdiff];
    P{si}=p;

    %figure,plot(X')
%    
    d = [0,diff(pp) < 2];
    subs = cumsum([diff(d) == 1, 0]).*(d | [0, diff(d) == -1]) + 1;
    temp = accumarray(subs', pp', [], @(x) fma(x,p));
    final = floor(temp(2:end));
    decision = [];
    countp=1;
    countn=1;
    tpX=[];tpfX=[];dp=[];drp=[];
    tprX=[];tpfrX=[];sps=[];
    final(final<l)=[];
    %final=pp;
    for i=1:numel(final)
        
%        line('XData', [pp(i) pp(i)], 'YData', [-200 200], 'LineStyle', '-');
       try
           bsEEG=mean(X(:,final(i)-2*pre_samples-1*post_samples-1:final(i)-1*pre_samples-1),2);
       catch err
           bsEEG=0;
       end
        sY=repop(X(:,final(i)-pre_samples:final(i)+post_samples),'-',bsEEG);
%         sY=ls_whiten(sY,5,0);
        sY=detrend(sY,2);
        fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%         
%         cx(i,:)=vec(sY);
%         fcx(i,:)=vec(fsY);
        
        dd=[final(i)-4:final(i)+4];
        if ~isempty(intersect(dd,SP))
            [sp_val sp_idx]=intersect(SP,dd);
           % SP(sp_idx)=[];
            sps(end+1)=sp_val(end);
            decision(i)=1;
            tpX(:,:,countp)=sY;
            tpfX(:,:,:,countp)=fsY;
            dp(countp)=p(final(i));
            countp=countp+1;
            
        else
            decision(i)=-1;
            tprX(:,:,countn)=sY;
            tpfrX(:,:,:,countn)=fsY;
            drp(countn)=p(final(i));
            countn=countn+1;
        end
    end
%     cx=ls_whiten(cx,6,0);
    TPX{si}=tpX;
    TPRX{si}=tprX;
    TPfX{si}=tpfX;
    TPfRX{si}=tpfrX;
    DP{si}=dp;
    DRP{si}=drp;
    
    %TPR(si,:)=[sum(decision==1)/numel(SP) sum(decision==1)];
    TPR(si,:)=[numel(unique(sps))/numel(SP)];
    
    FP(si)=sum(decision==-1);
    CX{si}=fcx;
    clusters=2;
    %CX{si}=CX{si}(~idOutliers(CX{si},1,2),:);
%     [idx c]=kmeans(CX{si},clusters,'Distance','sqEuclidean','Replicates',3);
%     figure,
%     subplot(1,clusters+2,1)
%     eval(['sEEG=' subj{si} '_sEEG;']);
%     plot(mean(sEEG,3)'),title(subj{si})
%     for i=1:clusters
%         subplot(1,clusters+2,i+1)
%         v=reshape(mean(cx(idx==i,:),1),16,65);
%         plot(v'),title([ subj{si} 'cluster ' num2str(i)])
%     end
%     subplot(1,clusters+2,i+2)
%     plot(1/(size(TPX{si},3)+size(TPRX{si},3))*(mean(TPX{si},3)*size(TPX{si},3)+mean(TPRX{si},3)*size(TPRX{si},3))')
% %     figure,subplot(1,4,1)
% %     eval(['xx=' subj{si} '_sEEG;']);
% %     plot(mean(xx,3)')
% %     subplot(1,4,2)
% %     plot(mean(TPX{si},3)')
% %     subplot(1,4,3)
% %     plot(mean(TPRX{si},3)')   
% %     subplot(1,4,4)
% %     plot(1/(size(TPX{si},3)+size(TPRX{si},3))*(mean(TPX{si},3)*size(TPX{si},3)+mean(TPRX{si},3)*size(TPRX{si},3))')
% % %     
count=0;
frsY=[];
[ps pi]=sort(p);
%NSP=find(p<0.5);
NSP=pi(1:round(size(p,2)/4));

while count<1000
 
    idx=datasample(NSP,1);
    if (idx<2*(pre_samples+post_samples+2)); continue; end;if (idx>size(X,2)-post_samples-1); continue; end;
    idx_set=idx-1*pre_samples:idx+1*post_samples;
%     if ( sum(ismember(idx_set,SP)) > 0 )
%         continue;
%     end
    idx_set=idx-pre_samples:idx+post_samples;
    count=count+1;    
    try
    bsEEG=mean(X(:,idx_set-post_samples-2*pre_samples-1),2);
    catch err
        bsEEG=0;
    end
    
    rsY(:,:,count)=repop(X(:,idx_set),'-',bsEEG);

    [dummy1 idx2remove]=intersect(NSP,idx_set);
    NSP(idx2remove)=[];
    
end

% RX{si}=detrend(ls_whiten(rsY,5,0),2);
RX{si}=detrend((rsY),2);


fRX{si}=spectrogram(RX{si},2,'fs',fs,'width_ms',width_ms,'overlap',overlap);

end


