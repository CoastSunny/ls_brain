%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CNA creation: 10/10/2016, last update: 05/01/2017
% Script that integrates the detection, localization and demodulation of
% signal sources for the MASNET project. It integrates codes from Pat
% Chambers and Heba Shoukry.
% The script is organised as follows:
% 1) Generates the scenario to evaluate. Can choose between separated zones
% for enemy and friend or mixed all together. It loads the information from
% the config file.

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
A.textdata(1:4,:) = [];

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
NF = A.data(index);               % Noise figurSize_FZ1_y = A.data(index);

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
















%% Antenna and Antenna Array generation for all the sensors and target

% From Pat's code in MainSimCode:
% Array preprocessing -- EADF approximation for antenna patterns.

% Antenna spacing for arrays
dist = (c/Fc)*0.25; %lambda/2 spacing

% Definition of a vector where storing the distances between elements
Dists = [dist, dist, dist, dist, dist, dist];

% Azimuth angle sampling to obtain the parameter.
% NAz=120;    % 3 degree sampling/resolution
Az=linspace(-180,180-1/NAz,NAz);

% Radiation patterns & antenna arrays.

% Slant on the antenna orientation. Shift of the orientation of the
% polarization
% Antenna_slant = 0; % If =0, no shift on the orientation

% 2D Radiation pattern of a half-lambda dipole antenna. Currently, the
% elevation is not supported (so no 3D possible). dipole function returns
% [V H ? Angle], where V and H are the values of the Vertical and
% Horizontal values of the pattern at each Angle. 
pattern(1,:,1,:)=dipole(Az,Antenna_slant); 

FP = [pattern;pattern];

% Generation of the Antenna Arrays considering the distribution
% (uniform), number of elements, distances, radiation patterns and sampling
% angles. If no FP is defined (FP-ECS and pattern), then by default it is a
% isotropic, vertically polarized antenna with XPD=inf

% Generate an arrays. Apparently it does not provide values of the pattern,
% just information about the array
Arrays(1) = AntennaArray('UCA',1,Dists(1),'FP-ACS',pattern,'Azimuth',Az); %ULA-1 
Arrays(2) = AntennaArray('ULA',10,Dists(1),'FP-ACS',pattern,'Azimuth',Az); %ULA-10

% % phi = -pi:pi/100:pi;
% % theta = -pi:pi/100:pi;
% % 
% % phi=[phi;phi];
% % theta=[theta;theta];
% % 
% 
%
% 
% ar=AntennaResponse(Arrays(2),Az);
% 
% for el=1:1 %first element in array
%     for pol=1:2
%         subplot(1,2,2*(el-1)+pol)
%         fp=squeeze(pattern(1,pol,1,:));
%         h(1)=polar(Az'*pi/180,fp);
%         set(h(1),'LineWidth',2)
%         hold on
% 
% 
%         h(2)=polar(Az'*pi/180,abs(squeeze(ar{1}(el,pol,:))),'rx');
%         set(h(2),'LineWidth',2)
%         legend(h,{'original','EADF approx'})
%         xlabel({['antenna element: ',int2str(el)];['polarization: ',int2str(pol)]}) 
%         hold off
%     end %for pol
% end %for el
% 
% a_pre=ArrayPreprocess(Arrays(2));









%% Set of the general parameters for the scenario

% Calculating the delay interval for the multipath components
Delay_interval = 1/Fs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANT: Now, we are calculating the pathloss independently from the
% WINNER-II channel. However, the wim function can also provide the
% multipath components already accounting for the path loss. To do that, we
% need to set 'PathLossModelUsed' to 'yes' in 'wimpar'. This will provide
% very small multipath components because already have the Pathloss. This
% provides useful if we want to obtain the Pr at each sensor already
% considering the Pathloss, for instance, when we only want to use the
% received multipath components to extract all the information needed such
% as the power received, time of arrival, angle of arrival, etc. The same
% applies if we want to consider the Shadowing, for that, we need to set
% 'ShadowingModelUsed' to 'yes' in 'wimpar'. Additionally, the values calculated for
% the Pathloss and Shadowing can be seen in the 'out' matrix.

wimpar = struct(  'range',1,...                         % Only useful when scenario is B5b. Set as default to 1. 
                'end_time',1,...                        % Observation end time for B5 - time points are taken as:  wimpar.TimeVector=linspace(0,wimpar.end_time,T);
                'SampleDensity', Sample_Density,...     
                'NumTimeSamples',Time_samples,...         
                'UniformTimeSampling','no',...          % If 'yes' the time sampling is equal to the smallest of all the links (calculated from the fastest sensor). If 'no', each link time sampling is calculated depending on the sensor velocity.
                'IntraClusterDsUsed','yes',...          % If 'yes' the two strongest clusters are divided into three subclusters with delays [0 5 10]ns and powers [10 6 4]/20. This is considered when calculating the rays. If 'no', then the clusters are not spread in delay.
                'NumSubPathsPerPath',20,...             % Number of rays per cluster. Only value supported is 20.
                'FixedPdpUsed','no',...                 % If 'yes' the power and delay of the rays are not random but follow values in tables. If 'no' then they are randomly created every time.
                'FixedAnglesUsed','no',...              % If 'yes' the AoD/AoAs of the rays are not random but follow values in tables. If 'no' then they are randomly created every time.
                'PolarisedArrays','yes',...             % Obsolete - always polarised arrays are used!
                'TimeEvolution','no',...                % use of time evolution option. Not fully implemented yet. Not to use for now.
                'CenterFrequency',Fc,...                
                'DelaySamplingInterval',5e-9,...        % This defines the delay grid where the multi-path components (taps) represents their time delays. If '5ns' (default) the Fs=200MSamples/s. In our case, Fs=31MSamples/s, so in theory we should change this to 16.13ns.
                'PathLossModelUsed','no',...            % If 'no' the path losses are computed for each link and provided in a separate variable. If 'yes' the path losses are multiplied to the channel matrices. 
                'ShadowingModelUsed','no',...           % The same as one line above.          
                'PathLossModel','pathloss',...          % This is just defining the name of the function where WIN function will look for the path loss formula to follow depending on the scenario and parameters such as height, etc. We could eventually changes this function for a custom one and set whatever formulas we want.
                'PathLossOption','CR_light',...         % Only used if scenario is A1 (small office). 'CR_light' or 'CR_heavy' or 'RR_light' or 'RR_heavy', CR = Corridor-Room, RR = Room-Room nlos  
                'RandomSeed',[],...                     % Sets random seed for Matlab random number generator. If empty, seed is not set. 
                'UseManualPropCondition','no');        % If 'yes' the propagation condition NLOS/LOS is set as it is in layoutpar. If 'no', then it is set following probability equations set in tables for specific scenarios. This is done in our code by ourself, but we could just write here 'no' and let the WIN function do it for us.

            
            
            
            
            
%% Start Montecarlo runs   

S_ = 96;
S = 96;     % Final number of sensors to evaluate
dS = -2;
P_ = -43;   % Initial value of the power transmitted by the target
P = -43;     % Final value of the power transmitted by the target
dP = 5;

conf_Best = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);
BER_Best = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);
BER_3_Best_Div = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);
BER_all_Div = zeros(((S-S_)/dS)+1,((P-P_)/dP)+1);



% Initialise wait bar for the Number of sensors runs
w3 = waitbar(0,'Running Number of Sensors simulation. Please wait...','Position', [500 600 280 50]);

process3 = 0;

i_s = 0;

for s=S_:dS:S
    
    waitbar(process3/(((S-S_)/dS)+1),w3);
    
    % Initialise wait bar for the Number of sensors runs
    w4 = waitbar(0,'Running Different Pt simulation. Please wait...','Position', [500 500 280 50]);
    
    process4 = 0;
    
    i_s = i_s + 1;
    
    i_p =0;
    
    for p=P_:dP:P
        
        Pt = p;
        
        % Here we load the previous SNR results once we have them
%         filename3 = ['SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(96) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
%         load(filename3);
        
    waitbar(process4/(((P-P_)/dP)+1),w4);    
    
    i_p = i_p + 1;

            %% Scenario and network generation

            % Function that generates a matrix with the position of each sensor in
            % the scenario.
            % The next line is commented for the calibration analysis
            %[Sensors,Num_sensors] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);

            % This is when we do not have the Sep_sensors but the number of sensors
            % that we want in the network.
            Num_sensors = s;
            Sep_sensors = floor(sqrt(760000/128));
            [Sensors,~] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);
            
            
            
