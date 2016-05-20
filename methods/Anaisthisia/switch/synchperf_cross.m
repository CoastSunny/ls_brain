

for si=1:numel(out)
       
    idx_fpr=find(out{si}.out.bias<=-bias_savC(si));
    if empirical==1
         idx_fpr=find(out2{si}.out.fpr.sav(m2,:)<=fpr_target);
    end   
 
    amfpr2(si)=out2{si}.out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
    amtpr2(si)=out2{si}.out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
   
    amfpr(si)=out{si}.out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
    amtpr(si)=out{si}.out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
  
    amtpr_switch{si}=cell2mat(out_switch{si}.out.tpr.sav(m2,idx_fpr(end)-cheating_bias,:));

    tpr=[squeeze(amtpr_switch{si})' repmat(amtpr(si),1,173-numel(amtpr_switch{si}))];
    P=[tpr(1) tpr(2:end).*cumprod(1-tpr(1:end-1))];
    if sum(P)>0.99
    TTD(si)=sum(P.*tau);
    else
        TTD(si)=inf;
    end
    sTTD(si)=sqrt(sum( (tau-TTD(si)).^2.*P ));
         
    
end


