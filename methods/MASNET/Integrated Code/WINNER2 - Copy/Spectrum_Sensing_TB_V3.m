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

% Probability of false alarm Signal Detector Parameters.
Pfa = 0.05;

% Sampling frequency (must be taken from literature for whatever type of
% signal is being loaded).
fs = 30.72e6;

% Sampling interval.
ts = 1/fs;

% SNR range (must correspond to filenames of testbed data!).
SNRdB = [-20:3:16]; % SNR Value in dB

% SNR range for look-up table
SNR_step_dB = 1;
SNR_vec_LUT = [-30:SNR_step_dB:20];


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

% Distribution to fit.
dist = 'normal';

% IQ imbalance.
eta = 0;
delta_theta = 0;
alpha = cos(delta_theta) + j*eta*sin(delta_theta);
beta = eta*cos(delta_theta) - j*sin(delta_theta);



% Channel paramaters for Rayleigh channel.
PathDelays = [0e-9, 50e-9, 110e-9, 170e-9, 290e-9, 310e-9];   % ITU indoor channel model - office
powers = [0,-3,-10,-18,-26,-32];

% Channel paramaters for Rician channel.
K_dB = 33;
K_lin = 10^(K_dB/10);


% Sample length for the detector.
N_OFDM_symbols_vec = [4,6];

