
fprs=0:0.1:1;
rr=[];
for gri=1:numel(fprs)
    fpr_target=fprs(gri);
    cross_combine_fNLclassifiers
    rr(gri,:)=mean(rfSS);
end