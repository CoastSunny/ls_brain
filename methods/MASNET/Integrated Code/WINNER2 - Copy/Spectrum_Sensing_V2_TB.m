%% The autocorrelation spectrum sensing algorithm with testbed channels and 
%% associated hardware FFO correction stratagy.

clear


%% General simulation and testbed parameters.

% Save results, options: 'y' or 'n' (path set in next cell).
save_results = 'n';

% Probability of false alarm Signal Detector Parameters.
Pfa = 0.1;

% Sampling frequency (must be taken from literature for whatever type of
% signal is being loaded).
fs = 30.72e6;

% Sampling interval.
ts = 1/fs;

% SNR range (must correspond to filenames of testbed data!).
SNRdB = [-20:3:16]; % SNR Value in dB

% SNR range for look-up table
SNR_vec_LUT = [-30:20];


% Total sample length (hard encode to save time, run 'How_Many_Samples.m').
S_tot = 41943040;

% FFT size, CP size, FFO correction signal length. 
T_d = 2048;
T_c = 144;


% Reference recorded amount of samples to maximum allowed for LTE20 for
% fairness.
yffo_len = 2*T_d + T_c;

% Number of possible autocorrelations.
N_autocorr =  (S_tot -  mod(S_tot,yffo_len))/yffo_len;

% Number of windows, yffo_len in length, to average
N_windows = 50;

% Sample length for the detector.
N_OFDM_symbols = 6;    
M = N_OFDM_symbols*yffo_len;
M_in_algo = M-T_d;

% Number of simulation to run. 
nr_sims_pd = 5000;

% Look-up table for imaginary component.
LUT_imag = randn(10*nr_sims_pd,1);
LUT_imag = LUT_imag - mean(LUT_imag);
LUT_imag = LUT_imag/std(LUT_imag);
LUT_imag = LUT_imag*sqrt(1/(2*(M-T_d)));  %Note M is M - T_d in autocorrdetV2

% Look-up table for real component.
LUT_real = randn(10*nr_sims_pd,1);
LUT_real = LUT_real - mean(LUT_real);
LUT_real = LUT_real/std(LUT_real);
LUT_real = LUT_real*sqrt(1/(2*(M-T_d)));  %Note M is M - T_d in autocorrdetV2 

% Angle and noise.
LUT_angle = randn(10*nr_sims_pd,1);
LUT_angle = LUT_angle - mean(LUT_angle);
LUT_angle = LUT_angle/std(LUT_angle);

LUT_noise = LUT_real + j*LUT_imag;

% Phase PDF step.
phase_step = (2*pi)/180;
bins_P = [-pi:phase_step:pi];
Nbins = 50;

% Uniform number LUT (based on the phase step).
uni_LUT = rand(1,length(bins_P));


% Distribution to fit.
dist = 'normal';

% IQ imbalance.
eta = 0;
delta_theta = 0;
alpha = cos(delta_theta) + j*eta*sin(delta_theta);
beta = eta*cos(delta_theta) - j*sin(delta_theta);

% Frequency offset factor.
deltaf = 15e3;
f_0 = 0.7*deltaf;
F = exp(j*2*pi*f_0*[1:M]*ts);

% Channel paramaters for Rayleigh channel.
PathDelays = [0e-9, 50e-9, 110e-9, 170e-9, 290e-9, 310e-9];   % ITU indoor channel model - office
powers = [0,-3,-10,-18,-26,-32];

% Channel paramaters for Rician channel.
K_dB = 33;
K_lin = 10^(K_dB/10);


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



%% Calculate number of bins, histogram and PDF of real part of autocorrelation function.


% Initialise arrays and cells

R_auto_sim = zeros(length(SNRdB), nr_sims_pd);
R_auto_sim2 = zeros(length(SNRdB), nr_sims_pd);
R_auto_sim3 = zeros(length(SNRdB), nr_sims_pd);
R_auto_sim4 = zeros(length(SNRdB), nr_sims_pd);
R_auto_sim3_WC = zeros(length(SNRdB), nr_sims_pd);
R_auto_sim4_WC = zeros(length(SNRdB), nr_sims_pd);

R_auto_meas = zeros(length(SNRdB), nr_sims_pd);
R_auto_meas2 = zeros(length(SNRdB), nr_sims_pd);
R_auto_meas3 = zeros(length(SNRdB), nr_sims_pd);
R_auto_meas4 = zeros(length(SNRdB), nr_sims_pd);
R_auto_meas3_WC = zeros(length(SNRdB), nr_sims_pd);
R_auto_meas4_WC = zeros(length(SNRdB), nr_sims_pd);

test_stat_meas = zeros(length(SNRdB), nr_sims_pd);
test_stat_meas2 = zeros(length(SNRdB), nr_sims_pd);
test_stat_meas3 = zeros(length(SNRdB), nr_sims_pd);
test_stat_meas4 = zeros(length(SNRdB), nr_sims_pd);
test_stat_sim = zeros(length(SNRdB), nr_sims_pd);
test_stat_sim2 = zeros(length(SNRdB), nr_sims_pd);
test_stat_sim3 = zeros(length(SNRdB), nr_sims_pd);
test_stat_sim4 = zeros(length(SNRdB), nr_sims_pd);
R_angle = zeros(length(SNRdB), nr_sims_pd);

