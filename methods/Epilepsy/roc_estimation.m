
TP_ROC=[];FP_ROC=[];
for si=itest
    idxp=[];idxn=[];idxp2=[];
       
    addpath([home '/Dropbox/Spikes/'])
    load([subj{si} 'data'])   
    spikes=spikes(:,spikes(2,:)>4);

    SP=round(spikes(1,:)*200);
    eval(['f=' subj{si} 'sRw;']);        
    p=1./(1+exp(-f));
    for i=1:numel(SP)
        
        if(SP(i)<numel(f))
        idxp(i,:)=SP(i)-8:SP(i)-8;             
        end
        
    end 
    
    idxp=unique(idxp(:)); 
    idxn=1:numel(f);
    idxn=setdiff(idxn,idxp);
     for i=1:numel(SP)
        
        if(SP(i)<numel(f))
        idxp2(i,:)=SP(i):SP(i);             
        end
        
    end 
    roc_thr=0:0.05:1;
    for roc_idx=1:numel(roc_thr)
        tp_r(roc_idx)=sum(p(idxp2)>roc_thr(roc_idx))/numel(p(idxp2));
        fp_r(roc_idx)=sum(p(idxn)>roc_thr(roc_idx))/numel(p(idxn));
    end
    TP_ROC(si,:)=tp_r;
    FP_ROC(si,:)=fp_r;
end


