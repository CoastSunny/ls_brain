
voters=15;
for si=1:numel(subj)
    eval(['F=' subj{si} '_F;'])
    eval(['labels=' subj{si} 'labels;'])
    eval(['f=' subj{si} 'fsperf.fold.f;'])
    outf=ensemble_methods(f,labels,1);
    TPR3(si)=outf.tpr;
    FPR3(si)=outf.fpr;
    fpp_idx=(labels==1 & outf.decision==1);
    fpn_idx=(labels==-1 & outf.decision==1);
    outFp=ensemble_methods(F(fpp_idx,:),labels(fpp_idx),voters);
    outFn=ensemble_methods(F(fpn_idx,:),labels(fpn_idx),voters);
    TPR1(si)=outFp.tpr;
    FPR1(si)=outFn.fpr;
    out=ensemble_methods(F,labels,voters);
    TPR2(si)=out.tpr;
    FPR2(si)=out.fpr;
end

Res=[TPR1' FPR1' TPR2' FPR2' TPR3' FPR3']