dec_auto_cor_n = zeros(1, nr_sims_pd);
test_stat_cor_n = zeros(1,nr_sims_pd);
R_auto_cor_n = zeros(1, nr_sims_pd);

dec_auto_cor_TBn = zeros(1, nr_sims_pd);
test_stat_cor_TBn = zeros(1, nr_sims_pd);
R_auto_cor_TBn = zeros(1, nr_sims_pd);

dec_auto_cor_n_stan = zeros(1, nr_sims_pd);
test_stat_cor_n_stan = zeros(1,nr_sims_pd);
R_auto_cor_n_stan = zeros(1, nr_sims_pd);

dec_auto_cor_TBn_stan = zeros(1, nr_sims_pd);
test_stat_cor_TBn_stan = zeros(1, nr_sims_pd);
R_auto_cor_TBn_stan = zeros(1, nr_sims_pd);


Pd_SK_auto_rho = zeros(1,length(SNRdB));
Pd_auto_rho = zeros(1,length(SNRdB));


dec_auto_meas = zeros(length(SNRdB), nr_sims_pd);
dec_auto_meas2 = zeros(length(SNRdB), nr_sims_pd);
dec_auto_meas3 = zeros(length(SNRdB), nr_sims_pd);
dec_auto_meas4 = zeros(length(SNRdB), nr_sims_pd);
dec_auto_sim = zeros(length(SNRdB), nr_sims_pd);
dec_auto_sim2 = zeros(length(SNRdB), nr_sims_pd);
dec_auto_sim3 = zeros(length(SNRdB), nr_sims_pd);
dec_auto_sim4 = zeros(length(SNRdB), nr_sims_pd);
R_meas_corr = zeros(1,length(SNRdB));
R_meas_corr2 = zeros(1,length(SNRdB));

R_sim_angle_var = zeros(1,length(SNRdB));



bins_meas_R_real_pdf = cell(length(SNRdB), 1); 
binsfit_meas_R_real_pdf = cell(length(SNRdB), 1); 
R_meas_real_pdf = cell(length(SNRdB), 1); 
R_meas_real_fitpdf = cell(length(SNRdB), 1); 
bins_imag_R_imag_pdf = cell(length(SNRdB), 1); 
binsfit_meas_R_imag_pdf = cell(length(SNRdB), 1); 
R_meas_imag_pdf = cell(length(SNRdB), 1); 
R_meas_imag_fitpdf = cell(length(SNRdB), 1);


bins_meas_R_real_pdf2 = cell(length(SNRdB), 1); 
binsfit_meas_R_real_pdf2 = cell(length(SNRdB), 1); 
R_meas_real_pdf2 = cell(length(SNRdB), 1); 
R_meas_real_fitpdf2 = cell(length(SNRdB), 1); 
bins_meas_R_imag_pdf2 = cell(length(SNRdB), 1); 
binsfit_meas_R_imag_pdf2 = cell(length(SNRdB), 1); 
R_meas_meas_pdf2 = cell(length(SNRdB), 1); 
R_meas_meas_fitpdf2 = cell(length(SNRdB), 1);


bins_sim_R_real_pdf2 = cell(length(SNRdB), 1); 
binsfit_sim_R_real_pdf2 = cell(length(SNRdB), 1); 
R_sim_real_pdf2 = cell(length(SNRdB), 1); 
R_sim_real_fitpdf2 = cell(length(SNRdB), 1);
bins_sim_R_imag_pdf2 = cell(length(SNRdB), 1); 
binsfit_sim_R_imag_pdf2 = cell(length(SNRdB), 1); 
R_sim_imag_pdf2 = cell(length(SNRdB), 1); 
R_sim_imag_fitpdf2 = cell(length(SNRdB), 1);


bins_sim_R_real_pdf = cell(length(SNRdB), 1); 
binsfit_sim_R_real_pdf = cell(length(SNRdB), 1); 
R_sim_real_pdf = cell(length(SNRdB), 1); 
R_sim_real_fitpdf = cell(length(SNRdB), 1); 
bins_sim_R_imag_pdf = cell(length(SNRdB), 1); 
binsfit_sim_R_imag_pdf = cell(length(SNRdB), 1); 
R_sim_imag_pdf = cell(length(SNRdB), 1); 
R_sim_imag_fitpdf = cell(length(SNRdB), 1); 

SNRdB2 = zeros(length(SNRdB),1);

bins_sim_test_stat_pdf = cell(length(SNRdB), 1);
binsfit_sim_test_stat_pdf = cell(length(SNRdB), 1);
test_stat_sim_pdf = cell(length(SNRdB), 1);
test_stat_sim_fitpdf = cell(length(SNRdB), 1);

bins_sim2_test_stat_pdf = cell(length(SNRdB), 1);
binsfit_sim2_test_stat_pdf = cell(length(SNRdB), 1);
test_stat_sim2_pdf = cell(length(SNRdB), 1);
test_stat_sim2_fitpdf = cell(length(SNRdB), 1);

  
bins_test_stat_meas2_pdf = cell(length(SNRdB), 1);
binsfit_test_stat_meas2_pdf = cell(length(SNRdB), 1);
test_stat_meas2_pdf = cell(length(SNRdB), 1);
test_stat_meas2_fitpdf = cell(length(SNRdB), 1);

