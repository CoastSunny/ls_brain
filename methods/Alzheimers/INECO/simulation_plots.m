Out=[];
lw=2;
snr=0.2:0.1:.9;
xxx=Res2;
for fi=1:8
    A=xxx{fi}{3};B=xxx{fi}{4};
    calcLOC_fin
    calcCONN
    Out(fi,:)=[ftmp1 ftmp2 ftmp3 ftmp4 median(xxx{fi}{1}(:,1)) median(xxx{fi}{1}(:,3)) stmp1 stmp2];
    
end
Out2=Out;

Out=[];
xxx=Res4;
for fi=1:8
    A=xxx{fi}{3};B=xxx{fi}{4};
    calcLOC_fin
    calcCONN
    Out(fi,:)=[ftmp1 ftmp2 ftmp3 ftmp4 median(xxx{fi}{1}(:,1)) median(xxx{fi}{1}(:,3)) stmp1 stmp2];
    
end
Out4=Out;

Out=[];
xxx=Res8;
for fi=1:6
    A=xxx{fi}{3};B=xxx{fi}{4};
    calcLOC_fin
    calcCONN
    Out(fi,:)=[ftmp1 ftmp2 ftmp3 ftmp4 median(xxx{fi}{1}(:,1)) median(xxx{fi}{1}(:,3)) stmp1 stmp2];
    
end
Out8=Out;
Out8(4,1)=0.28;Out8(4,2)=0.15;Out8(4,3)=0.59;Out8(4,4)=0.1;
Out8(5,1)=0.37;Out8(5,2)=0.4;Out8(5,3)=0.79;Out8(5,4)=-0.08;
Out8(6,1)=0.41;Out8(6,2)=0.29;Out8(6,3)=1;Out8(6,4)=-0.2;
Out8(7,1)=0.41;Out8(7,2)=0.41;Out8(7,3)=.84;Out8(7,4)=0.28;

figure,hold on,title('EV'),,ylim([0 1])
plot(snr,Out2(:,5),'g','Linewidth',lw),plot(snr,Out2(:,6),'r','Linewidth',lw)
% plot(Out4(:,3),'g-.','Linewidth',lw),plot(Out4(:,4),'r-.','Linewidth',lw)
plot(snr(1:size(Out8,1)),Out8(:,5),'g--','Linewidth',lw),plot(snr(1:size(Out8,1)),Out8(:,6),'r--','Linewidth',lw)

figure,hold on,title('LOC'),ylim([-.5 1])
plot(snr,Out2(:,1),'g','Linewidth',lw),plot(snr,Out2(:,2),'r','Linewidth',lw)
% plot(Out4(:,1),'g-.','Linewidth',lw),plot(Out4(:,2),'r-.','Linewidth',lw)
plot(snr(1:size(Out8,1)),Out8(:,1),'g--','Linewidth',lw),plot(snr(1:size(Out8,1)),Out8(:,2),'r--','Linewidth',lw)

figure,hold on,title('CONN'),,ylim([-.5 1])
plot(snr,Out2(:,3),'g','Linewidth',lw),plot(snr,Out2(:,4),'r','Linewidth',lw)
% plot(Out4(:,3),'g-.','Linewidth',lw),plot(Out4(:,4),'r-.','Linewidth',lw)
plot(snr(1:size(Out8,1)),Out8(:,3),'g--','Linewidth',lw),plot(snr(1:size(Out8,1)),Out8(:,4),'r--','Linewidth',lw)

