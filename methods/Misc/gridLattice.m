function A = gridLattice(n,c);

% INPUT     n-  number of nodes in grid lattice,
%           c-  number of columns of grid lattice. Note: n/c must be an integer.
%
% OUTPUT    A-  n x n x (max(c,n/c) + 1) adjacency matrix of the grid
% lattice for each step (corresponding to weight categories of the complete
% weighted grid lattice network).

C = max([c n/c]);
R = min([c n/c]);

if n/c ~= round(n/c)
    disp('Error: n/c must be an integer!')
else
    A = zeros(n,n,C+1);    
    
    for k = 3:C+1
        for i = 1:n
             M = reshape([1:n],C,R);
            [row,col] = find(M==i);
            if (row - k+2) > 0
                M(1:(row - k+1),:) = 0;
            end
            if (row + k-2) <= C
                M((row + k-1):C,:) = 0;
            end
            if (col - k+2)>0
                M(:,1:(col - k+1)) = 0;
            end
            if (col + k-2) <= R
                M(:,(col + k-1):R) = 0;
            end
            A(i,(M(:)>0),k) = 1;
        end             
                
        A(:,:,k) = A(:,:,k).*~eye(size(A(:,:,k))); % sets diagonal to zero
    end
    A(:,:,2) = A(:,:,2) + diag(diag(A(:,:,3),1),1) + diag(diag(A(:,:,3),-1),-1) + diag(ones(1,n-C),C) + diag(ones(1,n-C),-C);
end
