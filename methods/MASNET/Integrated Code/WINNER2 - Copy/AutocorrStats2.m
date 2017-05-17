%% Simulation of autocorrelation algorithm: SNR vs Probability of detection.

clear

% Paths

cdir = cd;
save_path = 'C:\Users\pc202\Desktop\PatChambers\AutoCorr\Results';

%% Noise and transmit power.

% SNR in dB for simulation.
SNR_step_dB = 1;
SNR_vec_dB = [-30:SNR_step_dB:20];
SNR_vec_LUT = SNR_vec_dB;

% Merge simulation values with testbed values of SNR.
SNRdB2 = load('AutoFigs.mat','SNRdB2');
SNRdB2 = SNRdB2.SNRdB2;

for ss = 1:length(SNRdB2)
    [~,b] = min(abs(SNRdB2(ss)-SNR_vec_dB));
    if SNRdB2(ss) > SNR_vec_dB(b)
        SNR_vec_dB = [SNR_vec_dB(1:b) SNRdB2(ss) SNR_vec_dB(b+1:end)];
    elseif SNRdB2(ss) < SNR_vec_dB(b)
        SNR_vec_dB = [SNR_vec_dB(1:b-1) SNRdB2(ss) SNR_vec_dB(b:end)];
    elseif SNRdB2(ss) == SNR_vec_dB(b)
    end
end


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
Pfa = 0.05;

% Reference recorded amount of samples to maximum allowed for LTE20 for
% fairness.
yffo_len = 2*T_d + T_c;

% Sample length for the detector.
N_OFDM_symbols_vec = [4,8];
%N_OFDM_symbols_vec = [6];

