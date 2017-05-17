%% Statitics of the autocorrelation algorithm
% Using preloaded WINNER channels, assess the performance of sensors

clear

%% Noise and transmit power.

SNR_step = 1;
SNR_vec = [-20:SNR_step:20];

% Phase PDF step
phase_step = (2*pi)/1000;
bins_P = [-pi:phase_step:pi];

% Uniform number LUT
uni_LUT = rand(1,length(bins_P));

% Sampling frequency (highest LTE).
fs = 30.72e6;


%% Tx 20 MHZ LTE signal.
TX_20MHz_QAM16 = load('LTE20QAM16');
Tx_signal = TX_20MHz_QAM16.Tx_signal_vec;
 


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

% Number of simulations at each SNR.
NDrops = 1000;

% RMS threshold for Rayleigh distributed variable.
Ray_thresh = abs(((1/sqrt(2*M_in_algo)) + j*(1/sqrt(2*M_in_algo))));

% Look-up table for imaginary component compensation.
%LUT_imag = randn(10*nr_sims_pd,1);
LUT_imag = randn(NDrops,1);
LUT_imag = LUT_imag - mean(LUT_imag);
LUT_imag = LUT_imag/std(LUT_imag);
LUT_imag = LUT_imag*sqrt(1/(2*(M_in_algo)));  %Note M is M - T_d in autocorrdetV2

% Initialise arrays, cells, etc.
dec_auto_sim = zeros(length(SNR_vec),NDrops);
dec_auto_sim2 = zeros(length(SNR_vec),NDrops);
dec_auto_sim3 = zeros(length(SNR_vec),NDrops);
dec_auto_sim4 = zeros(length(SNR_vec),NDrops);
test_stat_sim = zeros(length(SNR_vec), NDrops);
test_stat_sim2 = zeros(length(SNR_vec), NDrops);
test_stat_sim3 = zeros(length(SNR_vec), NDrops);
test_stat_sim4 = zeros(length(SNR_vec), NDrops);

R_auto_sim = zeros(length(SNR_vec), NDrops);
R_auto_sim2 = zeros(length(SNR_vec), NDrops);
R_auto_sim3 = zeros(length(SNR_vec), NDrops);
R_auto_sim4 = zeros(length(SNR_vec), NDrops);
R_auto_sim_real = zeros(length(SNR_vec), NDrops);
R_auto_sim_imag = zeros(length(SNR_vec), NDrops);
R_auto_sim_angle = zeros(length(SNR_vec), NDrops);
R_auto_sim_angle2 = zeros(length(SNR_vec), NDrops);
R_auto_sim_abs = zeros(length(SNR_vec), NDrops);
Ray_thresh_check = zeros(length(SNR_vec), NDrops);

Rupper_auto_sim = zeros(length(SNR_vec), NDrops);
Rsigma_z_auto_sim = zeros(length(SNR_vec), NDrops);
RSNR_auto_sim = zeros(length(SNR_vec), NDrops);
real_var = zeros(length(SNR_vec), NDrops);
rotation_angle = zeros(length(SNR_vec), NDrops);



R_auto_sim_real_mean = zeros(1,length(SNR_vec));
R_auto_sim_real_var = zeros(1,length(SNR_vec));      
R_auto_sim_real_varN1 = zeros(1,length(SNR_vec)); 
R_auto_sim_imag_mean = zeros(1,length(SNR_vec));
R_auto_sim_imag_var = zeros(1,length(SNR_vec));      
R_auto_sim_angle_mean = zeros(1,length(SNR_vec));
R_auto_sim_angle_var = zeros(1,length(SNR_vec));  
R_auto_sim_angle2_mean = zeros(1,length(SNR_vec));
R_auto_sim_angle2_var = zeros(1,length(SNR_vec));
R_auto_sim_abs_mean = zeros(1,length(SNR_vec));
R_auto_sim_abs_var = zeros(1,length(SNR_vec));  
Ray_PD = zeros(1,length(SNR_vec)); 
var_theory = zeros(1,length(SNR_vec)); 

