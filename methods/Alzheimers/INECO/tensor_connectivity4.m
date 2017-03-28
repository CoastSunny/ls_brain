function out = tensor_connectivity3(d,band)

fr=size(d,1);
if nargin<2
    band=1:fr;
end
nelems=size(d,2);
out=zeros(nelems,nelems,fr);

for k=band
    for i=1:nelems
        for j=1:nelems

            
            if (i~=j)
                
%                 out(i,j,k)=abs(mean(sign(imag(conj(d(k,i).*X(:,i)).*(d(k,j).*X(:,j))))));
                  out(i,j,k)=abs( angle(d(k,i)) - angle(d(k,j)) ) ;

            end
            
        end
    end
end

end