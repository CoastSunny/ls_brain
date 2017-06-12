function Heatmaps_generation_EMterrano(SNR, Pr, Noise)

clc


%% General parameters and load specific parameters from config.txt file

% Speed of light
%% General parameters and load specific parameters from config.txt file
% Transmitted Power
Pt=-23;

% Expected signal bandwidth in Hz
BW=20e6;

% Noise figure of the RF receiver {in dB}
NF=3.5;

% Speed of light
c = 3e8;

% Carrier Frequency
Fc = 2.4e9;

% Wavelength
lambda = c/Fc;

% Desired sampling frequency
Fs = 30.72e6;

% Number of monte-carlo runs
N_monte = 100;

% Number of sensors
Num_sensors = 4 ;

% Shadowing noise
sigma=9;

% Probability false alarm
Pfa=0.1;

% Autocorrelation sample coefficient. It indicates how many LTE traces have been taken. The bigger it is the more samples are taken for the autocorrelation.
AC_sample=6;

% Number of samples that forms the cyclic prefix. It depends on the bandwidth of the LTE or WIFI signal
Tc=144;

% Number of samples that forms the data. It depends on the bandwidth of the LTE or WIFI signal
Td=2048;

%% Calculate the Pd (probability of detection)

% We need to set the number of sensors that we want to show Heatmaps
% for. It needs to be at least 3 sensors or more (needed for the option
% when the best 3 sensors are taken).

Num_sensors = 4;