P_D = zeros(1,length(SNR_vec));
P_D2 = zeros(1,length(SNR_vec));
P_D3 = zeros(1,length(SNR_vec));
P_D4 = zeros(1,length(SNR_vec));
RSNR_auto_sim_mean = zeros(1,length(SNR_vec));
P = cell(length(SNR_vec),1);
K = zeros(length(SNR_vec),1);
B = zeros(length(SNR_vec),1);
P2 = cell(length(SNR_vec),NDrops);
K2 = zeros(length(SNR_vec),NDrops);
B2 = zeros(length(SNR_vec),NDrops);

bins_R_auto_sim_real = cell(length(SNR_vec),1);
bins_R_auto_sim_imag = cell(length(SNR_vec),1);
bins_R_auto_sim_angle = cell(length(SNR_vec),1);
bins_R_auto_sim_angle2 = cell(length(SNR_vec),1);
bins_R_auto_sim_abs = cell(length(SNR_vec),1);

binsfit_R_auto_sim_real = cell(length(SNR_vec),1);
binsfit_R_auto_sim_imag = cell(length(SNR_vec),1);
binsfit_R_auto_sim_angle = cell(length(SNR_vec),1);
binsfit_R_auto_sim_angle2 = cell(length(SNR_vec),1);
binsfit_R_auto_sim_abs = cell(length(SNR_vec),1);

pdf_R_auto_sim_real = cell(length(SNR_vec),1); 
pdf_R_auto_sim_imag = cell(length(SNR_vec),1);
pdf_R_auto_sim_angle = cell(length(SNR_vec),1);
pdf_R_auto_sim_angle2 = cell(length(SNR_vec),1);
pdf_R_auto_sim_abs = cell(length(SNR_vec),1); 

pdffit_R_auto_sim_real = cell(length(SNR_vec),1); 
pdffit_R_auto_sim_imag = cell(length(SNR_vec),1); 
pdffit_R_auto_sim_angle = cell(length(SNR_vec),1); 
pdffit_R_auto_sim_angle2 = cell(length(SNR_vec),1);
pdffit_R_auto_sim_abs = cell(length(SNR_vec),1); 


