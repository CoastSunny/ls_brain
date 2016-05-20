Ns=size(fXs,1);Ni=size(fXi,1);
trn=1:round(size(fXi,2));
rtrn=1:round(size(frXi,2));
% trn=1:30;
%tst=(round(size(Xi,2)/2)+1):size(Xi,2);
% KSRDL
optionKSRDL.lambda=0.15;
optionKSRDL.SCMethod='nnqpAS'; % can be nnqpAS, l1qpAS, nnqpIP, l1qpIP, l1qpPX, nnqpSMO, l1qpSMO
optionKSRDL.dicPrior='uniform'; % can be uniform, Gaussian
optionKSRDL.kernel='linear';
optionKSRDL.param=2^0;
optionKSRDL.iter=20;
optionKSRDL.dis=0;
optionKSRDL.residual=1e-4;
optionKSRDL.tof=1e-4;

s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);
k=30;
%

% 
% % fX=[fXs;fXi];
% % Hc=computeKernelMatrix(fX(:,trn),fX(:,trn),optionKSRDL);
% % [DtDc,Yc,Dc,pinvYc]=KSRDL(fX(:,trn),Hc,k,optionKSRDL);
% % Ds=Dc(1:size(fXs,1),:);
% % Ds=normc(Ds);
% % disp(['The final residual2 is ',num2str(norm(fXs-Ds*Yc,'fro'))]);
% 
Hs=computeKernelMatrix(fXs(:,trn),fXs(:,trn),optionKSRDL);
[DtDs,Ys,Ds,pinvYs]=KSRDL(fXs(:,trn),Hs,k,optionKSRDL);

Hrs=computeKernelMatrix(frXs(:,rtrn),frXs(:,rtrn),optionKSRDL);
[DtDrs,Yrs,Drs,pinvYrs]=KSRDL(frXs(:,rtrn),Hrs,k,optionKSRDL);

Dsrs=[Ds Drs];Dsrs=normc(Dsrs);
%% coupled
fXsf=[fXs;fXi];
Hs=computeKernelMatrix(fXsf(:,trn),fXsf(:,trn),optionKSRDL);
[DtDsf,Ysf,Dsf,pinvYsf]=KSRDL(fXsf(:,trn),Hs,k,optionKSRDL);

frXsf=[frXs;frXi];
Hrs=computeKernelMatrix(frXsf(:,rtrn),frXsf(:,rtrn),optionKSRDL);
[DtDrsf,Yrsf,Drsf,pinvYrsf]=KSRDL(frXsf(:,rtrn),Hrs,k,optionKSRDL);

Dsrsf=[Dsf Drsf];Dsrsf=Dsrsf(1:size(fXs,1),:);Dsrsf=normc(Dsrsf);
Disrsf=[Dsf Drsf];Disrsf=Disrsf((size(fXs,1)+1):end,:);Disrsf=normc(Disrsf);
Cis=Disrsf*pinv(Dsrsf);
%% not coupled
Hi=computeKernelMatrix(fXi(:,trn),fXi(:,trn),optionKSRDL);
[DtDi,Yi,Di,pinvYi]=KSRDL(fXi(:,trn),Hi,k,optionKSRDL);

Hri=computeKernelMatrix(frXi(:,rtrn),frXi(:,rtrn),optionKSRDL);
[DtDri,Yri,Dri,pinvYri]=KSRDL(frXi(:,rtrn),Hri,k,optionKSRDL);

Diri=[Di Dri];Diri=normc(Diri);




