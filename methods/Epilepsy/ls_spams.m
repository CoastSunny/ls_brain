time2=1:65;
Xi=Xi(:,:);rXi=rXi(:,:);Xs=Xs(:,:);rXs=rXs(:,:);
Xi=fXi(:,:);rXi=frXi(:,:);Xs=fXs(:,:);rXs=frXs(:,:);
% Xi=normc(Xi);rXi=normc(rXi);Xs=normc(Xi);rXs=normc(rXi);
% Xi=repop(Xi,'-',mean(Xi));rXi=repop(rXi,'-',mean(rXi));
% Xs=repop(Xs,'-',mean(Xs));rXs=repop(rXs,'-',mean(rXs));
Ns=size(Xs,1);Ni=size(Xi,1);
nex=size(Xi,2);extra=size(rXs,2)-size(Xs,2);
dtrn=1:round(nex*1/3);
drtrn=(1:extra);
ctrn=dtrn(end)+1:round(2*nex/3);
crtrn=drtrn(end)+1:drtrn(end)+numel(ctrn);
tst=ctrn(end)+1:nex;
rtst=crtrn(end)+1:(crtrn(end)+numel(tst));
% init
param.iter=100;
param.lambda=.2;
param.lambda3=0.25;
param.mode=2;
param.posAlpha=1;
param.posD=0;
param.whiten=0;
param.pos=1;
%%
% C=randn(size(Xs,1),size(Xi,1));
% S=randn(size(Xi,1),3);S=normc(S);
% as=full(sprand(size(S,2),size(Xi,2),0.5));
% N=randn(size(Xs,1),150);N=normc(N);
% an=full(sprand(size(N,2),size(Xi,2),0.01));
% ran=full(sprand(size(N,2),size(rXi,2),0.01));
% Xi=S*as;%Xi=normc(Xi);
% nn=1.0;
% Cs=normc(C*S);
% Xs=Cs*as+nn*N*an;%Xs=normc(Xs);
% rXs=nn*N*ran;%rXs=normc(rXs);
%% Learn rest data scalp Dictionary
kr=300;
param.K=kr;
s = RandStream('swb2712','Seed',1);RandStream.setGlobalStream(s);
[rDs rYs]=nnsc(rXs(:,drtrn),param);
%% Learn rest data scalp Dictionary

param.K=kr+k0;
s = RandStream('swb2712','Seed',1);RandStream.setGlobalStream(s);
[Dso Yso]=nnsc(Xs(:,dtrn),param);


%% Coupled Dictionary Learning with rest data Dictionary
param.K=k0+kr;
% 
s = RandStream('swb2712','Seed',1);RandStream.setGlobalStream(s);
[Df,Ys,Yr]=ls_nnsc(Xs(:,dtrn),Xi(:,dtrn),rDs,param);
Ds=Df(1:size(Xs,1),:);Di=Df(size(Xs,1)+1:end,:);
nc=sqrt(diag(Ds'*Ds));nd=sqrt(diag(Di'*Di));
Ds=normc(Ds);%Di=normc(Di);

%  Ds=mean(Xs(:,dtrn),2);Ds=normc(Ds);
Dsr=[Ds rDs];%Di=ones(Ni,1)*(nd./nc)'.*normc(Di);
% 
% param.lambda=0.3;
% param.iter=100;
% Dsr=rDs;
[Ytst_pre]=mexLasso(Xs(:,ctrn),Dsr,param);
Ytst=full(Ytst_pre(1:k0,:));

[rYtst_pre]=mexLasso(rXs(:,crtrn),Dsr,param);
rYtst=full(rYtst_pre(1:k0,:));

[Yout_pre]=mexLasso(Xs(:,tst),Dsr,param);
Yout=full(Yout_pre(1:k0,:));

[rYout_pre]=mexLasso(rXs(:,rtst),Dsr,param);
rYout=full(rYout_pre(1:k0,:));


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
