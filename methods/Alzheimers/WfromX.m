function  W = WfromX(X)

Y=repop(X,'-',mean(X,2));
C=Y*Y';
n=size(C,1);
for i=1:n
    
    l(i)=norm(Y(i,:));
    
end
L=diag(l);
W=abs(L\C/L);
W(eye(n)>0)=0;

end