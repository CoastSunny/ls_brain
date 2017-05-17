%% Numerical experiments with extreme value distribution

clear

% Generate appropriate data.
Nbins = 50;
NDrops = 5000;

% SNR in dB for simulation.
SNR_step_dB = 1;
SNR_vec_dB = [-30:SNR_step_dB:20];
SNR_vec_LUT = SNR_vec_dB;

phase_step = (2*pi)/180;
bins_P = [-pi:phase_step:pi];

% Uniform number LUT (based on the phase step).
uni_LUT = rand(1,length(bins_P));

% FFT size, CP size, FFO correction signal length. 
T_d = 2048;  %512, 2048
T_c = 144;   %36, 144


% Probability of false alarm Signal Detector Parameters.
Pfa = 0.1;

% Reference recorded amount of samples to maximum allowed for LTE20 for
% fairness.
yffo_len = 2*T_d + T_c;

% Sample length for the detector.
N_OFDM_symbols = 6;
M = N_OFDM_symbols*yffo_len;

M_in_algo = M - T_d;


% Preallocation.
test_stat_cor_n = zeros(1,NDrops);
dec_auto_cor_n = zeros(1,NDrops);
R_auto_cor_n = zeros(1,NDrops);

for Nd = 1:length(SNR_vec_LUT)
    % LUT for rho.
    rho_LUT(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_LUT(Nd)/10))/((10^(SNR_vec_LUT(Nd)/10)) + 1); 

end
precision_factor = 1/rho_LUT(1);
for NT = 1:NDrops  
    % Create noise.
    noise_vec = randn(1,M) + j*randn(1,M);
    noise_vec_mean = mean(noise_vec);
    noise_vec_mean_std = std(noise_vec);
    noise_vec = noise_vec - noise_vec_mean;
    noise_vec = noise_vec/noise_vec_mean_std;    
    
    % Autocorrelation for OFDM detection.
    [dec_auto_cor_n(NT), test_stat_cor_n(NT), R_auto_cor_n(NT)] = autocorrdetV3(noise_vec,Pfa,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
   
end

% PDFs.
[bins_min,bins_min_fit, pdf_min,pdf_fit_min] = distfit(test_stat_cor_n,Nbins,'pdf','extreme value');
[bins_max,~, pdf_max,~] = distfit(test_stat_cor_n,Nbins,'pdf','extreme value');
[~,bins_max_fit, ~,pdf_fit_max,est_ex] = distfit(-1*test_stat_cor_n,Nbins,'pdf','extreme value');
[bins_max_n,bins_max_fit_n, pdf_max_n,pdf_fit_max_n,est_n] = distfit(test_stat_cor_n,Nbins,'pdf','normal');
pdf_fit_max = pdf_fit_max(end:-1:1);
bins_max_fit = -1*bins_max_fit(end:-1:1);









% Plots
figure(1)
plot(bins_min,pdf_min,'-bs')
hold on; grid on;
plot(bins_min_fit,pdf_fit_min,'-b')

figure(2)
plot(bins_max,pdf_max,'-rs')
hold on; grid on;
plot(bins_max_fit,pdf_fit_max,'-r')
plot(bins_max_fit_n,pdf_fit_max_n,'-g')