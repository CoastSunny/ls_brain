wax=[3 15 0.5 1];
xx=[3 6 9 12 15];
LW1=3;
nirs='r-';
eeg='g-';
comb='b-';
figure,hold on
plot(xx,mean(Cgaverage_nirsAMf),'r-.','Linewidth',LW1)
plot(xx,mean(Cgaverage_eegAM),'g-.','Linewidth',LW1)
plot(xx,mean(Cgaverage_combAMf),'b-.','Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figure,hold on
plot(xx,mean(Tgaverage_nirsAMf),'r-.','Linewidth',LW1)
plot(xx,mean(Tgaverage_eegAM),'g-.','Linewidth',LW1)
plot(xx,mean(Tgaverage_combAMf),'b-.','Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figure,hold on
plot(xx,mean(Cgaverage_nirsIMf),'r-.','Linewidth',LW1)
plot(xx,mean(Cgaverage_eegIM),'g-.','Linewidth',LW1)
plot(xx,mean(Cgaverage_combIMf),'b-.','Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figure,hold on
plot(xx,mean(Tgaverage_nirsIMf),'r-.','Linewidth',LW1)
plot(xx,mean(Tgaverage_eegIM),'g-.','Linewidth',LW1)
plot(xx,mean(Tgaverage_combIMf),'b-.','Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figmerge([1 2 3 4])
legend({'nirs-indi' 'eeg-indi' 'combined-indi' 'nirs-cum' 'eeg-cum' 'combined-cum'})