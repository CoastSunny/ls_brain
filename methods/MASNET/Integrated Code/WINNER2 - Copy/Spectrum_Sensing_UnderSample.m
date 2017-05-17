clear

cdir = cd;

%% Paramters

SNRdB = [-30:2:20];
lag_vec = [1:1:1000];
T_d = 2048;  
T_c = 144;  
Pfa = 0.05;% False alarm probability

N_autos = 1000;

yffo_len = 2*T_d + T_c;

% Sample length for the detector.
N_OFDM_symbols = 5;
window_length = N_OFDM_symbols*yffo_len;

% Undersampling factor.
US_factor = 15; % 16: 1.92 MHz -> 30.72 MHz, etc.

% Simulation type: 'SNR_based' or 'lag_based'
Simulation_type = 'SNR_based'; % 'SNR_based' 'lag_based';


%% Load Tx 20 MHZ LTE signal.
%cd('H:\MATLAB\DSTL\MASNET_Project\WINNER2');
TX_20MHz_QAM16 = load('LTE20QAM16');
Tx_signal = TX_20MHz_QAM16.Tx_signal_vec;
clear TX_20MHz_QAM16
%cd(cdir)


switch Simulation_type
    case 'SNR_based'


%% Preallocation.
Pd = zeros(size(SNRdB)); 
P_D1 = zeros(size(SNRdB));
P_D2 = zeros(size(SNRdB));
decision1 = zeros(length(SNRdB),N_autos);
decision2 = zeros(length(SNRdB),N_autos);
Tx_signal3 = zeros(size(Tx_signal));




%% Theoretical probability of detection


for xx = 1:length(SNRdB)
    SNR = 10^(SNRdB(xx)/10);
    Ro1 = (T_c/(T_d+T_c))*(SNR/(1+SNR)); % equation (7)
    threshold = sqrt(1/window_length)*erfcinv(2*Pfa); % equation (20)
    Pd(xx) = 0.5*erfc(sqrt(window_length)*(threshold-Ro1/1-Ro1^2));  % equation (21)    
end


%% Simulated probability of detection
% Undersampling and padding.
Tx_signal2 = Tx_signal(1:US_factor:end);
padding_ind1 = 0;
padding_ind2 = 0;
for ss1 = 1:length(Tx_signal2)
    padding_ind2 = padding_ind2 + 1;
    for ss2 = 1:US_factor
        padding_ind1 = padding_ind1 + 1;
        Tx_signal3(padding_ind1) = Tx_signal2(padding_ind2);
    end
end
        
        
    
for ii = 1:length(SNRdB)   
    
    sig_drop = 0;
    for nn = 1:N_autos
        
        sig_drop = sig_drop + 1;
        if (sig_drop*(window_length/US_factor)) > length(Tx_signal2)
            sig_drop = 1;
            Tx_signal2(1:US_factor-1) = [];
        end
    
    signal1 = Tx_signal((nn-1)*window_length+1:window_length*nn); 
    %signal2 = Tx_signal2((sig_drop-1)*(ceil(window_length/US_factor))+1:(ceil(window_length/US_factor))*sig_drop);
    signal3 = Tx_signal3((nn-1)*window_length+1:window_length*nn); 
    
    % Genereate noise variances
    Noise_var_Watts = 10^(-SNRdB(ii)/10);
    % For standard case
    noise_vec1 = randn(size(signal1)) + j*randn(size(signal1));
    noise_vec_mean1 = mean(noise_vec1);
    noise_vec_mean_std1 = std(noise_vec1);
    noise_vec1 = noise_vec1 - noise_vec_mean1;
    noise_vec1 = noise_vec1/noise_vec_mean_std1;
    noise_vec1 = sqrt(Noise_var_Watts)*noise_vec1;
    % For undersampled case