R_sim_angle = zeros(length(SNRdB), nr_sims_pd);
bins_R_sim_angle = cell(length(SNRdB), 1);    
binsfit_R_sim_angle = cell(length(SNRdB), 1);
pdf_R_sim_angle = cell(length(SNRdB), 1);
pdffit_R_sim_angle = cell(length(SNRdB), 1);

R_sim2_angle = zeros(length(SNRdB), nr_sims_pd);
bins_R_sim2_angle = cell(length(SNRdB), 1);    
binsfit_R_sim2_angle = cell(length(SNRdB), 1);
pdf_R_sim2_angle = cell(length(SNRdB), 1);
pdffit_R_sim2_angle = cell(length(SNRdB), 1);

R_meas_angle = zeros(length(SNRdB), nr_sims_pd);
bins_R_meas_angle = cell(length(SNRdB), 1);    
binsfit_R_meas_angle = cell(length(SNRdB), 1);
pdf_R_meas_angle = cell(length(SNRdB), 1);
pdffit_R_meas_angle = cell(length(SNRdB), 1);

%% Look table
rho_LUT = zeros(1,length(SNR_vec_LUT));
for Nd = 1:length(SNR_vec_LUT)
    % LUT for rho.
    rho_LUT(Nd) = (T_c/(T_d + T_c))*(10^(SNR_vec_LUT(Nd)/10))/((10^(SNR_vec_LUT(Nd)/10)) + 1); 
end

% Constant and offset to remove look-up table precision problems.
precision_factor = 1/rho_LUT(2);
offset_factor = (precision_factor^2)*((10/(sqrt(2*M_in_algo)))^2);


% Load simulated signal.
 sig_sim = 0;
 cd(sim_path)
 sig_sim = load([signal_type,'.mat']);
 cd(TB_noise_path);
 TB_noise = load('Noise.mat');
 TB_noise =  TB_noise.Noise;
 cd(cdir)
 noise_loop = 0;
 
 %% Statistics of noise to set mean in threshold of new algorithm.
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
    [dec_auto_cor_n(sim_index ), test_stat_cor_n(sim_index), R_auto_cor_n(sim_index)] = autocorrdetV2(sim_noise_vec,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'none',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor);
    [dec_auto_cor_TBn(sim_index ), test_stat_cor_TBn(sim_index), R_auto_cor_TBn(sim_index)] = autocorrdetV2(TB_noise_vec,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'none',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor);
    
    [dec_auto_cor_n_stan(sim_index ), test_stat_cor_n_stan(sim_index), R_auto_cor_n_stan(sim_index)] = autocorrdetV2(sim_noise_vec,Pfa,T_d,'Standard1');
    [dec_auto_cor_TBn_stan(sim_index ), test_stat_cor_TBn_stan(sim_index), R_auto_cor_TBn_stan(sim_index)] = autocorrdetV2(TB_noise_vec,Pfa,T_d,'Standard1');
end

% r_sim_chan,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'none',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor,R_auto_noise_real_m

Nbins = 50;
%SKAB
[bins_R_auto_sim_real_n,binsfit_R_auto_sim_real_n, pdf_R_auto_sim_real_n,pdffit_R_auto_sim_real_n] = distfit(test_stat_cor_n,Nbins,'pdf','normal');
[~,binsfit_R_auto_sim_real_ev,~,pdffit_R_auto_sim_real_ev] = distfit(-1*test_stat_cor_n,Nbins,'pdf','extreme value');

[bins_R_auto_sim_real_TBn,binsfit_R_auto_sim_real_TBn, pdf_R_auto_sim_real_TBn,pdffit_R_auto_sim_real_TBn] = distfit(test_stat_cor_TBn,Nbins,'pdf','normal');
[~,binsfit_R_auto_sim_real_TBev,~,pdffit_R_auto_sim_real_TBev] = distfit(-1*test_stat_cor_TBn,Nbins,'pdf','extreme value');


%CAB
[bins_R_auto_sim_real_n_stan,binsfit_R_auto_sim_real_n_stan, pdf_R_auto_sim_real_n_stan,pdffit_R_auto_sim_real_n_stan] = distfit(test_stat_cor_n_stan,Nbins,'pdf','normal');
[bins_R_auto_sim_real_TBn_stan,binsfit_R_auto_sim_real_TBn_stan, pdf_R_auto_sim_real_TBn_stan,pdffit_R_auto_sim_real_TBn_stan] = distfit(test_stat_cor_TBn_stan,Nbins,'pdf','normal');


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
 

%% Simulation and testbed.
 % Run simulation and post-process testbed signals for comparison.
