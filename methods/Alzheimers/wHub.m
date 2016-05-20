function [W,We] = wHub(n,n_out,noise_std)

W(:,:,1) = zeros(n,n);
We=W;
for i = 1:(n-1)
    W(1:i,:,i+1) = 1;
    W(:,1:i,i+1) = 1;
    W(:,:,i+1) = W(:,:,i+1).*~eye(n);
    B=triu(rand(n));
    B=B+B';
    E=triu(randn(n))*noise_std;
    E=E+E';
    W(:,:,i+1)=W(:,:,i+1).*B;
    We(:,:,i+1)=(W(:,:,i+1)+E).*~eye(n);
    tmp=We;
    tmp(tmp<0)=0;
%     tmp(tmp>1)=1;
    We=tmp;
end

if ~isempty(n_out)
    W=W(:,:,n_out);
    W=W/max(max(W));
    We=We(:,:,n_out);
    We=We/max(max(We));
end
end


