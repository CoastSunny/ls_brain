function Pd_BER_Num_sensors_analysis()

clear all
close all force
clc

%% General parameters and load specific parameters from config.txt file

% Speed of light
c = 3e8;

% Load data from config.txt file. 1st Column are either comments or index
% values of variables. 2nd column are the names of the variables. 3rd
% column are the values of these variables
A = importdata('config.txt',';');

% Delete the first 4 lines because they are comments
A.textdata(1:3,:) = [];

% 2nd column data as char. Then we convert the char "matrix" into a string
% vector
chr = char(A.textdata{:,1});
str = cellstr(chr);

% Now, each input parameter is looked into the str array (by name) to know the index
% where the value must be taken in A.data. This way, if more input
% parameters are added in the config file, it does not matter where they
% are added in the config file, we will find them in their new position and
% assign them here
index = find(strcmp(str, 'Fc'));    % Carrier Frequency
Fc = A.data(index);

index = find(strcmp(str, 'Type_Scenario'));    % Type of scenario. Separated or mixed enemy and friend zones
Type_Scenario = A.data(index);

index = find(strcmp(str, 'Type_Environment'));  % Type of environment. Urban or rural
Type_Environment = A.data(index);

index = find(strcmp(str, 'Size_Scenario'));     % Size of the scenario
Size_Scenario = A.data(index);

index = find(strcmp(str, 'Size_EZ_x')); % Size of the enemy zone (horizontal)
Size_EZ_x = A.data(index);

index = find(strcmp(str, 'Size_EZ_y')); % Size of the enemy zone (vertical)
Size_EZ_y = A.data(index);

index = find(strcmp(str, 'Size_FZ1_x')); % Size of the friend zone 1 (horizontal)
Size_FZ1_x = A.data(index);

index = find(strcmp(str, 'Size_FZ1_y')); % Size of the friend zone 1 (vertical)
Size_FZ1_y = A.data(index);

index = find(strcmp(str, 'Size_FZ2_x')); % Size of the friend zone 2 (horizontal)
Size_FZ2_x = A.data(index);

index = find(strcmp(str, 'Size_FZ2_y')); % Size of the friend zone 2 (vertical)
Size_FZ2_y = A.data(index);

index = find(strcmp(str, 'Sep_sensors'));   % Distance between sensors
Sep_sensors = A.data(index);

index = find(strcmp(str, 'hs'));    % Sensors height
hs = A.data(index);

index = find(strcmp(str, 'ht'));    % Target height
ht = A.data(index);


% Velocity of the sensors not used here yet


% The distance between elements in antenna array not used here yet

index = find(strcmp(str, 'NAz'));   % 3 degree sampling/resolution
NAz=A.data(index);    

index = find(strcmp(str, 'Antenna_slant'));  % If =0, no shift on the orientation
Antenna_slant = A.data(index); 

index = find(strcmp(str, 'Sample_Density'));    % Density of samples for Doppler effect
Sample_Density = A.data(index);

index = find(strcmp(str, 'Time_samples'));  % Number of time samples to obtain the CIR
Time_samples = A.data(index); 

index = find(strcmp(str, 'Fs'));        % Desired sampling frequency
Fs = A.data(index);

index = find(strcmp(str, 'Int_target_x'));  % Set the distance between each change of target position
Int_target_x = A.data(index);        

index = find(strcmp(str, 'Int_target_y'));
Int_target_y = A.data(index);

index = find(strcmp(str, 'N_monte'));   % Number of runs for the Montecarlo simulation
N_monte = A.data(index);

index = find(strcmp(str, 'sigma'));     % sigma value for the lognormal random shadowing
sigma = A.data(index);

index = find(strcmp(str, 'n'));     % Urban is between 2.7 and 3.5, rural is 2
n = A.data(index);              

index = find(strcmp(str, 'd_0'));  % Outdoor is between 100m to 1km
d_0 = A.data(index);          

index = find(strcmp(str, 'Pt'));   % Target power
Pt = A.data(index);

index = find(strcmp(str, 'BW'));
BW = A.data(index);              % Signal bandwidth in Hz. Up to 20MHz.

index = find(strcmp(str, 'NF'));
NF = A.data(index);               % Noise figure of the RF receiver in dB

