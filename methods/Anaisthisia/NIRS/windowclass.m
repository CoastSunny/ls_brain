figure,hold on
title('Controls Actual Movement Window-Class Rate')
plot(mean(Ccaverage_eegAM),'r')
plot(mean(Ccaverage_nirsAMf),'g')
plot(mean(Ccaverage_combAMf),'b')

plot(mean(Cgaverage_eegAM),'r-.')
plot(mean(Cgaverage_nirsAMf),'g-.')
plot(mean(Cgaverage_combAMf),'b-.')
legend({'eeg-comb' 'nirs-comb' 'both-comb' 'eeg-indi' 'nirs-indi' 'both-indi'});
figure,hold on
title('Patients Attempted Movement Window-Class Rate')

plot(mean(Tcaverage_eegAM),'r')
plot(mean(Tcaverage_nirsAMf),'g')
plot(mean(Tcaverage_combAMf),'b')

plot(mean(Tgaverage_eegAM),'r-.')
plot(mean(Tgaverage_nirsAMf),'g-.')
plot(mean(Tgaverage_combAMf),'b-.')
legend({'eeg-comb' 'nirs-comb' 'both-comb' 'eeg-indi' 'nirs-indi' 'both-indi'});