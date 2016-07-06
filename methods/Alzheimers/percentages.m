sims=100;
PC=[];
for i=1:numel(noise_values)

    tmp=Eclu(:,:,i);
    PC(1,i)=sum(tmp(1,:)-tmp(2,:)>0);
    tmp=Edeg(:,:,i);
    PC(2,i)=sum(tmp(1,:)-tmp(2,:)>0);
    tmp=Etrans(:,:,i);
    PC(3,i)=sum(tmp(1,:)-tmp(2,:)>0);
    tmp=Eavndeg(:,:,i);
    PC(4,i)=sum(tmp(1,:)-tmp(2,:)>0);
    
end
