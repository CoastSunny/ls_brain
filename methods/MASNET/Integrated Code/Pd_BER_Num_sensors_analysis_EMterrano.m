function Pd_BER_Num_sensors_analysis()



%% General parameters and load specific parameters from config.txt file

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

%% Start Montecarlo runs

S_ = 4;
S = 4;     % Final number of sensors to evaluate
dS = -2;
P_ = -23;   % Initial value of the power transmitted by the target
P = -23;     % Final value of the power transmitted by the target
dP = 10;

conf_Best = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);
BER_Best = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);
BER_3_Best_Div = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);
BER_all_Div = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);

% conf_Best = zeros(((S_)/-dS)+1,((P-P_)/dP)+1);
% BER_Best = zeros(((S_)/-dS)+1,((P-P_)/dP)+1);
% BER_3_Best_Div = zeros(((S_)/-dS)+1,((P-P_)/dP)+1);
% BER_all_Div = zeros(((S_)/-dS)+1,((P-P_)/dP)+1);


for p=P_:dP:P
    
    for s=S_:dS:S
        
        
        % Here we load the previous SNR results once we have them (ALL_SNR)
        filename3 = ['SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(S_) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
        load(filename3);
        
        Num_sensors = s;
        
        
        %% Scenario and network generation
        Vel_sensors=ones(Num_sensors,3).*0.01;
        
        
        T_target_pos = ((Size_EZ_x/Int_target_x)+1)*((Size_EZ_y/Int_target_y)+1);
        
        %% Define the matrices to store the results
        
        % This is to store the channel coefficients
        
        %% Start the run for each possible position of the target
        
        for m=1:1:N_monte
            
            
            %% This is for when getting the specific SNR after getting SNR_stored
            
            
            % The conditions below are set to avoid uninteresting
            % locations of the sensors selected. For small number of
            % sensors it might happen that they end up being close
            % sensors and that it is not desired. For example, for
            % Num_sensors = 4, the four sensors that are selected by
            % using the delta_sensors commands are close to each other.
            % By adding the special conditions, we can control what
            % sensors we take. For relative larger values, the
            % separation between the selected sensors is fair. In the
            % case of the Mixed areas, because the simulated number of
            % sensors was 64, when we want to select a multiple of 64
            % (i.e. 4, 8, 16, 32) the selected sensors are placed in
            % straight lines which is not desired.
            
            if Num_sensors == S_
                
                SNR = squeeze(ALL_SNR(indx_x,indx_y,m,1:S_));
                Pr = squeeze(ALL_Pr(indx_x,indx_y,m,1:S_));
                Noise = squeeze(ALL_Noise(indx_x,indx_y,m));
                
            else
                
                SNR = squeeze(ALL_SNR(indx_x,indx_y,m,1:S_));
                Pr = squeeze(ALL_Pr(indx_x,indx_y,m,1:S_));
                Noise = squeeze(ALL_Noise(indx_x,indx_y,m));
                
                if S_ == 64
                    if mod(S_,Num_sensors) == 0
                        switch S_/Num_sensors
                            case 16   % This means Num_sensors = 4
                                temp = [10 15 50 55];
                                SNR = SNR(temp);
                            case 8    % This means Num_sensors = 8
                                temp = [1 8 19 22 43 46 57 64];
                                SNR = SNR(temp);
                            case 4    % This means Num_sensors = 16
                                temp = [1 3 6 8 17 19 22 24 41 43 46 48 57 59 62 64];
                                SNR = SNR(temp);
                            case 2
                                delta_sensors = S_/(S_-Num_sensors);
                                SNR(round(1+delta_sensors-1:delta_sensors:end)) = [];
                        end
                    else
                        
                        delta_sensors = S_/(S_-Num_sensors);
                        SNR(round(1+delta_sensors-1:delta_sensors:end)) = [];
                        
                    end
                    
                else
                    if Num_sensors == 4
                        temp = [13 24 47 76];
                        SNR = SNR(temp);
                    else
                        delta_sensors = S_/(S_-Num_sensors);
                        SNR(round(1+delta_sensors-1:delta_sensors:end)) = [];
                    end
                end
            end
            
            
            %                   SNR = SNR_(m,:)';
            
            
            % Calculate the Pd (probability of detection)
            
            [bn_pd,bn_pnd,ns_pnd,os_pd,snr,best_snr,BN_indx,BN_indx2] =...
                calculating_Prob_detection(AC_sample,Td,Tc,SNR,Pfa,Num_sensors);
            [bn_pd_no_cp,bn_pnd_no_cp,ns_pnd_no_cp,os_pd_no_cp,snr_no_cp,...
                best_snr_no_cp,BN_indx_no_cp,BN_indx2_no_cp] = ...
                calculating_Prob_detection_No_CP(SNR,Pr,Noise,Pfa,Num_sensors,Td);
            
            
            % For option 1 Detection
            BN_Pd(indx_x,indx_y,m) = bn_pd;     % Store the Pd in this Montecarlo run and target position
            
            %% Calculating the BER for different modulations, best snr, for the best node option 1
            
            snr_ = snr(BN_indx(BN_indx2));
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr_);
            
            
            % For option 1 BER
            Avg_Best_BER_BPSK(indx_x,indx_y) = Avg_Best_BER_BPSK(indx_x,indx_y) + Pe_BPSK;
            Avg_Best_BER_QPSK(indx_x,indx_y) = Avg_Best_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
            Avg_Best_BER_4AM(indx_x,indx_y) = Avg_Best_BER_4AM(indx_x,indx_y) + Pe_4AM;
            Avg_Best_BER_8AM(indx_x,indx_y) = Avg_Best_BER_8AM(indx_x,indx_y) + Pe_8AM;
            
            
            %% Calculating the BER for different modulations, added snr for diversity, option 3
            
            % This is the summation of the snr from each sensor for diversity
            % gain
            added_snr = sum(snr);
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(added_snr);
            
            Diversity_BER_BPSK(indx_x,indx_y) = Diversity_BER_BPSK(indx_x,indx_y) + Pe_BPSK;
            Diversity_BER_QPSK(indx_x,indx_y) = Diversity_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
            Diversity_BER_4AM(indx_x,indx_y) = Diversity_BER_4AM(indx_x,indx_y) + Pe_4AM;
            Diversity_BER_8AM(indx_x,indx_y) = Diversity_BER_8AM(indx_x,indx_y) + Pe_8AM;
            
            %% Calculating the BER for the best 3 sensors with diversity, option 2-3
            
            s_snr = sort(snr,'descend');
            best_3_added_snr = sum(s_snr(1:3));
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(best_3_added_snr);
            
            best_3_Diversity_BER_BPSK(indx_x,indx_y) = best_3_Diversity_BER_BPSK(indx_x,indx_y) + Pe_BPSK;
            best_3_Diversity_BER_QPSK(indx_x,indx_y) = best_3_Diversity_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
            best_3_Diversity_BER_4AM(indx_x,indx_y) = best_3_Diversity_BER_4AM(indx_x,indx_y) + Pe_4AM;
            best_3_Diversity_BER_8AM(indx_x,indx_y) = best_3_Diversity_BER_8AM(indx_x,indx_y) + Pe_8AM;
            
            %% Calculating the BER for different modulations, separated snr, no diversity option 2
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr);
            
            Avg_All_BER_BPSK(indx_x,indx_y) = Avg_All_BER_BPSK(indx_x,indx_y) + mean(Pe_BPSK);
            Avg_All_BER_QPSK(indx_x,indx_y) = Avg_All_BER_QPSK(indx_x,indx_y) + mean(Pe_QPSK);
            Avg_All_BER_4AM(indx_x,indx_y) = Avg_All_BER_4AM(indx_x,indx_y) + mean(Pe_4AM);
            Avg_All_BER_8AM(indx_x,indx_y) = Avg_All_BER_8AM(indx_x,indx_y) + mean(Pe_8AM);
            
            process = process + 1;
            
            waitbar(process/N_monte,w)
            
        end
        
        
        %% Take the required results for the number of sensors analysis
        
        for m=1:1:N_monte
            s_BN_Pd(m) = min(min(BN_Pd(:,:,m)));
        end
        
        conf_Best(i_s,i_p) = sum(s_BN_Pd==1)/length(s_BN_Pd);    % Store how many times we had Pd=1 for the best sensor. This gives us the confidence of always detecting or how many times we always detected. If for all the montecarlo runs we always had the best sensor with Pd=1, then our confidence is 100% we always detect.
        
        
        
        %% Calculate the average result from the montecarlo simulation for each
        % target position
        
        % BER option 1
        Avg_Best_BER_BPSK = Avg_Best_BER_BPSK./N_monte;
        
        BER_Best(i_s,i_p) = max(max(Avg_Best_BER_BPSK));
        
        Avg_Best_BER_QPSK = Avg_Best_BER_QPSK./N_monte;
        Avg_Best_BER_4AM = Avg_Best_BER_4AM./N_monte;
        Avg_Best_BER_8AM = Avg_Best_BER_8AM./N_monte;
        
        % BER option 2
        
        Avg_All_BER_BPSK = Avg_All_BER_BPSK./N_monte;
        Avg_All_BER_QPSK = Avg_All_BER_QPSK./N_monte;
        Avg_All_BER_4AM = Avg_All_BER_4AM./N_monte;
        Avg_All_BER_8AM = Avg_All_BER_8AM./N_monte;
        
        % BER option 3
        
        Diversity_BER_BPSK = Diversity_BER_BPSK./N_monte;
        
        BER_all_Div(i_s,i_p) = max(max(Diversity_BER_BPSK));
        
        Diversity_BER_QPSK = Diversity_BER_QPSK./N_monte;
        Diversity_BER_4AM = Diversity_BER_4AM./N_monte;
        Diversity_BER_8AM = Diversity_BER_8AM./N_monte;
        
        % BER option 2-3
        
        best_3_Diversity_BER_BPSK = best_3_Diversity_BER_BPSK./N_monte;
        
        BER_3_Best_Div(i_s,i_p) = max(max(best_3_Diversity_BER_BPSK));
        
        best_3_Diversity_BER_QPSK = best_3_Diversity_BER_QPSK./N_monte;
        best_3_Diversity_BER_4AM = best_3_Diversity_BER_4AM./N_monte;
        best_3_Diversity_BER_8AM = best_3_Diversity_BER_8AM./N_monte;        
                
        
    end
    
    
    
end

