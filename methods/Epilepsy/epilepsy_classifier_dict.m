
losstype='bal';
kerType='linear';
par1=1;par2=[];
Cs=5.^[3:-1:-3];
nfolds=4;

trlabels=[ones(1,size(Xs(:,ctrn),2)) -ones(1,size(rXs(:,crtrn),2))];
tstlabels=[ones(1,size(Xs(:,tst),2)) -ones(1,size(rXs(:,rtst),2))];

sD=cat(2,Xs(:,ctrn),rXs(:,crtrn));
[sclsfr, sres]=cvtrainKernelClassifier(sD,trlabels,Cs,nfolds,'dim',2,'par1',par1,'par2',par2,'kerType',kerType);%,options);
sDtst=cat(2,Xs(:,tst),rXs(:,rtst));
[sf]=applyLinearClassifier(sDtst,sclsfr);
sperf=fperf(sf,tstlabels);

% dD=cat(2,Ytst,rYtst);
% dD=cat(2,Xs(:,ctrn)-Dsr*Ytst_pre,rXs(:,crtrn)-Dsr*rYtst_pre);
dD=cat(2,Ytst,rYtst);
[dclsfr, dres]=cvtrainKernelClassifier(dD,trlabels,Cs,nfolds,'dim',2,'par1',par1,'par2',par2,'kerType',kerType);%,options);
% dDtst=cat(2,Yout,rYout);
% dDtst=cat(2,Xs(:,tst)-Dsr*Yout_pre,rXs(:,rtst)-Dsr*rYout_pre);
dDtst=cat(2,Yout,rYout);
[df]=applyLinearClassifier(dDtst,dclsfr);
dperf=fperf(df,tstlabels);

[sperf.perf dperf.perf]