for nn = 1:length(N_OFDM_symbols_vec)
    N_OFDM_symbols = N_OFDM_symbols_vec(nn);
    
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
    dec_auto_sim = zeros(length(SNR_vec_dB),NDrops);
    dec_auto_sim_WC1 = zeros(length(SNR_vec_dB),NDrops);
    dec_auto_cor2 = zeros(length(SNR_vec_dB),NDrops);
    dec_auto_cor_WC1 = zeros(length(SNR_vec_dB),NDrops);
    dec_auto_abs = zeros(length(SNR_vec_dB),NDrops);
    
    
    test_stat_sim = zeros(length(SNR_vec_dB), NDrops);
    test_stat_sim_WC1 = zeros(length(SNR_vec_dB), NDrops);
    test_stat_cor2 = zeros(length(SNR_vec_dB), NDrops);
    test_stat_cor_WC1 = zeros(length(SNR_vec_dB), NDrops);
    test_stat_abs = zeros(length(SNR_vec_dB), NDrops);
    
    
    
    R_auto_sim = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_WC1 = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_WC2 = zeros(length(SNR_vec_dB), NDrops);
    
    R_auto_cor2 = zeros(length(SNR_vec_dB), NDrops);
    R_auto_cor_WC1 = zeros(length(SNR_vec_dB), NDrops);
    R_auto_abs = zeros(length(SNR_vec_dB), NDrops);
    
    
    R_auto_sim_real = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_imag = zeros(length(SNR_vec_dB), NDrops);
    
    R_auto_cor2_real = zeros(length(SNR_vec_dB), NDrops);
    
    R_auto_sim_angle = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_angle2 = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_angle3 = zeros(length(SNR_vec_dB), NDrops);
    
    R_auto_sim_abs = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_abs2 = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_abs_sqd = zeros(length(SNR_vec_dB), NDrops);
    R_auto_sim_abs_sqd_2 = zeros(length(SNR_vec_dB), NDrops);
    R_abs_min_2sig2 = zeros(length(SNR_vec_dB), NDrops);
    R_abs_min_2sig22 = zeros(length(SNR_vec_dB), NDrops);
    
    real_mean_ind = zeros(length(SNR_vec_dB), NDrops);
    real_mean_ind2 = zeros(length(SNR_vec_dB), NDrops);
    rho_squared = zeros(length(SNR_vec_dB), NDrops);
    
    R_auto_cor2_real = zeros(length(SNR_vec_dB), NDrops);
    
    R_auto_sim_real_mean = zeros(1,length(SNR_vec_dB));
    R_auto_sim_real_var = zeros(1,length(SNR_vec_dB));
    
    R_auto_sim_imag_mean = zeros(1,length(SNR_vec_dB));
    R_auto_sim_imag_var = zeros(1,length(SNR_vec_dB));
    
    R_auto_sim_abs_mean = zeros(1,length(SNR_vec_dB));
    R_auto_sim_abs_var = zeros(1,length(SNR_vec_dB));
    
    R_real_var_theory = zeros(1,length(SNR_vec_dB));
    R_real_mean_theory = zeros(1,length(SNR_vec_dB));
    
    R_imag_var_theory = zeros(1,length(SNR_vec_dB));
    R_imag_mean_theory = zeros(1,length(SNR_vec_dB));
    
    R_abs_var_theory = zeros(1,length(SNR_vec_dB));
    R_abs_mean_theory = zeros(1,length(SNR_vec_dB));
    
    K_fac_analyic = zeros(1,length(SNR_vec_dB));
    K_fac_mean = zeros(1,length(SNR_vec_dB));
    K_fac_mean2 = zeros(1,length(SNR_vec_dB));
    K_fac_mean3 = zeros(1,length(SNR_vec_dB));
    K_fac_calc = zeros(length(SNR_vec_dB), NDrops);
    K_fac_calc2 = zeros(length(SNR_vec_dB), NDrops);
    K_fac_calc3 = zeros(length(SNR_vec_dB), NDrops);
    
    P_D = zeros(1,length(SNR_vec_dB));
    P_D_WC1 = zeros(1,length(SNR_vec_dB));
    P_D_WC2 = zeros(1,length(SNR_vec_dB));
    P_D_abs = zeros(1,length(SNR_vec_dB));
    
    P_D_SKA = zeros(1,length(SNR_vec_dB));
    P_D_SKA2 = zeros(1,length(SNR_vec_dB));
    P_D_SKA_WC1 = zeros(1,length(SNR_vec_dB));
    Pd_SKAB = zeros(1,length(SNR_vec_dB));
    delta_mu = zeros(1,length(SNR_vec_dB));
    delta_eta = zeros(1,length(SNR_vec_dB));
    
    Pd_SK_auto_rho2 = zeros(1,length(SNR_vec_dB));
    Pd_SK_auto_rho1 = zeros(1,length(SNR_vec_dB));
    Pd_auto_rho = zeros(1,length(SNR_vec_dB));
    
    rho_LUT = zeros(1,(length(SNR_vec_dB)));
    rho2 = zeros(1,length(SNR_vec_dB));
    rho3 = zeros(1,length(SNR_vec_dB));
    Rabs2 = zeros(1,length(SNR_vec_dB));
    R_abs_min_2sig2_mean = zeros(1,length(SNR_vec_dB));
    
    
    P = cell(length(SNR_vec_dB),1);
    K = zeros(length(SNR_vec_dB),1);
    B = zeros(length(SNR_vec_dB),1);
    
    P2 = cell(length(SNR_vec_dB),1);
    K2 = zeros(length(SNR_vec_dB),1);
    B2 = zeros(length(SNR_vec_dB),1);
    
    P3 = cell(length(SNR_vec_dB),1);
    K3 = zeros(length(SNR_vec_dB),1);
    B3 = zeros(length(SNR_vec_dB),1);
    var_real_theory = zeros(length(SNR_vec_dB),1);
    
    
    bins_R_auto_sim_angle = cell(length(SNR_vec_dB),1);
    binsfit_R_auto_sim_angle = cell(length(SNR_vec_dB),1);
    pdf_R_auto_sim_angle = cell(length(SNR_vec_dB),1);
    pdffit_R_auto_sim_angle = cell(length(SNR_vec_dB),1);
    
    
    bins_cor2 = cell(length(SNR_vec_dB),1);
    bins_fit_cor2 = cell(length(SNR_vec_dB),1);
    pdf_cor2 = cell(length(SNR_vec_dB),1);
    pdf_fit_cor2 = cell(length(SNR_vec_dB),1);
    
    bins_fit_cor2_G = cell(length(SNR_vec_dB),1);
    pdf_fit_cor2_G = cell(length(SNR_vec_dB),1);
    
    
    test_stat_cor_n = zeros(1,NDrops);
    dec_auto_cor_n = zeros(1,NDrops);
    R_auto_cor_n = zeros(1,NDrops);
    
    %% Look-up table for rho and variance.
    
    for Nd = 1:length(SNR_vec_LUT)
        % LUT for rho.
        rho_LUT(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_LUT(Nd)/10))/((10^(SNR_vec_LUT(Nd)/10)) + 1);
        var_real_theory(Nd) = ((1-rho_LUT(Nd)^2)^2)/(2*M_in_algo);
    end
    
    % Constant and offset to remove look-up table precision problems.
    precision_factor = 1/rho_LUT(1);
    rho_LUT2 = rho_LUT.^2;
    
    %% Statistics of noise to set mean in threshold of new algorithm.
    
    for NT = 1:NDrops
        % Create noise.
        %noise_vec = randn(1,M_in_algo) + j*randn(1,M_in_algo);
        noise_vec = randn(1,M) + j*randn(1,M);
        noise_vec_mean = mean(noise_vec);
        noise_vec_mean_std = std(noise_vec);
        noise_vec = noise_vec - noise_vec_mean;
        noise_vec = noise_vec/noise_vec_mean_std;
        
        % Autocorrelation for OFDM detection.
        [dec_auto_cor_n(NT), test_stat_cor_n(NT), R_auto_cor_n(NT)] = autocorrdetV3(noise_vec,Pfa,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none');
        
    end
    
    Nbins = 50;
    [bins_R_auto_sim_real_n,binsfit_R_auto_sim_real_n, pdf_R_auto_sim_real_n,pdffit_R_auto_sim_real_n,estparams] = distfit(test_stat_cor_n,Nbins,'pdf','normal');
    [~,bins_fit_cor2_G_n, ~,pdf_fit_cor2_G_n] = distfit(-1*test_stat_cor_n,Nbins,'pdf','extreme value');
    pdf_fit_cor2_G_n = pdf_fit_cor2_G_n(end:-1:1);
    bins_fit_cor2_G_n = -1*bins_fit_cor2_G_n(end:-1:1);
    R_auto_noise_real_m = mean(test_stat_cor_n);
    R_auto_noise_real_var = var(test_stat_cor_n);
    
    
    
    
    
    %% New algorithm vs standard
    
    Tx_signal2 = Tx_signal;
    for Nd = 1:length(SNR_vec_dB)
        % Standard algorithm theory.
        rho_calc = (T_c/(T_d + T_c))*(10^(SNR_vec_dB(Nd)/10))/((10^(SNR_vec_dB(Nd)/10)) + 1);
        mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa);
        mod_upper = mod_thres - rho_calc;
        mod_lower = 1 - (rho_calc^2);
        Pd_auto_rho(Nd) = (1/2)*erfc(sqrt(M_in_algo)*(mod_upper/mod_lower));
        
        
        sig_drop = 0;
        Noise_var_Watts = 10^(-SNR_vec_dB(Nd)/10);
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
            [dec_auto_sim(Nd,NT), test_stat_sim(Nd,NT), R_auto_sim(Nd,NT)] = autocorrdetV3(r_sim_chan,Pfa,T_d,'Standard1','none');
            [dec_auto_sim_WC1(Nd,NT), test_stat_sim_WC1(Nd,NT), R_auto_sim_WC1(Nd,NT)] = autocorrdetV3(r_sim_chan,Pfa,T_d,'Standard1','WC1');
            [dec_auto_abs(Nd,NT), test_stat_abs(Nd,NT), R_auto_abs(Nd,NT)] = autocorrdetV3(r_sim_chan,Pfa,T_d,'abs','none');
            
            [dec_auto_cor2(Nd,NT), test_stat_cor2(Nd,NT), R_auto_cor2(Nd,NT)] = autocorrdetV3(r_sim_chan,Pfa,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'none',R_auto_noise_real_m,R_auto_noise_real_var);
            [dec_auto_cor_WC1(Nd,NT), test_stat_cor_WC1(Nd,NT), R_auto_cor_WC1(Nd,NT), R_WC1(Nd,NT)] = autocorrdetV3(r_sim_chan,Pfa,T_d,'FO_Corrected1',rho_LUT,precision_factor,phase_step,uni_LUT,'WC1',R_auto_noise_real_m,R_auto_noise_real_var);
            
            
            
            
            % Quantities to be analysed statistically.
            R_auto_sim_real(Nd,NT) = real(R_auto_sim(Nd,NT));
            R_auto_sim_imag(Nd,NT) = imag(R_auto_sim(Nd,NT));
            R_auto_cor2_real(Nd,NT) = real(R_auto_cor2(Nd,NT));
            %R_auto_cor2_imag(Nd,NT) = imag(R_auto_cor2(Nd,NT));
            R_auto_sim_angle(Nd,NT) = angle(R_auto_sim(Nd,NT));
            R_auto_sim_abs(Nd,NT) = abs(R_auto_sim(Nd,NT));
            R_auto_sim_abs2(Nd,NT) = abs(R_auto_sim(Nd,NT))^2;
            K_fac_calc(Nd,NT) = R_auto_sim_abs(Nd,NT)^2 - diff_rms_pow;
            K_fac_calc2(Nd,NT) = R_auto_sim_abs(Nd,NT) - diff_rms;
            K_fac_calc3(Nd,NT) = ((real(R_auto_sim(Nd,NT))*(1*precision_factor))^2 + (imag(R_auto_sim(Nd,NT))*(1*precision_factor))^2) - ((diff_rms*(1*precision_factor))^2);
            
            
        end
        % Mean and variance: real, imag, angle, abs from simulation.
        R_auto_sim_real_mean(Nd) = mean(R_auto_sim_real(Nd,:));
        R_auto_sim_real_var(Nd) = var(R_auto_sim_real(Nd,:));
        R_auto_cor2_real_mean(Nd) = mean(R_auto_cor2_real(Nd,:));
        R_auto_cor2_real_var(Nd) = var(R_auto_cor2_real(Nd,:));
        R_auto_sim_imag_mean(Nd) = mean(R_auto_sim_imag(Nd,:));
        R_auto_sim_imag_var(Nd) = var(R_auto_sim_imag(Nd,:));
        R_auto_sim_angle_mean(Nd) = mean(R_auto_sim_angle(Nd,:));
        R_auto_sim_angle_var(Nd) = var(R_auto_sim_angle(Nd,:));
        R_auto_sim_abs_mean(Nd) = mean(R_auto_sim_abs(Nd,:));
        R_auto_sim_abs_var(Nd) = var(R_auto_sim_abs(Nd,:));
        P_D(Nd) = mean(dec_auto_sim(Nd,:));
        P_D_WC1(Nd) = mean(dec_auto_sim_WC1(Nd,:));
        P_D_abs(Nd) = mean(dec_auto_abs(Nd,:));
        
        
        P_D_SKA2(Nd) = mean(dec_auto_cor2(Nd,:));
        
        P_D_SKA_WC1(Nd) = mean(dec_auto_cor_WC1(Nd,:));
        
        
        R_abs_min_2sig2_mean(Nd) = mean(R_abs_min_2sig2(Nd,:));
        % Mean and variance: real, imag, angle, abs from theory.
        
        R_real_mean_theory(Nd) = rho_calc;
        rho2(Nd) = rho_calc^2;
        rho3(Nd) = (precision_factor^2)*(rho_calc^2);
        
        R_real_var_theory(Nd) = ((1-rho_calc^2)^2)/(2*M_in_algo);
        R_imag_var_theory(Nd) =  (1 + ((4*(T_c/(T_d + T_c))*(R_auto_sim_abs_mean(Nd)))/((var(r_sim_chan)^2))))/(2*M_in_algo);
        K_fac_analyic(Nd) = rho_calc/diff_rms;
        K_fac_mean(Nd) = mean(K_fac_calc(Nd,:));
        K_fac_mean2(Nd) = mean(K_fac_calc2(Nd,:));
        K_fac_mean3(Nd) = mean(K_fac_calc3(Nd,:));
        Rabs2(Nd) = mean(R_auto_sim_abs2(Nd,:));
        %PDFs.
        [bins_R_auto_sim_angle{Nd,1},binsfit_R_auto_sim_angle{Nd,1}, pdf_R_auto_sim_angle{Nd,1},pdffit_R_auto_sim_angle{Nd,1}] = distfit(R_auto_sim_angle(Nd,:),Nbins,'pdf','normal');
        [P{Nd,1},B(Nd,1),K(Nd,1)] =  ComplexGaussPhasePDF(R_auto_sim_real_mean(Nd), R_auto_sim_real_var(Nd), R_auto_sim_imag_var(Nd), phase_step);
        [P2{Nd,1},B2(Nd,1),K2(Nd,1)] =  ComplexGaussPhasePDF(R_auto_sim_real_mean(Nd), R_auto_sim_real_var(Nd),1/(2*M_in_algo), phase_step);
        [P3{Nd,1},B3(Nd,1),K3(Nd,1)] =  ComplexGaussPhasePDF(R_auto_sim_real_mean(Nd), 1/(2*M_in_algo),1/(2*M_in_algo), phase_step);
        
        [bins_cor2{Nd,1},bins_fit_cor2{Nd,1}, pdf_cor2{Nd,1},pdf_fit_cor2{Nd,1}] = distfit(test_stat_cor2(Nd,:),Nbins,'pdf','normal');
        [~,bins_fit_cor2_G{Nd,1}, ~,pdf_fit_cor2_G{Nd,1}] = distfit(-1*test_stat_cor2(Nd,:),Nbins,'pdf','extreme value');
        
        pdf_fit_cor2_G{Nd,1} = pdf_fit_cor2_G{Nd,1}(end:-1:1);
        bins_fit_cor2_G{Nd,1} = -1*bins_fit_cor2_G{Nd,1}(end:-1:1);
        
        
        
        % Semi analytical theory of SKAB
        mod_thres = sqrt(2*R_auto_noise_real_var)*erfcinv(2*Pfa) + R_auto_noise_real_m;
        mod_upper = mod_thres - R_auto_cor2_real_mean(Nd);
        mod_lower = sqrt(2*R_auto_cor2_real_var(Nd));
        Pd_SKAB(Nd) = (1/2)*erfc(mod_upper/mod_lower);
        
        delta_mu(Nd) = mod_thres -  R_auto_cor2_real_mean(Nd) - erfcinv(2*P_D_SKA2(Nd))*sqrt(2*R_auto_cor2_real_var(Nd));
        delta_eta(Nd) = R_auto_cor2_real_mean(Nd) - mod_thres + erfcinv(2*P_D_SKA2(Nd))*sqrt(2*R_auto_cor2_real_var(Nd));
        
        disp(['Simulation analysis: The value of M is: ',num2str(N_OFDM_symbols_vec(nn)),' SNR value: ',num2str(SNR_vec_dB(Nd)),' completed. Max value: ',num2str(SNR_vec_dB(end)),'. Step value: ',num2str(SNR_step_dB),'.'])
    end
    
%     figure(1)
%     plot(SNR_vec_dB,P_D,'-bs')
%     hold on; grid on
%     plot(SNR_vec_dB,Pd_auto_rho,'-rs')
%     plot(SNR_vec_dB,Pd_SKAB,'-ms')
%     plot(SNR_vec_dB,P_D_SKA2,'-ks')
%     plot(SNR_vec_dB,P_D_WC1,'-cs')
%     plot(SNR_vec_dB,P_D_SKA_WC1,'gs')
%     cd(save_path)    
%     save(['SKAB_analysis',num2str(N_OFDM_symbols_vec(nn)),'.mat'])
%     cd(cdir)
end

