



for si=1:numel(out_nrow)%[1 2 3 4 5]% 6:10]%[9 5 1 2 3 4 6 7 8 10]
  
            
    idx_fpr=find(out_nrow{si}.out.bias<=-bias_nrowA(si));
   
    amfpr(si)=out_nrow{si}.out.fpr.nrow(m2,idx_fpr(end)-cheating_bias);
    amtpr(si)=out_nrow{si}.out.tpr.nrow(m2,idx_fpr(end)-cheating_bias);
       
     
end

