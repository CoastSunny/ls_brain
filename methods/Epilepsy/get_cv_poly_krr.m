function [Copt S1opt S2opt Res] = get_cv_sigma_krr(Xtr,Ytr,C,S1,S2,folds)
% Xtr--input data matrix
% Ytr--output data matrix
% C  --values to test

if nargin<3
    C=[ 5.^[3:-1:-5]];
end
if nargin<4
    S1=1:4;
    S2=0:2:10;
    %S=[ 5.^[3:-.1:-3]];
end
if nargin<6
    folds=5;
end
Fi=gennFold(ones(size(Xtr,1),1),folds);
for fold=1:folds
    fidxs=Fi(:,fold);
    for i=1:numel(C)
        for j=1:numel(S1)
            parfor k=1:numel(S2)
            [alpha Y2]=km_krr(Xtr(fidxs==-1,:),Ytr(fidxs==-1,:),'poly',[S1(j) S2(k)],C(i),Xtr(fidxs==1,:));
            Res(i,j,k,fold)=norm(Y2-Ytr(fidxs==1,:),'fro');
            end
        end
    end
    
end
Res=mean(Res,4);
[m i]=min(Res(:));
[m n o]=ind2sub(size(Res),i);

Copt=C(m);
S1opt=S1(n);
S2opt=S2(o);

end