TPR=[];FP=[];Pspec_pred = []; Pspec_vis=[];

for si=itest
    cx=[];fcx=[];
  
    % spike indices 1-s
    addpath([home '/Dropbox/Spikes/'])
    load([subj{si} 'data'])
   
    spikes=spikes(:,spikes(2,:)>4);

    SP=round(spikes(1,:)*200);
    eval(['f=' subj{si} 'sRw;']);
      f(end+1:end+50)=0;

    p=1./(1+exp(-f));

    P{si}=p;
    [m im]=sort(p);
    ii=sort(im(end-thth:end));
    pp=ii;
    %figure,plot(X')
   
    d = [0,diff(pp) < 8];
    subs = cumsum([diff(d) == 1, 0]).*(d | [0, diff(d) == -1]) + 1;
    temp = accumarray(subs', pp', [], @(x) fma(x,p));
    final = floor(temp(2:end));
    
    decision = []; pdecision=[]; vdecision=[];        
    countp=1;
    countn=1;
       
    for i=1:numel(final)        
     
        dd=[final(i)-8:final(i)+8];
        
        if ~isempty(intersect(dd,SP))
            
            decision(i)=1;
            [sp sp_idx]=intersect(SP,dd);
            pdecision(i)=spikes(2,sp_idx(1));
            vdecision(i)=spikes(3,sp_idx(1));           
            dp(countp)=p(final(i));
            fsp(countp,:)=f(final(i)-32:final(i)+32);
            countp=countp+1;
                        
        else
            
            decision(i)=-1;          
            pdecision(i)=0;
            vdecision(i)=0;
            drp(countn)=p(final(i));
            fnsp(countn,:)=f(final(i)-32:final(i)+32);
            countn=countn+1;
            
        end
    end
%     cx=ls_whiten(cx,6,0);
    pD{si}=pdecision;
    vD{si}=vdecision;
    nV(si)=sum(spikes(3,:)==3);
    nnV(si)=sum(spikes(3,:)==2);
 
    DP{si}=dp;
    DRP{si}=drp;
    TPR(si,:)=[sum(decision==1)/numel(SP) sum(decision==1)];
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
    


end


