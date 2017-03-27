Q=B;
W=A;
z=Q(1,:)==1;
b=Q(:,z);
e=W(:,:,z);
LOC=zeros(1,size(e,3));
for ci=1:size(e,3)

    a=e(1,:,ci);
    b=e(3,:,ci);
    tmp1=sum(b==a(1));
    if tmp1>0
        LOC(ci)=LOC(ci)+1/2;
    else
        LOC(ci)=LOC(ci)-1/2;
    end
    tmp2=sum(b==a(2));
    if tmp2>0 & a(1)~=a(2)
        LOC(ci)=LOC(ci)+1/2;
    elseif tmp2<=0 & a(1)~=a(2)
        LOC(ci)=LOC(ci)-1/2;
    end
%     if a(1)==a(2)
%     LOC(ci)=LOC(ci)-1/2;
%     end
end
ftmp1=mean(LOC)
stmp1=std(LOC);
LOC=zeros(1,size(e,3));
for ci=1:size(e,3)

    a=e(2,:,ci);
    b=e(3,:,ci);
    tmp1=sum(b==a(1));
    if tmp1>0
        LOC(ci)=LOC(ci)+1/2;
    else
        LOC(ci)=LOC(ci)-1/2;
    end
    tmp2=sum(b==a(2));
    if tmp2>0 & a(1)~=a(2)
        LOC(ci)=LOC(ci)+1/2;
    elseif tmp2<=0 & a(1)~=a(2)
        LOC(ci)=LOC(ci)-1/2;
    end
%     if a(1)==a(2)
%     LOC(ci)=LOC(ci)-1/2;
%     end
end
ftmp2=mean(LOC)
stmp2=std(LOC);