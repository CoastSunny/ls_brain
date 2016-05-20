clear cool cools coolf ncool ncools ncoolf ncoolfs
method=2;
cheating_bias=00;-140;
offset=0;
K=9;
xax=1+offset:K;
cool=[];cools=[];coolf=[];
for N=1+offset:K
    m2=N;
    embc
    synchperf_d1
    synchperf_cross
    cool(N-offset,:) =...
        [min(TTD2)  median(TTD2) max(TTD2)  ...
        min(TTD) nanmedian(TTD)  max(TTD) nanmean(TTD) ]*6;
    cools(N-offset,:) =...
        [min(sTTD2)  median(sTTD2) max(sTTD2)  ...
        min(sTTD) median(sTTD)  max(sTTD) ]*6;
    coolf(N-offset,:)=[min(amfpr2) mean(amfpr2) max(amfpr2) median(amfpr2)...
        min(amfpr) mean(amfpr) max(amfpr) median(amfpr)];
    coolfs(N-offset,:)=[std(amfpr2) std(amfpr)];
    synchperf_d1_nrow
    synchperf_cross_nrow
    ncool(N-offset,:) =...
        [min(TTD2)  median(TTD2) max(TTD2)  ...
        min(nTTD) nanmedian(nTTD)  max(nTTD) nanmean(nTTD) ]*6;
    ncools(N-offset,:) =...
        [min(nsTTD2)  median(nsTTD2) max(nsTTD2)  ...
        min(nsTTD) median(nsTTD)  max(nsTTD) ]*6;
    ncoolf(N-offset,:)=[min(amfpr2) mean(amfpr2) max(amfpr2) median(amfpr2)...
        min(amfpr) mean(amfpr) max(amfpr) median(amfpr)];
    ncoolfs(N-offset,:)=[std(amfpr2) std(amfpr)];
    
end

% figure,errorbar((cool(:,2)+cool(:,5))/2,(cools(:,2)+cools(:,5))/2)
% figure,errorbar((cool(:,3)+cool(:,6))/2,(cools(:,3)+cools(:,6))/2)
% figure,errorbar((cool(:,1)+cool(:,4))/2,(cools(:,1)+cools(:,4))/2)

% figure,errorbar((cool(:,5)),(cools(:,5)),'Linewidth',3)
% figure,errorbar((cool(:,6)),(cools(:,6)),'Linewidth',3)
% figure,errorbar((cool(:,4)),(cools(:,4)),'Linewidth',3)

% figure,
% subplot(1,3,1)
% errorbar(xax,(cool(:,2)),(cools(:,2)),'Linewidth',3)
% xlabel('number of combined trials'),ylabel('response time in seconds'),title('median response time')
% subplot(1,3,2)
% errorbar(xax,(cool(:,3)),(cools(:,3)),'Linewidth',3)
% xlabel('number of combined trials'),ylabel('response time in seconds'),title('maximum response time')
% subplot(1,3,3)
% errorbar(xax,(cool(:,1)),(cools(:,1)),'Linewidth',3)
% xlabel('number of combined trials'),ylabel('response time in seconds'),title('minimum response time')
% 
% figure,
% subplot(1,3,1)
% errorbar(xax,(cool(:,5)),(cools(:,5)),'Linewidth',3)
% xlabel('number of combined trials'),ylabel('response time in seconds'),title('median response time')
% subplot(1,3,2)
% errorbar(xax,(cool(:,6)),(cools(:,6)),'Linewidth',3)
% xlabel('number of combined trials'),ylabel('response time in seconds'),title('maximum response time')
% subplot(1,3,3)
% errorbar(xax,(cool(:,4)),(cools(:,4)),'Linewidth',3)
% xlabel('number of combined trials'),ylabel('response time in seconds'),title('minimum response time')

ax=[1 9 0 50];
figure,subplot(2,2,1)
%subplot(1,2,1)
%errorbar(xax,(cool(:,2)),(cools(:,2)),'Linewidth',3),axis(ax)
%hold on
%plot(xax,cool(:,1),'Linewidth',3)
%plot(xax,cool(:,3),'Linewidth',3)
%xlabel('number of combined trials'),ylabel('response time in seconds'),title('Training Dataset')
%subplot(1,2,2)