%     noise_vec2 = randn(size(signal2)) + j*randn(size(signal2));
%     noise_vec_mean2 = mean(noise_vec2);
%     noise_vec_mean_std2 = std(noise_vec2);
%     noise_vec2 = noise_vec2 - noise_vec_mean2;
%     noise_vec2 = noise_vec2/noise_vec_mean_std2;
%     noise_vec2 = sqrt(Noise_var_Watts)*noise_vec2;
    
    % Received signal = Transmitted Signal + AWGN Noise
    y1 = signal1 + noise_vec1;   
    %y2 = signal2 + noise_vec2; 
    y2 = signal3 + noise_vec1; 
    
    
    [decision1(ii,nn)] = autocorrdetV3(y1,Pfa,T_d,'Standard1','none');
    %[decision2(ii,nn)] = autocorrdetV3(y2,Pfa,128,'Standard1','none');
    [decision2(ii,nn)] = autocorrdetV3(y2,Pfa,T_d,'Standard1','none');
    %[decision2(ii,nn)] = autocorrdetV3(y2,Pfa,T_d,'Standard1','none');



    end
 % Average over decisions.  
  P_D1(ii) =   sum(decision1(ii,:))/N_autos;
  P_D2(ii) =   sum(decision2(ii,:))/N_autos;
  
  disp(['SNR: ',num2str(SNRdB(ii)),' dB of ',num2str(max(SNRdB)),' complete.']) 
    
end


plot(SNRdB,Pd, 'c-o'); grid, hold on;
plot(SNRdB,P_D1, 'r-*'); 
plot(SNRdB,P_D2, 'bs--');
legend('Theory','standard1','standard2');
xlabel('SNR (dB)')
ylabel('Probability of Detection'); 
title('Curve for Probability of Detection Vs SNR');

case 'lag_based'
    

    %% Preallocation.
Pd = zeros(size(lag_vec)); 
P_D1 = zeros(size(lag_vec));
P_D2 = zeros(size(lag_vec));
decision1 = zeros(1,N_autos);
decision2 = zeros(1,N_autos);




%% Simulated probability of detection for various lags wrt T_d
Tx_signal2 = Tx_signal(1:(US_factor-1):end);
SNRdB = inf;
for ii = 1:length(lag_vec)    
    sig_drop = 0;
    for nn = 1:N_autos
        
        sig_drop = sig_drop + 1;
        if (sig_drop*(window_length/US_factor)) > length(Tx_signal2)
            sig_drop = 1;
            Tx_signal2(1:US_factor-1) = [];
        end
    
    signal1 = Tx_signal((nn-1)*window_length+1:window_length*nn); 
    signal2 = Tx_signal2((sig_drop-1)*(ceil(window_length/US_factor))+1:(ceil(window_length/US_factor))*sig_drop);
    
    % Genereate noise variances
    Noise_var_Watts = 10^(-SNRdB/10);
    % For standard case
    noise_vec1 = randn(size(signal1)) + j*randn(size(signal1));
    noise_vec_mean1 = mean(noise_vec1);
    noise_vec_mean_std1 = std(noise_vec1);
    noise_vec1 = noise_vec1 - noise_vec_mean1;
    noise_vec1 = noise_vec1/noise_vec_mean_std1;
    noise_vec1 = sqrt(Noise_var_Watts)*noise_vec1;
    % For undersampled case
    noise_vec2 = randn(size(signal2)) + j*randn(size(signal2));
    noise_vec_mean2 = mean(noise_vec2);
    noise_vec_mean_std2 = std(noise_vec2);
    noise_vec2 = noise_vec2 - noise_vec_mean2;
    noise_vec2 = noise_vec2/noise_vec_mean_std2;
    noise_vec2 = sqrt(Noise_var_Watts)*noise_vec2;
    
    % Received signal = Transmitted Signal + AWGN Noise
    y1 = signal1 + noise_vec1;   
    y2 = signal2 + noise_vec2;   
    
    
    [decision1(nn)] = autocorrdetV3(y1,Pfa,lag_vec(ii),'Standard1','none');
    [decision2(nn)] = autocorrdetV3(y2,Pfa,lag_vec(ii),'Standard1','none');
    %[decision2(ii,nn)] = autocorrdetV3(y2,Pfa,T_d,'Standard1','none');



    end
 % Average over decisions.  
  P_D1(ii) =   mean(decision1);
  P_D2(ii) =   mean(decision2);
  
  disp(['Lag: ',num2str(lag_vec(ii)),' and max value is: ',num2str(lag_vec(end)),'.']) 
    
end
    
    

plot(lag_vec,P_D1, 'r-*');
grid on; hold on;
plot(lag_vec,P_D2, 'bs--');
legend('standard1','standard2');
xlabel('Lag, [Samples]')
ylabel('Probability of Detection'); 

end
