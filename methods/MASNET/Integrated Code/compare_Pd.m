function [BN_Pd BN_Pd_no_cp] = compare_Pd()
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
S_=96;
Num_sensors=96;
filename3 = ...
    ['./results/SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment)...
    '_Num_Sensors_' num2str(S_) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y)...
    '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
load(filename3);
for m=1:N_monte
    for t_x=1:size(ALL_SNR,1)
        
        for t_y=1:size(ALL_SNR,2)
            
            SNR = squeeze(ALL_SNR(t_x,t_y,m,1:S_));
            Pr = squeeze(ALL_Pr(t_x,t_y,m,1:S_));
            Noise = squeeze(ALL_Noise(t_x,t_y,m));
            
            [bn_pd,bn_pnd,ns_pnd,os_pd,snr,best_snr,BN_indx,BN_indx2] =...
                calculating_Prob_detection(AC_sample,Td,Tc,SNR,Pfa,Num_sensors);
            [bn_pd_no_cp,bn_pnd_no_cp,ns_pnd_no_cp,os_pd_no_cp,snr_no_cp,...
                best_snr_no_cp,BN_indx_no_cp,BN_indx2_no_cp] = ...
                calculating_Prob_detection_No_CP(SNR,Pr,Noise,Pfa,Num_sensors,Td);
            
            BN_Pd(t_x,t_y,m) = bn_pd;
            BN_Pd_no_cp(t_x,t_y,m) = bn_pd_no_cp;
            
            
        end
    end
end




end % function