Q=B2;
W=A2;
z=Q(1,:)==1;
b=Q(:,z);
e=W(:,:,z);
LOC=0;
for i=1:size(e,3)

    a=e(:,1,i);
    b=e(:,2,i);
    tmp1=sum(b==a(1))*1/2;
    if tmp1>0
        LOC=LOC+1/2;
    else
        LOC=LOC-1/2;
    end
    tmp2=sum(b==a(2))*1/2;
    if tmp2>0
        LOC=LOC+1/2;
    else
        LOC=LOC-1/2;
    end
end