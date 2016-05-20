function module_matrix = ind2mod(mod_ind,W)

n=size(W,1);

for i=1:numel(mod_ind)
    
    tmp = mod_ind{ i };
    for j=1:numel(tmp)
        for k=1:numel(tmp)
            if (j~=k)
                D(tmp(j),tmp(k))=1;
            end
            
        end
        
    end
    
end

module_matrix=D;

end