wax=[3 15 0.5 1];
xx=[3 6 9 12 15];
LW1=3;
nirs='r';
eeg='g-';
comb='b';
figure,hold on
plot(xx,mean(Ccaverage_nirsAMf),nirs,'Linewidth',LW1)
plot(xx,mean(Ccaverage_eegAM),eeg,'Linewidth',LW1)
plot(xx,mean(Ccaverage_combAMf),comb,'Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figure,hold on
plot(xx,mean(Tcaverage_nirsAMf),nirs,'Linewidth',LW1)
plot(xx,mean(Tcaverage_eegAM),eeg,'Linewidth',LW1)
plot(xx,mean(Tcaverage_combAMf),comb,'Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figure,hold on
plot(xx,mean(Ccaverage_nirsIMf),nirs,'Linewidth',LW1)
plot(xx,mean(Ccaverage_eegIM),eeg,'Linewidth',LW1)
plot(xx,mean(Ccaverage_combIMf),comb,'Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figure,hold on
plot(xx,mean(Tcaverage_nirsIMf),nirs,'Linewidth',LW1)
plot(xx,mean(Tcaverage_eegIM),eeg,'Linewidth',LW1)
plot(xx,mean(Tcaverage_combIMf),comb,'Linewidth',LW1)
set(gca,'XTick',[3 6 9 12 15])
xlabel('time in seconds'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color','k')

figmerge([1 2 3 4])
legend({'nirs' 'eeg' 'combined'})