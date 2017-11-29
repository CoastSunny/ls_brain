cd C:\Users\Loukianos\Documents\MATLAB\ls_brain\results\masnet\probs\

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
figure
hold on
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
% errorbar(sens,pbsens_av(sens,idx),pbsens_std(sens,idx),'Linewidth',2)
plot(sens,pbsens_av(sens,idx),'Linewidth',2)
load Pr_nocp_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
% errorbar(sens,pbsens_av(sens,idx),pbsens_std(sens,idx),'Linewidth',2)
plot(sens,pbsens_av(sens,idx),'Linewidth',2)
load Pr_lte_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
% errorbar(sens,pbsens_av(sens,idx),pbsens_std(sens,idx),'Linewidth',2)
plot(sens,pbsens_av(sens,idx),'Linewidth',2)
ylabel('Probability of detection')
xlabel('Number of sensors')
title('Protocols - Pt:-33dbW - Mixed/Urban')
legend({'OFDM' 'no protocol' 'LTE'  })
legend boxoff


%% ROC curves
load Pr_ofdm_final_Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
pfa=0.01:0.01:0.1
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