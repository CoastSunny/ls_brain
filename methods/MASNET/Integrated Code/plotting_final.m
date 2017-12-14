if isunix==0
    cd C:\Users\Loukianos\Documents\MATLAB\ls_brain\results\masnet\probs\
else
    cd ~/Documents/ls_brain/results/masnet/probs/
end

%% QUANTILES
idx=10;
ff=1;
sens=(1:20);
figure
hold on

load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),...
    pbsens_av(sens,idx)-pbsens_q(sens,idx,1),pbsens_q(sens,idx,2)-pbsens_av(sens,idx)...
    ,'-o','Linewidth',2)
load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),...
    pbsens_av(sens,idx)-pbsens_q_noloc(sens,idx,1),pbsens_q_noloc(sens,idx,2)-pbsens_av(sens,idx)...
    ,'-o','Linewidth',2)
legend({'location uncertainty' 'channel variance' })
legend boxoff
title('Quantiles - Pt:-33dbW - Separated/Urban')
ylabel('Probability of detection')
xlabel('Number of sensors')

figure
hold on

load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),...
    pbsens_av(sens,idx)-pbsens_q(sens,idx,1),pbsens_q(sens,idx,2)-pbsens_av(sens,idx)...
    ,'-o','Linewidth',2)
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),...
    pbsens_av(sens,idx)-pbsens_q_noloc(sens,idx,1),pbsens_q_noloc(sens,idx,2)-pbsens_av(sens,idx)...
    ,'-o','Linewidth',2)
legend({'location uncertainty' 'channel variance' })
legend boxoff
title('Quantiles - Pt:-33dbW - Mixed/Urban')
ylabel('Probability of detection')
xlabel('Number of sensors')

%% ERROR BOUNDS
idx=10;
ff=1;
sens=(1:50);
figure
hold on

load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),pbsens_std(sens,idx),'Linewidth',2)
load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),pbsens_noloc_std(sens,idx),'Linewidth',2)
legend({'location uncertainty' 'channel variance' })
legend boxoff
title('Error bounds - Pt:-33dbW - Separated/Urban')
ylabel('Probability of detection')
xlabel('Number of sensors')

figure
hold on

load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),pbsens_std(sens,idx),'Linewidth',2)
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,pbsens_av(sens,idx),pbsens_noloc_std(sens,idx),'Linewidth',2)
legend({'location uncertainty' 'channel variance' })
legend boxoff
title('Error bounds - Pt:-33dbW - Mixed/Urban')
ylabel('Probability of detection')
xlabel('Number of sensors')
%% PROTOCOLS
idx=10;
ff=1;
sens=(1:50);
esens=[1 5:5:50];
figure
hold on
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(esens,pbsens_av(esens,idx),pbsens_std(esens,idx),'o','Linewidth',2,'Color','b')
plot(sens,pbsens_av(sens,idx),'Linewidth',2,'Color','b')
load Pr_nocp_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(esens,pbsens_av(esens,idx),pbsens_std(esens,idx),'o','Linewidth',2,'Color','r')
plot(sens,pbsens_av(sens,idx),'Linewidth',2,'Color','r')
load Pr_lte_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(esens,pbsens_av(esens,idx),pbsens_std(esens,idx),'o','Linewidth',2,'Color','g')
plot(sens,pbsens_av(sens,idx),'Linewidth',2,'Color','g')
ylabel('Probability of detection')
xlabel('Number of sensors')
title('Protocols - Pt:-33dbW - Mixed/Urban')
legend({'' 'OFDM' '' 'no protocol' '' 'LTE'  },'Location','Southeast')
legend boxoff


%% ROC curves
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
pfa=0.01:0.01:0.1;
figure
hold on
for i=1:20
    plot(pfa,pbsens_av(i,:),'Linewidth',2)
end
xlabel('Probability of false alarm')
ylabel('Probability of detection')
title('ROC - Pt:-33dbW - Mixed/Urban')
legend({'1 sensor' '2 sensors' '...'},'Location','southeast')
legend boxoff

%% Time
ff=1;
sens=(1:50);
figure
hold on
load Pr_ofdm_final_Time_10_tm_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
% errorbar(sens,pall_av(:,idx),pall_std(:,idx),'b')
plot(sens,pbsens_av(sens,idx),'r')
load Pr_ofdm_final_Time_10_tm_2_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_3_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_4_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_5_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_6_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_7_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_8_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')
load Pr_ofdm_final_Time_10_tm_9_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'g')
load Pr_ofdm_final_Time_10_tm_10_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b')

xlabel('Number of Sensors'), ylabel('Probability of detection')
title('t:1-10 - Pt:-33dbW - Mixed/Urban')
legend boxoff 

