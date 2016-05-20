clear TPR TPR_ksav TPR_knrow
for si=1:10
    
    tmp=checkmethod(-mean(FpA2{si}),std(FpA2{si}),-mean(FnA2{si}),std(FnA2{si}),55,0.017,2);
    TPR(si)=tmp.tpr_sav;
    TPR_ksav(si,:)=tmp.tpr_ksav;
    TPR_knrow(si,:)=tmp.tpr_knrow;
    
end

TPR