wax=[0 6 0.5 1];
figure,hold on
plot(mean(Cgaverage_nirsAMf),'r-.'),plot(mean(Cgaverage_eegAM),'g-.'),plot(mean(Cgaverage_combAMf),'b-.')
plot(mean(Ccaverage_nirsAMf),'r'),plot(mean(Ccaverage_eegAM),'g'),plot(mean(Ccaverage_combAMf),'b')
set(gca,'XTick',[1 2 3 4 5])
xlabel('window'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);

figure,hold on
plot(mean(Tgaverage_nirsAMf),'r-.'),plot(mean(Tgaverage_eegAM),'g-.'),plot(mean(Tgaverage_combAMf),'b-.')
plot(mean(Tcaverage_nirsAMf),'r'),plot(mean(Tcaverage_eegAM),'g'),plot(mean(Tcaverage_combAMf),'b')
set(gca,'XTick',[1 2 3 4 5])
xlabel('window'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-AM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);

figure,hold on
plot(mean(Cgaverage_nirsIMf),'r-.'),plot(mean(Cgaverage_eegIM),'g-.'),plot(mean(Cgaverage_combIMf),'b-.')
plot(mean(Ccaverage_nirsIMf),'r'),plot(mean(Ccaverage_eegIM),'g'),plot(mean(Ccaverage_combIMf),'b')
set(gca,'XTick',[1 2 3 4 5])
xlabel('window'),ylabel('accuracy')
title('Classifier accuracy per window, Controls-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);

figure,hold on
plot(mean(Tgaverage_nirsIMf),'r-.'),plot(mean(Tgaverage_eegIM),'g-.'),plot(mean(Tgaverage_combIMf),'b-.')
plot(mean(Tcaverage_nirsIMf),'r'),plot(mean(Tcaverage_eegIM),'g'),plot(mean(Tcaverage_combIMf),'b')
set(gca,'XTick',[1 2 3 4 5])
xlabel('window'),ylabel('accuracy')
title('Classifier accuracy per window, Patients-IM')
legend({'Ns' 'Es' 'Cs' 'Nc' 'Ec' 'Cc'},'Location','NorthWest')
axis(wax);

figmerge([1 2 3 4])
legend({'nirs' 'eeg' 'combined'})