for nn = 1:length(N_OFDM_symbols_vec)
    
    N_OFDM_symbols = N_OFDM_symbols_vec(nn);
    M = N_OFDM_symbols*yffo_len;
    M_in_algo = M-T_d;
    
    
    % Frequency offset factor.
    deltaf = 15e3;
    f_0 = 0.7*deltaf;
    F = exp(j*2*pi*f_0*[1:M_in_algo]*ts);
    
    %% Preallocation
    
    R_auto_sim = zeros(length(SNRdB), nr_sims_pd);
    
    
    R_auto_meas = zeros(length(SNRdB), nr_sims_pd);
    R_auto_meas_abs = zeros(length(SNRdB), nr_sims_pd);
    R_auto_meas2 = zeros(length(SNRdB), nr_sims_pd);
    
    test_stat_meas = zeros(length(SNRdB), nr_sims_pd);
    test_stat_meas_abs = zeros(length(SNRdB), nr_sims_pd);
    test_stat_meas2 = zeros(length(SNRdB), nr_sims_pd);
    
    test_stat_sim = zeros(length(SNRdB), nr_sims_pd);
    
    dec_auto_cor_TBn = zeros(1, nr_sims_pd);
    test_stat_cor_TBn = zeros(1, nr_sims_pd);
    R_auto_cor_TBn = zeros(1, nr_sims_pd);
    
    
    dec_auto_meas = zeros(length(SNRdB), nr_sims_pd);
    dec_auto_meas_abs = zeros(length(SNRdB), nr_sims_pd);
    dec_auto_meas2 = zeros(length(SNRdB), nr_sims_pd);
    
    
    dec_auto_sim = zeros(length(SNRdB), nr_sims_pd);
    
    
    SNRdB2 = zeros(1,length(SNRdB),1);
    rho_LUT = zeros(1,length(SNR_vec_LUT));
    
    bins_cor2 = cell(length(SNRdB),1);
    bins_fit_cor2 = cell(length(SNRdB),1);
    pdf_cor2 = cell(length(SNRdB),1);
    pdf_fit_cor2 = cell(length(SNRdB),1);
    
    bins_fit_cor2_G = cell(length(SNRdB),1);
    pdf_fit_cor2_G = cell(length(SNRdB),1);
    
    Pd_auto_meas = zeros(1,length(SNRdB));
    Pd_auto_meas_abs = zeros(1,length(SNRdB));
    Pd_auto_meas2 = zeros(1,length(SNRdB));
    Pd_auto_sim = zeros(1,length(SNRdB));
    
    
    
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
        noise_loop =  noise_loop + 1;
        if (noise_loop*M) > length(TB_noise)
            noise_loop = 1;
            TB_noise(1:10) = [];
        end
        TB_noise_vec =  TB_noise(((noise_loop-1)*M)+1:noise_loop*M);
        
        % Autocorrelation algorithms.
        [dec_auto_cor_TBn(sim_index), test_stat_cor_TBn(sim_index), R_auto_cor_TBn(sim_index)] = autocorrdetV3(TB_noise_vec,Pfa,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
        
        
    end
    
    Nbins = 50;
    [bins_R_auto_sim_real_n,binsfit_R_auto_sim_real_n, pdf_R_auto_sim_real_n,pdffit_R_auto_sim_real_n,estparams] = distfit(test_stat_cor_TBn,Nbins,'pdf','normal');
    [~,bins_fit_cor2_G_n, ~,pdf_fit_cor2_G_n] = distfit(-1*test_stat_cor_TBn,Nbins,'pdf','extreme value');
    pdf_fit_cor2_G_n = pdf_fit_cor2_G_n(end:-1:1);
    bins_fit_cor2_G_n = -1*bins_fit_cor2_G_n(end:-1:1);
    R_auto_noise_real_m = mean(test_stat_cor_TBn);
    R_auto_noise_real_var = var(test_stat_cor_TBn);
    
    
    
    %% Simulation and testbed.
    % Run simulation and post-process testbed signals for comparison.
    for snr_index = 1:length(SNRdB)
        clc; disp(['SNR iteration: ', int2str(snr_index),' out of: ', int2str(length(SNRdB)),', M is: ',num2str(N_OFDM_symbols_vec(nn)),' .']);
        % Load testbed  signal (large and SNR dependent).
        sig = 0;
        cd(meas_path)
        sig = load(['SNR',int2str(SNRdB(snr_index)),'.mat']);
        SNRdB2(snr_index) = sig.SNR_actual;
        cd(cdir)
        ss = 0;
        ss2 = 0;
        Tx_signal3 = sig.rx_wave;
        for sim_index = 1:nr_sims_pd
            ss = ss + 1;
            if (ss*M) > length(Tx_signal3)
                ss = 1;
                Tx_signal3(1:10) = [];
            end
            % Load testbed signals (based on SNR).
            r_meas = Tx_signal3(((ss-1)*M)+1:ss*M);
            
            Tx_signal2 = sig_sim.Tx_signal_vec;
            ss2 = ss2 + 1;
            if (ss2*M) > length(Tx_signal2)
                ss2 = 1;
                Tx_signal2(1:10) = [];
            end
            r_sim = Tx_signal2(((ss2-1)*M)+1:ss2*M);
            
            
            
            
            % Load simulated signal and add AWGN.
            switch Sim_channel
                case 'AWGN'
                    
                    r_sim_chan = r_sim/std(r_sim) + (10^(-sig.SNR_actual/20))*(randn(size(r_sim)) + j*randn(size(r_sim)))/sqrt(2);
                    r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));
                    r_sim_chan = alpha*r_sim_chan + beta*conj(r_sim_chan);
                case 'AWGNFO'
                    
                    F = reshape(F,size(r_sim));
                    r_sim = F.*r_sim;
                    r_sim_chan = r_sim/std(r_sim) + (10^(-sig.SNR_actual/20))*(randn(size(r_sim)) + j*randn(size(r_sim)))/sqrt(2);
                    r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));
                    r_sim_chan = alpha*r_sim_chan + beta*conj(r_sim_chan);
                case 'Rayleigh'
                    chan = rayleighchan(ts, 0, PathDelays, powers);
                    
                    r_sim_chan = filter(chan, r_sim/std(r_sim)) + (10^(-sig.SNR_actual/20))*(randn(size(r_sim)) + j*randn(size(r_sim)))/sqrt(2);
                    r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));
                    r_sim_chan = alpha*r_sim_chan + beta*conj(r_sim_chan);
                case 'RayleighFO'
                    chan = rayleighchan(ts, 0, PathDelays, powers);
                    
                    F = reshape(F,size(r_sim));
                    r_sim = F.*r_sim;
                    r_sim_chan = filter(chan, r_sim/std(r_sim)) + (10^(-sig.SNR_actual/20))*(randn(size(r_sim)) + j*randn(size(r_sim)))/sqrt(2);
                    r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));
                    r_sim_chan = alpha*r_sim_chan + beta*conj(r_sim_chan);
                case 'Rician'
                    chan = ricianchan(ts, 0, K_lin);
                    
                    r_sim_chan = filter(chan, r_sim/std(r_sim)) + (10^(-sig.SNR_actual/20))*(randn(size(r_sim)) + j*randn(size(r_sim)))/sqrt(2);
                    r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));
                    r_sim_chan = alpha*r_sim_chan + beta*conj(r_sim_chan);
                case 'RicianFO'
                    chan = ricianchan(ts, 0, K_lin);
                    
                    F = reshape(F,size(r_sim));
                    r_sim = F.*r_sim;
                    r_sim_chan = filter(chan, r_sim/std(r_sim)) + (10^(-sig.SNR_actual/20))*(randn(size(r_sim)) + j*randn(size(r_sim)))/sqrt(2);
                    r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));
                    r_sim_chan = alpha*r_sim_chan + beta*conj(r_sim_chan);
                otherwise
                    error('This channel model has not been implemented')
            end
            
            
            
            [dec_auto_sim(snr_index,sim_index), test_stat_sim(snr_index,sim_index), R_auto_sim(snr_index,sim_index)] = autocorrdetV3(r_sim_chan,Pfa,T_d,'Standard1','none');
            [dec_auto_meas(snr_index,sim_index), test_stat_meas, R_auto_meas(snr_index,sim_index)] = autocorrdetV3(r_meas,Pfa,T_d,'Standard1','none');
            [dec_auto_meas_abs(snr_index,sim_index), test_stat_meas_abs, R_auto_meas_abs(snr_index,sim_index)] = autocorrdetV3(r_meas,Pfa,T_d,'abs','none');
            [dec_auto_meas2(snr_index,sim_index), test_stat_meas2(snr_index,sim_index), R_auto_meas2(snr_index,sim_index)] = autocorrdetV3(r_meas,Pfa,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none',R_auto_noise_real_m,R_auto_noise_real_var);
            
        end
        
        [bins_cor2{snr_index,1},bins_fit_cor2{snr_index,1}, pdf_cor2{snr_index,1},pdf_fit_cor2{snr_index,1}] = distfit(test_stat_meas2(snr_index,:),Nbins,'pdf','normal');
        [~,bins_fit_cor2_G{snr_index,1}, ~,pdf_fit_cor2_G{snr_index,1}] = distfit(-1*test_stat_meas2(snr_index,:),Nbins,'pdf','extreme value');
        
        pdf_fit_cor2_G{snr_index,1} = pdf_fit_cor2_G{snr_index,1}(end:-1:1);
        bins_fit_cor2_G{snr_index,1} = -1*bins_fit_cor2_G{snr_index,1}(end:-1:1);
        
    end
    
    %% Calculate probability of detection.
    Pd_auto_meas = sum(dec_auto_meas,2)/nr_sims_pd;
    Pd_auto_meas_abs = sum(dec_auto_meas_abs,2)/nr_sims_pd;
    Pd_auto_meas2 = sum(dec_auto_meas2,2)/nr_sims_pd;
    Pd_auto_sim = sum(dec_auto_sim,2)/nr_sims_pd;
    
    %% Save Results for further plotting/analysis
    switch save_results
        case 'y'
            
            cd(save_path);
            clear Tx_signal3 sig
            save(['SKAB_analysisTB',num2str(N_OFDM_symbols_vec(nn)),'.mat'])
            cd(cdir);
            disp('Results saved')
            
        case 'n'
            cd(cdir);
            disp('Results not saved')
    end
    
    
end


