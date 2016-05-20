
X=0.01:0.01:1;
Y=X;Z=X;C=X;
T=[];
for x=1:numel(X)
    for y=1:numel(Y)
        for z=1:numel(Z)
            for c=1:numel(C)
                W=zeros(4,4);
                W(1,2)=X(x);W(1,3)=Y(y);W(2,3)=Z(z);
                W(3,4)=C(c);
                W=W+W';
                T(x,y,z,c)=ls_network_metric(W,'trans');
                
            end
        end
    end
end