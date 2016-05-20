function [Copt Sopt Res] = get_cv_sigma_krr(Xtr,Ytr,C,S,folds)
% Xtr--input data matrix
% Ytr--output data matrix
% C  --values to test

if nargin<3
    C=[ 5.^[5:-1:-1]];
end
% C=.1*dataVarEst(Xtr,1)*C;
if nargin<4
    S=(0.1:100:1000.1);
    %S=[ 5.^[3:-.1:-3]];
end
S=.1*dataVarEst(Xtr,1)*S;
if nargin<5
    folds=5;
end
Fi=gennFold(ones(size(Xtr,1),1),folds);
for fold=1:folds
    fidxs=Fi(:,fold);
    for i=1:numel(C)
        for j=1:numel(S)
            [alpha Y2]=km_krr(Xtr(fidxs==-1,:),Ytr(fidxs==-1,:),'gauss',S(j),C(i),Xtr(fidxs==1,:));
            Res(i,j,fold)=norm(Y2-Ytr(fidxs==1,:),'fro');
        end
    end
    
end

Res=mean(Res,3);
[m i]=min(Res(:));
[m n]=ind2sub(size(Res),i);

Copt=C(m);
Sopt=S(n);

end