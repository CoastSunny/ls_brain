for jjj=1:10
    sweep_SI
    thth=1999;
    detect_perf5
    
    aperm{jjj}=nanmean(Pspec_pred);
    bperm{jjj}=nanmean(Pspec_vis);
    cperm{jjj}=nanmean(Pspec_vis2);
    dperm{jjj}=nanmean(Pspec_nvis);
    sap{jjj}=nanstd(Pspec_pred);
    sbp{jjj}=nanstd(Pspec_vis);
    scp{jjj}=nanstd(Pspec_vis2);
    sdp{jjj}=nanstd(Pspec_nvis);
    TPRp{jjj}=TPR(:,1);
    TPRp2{jjj}=TPR(:,2);
    FPp{jjj}=FP;
    TPXp{jjj}=TPX;TPRXp{jjj}=TPRX;
    vDp{jjj}=vD;pDp{jjj}=pD;NVp{jjj}=nV;NNVp{jjj}=nnV;DPp{jjj}=DP;DRPp{jjj}=DRP;
    
end