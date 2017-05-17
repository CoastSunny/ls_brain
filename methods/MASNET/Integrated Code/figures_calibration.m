% Loads values for the Pd and BER obtained in the calibration and plots
% figures

clear all
close all

load('Results_Calibration_TE_0_sigma_9dB_Fading_yes_all_together.mat')
Pd_fading = mean(Pd);
BER_BPSK_fading = mean(Pe_BPSK);
SNR_fading = SNR_;

load('Results_Calibration_TE_0_sigma_9dB_Fading_no.mat')
Pd_SHD = mean(Pd);
BER_BPSK_SHD = mean(Pe_BPSK);
SNR_SHD = SNR_;

load('Results_Calibration_TE_0_sigma_0dB_Fading_no.mat')
Pd_AWGN = Pd;
BER_BPSK_AWGN = Pe_BPSK;
SNR_AWGN = SNR_;

figure(1)
plot(SNR_AWGN,Pd_AWGN)
hold on
plot(SNR_SHD,Pd_SHD,'-xk')
plot(SNR_fading,Pd_fading,'-or')
hold off
title('Probability of detection vs SNR')
xlabel('SNR [dB]')
ylabel('Pd')
legend('AWGN','Shadowing','Fading')

figure(2)
plot(SNR_AWGN,BER_BPSK_AWGN)
hold on
plot(SNR_SHD,BER_BPSK_SHD,'-xk')
plot(SNR_fading,BER_BPSK_fading,'-or')
hold off
title('Bit Error Rate vs SNR')
xlabel('SNR [dB]')
ylabel('BER')
legend('AWGN','Shadowing','Fading')