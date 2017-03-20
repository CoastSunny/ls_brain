function out = tensor_connectivity3(p,h,d,band)

tr=size(p{1},1);
fr=size(p,2);
if nargin<4
    band=1:fr;
end
nelems=size(p{1},2);
out=zeros(nelems,nelems,fr);

for k=band
    for i=1:nelems
        for j=1:nelems
            X=p{k}*h;
            
            if (i~=j)
                
                out(i,j,k)=abs(mean(sign(imag(conj(d(k,i).*X(:,i)).*(d(k,j).*X(:,j))))));
%                   out(i,j,k)=abs(mean(sign(angle(X(:,i)-angle(X(:,j))))));

            end
            
        end
    end
end

end