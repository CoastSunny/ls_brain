function [ CSTAdMat CSThresh] = CST(M) 

% Function computes the Cluster-Span Threshold of a complete weighted
% adjacency matrix
%
%   INPUT:      M - M complete weighted adjacency matrix for the network
%
%   OUTPUT:     CSTAdMat - The binary network from the Cluster-Span Threshold 
%
%

A = sort(M(:));

for i = 1:(round(.85*length(M)*(length(M)-1)/2))                         % Index starts from 15% till 85% connection density  
    % Threshold graph on edge count  
    edgeThresh          = A(round(.15*length(M)*(length(M)-1)/2)+2*i);
    Propi               = M > edgeThresh;
    
    % Global Clustering Co-efficient
    Dsq                 = diag( diag( Propi^2 ) );      
    C_glob(i)           = sum( diag( Propi^3 ) ) / sum(sum(Propi^2 - Dsq));
end

[c index]           = min(abs(C_glob - 0.5));
CSThresh            = A(round(.15*length(M)*(length(M)-1)/2)+2*index);
CSTAdMat            = M > CSThresh;