for snr_index = 1:length(SNRdB) 
    clc; disp(['SNR iteration: ', int2str(snr_index),' out of: ', int2str(length(SNRdB)),'.']);   
    % Load testbed  signal (large and SNR dependent).
    sig = 0;
    cd(meas_path)    
    sig = load(['SNR',int2str(SNRdB(snr_index)),'.mat']);
    SNRdB2(snr_index) = sig.SNR_actual;
    
    % Probability of dectection dased on the analytical model.
    rho_calc(snr_index) = (T_c/(T_d + T_c))*(10^(sig.SNR_actual/10))/((10^(sig.SNR_actual/10)) + 1);
    mod_thres = (1/(sqrt(M)))*erfcinv(2*Pfa);
    mod_upper = mod_thres - rho_calc(snr_index);
    mod_lower = 1 - (rho_calc(snr_index)^2);
    Pd_auto_rho(snr_index) = (1/2)*erfc(sqrt(M)*(mod_upper/mod_lower));
    
    % Probability of dectection dased on the analytical model for new algorithm.
    mod_thres = sqrt(2*R_auto_noise_real_TBvar)*erfcinv(2*Pfa) + R_auto_noise_real_TBm;
    %mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa) + R_auto_noise_real_TBm;
    mod_upper = mod_thres - rho_calc(snr_index);
    mod_lower = (1 - (rho_calc(snr_index)^2))*sqrt(2*R_auto_noise_real_TBvar);
    Pd_SK_auto_rho(snr_index) = (1/2)*erfc((mod_upper/mod_lower));
    
    
    LUT_angle = LUT_angle*sqrt(Angle_var(snr_index));
    LUT_index = 0;
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
        
        LUT_index = LUT_index + 1;       
          
             
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
        
        cd(cdir)  
