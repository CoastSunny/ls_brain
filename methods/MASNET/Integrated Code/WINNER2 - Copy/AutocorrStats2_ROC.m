%% Simulation of autocorrelation algorithm: SNR vs Probability of detection.

clear

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

%% Noise and transmit power.

% SNR in dB for simulation.
SNR_step_dB = 1;
SNR_vec_dB = -9.1376; % From the testbed.
SNR_vec_LUT = [-30:SNR_step_dB:20];


% Phase PDF step.
phase_step = (2*pi)/180;
bins_P = [-pi:phase_step:pi];
Nbins = 50;

% Uniform number LUT (based on the phase step).
uni_LUT = rand(1,length(bins_P));

% Sampling frequency (highest LTE).
fs = 30.72e6;

%% Tx 20 MHZ LTE signal.
TX_20MHz_QAM16 = load('LTE20QAM16');
Tx_signal = TX_20MHz_QAM16.Tx_signal_vec;
clear TX_20MHz_QAM16

% FFT size, CP size, FFO correction signal length.
T_d = 2048;  %512, 2048
T_c = 144;   %36, 144


% Probability of false alarm Signal Detector Parameters.
PD_step_dB = 0.001
Pfa_vec = [0:PD_step_dB:1];

% Reference recorded amount of samples to maximum allowed for LTE20 for
% fairness.
yffo_len = 2*T_d + T_c;

% Sample length for the detector.
N_OFDM_symbols_vec = 6;


N_OFDM_symbols = N_OFDM_symbols_vec(1);

M = N_OFDM_symbols*yffo_len;

M_in_algo = M - T_d;

% Number of simulations at each SNR.
NDrops = 5000;

% K factor
diff_comp = (1/(sqrt(2*M_in_algo))) + (j*(1/(sqrt(2*M_in_algo))));
diff_rms = abs(diff_comp);
diff_rms_pow = diff_rms^2;

sigma_diff = (1/(sqrt(2*M_in_algo)));

%% Initialise arrays, cells, etc.
rho_LUT = zeros(1,length(SNR_vec_LUT));

dec_auto_cor_n = zeros(1,NDrops);
test_stat_cor_n = zeros(1,NDrops);
R_auto_cor_n = zeros(1,NDrops);

Pd_auto_rho = zeros(1,length(Pfa_vec));
P_D = zeros(1,length(Pfa_vec));
P_D_SKA2 = zeros(1,length(Pfa_vec));
Pd_SKAB = zeros(1,length(Pfa_vec));

dec_auto_sim = zeros(1,NDrops);
dec_auto_cor2 = zeros(1,NDrops);
test_auto_cor2 = zeros(1,NDrops);


%% Look-up table for rho and variance.

for Nd = 1:length(SNR_vec_LUT)
    % LUT for rho.
    rho_LUT(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_LUT(Nd)/10))/((10^(SNR_vec_LUT(Nd)/10)) + 1);
end

% Constant and offset to remove look-up table precision problems.
precision_factor = 1/rho_LUT(1);
rho_LUT2 = rho_LUT.^2;

%% Statistics of noise to set mean in threshold of new algorithm.
Pfa_n = 0.05;
for NT = 1:NDrops
    % Create noise.
    noise_vec = randn(1,M_in_algo) + j*randn(1,M_in_algo);
    noise_vec_mean = mean(noise_vec);
    noise_vec_mean_std = std(noise_vec);
    noise_vec = noise_vec - noise_vec_mean;
    noise_vec = noise_vec/noise_vec_mean_std;
    
    % Autocorrelation for OFDM detection.
    [dec_auto_cor_n(NT), test_stat_cor_n(NT), R_auto_cor_n(NT)] = autocorrdetV3(noise_vec,Pfa_n,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
end
R_auto_noise_real_m = mean(test_stat_cor_n);
R_auto_noise_real_var = var(test_stat_cor_n);



%% New algorithm vs standard

Tx_signal2 = Tx_signal;
for Nd = 1:length(Pfa_vec)
    
    % Standard algorithm theory.
    rho_calc = (T_c/(T_d + T_c))*(10^(SNR_vec_dB/10))/((10^(SNR_vec_dB/10)) + 1);
    mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa_vec(Nd));
    mod_upper = mod_thres - rho_calc;
    mod_lower = 1 - (rho_calc^2);
    Pd_auto_rho(Nd) = (1/2)*erfc(sqrt(M_in_algo)*(mod_upper/mod_lower));
    
    
    sig_drop = 0;
    Noise_var_Watts = 10^(-SNR_vec_dB/10);
    Tx_signal2 = Tx_signal;
    for NT = 1:NDrops
        sig_drop = sig_drop + 1;
        if (sig_drop*M) > length(Tx_signal2)
            sig_drop = 1;
            Tx_signal2(1:10) = [];
        end
        % Signal.
        r_sim = Tx_signal2(((sig_drop-1)*M)+1:sig_drop*M);
        r_sim = (r_sim/std(r_sim));
        % Create noise.
        noise_vec = randn(size(r_sim)) + j*randn(size(r_sim));
        noise_vec_mean = mean(noise_vec);
        noise_vec_mean_std = std(noise_vec);
        noise_vec = noise_vec - noise_vec_mean;
        noise_vec = noise_vec/noise_vec_mean_std;
        noise_vec = sqrt(Noise_var_Watts)*noise_vec;
        % Signal + noise.
        r_sim_chan = r_sim + noise_vec;
        % Autocorrelation for OFDM detection.
        [dec_auto_sim(NT)] = autocorrdetV3(r_sim_chan,Pfa_vec(Nd),T_d,'Standard1','none');
        [dec_auto_cor2(NT), test_auto_cor2(NT),~] = autocorrdetV3(r_sim_chan,Pfa_vec(Nd),T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none',R_auto_noise_real_m,R_auto_noise_real_var);
        
    end
    P_D(Nd) = mean(dec_auto_sim);
    P_D_SKA2(Nd) = mean(dec_auto_cor2);
    test_auto_cor2_mean = mean(test_auto_cor2);
    test_auto_cor2_var = var(test_auto_cor2);
    
    % Semi analytical theory of SKAB
    mod_thres = sqrt(2*R_auto_noise_real_var)*erfcinv(2*Pfa_vec(Nd)) + R_auto_noise_real_m; 
    mod_upper = mod_thres - test_auto_cor2_mean;
    mod_lower = sqrt(2*test_auto_cor2_var);
    Pd_SKAB(Nd) = (1/2)*erfc(mod_upper/mod_lower);
    
    
    disp(['Simulation analysis: P_D value: ',num2str(Pfa_vec(Nd)),' completed. Max value: ',num2str(Pfa_vec(Nd)),'. Step value: ',num2str(PD_step_dB),'.'])
end




cd(save_path)
save(['SKAB_analysisROC6.mat'])
cd(cdir)



