
f1=[];
f2=[];
f3=[];
f4=[];
for fii=1:50
for fj=9:54
    embc
    f1(fj-8,fii)=GsavC(3,end);
    f2(fj-8,fii)=GnrowC(3,end);
    f3(fj-8,fii)=max(GsavC(3,1:end-1));
    f4(fj-8,fii)=max(GnrowC(3,1:end-1));
end
end
figure,plot(mean(f1)),hold on,plot(mean(f2),'r')
figure,plot(mean(f3)),hold on,plot(mean(f4),'r')