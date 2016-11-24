function out = tensor_connectivity2(p,h)

tr=size(p{1},1);
fr=size(p,2);
nelems=size(p{1},2);

for k=1:fr
    for i=1:nelems
        for j=1:nelems
            X=p{k}*h;
            
            if (i~=j)
                
                out(i,j,k)=abs(mean(sign(imag(conj(X(:,i)).*X(:,j)))));
                
            end
            
        end
    end
end

end