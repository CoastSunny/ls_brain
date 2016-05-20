function A = Hub(n)

A(:,:,1) = zeros(n,n);

for i = 1:(n-1)
    A(1:i,:,i+1) = 1;
    A(:,1:i,i+1) = 1;
    A(:,:,i+1) = A(:,:,i+1).*~eye(n);
end