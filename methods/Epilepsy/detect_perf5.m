TPR=[];FP=[];Pspec_pred = []; Pspec_vis=[];
pre_samples=100;
post_samples=100;
for si=itest
    cx=[];fcx=[];
    %fprintf(num2str(si))
    try cd D:\Raw\Epilepsy
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
    X=X(1:32,:);
    X=repop(X,'-',mean(X([20 21],:),1));
%     X = repop(X,'-',mean(X,1));
%     X=X(iall(:,si),:);
    X(:,end+1:end+200)=0;
    % spike indices 1-s
    addpath([home '/Dropbox/Spikes/'])
    load([subj{si} 'data'])
   
    spikes=spikes(:,spikes(2,:)>4);
%     if si==14
%         spikes(3,size(spikes,2))=2;
%     end
    SP=round(spikes(1,:)*200);
    eval(['f=' subj{si} 'sRw;']);
    f=f;%-mean(f);
    f(end+1:end+50)=0;
    Ff{si}=f;
    try
    Fs{si}=f(SP);
    catch err
        SP(end)=[];
        Fs{si}=f(SP);
    end
    %f=filtfilt(ones(1,1)/1,1,f);
    p=1./(1+exp(-f));

   % th=mean(p)*2;
   % tmp=find(p>0.7*max(p));
   % pp=p(tmp);
   %pp=find(p>th);
   % ppdiff=diff(pp);
   % ppdiff=[-1 ppdiff];
    
    P{si}=p;
    [m im]=sort(p);
    ii=sort(im(end-thth:end));
    pp=ii;
    %figure,plot(X')
   
    d = [0,diff(pp) < 6];
    subs = cumsum([diff(d) == 1, 0]).*(d | [0, diff(d) == -1]) + 1;
    temp = accumarray(subs', pp', [], @(x) fma(x,p));
    final = floor(temp(2:end));
    
    decision = []; pdecision=[]; vdecision=[];        
    countp=1;
    countn=1;
    tpX=[];tpfX=[];dp=[];drp=[];
    tprX=[];tpfrX=[];fsp=[];fnsp=[];
    
    for i=3:numel(final)
        
        bsEEG=mean(X(:,final(i)-2*pre_samples-1*post_samples-1:final(i)-1*pre_samples-1),2);
        sY=repop(X(:,final(i)-pre_samples:final(i)+post_samples),'-',bsEEG);
        %sY=ls_whiten(sY,5,0);
        sY=detrend(sY,2);
      %  fsY=mean(spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap),3);
        fsY=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
        
        cx(i,:)=vec(sY);
        fcx(i,:)=vec(fsY);        
        dd=[final(i)-8:final(i)+8];
        
        if ~isempty(intersect(dd,SP))
            
            decision(i)=1;
            [sp sp_idx]=intersect(SP,dd);
            pdecision(i)=spikes(2,sp_idx(1));
            vdecision(i)=spikes(3,sp_idx(1));
            tpX(:,:,countp)=sY;
            tpfX(:,:,:,countp)=fsY;
            dp(countp)=p(final(i));
%             fsp(countp,:)=f(final(i)-32:final(i)+32);
            countp=countp+1;
                        
        else
            
            decision(i)=-1;
            tprX(:,:,countn)=sY;
            tpfrX(:,:,:,countn)=fsY;
            pdecision(i)=0;
            vdecision(i)=0;
            drp(countn)=p(final(i));
%             fnsp(countn,:)=f(final(i)-32:final(i)+32);
            countn=countn+1;
            
        end
    end
%     cx=ls_whiten(cx,6,0);
    pD{si}=pdecision;
    vD{si}=vdecision;
    nV(si)=sum(spikes(3,:)==3);
    nnV(si)=sum(spikes(3,:)==2);
    TPX{si}=tpX;
    TPRX{si}=tprX;
    TPfX{si}=tpfX;
    TPfRX{si}=tpfrX;
    DP{si}=dp;
    DRP{si}=drp;
    TPR(si,:)=[sum(decision==1)/numel(SP) sum(decision==1) sum(vdecision==4)/sum(spikes(3,:)==4)];
    FSP{si}=fsp;FNSP{si}=fnsp;
    FP(si)=sum(decision==-1);
   
    for pidx=5:10
        if sum(spikes(2,:)==pidx)>0            
            Pspec_pred(si,pidx)=sum(pdecision==pidx)/sum(spikes(2,:)==pidx);
            Pspec_vis(si,pidx)=sum(pdecision==pidx & vdecision==3)/sum(spikes(2,:)==pidx);
            Pspec_vis2(si,pidx)=sum(pdecision==pidx & (vdecision==3 | vdecision==4))/sum(spikes(2,:)==pidx & (spikes(3,:)==3 | spikes(3,:)==4));
            Pspec_vis3(si,pidx)=sum(pdecision==pidx & vdecision==3)/sum(spikes(2,:)==pidx & spikes(3,:)==3);
            Pspec_vis4(si,pidx)=sum(pdecision==pidx & vdecision==4)/sum(spikes(2,:)==pidx & spikes(3,:)==4);
            Pspec_nvis(si,pidx)=sum(pdecision==pidx & vdecision==2)/sum(spikes(2,:)==pidx & spikes(3,:)==2);
            Pspec_vis3(si,pidx)=sum(pdecision==pidx & vdecision==3)/sum(spikes(2,:)==pidx);
            Pspec_nvis2(si,pidx)=sum(pdecision==pidx& vdecision==2)/sum(spikes(2,:)==pidx);
        else 
            Pspec_pred(si,pidx)=nan;
            Pspec_vis(si,pidx)=nan;
            Pspec_vis2(si,pidx)=nan;
            Pspec_nvis(si,pidx)=nan;
            Pspec_vis3(si,pidx)=nan;
            Pspec_nvis2(si,pidx)=nan;
        end
    end
    
%     CX{si}=fcx;
%     clusters=2;
%     CX{si}=CX{si}(~idOutliers(CX{si},1,2),:);
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
% % 
% % count=0;
% % rsY=[];frsY=[];
% % [ps pi]=sort(p);
% % % NSP=find(p<0.5);
% % NSP=pi(1:round(size(p,2)/1));
% % 
% % while count<1000
% %  
% %     idx=datasample(NSP,1);
% %     if (idx<2*(pre_samples+post_samples+2)); continue; end;if (idx>size(X,2)-post_samples-1); continue; end;
% %     idx_set=idx-1*pre_samples:idx+1*post_samples;
% % %     if ( sum(ismember(idx_set,SP)) > 0 )
% % %         continue;
% % %     end
% %     idx_set=idx-pre_samples:idx+post_samples;
% %     count=count+1;    
% %     
% %     bsEEG=mean(X(:,idx_set-post_samples-pre_samples-1),2);
% %     rsY(:,:,count)=repop(X(:,idx_set),'-',bsEEG);
% % 
% %     [dummy1 idx2remove]=intersect(NSP,idx_set);
% %     NSP(idx2remove)=[];
% %     
% % end
% % 
% % % RX{si}=detrend(ls_whiten(rsY,5,0),2);
% % RX{si}=detrend(rsY,2);
% % 
% % % fRX{si}=mean(spectrogram(RX{si},2,'fs',fs,'width_ms',width_ms,'overlap',overlap),3);
% % fRX{si}=spectrogram(RX{si},2,'fs',fs,'width_ms',width_ms,'overlap',overlap);


end


