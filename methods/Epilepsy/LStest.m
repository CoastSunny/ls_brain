
for i=1:size(spikes,2)
   
    sX(:,:,i)=X(sEEG_idx,SP(i)-50:SP(i)+50);
    x=sX(:,:,i);
    sY(:,:,i)=X(iEEG_idx,SP(i)-50:SP(i)+50);
    y=sY(:,:,i);
    r(i,:)=y(1,:);
    w(:,i)=inv(x*x')*x*r(i,:)';
    z(i,:)=w(:,i)'*x;
    
end