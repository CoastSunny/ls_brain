function [W] = generate_MDU_pd(Sensors,R)
nn = 1;
k =size(Sensors,1);
W_R = zeros(nn,nn); % define mask matrix for distances between target nodes 0 for (unknown) unobserved entries
W_S = zeros(k,k); % define mask matrix for distances between sensor nodes 1 for (known) observed entries
W_R_S = R;% % define mask matrix for distances between sensor and target nodes 0 for (unknown)
W_S_R = R'; %%% define mask matrix for distances between sensor and target nodes 0 for (unknown)
W_mdu = [W_R W_R_S; W_S_R W_S]; % concatenate all four matrices to get one mask matrix (n+k)x(n+k) with 1 (known) and 0 (unknown)
W = logical(W_mdu);

end