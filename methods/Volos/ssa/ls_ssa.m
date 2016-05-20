function y = ls_ssa(x,r,L)



N=length(x);
if L>N/2;L=N-L;end
K=N-L+1;
X=zeros(L,K);
Y=zeros(L,K);
for i=1:K
    X(1:L,i)=x(i:L+i-1);
    Y(1:L,i)=r(i:L+i-1);
end

[U S V] = svd(X);
W=eye(L);
mu=0.001;
S=S(1:L,1:L);
V=V(:,1:L);

for i=1:1000
   
    W = W - mu * U * S * V' * ( Y - U * W * S * V')';
    mu=0.9*mu;
end

   rca=U*W*S*V';

   y=zeros(N,1);  
   Lp=min(L,K);
   Kp=max(L,K);

   for k=0:Lp-2
     for m=1:k+1;
      y(k+1)=y(k+1)+(1/(k+1))*rca(m,k-m+2);
     end
   end

   for k=Lp-1:Kp-1
     for m=1:Lp;
      y(k+1)=y(k+1)+(1/(Lp))*rca(m,k-m+2);
     end
   end

   for k=Kp:N
      for m=k-Kp+2:N-Kp+1;
       y(k+1)=y(k+1)+(1/(N-k))*rca(m,k-m+2);
     end
   end

   
end
