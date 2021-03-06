
X=cat(3,x,rx);
X=permute(x,[2 1 3]);
X=reshape(X,[],size(X,3));

% KSRDL
optionKSRDL.lambda=0.1;
optionKSRDL.SCMethod='nnqpAS'; % can be nnqpAS, l1qpAS, nnqpIP, l1qpIP, l1qpPX, nnqpSMO, l1qpSMO
optionKSRDL.dicPrior='uniform'; % can be uniform, Gaussian
optionKSRDL.kernel='rbf';
optionKSRDL.param=2^0;
optionKSRDL.iter=100;
optionKSRDL.dis=0;
optionKSRDL.residual=1e-4;
optionKSRDL.tof=1e-4;

H=computeKernelMatrix(X,X,optionKSRDL);

% training: learn the feature space
k=20; % number of basis vectors
[AtA,Y,A,pinvY]=KSRDL(X,H,k,optionKSRDL); % Y is the representation of the training set in the feature space, the dictionry A is only meaningful for linear kernel. Usually we use AtA.

% prediction: project the unknown samples in the feature space


