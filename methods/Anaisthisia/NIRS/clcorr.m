Rc=[];Rp=[];
for i=1:15
    
    a=Nf{1,6,i};
    b=Ef{1,2,i};
    a=a(13:end,2:5);
    b=b(13:end,2:5);
    a=a(:);b=b(:);b=-b;
    [r p]=corrcoef(a,b);
    Rc(end+1)=r(1,2);
    Rp(end+1)=p(1,2);
    
end

for i=1:15
    
    a=Nf{1,5,i};
    b=Ef{1,1,i};
    a=a(13:end,2:5);
    b=b(13:end,2:5);
    a=a(:);b=b(:);b=-b;
    [r p]=corrcoef(a,b);
    Rc(end+1)=r(1,2);
    Rp(end+1)=p(1,2);
    
end

for i=1:15
    
    a=Nf{1,6,i};
    b=Ef{1,2,i};
    a=a(1:12,2:5);
    b=b(1:12,2:5);
    a=a(:);b=b(:);b=-b;
    [r p]=corrcoef(a,b);
    Rc(end+1)=r(1,2);
    Rp(end+1)=p(1,2);
    
end

for i=1:15   
    
    a=Nf{1,5,i};
    b=Ef{1,1,i};
    a=a(1:12,2:5);
    b=b(1:12,2:5);
    a=a(:);b=b(:);b=-b;
    [r p]=corrcoef(a,b);
    Rc(end+1)=r(1,2);
    Rp(end+1)=p(1,2);
    
end