% This is for when taking different number of sensors after getting the
% SNR_stored
%             if Num_sensors ~= 96
%                 Sensors_ = Sensors(1:96,:);
%                 delta_sensors = 96/(96-Num_sensors);
%                 Sensors_(1+delta_sensors-1:delta_sensors:end,:) = [];   % MATLAB is automatically rounding to the nearest integer the index for Sensors_, so for example, if delta_sensors=4.3, then the first position removed is position 4.
%             end
            
            % % The next lines are needed for the calibration analysis
            % Num_sensors = ((20--20)/1)+1;
            % Sensors = zeros(Num_sensors,3);
            % % Calculating the vector of distances that we need for having specific
            % % values of SNR
            % SNR_=-20:1:20;
            % Noise = BW*1.38064852e-23*295;
            % Noise = 10*log10(Noise);
            % Noise = Noise + NF;
            % d=round((lambda.*10.^((Pt-Noise-SNR_)./(20)))./(4.*pi));
            % for i=1:1:Num_sensors
            %     Sensors(i,:)=[d(i);0;hs];
            % end

            % Define sensor velocities. For now, all are static. The velocity of the
            % sensors cannot be zero, therefore, if we want to analyse static sensors,
            % we need to put very small velocities of the sensors.
            Vel_sensors=ones(Num_sensors,3).*0.01;

            
            %% Defining the layoutpar of the scenario

            % Define the type of arrays for each sensor and target. MsAAIdx has as many
            % elements as sensors and the number in it will set what array in arrays is
            % set to each of the sensors. BsAAIdxCell is the same but for target (BST).
            % If the target/BST has more than one sector, then {[1 1]} or {[1 1 1]} and
            % so on. Also, it is possible to mix arrays for different sensors and
            % target/BST i.e. MsAAIdx = [1 1 1 3 2 1 2 3 ...] and BsAAIdxCell = {[1
            % 2];[1];[3 2]} and so on.
            MsAAIdx = ones(Num_sensors,1);    % All sensor the same. 1 element array
            MsAAIdx = MsAAIdx.*1;
            BsAAIdxCell = {[1]};                % target/BST also same as sensors

            % Define number of channel pair (link between target and each sensor).
            % There are as many as sensors are if there is one target, 2 times as many
            % if there are 2 targets, so on
            chan_pairing = length(MsAAIdx);

            % Define network layot structure for wim function. Careful! the function
            % layoutparset will generate a random 500mX500m cell with random stations
            % position and velocities. Many of the parameters need to be changed.
            layoutpar = layoutparset(MsAAIdx, BsAAIdxCell, chan_pairing, Arrays);

            % Changing the scenario type. WINNER-II have pre-defined scenarios
            % (indoor/outdoor, offices, street, urban and rural areas, etc)
            % Scenarios.
            % A1         A2         B1           B2           B3        B4           
            %
            % 1          2          3            4            5         6            
            %
            % Indoor     Indoor to  Urban        Bad Urban    Indoor    Outdoor
            % Office     Outdoor    Micro-cell   Micro-cell   Hotspot   to Indoor
            %
            %
            % B5           C1          C2          C3          C4
            %
            % 7            8           9           10          11
            %
            % Stationary   Suburban    Urban       Bad urban   Urban macro            
            % Feeder       macro-cell  macro-cell  macro-cell  Outdoor to
            %             (Not Working)(Not working)           Indoor
            %
            % D1              D2
            %
            % 12              13
            %
            % Rural macro     Moving
            % cell            networks
            if Type_Environment==0
                layoutpar.ScenarioVector(layoutpar.ScenarioVector==1) = 10; % Ideally 9, but it does not work.
            else
                layoutpar.ScenarioVector(layoutpar.ScenarioVector==1) = 12;
            end



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


            % Initialise wait bar for the Montecarlo runs
            w = waitbar(0,'Running Montecarlo simulation. Please wait...','Position', [500 400 280 50]);

            process = 0;

            % Run the Montecarlo simulation N times

            % N_monte = 100;

            waitbar(process/N_monte,w);


            % Initialise wait bar for each target position at each Montecarlo run
            w2 = waitbar(0,'Simulating different target locations. Please wait...','Position', [500 300 280 50]);





            %% Define the matrices to store the results
            
            % This is to store the channel coefficients
            
%             chan_coeff = cell(N_target_pos_x,N_target_pos_y,N_monte);
%             SNR_stored = zeros(S,N_target_pos_x,N_target_pos_y);

            % Initialise the matrices to store the probabilities of detection and no
            % detection for each position of target and run of the montecarlo sim.

            Avg_BN_Pd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_BN_Pnd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_NS_Pnd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_OS_Pd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            
            BN_Pd = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the Pd of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis
            s_BN_Pd = zeros(N_monte,1);                             % Vector to store the worst Pd at each montecarlo run.    

            ALL_snr = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);     % This matrix will store the snr values of each sensor at each target position for each Montecarlo run

            %% Option 1

            Avg_Best_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_Best_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_Best_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_Best_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
            Avg_Best_BER_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average value result from the montecarlo simulation
            Avg_Best_BER_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average value result from the montecarlo simulation
            
            Best_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the BER of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis
            s_Best_BER_BPSK = zeros(N_monte,1);                             % Vector to store the worst BER at each montecarlo run.  

            %% Option 2
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
            All_3_correct_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            All_3_correct_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

            one_sensor_wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            one_sensor_wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            one_sensor_wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            one_sensor_wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            one_sensor_wrong_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            one_sensor_wrong_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

            two_sensor_wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            two_sensor_wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            two_sensor_wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            two_sensor_wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            two_sensor_wrong_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            two_sensor_wrong_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

            three_sensor_wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            three_sensor_wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            three_sensor_wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            three_sensor_wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            three_sensor_wrong_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            three_sensor_wrong_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors

            Correct_BPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly BPSK
            Correct_QPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly QPSK
            Correct_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly 4AM
            Correct_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the probability of decoding correctly 8AM

            Wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            Wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            Wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            Wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            Wrong_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
            Wrong_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors


            %% Option 3
            Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for option 3 Q formulas
            Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for option 3 Q formulas
            Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for option 3 Alouini formulas
            Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for option 3 Alouini formulas
            
            All_Div_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the BER of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis
            s_All_Div_BER_BPSK = zeros(N_monte,1);                             % Vector to store the worst BER at each montecarlo run.  

            %% Option 2-3

            best_3_Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for best 3 with diversity option 2-3 Q formulas
            best_3_Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for best 3 with diversity option 2-3 Q formulas
            best_3_Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for best 3 with diversity option 2-3 Alouini formulas
            best_3_Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for best 3 with diversity option 2-3 Alouini formulas
            
            Best_3_Div_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);   % Matrix to store the BER of the best sensor at each target position for each Montecarlo run. Used later for the number of sensors vs confidence in detection analysis
            s_Best_3_Div_BER_BPSK = zeros(N_monte,1);                             % Vector to store the worst BER at each montecarlo run.  


            out_ = cell(N_target_pos_x,N_target_pos_y);

            test = 0;
            test_ = 0;
            t = 0;
            t_ = 0;

            %% Commented for now for the analysis of number of sensors
            SNR_ = zeros(N_monte,Num_sensors);






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


                        % Set target position from origin of coordinates in metres. Now, the target
                        % position is set, but later it needs to be changed to all possible
                        % positions within the enemy area and repeat the calculations
                        Pos_target = [t_x;t_y;ht];
                        Vel_target = [0;0;0];

                        %% This is commented now for the number of sensors analysis
                        % Changing the position coordinates randomly set in layoutpar
                        % and the velocity of the target to the desired values.
                        layoutpar.Stations(1).Pos = Pos_target;
                        layoutpar.Stations(1).Velocity = Vel_target;

                        %% Changing the random generated values in layoutpar for each sensor to the desired values and configuration
                        % This has to be done here everytime we change the position of the target.

                        [layoutpar,distance] = sensor_settings(layoutpar,Sensors,Num_sensors,Type_Environment,Pos_target,Vel_sensors);

                        % This is for setting the fixed propaagation condition and the
                        % distances where the first obstacles are located. Assummed
                        % here, there is a wall at coordinate x=(0 to some point in the x coordinate) and y=500 that obstruct the
                        % three sensors on the top left of the scenario and another
                        % wall at coordinate x=1500 y=(0 to some point in the y
                        % coordinate) that obstructs the three sensors on the bottom
                        % left part. The distances are found by calculating r=(location
                        % of the wall)/(cos(arcos(Sensor_x_pos or Sensor_y_pos/sqrt((0-sensor_pos_x)^2+(0-sensor_pos_y)^2)))); Only
                        % sensor on the top right corner has LOS

            %             Wall_1 = [1500,0];
            %             Wall_2 = [0,500];
            %             
            %             layoutpar.PropagConditionVector(1) = 0;
            %             layoutpar.PropagConditionVector(2) = 0;
            %             layoutpar.PropagConditionVector(3) = 0;
            %             layoutpar.PropagConditionVector(4) = 0;
            %             layoutpar.PropagConditionVector(5) = 0;
            %             layoutpar.PropagConditionVector(6) = 0;
            %             layoutpar.PropagConditionVector(7) = 1;
            %             
            %             layoutpar.Dist1(1) = (Wall_1(1))/(cos(acos(Sensors(1,1)/sqrt((t_x-Sensors(1,1))^2+(t_y-Sensors(1,2))^2))));
            %             layoutpar.Dist1(2) = (Wall_1(1))/(cos(acos(Sensors(2,1)/sqrt((t_x-Sensors(2,1))^2+(t_y-Sensors(2,2))^2))));
            %             layoutpar.Dist1(3) = (Wall_1(1))/(cos(acos(Sensors(3,1)/sqrt((t_x-Sensors(2,1))^2+(t_y-Sensors(2,2))^2))));
            %             layoutpar.Dist1(4) = (Wall_2(2))/(cos(acos(Sensors(4,2)/sqrt((t_x-Sensors(4,1))^2+(t_y-Sensors(4,2))^2))));
            %             layoutpar.Dist1(5) = (Wall_2(2))/(cos(acos(Sensors(4,2)/sqrt((t_x-Sensors(5,1))^2+(t_y-Sensors(5,2))^2))));
            %             layoutpar.Dist1(6) = (Wall_2(2))/(cos(acos(Sensors(4,2)/sqrt((t_x-Sensors(6,1))^2+(t_y-Sensors(6,2))^2))));


                        % For test, here we can visualise the scenario evaluated
                        % NTlayout(layoutpar)

                        % Calling the wim.m function. This function calculates the channel response
                        % considering the network and general parameters layoutpar and wimpar. It
                        % can provide up to 3 outputs [H, DELAYS, FULLOUTPUT]. H is a cell array of
                        % dimensions equal to number of links (channel pairs) K. Each element in
                        % the cell array is a matrix with dimensions U x S x N x T where U=#
                        % sensors/MS, S=# targets/BSTs, N=# multipath(taps) components and T=# time
                        % samples. DELAYS is a K x N matrix with the values of the delays for each
                        % multipath component. FULLOUTPUT is a MATLAB structure that contains info
                        % such as delays (again), multipath component powers, AoA/AoD, path losses,
                        % distances, shadow fading, etc.
                        % For some reason, it does not calculate the path_losses per link when the
                        % option wimpar.PathLossModelUsed=no. In theory it should still calculate 
                        % it  and give it in the out structure but not multiply the losses to the 
                        % channel coefficients.

