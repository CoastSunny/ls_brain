
%% Sensor Performance.
% Using preloaded WINNER channels, assess the performance of sensors

clear

%% Noise and transmit power.

SNRdB = [-20:3:16]; % SNR Value in dB
% Sampling frequency (highest LTE).
fs = 30.72e6;

%% Tx 20 MHZ LTE signal.
signal_type = 'LTE20QAM16'; % 'LTE5QAM16', 'LTE20QAM16', 'WiMAXQAM16'
sig_sim = load([signal_type,'.mat']);

% FFT size, CP size, FFO correction signal length.
T_d = 2048;
T_c = 144;

% Probability of false alarm Signal Detector Parameters.
Pfa = 0.1;

% Reference recorded amount of samples to maximum allowed for LTE20 for
% fairness.
yffo_len = 2*T_d + T_c;

% Sample length for the detector.
N_OFDM_symbols = 3;
M = N_OFDM_symbols*yffo_len;
M_in_algo = M - T_d;


%% File paths.
cdir = cd;
Load_channels_path = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
Save_channels_path = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
Channels_name = 'WINNER_channels_smallscale';
%Channels_name = 'WINNER_channels_largescale';
% Note: There 10 receivers and 15 'drops'.
% Each drop contains 1000 channels impulse responses


%% Load channels.
cd(Load_channels_path);
WINNER_Channels = load(Channels_name);
cd(cdir);

%% Channels paramters.

switch Channels_name
    case 'WINNER_channels_smallscale'
        Tx_pos = [265; 435; 3];
        Rx_pos(:,1) = [449.0000; 250; 1.5];
        Rx_pos(:,2) = [276.0000; 175.0000; 1.5];
        Rx_pos(:,3) = [99.0000; 299.0000; 1.5];
        Rx_pos(:,4) = [469.0000;  190.0000; 1.5];
        Rx_pos(:,5) = [314.0000; 198.0000; 1.5];
        Rx_pos(:,6) = [104.0000; 283.0000; 1.5];
        Rx_pos(:,7) = [189.0000; 217.0000; 1.5];
        Rx_pos(:,8) = [463.0000; 120.0000; 1.5];
        Rx_pos(:,9) = [44.0000; 261.000; 1.5];
        Rx_pos(:,10) = [157.0000; 357.0000; 1.5];
        
        % Find nearest user to base station
        Rx_dists = zeros(1,length(Rx_pos));
        for dd = 1:length(Rx_pos)
            Rx_dists(dd) = sqrt(sum((Rx_pos(:,dd) - Tx_pos).^2));
        end
        [a,user_pos] = sort(Rx_dists);
        Nearest_user = user_pos(1);
        
        disp(['The nearest user is receiver (mobile station) number: ',num2str(Nearest_user),' .'])
        
    case 'WINNER_channels_largescale'
        Nearest_user = 1;
        disp(['The nearest user is assumed to be receiver (mobile station) number: ',num2str(Nearest_user),' .'])
end

scenario = WINNER_Channels.scenario;
CIR_out =  WINNER_Channels.CIR_out;
newdelays = WINNER_Channels.newdelays;
Fs_desired = 31e6;
N_Rxs = size(CIR_out,1);
Ndrops = size(CIR_out,2);
Temp = size(CIR_out{1,1},4);
NRx = size(CIR_out{1,1},1);
NTx = size(CIR_out{1,1},2);
CIR_length = size(CIR_out{1,1},3);
Drop_norm_reference = 1;

%% Normalisation.

% Calculation of normalisation factor (based on mean Frobenius norm of nearest user in first drop)
CIR_comp_sum = zeros(NRx, NTx, Temp);
CIR_comp_fro = zeros(1,Temp);
CIR_out_norm = cell(size(CIR_out));

for xx4 = 1:Temp
    for xx1 = 1:NRx
        for xx2 = 1:NTx
            CIR_comp_sum(xx1,xx2,xx4) = sum(CIR_out{Nearest_user,Drop_norm_reference}(xx1, xx2, :, xx4));
        end
    end
    CIR_comp_fro(xx4) = norm(CIR_comp_sum(:,:,xx4),'fro');
end

Norm_factor = mean(CIR_comp_fro);

