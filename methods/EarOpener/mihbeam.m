
%% X: ERP average
X=single(X);

%% h: scalp map
h = 

%% C: sample covariance matrix
C = 1/size(X,2)*X*X';
%% regularize?
% lamba = ?
% C = C + lambda * eye(size(C));

w=inv(h'*inv(C)*h)*h'*inv(C);