for m=1:1:N_monte
    
    
    [bn_pd,bn_pnd,ns_pnd,os_pd,snr,best_snr,BN_indx,BN_indx2] = ...
        calculating_Prob_detection(AC_sample,Td,Tc,SNR(:,m),Pfa,Num_sensors);
    
    
    %% For option 1 Detection
    BN_Pd(m)      = bn_pd;     % Store the Pd in this Montecarlo run and target position
    
    Avg_BN_Pd(m)  = bn_pd;
    Avg_BN_Pnd(m) = bn_pnd;
    
    
    %% For option 2 Detecion
    Avg_NS_Pnd(m) = ns_pnd;
    Avg_OS_Pd(m)  = os_pd;
    
    
    %% Calculating the BER for different modulations, best snr, for the best node option 1
    
    snr_ = snr(BN_indx(BN_indx2));
    
    [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr_);
    
    
    % For option 1 BER
    Avg_Best_BER_BPSK(m) = Pe_BPSK;
    
    Best_BER_BPSK(m)     = Pe_BPSK;
    
    Avg_Best_BER_QPSK(m) = Pe_QPSK;
    Avg_Best_BER_4AM(m)  = Pe_4AM;
    Avg_Best_BER_8AM(m)  = Pe_8AM;
    
    %% Calculating the BER for different modulations, added snr for diversity, option 3
    
    % This is the summation of the snr from each sensor for diversity
    % gain
    added_snr = sum(snr);
    
    [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(added_snr);
    
    Diversity_BER_BPSK(m) = Pe_BPSK;
    
    All_Div_BER_BPSK(m)   = Pe_BPSK;
    
    Diversity_BER_QPSK(m) = Pe_QPSK;
    Diversity_BER_4AM(m)  = Pe_4AM;
    Diversity_BER_8AM(m)  = Pe_8AM;
    
    
    %% Calculating the BER for the best 3 sensors with diversity, option 2-3
    
    s_snr = sort(snr,'descend');
    best_3_added_snr = sum(s_snr(1:3));
    
    [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(best_3_added_snr);
    
    best_3_Diversity_BER_BPSK(m) = Pe_BPSK;
    
    Best_3_Div_BER_BPSK(m) = Pe_BPSK;
    
    best_3_Diversity_BER_QPSK(m) = Pe_QPSK;
    best_3_Diversity_BER_4AM(m)  = Pe_4AM;
    best_3_Diversity_BER_8AM(m)  = Pe_8AM;
    
    
    %% Calculating the BER for different modulations, separated snr, no diversity option 2
    
    [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr);
    
    ALL_BPSK(m,:) = Pe_BPSK;
    ALL_QPSK(m,:) = Pe_QPSK;
    ALL_4AM(m,:) = Pe_4AM;
    ALL_8AM(m,:) = Pe_8AM;
    
    Avg_All_BER_BPSK(m) = mean(ALL_BPSK(m,:));
    Avg_All_BER_QPSK(m) = mean(ALL_QPSK(m,:));
    Avg_All_BER_4AM(m)  = mean(ALL_4AM(m,:));
    Avg_All_BER_8AM(m)  = mean(ALL_8AM(m,:));
    
    
    % sort from smallest to the higest the BER obtained
    s_Avg_sensor_BPSK = sort(Pe_BPSK);
    s_Avg_sensor_QPSK = sort(Pe_QPSK);
    s_Avg_sensor_4AM = sort(Pe_4AM);
    s_Avg_sensor_8AM = sort(Pe_8AM);
    
    % Calculating the average BER conunting all sensors that
    % satisfy snr_best_sensor*0·9,0.5,0.1 <
    % SNR_other_selected_sensors (so, the selected sensors snr are
    % within 90% to 10% dB of the best sensor)
    Avg_90_snr_BER_BPSK(m) = mean(Pe_BPSK(snr>=max(snr)*0.9));
    Avg_50_snr_BER_BPSK(m) = mean(Pe_BPSK(snr>=max(snr)*0.5));
    Avg_10_snr_BER_BPSK(m) = mean(Pe_BPSK(snr>=max(snr)*0.1));
    
    
    
    % Calculate the average BER only counting the best 3 sensors
    Avg_best_3_BER_BPSK(m) = mean(s_Avg_sensor_BPSK(1:3));
    Avg_best_3_BER_QPSK(m) = mean(s_Avg_sensor_QPSK(1:3));
    Avg_best_3_BER_4AM(m)  = mean(s_Avg_sensor_4AM(1:3));
    Avg_best_3_BER_8AM(m)  = mean(s_Avg_sensor_8AM(1:3));
    
    % The probability of all 3 sensors decoding correctly is =
    % (1-BER1)*(1-BER2)*(1-BER3)
    All_3_correct_BPSK(m) = (1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3));
    All_3_correct_QPSK(m) = (1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3));
    All_3_correct_4AM(m)  = (1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3));
    All_3_correct_8AM(m)  = (1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3));
    
    % The probability of 1 sensor decoding wrongly is =
    % BER1*(1-BER2)*(1-BER3) + BER2*(1-BER1)*(1-BER3) + ... so on
    one_sensor_wrong_BPSK(m) = s_Avg_sensor_BPSK(1).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3));
    one_sensor_wrong_QPSK(m) = s_Avg_sensor_QPSK(1).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3));
    one_sensor_wrong_4AM(m)  = s_Avg_sensor_4AM(1).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3));
    one_sensor_wrong_8AM(m)  = s_Avg_sensor_8AM(1).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3));
    
    % The probability of decoding correctly (either all decode
    % correctly or 2/3 of the best sensors decode correctly) is
    
    Correct_BPSK(m) = (1 - (((1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3))) + (s_Avg_sensor_BPSK(1).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3)))));
    Correct_QPSK(m) = (1 - (((1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3))) + (s_Avg_sensor_QPSK(1).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3)))));
    Correct_4AM(m)  = (1 - (((1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3))) + (s_Avg_sensor_4AM(1).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3)))));
    Correct_8AM(m)  = (1 - (((1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3))) + (s_Avg_sensor_8AM(1).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3)))));
    
    
    % The same proceedure for 2 sensors wrong
    two_sensor_wrong_BPSK(m) = (1-s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3)) + (s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3)) + (s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3));
    two_sensor_wrong_QPSK(m) = (1-s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3)) + (s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3)) + (s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3));
    two_sensor_wrong_4AM(m)  = (1-s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3)) + (s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3)) + (s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3));
    two_sensor_wrong_8AM(m)  = (1-s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3)) + (s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3)) + (s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3));
    
    % For the case of all 3 sensors to receive wrong
    three_sensor_wrong_BPSK(m) = (s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3));
    three_sensor_wrong_QPSK(m) = (s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3));
    three_sensor_wrong_4AM(m)  = (s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3));
    three_sensor_wrong_8AM(m)  = (s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3));        
    
    
end

end