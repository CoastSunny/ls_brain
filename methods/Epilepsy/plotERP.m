tm=(-32:32)/200;

for si=1:numel(subj)
    
    eval(['sEEG=' subj{si} '_sEEG;']);  
    eval(['iEEG=' subj{si} '_iEEG;']);
   
    subplot(9,2,2*si-1)
    plot(tm,mean(sEEG,3)')
    subplot(9,2,2*si)
    plot(tm,mean(iEEG,3)')
end