
function [powr,pow,snr]=ls_pf2fit(A,H,C,P,K,r)

   % Calculate fit and impute missing elements from model
    if strcmp(r,'all')
        r=1:size(A,2);
    end
   powr=0;pow=0;
   for k = 1:K
     z=P{k}*H;
     M(:,:,k)   = A(:,r)*diag(C(k,r))*(z(:,r))';
     Y(:,:,k)   = A*diag(C(k,:))*(z)';
     % if missing values replace missing elements with model estimates
    
%      powr = powr + sum(sum(abs ( M(:,:,k) )));
%      pow = pow + sum(sum(abs (Y(:,:,k) )));
     powr = powr + norm ( M(:,:,k),'fro' );
     pow = pow + norm (Y(:,:,k) ,'fro');

%    fit = fit + norm(X{k}-M,'fro').^2;
   end
   snr=powr/(pow);