% Normalise entire set of channel impulse reponses.
% 'CIR_out_norm' is the new cell containing normalised channel impulse responses.
% Note: Signal may be convolved with channel as in: conv(squeeze(channl_vec, signal_vec) + noise;
for rr = 1:N_Rxs
    for dd = 1:Ndrops
        for xx4 = 1:Temp
            for xx1 = 1:NRx
                for xx2 = 1:NTx
                    CIR_out_norm{rr,dd}(xx1,xx2,:,xx4) = (sqrt(NRx))*(CIR_out{rr,dd}(xx1,xx2,:,xx4)./Norm_factor); 
                end
            end
        end
    end
end


%% Theorectical and AWGN simulation of autocorrelation detector.

% Initialise arrays, cells, etc.
P_D_AWGN = zeros(1,length(SNRdB));
Pd_auto_rho = zeros(1,length(SNRdB));

dec_auto_sim_AWGN = zeros(1,Temp);
test_stat_sim_AWGN = zeros(1,Temp);
R_auto_sim_AWGN =  zeros(1,Temp);

bins_test_stat_AWGN = cell(1,length(SNRdB));
binsfit_test_stat_AWGN = cell(1,length(SNRdB));
pdf_test_stat_AWGN = cell(1,length(SNRdB));
pdffit_test_stat_AWGN = cell(1,length(SNRdB));

for snr_index = 1:length(SNRdB)  
  % Probability of dectection dased on the analytical model.
    rho_calc = (T_c/(T_d + T_c))*(10^(SNRdB(snr_index)/10))/((10^(SNRdB(snr_index)/10)) + 1);
    mod_thres = (1/(sqrt(M_in_algo)))*erfcinv(2*Pfa);
    mod_upper = mod_thres - rho_calc;
    mod_lower = 1 - (rho_calc^2);
    Pd_auto_rho(snr_index) = (1/2)*erfc(sqrt(M_in_algo)*(mod_upper/mod_lower));
    
    Noise_var_Watts = 10^(-SNRdB(snr_index)/10);
      for NT = 1:Temp          
                % Signal.
                r_sim = sig_sim.Tx_signal_vec(((NT-1)*M)+1:NT*M);
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
                [dec_auto_sim_AWGN(NT), test_stat_sim_AWGN(NT), R_auto_sim_AWGN(NT)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1');  
      end      
      P_D_AWGN(snr_index) = mean(dec_auto_sim_AWGN);
      Nbins = 50;
      [bins_test_stat_AWGN{1,snr_index},binsfit_test_stat_AWGN{1,snr_index}, pdf_test_stat_AWGN{1,snr_index}, pdffit_test_stat_AWGN{1,snr_index}] = distfit(test_stat_sim_AWGN,Nbins,'pdf','normal');      
end

%% WINNER simulation of autocorrelation detector (over SNR, user & drop number).

% Initialise arrays, cells, etc.
P_D = zeros(N_Rxs,Ndrops,length(SNRdB));

dec_auto_sim = zeros(1,Temp);
test_stat_sim = zeros(1,Temp);
R_auto_sim =  zeros(1,Temp);

bins_test_stat = cell(N_Rxs,length(SNRdB));
binsfit_test_stat = cell(N_Rxs,length(SNRdB));
pdf_test_stat = cell(N_Rxs,length(SNRdB));
pdffit_test_stat = cell(N_Rxs,length(SNRdB));

for snr_index = 1:length(SNRdB)  
    for link_K = 1:N_Rxs
        Number_of_discarded_channels = 0;
        for Nd = 1:Ndrops
            for NT = 1:Temp
                % Signal & Channel.
                r_sim = sig_sim.Tx_signal_vec(((NT-1)*M)+1:NT*M);
                r_sim = (r_sim/std(r_sim));
                chan = squeeze(CIR_out_norm{link_K,Nd}(:,:,:,NT));
                r_sim_chan_noAWGN = conv(chan, r_sim);
                % Create noise.
                noise_vec = randn(size(r_sim_chan_noAWGN)) + j*randn(size(r_sim_chan_noAWGN));
                noise_vec_mean = mean(noise_vec);
                noise_vec_mean_std = std(noise_vec);
                noise_vec = noise_vec - noise_vec_mean;
                noise_vec = noise_vec/noise_vec_mean_std;
                noise_vec =  (10^(-SNRdB(snr_index)/20))*noise_vec;
                % Signal + noise.
                r_sim_chan = r_sim_chan_noAWGN + noise_vec;
                r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan));                
                % Autocorrelation for OFDM detection.
                [dec_auto_sim(NT), test_stat_sim(NT), R_auto_sim(NT)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1');                
            end
            P_D(link_K,Nd,snr_index) = mean(dec_auto_sim);
            Nbins = 50;
            [bins_test_stat{link_K,snr_index},binsfit_test_stat{link_K,snr_index}, pdf_test_stat{link_K,snr_index},pdffit_test_stat{link_K,snr_index}] = distfit(test_stat_sim,Nbins,'pdf','normal');
            
        end
        
        disp(['Link (Sensor): ',num2str(link_K),' of: ',num2str(N_Rxs),' completed.'])
    end
    disp(['***SNR iteration: ', int2str(snr_index),' out of: ', int2str(length(SNRdB)),' completed.***']);
end
