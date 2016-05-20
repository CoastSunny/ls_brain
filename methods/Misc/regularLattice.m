function A = regularLattice(n)

A(:,:,1) = zeros(n,n);
if mod(n,2) == 0
    for j = 2:n/2
        A(:,:,j) = A(:,:,j-1) + diag(ones(1,n-(j-1)),j-1) + diag(ones(1,n-(j-1)),-(j-1)) + diag(ones(1,j-1),n-(j-1)) + diag(ones(1,j-1),-(n-(j-1)));
    end
    A(:,:,n/2+1) = ~eye(n);
else
    for j = 2:(n-1)/2+1
         A(:,:,j) = A(:,:,j-1) + diag(ones(1,n-(j-1)),j-1) + diag(ones(1,n-(j-1)),-(j-1)) + diag(ones(1,j-1),n-(j-1)) + diag(ones(1,j-1),-(n-(j-1)));
    end
end
