function M = component2model(comp,T1,T2,T3,T4)

A=T1;
H=T2;
P=T4;
C=T3;
K=numel(P);
for k=1:K
    
    F=P{k}*H;
    M(:,:,k)=A(:,comp)*diag(C(k,comp))*(F(:,comp))';
    
end

end
