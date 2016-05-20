

for si=1:numel(out_nrow)        
  
    idx_fpr=find(out_nrow{si}.out.bias<=-bias_nrowC(si));
    if empirical==1
        idx_fpr=find(out2_nrow{si}.out.fpr.nrow(m2,:)<=fpr_target);
    end
    
    
    amfpr2(si)=out2_nrow{si}.out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr2(si)=out2_nrow{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
 
    amfpr(si)=out_nrow{si}.out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr(si)=out_nrow{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr_nswitch{si}=cell2mat(out_nswitch{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias,:));
   
    tpr=[squeeze(amtpr_nswitch{si})' repmat(amtpr(si),1,173-numel(amtpr_nswitch{si}))];
    P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
    if sum(P)>0.99
    nTTD(si)=sum(P.*tau);
    else
        nTTD(si)=inf;
    end
    nsTTD(si)=sqrt(sum( (tau-TTD(si)).^2.*P ));
     
end


