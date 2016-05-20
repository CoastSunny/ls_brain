
Q=F(:,:,2);

for i=1:600
   
    tmp=Q(i,:);
    [dum idx(i)]=max(abs(tmp));
    R(i)=tmp(idx(i));
    
end