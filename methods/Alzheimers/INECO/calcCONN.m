Q=B10;
W=A10;
z=Q(1,:)==1;
b=Q(:,z);
count=0;
tmp=[];
CON=[];
for th=0:0.01:0.25
    count=count+1;
    c=sum(b(3,:)>th);
    d=sum(b(4,:)>th);
    tmp{count}=[ones(1,c) -2*ones(1,d)];
end
for i=1:count
    CON(i)=mean(tmp{i});
end
    