%% This is commented now because we loaded the SNR
                         [cir,delays,out] = wim(wimpar,layoutpar);

            %             if m == 1
            %             
            %                 [cir,delays,out] = wim(wimpar,layoutpar);
            %             
            %             else
            %                 [cir,delays,out] = wim(wimpar,layoutpar,out);
            %             end

                        % Due to the CIR and delays are for 100MHz (5ns=200MHz^-1), we
                        % need to modify the delays in order to have a delay sampling
                        % interval proportional to 31MHz (maximum sampling rate)
                        % Delay_interval=1/Fs. Most of the code is originally from
                        % Pat's code in WINUnpack.m

            %             test1 = squeeze(cir{1,1}(1,1,:,1));
            %             test2 = squeeze(cir{41,1}(1,1,:,1));
            %             test1(isnan(abs(test1)))=0;
            %             test2(isnan(abs(test2)))=0;
            %             
            %             test = test + test1;
            %             test_ = test_ + test2;
            %             
            %             t = t + abs(test1);
            %             t_ = t_ + abs(test2);

                        cir = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples);
                        
%                         chan_coeff{indx_x,indx_y,m} = cir;


                        % Calculate the SNR

                        SNR = SNR_calculation(cir,distance,lambda,Type_Environment,d_0,sigma,Num_sensors,Time_samples,Pt,NF,n,BW);

                        SNR_(m,:) = SNR;

%                         This is for storing the SNR when getting the SNR_stored
%                         SNR_stored(:,indx_x,indx_y) = SNR_stored(:,indx_x,indx_y) + SNR;

                        %% This is for when getting the specific SNR after getting SNR_stored
                          
                          
