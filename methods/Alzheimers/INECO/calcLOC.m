Q=B;
W=A;
z=Q(1,:)==1;
b=Q(:,z);
e=W(:,:,z);
LOC=zeros(1,size(e,3));
for i=1:size(e,3)

    a=e(1,:,i);
    b=e(2,:,i);
    tmp1=sum(b==a(1));
    if tmp1>0
        LOC(i)=LOC(i)+1/2;
    else
        LOC(i)=LOC(i)-1/2;
    end
    tmp2=sum(b==a(2));
    if tmp2>0 & a(1)~=a(2)
        LOC(i)=LOC(i)+1/2;
    elseif tmp2<=0 & a(1)~=a(2)
        LOC(i)=LOC(i)-1/2;
    end
end
mean(LOC)