function x = permMatrices(n,permutations)
 x = zeros(n,n,size(permutations,1));
% permutations = perms(1:n);
for i = 1:size(x,3)
    I=eye(n);
    x(:,:,i) = I(permutations(i,:),:);
end
end