%                           if Num_sensors == 96
%                               SNR_=zeros(N_monte,96);
%                                 SNR_(m,:) = SNR_stored(1:96,indx_x,indx_y);
%                           else
%                               SNR_=zeros(N_monte,96);
%                               SNR_(m,:) = SNR_stored(1:96,indx_x,indx_y);
%                               SNR_(:,1+delta_sensors-1:delta_sensors:end) = [];
%                           end
%                           
%                           SNR = SNR_(m,:)';
                       

                        % Calculate the Pd (probability of detection)

                        [bn_pd,bn_pnd,ns_pnd,os_pd,snr,best_snr,BN_indx,BN_indx2] = calculating_Prob_detection(AC_sample,Td,Tc,SNR,Pfa,Num_sensors);


                        % For option 1 Detection
                        BN_Pd(indx_x,indx_y,m) = bn_pd;     % Store the Pd in this Montecarlo run and target position
                        
                        Avg_BN_Pd(indx_x,indx_y) = Avg_BN_Pd(indx_x,indx_y) + bn_pd;
                        Avg_BN_Pnd(indx_x,indx_y) = Avg_BN_Pnd(indx_x,indx_y) + bn_pnd;

                        % For option 2 Detecion
                        Avg_NS_Pnd(indx_x,indx_y) = Avg_NS_Pnd(indx_x,indx_y) + ns_pnd;
                        Avg_OS_Pd(indx_x,indx_y) = Avg_OS_Pd(indx_x,indx_y) + os_pd;


                        ALL_snr(indx_x,indx_y,m,:) = snr;   % Store the resulting snr in this target position for this run. No it does not consider more than 1 time sample!



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


                        % The probability of not decoding correct is
                        % =(1-Pe_all_right)=1_sensor_wrong+2_sensor_wrong+3_sensor_wrong
            %             Wrong_BPSK(indx_x,indx_y) = Wrong_BPSK(indx_x,indx_y) + 1 - All_3_correct_BPSK(indx_x,indx_y);
            %             Wrong_QPSK(indx_x,indx_y) = Wrong_QPSK(indx_x,indx_y) + 1 - All_3_correct_QPSK(indx_x,indx_y);
            %             Wrong_4AM(indx_x,indx_y) = Wrong_4AM(indx_x,indx_y) + 1 - All_3_correct_4AM(indx_x,indx_y);
            %             Wrong_8AM(indx_x,indx_y) = Wrong_8AM(indx_x,indx_y) + 1 - All_3_correct_8AM(indx_x,indx_y);

                          % This has to be changed. All_3_correct cannot be used
                          % because it will be larger than 1 as it is adding the result above for every run
                          % of the montecarlo. It needs to be changed for the actual
                          % formulas above.
            %             Wrong_BPSK(indx_x,indx_y) = Wrong_BPSK(indx_x,indx_y) + (1 - (All_3_correct_BPSK(indx_x,indx_y) + one_sensor_wrong_BPSK(indx_x,indx_y)));
            %             Wrong_QPSK(indx_x,indx_y) = Wrong_QPSK(indx_x,indx_y) + (1 - (All_3_correct_QPSK(indx_x,indx_y) + one_sensor_wrong_QPSK(indx_x,indx_y)));
            %             Wrong_4AM(indx_x,indx_y) = Wrong_4AM(indx_x,indx_y) + (1 - (All_3_correct_4AM(indx_x,indx_y) + one_sensor_wrong_4AM(indx_x,indx_y)));
            %             Wrong_8AM(indx_x,indx_y) = Wrong_8AM(indx_x,indx_y) + (1 - (All_3_correct_8AM(indx_x,indx_y) + one_sensor_wrong_8AM(indx_x,indx_y)));


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







            % Delete the waitbars
            delete(w)
            delete(w2)
            
            %% Take the required results for the number of sensors analysis
            
            for m=1:1:N_monte
               s_BN_Pd(m) = min(min(BN_Pd(:,:,m))); 
            end
            
            conf_Best(i_s,i_p) = sum(s_BN_Pd==1)/length(s_BN_Pd);    % Store how many times we had Pd=1 for the best sensor. This gives us the confidence of always detecting or how many times we always detected. If for all the montecarlo runs we always had the best sensor with Pd=1, then our confidence is 100% we always detect.


            
            %% Calculate the average result from the montecarlo simulation for each
            % target position

            % Detection options 1 and 2
            Avg_BN_Pd = Avg_BN_Pd./N_monte;
            Avg_BN_Pnd = 1-Avg_BN_Pd;
            Avg_NS_Pnd = Avg_NS_Pnd./N_monte;
            Avg_OS_Pd = 1-Avg_NS_Pnd;

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



            % Here we calculate the probabilities of detection and BER but focused on the sensors. The idea is to be able to represent heat maps for each sensor position to determine the best placements for sensors

            % Calcualte the Probabilities of detectio and BER for each sensor, at each
            % target position and montecarlo run
            SNR_ = mean(SNR_);
            Pd = calculating_Prob_detection_v2(AC_sample,Td,Tc,ALL_snr,Pfa);
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(ALL_snr);

            % These lines are for showing the resulting Pd and BER for the calibration
            % analysis.
            % Pd = squeeze(Pd);
            % Pe_BPSK = squeeze(Pe_BPSK);
            % Pe_QPSK = squeeze(Pe_QPSK);
            % Pe_4AM = squeeze(Pe_4AM);
            % Pe_8AM = squeeze(Pe_8AM);
            % 
            % filename = ['Results_Calibration_TE_' num2str(Type_Environment) '_sigma_' num2str(sigma) 'dB_Fading_yes_all_together'];
            % save(filename,'Pd','Pe_BPSK','Pe_QPSK','Pe_4AM','Pe_8AM','SNR_');

            % figure(6)
            % plot(SNR,Pd,'-o')
            % title('Probability of detection vs SNR')
            % xlabel('SNR [dB]')
            % ylabel('Pe_BPSK')
            % 
            % figure(7)
            % plot(SNR,Pe_BPSK,'-o')
            % title('BPSK BER vs SNR')
            % xlabel('SNR [dB]')
            % ylabel('Pe_QPSK')
            % set(gca,'yscale','log')
            % 
            % figure(8)
            % plot(SNR,Pe_QPSK,'-o')
            % title('QPSK BER vs SNR')
            % xlabel('SNR [dB]')
            % ylabel('Pe_4AM')
            % set(gca,'yscale','log')
            % 
            % figure(9)
            % plot(SNR,Pe_4AM,'-o')
            % title('4AM BER vs SNR')
            % xlabel('SNR [dB]')
            % ylabel('Pd')
            % set(gca,'yscale','log')
            % 
            % figure(10)
            % plot(SNR,Pe_8AM,'-o')
            % title('8AM BER vs SNR')
            % xlabel('SNR [dB]')
            % ylabel('Pd')
            % set(gca,'yscale','log')

            % Then, take the averaged Pd and BER at each sensor for each montecarlo run
            % and target position
            Pd_final = zeros(Num_sensors,1);
            Pe_BPSK_final = zeros(Num_sensors,1);
            Pe_QPSK_final = zeros(Num_sensors,1);
            Pe_4AM_final = zeros(Num_sensors,1);
            Pe_8AM_final = zeros(Num_sensors,1);

%             Pd_rep = zeros((Size_Scenario/Sep_sensors)+1);
%             Pe_BPSK_rep = zeros((Size_Scenario/Sep_sensors)+1);
%             Pe_QPSK_rep = zeros((Size_Scenario/Sep_sensors)+1);
%             Pe_4AM_rep = zeros((Size_Scenario/Sep_sensors)+1);
%             Pe_8AM_rep = zeros((Size_Scenario/Sep_sensors)+1);
%             positions = 0:Sep_sensors:Size_Scenario;

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

                % Now, prepare a squared matrix to store the values at each sensor position
                % for the heatmaps

%                 Pd_rep(ceil(Sensors(i,1,1)./Sep_sensors),ceil(Sensors(i,2,1)./Sep_sensors)) = Pd_final(i);
%                 Pe_BPSK_rep(ceil(Sensors(i,1,1)./Sep_sensors),ceil(Sensors(i,2,1)./Sep_sensors)) = Pe_BPSK_final(i);
%                 Pe_QPSK_rep(ceil(Sensors(i,1,1)./Sep_sensors),ceil(Sensors(i,2,1)./Sep_sensors)) = Pe_QPSK_final(i);
%                 Pe_4AM_rep(ceil(Sensors(i,1,1)./Sep_sensors),ceil(Sensors(i,2,1)./Sep_sensors)) = Pe_4AM_final(i);
%                 Pe_8AM_rep(ceil(Sensors(i,1,1)./Sep_sensors),ceil(Sensors(i,2,1)./Sep_sensors)) = Pe_8AM_final(i);
            end


            % figure(1)
            % pcolor(positions,positions,Pd_rep)
            % colormap(colorcube)
            % title('Probability of detection for each sensor')
            % xlabel('x coordinate (metres)')
            % ylabel('y coordinate (metres)')
            % 
            % figure(2)
            % pcolor(positions,positions,Pe_BPSK_rep)
            % colormap(colorcube)
            % title('BPSK BER for each sensor')
            % xlabel('x coordinate (metres)')
            % ylabel('y coordinate (metres)')

            % figure(3)
            % pcolor(positions,positions,Pe_QPSK_rep)
            % colormap(colorcube)
            % title('QPSK BER for each sensor')
            % xlabel('x coordinate (metres)')
            % ylabel('y coordinate (metres)')
            % 
            % figure(4)
            % pcolor(positions,positions,Pe_4AM_rep)
            % colormap(colorcube)
            % title('4AM BER for each sensor')
            % xlabel('x coordinate (metres)')
            % ylabel('y coordinate (metres)')
            % 
            % figure(5)
            % pcolor(positions,positions,Pe_8AM_rep)
            % colormap(colorcube)
            % title('8AM BER for each sensor')
            % xlabel('x coordinate (metres)')
            % ylabel('y coordinate (metres)')



                 % Plot target position and sensor position
            %      figure(1)
            %      plot3(Sensors(:,1,1),Sensors(:,2,1),Pd_final,'xr')
            % %      hold on
            % %      plot3(Pos_target(1),Pos_target(2),Pos_target(3),'ob')
            % %      hold off
            %      title('Target position x and sensor location o')
            %      xlabel('x coordinate (metres)')
            %      ylabel('y coordinate (metres)')
            %      zlabel('Probability of Detection')
            
            process4 = process4 + 1;
    end
   
    process3 = process3 + 1;
    
    delete(w4)
    
end

delete(w3)

% SNR_stored = SNR_stored./N_monte;
            

%% Save results in file

