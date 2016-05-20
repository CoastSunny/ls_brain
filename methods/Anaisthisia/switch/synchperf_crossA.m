




for si=1:numel(out)%[1 2 3 4 5]% 6:10]%[9 5 1 2 3 4 6 7 8 10]
    si;
   
    idx_fpr=find(out{si}.out.bias<=-bias_savA(si));    
 
    amfpr(si)=out{si}.out.fpr.sav(m2,idx_fpr(end)-cheating_bias);
    amtpr(si)=out{si}.out.tpr.sav(m2,idx_fpr(end)-cheating_bias);
  
    
end

