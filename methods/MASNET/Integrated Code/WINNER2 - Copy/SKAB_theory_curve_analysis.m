%% Attempt to develop theoretical curve for SKAB performance.

clear

SKAB_results = load('SKAB_analysis6.mat');
R_auto_cor = SKAB_results.R_auto_cor;
R_auto_cor2 = SKAB_results.R_auto_cor2;
SNR_vec_dB = SKAB_results.SNR_vec_dB;
P_D = SKAB_results.P_D;
Pd_auto_rho = SKAB_results.Pd_auto_rho;
Pd_SK_auto_rho1 = SKAB_results.Pd_SK_auto_rho1;
Pd_SK_auto_rho2 = SKAB_results.Pd_SK_auto_rho2;
P_D_SKA = SKAB_results.P_D_SKA;
P_D_SKA2 = SKAB_results.P_D_SKA2;
R_auto_cor2_real_mean = SKAB_results.R_auto_cor2_real_mean;
R_auto_cor2_real_var = SKAB_results.R_auto_cor2_real_var;

plot(SNR_vec_dB,P_D,'-bs')
hold on; grid on
plot(SNR_vec_dB,Pd_auto_rho,'-rs')
plot(SNR_vec_dB,Pd_SK_auto_rho1,'-ms')
plot(SNR_vec_dB,Pd_SK_auto_rho2,'-cs')
plot(SNR_vec_dB,P_D_SKA,'-gs')
plot(SNR_vec_dB,P_D_SKA2,'-ks')


% Number of simulations at each SNR.
NDrops = 5000;

Pfa = 0.1;

% FFT size, CP size, FFO correction signal length.
T_d = 2048;  %512, 2048
T_c = 144;   %36, 144

% Sample length for the detector.
yffo_len = 2*T_d + T_c;
N_OFDM_symbols = 6;
M = N_OFDM_symbols*yffo_len;
M_in_algo = M - T_d;

% Phase PDF step.
phase_step = (2*pi)/180;
bins_P = [-pi:phase_step:pi];


% Uniform number LUT (based on the phase step).
uni_LUT = rand(1,length(bins_P));

% Sampling frequency (highest LTE).
fs = 30.72e6;

% Preallocations.
R_auto_sim_cor = zeros(length(SNR_vec_dB),NDrops);
R_auto_sim_cor_m = zeros(1,length(SNR_vec_dB));
rho_calc = zeros(1,length(SNR_vec_dB));
Pd_SKAB = zeros(1,length(SNR_vec_dB));
Pd_SKAB2 = zeros(1,length(SNR_vec_dB));
test_stat_cor_n = zeros(1,NDrops);
dec_auto_cor_n = zeros(1,NDrops);
R_auto_cor_n = zeros(1,NDrops);





% Noise calcs
precision_factor = 1/rho_calc(2);
offset_factor = (precision_factor^2)*((10/(sqrt(2*M_in_algo)))^2);
for Nd = 1:length(SNR_vec_dB)
     rho_calc(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_dB(Nd)/10))/((10^(SNR_vec_dB(Nd)/10)) + 1);
end

for NT = 1:NDrops
    % Create noise.
    noise_vec = randn(1,M) + j*randn(1,M);
    noise_vec_mean = mean(noise_vec);
    noise_vec_mean_std = std(noise_vec);
    noise_vec = noise_vec - noise_vec_mean;
    noise_vec = noise_vec/noise_vec_mean_std;
    
    % Autocorrelation for OFDM detection.
    [dec_auto_cor_n(NT), test_stat_cor_n(NT), R_auto_cor_n(NT)] = autocorrdetV3(noise_vec,Pfa,T_d,'FO_Corrected1',rho_calc,precision_factor,phase_step,uni_LUT,offset_factor,'none');
    
end

R_auto_noise_real_m = mean(test_stat_cor_n);
R_auto_noise_real_var = var(test_stat_cor_n);



for Nd = 1:length(SNR_vec_dB)
     
    % SKAB Theory.
    if rho_calc(Nd) < (0.5*R_auto_noise_real_m)
        mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa) + R_auto_noise_real_m;
        mod_upper = mod_thres - (rho_calc(Nd) + R_auto_noise_real_m);
        mod_lower = (1 - ((rho_calc(Nd)+R_auto_noise_real_m)^2))*sqrt(2*R_auto_noise_real_var);
        Pd_SKAB(Nd) = (1/2)*erfc(mod_upper/mod_lower);
    elseif rho_calc(Nd) >= (0.5*R_auto_noise_real_m)
        mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa) + R_auto_noise_real_m;
        mod_upper = mod_thres - (rho_calc(Nd));
        mod_lower = (1 - ((rho_calc(Nd))^2))*sqrt(2*R_auto_noise_real_var);
        Pd_SKAB(Nd) = (1/2)*erfc(mod_upper/mod_lower);
    end
    
    
    
   R_auto_sim_cor_m(Nd) = mean(R_auto_sim_cor(Nd,:));
    
    % SKAB Theory II.
    mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa) + R_auto_noise_real_m;
    mod_upper = mod_thres - R_auto_cor2_real_mean(Nd);
    mod_lower = sqrt(2*R_auto_cor2_real_var(Nd));
    Pd_SKAB2(Nd) = (1/2)*erfc(mod_upper/mod_lower);   

    
    
    
    disp(['Simulation analysis: SNR value: ',num2str(SNR_vec_dB(Nd)),' completed. Max value: ',num2str(SNR_vec_dB(end)),'.'])
end
    
    
    