
trn=1:round(size(Di,2)/2);
tst=(round(size(Di,2)/2)+1):size(Di,2);
% KSRDL
optionKSRDL.lambda=0.1;
optionKSRDL.SCMethod='nnqpAS'; % can be nnqpAS, l1qpAS, nnqpIP, l1qpIP, l1qpPX, nnqpSMO, l1qpSMO
optionKSRDL.dicPrior='uniform'; % can be uniform, Gaussian
optionKSRDL.kernel='linear';
optionKSRDL.param=2^0;
optionKSRDL.iter=100;
optionKSRDL.dis=0;
optionKSRDL.residual=1e-4;
optionKSRDL.tof=1e-4;
 
% X=cat(3,x,rx);
% X=permute(x,[2 1 3]);
% X=reshape(X,[],size(X,3));
h=gausswin(15);
%h=ones(15,1);
C=convmtx(h,27);
C=C(8:end-7,:);
%signal=sin(2*pi*(1:47)/10);
%Di=signal'*ones(1,size(Di,2))+.1*randn(size(Di));

% figure,subplot(1,2,1),plot(C(:,25))
% Ds=C*Di;
%  C=Ds*pinv(Di)+eye(size(C));
% C=eye(size(C));
Mi=mean(Di(:,trn),2);Ms=mean(Ds(:,trn),2);zz=1./Ms'*pinv(Mi');
 %zz=.5;
zz=norm(Ms)/norm(Mi);
%zz=.4;%%zz=0.2;
zz=.5;
C=zz*C/diag(sum(C));
C=zz*eye(size(C));
%  C=1;
C=zz*diag(ones(1,27-2),2)';
%Ds=C*Di+nn*randn(size(Ds));
%Ds=normc(Ds);
%  C=Ms*pinv(Mi);%+eye(size(C));
C=zz*eye(size(C));
 CC=C;

%D=normc(D);
k=10; % number of basis vectors
% C=zz*diag(ones(1,27-0),0)';
 
 
%%
Hx=computeKernelMatrix(Di(:,trn),Di(:,trn),optionKSRDL);
[AtAx,Yx,Ax,pinvYx]=KSRDL(Di(:,trn),Hx,k,optionKSRDL);
CC=Ds(:,trn)*pinv(Ax*Yx);
%CC=Ds(:,trn)*pinv(Di(:,trn));
% CC=zz*eye(size(C));
%CC=C;
Axc=CC*Ax;Axc=normc(Axc);
AtAx2=Axc'*Axc;
% [AtAx2,~,XtX,~,AtX]=normalizeKernelMatrix(AtAx2,AtAx2,AtAx2);
Yx2=KSRSC(AtAx2,Axc'*Ds(:,tst),H,optionKSRDL);
Yx2i=KSRSC(Ax'*Ax,Ax'*Di(:,tst),H,optionKSRDL);
%C=Ds(:,trn)*pinv(Di(:,trn));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C=CC;
D=Di+C'*Ds;
H=computeKernelMatrix(D(:,trn),D(:,trn),optionKSRDL);
[AtA,Y,A,pinvY,C,rr]=KSRDLj(Di(:,trn),Ds(:,trn),C,H,k,optionKSRDL); % Y is the representation of the training set in the feature space, the dictionry A is only meaningful for linear kernel. Usually we use AtA.
Ac=C*A;Ac=normc(Ac);
AtA2=(Ac)'*(Ac);
% [AtA2]=normalizeKernelMatrix(AtA2);
Y2=KSRSC(AtA2,Ac'*Ds(:,tst),H,optionKSRDL);
Y2i=KSRSC(A'*A,A'*Di(:,tst),H,optionKSRDL);


%%
Ho=computeKernelMatrix(Ds(:,trn),Ds(:,trn),optionKSRDL);
[AtAo,Yo,Ao,pinvYo]=KSRDL(Ds(:,trn),Ho,k,optionKSRDL);
Yo2=KSRSC(AtAo,Ao'*Ds(:,tst),H,optionKSRDL);

[norm(Di(:,tst)-A*Y2,'fro') norm(Di(:,tst)-Ax*Yx2,'fro')...
 norm(Di(:,tst)-A*Y2i,'fro') norm(Di(:,tst)-Ax*Yx2i,'fro')...
 norm(Ds(:,tst)-C*A*Y2,'fro') norm(Ds(:,tst)-CC*Ax*Yx2,'fro')...
 norm(Ds(:,tst)-Ao*Yo2,'fro') ]


