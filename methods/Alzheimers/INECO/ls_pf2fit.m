
function [powr,pow,powf,snr]=ls_pf2fit(Z,A,H,C,P,K,r)

  
    if strcmp(r,'all')
        r=1:size(A,2);
    end
   powr=0;pow=0;powf=0;
   for k = 1:K
     z=P{k}*H;
     M(:,:,k)   = A(:,r)*diag(C(k,r))*(z(:,r))';
     Y(:,:,k)   = A*diag(C(k,:))*(z)';
     
     powr = powr + norm ( M(:,:,k),'fro' );
     pow = pow + norm (Y(:,:,k) ,'fro');
     powf = powf + norm ( Z(:,:,k),'fro' );
%    fit = fit + norm(X{k}-M,'fro').^2;
   end
   snr=powr/(pow);