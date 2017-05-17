%% The autocorrelation spectrum sensing algorithm with testbed channels and
%% associated hardware FFO correction stratagy.

clear

%% Set paths and load signsl.

% Current directory
cdir = cd;

% Save path
save_path = ('C:\Users\pc202\Desktop\PatChambers\AutoCorr\Results');

% Testbed signal
scenario = 'Corridor';
signal_type = 'LTE20QAM16'; % 'LTE5QAM16', 'LTE20QAM16', 'WiMAXQAM16'
meas_path = (['C:\Users\pc202\Desktop\PatChambers\AutoCorr\Testbed_signals\',scenario,'\',signal_type]);

% Simulated signal
sim_path = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
Sim_channel = 'AWGN';  % can be 'AWGN', 'Rayleigh', 'Measure_with_Rayleigh', 'Rician', 'AWGNFO', 'RayleighFO','RicianFO'

% Testbed noise.
TB_noise_path = 'C:\Users\pc202\Desktop\PatChambers\AutoCorr\Testbed_signals\Noise';


%% General simulation and testbed parameters.

% Save results, options: 'y' or 'n' (path set in next cell).
save_results = 'y';


% Sampling frequency (must be taken from literature for whatever type of
% signal is being loaded).
fs = 30.72e6;

% Sampling interval.
ts = 1/fs;

% The SNR range
SNRdB = [-20:3:16]

% SNR range for look-up table
SNR_step_dB = 1;
SNR_vec_LUT = [-30:SNR_step_dB:20];

% Probability of false alarm Signal Detector Parameters.
PD_step_dB = 0.001
Pfa_vec = [0:PD_step_dB:1];


% Total sample length (hard encode to save time, run 'How_Many_Samples.m').
S_tot = 41943040;

% FFT size, CP size, FFO correction signal length.
T_d = 2048;
T_c = 144;

% Number of simulation to run.
nr_sims_pd = 10000;

% Phase PDF step.
phase_step = (2*pi)/180;
bins_P = [-pi:phase_step:pi];
Nbins = 50;

% Uniform number LUT (based on the phase step).
uni_LUT = rand(1,length(bins_P));


% Reference recorded amount of samples to maximum allowed for LTE20 for
% fairness.
yffo_len = 2*T_d + T_c;

% Number of possible autocorrelations.
N_autocorr =  (S_tot -  mod(S_tot,yffo_len))/yffo_len;

% Number of windows, yffo_len in length, to average
N_windows = 50;


% Sample length for the detector.
N_OFDM_symbols_vec = 6;


% Load testbed signal.
sig = 0;
cd(meas_path)
sig = load(['SNR',int2str(SNRdB(5)),'.mat']);
SNRdB2 = sig.SNR_actual;
cd(cdir)

N_OFDM_symbols = N_OFDM_symbols_vec;
M = N_OFDM_symbols*yffo_len;
M_in_algo = M-T_d;



%% Preallocation

dec_auto_cor_TBn = zeros(1, nr_sims_pd);
test_stat_cor_TBn = zeros(1, nr_sims_pd);
R_auto_cor_TBn = zeros(1, nr_sims_pd);

Pd_auto_meas = zeros(1,length(Pfa_vec));
Pd_auto_meas2 = zeros(1,length(Pfa_vec));


dec_auto_meas = zeros(length(SNRdB),nr_sims_pd);
dec_auto_meas2 = zeros(length(SNRdB),nr_sims_pd);
rho_LUT = zeros(1,length(SNR_vec_LUT));




%% Look-up table
rho_LUT = zeros(1,length(SNR_vec_LUT));
for Nd = 1:length(SNR_vec_LUT)
    % LUT for rho.
    rho_LUT(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_LUT(Nd)/10))/((10^(SNR_vec_LUT(Nd)/10)) + 1);
end

% Constant and offset to remove look-up table precision problems.
precision_factor = 1/rho_LUT(1);

% Load simulated signal.
sig_sim = 0;
cd(sim_path)
sig_sim = load([signal_type,'.mat']);
cd(TB_noise_path);
TB_noise = load('Noise.mat');
TB_noise =  TB_noise.Noise;
cd(cdir)
noise_loop = 0;

%% Statistics of testbed noise.
for sim_index = 1:nr_sims_pd
    % Testbed noise
    Pfa_n = 0.05;
    noise_loop =  noise_loop + 1;
    if (noise_loop*M) > length(TB_noise)
        noise_loop = 1;
        TB_noise(1:10) = [];
    end
    TB_noise_vec =  TB_noise(((noise_loop-1)*M)+1:noise_loop*M);
    
    % Autocorrelation algorithms.
    [dec_auto_cor_TBn(sim_index), test_stat_cor_TBn(sim_index), R_auto_cor_TBn(sim_index)] = autocorrdetV3(TB_noise_vec,Pfa_n,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
    
    
end


R_auto_noise_real_m = mean(test_stat_cor_TBn);
R_auto_noise_real_var = var(test_stat_cor_TBn);



%% Simulation and testbed.
% Run simulation and post-process testbed signals for comparison.
for snr_index = 1:length(Pfa_vec)
    
    clc; disp(['P_fa iteration: ', int2str(snr_index),' out of: ', int2str(length(Pfa_vec))]);
    
    ss = 0;    
    Tx_signal3 = sig.rx_wave;
    for sim_index = 1:nr_sims_pd
        ss = ss + 1;
        if (ss*M) > length(Tx_signal3)
            ss = 1;
            Tx_signal3(1:10) = [];
        end
        % Load testbed signals (based on SNR).
        r_meas = Tx_signal3(((ss-1)*M)+1:ss*M);       
        
        
        [dec_auto_meas(snr_index,sim_index)] = autocorrdetV3(r_meas,Pfa_vec(snr_index),T_d,'Standard1','none');
        [dec_auto_meas2(snr_index,sim_index)] = autocorrdetV3(r_meas,Pfa_vec(snr_index),T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none',R_auto_noise_real_m,R_auto_noise_real_var);
        
        
    end
    
    
    
end

%% Calculate probability of detection.
Pd_auto_meas = sum(dec_auto_meas,2)/nr_sims_pd;
Pd_auto_meas2 = sum(dec_auto_meas2,2)/nr_sims_pd;




%% Save Results for further plotting/analysis
switch save_results
    case 'y'
        
        cd(save_path);
        clear Tx_signal3 sig
        save(['SKAB_analysisTB_ROC.mat'])
        cd(cdir);
        disp('Results saved')
        
    case 'n'
        cd(cdir);
        disp('Results not saved')
end





