Ns=size(Xs,1);Ni=size(Xi,1);
trn=1:round(size(Xi,2)/2);
% trn=1:30;
tst=(round(size(Xi,2)/2)+1):size(Xi,2);
% KSRDL
optionKSRDL.lambda=0.1;
optionKSRDL.SCMethod='nnqpAS'; % can be nnqpAS, l1qpAS, nnqpIP, l1qpIP, l1qpPX, nnqpSMO, l1qpSMO
optionKSRDL.dicPrior='uniform'; % can be uniform, Gaussian
optionKSRDL.kernel='linear';
optionKSRDL.param=2^0;
optionKSRDL.iter=20;
optionKSRDL.dis=0;
optionKSRDL.residual=1e-4;
optionKSRDL.tof=1e-4;
Ci=[];
ci=ones(1,12);
for icool=1:12
    tmp{icool}=diag(ci(icool)*ones(1,65));
    Ci=[Ci;tmp{icool}];
end

% %  
% l=.5;
% hC=l*diag(ones(1,37-0),0)';
% %C=l*eye(27);
% Xs=hC*Xi+N;

% Xs=Xs+N;
%Xs=normc(Xs);
k=10; % number of basis vectors
% C=zz*diag(ones(1,27-0),0)';
Mi=mean(Xi(:,trn),2);Ms=mean(Xs(:,trn),2);

s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);

%%
Ho=computeKernelMatrix(Xs(:,trn),Xs(:,trn),optionKSRDL);
Hs=computeKernelMatrix(Xs(:,tst),Xs(:,tst),optionKSRDL);
[DtDo,Yo,Do,pinvYo]=KSRDL(Xs(:,trn),Ho,k,optionKSRDL);
DtXo=Do'*Xs(:,tst);
[DtDo,~,Hs,~,DtXo]=normalizeKernelMatrix(DtDo,Hs,DtXo);
Yo2=KSRSC(DtDo,DtXo,Hs,optionKSRDL);
%%
s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);
Hx=computeKernelMatrix(Xi(:,trn),Xi(:,trn),optionKSRDL);
[DtDx,Yx,Dx,pinvYx,numIter,tElapsed,rrx]=KSRDL(Xi(:,trn),Hx,k,optionKSRDL);
%CC=Do*pinv(Dx);
CC=Xs(:,trn)*pinv(Xi(:,trn));%CC=CC/norm(CC,'fro');
%CC=(mean(Xs(:,trn),2)'*pinv(mean(Dx*Yx,2)'))*eye(size(CC));
% delay=finddelay(mean(Dx*Yx,2),Ms);
% hCC=diag(ones(1,27-delay),delay)';
%CC=(mean(Xs(:,trn),2)'*pinv(mean(hCC*Dx*Yx,2)'))*hCC;
%CC=hC;
Dxc=CC*Dx;Dxc=normc(Dxc);
DtDxc=Dxc'*Dxc;
DtXx=Dxc'*Xs(:,tst);
[DtDxc,~,Hs,~,DtXx]=normalizeKernelMatrix(DtDxc,Hs,DtXx);
Yx2=KSRSC(DtDxc,DtXx,[],optionKSRDL);
Yx2i=KSRSC(Dx'*Dx,Dx'*Xi(:,tst),[],optionKSRDL);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = RandStream('swb2712','Seed',1);
RandStream.setGlobalStream(s);
%C=eye(size(Xs));
%C=hC;
%C=CC;
%pen=0.4;
C=randn(size(Xs,1),65);
Xh=[pen*Xs;Xi];%Xh=normc(Xh);
H=computeKernelMatrix(Xh(:,trn),Xh(:,trn),optionKSRDL);
[DtD,Y,D,Dh,pinvY,Cs,Ci,rr]=KSRDLj3(Xi(:,trn),Xs(:,trn),C,Ci,pen,H,k,optionKSRDL); % Y is the representation of the training set in the feature space, the dictionry A is only meaningful for linear kernel. Usually we use AtA.
%D=Dh(38:end,:);
nc=1/pen*sqrt(diag(Dh(1:Ns,:)'*Dh(1:Ns,:)));nd=sqrt(diag(Dh(Ns+1:end,:)'*Dh(Ns+1:end,:)));
D=Dh(Ns+1:end,:);D=ones(Ni,1)*(nd./nc)'.*normc(D);
Dc=Dh(1:Ns,:);Dc=normc(Dc);
DtDc=(Dc)'*(Dc);
DtX=Dc'*Xs(:,tst);
[DtDc,~,Hs,~,DtX]=normalizeKernelMatrix(DtDc,Hs,DtX);
Y2=KSRSC(DtDc,DtX,[],optionKSRDL);
Y2i=KSRSC(DtD,D'*Xi(:,tst),[],optionKSRDL);
rr(end,:);
% Xsh=[C*Xs(:,tst);Xs(:,tst)];
% Hsh=computeKernelMatrix(Xsh,Xsh,optionKSRDL);
% DtX=Dh'*Xsh;
% [DtD,~,Hsh,~,DtX]=normalizeKernelMatrix(DtD,Hsh,DtX);
% Y22=KSRSC(DtD,DtX,[],optionKSRDL);
Xh=[pen*Xs;Xi];%Xh=normc(Xh);
H=computeKernelMatrix(Xh(:,trn),Xh(:,trn),optionKSRDL);
[DtDy,Yy,Dy,pinvY]=KSRDL(Xh(:,trn),H,k,optionKSRDL); % Y is the representation of the training set in the feature space, the dictionry A is only meaningful for linear kernel. Usually we use AtA.
nc=1/pen*sqrt(diag(Dy(1:Ns,:)'*Dy(1:Ns,:)));nd=sqrt(diag(Dy(Ns+1:end,:)'*Dy(Ns+1:end,:)));
Dyi=Dy(Ns+1:end,:);Dyi=ones(Ni,1)*(nd./nc)'.*normc(Dyi);
Dys=Dy(1:Ns,:);Dys=normc(Dys);
DtDys=Dys'*Dys;
DtXys=Dys(1:Ns,:)'*Xs(:,tst);
[DtDys,~,Hs,~,DtXys]=normalizeKernelMatrix(DtDys,Hs,DtXys);
Yy2=KSRSC(DtDys,DtXys,[],optionKSRDL);
Yy2i=KSRSC(DtDy,D'*Xi(:,tst),[],optionKSRDL);

%%
ttt=1:Ni;
L=size(Xi(:,tst),2);
[norm(Xi(ttt,tst)-D(ttt,:)*Y2,'fro') norm(Xi(ttt,tst)-Dx(ttt,:)*Yx2,'fro') norm(Xi(ttt,tst)-Dyi(ttt,:)*Yy2,'fro')...
 norm(mean(Xi(:,tst),2)-mean(D*Y2,2)) norm(mean(Xi(:,tst),2)-mean(Dx*Yx2,2))...
 norm(mean(Xi(:,tst),2)-mean(Dyi*Yy2,2))...
 norm(Xi(:,tst)-D*Y2i,'fro') norm(Xi(:,tst)-Dx*Yx2i,'fro')...
 norm(Xs(:,tst)-Dc*Y2,'fro') norm(Xs(:,tst)-Dxc*Yx2,'fro')...
 norm(Xs(:,tst)-Dys*Yy2,'fro') norm(Xs(:,tst)-Do*Yo2,'fro')]/L
 