[haxes,hline1,hline2]=plotyy(xax,cool(:,[5 7]),xax,cool(:,6))

ylabel(haxes(1),'mean/median RT (sec)') % label left y-axis
ylabel(haxes(2),'max RT (sec)') % label right y-axis
xlabel(haxes(2),'number of combined trials') % label x-axis
set(hline1(1),'LineStyle','-','LineWidth',3);
set(hline1(2),'LineStyle','-.','LineWidth',3);
set(hline2,'LineStyle','--','LineWidth',3);
legend({'median Response Time' 'mean Response Time' 'max Response Time'});

ax=[0 10 0 0.15];
subplot(2,2,2)
hold on,
plot(xax,(coolf(:,6)),'Linewidth',3,'LineStyle','-.','Color','g'),axis(ax)
plot(xax,(coolf(:,8)),'Linewidth',3,'Color','b'),axis(ax)
plot(xax,(coolf(:,7)),'Linewidth',3,'LineStyle','--','Color','r'),axis(ax)
xlabel('number of combined trials'),ylabel('FPR')
legend({'mean FPR' 'median FPR' 'max FPR'});

ax=[2 13 0 200];
subplot(2,2,3)
%subplot(1,2,1)
%errorbar(xax,(cool(:,2)),(cools(:,2)),'Linewidth',3),axis(ax)
%hold on
%plot(xax,cool(:,1),'Linewidth',3)
%plot(xax,cool(:,3),'Linewidth',3)
%xlabel('number of combined trials'),ylabel('response time in seconds'),title('Training Dataset')
%subplot(1,2,2)

[haxes,hline1,hline2]=plotyy(xax,ncool(:,[5 7]),xax,ncool(:,6))

ylabel(haxes(1),'mean/median RT (sec)') % label left y-axis
ylabel(haxes(2),'max RT (sec)') % label right y-axis
xlabel(haxes(2),'number of combined trials') % label x-axis
set(hline1(1),'LineStyle','-','LineWidth',3);
set(hline1(2),'LineStyle','-.','LineWidth',3);
set(hline2,'LineStyle','--','LineWidth',3);
legend({'median Response Time' 'mean Response Time' 'max Response Time'});
%errorbar(xax,(cool(:,5)),(cools(:,5)),'Linewidth',3),axis(ax)
%plot(xax,cool(:,6),'Linewidth',3)
%title('Holdout Dataset')
ax=[0 10 0 0.15];
subplot(2,2,4)
hold on,
plot(xax,(ncoolf(:,6)),'Linewidth',3,'LineStyle','-.','Color','g'),axis(ax)
plot(xax,(ncoolf(:,8)),'Linewidth',3,'Color','b'),axis(ax)
plot(xax,(ncoolf(:,7)),'Linewidth',3,'LineStyle','--','Color','r'),axis(ax)
xlabel('number of combined trials'),ylabel('FPR')
legend({'mean FPR' 'median FPR' 'max FPR'});% % ax=[1 13 -0.07 0.07];
% % figure,
% % subplot(1,2,1)
% % errorbar(xax,(coolf(:,4)),(coolfs(:,1)),'Linewidth',3),axis(ax)
% % xlabel('number of combined trials'),ylabel('response time in seconds'),title('median FPR')
% % subplot(1,2,2)
% % errorbar(xax,(coolf(:,8)),(coolfs(:,2)),'Linewidth',3),axis(ax)
% % xlabel('number of combined trials'),ylabel('response time in seconds'),title('median FPR')
% 


% ax=[1 13 0 250];
% figure,
% hold on
% plot(xax,(cool(:,3)),'Linewidth',3),axis(ax)
% plot(xax,(cool(:,6)),'Linewidth',3,'Color','r'),axis(ax)
% xlabel('number of combined trials'),ylabel('response time inseconds'),title('Worst Subject RT')
% legend({'Training Dataset' 'Holdout Dataset'})
