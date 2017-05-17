%% The autocorrelation spectrum sensing algorithm with testbed channels and 
%% associated hardware FFO correction stratagy.

clear


%% General simulation and testbed parameters.

% Save results, options: 'y' or 'n' (path set in next cell).
save_results = 'n';

% Probability of false alarm Signal Detector Parameters.
Pfa = 0.05;
Pfa_n = Pfa; % dummy variable as threshold is not needed for AWGN analysis.

% Sampling frequency (must be taken from literature for whatever type of
% signal is being loaded).
fs = 30.72e6;

% Sampling interval.
ts = 1/fs;

% SNR range (must correspond to filenames of testbed data!).
SNRdB = [-20:3:16]; % SNR Value in dB

% SNR range for look-up table
SNR_vec_LUT = [-30:1:20];


% FFT size, CP size, FFO correction signal length. 
T_d = 2048;
T_c = 144;
yffo_len = 2*T_d + T_c;

% Sample length for the detector.
N_OFDM_symbols = 6;    
M = N_OFDM_symbols*yffo_len;
M_in_algo = M-T_d;

% Number of simulation to run. 
nr_sims_pd = 5000;


% Phase PDF step.
phase_step = (2*pi)/180;
bins_P = [-pi:phase_step:pi];
Nbins = 50;

% Uniform number LUT (based on the phase step).
uni_LUT = rand(1,length(bins_P));


%% Set paths and load signsl.

% Current directory
cdir = cd;

% Save path
save_path = ('C:\Users\EM130\Desktop\PatChambers\Matlab_Codes\Results');

