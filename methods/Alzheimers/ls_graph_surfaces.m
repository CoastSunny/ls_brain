clear all
n=4;
H=ones(n)-eye(n);
X=[ -2:0.1:2];
Y=X;Z=X;C=X;
T=zeros(numel(X),numel(Y),numel(Z),numel(C));
T2=zeros(numel(X),numel(Y),numel(Z),numel(C));
T3=zeros(numel(X),numel(Y),numel(Z),numel(C));
E=zeros(numel(X),numel(Y),numel(Z),numel(C));
d=zeros(numel(X),numel(Y),numel(Z),numel(C));
cl=zeros(numel(X),numel(Y),numel(Z),numel(C));


for x=1:numel(X)
    for y=1:numel(Y)
        for z=1:numel(Z)
             parfor c=1:numel(C)
                 
                W=zeros(4,4);
                W(1,2)=X(x);W(1,3)=Y(y);W(2,3)=Z(z);
                W(3,4)=C(c);
                W=W+W';
%                 T(x,y,z,c)=ls_network_metric(W,'trans');
               
                     T2(x,y,z,c)=trace(W^3);
                     T3(x,y,z,c)=trace(W*H*W);
    %                 d(x,y,z,c)=trace(W*R);
              % cl(x,y,z,c)=mean(ls_network_metric(W,'clust')); 
                
             end
        end
    end
end
% a=(T2./T3-0.5).^2;
% D=(d-0.4).^2;

% Cl=(cl-0.3).^2;

t2=(T2-0.1).^2;
t3=(T3-0.1).^2;