%%  Statistics of Algorithm.
for Nd = 1:length(SNR_vec)
    Noise_var_Watts = 10^(-SNR_vec(Nd)/10);
      for NT = 1:NDrops
          
                % Signal.
                r_sim = Tx_signal(((NT-1)*M)+1:NT*M);
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
                [dec_auto_sim(Nd,NT), test_stat_sim(Nd,NT), R_auto_sim(Nd,NT)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'Standard1');    
                % Quantities to be analysed statistically.            
                R_auto_sim_real(Nd,NT) = real(R_auto_sim(Nd,NT));
                R_auto_sim_imag(Nd,NT) = imag(R_auto_sim(Nd,NT));               
                R_auto_sim_angle(Nd,NT) = angle(R_auto_sim(Nd,NT));                
                R_auto_sim_abs(Nd,NT) = abs(R_auto_sim(Nd,NT));
                
              
                RSNR_auto_sim(Nd,NT) = 1/((Rsigma_z_auto_sim(Nd,NT)/abs(Rupper_auto_sim(Nd,NT))) - 1);
                %real_var(Nd,NT) = ((1-(R_auto_sim_abs(Nd,NT))^2)^2)/(2*M_in_algo);
                real_var(Nd,NT) = (1-(R_auto_sim_abs(Nd,NT))^2)^2/(2*M_in_algo);
                [P2{Nd,NT},B2(Nd,NT),K2(Nd,NT)]  = ComplexGaussPhasePDF(R_auto_sim_abs(Nd,NT), real_var(Nd,NT), (1/(2*M_in_algo)), phase_step);
                
       
      end
       
      % Mean and variance.
      R_auto_sim_real_mean(Nd) = mean(R_auto_sim_real(Nd,:));
      R_auto_sim_real_var(Nd) = var(R_auto_sim_real(Nd,:));
      R_auto_sim_real_varN1(Nd) = var(R_auto_sim_real(Nd,:),1);
       
      R_auto_sim_imag_mean(Nd) = mean(R_auto_sim_imag(Nd,:));
      R_auto_sim_imag_var(Nd) = var(R_auto_sim_imag(Nd,:));
      
      
      R_auto_sim_angle_mean(Nd) = mean(R_auto_sim_angle(Nd,:));
      R_auto_sim_angle_var(Nd) = var(R_auto_sim_angle(Nd,:));
      
  
      
      R_auto_sim_abs_mean(Nd) = mean(R_auto_sim_abs(Nd,:));
      R_auto_sim_abs_var(Nd) = var(R_auto_sim_abs(Nd,:));
      
      P_D(Nd) = mean(dec_auto_sim(Nd,:));

      
      RSNR_auto_sim_mean(Nd) = mean(RSNR_auto_sim(Nd,:));
      Ray_PD(Nd) = mean(Ray_thresh_check(Nd,:));
      %var_theory(Nd) = (1-(R_auto_sim_real_mean(Nd))^2)^2/(2*M_in_algo);
      var_theory(Nd) = (1-(R_auto_sim_real_mean(Nd))^2)/(2*M_in_algo);
      
      % PDFs.      
      Nbins = 0; 
      [bin_width, Nbins] = binwidth(R_auto_sim_real(Nd,:)); 
      [bins_R_auto_sim_real{Nd,1},binsfit_R_auto_sim_real{Nd,1}, pdf_R_auto_sim_real{Nd,1},pdffit_R_auto_sim_real{Nd,1}] = distfit(R_auto_sim_real(Nd,:),Nbins,'pdf','normal');
      
      Nbins = 0; 
      [bin_width, Nbins] = binwidth(R_auto_sim_imag(Nd,:)); 
      [bins_R_auto_sim_imag{Nd,1},binsfit_R_auto_sim_imag{Nd,1}, pdf_R_auto_sim_imag{Nd,1},pdffit_R_auto_sim_imag{Nd,1}] = distfit(R_auto_sim_imag(Nd,:),Nbins,'pdf','normal');
      
      Nbins = 50; 
      %[bin_width, Nbins] = binwidth(R_auto_sim_angle(Nd,:)); 
      [bins_R_auto_sim_angle{Nd,1},binsfit_R_auto_sim_angle{Nd,1}, pdf_R_auto_sim_angle{Nd,1},pdffit_R_auto_sim_angle{Nd,1}] = distfit(R_auto_sim_angle(Nd,:),Nbins,'pdf','normal');      
      [P{Nd,1},B(Nd,1),K(Nd,1)] =  ComplexGaussPhasePDF(R_auto_sim_real_mean(Nd), R_auto_sim_real_var(Nd), R_auto_sim_imag_var(Nd), phase_step);
      
      for NT = 1:NDrops
      [dec_auto_sim2(Nd,NT), test_stat_sim2(Nd,NT), R_auto_sim2(Nd,NT)] = autocorrdetV2(r_sim_chan,Pfa,T_d,'FO_Corrected3',uni_LUT,'WC1',phase_step,R_auto_sim_real_mean(Nd), R_auto_sim_real_var(Nd)); 
      R_auto_sim_angle2(Nd,NT) = angle(R_auto_sim2(Nd,NT));
      end      
      P_D2(Nd) = mean(dec_auto_sim2(Nd,:));
      
      R_auto_sim_angle2_mean(Nd) = mean(R_auto_sim_angle2(Nd,:));
      R_auto_sim_angle2_var(Nd) = var(R_auto_sim_angle2(Nd,:));
      
      
      Nbins = 50; 
      %[bin_width, Nbins] = binwidth(R_auto_sim_angle(Nd,:)); 
      [bins_R_auto_sim_angle2{Nd,1},binsfit_R_auto_sim_angle2{Nd,1}, pdf_R_auto_sim_angle2{Nd,1},pdffit_R_auto_sim_angle2{Nd,1}] = distfit(R_auto_sim_angle2(Nd,:),Nbins,'pdf','normal');
      
      Nbins = 0; 
      [bin_width, Nbins] = binwidth(R_auto_sim_angle(Nd,:)); 
      [bins_R_auto_sim_abs{Nd,1},binsfit_R_auto_sim_abs{Nd,1}, pdf_R_auto_sim_abs{Nd,1},pdffit_R_auto_sim_abs{Nd,1}] = distfit(R_auto_sim_abs(Nd,:),Nbins,'pdf','normal');
      
      
         
          
      disp(['SNR value: ',num2str(SNR_vec(Nd)),' dB completed. Max value: ',num2str(SNR_vec(end)),' dB. Step value: ',num2str(SNR_step),' dB.'])    
end 
       
      
     

                