% Testbed signal
scenario = 'Corridor';
signal_type = 'LTE20QAM16'; % 'LTE5QAM16', 'LTE20QAM16', 'WiMAXQAM16'
meas_path = (['C:\Users\EM130\Desktop\PatChambers\Measurements\Rx_signals\',scenario,'\',signal_type]);

% Simulated signal
sim_path = 'C:\Users\EM130\Desktop\PatChambers\Measurements\Tx_signals';
Sim_channel = 'AWGN';  % can be 'AWGN', 'Rayleigh', 'Measure_with_Rayleigh', 'Rician', 'AWGNFO', 'RayleighFO','RicianFO' 

% Testbed noise.
TB_noise_path = 'C:\Users\EM130\Desktop\PatChambers\Measurements\Noise\NoAntenna';

% Angular variances

Angle_var = [3.0566, 2.8413, 2.5915, 1.8976, 1.0677, 0.3491, 0.1170, 0.0505, 0.0270, 0.0217, 0.0194, 0.0183, 0.0177];

%% Prealloaction
rho_LUT = zeros(1,length(SNR_vec_LUT));
test_stat_cor_n = zeros(1,nr_sims_pd);
test_stat_cor_TBn = zeros(1,nr_sims_pd);
test_stat_stan_n = zeros(1,nr_sims_pd);
test_stat_stan_TBn = zeros(1,nr_sims_pd);

%% Look table
rho_LUT = zeros(1,length(SNR_vec_LUT));
for Nd = 1:length(SNR_vec_LUT)
    % LUT for rho.
    rho_LUT(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_LUT(Nd)/10))/((10^(SNR_vec_LUT(Nd)/10)) + 1); 
end

% Constant and offset to remove look-up table precision problems.
precision_factor = 1/rho_LUT(1);


%% Statistics of noise to set mean in threshold of new algorithm.

% Load testbed signal.
 cd(TB_noise_path);
 TB_noise = load('Noise.mat');
 TB_noise =  TB_noise.Noise;
 cd(cdir)
 noise_loop = 0;
 
 
for sim_index = 1:nr_sims_pd                                       
    % Create simulated noise.
    sim_noise_vec = randn(1,M) + j*randn(1,M);
    sim_noise_vec_mean = mean(sim_noise_vec);
    sim_noise_vec_mean_std = std(sim_noise_vec);
    sim_noise_vec = sim_noise_vec - sim_noise_vec_mean;
    sim_noise_vec = sim_noise_vec/sim_noise_vec_mean_std;
    
    % Testbed noise
     noise_loop =  noise_loop + 1;
          if (noise_loop*M) > length(TB_noise)
               noise_loop = 1;
              TB_noise(1:10) = [];
          end  
    TB_noise_vec =  TB_noise(((noise_loop-1)*M)+1:noise_loop*M); 
    
    % Autocorrelation algorithms.
    [~,test_stat_cor_n(sim_index),~] = autocorrdetV3(TB_noise_vec,Pfa_n,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
    [~,test_stat_cor_TBn(sim_index),~] = autocorrdetV3(TB_noise_vec,Pfa_n,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
    
    [~,test_stat_stan_n(sim_index),~] = autocorrdetV3(TB_noise_vec,Pfa_n,T_d,'Standard1','none');
    [~,test_stat_stan_TBn(sim_index),~] = autocorrdetV3(TB_noise_vec,Pfa_n,T_d,'Standard1','none');
end



Nbins = 50;
%SKAB
[bins_R_auto_sim_real_n,binsfit_R_auto_sim_real_n, pdf_R_auto_sim_real_n,pdffit_R_auto_sim_real_n] = distfit(test_stat_cor_n,Nbins,'pdf','normal');
[~,binsfit_R_auto_sim_real_ev,~,pdffit_R_auto_sim_real_ev] = distfit(-1*test_stat_cor_n,Nbins,'pdf','extreme value');

[bins_R_auto_sim_real_TBn,binsfit_R_auto_sim_real_TBn, pdf_R_auto_sim_real_TBn,pdffit_R_auto_sim_real_TBn] = distfit(test_stat_cor_TBn,Nbins,'pdf','normal');
[~,binsfit_R_auto_sim_real_TBev,~,pdffit_R_auto_sim_real_TBev] = distfit(-1*test_stat_cor_TBn,Nbins,'pdf','extreme value');


%CAB
[bins_R_auto_sim_real_n_stan,binsfit_R_auto_sim_real_n_stan, pdf_R_auto_sim_real_n_stan,pdffit_R_auto_sim_real_n_stan] = distfit(test_stat_stan_n,Nbins,'pdf','normal');
[bins_R_auto_sim_real_TBn_stan,binsfit_R_auto_sim_real_TBn_stan, pdf_R_auto_sim_real_TBn_stan,pdffit_R_auto_sim_real_TBn_stan] = distfit(test_stat_stan_TBn,Nbins,'pdf','normal');


R_auto_noise_real_m = mean(test_stat_cor_n);
R_auto_noise_real_var = var(test_stat_cor_n);
R_auto_noise_real_TBm = mean(test_stat_cor_TBn);
R_auto_noise_real_TBvar = var(test_stat_cor_TBn);


% pdf_R_auto_sim_real_n = pdf_R_auto_sim_real_n(end:-1:1);
% pdffit_R_auto_sim_real_n = pdffit_R_auto_sim_real_n(end:-1:1);

figure(1)
plot(bins_R_auto_sim_real_n,  pdf_R_auto_sim_real_n,'-bx')
hold on; grid on
plot(binsfit_R_auto_sim_real_n, pdffit_R_auto_sim_real_n,'b-') 
plot(bins_R_auto_sim_real_TBn,  pdf_R_auto_sim_real_TBn,'-rx')
plot(binsfit_R_auto_sim_real_TBn, pdffit_R_auto_sim_real_TBn,'r-')

plot(bins_R_auto_sim_real_n_stan,  pdf_R_auto_sim_real_n_stan,'-gx')
plot(binsfit_R_auto_sim_real_n_stan, pdffit_R_auto_sim_real_n_stan,'g-') 
plot(bins_R_auto_sim_real_TBn_stan,  pdf_R_auto_sim_real_TBn_stan,'-kx')
plot(binsfit_R_auto_sim_real_TBn_stan, pdffit_R_auto_sim_real_TBn_stan,'k-')

save('CAB&SKAB_AWGN_anyl.mat')
 





