function A = randomHierarchy(n,strength,k,p)

% Produces random hierarchy network with n nodes and k levels. 
%
%   INPUT:      n-              Number of nodes in the network
%               strength-       Additional strength of connections given to nodes in hierarchy level above the
%                               lower level. If unspecified strength will be 0.2.
%               k-              Number of hierarchical levels. If unspecified it will be randomly selected 
%                               between 2 & 5.
%               p-              A kx1 vector of probability distribution of a node belonging to each hierarchy
%                               level. If unspecified the probabilities follow a geometric distribution with 
%                               parameter 0.6.               
%
%   OUTPUT:     A-              Complete weighted adjacency matrix for the random hierarchy network.

% rng('shuffle');
M_rand = rand(n);
Q = (triu(M_rand) + triu(M_rand,1)');

if ~exist('k','var')
    k = randi(4)+1;
end

if ~exist('p','var')    
    p = [cdf('geo',0:k-2,0.6),1];
elseif length(p) ~= k
    disp('k and length(p) do not match!')
else        
end

if ~exist('strength','var')
    strength = 0.2;
end


Rndval = rand(n,1);

for j = 1:n
    propj = p - Rndval(j);
    K = find(propj>0,1);
    Q(j,:) = Q(j,:) + strength*(K-1);
    Q(:,j) = Q(:,j) + strength*(K-1);
end

A = Q.*~eye(n)./(1+2*(k)*strength);



    