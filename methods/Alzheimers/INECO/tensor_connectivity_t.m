function out = tensor_connectivity3(F,T,band)

tr=size(T,1);
fr=size(F,1);
if nargin<4
    band=1:fr;
end
nelems=size(T,2);
out=zeros(nelems,nelems,fr);

for k=band
    for i=1:nelems
        for j=1:nelems            
            
            if (i~=j)
                
                out(i,j,k)=abs(mean(sign(imag(conj(F(k,i).*T(:,i)).*(F(k,j).*T(:,j))))));
%                   out(i,j,k)=abs(mean(sign(angle(F(k,i).*T(:,i))-angle(F(k,j).*T(:,j)))));

            end
            
        end
    end
end

end