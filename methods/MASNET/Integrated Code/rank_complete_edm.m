function [D,X] = rank_complete_edm(t_D, W, dim, gram)

%%
% D = sdr_complete_D(t_D, W, dim)
%
% Completes a partially observed D (with observed entries assumed noiseless)
% by alternating between enforcing the rank and enforcing the observed
% entries.
%
% INPUT:  t_D  ... input partial EDM
%         W    ... observation mask (1 for observed, 0 for non-observed
%         entries) in the case of W_{T,S} and W_{S,T}
%         dim  ... desired embedding dimensions
%         gram ... rank-threshold the Gram matrix, not the EDM
%
% OUTPUT: D    ... completed EDM
%
% Author: Ivan Dokmanic, 2014
% modified by Heba Shoukry for localization problem 

% Stopping criteria
MAX_ITER = 5000;
MAX_TOL  = 100;


W      = logical(W);
n      = size(t_D, 1);
mean_d = mean(mean(sqrt(t_D)));
D      = t_D;
D(W)   = mean_d;
I      = logical(eye(n));
J      = I - (1/n)*ones(n);

while true
    for i = 1:MAX_ITER
        % Save D to monitor convergence
        D_old = D;

        % Do rank thresholding
        if gram == 1
            G = -1/2 * J * D * J;
            [U, S, V] = svd(G);
            S(dim+1:end, dim+1:end) = 0;
            G = U * S * V';
            D = diag(G)*ones(1, n) + ones(n, 1)*diag(G)' - 2*G;
        else
            % to make rank of D = d+2
            [U, S, V] = svd(D);
            S(dim+3:end, dim+3:end) = 0;
            D = U * S * V';
            
        end

        change1 = norm((D_old - D), 'fro');

        % Enforce observed entries, zero diagonal and positivity
        
        D(W) = t_D(W); % enforce to observed entries
        D(I) = 0; % to assign all main diagonal elements to zero
        D(D<0) = 0; % to assign all negative elements in D to zero

        change2 = norm((D_old - D), 'fro');

        if (change1 < MAX_TOL)  && (change2 < MAX_TOL)
            break;
        end
       
    end
   X = sqrt(S(1:dim,:))*V.';

    if gram < 2
        break;
    else
        gram = 1;
    end
end
