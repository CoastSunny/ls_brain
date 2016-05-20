
function [U V E] = ls_nnsc(Xs,Xi,rDs,param)

K=param.K;
Ks=K-size(rDs,2);
param.mode=2;
param.posAlpha=1;
param.whiten=0;



E=zeros(size(rDs,2),size(Xs,2));
for ls_iter=1:10
Xf=cat(1,Xs-rDs*E,Xi);
% [r c]=find(Xf<0);
% Xf(r,c)=0;

param.K=Ks;
U=mexTrainDL(Xf,param);
V=mexLasso(Xf,U,param);
param.K=K-Ks;
Ds=U(1:size(Xs,1),:);
Dsr=[normc(Ds) rDs];
Eo=mexLasso(Xs,Dsr,param);
E=Eo(Ks+1:end,:);
% Xx=Xs-Ds*V;
% [r c]=find(Xx<0);
% XX(r,c)=0;

% E=mexLasso(Xx,rDs,param);
end

   
end

