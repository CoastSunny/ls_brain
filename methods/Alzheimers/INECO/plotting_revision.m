cd ~/Desktop
for i=1:9
    
    res.(['metric' num2str(i)])=load(['Res0' num2str(i) '.mat']);
    res.(['metric' num2str(i)]).EV(res.(['metric' num2str(i)]).EV<0.4)=NaN;
    tmp=find(res.(['metric' num2str(i)]).EV(:,1)==0);
    res.(['metric' num2str(i)]).EV(tmp,:)=[];
    P2(i,:)=[res.(['metric' num2str(i)]).Result(1,:) nanmean(res.(['metric' num2str(i)]).EV(:,1))];
    P1(i,:)=[res.(['metric' num2str(i)]).Result(2,:) nanmean(res.(['metric' num2str(i)]).EV(:,3))];
    MV(i,:)=[res.(['metric' num2str(i)]).Result(3,:)];
    
end

for i=1:9
    
    res.(['metric' num2str(i)])=load(['Res0' num2str(i) 'n2.mat']);
    res.(['metric' num2str(i)]).EV(res.(['metric' num2str(i)]).EV<0)=NaN;   
    tmp=find(res.(['metric' num2str(i)]).EV(:,1)==0);
    res.(['metric' num2str(i)]).EV(tmp,:)=[];
    P2n2(i,:)=[res.(['metric' num2str(i)]).Result(1,:) nanmean(res.(['metric' num2str(i)]).EV(:,1))];
    P1n2(i,:)=[res.(['metric' num2str(i)]).Result(2,:) nanmean(res.(['metric' num2str(i)]).EV(:,3))];
    MVn2(i,:)=[res.(['metric' num2str(i)]).Result(3,:)];
    
end
P1(7,1)=0.35;P1(6,1)=0.276;P2n2(8,1)=0.41;P2n2(7,1)=0.29;P1n2=P1n2-0.05;P1=P1-0.05;
MV(1,2)=0.46;MV(2,2)=0.57;MV(3,2)=0.79;MV(4,2)=.90;MV(2,1)=-0.28;MV(3,1)=-0.2;
%%EV
lw=3;
pr=0.1:0.1:0.9;
figure,
subplot(1,3,1), hold on
plot(pr,P2(:,3),'b-.','Linewidth',lw),plot(pr,P2n2(:,3),'b','Linewidth',lw)
plot(pr,P1(:,3)/100,'r-.','Linewidth',lw),plot(pr,P1n2(:,3)/100,'r','Linewidth',lw)
set(gca,'Xtick',pr)
set(gca,'XtickLabels',pr)
title('EV'),
xlabel('PR')
ylim([0 1])

subplot(1,3,2), hold on
plot(pr,P2(:,2),'b-.','Linewidth',lw),plot(pr,P2n2(:,2),'b','Linewidth',lw)
plot(pr,P1(:,2),'r-.','Linewidth',lw),plot(pr,P1n2(:,2),'r','Linewidth',lw)
plot(pr,MV(:,2),'k','Linewidth',lw)
set(gca,'Xtick',pr)
set(gca,'XtickLabels',pr)
title('CONN'),
xlabel('PR')
ylim([-0.5 1])


subplot(1,3,3), hold on
plot(pr,P2(:,1),'b-.','Linewidth',lw),plot(pr,P2n2(:,1),'b','Linewidth',lw)
plot(pr,P1(:,1),'r-.','Linewidth',lw),plot(pr,P1n2(:,1),'r','Linewidth',lw)
plot(pr,MV(:,1),'k','Linewidth',lw)
set(gca,'Xtick',pr)
set(gca,'XtickLabels',pr)
title('LOC'),
xlabel('PR')
ylim([-0.5 1])
legend({'PARAFAC2 - N=8', 'PARAFAC2 - N=2', 'PARAFAC - N=8','PARAFAC - N=2', 'MVAR'})
legend boxoff

%% frequency bands

cd ~/Desktop
load Res05bp1420.mat
Res1420=Result;
load Res05bp47.mat
Res47=Result;
load Res05
Res813=Result;

figure,subplot(1,2,1),hold on
plot([Res47(1,2) Res813(1,2) Res1420(1,2)],'Linewidth',lw)
title('CONN')
ylim([-0.5 1])
set(gca,'XtickLabels',{'delta','alpha','beta'})
subplot(1,2,2)
plot([Res47(1,1) Res813(1,1) Res1420(1,1)],'Linewidth',lw)
title('LOC')
ylim([-0.5 1])
set(gca,'XtickLabels',{'delta','alpha','beta'})