%         
%         [dec_auto_sim(snr_index,sim_index), test_stat_sim(snr_index,sim_index), R_auto_sim(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1');
%         [dec_auto_sim4(snr_index,sim_index), test_stat_sim4(snr_index,sim_index), R_auto_sim4(snr_index,sim_index), R_auto_sim4_WC(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2');
%         [dec_auto_sim2(snr_index,sim_index), test_stat_sim2(snr_index,sim_index), R_auto_sim2(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'FO_Corrected18',LUT_imag,sim_index,LUT_angle(sim_index),T_c);
%         [dec_auto_sim3(snr_index,sim_index), test_stat_sim3(snr_index,sim_index), R_auto_sim3(snr_index,sim_index),  R_auto_sim3_WC(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'FO_Corrected18',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2');
%         [dec_auto_meas(snr_index,sim_index), test_stat_meas, R_auto_meas(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'Standard1');
%         [dec_auto_meas4(snr_index,sim_index), test_stat_meas4, R_auto_meas4(snr_index,sim_index), R_auto_meas4_WC(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'Standard1',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2');
%         [dec_auto_meas2(snr_index,sim_index), test_stat_meas2(snr_index,sim_index), R_auto_meas2(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'FO_Corrected18',LUT_imag,sim_index,LUT_angle(sim_index),T_c);
%         [dec_auto_meas3(snr_index,sim_index), test_stat_meas3(snr_index,sim_index), R_auto_meas3(snr_index,sim_index), R_auto_meas3_WC(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'FO_Corrected18',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2');
%        
         

        [dec_auto_sim(snr_index,sim_index), test_stat_sim(snr_index,sim_index), R_auto_sim(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1');
        [dec_auto_sim4(snr_index,sim_index), test_stat_sim4(snr_index,sim_index), R_auto_sim4(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor);
        [dec_auto_sim2(snr_index,sim_index), test_stat_sim2(snr_index,sim_index),R_auto_sim2(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'none',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor);
        [dec_auto_sim3(snr_index,sim_index), test_stat_sim3(snr_index,sim_index), R_auto_sim3(snr_index,sim_index)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor);
        [dec_auto_meas(snr_index,sim_index), test_stat_meas, R_auto_meas(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'Standard1');
        [dec_auto_meas4(snr_index,sim_index), test_stat_meas4, R_auto_meas4(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'Standard1',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor,R_auto_noise_real_TBm,R_auto_noise_real_TBvar);
        [dec_auto_meas2(snr_index,sim_index), test_stat_meas2(snr_index,sim_index), R_auto_meas2(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'none',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor,R_auto_noise_real_TBm,R_auto_noise_real_TBvar);
        [dec_auto_meas3(snr_index,sim_index), test_stat_meas3(snr_index,sim_index), R_auto_meas3(snr_index,sim_index)] = autocorrdetV2(r_meas,Pfa,T_d,'FO_Corrected22',LUT_imag,sim_index,LUT_angle(sim_index),T_c,'WC2',N_windows,rho_LUT,precision_factor,phase_step,uni_LUT,offset_factor,R_auto_noise_real_TBm,R_auto_noise_real_TBvar);
       


    end
    

      
% The correlation between Re{R} and Im{R}

R_meas1_re_mu = mean(real(R_auto_meas(snr_index,:)));
R_meas1_im_mu = mean(imag(R_auto_meas(snr_index,:)));
R_meas2_re_mu = mean(real(R_auto_meas2(snr_index,:)));
R_meas2_im_mu = mean(imag(R_auto_meas2(snr_index,:)));

R_meas1_re_wo_mu = real(R_auto_meas(snr_index,:)) - R_meas1_re_mu;
R_meas1_im_wo_mu = imag(R_auto_meas(snr_index,:)) - R_meas1_im_mu;
R_meas2_re_wo_mu = real(R_auto_meas2(snr_index,:)) - R_meas2_re_mu;
R_meas2_im_wo_mu = imag(R_auto_meas2(snr_index,:)) - R_meas2_im_mu;


R_meas_corr(snr_index) = (mean(R_meas1_re_wo_mu.*R_meas1_im_wo_mu))/(std(real(R_auto_meas(snr_index,:)))*std(imag(R_auto_meas(snr_index,:))));
R_meas_corr2(snr_index) = (mean(R_meas2_re_wo_mu.*R_meas2_im_wo_mu))/(std(real(R_auto_meas2(snr_index,:)))*std(imag(R_auto_meas2(snr_index,:))));


R_sim_angle(snr_index,:) = angle(R_auto_sim(snr_index,:));
R_sim_angle_var(snr_index) = var(R_sim_angle(snr_index,:));
R_sim2_angle(snr_index,:) = angle(R_auto_sim2(snr_index,:));
R_meas_angle(snr_index,:) = angle(R_auto_meas(snr_index,:));


    
 %% First order statistical analysis of correlation. 
 
 
    % Fit pdf for analysis
    Nbins = 25;
    %[~, Nbins] = binwidth(real(R_auto_meas(snr_index,:)));
    [bins_meas_R_real_pdf{snr_index,1},binsfit_meas_R_real_pdf{snr_index,1}, R_meas_real_pdf{snr_index,1},R_meas_real_fitpdf{snr_index,1}] =  distfit(real(R_auto_meas(snr_index,:)),Nbins,'cdf','normal');
     Rreal_meas_var(snr_index) = var(real(R_auto_meas(snr_index,:)));
     Rreal_meas_mean(snr_index) = mean(real(R_auto_meas(snr_index,:))); 
     
     
     
    
     [bins_R_sim_angle{snr_index,1},binsfit_R_sim_angle{snr_index,1}, pdf_R_sim_angle{snr_index,1},pdffit_R_sim_angle{snr_index,1}] = distfit(R_sim_angle(snr_index,:),Nbins,'pdf','normal');
     [bins_R_sim2_angle{snr_index,1},binsfit_R_sim2_angle{snr_index,1}, pdf_R_sim2_angle{snr_index,1},pdffit_R_sim2_angle{snr_index,1}] = distfit(R_sim2_angle(snr_index,:),Nbins,'pdf','normal'); 
     [bins_R_meas_angle{snr_index,1},binsfit_R_meas_angle{snr_index,1}, pdf_R_meas_angle{snr_index,1},pdffit_R_meas_angle{snr_index,1}] = distfit(R_meas_angle(snr_index,:),Nbins,'pdf','normal'); 
     
    
%     %[~, Nbins] = binwidth(real(R_auto_meas(snr_index,:)));
%     [bins_R_angle_pdf{snr_index,1}, R_angle_pdf{snr_index,1}] =  distfit(R_angle(snr_index,:),Nbins);
%     
%      %[~, Nbins] = binwidth(real(R_auto_meas(snr_index,:)));
%     [bins_R_angle_sim_pdf{snr_index,1}, R_angle_sim_pdf{snr_index,1}] =  distfit(R_sim_angle(snr_index,:),Nbins);
%     
%     %Nbins = 0;
    %[~, Nbins] = binwidth(imag(R_auto_meas(snr_index,:)));
     [bins_meas_R_imag_pdf{snr_index,1},binsfit_meas_R_imag_pdf{snr_index,1},R_meas_imag_pdf{snr_index,1},R_meas_imag_fitpdf{snr_index,1}] =  distfit(imag(R_auto_meas(snr_index,:)),Nbins,'cdf','normal');
     Rimag_meas_var(snr_index) = var(imag(R_auto_meas(snr_index,:)));
     Rimag_meas_mean(snr_index) = mean(imag(R_auto_meas(snr_index,:))); 
     
     
     
     
     
     Rboth_meas = imag(R_auto_meas(snr_index,:)) + real(R_auto_meas(snr_index,:));
     Rboth_meas_var(snr_index) = var(Rboth_meas);
     Rboth_meas_mean(snr_index) = mean(Rboth_meas);     
     [bins_meas_R_both_pdf{snr_index,1},binsfit_meas_R_both_pdf{snr_index,1},R_meas_both_pdf{snr_index,1},R_meas_both_fitpdf{snr_index,1}] =  distfit(Rboth_meas,Nbins,'cdf','normal'); 



%     %Nbins = 0;
%     %[~, Nbins] = binwidth(real(R_auto_meas2(snr_index,:)));
%     [bins_meas_R_real_pdf2{snr_index,1}, R_meas_real_pdf2{snr_index,1}] =  distfit(real(R_auto_meas2(snr_index,:)),Nbins);
%     
%     %Nbins = 0;
%     %[~, Nbins] = binwidth(imag(R_auto_meas2(snr_index,:)));
%     [bins_meas_R_imag_pdf2{snr_index,1}, R_meas_imag_pdf2{snr_index,1}] =  distfit(imag(R_auto_meas2(snr_index,:)),Nbins);
%     
%     %     
%     
%     %Nbins = 0;
%     %[~, Nbins] = binwidth(real(R_auto_sim(snr_index,:)));
      [bins_sim_R_real_pdf{snr_index,1},binsfit_sim_R_real_pdf{snr_index,1},R_sim_real_pdf{snr_index,1},R_sim_real_fitpdf{snr_index,1}] =  distfit(real(R_auto_sim(snr_index,:)),Nbins,'cdf','normal');
       Rreal_sim_var(snr_index) = var(real(R_auto_sim(snr_index,:)));
       Rreal_sim_mean(snr_index) = mean(real(R_auto_sim(snr_index,:))); 




%     %Nbins = 0;
      %[~, Nbins] = binwidth(imag(R_auto_sim(snr_index,:)));
      [bins_sim_R_imag_pdf{snr_index,1},binsfit_sim_R_imag_pdf{snr_index,1},R_sim_imag_pdf{snr_index,1},R_sim_imag_fitpdf{snr_index,1}] =  distfit(imag(R_auto_sim(snr_index,:)),Nbins,'cdf','normal');
     Rimag_sim_var(snr_index) = var(imag(R_auto_sim(snr_index,:)));
     Rimag_sim_mean(snr_index) = mean(imag(R_auto_sim(snr_index,:))); 



     Rboth_sim = imag(R_auto_sim(snr_index,:)) + real(R_auto_sim(snr_index,:));
     Rboth_sim_var(snr_index) = var(Rboth_sim);
     Rboth_sim_mean(snr_index) = mean(Rboth_sim);     
     [bins_sim_R_both_pdf{snr_index,1},binsfit_sim_R_both_pdf{snr_index,1},R_sim_both_pdf{snr_index,1},R_sim_both_fitpdf{snr_index,1}] =  distfit(Rboth_sim,Nbins,'cdf','normal'); 


     [bins_sim_test_stat_pdf{snr_index,1},binsfit_sim_test_stat_pdf{snr_index,1},test_stat_sim_pdf{snr_index,1},test_stat_sim_fitpdf{snr_index,1}] =  distfit(test_stat_sim(snr_index,:),Nbins,'pdf','normal');
     [bins_sim2_test_stat_pdf{snr_index,1},binsfit_sim2_test_stat_pdf{snr_index,1},test_stat_sim2_pdf{snr_index,1},test_stat_sim2_fitpdf{snr_index,1}] =  distfit(test_stat_sim2(snr_index,:),Nbins,'pdf','normal');      
     [bins_test_stat_meas2_pdf{snr_index,1},binsfit_test_stat_meas2_pdf{snr_index,1},test_stat_meas2_pdf{snr_index,1},test_stat_meas2_fitpdf{snr_index,1}] =  distfit(test_stat_meas2(snr_index,:),Nbins,'pdf','normal'); 
     
     
     
     
%     %Nbins = 0;
%     %[~, Nbins] = binwidth(real(R_auto_sim_noise(snr_index,:)));
%     [bins_sim_noise_R_real_pdf{snr_index,1}, R_sim_noise_real_pdf{snr_index,1}] =  distfit(real(R_auto_sim_noise(snr_index,:)),Nbins);
%     
%     %Nbins = 0;
%     %[~, Nbins] = binwidth(imag(R_auto_sim_noise(snr_index,:)));
%     [bins_sim_noise_R_imag_pdf{snr_index,1}, R_sim_noise_imag_pdf{snr_index,1}] =  distfit(imag(R_auto_sim_noise(snr_index,:)),Nbins);
    
    
    
end
 
%% Calculate probability of detection.

% Based on the decisions.
Pd_auto_meas = sum(dec_auto_meas,2)/nr_sims_pd;
Pd_auto_meas2 = sum(dec_auto_meas2,2)/nr_sims_pd;
Pd_auto_meas3 = sum(dec_auto_meas3,2)/nr_sims_pd;
Pd_auto_meas4 = sum(dec_auto_meas4,2)/nr_sims_pd;
Pd_auto_sim = sum(dec_auto_sim,2)/nr_sims_pd;
Pd_auto_sim2 = sum(dec_auto_sim2,2)/nr_sims_pd;
Pd_auto_sim3 = sum(dec_auto_sim3,2)/nr_sims_pd;
Pd_auto_sim4 = sum(dec_auto_sim4,2)/nr_sims_pd;






%% Plots for basic inspection

plot_threshold = (1/sqrt(M-T_d))*erfcinv(2*Pfa);
% Choose SNR
s = 1;

LW = 3;
MS = 10;
FS = 25;


figure(4)
prboth_sim_var = plot(SNRdB2, Rboth_sim_var,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
hold on
grid on
primag_sim_var = plot(SNRdB2, Rimag_sim_var,'-gs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
prreal_sim_var = plot(SNRdB2, Rreal_sim_var,'-r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
prboth_meas_var = plot(SNRdB2, Rboth_meas_var,'--bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
primag_meas_var = plot(SNRdB2, Rimag_meas_var,'--gs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
prreal_meas_var = plot(SNRdB2, Rreal_meas_var,'--r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
title(['Variance of R for signal: ',signal_type]);
legend([prboth_sim_var, primag_sim_var, prreal_sim_var, prboth_meas_var primag_meas_var prreal_meas_var], 'Both(Sim)', 'Imag(Sim)','Real(Sim)','Both(Meas)','Imag(Meas)','Real(Meas)','Location','Best')
xlabel('SNR, [dB]')
ylabel('\rho')

figure(5)
prboth_sim_mean = plot(SNRdB2, Rboth_sim_mean,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
hold on
grid on
primag_sim_mean = plot(SNRdB2, Rimag_sim_mean,'-gs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
prreal_sim_mean = plot(SNRdB2, Rreal_sim_mean,'-r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
prboth_meas_mean = plot(SNRdB2, Rboth_meas_mean,'--bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
primag_meas_mean = plot(SNRdB2, Rimag_meas_mean,'--gs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
prreal_meas_mean = plot(SNRdB2, Rreal_meas_mean,'--r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
title(['Mean of R for signal: ',signal_type])
legend([prboth_sim_mean, primag_sim_mean, prreal_sim_mean, prboth_meas_mean primag_meas_mean prreal_meas_mean], 'Both(Sim)', 'Imag(Sim)','Real(Sim)','Both(Meas)','Imag(Meas)','Real(Meas)','Location','Best')
xlabel('SNR, [dB]')
ylabel('\rho')

% R

Rsim =  mean(abs(R_auto_sim),2);
Rsim2 =  mean(abs(R_auto_sim2),2);
Rmeas2 = mean(abs(R_auto_meas2),2);
Rmeas = mean(abs(R_auto_meas),2);

figure(1)
Rsim_abs_plot = plot(SNRdB2, Rsim,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
hold on
grid on
R_sim2_abs_plot = plot(SNRdB2, Rsim2,'-ks','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5) 
Rmeas_abs_plot = plot(SNRdB2,Rmeas,'-r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
Rmeas2_abs_plot = plot(SNRdB2,Rmeas2,'-go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
legend([Rsim_abs_plot, R_sim2_abs_plot, Rmeas_abs_plot, Rmeas2_abs_plot], 'Simulation1', 'Simulation2','Testbed','Testbed2','Location','Best')
xlabel('SNR, [dB]')
ylabel('R')

% R

Rsim_re =  mean(real(R_auto_sim),2);
Rsim2_re =  mean(real(R_auto_sim2),2);
Rmeas2_re = mean(test_stat_meas2,2);
Rmeas_re = mean(real(R_auto_meas),2);


figure(2)
Rrsim = plot(SNRdB2, Rsim_re,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
hold on
grid on
Rrsim2 = plot(SNRdB2, Rsim2_re,'-ms','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
Rrmeas = plot(SNRdB2, Rmeas_re,'-r^','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
Rrcorr = plot(SNRdB2, Rmeas2_re,'-go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
rho_calcplot = plot(SNRdB2,rho_calc,'-c<','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
legend([Rrsim, Rrsim2, Rrmeas, Rrcorr, rho_calcplot], 'Simulation1', 'Simulation2', 'Testbed', 'Testbed FO corrected','Model','Location','Best')
xlabel('SNR, [dB]')
ylabel('\rho')



figure(3)
pdsim = plot(SNRdB2, Pd_auto_sim,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
hold on
grid on
pdsim2 = plot(SNRdB2, Pd_auto_sim2,'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdsim3 = plot(SNRdB2, Pd_auto_sim3,'-m*','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdsim4 = plot(SNRdB2, Pd_auto_sim4,'--m>','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdmeas = plot(SNRdB2, Pd_auto_meas,'-rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdmeas2 = plot(SNRdB2, Pd_auto_meas2,'-go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdmeas3 = plot(SNRdB2, Pd_auto_meas3,'-g*','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdmeas4 = plot(SNRdB2, Pd_auto_meas4,'--g>','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdrho = plot(SNRdB2, Pd_auto_rho,'-co','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)  
legend([pdsim, pdsim2, pdsim3, pdsim4, pdmeas, pdmeas2,pdmeas3,pdmeas4,pdrho], 'Simulation1', 'Simulation2','Simulation (WC corrected)','Simulation (WC)','Testbed','Testbed FO corrected','Testbed (WC FO corrected)','Testbed (WC)','Anyl Model','Location','Best')
xlabel('SNR, [dB]')
ylabel('P_{D}')


% figure(13)
% pdsim = plot(SNRdB2, Pd_auto_sim,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
% hold on
% grid on
% pdrho = plot(SNRdB2, Pd_auto_rho,'--bo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
% pdmeas2 = plot(SNRdB2, Pd_auto_meas2,'-go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
% pdrho_SK = plot(SNRdB2, Pd_SK_auto_rho,'--go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5) 
% pdmeas = plot(SNRdB2, Pd_auto_meas,'-rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
% legend([pdsim, pdrho, pdmeas2, pdrho_SK, pdmeas], 'Conventional (Sim)','Conventional (Theory)','SKAB (Testbed)','SKAB (Theory),','Conventional (Testbed)','Location','Best')
% xlabel('SNR, [dB]')
% ylabel('P_{D}'


figure(13)
pdsim = plot(SNRdB2, Pd_auto_sim,'-bs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
hold on
grid on
pdrho = plot(SNRdB2, Pd_auto_rho,'--bo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
pdmeas2 = plot(SNRdB2, Pd_auto_meas2,'-go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
%pdrho_SK = plot(SNRdB2, Pd_SK_auto_rho,'--go','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5) 
pdmeas = plot(SNRdB2, Pd_auto_meas,'-rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
legend([pdsim, pdrho, pdmeas2,pdmeas], 'Simulation','Theory','SKAB (Testbed)','Conventional (Testbed)','Location','Best')
xlabel('SNR, [dB]')
ylabel('P_{D}')



for snr_index = 1:length(SNRdB)
    test_stat_meas2_var(snr_index) = var(test_stat_meas2(snr_index,:));
    test_stat_sim_var(snr_index) = var(test_stat_sim(snr_index,:));
    test_stat_meas2_mean(snr_index) = mean(test_stat_meas2(snr_index,:));
    test_stat_sim_mean(snr_index) = mean(test_stat_sim(snr_index,:));
    R_autosim_imag_var(snr_index) = var(imag(R_auto_sim(snr_index,:)));
    R_autosim_imag_mean(snr_index) = mean(imag(R_auto_sim(snr_index,:)));
end
    


figure (6)
plot(SNRdB2,test_stat_meas2_var,'r')
hold on
grid on
plot(SNRdB2,test_stat_sim_var)

figure(7)
plot(SNRdB2,test_stat_meas2_mean,'r')
hold on 
grid on
plot(SNRdB2,test_stat_sim_mean)

figure(8)
plot(bins_R_sim_angle{1},pdf_R_sim_angle{1},'k')
hold on; grid on
plot(binsfit_R_sim_angle{1},pdffit_R_sim_angle{1},'r')
plot(bins_R_sim_angle{7},pdf_R_sim_angle{7},'k')
plot(binsfit_R_sim_angle{7},pdffit_R_sim_angle{7},'g')
plot(bins_R_sim_angle{13},pdf_R_sim_angle{13},'k')
plot(binsfit_R_sim_angle{13},pdffit_R_sim_angle{13})

figure(9)
plot(bins_R_sim2_angle{1},pdf_R_sim2_angle{1},'k')
hold on; grid on
plot(binsfit_R_sim2_angle{1},pdffit_R_sim2_angle{1},'r')
plot(bins_R_sim2_angle{7},pdf_R_sim2_angle{7},'k')
plot(binsfit_R_sim2_angle{7},pdffit_R_sim2_angle{7},'g')
plot(bins_R_sim2_angle{13},pdf_R_sim2_angle{13},'k')
plot(binsfit_R_sim2_angle{13},pdffit_R_sim2_angle{13})


figure(10)
title('Simulation')
plot(bins_sim_test_stat_pdf{1},test_stat_sim_pdf{1},'k') 
hold on; grid on
plot(binsfit_sim_test_stat_pdf{1},test_stat_sim_fitpdf{1},'r')
plot(bins_sim_test_stat_pdf{7},test_stat_sim_pdf{7},'k')
plot(binsfit_sim_test_stat_pdf{7},test_stat_sim_fitpdf{7},'r')
plot(bins_sim_test_stat_pdf{13},test_stat_sim_pdf{13},'k')
plot(binsfit_sim_test_stat_pdf{13},test_stat_sim_fitpdf{13},'r')
line([plot_threshold,plot_threshold], [0,70])

figure(11)
title('Simulation w/FFO corrected')
plot(bins_sim2_test_stat_pdf{1},test_stat_sim2_pdf{1},'k') 
hold on; grid on
plot(binsfit_sim2_test_stat_pdf{1},test_stat_sim2_fitpdf{1},'r')
plot(bins_sim2_test_stat_pdf{7},test_stat_sim2_pdf{7},'k')
plot(binsfit_sim2_test_stat_pdf{7},test_stat_sim2_fitpdf{7},'r')
plot(bins_sim2_test_stat_pdf{13},test_stat_sim2_pdf{13},'k')
plot(binsfit_sim2_test_stat_pdf{13},test_stat_sim2_fitpdf{13},'r')
line([plot_threshold,plot_threshold], [0,70])

figure(12)
title('Testbed w/FFO corrected')
plot(bins_test_stat_meas2_pdf{1},test_stat_meas2_pdf{1},'k') 
hold on; grid on
plot(binsfit_test_stat_meas2_pdf{1},test_stat_meas2_fitpdf{1},'r')
plot(bins_test_stat_meas2_pdf{7},test_stat_meas2_pdf{7},'k')
plot(binsfit_test_stat_meas2_pdf{7},test_stat_meas2_fitpdf{7},'r')
plot(bins_test_stat_meas2_pdf{13},test_stat_meas2_pdf{13},'k')
plot(binsfit_test_stat_meas2_pdf{13},test_stat_meas2_fitpdf{13},'r')
line([plot_threshold,plot_threshold], [0,70])

%% Save Results for further plotting/analysis 
switch save_results
    case 'y'

cd(save_path);
save([scenario,'_',Sim_channel,'_',signal_type,'.mat'],'R_auto_sim','R_auto_meas','SNRdB2','Pd_auto_rho','R_sim_imag_pdf','R_meas_imag_fitpdf','binsfit_meas_R_imag_pdf','R_meas_real_fitpdf','binsfit_meas_R_real_pdf','R_sim_imag_fitpdf','binsfit_sim_R_imag_pdf','R_sim_real_fitpdf','binsfit_sim_R_real_pdf','bins_sim_R_real_pdf','R_sim_real_pdf','bins_meas_R_imag_pdf','R_meas_imag_pdf','bins_meas_R_real_pdf','R_meas_real_pdf','bins_sim_R_imag_pdf','R_sim_imag_fitpdf','SNRdB','Pd_auto_meas','Pd_auto_meas2','Pd_auto_sim','Pd_auto_sim2');

disp('Results saved')

    case 'n'
        
disp('Results not saved')
end




