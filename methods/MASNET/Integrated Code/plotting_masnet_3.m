% load Probs_CORRSHD_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-43dBW_sigma_9dB.mat
% pfa=0.01:0.01:0.1;
% idx=5;
% figure
% hold on
% plot(pfa,psep_d(idx,:))
% plot(pfa,pdiv_d(idx,:),'r')
% plot(pfa,pbest_d(idx,:),'g')
% xlabel('Probability false alarm')
% ylabel('Probability of detection')
% title('Separated - Urban - Pt:-43dBW - SxF:5')
cd ~/Documents/projects/ls_brain/results/masnet/probs

load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_1_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
idx=1;
ff=1;
sens=(1:96);
figure
hold on
% errorbar(sens,pall_av(:,idx),pall_std(:,idx),'b')
plot(sens,pbsens_av(:,idx),'r')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_2_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_3_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_4_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_5_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_6_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_7_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_8_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_9_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_10_TS_1_TE_0_Num_Sensors_96_SepTar_500_500_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
xlim([1 96])
set(gca,'Xtick',0:4:97)
set(gca,'XtickLabel',(0:4:97)*ff)
xlabel('Number of Sensors'), ylabel('Probability of detection')
title('t:1-10 - Pt:-33dbW - pfa:0.01 - mixed')
legend boxoff 


load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_1_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
idx=1;
ff=1;
sens=(1:96);
figure
hold on
% errorbar(sens,pall_av(:,idx),pall_std(:,idx),'b')
plot(sens,pbsens_av(:,idx),'r')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_2_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_3_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_4_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_5_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_6_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_7_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_8_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_9_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_Time_10_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'g')
xlim([1 96])
ylim([0.85 1])
set(gca,'Xtick',0:1:97)
set(gca,'XtickLabel',(0:1:97)*ff)
xlabel('Number of Sensors'), ylabel('Probability of detection')
title('t:1-10 - Pt:-33dbW - pfa:0.01 - separated')
legend boxoff 

load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
idx=1;
ff=1;
sens=(1:96);
figure
hold on
plot(sens,pbsens_av(:,idx),'r')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_NOCP_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'g')
load ~/Documents/projects/ls_brain/results/masnet/probs/Probs_CORRSHD_PSS_TS_0_TE_0_Num_Sensors_96_SepTar_50_50_Pt_-33dBW_sigma_9dB
plot(sens,pbsens_av(:,idx),'b')
xlim([1 96])
ylim([0 1])
set(gca,'Xtick',0:4:97)
set(gca,'XtickLabel',(0:4:97)*ff)
xlabel('Number of Sensors'), ylabel('Probability of detection')
title('t:1 - Pt:-33dbW - pfa:0.01 - separated')
legend({'OFDM' 'no CP' 'PSS'})
legend boxoff 


