Wls=[];
for i=1:1:size(X,2)-l
   
    sY=X(sEEG_idx,i:i+l-1);
    iY=X(iEEG_idx,i:i+l-1);
    
    sY=detrend(sY,2);
    iY=detrend(iY,2);
    
    w=inv(sY*sY'+1*norm(sY,'fro')*eye(size(sY,1)))*sY*iY';
    Wls(:,:,i)=w;
    
end