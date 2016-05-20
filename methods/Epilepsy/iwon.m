clear Mx Mrx M Mr
TPX=TPX1;
TPRX=TPRX1;
for i=1:numel(subj)
   temp=[];
   if size(TPX{i},3)>1
    for j=1:size(TPX{i},3)        
        temp(j)=get_M(TPX{i}(:,:,j));
    end
    M(i)=mean(temp(j));
    Mx{i}=temp;
    
   end
   tempr=[];
    for j=1:size(TPRX{i},3)        
        tempr(j)=get_M(TPRX{i}(:,:,j));
    end
    Mr(i)=mean(tempr);
    Mrx{i}=tempr;
end