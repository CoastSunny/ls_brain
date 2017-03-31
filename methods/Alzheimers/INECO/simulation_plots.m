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
for fi=1:7
    A=xxx{fi}{3};B=xxx{fi}{4};
    calcLOC_fin
    calcCONN
    Out(fi,:)=[ftmp1 ftmp2 ftmp3 ftmp4 median(xxx{fi}{1}(:,1)) median(xxx{fi}{1}(:,3)) stmp1 stmp2];
    
end
Out8=Out;

figure,subplot(1,3,1),hold on,title('EV'),,ylim([0 1]),xlim([0.2 0.91])
plot(snr,Out2(:,5),'b','Linewidth',lw),plot(snr,Out2(:,6)/100,'r','Linewidth',lw)
% plot(Out4(:,3),'g-.','Linewidth',lw),plot(Out4(:,4),'r-.','Linewidth',lw)
plot(snr(1:size(Out8,1)),Out8(:,5),'b--','Linewidth',lw),plot(snr(1:size(Out8,1)),Out8(:,6)/100,'r--','Linewidth',lw)

subplot(1,3,2),,hold on,title('CONN'),,ylim([-.5 1]),xlim([0.2 0.9])
plot(snr,Out2(:,3),'b','Linewidth',lw),plot(snr,Out2(:,4),'r','Linewidth',lw)
% plot(Out4(:,3),'g-.','Linewidth',lw),plot(Out4(:,4),'r-.','Linewidth',lw)
plot(snr(1:size(Out8,1)),Out8(:,3),'b--','Linewidth',lw),plot(snr(1:size(Out8,1)),Out8(:,4),'r--','Linewidth',lw)

subplot(1,3,3),,hold on,title('LOC'),ylim([-.5 1]),xlim([0.2 0.9])
plot(snr,Out2(:,1),'b','Linewidth',lw),plot(snr,Out2(:,2),'r','Linewidth',lw)
% plot(Out4(:,1),'g-.','Linewidth',lw),plot(Out4(:,2),'r-.','Linewidth',lw)
plot(snr(1:size(Out8,1)),Out8(:,1),'b--','Linewidth',lw),plot(snr(1:size(Out8,1)),Out8(:,2),'r--','Linewidth',lw)

