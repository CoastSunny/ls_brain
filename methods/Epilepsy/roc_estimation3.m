
TP_ROC=[];FP_ROC=[];tp_r=[];fp_r=[];
for si=itest
    idxp=[];idxn=[];idxp2=[];
    roc_thr=0.5:0.05:1;
    addpath([home '/Dropbox/Spikes/'])
    load([subj{si} 'data'])
    spikes=spikes(:,spikes(2,:)>4);
    
    SP=round(spikes(1,:)*200);
    eval(['f=' subj{si} 'sRw;']);
    p=1./(1+exp(-f));
    for i=1:numel(SP)        
        if(SP(i)<numel(f))
            idxp(i,:)=SP(i):SP(i);
        end        
    end
    for roc_idx=1:numel(roc_thr)
        tp_r(roc_idx)=sum(p(idxp)>roc_thr(roc_idx))/numel(p(idxp));
    end     
    idxp=[];
    for i=1:numel(SP)        
        if(SP(i)<numel(f))
            idxp(i,:)=SP(i)-16:SP(i)-16;
        end        
    end    
    idxp=unique(idxp(:));
    idxn=1:numel(f);
    idxn=setdiff(idxn,idxp);
    
    for roc_idx=1:numel(roc_thr)
        pp=find(p(idxn)>roc_thr(roc_idx));
        if (~isempty(pp))
        d = [0,diff(pp) < 4];
        subs = cumsum([diff(d) == 1, 0]).*(d | [0, diff(d) == -1]) + 1;
        temp = accumarray(subs', pp', [], @(x) fma(x,p));
        final = floor(temp(2:end));
        fp_r(roc_idx)=numel(final)/numel(idxn);
        else
            fp_r(roc_idx)=0;
        end
    end
    TP_ROC(si,:)=tp_r;
    FP_ROC(si,:)=fp_r;
end