%% Power
sens=(1:50);
figure
hold on
load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-23dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b','Linewidth',2)
load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'g','Linewidth',2)
load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-43dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'r','Linewidth',2)
legend({'-23dbW' '-33dbW' '-43dbW'}),legend boxoff
title('Transmit Power effect - Separated/Urban')
ylabel('Probability of detection')
xlabel('Number of sensors')
ylim([0 1])
xlim([1 sens(end)])

sens=(1:50);
figure
hold on
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-23dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'b','Linewidth',2)
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'g','Linewidth',2)
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-43dBW_sigma_9dB
plot(sens,pbsens_av(sens,idx),'r','Linewidth',2)
legend({'-23dbW' '-33dbW' '-43dbW'}),legend boxoff
title('Transmit Power effect - Mixed/Urban')
ylabel('Probability of detection')
xlabel('Number of sensors')
ylim([0 1])
xlim([1 sens(end)])

%% BER

sens=(1:50);
idx=10;
figure

load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
semilogy(sens,eb_bpsk_av(sens,idx),'Linewidth',2)
hold on
semilogy(sens,eb_qpsk_av(sens,idx),'Linewidth',2)
semilogy(sens,eb_4am_av(sens,idx),'Linewidth',2)
semilogy(sens,eb_8am_av(sens,idx),'Linewidth',2)
xlabel('Number of sensors')
ylabel('BER')
title('BER for different modulation schemes - Mixed/Urban')
legend({'BPSK' 'QPSK' '4AM' '8AM'}), legend boxoff


load Pr_ofdm_final_Time_1_TS_0_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
semilogy(sens,eb_bpsk_av(sens,idx),'Linewidth',2)
hold on
semilogy(sens,eb_qpsk_av(sens,idx),'Linewidth',2)
semilogy(sens,eb_4am_av(sens,idx),'Linewidth',2)
semilogy(sens,eb_8am_av(sens,idx),'Linewidth',2)
xlabel('Number of sensors')
ylabel('BER')
title('BER for different modulation schemes - Separated/Urban')
legend({'BPSK' 'QPSK' '4AM' '8AM'}), legend boxoff


sens=(1:50);
idx=10;
figure

load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
plot(sens,log10(eb_bpsk_av(sens,idx)),'Linewidth',2)
hold on
plot(sens,log10(eb_qpsk_av(sens,idx)),'Linewidth',2)
plot(sens,log10(eb_4am_av(sens,idx)),'Linewidth',2)
plot(sens,log10(eb_8am_av(sens,idx)),'Linewidth',2)
xlabel('Number of sensors')
ylabel('BER')
title('BER for different modulation schemes - Mixed/Urban')
legend({'BPSK' 'QPSK' '4AM' '8AM'}), legend boxoff
set(gca,'YtickLabels',{'1' '10^{-1}' '10^{-2}' '10^{-3}' '10^{-4}' '10^{-5}' '10^{-6}'})


sens=(1:50);
idx=10;
figure
subplot(2,2,1)
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
errorbar(sens,log10(eb_bpsk_av(sens,idx)),...
    log10(eb_bpsk_av(sens,idx))-log10(eb_bpsk_q(sens,idx,1)),...
    log10(eb_bpsk_q(sens,idx,2))-log10(eb_bpsk_av(sens,idx))...
    ,'-o','Linewidth',2)
xlabel('Number of sensors')
ylabel('BPSK')
set(gca,'YtickLabels',{'1' '10^{-1}' '10^{-2}' '10^{-3}' '10^{-4}' '10^{-5}' '10^{-6}'})

subplot(2,2,2)
errorbar(sens,eb_qpsk_av(sens,idx),...
    eb_qpsk_av(sens,idx)-eb_qpsk_q(sens,idx,1),eb_qpsk_q(sens,idx,2)-eb_qpsk_av(sens,idx)...
    ,'-o','Linewidth',2)
xlabel('Number of sensors')
ylabel('QPSK')
subplot(2,2,3)
errorbar(sens,eb_4am_av(sens,idx),...
    eb_4am_av(sens,idx)-eb_4am_q(sens,idx,1),eb_4am_q(sens,idx,2)-eb_4am_av(sens,idx)...
    ,'-o','Linewidth',2)
xlabel('Number of sensors')
ylabel('4AM')
subplot(2,2,4)
errorbar(sens,eb_8am_av(sens,idx),...
    eb_8am_av(sens,idx)-eb_8am_q(sens,idx,1),eb_8am_q(sens,idx,2)-eb_8am_av(sens,idx)...
    ,'-o','Linewidth',2)
xlabel('Number of sensors')
ylabel('8AM')
title('BER for different modulation schemes - Mixed/Urban')







