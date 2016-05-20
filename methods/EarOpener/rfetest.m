d=APLO2.d1.default.c1420;

e=d.rfe.excluded;
i=numel(e);

F=ones(64,64);
figure
for i=1:i

    a=find(F>0);
    b=a(e{i});
    F(b)=0;
    imagesc(F)
    %pause  
end



