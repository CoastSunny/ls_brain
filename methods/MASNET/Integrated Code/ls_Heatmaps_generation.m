function Heatmaps_generation()

    clc
    S_=96;      % Caution: This value might change
                % This number of sensors helps to get the right 
                % number of sensors positioned later. For 
                % Separated: Num_sensors=76 if Sep_sensors=100 or
                % Num_sensors=96 if Sep_sensors=78, for Mixed: 
                % Num_sensors=64 if Sep_sensors=250.

    filename = ['~/Documents/ls_brain/results/masnet/SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(S_) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
    load(filename);
    % Speed of light, wavelength
    c = 3e8;
    lambda = c/Fc;

    
    if Type_Scenario == 0
        N_target_pos_x = floor((Size_EZ_x/Int_target_x) + 1);
        N_target_pos_y = floor((Size_EZ_y/Int_target_y) + 1);
    else
        Size_EZ_x = Size_Scenario;
        Size_EZ_y = Size_Scenario;
        N_target_pos_x = floor((Size_Scenario/Int_target_x) + 1);
        N_target_pos_y = floor((Size_Scenario/Int_target_y) + 1);
    end
    
    
    %% Load the file that contains the previously calculated SNR
    
    % We need to set the number of sensors that the SNR was generated with
    
   

    %% Calculate the Pd (probability of detection)
    
    % We need to set the number of sensors that we want to show Heatmaps
    % for. It needs to be at least 3 sensors or more (needed for the option
    % when the best 3 sensors are taken).
    
    Num_sensors = 8;   
    
    
    % Initialise the matrices to store the probabilities of detection and no
    % detection for each position of target and run of the montecarlo sim.

    Avg_BN_Pd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    Avg_BN_Pnd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    Avg_NS_Pnd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    Avg_OS_Pd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation

    BN_Pd = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the Pd of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis

    
    Avg_Best_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    Avg_Best_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    Avg_Best_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    Avg_Best_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
    
    
    Avg_All_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average BPSK for option 2 Q formulas
    Avg_All_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average QPSK for option 2 Q formulas
    Avg_All_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average 4AM for option 2 Alouini formulas
    Avg_All_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average 8AM for option 2 Alouini formulas

    Avg_90_snr_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);
    Avg_50_snr_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);
    Avg_10_snr_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);

    Avg_best_3_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);
    Avg_best_3_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);
    Avg_best_3_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);
    Avg_best_3_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);

    ALL_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);
    ALL_QPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);
    ALL_4AM = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);
    ALL_8AM = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);

    All_3_correct_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    All_3_correct_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    All_3_correct_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    All_3_correct_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

    one_sensor_wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    one_sensor_wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    one_sensor_wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    one_sensor_wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

    two_sensor_wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    two_sensor_wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    two_sensor_wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    two_sensor_wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

    three_sensor_wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    three_sensor_wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    three_sensor_wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    three_sensor_wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

    Correct_BPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly BPSK
    Correct_QPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly QPSK
    Correct_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly 4AM
    Correct_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly 8AM

    Wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    Wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    Wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    Wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
    
    Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for option 3 Q formulas
    Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for option 3 Q formulas
    Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for option 3 Alouini formulas
    Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for option 3 Alouini formulas
    
    All_Div_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the BER of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis


    best_3_Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for best 3 with diversity option 2-3 Q formulas
    best_3_Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for best 3 with diversity option 2-3 Q formulas
    best_3_Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for best 3 with diversity option 2-3 Alouini formulas
    best_3_Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for best 3 with diversity option 2-3 Alouini formulas
    
    Best_3_Div_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the BER of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis

    
    
    % Get the data for each target position
    
    indx_x = 1;
    indx_y = 1;
    
    for t_x=0:Int_target_x:Size_EZ_x

        for t_y=0:Int_target_y:Size_EZ_y
            
            % For each Monte Carlo run
            
            for m=1:1:N_monte
    
                % Take the SNR only from the desired number of sensors
                
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
                  else
                      SNR = squeeze(ALL_SNR(indx_x,indx_y,m,1:S_));
                      if S_ == 64       % This means it is Mixed Zones
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
                          
                      else      % This means is Separated Zones
                         if Num_sensors == 4
                           temp = [13 24 47 76];
                           SNR = SNR(temp);
                         else
                          delta_sensors = S_/(S_-Num_sensors);
                          SNR(round(1+delta_sensors-1:delta_sensors:end)) = [];     
                         end
                      end
                  end

                [bn_pd,bn_pnd,ns_pnd,os_pd,snr,best_snr,BN_indx,BN_indx2] = calculating_Prob_detection(AC_sample,Td,Tc,SNR,Pfa,Num_sensors);


                %% For option 1 Detection
                BN_Pd(indx_x,indx_y,m) = bn_pd;     % Store the Pd in this Montecarlo run and target position

                Avg_BN_Pd(indx_x,indx_y) = Avg_BN_Pd(indx_x,indx_y) + bn_pd;
                Avg_BN_Pnd(indx_x,indx_y) = Avg_BN_Pnd(indx_x,indx_y) + bn_pnd;


                %% For option 2 Detecion
                Avg_NS_Pnd(indx_x,indx_y) = Avg_NS_Pnd(indx_x,indx_y) + ns_pnd;
                Avg_OS_Pd(indx_x,indx_y) = Avg_OS_Pd(indx_x,indx_y) + os_pd;


                %% Calculating the BER for different modulations, best snr, for the best node option 1

                snr_ = snr(BN_indx(BN_indx2));

                [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr_);


                % For option 1 BER
                Avg_Best_BER_BPSK(indx_x,indx_y) = Avg_Best_BER_BPSK(indx_x,indx_y) + Pe_BPSK;

                Best_BER_BPSK(indx_x,indx_y,m) = Pe_BPSK;   

                Avg_Best_BER_QPSK(indx_x,indx_y) = Avg_Best_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
                Avg_Best_BER_4AM(indx_x,indx_y) = Avg_Best_BER_4AM(indx_x,indx_y) + Pe_4AM;
                Avg_Best_BER_8AM(indx_x,indx_y) = Avg_Best_BER_8AM(indx_x,indx_y) + Pe_8AM;

                %% Calculating the BER for different modulations, added snr for diversity, option 3

                % This is the summation of the snr from each sensor for diversity
                % gain
                added_snr = sum(snr);

                [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(added_snr);

                Diversity_BER_BPSK(indx_x,indx_y) = Diversity_BER_BPSK(indx_x,indx_y) + Pe_BPSK;

                All_Div_BER_BPSK(indx_x,indx_y,m) = Pe_BPSK; 

                Diversity_BER_QPSK(indx_x,indx_y) = Diversity_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
                Diversity_BER_4AM(indx_x,indx_y) = Diversity_BER_4AM(indx_x,indx_y) + Pe_4AM;
                Diversity_BER_8AM(indx_x,indx_y) = Diversity_BER_8AM(indx_x,indx_y) + Pe_8AM;
                
                
                %% Calculating the BER for the best 3 sensors with diversity, option 2-3

                s_snr = sort(snr,'descend');
                best_3_added_snr = sum(s_snr(1:3));

                [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(best_3_added_snr);

                best_3_Diversity_BER_BPSK(indx_x,indx_y) = best_3_Diversity_BER_BPSK(indx_x,indx_y) + Pe_BPSK;

                Best_3_Div_BER_BPSK(indx_x,indx_y,m) = Pe_BPSK; 

                best_3_Diversity_BER_QPSK(indx_x,indx_y) = best_3_Diversity_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
                best_3_Diversity_BER_4AM(indx_x,indx_y) = best_3_Diversity_BER_4AM(indx_x,indx_y) + Pe_4AM;
                best_3_Diversity_BER_8AM(indx_x,indx_y) = best_3_Diversity_BER_8AM(indx_x,indx_y) + Pe_8AM;
                
                
                %% Calculating the BER for different modulations, separated snr, no diversity option 2

                [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr);

                ALL_BPSK(indx_x,indx_y,m,:) = Pe_BPSK;
                ALL_QPSK(indx_x,indx_y,m,:) = Pe_QPSK;
                ALL_4AM(indx_x,indx_y,m,:) = Pe_4AM;
                ALL_8AM(indx_x,indx_y,m,:) = Pe_8AM;

                Avg_All_BER_BPSK(indx_x,indx_y) = Avg_All_BER_BPSK(indx_x,indx_y) + mean(ALL_BPSK(indx_x,indx_y,m,:));
                Avg_All_BER_QPSK(indx_x,indx_y) = Avg_All_BER_QPSK(indx_x,indx_y) + mean(ALL_QPSK(indx_x,indx_y,m,:));
                Avg_All_BER_4AM(indx_x,indx_y) = Avg_All_BER_4AM(indx_x,indx_y) + mean(ALL_4AM(indx_x,indx_y,m,:));
                Avg_All_BER_8AM(indx_x,indx_y) = Avg_All_BER_8AM(indx_x,indx_y) + mean(ALL_8AM(indx_x,indx_y,m,:));


                % sort from smallest to the higest the BER obtained
                s_Avg_sensor_BPSK = sort(Pe_BPSK);
                s_Avg_sensor_QPSK = sort(Pe_QPSK);
                s_Avg_sensor_4AM = sort(Pe_4AM);
                s_Avg_sensor_8AM = sort(Pe_8AM);

                % Calculating the average BER conunting all sensors that
                % satisfy snr_best_sensor*0·9,0.5,0.1 <
                % SNR_other_selected_sensors (so, the selected sensors snr are
                % within 90% to 10% dB of the best sensor)
                Avg_90_snr_BER_BPSK(indx_x,indx_y) = Avg_90_snr_BER_BPSK(indx_x,indx_y) + mean(Pe_BPSK(snr>=max(snr)*0.9));
                Avg_50_snr_BER_BPSK(indx_x,indx_y) = Avg_50_snr_BER_BPSK(indx_x,indx_y) + mean(Pe_BPSK(snr>=max(snr)*0.5));
                Avg_10_snr_BER_BPSK(indx_x,indx_y) = Avg_10_snr_BER_BPSK(indx_x,indx_y) + mean(Pe_BPSK(snr>=max(snr)*0.1));



                % Calculate the average BER only counting the best 3 sensors
                Avg_best_3_BER_BPSK(indx_x,indx_y) = Avg_best_3_BER_BPSK(indx_x,indx_y) + mean(s_Avg_sensor_BPSK(1:3));
                Avg_best_3_BER_QPSK(indx_x,indx_y) = Avg_best_3_BER_QPSK(indx_x,indx_y) + mean(s_Avg_sensor_QPSK(1:3));
                Avg_best_3_BER_4AM(indx_x,indx_y) = Avg_best_3_BER_4AM(indx_x,indx_y) + mean(s_Avg_sensor_4AM(1:3));
                Avg_best_3_BER_8AM(indx_x,indx_y) = Avg_best_3_BER_8AM(indx_x,indx_y) + mean(s_Avg_sensor_8AM(1:3));

                % The probability of all 3 sensors decoding correctly is =
                % (1-BER1)*(1-BER2)*(1-BER3)
                All_3_correct_BPSK(indx_x,indx_y) = All_3_correct_BPSK(indx_x,indx_y) + (1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3));
                All_3_correct_QPSK(indx_x,indx_y) = All_3_correct_QPSK(indx_x,indx_y) + (1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3));
                All_3_correct_4AM(indx_x,indx_y) = All_3_correct_4AM(indx_x,indx_y) + (1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3));
                All_3_correct_8AM(indx_x,indx_y) = All_3_correct_8AM(indx_x,indx_y) + (1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3));

                % The probability of 1 sensor decoding wrongly is =
                % BER1*(1-BER2)*(1-BER3) + BER2*(1-BER1)*(1-BER3) + ... so on
                one_sensor_wrong_BPSK(indx_x,indx_y) = one_sensor_wrong_BPSK(indx_x,indx_y) + s_Avg_sensor_BPSK(1).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3));
                one_sensor_wrong_QPSK(indx_x,indx_y) = one_sensor_wrong_QPSK(indx_x,indx_y) + s_Avg_sensor_QPSK(1).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3));
                one_sensor_wrong_4AM(indx_x,indx_y) = one_sensor_wrong_4AM(indx_x,indx_y) + s_Avg_sensor_4AM(1).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3));
                one_sensor_wrong_8AM(indx_x,indx_y) = one_sensor_wrong_8AM(indx_x,indx_y) + s_Avg_sensor_8AM(1).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3));

                % The probability of decoding correctly (either all decode
                % correctly or 2/3 of the best sensors decode correctly) is

                Correct_BPSK(indx_x,indx_y) = Correct_BPSK(indx_x,indx_y) + (1 - (((1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3))) + (s_Avg_sensor_BPSK(1).*(1-s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3)) + (1-s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3)))));
                Correct_QPSK(indx_x,indx_y) = Correct_QPSK(indx_x,indx_y) + (1 - (((1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3))) + (s_Avg_sensor_QPSK(1).*(1-s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3)) + (1-s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3)))));
                Correct_4AM(indx_x,indx_y) = Correct_4AM(indx_x,indx_y) + (1 - (((1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3))) + (s_Avg_sensor_4AM(1).*(1-s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3)) + (1-s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3)))));
                Correct_8AM(indx_x,indx_y) = Correct_8AM(indx_x,indx_y) + (1 - (((1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3))) + (s_Avg_sensor_8AM(1).*(1-s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3)) + (1-s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3)))));


                % The same proceedure for 2 sensors wrong
                two_sensor_wrong_BPSK(indx_x,indx_y) = two_sensor_wrong_BPSK(indx_x,indx_y) + (1-s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3)) + (s_Avg_sensor_BPSK(1)).*(1-s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3)) + (s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(1-s_Avg_sensor_BPSK(3));
                two_sensor_wrong_QPSK(indx_x,indx_y) = two_sensor_wrong_QPSK(indx_x,indx_y) + (1-s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3)) + (s_Avg_sensor_QPSK(1)).*(1-s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3)) + (s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(1-s_Avg_sensor_QPSK(3));
                two_sensor_wrong_4AM(indx_x,indx_y) = two_sensor_wrong_4AM(indx_x,indx_y) + (1-s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3)) + (s_Avg_sensor_4AM(1)).*(1-s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3)) + (s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(1-s_Avg_sensor_4AM(3));
                two_sensor_wrong_8AM(indx_x,indx_y) = two_sensor_wrong_8AM(indx_x,indx_y) + (1-s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3)) + (s_Avg_sensor_8AM(1)).*(1-s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3)) + (s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(1-s_Avg_sensor_8AM(3));

                % For the case of all 3 sensors to receive wrong
                three_sensor_wrong_BPSK(indx_x,indx_y) = three_sensor_wrong_BPSK(indx_x,indx_y) + (s_Avg_sensor_BPSK(1)).*(s_Avg_sensor_BPSK(2)).*(s_Avg_sensor_BPSK(3));
                three_sensor_wrong_QPSK(indx_x,indx_y) = three_sensor_wrong_QPSK(indx_x,indx_y) + (s_Avg_sensor_QPSK(1)).*(s_Avg_sensor_QPSK(2)).*(s_Avg_sensor_QPSK(3));
                three_sensor_wrong_4AM(indx_x,indx_y) = three_sensor_wrong_4AM(indx_x,indx_y) + (s_Avg_sensor_4AM(1)).*(s_Avg_sensor_4AM(2)).*(s_Avg_sensor_4AM(3));
                three_sensor_wrong_8AM(indx_x,indx_y) = three_sensor_wrong_8AM(indx_x,indx_y) + (s_Avg_sensor_8AM(1)).*(s_Avg_sensor_8AM(2)).*(s_Avg_sensor_8AM(3));
                
               

        
            end
            
            indx_y = indx_y + 1;
    
        end
        
        indx_y = 1;

        indx_x = indx_x + 1;
        
    end
    
    
    
    %% Calculate the average result from the montecarlo simulation for each
    % target position

    % Detection options 1 and 2
    Avg_BN_Pd = Avg_BN_Pd./N_monte;
    Avg_BN_Pnd = 1-Avg_BN_Pd;
    Avg_NS_Pnd = Avg_NS_Pnd./N_monte;
    Avg_OS_Pd = 1-Avg_NS_Pnd;

    % BER option 1
    Avg_Best_BER_BPSK = Avg_Best_BER_BPSK./N_monte;
    Avg_Best_BER_QPSK = Avg_Best_BER_QPSK./N_monte;
    Avg_Best_BER_4AM = Avg_Best_BER_4AM./N_monte;
    Avg_Best_BER_8AM = Avg_Best_BER_8AM./N_monte;

    % BER option 2

    Avg_All_BER_BPSK = Avg_All_BER_BPSK./N_monte;
    Avg_All_BER_QPSK = Avg_All_BER_QPSK./N_monte;
    Avg_All_BER_4AM = Avg_All_BER_4AM./N_monte;
    Avg_All_BER_8AM = Avg_All_BER_8AM./N_monte;

    Avg_90_snr_BER_BPSK = Avg_90_snr_BER_BPSK./N_monte;
    Avg_50_snr_BER_BPSK = Avg_50_snr_BER_BPSK./N_monte;
    Avg_10_snr_BER_BPSK = Avg_10_snr_BER_BPSK./N_monte;

    Avg_best_3_BER_BPSK = Avg_best_3_BER_BPSK./N_monte;
    Avg_best_3_BER_QPSK = Avg_best_3_BER_QPSK./N_monte;
    Avg_best_3_BER_4AM = Avg_best_3_BER_4AM./N_monte;
    Avg_best_3_BER_8AM = Avg_best_3_BER_8AM./N_monte;

    All_3_correct_BPSK = All_3_correct_BPSK./N_monte;
    All_3_correct_QPSK = All_3_correct_QPSK./N_monte;
    All_3_correct_4AM = All_3_correct_4AM./N_monte;
    All_3_correct_8AM = All_3_correct_8AM./N_monte;

    one_sensor_wrong_BPSK = one_sensor_wrong_BPSK./N_monte;
    one_sensor_wrong_QPSK = one_sensor_wrong_QPSK./N_monte;
    one_sensor_wrong_4AM = one_sensor_wrong_4AM./N_monte;
    one_sensor_wrong_8AM = one_sensor_wrong_8AM./N_monte;

    Correct_BPSK = Correct_BPSK./N_monte;
    Correct_QPSK = Correct_QPSK./N_monte;
    Correct_4AM = Correct_4AM./N_monte;
    Correct_8AM = Correct_8AM./N_monte;

    two_sensor_wrong_BPSK = two_sensor_wrong_BPSK./N_monte;
    two_sensor_wrong_QPSK = two_sensor_wrong_QPSK./N_monte;
    two_sensor_wrong_4AM = two_sensor_wrong_4AM./N_monte;
    two_sensor_wrong_8AM = two_sensor_wrong_8AM./N_monte;

    Wrong_BPSK = Wrong_BPSK./N_monte;
    Wrong_QPSK = Wrong_QPSK./N_monte;
    Wrong_4AM = Wrong_4AM./N_monte;
    Wrong_8AM = Wrong_8AM./N_monte;

    % BER option 3

    Diversity_BER_BPSK = Diversity_BER_BPSK./N_monte;
    Diversity_BER_QPSK = Diversity_BER_QPSK./N_monte;
    Diversity_BER_4AM = Diversity_BER_4AM./N_monte;
    Diversity_BER_8AM = Diversity_BER_8AM./N_monte;

    % BER option 2-3

    best_3_Diversity_BER_BPSK = best_3_Diversity_BER_BPSK./N_monte;
    best_3_Diversity_BER_QPSK = best_3_Diversity_BER_QPSK./N_monte;
    best_3_Diversity_BER_4AM = best_3_Diversity_BER_4AM./N_monte;
    best_3_Diversity_BER_8AM = best_3_Diversity_BER_8AM./N_monte;
    
    
    %% Here we calculate the probabilities of detection and BER but focused on the sensors. The idea is to be able to represent heat maps for each sensor position to determine the best placements for sensors

    % Calcualte the Probabilities of detectio and BER for each sensor, at each
    % target position and montecarlo run
      if Num_sensors == S_
          ALL_snr = 10.^(ALL_SNR./10);
      else
          ALL_snr = 10.^(ALL_SNR./10);
          if S_ == 64       % This is for Mixed Zones
              if mod(S_,Num_sensors) == 0
                  switch S_/Num_sensors
                      case 16   % This means Num_sensors = 4
                          temp = [10 15 50 55];
                          ALL_snr = ALL_snr(:,:,:,temp);
                      case 8    % This means Num_sensors = 8
                          temp = [1 8 19 22 43 46 57 64];
                          ALL_snr = ALL_snr(:,:,:,temp);
                      case 4    % This means Num_sensors = 16
                          temp = [1 3 6 8 17 19 22 24 41 43 46 48 57 59 62 64];
                          ALL_snr = ALL_snr(:,:,:,temp);
                      case 2
                          ALL_snr(:,:,:,round(1+delta_sensors-1:delta_sensors:end)) = [];
                  end
              else
                  
                ALL_snr(:,:,:,round(1+delta_sensors-1:delta_sensors:end)) = [];
              
              end
          else      % This is for Separated Zones
             if Num_sensors == 4
               temp = [13 24 47 76];
               ALL_snr = ALL_snr(:,:,:,temp);
             else
               ALL_snr(:,:,:,round(1+delta_sensors-1:delta_sensors:end)) = []; 
             end
          end
      end
    Pd = calculating_Prob_detection_v2(AC_sample,Td,Tc,ALL_snr,Pfa);
    [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(ALL_snr);
    
    % Then, take the averaged Pd and BER at each sensor for each montecarlo run
    % and target position
    Pd_final = zeros(Num_sensors,1);
    Pe_BPSK_final = zeros(Num_sensors,1);
    Pe_QPSK_final = zeros(Num_sensors,1);
    Pe_4AM_final = zeros(Num_sensors,1);
    Pe_8AM_final = zeros(Num_sensors,1);
    
    % Getting sensor positions
    
    if S_ == 64     % This is for the case of Mixed Zones
        Sep_sensors = 250;
        [Sensors,~] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);
        Sensors = Sensors(1:1:64,:);
        
        if Num_sensors ~= 64
          if mod(S_,Num_sensors) == 0
              switch S_/Num_sensors
                  case 16   % This means Num_sensors = 4
                      temp = [10 15 50 55];
                      Sensors = Sensors(temp,:);
                  case 8    % This means Num_sensors = 8
                      temp = [1 8 19 22 43 46 57 64];
                      Sensors = Sensors(temp,:);
                  case 4    % This means Num_sensors = 16
                      temp = [1 3 6 8 17 19 22 24 41 43 46 48 57 59 62 64];
                      Sensors = Sensors(temp,:);
                  case 2
                      Sensors(round(1+delta_sensors-1:delta_sensors:end),:) = [];
              end
          else

            Sensors(round(1+delta_sensors-1:delta_sensors:end),:) = [];

          end
            
        else
            Sensors(round(1+delta_sensors-1:delta_sensors:end),:) = [];
        end 
    else        % This is for the case of Separated Zones
        Sep_sensors = 78;       % Caution: This value might have to change!
        [Sensors,~] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);
        Sensors = Sensors(1:1:96,:);
        if Num_sensors ~= S_
           if Num_sensors == 4
              temp = [13 24 47 76];
              Sensors = Sensors(temp,:);
           else
              Sensors(round(1+delta_sensors-1:delta_sensors:end),:) = [];
           end

        end
    end
    
    positions_x = 0:Sep_sensors:Size_Scenario;
    positions_y = 0:Sep_sensors:Size_Scenario;
    
    Pd_rep = zeros(length(positions_x),length(positions_y));
    Pe_BPSK_rep = zeros(length(positions_x),length(positions_y));
    Pe_QPSK_rep = zeros(length(positions_x),length(positions_y));
    Pe_4AM_rep = zeros(length(positions_x),length(positions_y));
    Pe_8AM_rep = zeros(length(positions_x),length(positions_y));
    
    for i=1:1:Num_sensors
        % Calculate the average Pd and BER at each sensor considering all the
        % target positions and montecarlo runs. The result is an averaged Pd
        % and BER for each sensor. This will help to indicate where are the
        % best sensors
        Pd_final(i) = mean(mean(mean(Pd(:,:,:,i))));
        Pe_BPSK_final(i) = mean(mean(mean(Pe_BPSK(:,:,:,i))));
        Pe_QPSK_final(i) = mean(mean(mean(Pe_QPSK(:,:,:,i))));
        Pe_4AM_final(i) = mean(mean(mean(Pe_4AM(:,:,:,i))));
        Pe_8AM_final(i) = mean(mean(mean(Pe_8AM(:,:,:,i))));
        
        Pd_rep(ceil(Sensors(i,1,1)./(Sep_sensors)),ceil(Sensors(i,2,1)./(Sep_sensors))) = Pd_final(i);
        Pe_BPSK_rep(ceil(Sensors(i,1,1)./(Sep_sensors)),ceil(Sensors(i,2,1)./(Sep_sensors))) = Pe_BPSK_final(i);
        Pe_QPSK_rep(ceil(Sensors(i,1,1)./(Sep_sensors)),ceil(Sensors(i,2,1)./(Sep_sensors))) = Pe_QPSK_final(i);
        Pe_4AM_rep(ceil(Sensors(i,1,1)./(Sep_sensors)),ceil(Sensors(i,2,1)./(Sep_sensors))) = Pe_4AM_final(i);
        Pe_8AM_rep(ceil(Sensors(i,1,1)./(Sep_sensors)),ceil(Sensors(i,2,1)./(Sep_sensors))) = Pe_8AM_final(i);
    end
    
    
    %% Plotting results
    
    
    %% Heatmaps of Pd and BER at each sensors position
   
    figure(1)
    pcolor(positions_x,positions_y,Pd_rep.*100)
    colormap(colorcube)
    set(gca,'XTickLabel',positions_x,'XTick',positions_x);
    set(gca,'YTickLabel',positions_y,'YTick',positions_y);
    title('Probability of Interception [%] for each sensor')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')

    figure(2)
    pcolor(positions_x,positions_y,Pe_BPSK_rep)
    colormap(colorcube)
    set(gca,'XTickLabel',positions_x,'XTick',positions_x);
    set(gca,'YTickLabel',positions_y,'YTick',positions_y);
    title('Bit Error Rate for each sensor (BPSK case)')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')

    figure(3)
    pcolor(positions_x,positions_y,Pe_QPSK_rep)
    colormap(colorcube)
    set(gca,'XTickLabel',positions_x,'XTick',positions_x);
    set(gca,'YTickLabel',positions_y,'YTick',positions_y);
    title('QPSK BER for each sensor')
    xlabel('x coordinate (metres)')
    ylabel('y coordinate (metres)')

    figure(4)
    pcolor(positions_x,positions_y,Pe_4AM_rep)
    colormap(colorcube)
    set(gca,'XTickLabel',positions_x,'XTick',positions_x);
    set(gca,'YTickLabel',positions_y,'YTick',positions_y);
    title('4AM BER for each sensor')
    xlabel('x coordinate (metres)')
    ylabel('y coordinate (metres)')

    figure(5)
    pcolor(positions_x,positions_y,Pe_8AM_rep)
    colormap(colorcube)
    set(gca,'XTickLabel',positions_x,'XTick',positions_x);
    set(gca,'YTickLabel',positions_y,'YTick',positions_y);
    title('8AM BER for each sensor')
    xlabel('x coordinate (metres)')
    ylabel('y coordinate (metres)')

    
    %% Heatmaps of Pd and BER at each target position
    
    % Heat map option 1 detection
