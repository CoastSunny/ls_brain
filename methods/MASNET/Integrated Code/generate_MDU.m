function [W] = generate_MDU(Sensors,R)
nn = R;
k =size(Sensors,1);
W_R = zeros(nn,nn); % define mask matrix for distances between target nodes for (unknown) unobserved entries
W_S = zeros(k,k); % define mask matrix for distances between sensor nodes for (known) observed entries
W_R_S = ones(nn,k);%[1 0 1 1 1 0 1 1 0 0 ];%ones(nn,k);% % define mask matrix for distances between sensor and target nodes
W_S_R = ones(k,nn);%[1 0 1 1 1 0 1 1 0 0 ].';%ones(k,nn); %%% define mask matrix for distances between sensor and target nodes 
W_mdu = [W_R W_R_S; W_S_R W_S]; % concatenate all four matrices to get one mask matrix (n+k)x(n+k) with 1 (known) and 0 (unknown)
W = logical(W_mdu);
end