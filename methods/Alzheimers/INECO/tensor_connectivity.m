function out = tensor_connectivity(Fp,subj,dim)

X=Fp{subj}{dim};
nelems=size(X,2);

for i=1:nelems
    for j=1:nelems
        
        if (i~=j)
            
            out(i,j)=abs(mean(sign(imag(conj(X(:,i)).*X(:,j)))));
            
        end
        
    end
end

end