% filename3 = ['SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(Num_sensors) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
% save(filename3,'SNR_stored');

filename = ['Results_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) 'SepSen_' num2str(Sep_sensors) 'SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) ...
    '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
save(filename,'Avg_BN_Pd','Avg_BN_Pnd','Avg_NS_Pnd','Avg_OS_Pd','Avg_Best_BER_BPSK','Avg_Best_BER_QPSK','Avg_Best_BER_4AM','Avg_Best_BER_8AM',...
    'Avg_All_BER_BPSK','Avg_All_BER_QPSK','Avg_All_BER_4AM','Avg_All_BER_8AM','Diversity_BER_BPSK','Diversity_BER_QPSK','Diversity_BER_4AM',...
    'Diversity_BER_8AM','All_3_correct_BPSK','All_3_correct_QPSK',...
    'All_3_correct_4AM','All_3_correct_8AM','one_sensor_wrong_BPSK','one_sensor_wrong_QPSK','one_sensor_wrong_4AM','one_sensor_wrong_8AM',...
    'two_sensor_wrong_BPSK','two_sensor_wrong_QPSK','two_sensor_wrong_4AM','two_sensor_wrong_8AM',...
    'Wrong_BPSK','Wrong_QPSK','Wrong_4AM','Wrong_8AM','Pd_final','Pe_BPSK_final','Pe_QPSK_final','Pe_4AM_final','Pe_8AM_final');

n_sensors = S_:dS:S;
p_power = P_:dP:P;
filename2 = ['Results_Num_Sensors_vs_Pd_BER_vs_SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Sensors_ ' num2str(S_) '_' num2str(dS) '_' num2str(S) '_Power_' num2str(P_) ...
    '_' num2str(dP) '_' num2str(P) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_sigma_' num2str(sigma) 'dB.mat'];
save(filename2,'conf_Best','BER_Best','BER_3_Best_Div','BER_all_Div','n_sensors','p_power');




%% Plotting figures for Number of Sensors vs Pd vs BER vs SNR analysis





%% Plot heat maps for detection

% Heat map option 1 detection
% hmo1 = HeatMap(Avg_BN_Pd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo1, 'Probability of being detected by the best sensor');
% 
% % % Heat map option 1 no detection
% % hmo2 = HeatMap(Avg_BN_Pnd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% % addTitle(hmo2, 'Probability of not being detected by the best sensor');
% 
% % Heat map option 2 no detection
% % hmo3 = HeatMap(Avg_NS_Pnd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% % addTitle(hmo3, 'Probability of not being detected by any sensor');
% 
% % Heat map option 2 detection
% hmo4 = HeatMap(Avg_OS_Pd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo4, 'Probability of being detected by at least one sensor');


%% Plot the heat maps for BER


%% Option 1
% Heat map option 1 BER BPSK (Proakis)
hmo5 = HeatMap(Avg_Best_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo5, 'BER of the best sensor BPSK option 1 Q formulas');

% % Heat map option 1 BER QPSK (Proakis)
% hmo8 = HeatMap(Avg_Best_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo8, 'BER of the best sensor QPSK option 1 Q formulas');

% Heat map option 1 BER 4-AM (Alouini)
% hmo9 = HeatMap(Avg_Best_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo9, 'BER of the best sensor 4-AM option 1 Alouini paper');

% % Heat map option 1 BER 8-AM (Alouini)
% hmo11 = HeatMap(Avg_Best_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo11, 'BER of the best sensor 8-AM option 1 Alouini paper');




%% Option 3
% Heat map option 3 BER BPSK  (Proakis)
hmo13 = HeatMap(Diversity_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo13, 'BER BPSK all sensors (diversity) option 3 Q formulas');

% % Heat map option 3 BER QPSK  (Proakis)
% hmo14 = HeatMap(total_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo14, 'BER BPSK all sensors (diversity) option 3 Q formulas');

% Heat map option 3 BER 4-AM  (Alouini)
% hmo15 = HeatMap(Diversity_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo15, 'BER BPSK all sensors (diversity) option 3 Q formulas');

% % Heat map option 3 BER 8-AM  (Alouini)
% hmo15 = HeatMap(Diversity_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo15, 'BER BPSK all sensors (diversity) option 3 Q formulas');


%% Option 2-3
% Heat map option 3 BER BPSK  (Proakis)
hmo113 = HeatMap(best_3_Diversity_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo113, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');

% % Heat map option 3 BER QPSK  (Proakis)
% hmo114 = HeatMap(best_3_Diversity_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo114, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');

% Heat map option 3 BER 4-AM  (Alouini)
% hmo115 = HeatMap(best_3_Diversity_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo115, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');

% % Heat map option 3 BER 8-AM  (Alouini)
% hmo115 = HeatMap(best_3_Diversity_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo115, 'BER BPSK 3 best sensors (diversity) option 2-3 Q formulas');




%% Option 2
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
hmo162 = HeatMap(Avg_90_snr_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo162, 'BER of sensors within 90% of best SNR (average) BPSK option 2 Q formulas');

% Heat map option 2 BER BPSK: Average best sensors within 50% of best snr (Proakis)
hmo163 = HeatMap(Avg_50_snr_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo163, 'BER of sensors within 50% of best SNR (average) BPSK option 2 Q formulas');

% Heat map option 2 BER BPSK: Average best sensors within 10% of best snr (Proakis)
hmo164 = HeatMap(Avg_10_snr_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo164, 'BER of sensors within 10% of best SNR (average) BPSK option 2 Q formulas');





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
hmo228 = HeatMap(Correct_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo228, 'Option 2 best 3: Probability of decoding correctly BPSK');

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
hmo34 = HeatMap(two_sensor_wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo34, 'Option 2 best 3: Probability of two sensor receive wrong BPSK');

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
% 












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Localization

% Load Pd and BER values from Montecarlo simulations
filename = 'Results_TS_0_TE_0SepSen_200SepTar_50_50_Pt_-33dBW_sigma_9dB.mat';
load(filename);

% Loading of the LTE signal
Tx_vector_20M = load('Tx_20MHz');
Tx_vector_20M = Tx_vector_20M.Tx_LTE_20MHz_QPSK;
Tx_signal = Tx_vector_20M;


% Placing randonmly the target

%% Start the run for each possible position of the target

error_TDOA_only_LOS = zeros(N_target_pos_x,N_target_pos_y);
error_TDOA_only_LOS_Det = zeros(N_target_pos_x,N_target_pos_y);
error_TDOA_only_NLOS = zeros(N_target_pos_x,N_target_pos_y);
error_TDOA_only_NLOS_Det = zeros(N_target_pos_x,N_target_pos_y);
error_TDOA_all = zeros(N_target_pos_x,N_target_pos_y);
error_TDOA_all_Det = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_LOS_MU = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_LOS_BAR = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_LOS_MU_Det = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_LOS_BAR_Det = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_nLOS_MU = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_nLOS_BAR = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_nLOS_MU_Det = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_only_nLOS_BAR_Det = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_all_Mu = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_all_BAR = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_all_MU_Det = zeros(N_target_pos_x,N_target_pos_y);
error_AoA_all_BAR_Det = zeros(N_target_pos_x,N_target_pos_y);


% Initialise wait bar for the Montecarlo runs
w = waitbar(0,'Running Montecarlo simulation. Please wait...','Position', [500 400 280 50]);

process = 0;

% Run the Montecarlo simulation N times

% N_monte = 100;

waitbar(process/N_monte,w);


% Initialise wait bar for each target position at each Montecarlo run
w2 = waitbar(0,'Simulating different target locations. Please wait...','Position', [500 300 280 50]);
    
    indx_x = 1;
    indx_y = 1;
    
    process2 = 0;
    
    waitbar(process2/T_target_pos,w2);

    for t_x=0:Int_target_x:Size_EZ_x

        for t_y=0:Int_target_y:Size_EZ_y
            
            
            process = 0;
            
            waitbar(process/N_monte,w)
            
            for m=1:1:N_monte

                % % This is for mixed zones
                % t_x = rand*Size_Scenario;
                % t_y = rand*Size_Scenario;
                
                Target_pos=[t_x t_y];

                Pos_target = [t_x;t_y;ht];
                Vel_target = [0;0;0];
                layoutpar.Stations(1).Pos = Pos_target;
                layoutpar.Stations(1).Velocity = Vel_target;

                % Calculating distances between target and sensors
                [layoutpar,distance] = sensor_settings(layoutpar,Sensors,Num_sensors,Type_Environment,Pos_target,Vel_sensors);

                % Generate the CIR
                [cir,delays,out] = wim(wimpar,layoutpar);

                % Find the sensors that have LOS
                [~,idx]= find(layoutpar.PropagConditionVector==1);
                LOS_sensor=Sensors(idx,:);

                % Find the sensors that have NLOS
                [~,nidx]= find(layoutpar.PropagConditionVector==0);
                nLOS_sensor=Sensors(nidx,:);

                % downsampling of channel coefficients
                cir_ds = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples);

                % downsampling of channel coefficients
                cir_ds = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples);
                for kk= 1:length(idx)
                    cir_ds_los{kk} = cir_ds{kk};
                end
                for ll= 1:length(nidx)
                    cir_ds_nlos{ll} = cir_ds{ll};
                end

                % Calculate the received times for the LOS and NLOS sensors
                [rx_times_los,rx_times_nlos] = delay_calc(distance,Type_Environment,cir_ds,idx,nidx,c);
                rx_times = zeros(length(Sensors),size(cir_ds{1,1},3));
                rx_times(idx,:) = rx_times_los;
                rx_times(nidx,:) = rx_times_nlos;

                % Calculate the Prob of having LOS?
                Avg_pd_LOS=Pd_final(idx(1:end));
                [v,p_los]=sort(Avg_pd_LOS,'descend');

                % Calculating the Prob of having NLOS?
                Avg_pd_nLOS=Pd_final(nidx(1:end));
                [vn,p_nlos]=sort(Avg_pd_nLOS,'descend');

                % Generate a Bernouilli vector that will determine which sensors have
                % detected and wich ones no
                Det_sensors = zeros(Num_sensors,1);
                % Det_LOS_sensors = zeros(length(idx),1);
                % Det_NLOS_sensors = zeros(length(nidx),1);

                for ii=1:1:Num_sensors
                    Det_sensors(ii) = randsrc(1,1,[0 1; (1-Pd_final(ii)) Pd_final(ii)]);
                end

                Det_LOS_sensors = Det_sensors(idx);

                Det_NLOS_sensors = Det_sensors(nidx);


%                 %Estimation of the target position for TDOA
%                 if length(idx) >= 3
%                     [est_target_los,iter_target_los]= TDOA_localization(rx_times_los(:,1),LOS_sensor,c);
% 
% %                     figure(1)
% %                     subplot(2,1,1)
% %                     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% %                     plot(t_x,t_y,'bo','MarkerSize',16);hold on
% %                     plot(LOS_sensor(:,1),LOS_sensor(:,2),'gx','MarkerSize',16); hold on
% %                     plot(est_target_los(1,:),est_target_los(2,:),'k+','MarkerSize',16); hold on
% %                     plot(iter_target_los(:,1),iter_target_los(:,2),'m+','MarkerSize',16); hold off
% %                     legend('Sensor Pos','True Target Pos','All LOS Sensors Pos','Est Target Pos','Iter Target Pos')
% 
%                     error_TDOA_only_LOS(indx_x,indx_y) = error_TDOA_only_LOS(indx_x,indx_y) + sqrt((t_x-est_target_los(1,:))^2+(t_y-est_target_los(2,:))^2);
% 
%                     if sum(Det_LOS_sensors) >= 3
%                         [est_target_los_pd,iter_target_los_pd]= TDOA_localization(rx_times_los(find(Det_LOS_sensors),1),LOS_sensor(find(Det_LOS_sensors),:),c);
% 
% %                         subplot(2,1,2)
% %                         plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% %                         plot(t_x,t_y,'bo','MarkerSize',16);hold on
% %                         plot(LOS_sensor(find(Det_LOS_sensors),1),LOS_sensor(find(Det_LOS_sensors),2),'g*','MarkerSize',16); hold on
% %                         plot(est_target_los_pd(1,:),est_target_los_pd(2,:),'k+','MarkerSize',16); hold on
% %                         plot(iter_target_los_pd(:,1),iter_target_los_pd(:,2),'m+','MarkerSize',16); hold off
% %                         legend('Sensor Pos','True Target Pos','Detected LOS Sensors Pos','Est Target Pos','Iter Target Pos')
% %                         title('Target position estimation using TDOA only DETECTED LOS sensors')
% 
%                         error_TDOA_only_LOS_Det(indx_x,indx_y) = error_TDOA_only_LOS_Det(indx_x,indx_y) + sqrt((t_x-est_target_los_pd(1,:))^2+(t_y-est_target_los_pd(2,:))^2);
%                         
%                     end
% 
%                 end
% 
% %                 subplot(2,1,1)
% %                 title('Target position estimation using TDOA ALL LOS sensors')
% 
% 
% 
%                 [est_target_nlos,iter_target_nlos]= TDOA_localization(rx_times_nlos(:,1),nLOS_sensor,c);
% 
% %                 figure(2)
% %                 subplot(2,1,1)
% %                 plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% %                 plot(t_x,t_y,'bo','MarkerSize',16);hold on
% %                 plot(nLOS_sensor(:,1),nLOS_sensor(:,2),'c*','MarkerSize',16); hold on
% %                 plot(est_target_nlos(1,:),est_target_nlos(2,:),'k*','MarkerSize',16); hold on
% %                 plot(iter_target_nlos(:,1),iter_target_nlos(:,2),'m*','MarkerSize',16); hold off
% %                 legend('Sensor Pos','True Target Pos','All NLOS Sensors Pos','Est Target Pos','Iter Target Pos')
% 
%                 error_TDOA_only_NLOS(indx_x,indx_y) = error_TDOA_only_NLOS(indx_x,indx_y) + sqrt((t_x-est_target_nlos(1,:))^2+(t_y-est_target_nlos(2,:))^2);
% 
%                 if sum(Det_NLOS_sensors) >= 3
%                     [est_target_nlos_pd,iter_target_nlos_pd]= TDOA_localization(rx_times_nlos(find(Det_NLOS_sensors),1),nLOS_sensor(find(Det_NLOS_sensors),:),c);
% 
% %                     subplot(2,1,2)
% %                     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% %                     plot(t_x,t_y,'bo','MarkerSize',16);hold on
% %                     plot(nLOS_sensor(find(Det_NLOS_sensors),1),nLOS_sensor(find(Det_NLOS_sensors),2),'c^','MarkerSize',16); hold on
% %                     plot(est_target_nlos_pd(1,:),est_target_nlos_pd(2,:),'k*','MarkerSize',16); hold on
% %                     plot(iter_target_nlos_pd(:,1),iter_target_nlos_pd(:,2),'m*','MarkerSize',16); hold off
% %                     legend('Sensor Pos','True Target Pos','Detected NLOS Sensors Pos','Est Target Pos','Iter Target Pos')
% %                     title('Target position estimation using TDOA only DETECTED NLOS sensors')
% 
%                     error_TDOA_only_NLOS_Det(indx_x,indx_y) = error_TDOA_only_NLOS_Det(indx_x,indx_y) + sqrt((t_x-est_target_nlos_pd(1,:))^2+(t_y-est_target_nlos_pd(2,:))^2);
%                 end
% 
% %                 subplot(2,1,1)
% %                 title('Target position estimation using TDOA ALL NLOS sensors')
% 
%                 [est_target,iter_target]= TDOA_localization(rx_times(:,1),Sensors,c);
% 
% %                 figure(3)
% %                 subplot(2,1,1)
% %                 plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% %                 plot(t_x,t_y,'bo','MarkerSize',16);hold on
% %                 plot(est_target(1,:),est_target(2,:),'k*','MarkerSize',16); hold on
% %                 plot(iter_target(:,1),iter_target(:,2),'m*','MarkerSize',16); hold off
% %                 legend('Sensor Pos','True Target Pos','Est Target Pos','Iter Target Pos')
% 
%                 error_TDOA_all(indx_x,indx_y) = error_TDOA_all(indx_x,indx_y) + sqrt((t_x-est_target(1,:))^2+(t_y-est_target(2,:))^2);
% 
% 
%                 if sum(Det_sensors) >=3
%                     [est_target_pd,iter_target_pd]= TDOA_localization(rx_times(find(Det_sensors),1),Sensors(find(Det_sensors),:),c);
% 
% %                     subplot(2,1,2)
% %                     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% %                     plot(t_x,t_y,'bo','MarkerSize',16);hold on
% %                     plot(Sensors(find(Det_sensors),1),Sensors(find(Det_sensors),2),'c^','MarkerSize',16); hold on
% %                     plot(est_target_pd(1,:),est_target_pd(2,:),'k*','MarkerSize',16); hold on
% %                     plot(iter_target_pd(:,1),iter_target_pd(:,2),'m*','MarkerSize',16); hold off
% %                     legend('Sensor Pos','True Target Pos','Detected Sensors','Est Target Pos','Iter Target Pos')
% %                     title('Target position estimation using TDOA only DETECTED sensors')
% 
%                     error_TDOA_all_Det(indx_x,indx_y) = error_TDOA_all_Det(indx_x,indx_y) + sqrt((t_x-est_target_pd(1,:))^2+(t_y-est_target_pd(2,:))^2);
%                 end
% 
% %                 subplot(2,1,1)
% %                 title('Target position estimation using TDOA ALL sensors')












                % AoA localization (linear least square problem)
                if length(idx) > 0
                    [aoa_los,aoa_b_los] = AOA_Detection(Type_Environment,LOS_sensor,Tx_signal,cir_ds_los,Target_pos,1);
                     az_mu(idx) = aoa_los;
                     az_bar(idx) = aoa_b_los;
                end
                
                
                [aoa_nlos,aoa_b_nlos] = AOA_Detection(Type_Environment,nLOS_sensor,Tx_signal,cir_ds_nlos,Target_pos,0);
                az_mu = zeros(1,Num_sensors);

                az_mu(nidx) = aoa_nlos;
                az_bar = zeros(1,Num_sensors);

                az_bar(nidx) = aoa_b_nlos;


                % localization for all LOS sensors

                if length(idx) >= 2
%                     [pos_los]=AOA_localization(aoa_los,size(aoa_los,2),LOS_sensor);
                    [pos_b_los]=AOA_localization(aoa_b_los,size(aoa_b_los,2),LOS_sensor);
                    
%                     figure(4)
%                     subplot(2,1,1)
%                     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%                     plot(t_x,t_y,'bo','MarkerSize',16);hold on
%                     plot(LOS_sensor(:,1),LOS_sensor(:,2),'g*','MarkerSize',16); hold on
%                     plot(pos_los(2),pos_los(1),'k+','MarkerSize',16); hold on
%                     plot(pos_b_los(2),pos_b_los(1),'m+','MarkerSize',16); hold off
%                     legend('Sensor Pos','True Target Pos','All LOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')

%                     error_AoA_only_LOS_MU(indx_x,indx_y) = error_AoA_only_LOS_MU(indx_x,indx_y) + sqrt((t_x-pos_los(2))^2+(t_y-pos_los(1))^2);
                    error_AoA_only_LOS_BAR(indx_x,indx_y) = error_AoA_only_LOS_BAR(indx_x,indx_y) + sqrt((t_x-pos_b_los(2))^2+(t_y-pos_b_los(1))^2);

                    % localization for DETECTING LOS sensors only

                    if sum(Det_LOS_sensors) >= 2
%                         [pos_los_pd]= AOA_localization(aoa_los(find(Det_LOS_sensors)),size(aoa_los(find(Det_LOS_sensors)),2),LOS_sensor(find(Det_LOS_sensors),:));
                        [pos_b_los_pd]= AOA_localization(aoa_b_los(find(Det_LOS_sensors)),size(aoa_b_los(find(Det_LOS_sensors)),2),LOS_sensor(find(Det_LOS_sensors),:));
%                         subplot(2,1,2)
%                         plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%                         plot(t_x,t_y,'bo','MarkerSize',16);hold on
%                         plot(LOS_sensor(find(Det_LOS_sensors),1),LOS_sensor(find(Det_LOS_sensors),2),'c^','MarkerSize',16); hold on
%                         plot(pos_los_pd(2),pos_los_pd(1),'k+','MarkerSize',16); hold on
%                         plot(pos_b_los_pd(2),pos_b_los_pd(1),'m+','MarkerSize',16); hold off
%                         legend('Sensor Pos','True Target Pos','All LOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')
%                         title('Target position estimation using AoA only DETECTED LOS sensors')
                    
%                     error_AoA_only_LOS_MU_Det(indx_x,indx_y) = error_AoA_only_LOS_MU_Det(indx_x,indx_y) + sqrt((t_x-pos_los(2))^2+(t_y-pos_los(1))^2);
                    error_AoA_only_LOS_BAR_Det(indx_x,indx_y) = error_AoA_only_LOS_BAR_Det(indx_x,indx_y) + sqrt((t_x-pos_b_los(2))^2+(t_y-pos_b_los(1))^2);

                    end
                end

%                 subplot(2,1,1)
%                 title('Target position estimation using AoA ALL LOS sensors')


                % localization for all NLOS sensors

                if length(nidx) >= 2
%                     [pos_nlos]=AOA_localization(aoa_nlos,size(aoa_nlos,2),nLOS_sensor);
                    [pos_b_nlos]=AOA_localization(aoa_b_nlos,size(aoa_b_nlos,2),nLOS_sensor);
                    
%                     figure(5)
%                     subplot(2,1,1)
%                     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%                     plot(t_x,t_y,'bo','MarkerSize',16);hold on
%                     plot(nLOS_sensor(:,1),nLOS_sensor(:,2),'g*','MarkerSize',16); hold on
%                     %plot(pos_nlos(2),pos_nlos(1),'k+','MarkerSize',16); hold on
%                     plot(pos_b_nlos(2),pos_b_nlos(1),'m+','MarkerSize',16); hold off
%                     legend('Sensor Pos','True Target Pos','All NLOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')

%                     error_AoA_only_nLOS_MU(indx_x,indx_y) = error_AoA_only_nLOS_MU(indx_x,indx_y) + sqrt((t_x-pos_nlos(2))^2+(t_y-pos_nlos(1))^2);
                    error_AoA_only_nLOS_BAR(indx_x,indx_y) = error_AoA_only_nLOS_BAR(indx_x,indx_y) + sqrt((t_x-pos_b_nlos(2))^2+(t_y-pos_b_nlos(1))^2);

                    % localization for DETECTING NLOS sensors only

                    if sum(Det_NLOS_sensors) >= 2
                        %[pos_nlos_pd]= AOA_localization(aoa_nlos(find(Det_NLOS_sensors)),size(aoa_nlos(find(Det_NLOS_sensors)),2),NLOS_sensor(find(Det_NLOS_sensors),:));
                        [pos_b_nlos_pd]= AOA_localization(aoa_b_nlos(find(Det_NLOS_sensors)),size(aoa_b_nlos(find(Det_NLOS_sensors)),2),nLOS_sensor(find(Det_NLOS_sensors),:));
                        
%                         subplot(2,1,2)
%                         plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%                         plot(t_x,t_y,'bo','MarkerSize',16);hold on
%                         plot(nLOS_sensor(find(Det_NLOS_sensors),1),nLOS_sensor(find(Det_NLOS_sensors),2),'c^','MarkerSize',16); hold on
%                         %plot(pos_nlos_pd(2),pos_nlos_pd(1),'k+','MarkerSize',16); hold on
%                         plot(pos_b_nlos_pd(2),pos_b_nlos_pd(1),'m+','MarkerSize',16); hold off
%                         legend('Sensor Pos','True Target Pos','All NLOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')
%                         title('Target position estimation using AoA only DETECTED NLOS sensors')

%                     error_AoA_only_nLOS_MU_Det(indx_x,indx_y) = error_AoA_only_nLOS_MU_Det(indx_x,indx_y) + sqrt((t_x-pos_nlos(2))^2+(t_y-pos_nlos(1))^2);
                    error_AoA_only_nLOS_BAR_Det(indx_x,indx_y) = error_AoA_only_nLOS_BAR_Det(indx_x,indx_y) + sqrt((t_x-pos_b_nlos(2))^2+(t_y-pos_b_nlos(1))^2);
                    
                    end
                end

%                 subplot(2,1,1)
%                 title('Target position estimation using AoA ALL NLOS sensors')

                % localization using all sensors

%                 [pos_mu]= AOA_localization(az_mu,size(az_mu,2),Sensors);
                [pos_bar]= AOA_localization(az_bar,size(az_bar,2),Sensors);
                
%                 figure(6)
%                 subplot(2,1,1)
%                 plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%                 plot(t_x,t_y,'bo','MarkerSize',16);hold on
%                 %plot(pos_mu(2),pos_mu(1),'k*','MarkerSize',16); hold on
%                 plot(pos_bar(2),pos_bar(1),'m*','MarkerSize',16); hold off
%                 legend('Sensor Pos','True Target Pos','MUSIC Target Pos','BARTLETT Target Pos')

%                 error_AoA_all_Mu(indx_x,indx_y) = error_AoA_all_Mu(indx_x,indx_y) + sqrt((t_x-pos_mu(2))^2+(t_y-pos_mu(1))^2);
                error_AoA_all_BAR(indx_x,indx_y) = error_AoA_all_BAR(indx_x,indx_y) + sqrt((t_x-pos_bar(2))^2+(t_y-pos_bar(1))^2);
                
                if sum(Det_sensors) >=2
%                     [pos_mu_pd]= AOA_localization(az_mu(find(Det_sensors)),size(az_mu(find(Det_sensors)),2),Sensors(find(Det_sensors),:));
                    [pos_bar_pd]= AOA_localization(az_bar(find(Det_sensors)),size(az_bar(find(Det_sensors)),2),Sensors(find(Det_sensors),:));

                    % Using only sensors that detected

%                     subplot(2,1,2)
%                     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%                     plot(t_x,t_y,'bo','MarkerSize',16);hold on
%                     plot(Sensors(find(Det_sensors),1),Sensors(find(Det_sensors),2),'c^','MarkerSize',16); hold on
%                     %plot(pos_mu_pd(2),pos_mu_pd(1),'k*','MarkerSize',16); hold on
%                     plot(pos_bar_pd(2),pos_bar_pd(1),'m*','MarkerSize',16); hold off
%                     legend('Sensor Pos','True Target Pos','Detected Sensors','MUSIC Target Pos','BARTLETT Target Pos')
%                     title('Target position estimation using AoA only DETECTED sensors')

%                     error_AoA_all_MU_Det(indx_x,indx_y) = error_AoA_all_MU_Det(indx_x,indx_y) + sqrt((t_x-pos_mu_pd(2))^2+(t_y-pos_mu_pd(1))^2);
                    error_AoA_all_BAR_Det(indx_x,indx_y) = error_AoA_all_BAR_Det(indx_x,indx_y) + sqrt((t_x-pos_bar_pd(2))^2+(t_y-pos_bar_pd(1))^2);

                end

%                 subplot(2,1,1)
%                 title('Target position estimation using AoA ALL sensors')


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
    

% Delete the waitbars
delete(w)
delete(w2)


error_TDOA_only_LOS = error_TDOA_only_LOS./N_monte;
error_TDOA_only_LOS_Det = error_TDOA_only_LOS_Det./N_monte;

error_TDOA_only_NLOS = error_TDOA_only_NLOS./N_monte;
error_TDOA_only_NLOS_Det = error_TDOA_only_NLOS_Det./N_monte;

error_TDOA_all = error_TDOA_all./N_monte;
error_TDOA_all_Det = error_TDOA_all_Det./N_monte;


error_AoA_only_LOS_MU = error_AoA_only_LOS_MU./N_monte;
error_AoA_only_LOS_BAR = error_AoA_only_LOS_BAR./N_monte;

error_AoA_only_LOS_MU_Det = error_AoA_only_LOS_MU_Det./N_monte;
error_AoA_only_LOS_BAR_Det = error_AoA_only_LOS_BAR_Det./N_monte;

error_AoA_only_nLOS_MU = error_AoA_only_nLOS_MU./N_monte;
error_AoA_only_nLOS_BAR = error_AoA_only_nLOS_BAR./N_monte;

error_AoA_only_nLOS_MU_Det = error_AoA_only_nLOS_MU_Det./N_monte;
error_AoA_only_nLOS_BAR_Det = error_AoA_only_nLOS_BAR_Det./N_monte;

error_AoA_all_Mu = error_AoA_all_Mu./N_monte;
error_AoA_all_BAR = error_AoA_all_BAR./N_monte;

error_AoA_all_MU_Det = error_AoA_all_MU_Det./N_monte;
error_AoA_all_BAR_Det = error_AoA_all_BAR_Det./N_monte;


% Save results
filename = ['Results_LOC_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) 'SepSen_' num2str(Sep_sensors) 'SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
save(filename,'error_TDOA_only_LOS','error_TDOA_only_LOS_Det','error_TDOA_only_NLOS','error_TDOA_only_NLOS_Det','error_TDOA_all','error_TDOA_all_Det','error_AoA_only_LOS_MU','error_AoA_only_LOS_BAR',...
    'error_AoA_only_LOS_MU_Det','error_AoA_only_LOS_BAR_Det','error_AoA_only_nLOS_MU','error_AoA_only_nLOS_BAR','error_AoA_only_nLOS_MU_Det','error_AoA_only_nLOS_BAR_Det','error_AoA_all_Mu',...
    'error_AoA_all_BAR','error_AoA_all_MU_Det','error_AoA_all_BAR_Det');


% Heat maps for TDOA location

hmo200 = HeatMap(error_TDOA_only_LOS,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo200, 'Error location estimation TDOA considering all LOS sensors');

hmo201 = HeatMap(error_TDOA_only_LOS_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo201, 'Error location estimation TDOA considering only LOS sensors that Detected');

hmo202 = HeatMap(error_TDOA_only_NLOS,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo202, 'Error location estimation TDOA considering all NLOS sensors');
 
hmo203 = HeatMap(error_TDOA_only_NLOS_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo203, 'Error location estimation TDOA considering only NLOS sensors that Detected');

hmo204 = HeatMap(error_TDOA_all,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo204, 'Error location estimation TDOA considering all sensors');

hmo205 = HeatMap(error_TDOA_all_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo205, 'Error location estimation TDOA considering only sensors that Detected');



hmo206 = HeatMap(error_AoA_only_LOS_MU,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo206, 'Error location estimation AoA MU considering all LOS sensors');
hmo207 = HeatMap(error_AoA_only_LOS_BAR,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo207, 'Error location estimation AoA BAR considering all LOS sensors');

hmo208 = HeatMap(error_AoA_only_LOS_MU_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo208, 'Error location estimation AoA MU considering only LOS sensors that Detected');
hmo209 = HeatMap(error_AoA_only_LOS_BAR_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo209, 'Error location estimation AoA BAR considering only LOS sensors that Detected');

hmo210 = HeatMap(error_AoA_only_nLOS_MU,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo210, 'Error location estimation AoA MU considering all NLOS sensors');
hmo211 = HeatMap(error_AoA_only_nLOS_BAR,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo211, 'Error location estimation AoA BAR considering all NLOS sensors');
 
hmo212 = HeatMap(error_AoA_only_nLOS_MU_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo212, 'Error location estimation AoA MU considering only NLOS sensors that Detected');
hmo213 = HeatMap(error_AoA_only_nLOS_BAR_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo213, 'Error location estimation AoA BAR considering only NLOS sensors that Detected');

hmo214 = HeatMap(error_AoA_all_Mu,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo214, 'Error location estimation AoA MU considering all sensors');
hmo215 = HeatMap(error_AoA_all_BAR,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo215, 'Error location estimation AoA BAR considering all sensors');

hmo216 = HeatMap(error_AoA_all_MU_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo216, 'Error location estimation AoA MU considering only sensors that Detected');
hmo217 = HeatMap(error_AoA_all_BAR_Det,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo217, 'Error location estimation AoA BAR considering only sensors that Detected');

% fid=fopen('Results.txt','w');
% fprintf(fid,'Target True Position\n');
% fprintf(fid,'%f %f \n',[t_x,t_y]);
% fprintf(fid, 'LOS sensors \n');
% fprintf(fid,'%f %f \n',[LOS_sensor(:,1),LOS_sensor(:,2)]);
% fprintf(fid,'aoa \n');
% fprintf(fid,'%f \n',aoa);
% fprintf(fid,'Target Estimated Position\n');
% fprintf(fid,'%f %f \n',[pos(2),pos(1)]);
% fclose(fid);


% % Gradient Descend localization TOA  (Non-linear least squares)
% p_initial(1,1)=rand*Size_Scenario;
% p_initial(2,1)=rand*Size_Scenario;
% [p_exact]= GD_algorithm(p_initial,distance(p(1:3)),c,Sensors(p(1:3),:));
% figure
% plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% plot(t_x,t_y,'bo','MarkerSize',16);hold on
% plot(LOS_sensor(:,1),LOS_sensor(:,2),'g*','MarkerSize',16); hold on
% plot(p_exact(1,:),p_exact(2,:),'b+','Markersize',16); hold off
%  fid=fopen('Results_toa.txt','w');
%  fprintf(fid,'Target True Position\n');
%  fprintf(fid,'%f %f \n',[t_x,t_y]);
%  fprintf(fid,'Target Initial Position\n');
%  fprintf(fid,'%f %f \n',[p_initial(1,1),p_initial(2,1)]);
%  fprintf(fid, 'Effective LOS sensors \n');
%  fprintf(fid,'%f %f \n',[LOS_sensor(p,1),LOS_sensor(p,2)]);
%  fprintf(fid,'Target Estimated Position\n');
%  fprintf(fid,'%f %f \n',[p_exact(1,:),p_exact(2,:)]);
%  fclose(fid);





