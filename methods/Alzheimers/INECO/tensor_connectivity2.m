function out = tensor_connectivity2(p,h,band)

tr=size(p{1},1);
fr=size(p,2);
if nargin<3
    band=1:fr;
end
nelems=size(p{1},2);
out=zeros(nelems,nelems,fr);

parfor k=band
    for i=1:nelems
        for j=1:nelems
            X=p{k}*h;
            
            if (i~=j)
                
%                 out(i,j,k)=abs(mean(sign(imag(conj(X(:,i)).*X(:,j)))));
                  out(i,j,k)=abs(mean(sign(angle(X(:,i)-angle(X(:,j))))));

            end
            
        end
    end
end

end