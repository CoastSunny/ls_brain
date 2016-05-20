wax=[3 15 0.5 1];
xx=[6 9 12 15];
xxe=[ 3 6 9 12 15];
ctick=[1.5 4.5 10.5 13.5];
ctick=[3 6 9 12 15];
LW1=2;
bino_col=[0.8 0.8 0.8];
nirs='ro-';
eeg='gs-';
comb='bd-';
figure,hold on
plot(xx,mean(Cnaverage_nirsAMf),nirs,'Linewidth',LW1)
plot(xxe,mean(Ccaverage_eegAM),eeg,'Linewidth',LW1)
plot(xxe,mean(Cnaverage_combAMf),comb,'Linewidth',LW1)
set(gca,'XTick',ctick)
set(gca,'XTickLabel',{'1.5' '4.5' '7.5' '10.5' '13.5'})
xlabel('time(s)'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color',bino_col)

figure,hold on
plot(xx,mean(Tnaverage_nirsAMf),nirs,'Linewidth',LW1)
plot(xxe,mean(Tcaverage_eegAM),eeg,'Linewidth',LW1)
plot(xxe,mean(Tnaverage_combAMf),comb,'Linewidth',LW1)
set(gca,'XTick',ctick)
set(gca,'XTickLabel',{'1.5' '4.5' '7.5' '10.5' '13.5'})
xlabel('time(s)'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color',bino_col)

figure,hold on
plot(xx,mean(Cnaverage_nirsIMf),nirs,'Linewidth',LW1)
plot(xxe,mean(Ccaverage_eegIM),eeg,'Linewidth',LW1)
plot(xxe,mean(Cnaverage_combIMf),comb,'Linewidth',LW1)
set(gca,'XTick',ctick)
set(gca,'XTickLabel',{'1.5' '4.5' '7.5' '10.5' '13.5'})
xlabel('time(s)'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color',bino_col)

figure,hold on
plot(xx,mean(Tnaverage_nirsIMf),nirs,'Linewidth',LW1)
plot(xxe,mean(Tcaverage_eegIM),eeg,'Linewidth',LW1)
plot(xxe,mean(Tnaverage_combIMf),comb,'Linewidth',LW1)
set(gca,'XTick',ctick)
set(gca,'XTickLabel',{'1.5' '4.5' '7.5' '10.5' '13.5'})
xlabel('time(s)'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);
line([3 15],[.622 .622],[1 1],'LineStyle','-','LineWidth',2,'Color',bino_col)

figmerge([1 2 3 4])
legend({'nirs-cum' 'eeg-cum' 'combined-cum' 'binomial confidence'})