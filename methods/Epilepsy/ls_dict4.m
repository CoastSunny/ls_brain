time2=1:65;
Xi=Xi(:,:);rXi=rXi(:,:);Xs=Xs(:,:);rXs=rXs(:,:);
Xi=fXi(:,:);rXi=frXi(:,:);Xs=fXs(:,:);rXs=frXs(:,:);
Xi=normc(Xi);rXi=normc(rXi);Xs=normc(Xs);rXs=normc(rXs);
Ns=size(Xs,1);Ni=size(Xi,1);
nex=size(Xi,2);rnex=size(rXi,2);
dtrn=1:round(nex*1/3);
drtrn=1:round(nex*1/3);
ctrn=numel(dtrn)+1:round(2*nex/3);
crtrn=numel(drtrn)+1:round(2*rnex/3);
tst=ctrn(end)+1:nex;
rtst=crtrn(end)+1:rnex;
% KSRDL
optionKSRDL.lambda=0.1;
optionKSRDL.SCMethod='nnqpAS'; % can be nnqpAS, l1qpAS, nnqpIP, l1qpIP, l1qpPX, nnqpSMO, l1qpSMO
optionKSRDL.dicPrior='uniform'; % can be uniform, Gaussian
optionKSRDL.kerfnel='linear';
optionKSRDL.param=2^0;
optionKSRDL.iter=10;
optionKSRDL.dis=0;
optionKSRDL.residual=1e-4;
optionKSRDL.tof=1e-4;
% C=eye(size(Xs,1),size(Xi,1));
% S=randn(size(Xi,1),20);S=normc(S);
% as=full(sprand(size(S,2),size(Xi,2),0.3));
% N=-0.5+rand(size(Xs,1),20);N=normc(N);
% an=full(sprand(size(N,2),size(Xi,2),0.3));
% ran=full(sprand(size(N,2),size(rXi,2),0.3));
% Xi=S*as;Xi=normc(Xi);
% nn=5.1;
% Xs=C*S*as+nn*N*an;Xs=normc(Xs);
% rXs=N*ran;rXs=normc(rXs);
%% Learn rest data scalp Dictionary
k1=60;
s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);
rHs=computeKernelMatrix(rXs(:,drtrn),rXs(:,drtrn),optionKSRDL);
[rDtDs,rYs,rDs,pinvrYs]=KSRDL(rXs(:,drtrn),rHs,k1,optionKSRDL);

%% Coupled Dictionary Learning with rest data Dictionary
k3=k1+k0;
s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);
C=randn(size(Xs,1),size(Xi,1));
Xf=[Xs;Xi];%Xf=normc(Xf);
Hf=computeKernelMatrix(Xf(:,dtrn),Xf(:,dtrn),optionKSRDL);
[DtD,Y1,Y2,Dh]=KSRDLjnew(Xs(:,dtrn),Xi(:,dtrn),C,rDs,Hf,k3,optionKSRDL);
Ds=Dh(1:size(Xs,1),:);Di=Dh(size(Xs,1)+1:end,:);
nc=sqrt(diag(Ds'*Ds));nd=sqrt(diag(Di'*Di));
Ds=normc(Ds);
Dsr=[Ds rDs];Di=ones(Ni,1)*(nd./nc)'.*normc(Di);
sDtD=Dsr'*Dsr;iDtD=Di'*Di;
sDtX=Dsr'*Xs(:,ctrn);
l2=0.01;
optionKSRDL.lambda=l2;
[Ytst_pre, ~, sp1]=KSRSC(sDtD,sDtX,[],optionKSRDL);
Ytst=Ytst_pre(1:size(Y1,1),:);Ytstr=Ytst_pre(size(Y1,1)+1:end,:);
rsDtX=Dsr'*rXs(:,crtrn);
optionKSRDL.lambda=l2;
[rYtst_pre, ~, sp2]=KSRSC(sDtD,rsDtX,[],optionKSRDL);
rYtst=rYtst_pre(1:size(Y1,1),:);

sDtX=Dsr'*Xs(:,tst);
optionKSRDL.lambda=l2;
[Yout_pre, ~, sp3]=KSRSC(sDtD,sDtX,[],optionKSRDL);
Yout=Yout_pre(1:size(Y1,1),:);
rsDtX=Dsr'*rXs(:,rtst);
optionKSRDL.lambda=l2;
[rYout_pre, ~, sp4]=KSRSC(sDtD,rsDtX,[],optionKSRDL);
rYout=rYout_pre(1:size(Y1,1),:);


% %% Coupled Dictionary Learning without rDs
% k4=k3;
% s = RandStream('swb2712','Seed',1);
% RandStream.setGlobalStream(s);
% C=randn(size(Xs,1),size(Xi,1));
% Xf=[Xs;Xi];%Xf=normc(Xf);
% Hf=computeKernelMatrix(Xf(:,dtrn),Xf(:,dtrn),optionKSRDL);
% optionKSRDL.lambda=0.1;
% [cDtD,cY,cD,cpinvY]=KSRDL(Xf(:,dtrn),Hf,k4,optionKSRDL);
% cDs=cD(1:size(Xs,1),:);cDi=cD(size(Xs,1)+1:end,:);
% nc=sqrt(diag(cDs'*cDs));nd=sqrt(diag(cDi'*cDi));
% cDs=[normc(cDs)];cDi=ones(Ni,1)*(nd./nc)'.*normc(cDi);
% csDtD=cDs'*cDs;ciDtD=cDi'*cDi;
% csDtX=cDs'*Xs(:,ctrn);
% optionKSRDL.lambda=0.01;
% [cYtst_pre, ~, sp3]=KSRSC(csDtD,csDtX,[],optionKSRDL);
% cYtst=cYtst_pre(1:size(cY,1),:);cYtstr=cYtst_pre(size(cY,1)+1:end,:);
% rcsDtX=cDs'*rXs(:,ctrn);
% optionKSRDL.lambda=0.01;
% [rcYtst_pre, ~, sp4]=KSRSC(csDtD,rcsDtX,[],optionKSRDL);
% rcYtst=rcYtst_pre(1:size(cY,1),:);


%% Evaluation
% res=[norm(Xi(:,ctrn)-Di*Ytst,'fro') norm(Xi(:,ctrn)-cDi*cYtst,'fro')...    
%     norm(Xi(:,dtrn)-Di*Y1,'fro') norm(Xi(:,dtrn)-cDi*cY,'fro') ...
%     norm(Xs(:,ctrn)-Dsr*Ytst_pre,'fro') norm(Xs(:,ctrn)-cDs*cYtst_pre,'fro')...
%     norm(rXs(:,ctrn)-Dsr*rYtst_pre,'fro') norm(rXs(:,ctrn)-cDs*rcYtst_pre,'fro')...
%     sp1 sp2 sp3 sp4]
