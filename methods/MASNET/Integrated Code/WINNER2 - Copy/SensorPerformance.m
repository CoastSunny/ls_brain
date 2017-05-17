%% Sensor Performance
% Using preloaded WINNER channels, assess the performance of sensors

clear

%% Noise and transmit power.

% Noise variance based on Rx sampling at 30.72 MSamples/sec.
Noise_var_dBm = -91;
Noise_var_Watts = 10^((Noise_var_dBm - 30)/10);

% Tx power
PTx = 23;
PTx_lin = 10^((PTx-30)/10);

% Sampling frequency (highest LTE).
fs = 30.72e6;


%% Tx 20 MHZ LTE signal.
TX_20MHz_QAM16 = load('Tx_20MHz.mat');
Tx_signal_20 = TX_20MHz_QAM16.Tx_LTE_20MHz_QPSK;
Tx_signal = Tx_signal_20;


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


%% WINNER channels based on 30.72 MSamples/sec.
WINNER_Channels = load('WINNER_channels.mat','CIR_out','newdelays');
CIR = WINNER_Channels.CIR_out;
delays = WINNER_Channels.newdelays; 

% Cells are dimension link_K (channel pairing) x Nd (drop).
channel_pairing = size(CIR,1);
Ndrops = size(CIR,2);
Temp = size(CIR{1,1},4);
Total_channels = Ndrops*Temp;

% Initialise arrays, cells, etc.
dec_auto_sim = zeros(channel_pairing,Ndrops);
test_stat_sim = zeros(channel_pairing, Ndrops);
R_auto_sim = zeros(channel_pairing, Ndrops);
SNR_sim_mean = zeros(channel_pairing, Ndrops);
P_D = zeros(channel_pairing, Ndrops);

dec_auto_sim = zeros(1,Temp);
test_stat_sim = zeros(1,Temp);
R_auto_sim =  zeros(1,Temp);
SNR_sim =  zeros(1,Temp);

bins_SNR = cell(channel_pairing,1);
binsfit_SNR = cell(channel_pairing,1);
pdf_SNR = cell(channel_pairing,1);
pdffit_SNR = cell(channel_pairing,1);

bins_P_D = cell(channel_pairing,1);
binsfit_P_D = cell(channel_pairing,1);
pdf_P_D = cell(channel_pairing,1);
pdffit_P_D = cell(channel_pairing,1);



sim_index = 1;
for link_K = 1:channel_pairing
    Number_of_discarded_channels = 0;
      for Nd = 1:Ndrops
          for NT = 1:Temp
                % Signal & Channel.
                r_sim = Tx_signal(((sim_index-1)*M)+1:sim_index*M);
                r_sim = (r_sim/std(r_sim))*sqrt(PTx_lin);
                chan = squeeze(CIR{link_K,Nd}(:,:,:,NT));
                r_sim_chan_noAWGN = conv(chan, r_sim);                
                % Create noise.
                noise_vec = randn(size(r_sim_chan_noAWGN)) + j*randn(size(r_sim_chan_noAWGN));
                noise_vec_mean = mean(noise_vec);
                noise_vec_mean_std = std(noise_vec);
                noise_vec = noise_vec - noise_vec_mean;
                noise_vec = noise_vec/noise_vec_mean_std;                
                noise_vec = sqrt(Noise_var_Watts)*noise_vec;                
                % Signal + noise.
                r_sim_chan = r_sim_chan_noAWGN + noise_vec;           
                r_sim_chan = reshape(r_sim_chan,1,length(r_sim_chan)); 
                
                % Autocorrelation for OFDM detection.
                [dec_auto_sim(NT), test_stat_sim(NT), R_auto_sim(NT)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1');                
                % Receive SNR calculation.
                SNR_sim(NT) = (var(r_sim_chan)/var(noise_vec)) - 1;   
                
                if var(r_sim_chan) < var(noise_vec)
                    Number_of_discarded_channels = Number_of_discarded_channels + 1;
                    dec_auto_sim(NT) = [];
                    test_stat_sim(NT) = [];
                    R_auto_sim(NT) = [];
                    SNR_sim(NT) = [];                    
                end
          end
       
          SNR_sim_mean(link_K,Nd) = mean(SNR_sim);
          P_D(link_K,Nd) = mean(dec_auto_sim);
          
      end 
       Nbins = 0; 
       [bin_width, Nbins] = binwidth(SNR_sim_mean(link_K,:)); 
       [bins_SNR{link_K,1},binsfit_SNR{link_K,1}, pdf_SNR{link_K,1},pdffit_SNR{link_K,1}] = distfit(SNR_sim_mean(link_K,:),Nbins,'pdf','normal');
       
       Nbins = 0; 
       [bin_width, Nbins] = binwidth(P_D(link_K,:)); 
       [bins_P_D{link_K,1},binsfit_P_D{link_K,1}, pdf_P_D{link_K,1},pdffit_P_D{link_K,1}] = distfit(P_D(link_K,:),Nbins,'pdf','normal');
      
      disp(['Link (Sensor): ',num2str(link_K),' of: ',num2str(channel_pairing),' completed. The number of discared channels was: ',num2str(Number_of_discarded_channels),' out of: ',num2str(Ndrops*Temp),' .'])
end
                





