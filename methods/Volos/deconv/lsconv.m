L=64;
A=cell2mat(D{11})';

for l=1:L
    
    delay=dfilt.delay(l-1);
    X1(l,:)=filter(delay,A(1,:));
    X2(l,:)=filter(delay,A(2,:));
    X3(l,:)=filter(delay,A(3,:));
    X4(l,:)=filter(delay,A(4,:));
    X5(l,:)=filter(delay,A(5,:));
    X6(l,:)=filter(delay,A(6,:));
    X7(l,:)=filter(delay,A(7,:));    

end

X=[X1;X2;X3;X4;X5;X6;X7];

h=zeros(1,448);
h(1:64:end)=1;
h(8:64:end)=1;
h(15+1)=1;
h(64+20)=1;
h(128+24)=1;
h(192+27)=1;
h(256+31)=1;
h(320+35)=1;
h(384+39)=1;
