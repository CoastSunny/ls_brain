function M = get_M(X)

for i=1:size(X,1)
    mx(i)=max(abs(X(i,(floor(size(X,2)/2)-4):(floor(size(X,2)/2)+4))));
end
    M=max(mx);
end

