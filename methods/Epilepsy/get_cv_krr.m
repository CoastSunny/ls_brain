function [Copt Res] = get_cv_krr(Xtr,Ytr,C,folds)
% Xtr--input data matrix
% Ytr--output data matrix
% C  --values to test

if nargin<3
    C=[ 5.^[5:-1:-1]];
end
C=.1*dataVarEst(Xtr,1)*C;
if nargin<4
    folds=5;
end
Fi=gennFold(ones(size(Xtr,1),1),folds);
for fold=1:folds
    fidxs=Fi(:,fold);
    for i=1:numel(C)       
            [alpha Y2]=km_krr(Xtr(fidxs==-1,:),Ytr(fidxs==-1,:),'linear',[],C(i),Xtr(fidxs==1,:));
            Res(i,fold)=norm(Y2-Ytr(fidxs==1,:),'fro');       
    end
    
end
Res=mean(Res,2);
[m i]=min(Res(:));

Copt=C(i);

end