index = find(strcmp(str, 'Tc'));
Tc = A.data(index);       % # of samples in the cyclic prefix (CP)

index = find(strcmp(str, 'Td'));
Td = A.data(index);      % Number of samples of data in the LTE trace

index = find(strcmp(str, 'AC_sample'));            
AC_sample = A.data(index);

index = find(strcmp(str, 'Pfa'));
Pfa = A.data(index);      % Probability of false alarm

% Wavelength
lambda = c/Fc;


%% Start Montecarlo runs   

S_ = 96;    % This number of sensors helps to get the right 
            % number of sensors positioned later. For 
            % Separated: Num_sensors=76 if separation=100 or
            % Num_sensors=96 if Sep_sensors=78, for Mixed: 
            % Num_sensors=64 if separation=250.
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



% Initialise wait bar for the Number of sensors runs
w3 = waitbar(0,'Running Number of Sensors simulation. Please wait...','Position', [500 600 280 50]);
w4 = waitbar(0,'Running Different Pt simulation. Please wait...','Position', [500 500 280 50]);
w = waitbar(0,'Running Montecarlo simulation. Please wait...','Position', [500 400 280 50]);
w2 = waitbar(0,'Simulating different target locations. Please wait...','Position', [500 300 280 50]);

i_p =0;

process4 = 0;

