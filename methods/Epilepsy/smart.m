
t1=SP(1);
l=41;
xxx=[];
tr=50;
for i=SP(tr)-10000:SP(tr)+10000

    sY=X(sEEG_idx,i:i+l-1);
    sY=detrend(sY,2);
    w=inv(sY*sY'+2*norm(sY,'fro')*eye(size(sY,1)))*sY*mean(I(:,:,1:50),3)';
    xxx(:,:,end+1)=w'*sY;

end

 ssD=cat(3,sy,rsy,xxx);
 labels2=[];
 labels2(1:size(sy,3))=-1;
 labels2(size(sy,3)+1:size(sy,3)+size(rsy,3))=1;
 labels2(1:50)=0;
 labels2(size(sy,3)+1:size(sy,3)+50)=0;
 labels2(end+1:end+size(xxx,3))=0;
 [ssclsfr ssres]=cvtrainLinearClassifier(ssD,labels2,[],10,'dim',3);