%     hmo1 = heatmap(Avg_BN_Pd.*100,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false,'TickFontSize', 20);
%     addTitle(hmo1, 'Probability of Interception [%]: Best sensor','FontSize', 22);
%     addXLabel(hmo1, 'x coordinate [metres]','FontSize',22);
%     addYLabel(hmo1, 'y coordinate [metres]','FontSize',22);
    figure(5)
    hmo1 = heatmap(Avg_BN_Pd.*100,0:Int_target_x:Size_EZ_x,Size_EZ_y:-Int_target_y:0);
    colormap(hot)
    title('Probability of Interception [%]: Best sensor')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')

%     % Heat map option 1 no detection
%     hmo2 = HeatMap(Avg_BN_Pnd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
%     addTitle(hmo2, 'Probability of not being detected by the best sensor');
% 
%     % Heat map option 2 no detection
%     hmo3 = HeatMap(Avg_NS_Pnd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
%     addTitle(hmo3, 'Probability of not being detected by any sensor');

    % Heat map option 2 detection
%     hmo4 = HeatMap(Avg_OS_Pd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
%     addTitle(hmo4, 'Probability of being detected by at least one sensor');
    figure(6)
    hmo4 = heatmap(Avg_OS_Pd.*100,0:Int_target_x:Size_EZ_x,Size_EZ_y:-Int_target_y:0);
    colormap(hot)
    title('Probability of Interception [%]: At least One sensor')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')
    
    
    % Heat map option 1 BER BPSK (Proakis)
%     hmo5 = HeatMap(Avg_Best_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
%     addTitle(hmo5, 'BER of the best sensor BPSK option 1 Q formulas');
    
    figure(7)
    hmo5 = heatmap(Avg_Best_BER_BPSK,0:Int_target_x:Size_EZ_x,Size_EZ_y:-Int_target_y:0);
    colormap(hot)
    title('Bit Error Rate: Only Best Sensor (BPSK case)')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')

    % % Heat map option 1 BER QPSK (Proakis)
    % hmo8 = HeatMap(Avg_Best_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo8, 'BER of the best sensor QPSK option 1 Q formulas');

    % Heat map option 1 BER 4-AM (Alouini)
    % hmo9 = HeatMap(Avg_Best_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo9, 'BER of the best sensor 4-AM option 1 Alouini paper');

    % % Heat map option 1 BER 8-AM (Alouini)
    % hmo11 = HeatMap(Avg_Best_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo11, 'BER of the best sensor 8-AM option 1 Alouini paper');

    
    % Heat map option 3 BER BPSK  (Proakis)
%     hmo13 = HeatMap(Diversity_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
%     addTitle(hmo13, 'BER BPSK all sensors (diversity) option 3 Q formulas');
    
    figure(8)
    hmo13 = heatmap(Diversity_BER_BPSK,0:Int_target_x:Size_EZ_x,Size_EZ_y:-Int_target_y:0);
    colormap(hot)
    title('Bit Error Rate: ALL Sensors (BPSK case)')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')

    % % Heat map option 3 BER QPSK  (Proakis)
    % hmo14 = HeatMap(total_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo14, 'BER BPSK all sensors (diversity) option 3 Q formulas');

    % Heat map option 3 BER 4-AM  (Alouini)
    % hmo15 = HeatMap(Diversity_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo15, 'BER BPSK all sensors (diversity) option 3 Q formulas');

    % % Heat map option 3 BER 8-AM  (Alouini)
    % hmo15 = HeatMap(Diversity_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo15, 'BER BPSK all sensors (diversity) option 3 Q formulas');
    
    
    % Heat map option 2-3 BER BPSK  (Proakis)
%     hmo113 = HeatMap(best_3_Diversity_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
%     addTitle(hmo113, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');
    
    figure(9)
    hmo113 = heatmap(best_3_Diversity_BER_BPSK,0:Int_target_x:Size_EZ_x,Size_EZ_y:-Int_target_y:0);
    colormap(hot)
    title('Bit Error Rate: 3 Best Sensors (BPSK case)')
    xlabel('x coordinate [metres]')
    ylabel('y coordinate [metres]')

    % % Heat map option 2-3 BER QPSK  (Proakis)
    % hmo114 = HeatMap(best_3_Diversity_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo114, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');

    % Heat map option 2-3 BER 4-AM  (Alouini)
    % hmo115 = HeatMap(best_3_Diversity_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo115, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');

    % % Heat map option 2-3 BER 8-AM  (Alouini)
    % hmo115 = HeatMap(best_3_Diversity_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo115, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');
    
    
    % Heat map option 2 BER BPSK (Proakis)
    hmo16 = HeatMap(Avg_All_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    addTitle(hmo16, 'BER of all sensors (average) BPSK option 2 Q formulas');

    % Heat map option 2 BER QPSK (Proakis)
    % hmo17 = HeatMap(Avg_All_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo17, 'BER of all sensors (average) QPSK option 2 Q formulas');
    % 
    % % Heat map option 2 BER 4-AM (Alouini)
    % hmo18 = HeatMap(Avg_All_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo18, 'BER of all sensors (average) 4-AM option 2 Alouini formulas');
    % 
    % % Heat map option 2 BER 8-AM (Alouini)
    % hmo19 = HeatMap(Avg_All_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo19, 'BER of all sensors (average) 8-AM option 2 Alouini formulas');


    
    % Heat map option 2 BER BPSK: Average best 3 sensors (Proakis)
    hmo161 = HeatMap(Avg_best_3_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    addTitle(hmo161, 'BER of 3 best sensors (average) BPSK option 2 Q formulas');

    % Heat map option 2 BER QPSK: Average best 3 sensors (Proakis)
    % hmo171 = HeatMap(Avg_best_3_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo171, 'BER of 3 best sensors (average) QPSK option 2 Q formulas');
    % 
    % % Heat map option 2 BER 4-AM: Average best 3 sensors (Alouini)
    % hmo181 = HeatMap(Avg_best_3_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo181, 'BER of 3 best sensors (average) 4-AM option 2 Alouini formulas');
    % 
    % % Heat map option 2 BER 8-AM: Average best 3 sensors (Alouini)
    % hmo191 = HeatMap(Avg_best_3_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo191, 'BER of 3 best sensors (average) 8-AM option 2 Alouini formulas');


    
    % Heat map option 2 BER BPSK: Average best sensors within 90% of best snr (Proakis)
    % hmo162 = HeatMap(Avg_90_snr_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo162, 'BER of sensors within 90% of best SNR (average) BPSK option 2 Q formulas');

    % Heat map option 2 BER BPSK: Average best sensors within 50% of best snr (Proakis)
    % hmo163 = HeatMap(Avg_50_snr_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo163, 'BER of sensors within 50% of best SNR (average) BPSK option 2 Q formulas');

    % Heat map option 2 BER BPSK: Average best sensors within 10% of best snr (Proakis)
    % hmo164 = HeatMap(Avg_10_snr_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo164, 'BER of sensors within 10% of best SNR (average) BPSK option 2 Q formulas');





    % Heat map option 2 Logic combinations Best 3: ALL correct (John)
    hmo22 = HeatMap(All_3_correct_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    addTitle(hmo22, 'Option 2 best 3: Probability of all sensors receive right BPSK Q formulas');

    % Heat map option 2 Logic combinations Best 3: ALL correct (John)
    % hmo24 = HeatMap(All_3_correct_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo24, 'Option 2 best 3: Probability of all sensors receive right QPSK Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: ALL correct (John)
    % hmo25 = HeatMap(All_3_correct_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo25, 'Option 2 best 3: Probability of all sensors receive right 4-AM Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: ALL correct (John)
    % hmo27 = HeatMap(All_3_correct_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo27, 'Option 2 best 3: Probability of all sensors receive right 8-AM Q formulas');



    % Heat map option 2 Logic combinations Best 3: One wrong (John)
    hmo28 = HeatMap(one_sensor_wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    addTitle(hmo28, 'Option 2 best 3: Probability of one sensor receive wrong BPSK');

    % Heat map option 2 Logic combinations Best 3: One wrong (John)
    % hmo30 = HeatMap(one_sensor_wrong_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo30, 'Option 2 best 3: Probability of one sensor receive wrong QPSK Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: One wrong (John)
    % hmo31 = HeatMap(one_sensor_wrong_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo31, 'Option 2 best 3: Probability of one sensor receive wrong 4-AM Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: One wrong (John)
    % hmo33 = HeatMap(one_sensor_wrong_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo33, 'Option 2 best 3: Probability of one sensor receive wrong 8-AM Q formulas');


    % Heat map option 2 Logic combinations Best 3: Decoding correctly (John)
    % hmo228 = HeatMap(Correct_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo228, 'Option 2 best 3: Probability of decoding correctly BPSK');

    % Heat map option 2 Logic combinations Best 3: One wrong (John)
    % hmo230 = HeatMap(Correct_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo230, 'Option 2 best 3: Probability of decoding correctly QPSK Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: One wrong (John)
    % hmo231 = HeatMap(Correct_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo231, 'Option 2 best 3: Probability of decoding correctly 4-AM Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: One wrong (John)
    % hmo233 = HeatMap(Correct_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo233, 'Option 2 best 3: Probability of decoding correctly 8-AM Q formulas');



    % Heat map option 2 Logic combinations Best 3: Two wrong (John)
    % hmo34 = HeatMap(two_sensor_wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo34, 'Option 2 best 3: Probability of two sensor receive wrong BPSK');

    % Heat map option 2 Logic combinations Best 3: Two wrong (John)
    % hmo36 = HeatMap(two_sensor_wrong_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo36, 'Option 2 best 3: Probability of two sensor receive wrong QPSK Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: Two wrong (John)
    % hmo37 = HeatMap(two_sensor_wrong_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo37, 'Option 2 best 3: Probability of two sensor receive wrong 4-AM Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: Two wrong (John)
    % hmo39 = HeatMap(two_sensor_wrong_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo39, 'Option 2 best 3: Probability of two sensor receive wrong 8-AM Q formulas');




    % Heat map option 2 Logic combinations Best 3: all wrong (John)
    % hmo40 = HeatMap(Wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo40, 'Option 2 best 3: Probability of all sensor receive wrong BPSK');

    % Heat map option 2 Logic combinations Best 3: all wrong (John)
    % hmo42 = HeatMap(Wrong_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo42, 'Option 2 best 3: Probability of all sensor receive wrong QPSK Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: all wrong (John)
    % hmo43 = HeatMap(Wrong_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo43, 'Option 2 best 3: Probability of all sensor receive wrong 4-AM Q formulas');
    % 
    % % Heat map option 2 Logic combinations Best 3: all wrong (John)
    % hmo45 = HeatMap(Wrong_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
    % addTitle(hmo45, 'Option 2 best 3: Probability of all sensor receive wrong 8-AM Q formulas');

end