for p=P_:dP:P
    
    Pt = p;
    
    waitbar(process4/(((P-P_)/dP)+1),w4);    

    i_p = i_p + 1;
    
    i_s = 0;

    process3 = 0;
    
    for s=S_:dS:S
        
        waitbar(process3/(((S-S_)/dS)+1),w3);

        i_s = i_s + 1;

        % Here we load the previous SNR results once we have them (ALL_SNR)
        filename3 = ['SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(S_) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
        load(filename3);
        
        Num_sensors = s;
        

        %% Scenario and network generation

        % Define sensor velocities. For now, all are static. The velocity of the
        % sensors cannot be zero, therefore, if we want to analyse static sensors,
        % we need to put very small velocities of the sensors.
        Vel_sensors=ones(Num_sensors,3).*0.01;


        if Type_Scenario == 0
            N_target_pos_x = floor((Size_EZ_x/Int_target_x) + 1);
            N_target_pos_y = floor((Size_EZ_y/Int_target_y) + 1);
        else
            Size_EZ_x = Size_Scenario;
            Size_EZ_y = Size_Scenario;
            N_target_pos_x = floor((Size_Scenario/Int_target_x) + 1);
            N_target_pos_y = floor((Size_Scenario/Int_target_y) + 1);
        end

        % Calculating the total number of target positions
        T_target_pos = ((Size_EZ_x/Int_target_x)+1)*((Size_EZ_y/Int_target_y)+1);

        process = 0;

        % Run the Montecarlo simulation N times

        % N_monte = 100;

        waitbar(process/N_monte,w);
        
        %% Define the matrices to store the results

        % This is to store the channel coefficients

        BN_Pd = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the Pd of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis     
        s_BN_Pd = zeros(N_monte,1);                             % Vector to store the worst Pd at each montecarlo run.  
        
        Avg_Best_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
        Avg_Best_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
        Avg_Best_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
        Avg_Best_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
        
        Avg_All_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average BPSK for option 2 Q formulas
        Avg_All_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average QPSK for option 2 Q formulas
        Avg_All_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average 4AM for option 2 Alouini formulas
        Avg_All_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average 8AM for option 2 Alouini formulas
        
        Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for option 3 Q formulas
        Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for option 3 Q formulas
        Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for option 3 Alouini formulas
        Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for option 3 Alouini formulas
        
        best_3_Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for best 3 with diversity option 2-3 Q formulas
        best_3_Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for best 3 with diversity option 2-3 Q formulas
        best_3_Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for best 3 with diversity option 2-3 Alouini formulas
        best_3_Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for best 3 with diversity option 2-3 Alouini formulas
        
        %% Start the run for each possible position of the target



        indx_x = 1;
        indx_y = 1;

        process2 = 0;

        waitbar(process2/T_target_pos,w2);

        for t_x=0:Int_target_x:Size_EZ_x

            for t_y=0:Int_target_y:Size_EZ_y


                process = 0;

                waitbar(process/N_monte,w)

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

                indx_y = indx_y + 1;

                process2 = process2 + 1;

                waitbar(process2/T_target_pos,w2);

            end

            indx_y = 1;

            indx_x = indx_x + 1;

        end

        %% Take the required results for the number of sensors analysis

        for m=1:1:N_monte
           s_BN_Pd(m) = min(min(BN_Pd(:,:,m))); 
        end

        conf_Best(i_s,i_p) = sum(s_BN_Pd==1)/length(s_BN_Pd);   
        % Store how many times we had Pd=1 for the best sensor. This gives us the confidence of always detecting or how many times we always detected. If for all the montecarlo runs we always had the best sensor with Pd=1, then our confidence is 100% we always detect.



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




        process3 = process3 + 1;
    end
   
    process4 = process4 + 1;
    
end

delete(w)
delete(w2)
delete(w3)
delete(w4)

% Present results

figure(1)
plot(S_:-2:S,100.*conf_Best(:,1),'-ob','LineWidth',3)
hold on
plot(S_:-2:S,100.*conf_Best(:,2),'-ok','LineWidth',3)
plot(S_:-2:S,100.*conf_Best(:,3),'-or','LineWidth',3)
plot(S_:-2:S,100.*conf_Best(:,4),'-og','LineWidth',3)
hold off
axis([S S_ -10 110])
legend('Pt=-53dBW','Pt=-43dBW','Pt=-33dBW','Pt=-23dBW')
title('POI confidence: Only Best Sensor')
xlabel('Number of Sensors')
ylabel('POI confidence [%]')
set(gcf,'color','w');
xticks([S:2:S_])
yticks([-10:10:110])
grid on

figure(2)
semilogy(S_:-2:S,BER_Best(:,1),'-ob','LineWidth',3)
hold on
semilogy(S_:-2:S,BER_Best(:,2),'-ok','LineWidth',3)
semilogy(S_:-2:S,BER_Best(:,3),'-or','LineWidth',3)
semilogy(S_:-2:S,BER_Best(:,4),'-og','LineWidth',3)
hold off
legend('Pt=-53dBW','Pt=-43dBW','Pt=-33dBW','Pt=-23dBW')
title('Bit Error Rate: Only Best Sensor')
xlabel('Number of Sensors')
ylabel('BER')
set(gcf,'color','w');
xticks([S:2:S_])
yticks([10^-8 10^-7 10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 10^0])
grid on
axis([S S_ 10^-8 1])


figure(3)
semilogy(S_:-2:S,BER_3_Best_Div(:,1),'-ob','LineWidth',3)
hold on
semilogy(S_:-2:S,BER_3_Best_Div(:,2),'-ok','LineWidth',3)
semilogy(S_:-2:S,BER_3_Best_Div(:,3),'-or','LineWidth',3)
semilogy(S_:-2:S,BER_3_Best_Div(:,4),'-og','LineWidth',3)
hold off
legend('Pt=-53dBW','Pt=-43dBW','Pt=-33dBW','Pt=-23dBW')
title('Bit Error Rate: 3 Best Sensors')
xlabel('Number of Sensors')
ylabel('BER')
set(gcf,'color','w');
xticks([S:2:S_])
yticks([10^-8 10^-7 10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 10^0])
grid on
axis([S S_ 10^-8 1])

figure(4)
semilogy(S_:-2:S,BER_all_Div(:,1),'-ob','LineWidth',3)
hold on
semilogy(S_:-2:S,BER_all_Div(:,2),'-ok','LineWidth',3)
semilogy(S_:-2:S,BER_all_Div(:,3),'-or','LineWidth',3)
semilogy(S_:-2:S,BER_all_Div(:,4),'-og','LineWidth',3)
hold off
legend('Pt=-53dBW','Pt=-43dBW','Pt=-33dBW','Pt=-23dBW')
title('Bit Error Rate: All Sensors')
xlabel('Number of Sensors')
ylabel('BER')
set(gcf,'color','w');
xticks([S:2:S_])
yticks([10^-8 10^-7 10^-6 10^-5 10^-4 10^-3 10^-2 10^-1 10^0])
grid on
axis([S S_ 10^-8 1])
