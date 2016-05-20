
time_window=-16:16;
time_window2=-15:16;

figure, plot((time_window)/.200,mean(A_S_iEEG,3)')
xlabel('time(ms)'),ylabel(subj{1}),title('iEEG original')
figure, plot((time_window2)/.200,mean(A_S_ciEEG,3)')
xlabel('time(ms)'),ylabel(subj{1}),title('iEEG chirp2')

figure, plot((time_window)/.200,mean(B_G_iEEG,3)')
xlabel('time(ms)'),ylabel(subj{2})
figure, plot((time_window2)/.200,mean(B_G_ciEEG,3)')
xlabel('time(ms)'),ylabel(subj{2})

figure, plot((time_window)/.200,mean(E_N_iEEG,3)')
xlabel('time(ms)'),ylabel(subj{3})
figure, plot((time_window2)/.200,mean(E_N_ciEEG,3)')
xlabel('time(ms)'),ylabel(subj{3})

figure, plot((time_window)/.200,mean(C_R_iEEG,3)')
xlabel('time(ms)'),ylabel(subj{4})
figure, plot((time_window2)/.200,mean(C_R_ciEEG,3)')
xlabel('time(ms)'),ylabel(subj{4})

figure, plot((time_window)/.200,mean(D_L_iEEG,3)')
xlabel('time(ms)'),ylabel(subj{5})
figure, plot((time_window2)/.200,mean(D_L_ciEEG,3)')
xlabel('time(ms)'),ylabel(subj{5})
 
figmerge([1 3 5 7 9 2 4 6 8 10 ])