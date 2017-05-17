%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CNA 10/10/2016
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
NF = A.data(index);               % Noise figure of the RF receiver in dB

index = find(strcmp(str, 'Tc'));
Tc = A.data(index);       % # of samples in the cyclic prefix (CP)

index = find(strcmp(str, 'Td'));
Td = A.data(index);      % Number of samples of data in the LTE trace

index = find(strcmp(str, 'AC_sample'));            
AC_sample = A.data(index);

index = find(strcmp(str, 'Pfa'));
Pfa = A.data(index);      % Probability of false alarm



% Carrier Frequency
% Fc = 2.4e9;

% Wavelength
lambda = c/Fc;


%% Scenario and network generation

% Function that generates a matrix with the position of each sensor in
% the scenario
[Sensors,Num_sensors] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);

% if Type_Scenario == 0
% 
%     % Select type of the scenario: 0 for separate zones for enemies and
%     % friends and 1 for all mixed.
%     % Type_Scenario = 0;
% 
%     % Type of environment in the scenario 0=urban, 1=rural
%     % Type_Environment = 0;
% 
% 
%     % Size of the scenario= Size_Scenario x Size_scenario (metres)
%     % Size_Scenario = 2000;
% 
%     % Size of the enemy zone = Size_EZ_x x Size_EZ_y (metres)
%     % Size_EZ_x = 200;
%     % Size_EZ_y = 200;
% 
%     % Size of the friend zone 1 = Size_FZ1_x x Size_FZ1_y (metres). This is the
%     % first of the zones. Also, the starting coordinates of the FZ1 are
%     % defined.
%     % Size_FZ1_x = 200;
%     % Size_FZ1_y = 2000;
%     Start_FZ1_x = Size_Scenario - Size_FZ1_x;
%     Start_FZ1_y = 0;
%     Area_FZ1 = Size_FZ1_x*Size_FZ1_y;
% 
%     % Size of the friend zone 2 = Size_FZ2_x x Size_FZ2_y (metres). This is the
%     % second of the zones. Also, the starting coordinates of the FZ2 are
%     % defined.
%     % Size_FZ2_x = 1800;
%     % Size_FZ2_y = 200;
%     Start_FZ2_x = 0;
%     Start_FZ2_y = Size_Scenario - Size_FZ2_y;
%     Area_FZ2 = Size_FZ2_x*Size_FZ2_y;
% 
%     % Separation between sensors in metres. There are as many sensors in the
%     % friend zones FZ1 and FZ2 as they fit.
%     % Sep_sensors = 200;
%     Num_sensors = floor((Area_FZ1+Area_FZ2)/(Sep_sensors)^2);
% 
%     % Define height of sensors and target in metres
%     % hs = 1.5;
%     % ht = 3;
% 
%     % Initialise the matrix of positions (coordinates) where the sensors are
%     % located.
%     %Pos_sensors_x = zeros(Size_Scenario/Sep_sensors);
%     %Pos_sensors_y = zeros(Size_Scenario/Sep_sensors);
%     Sensors = zeros(Num_sensors,3);
% 
% 
%     % Positioning the sensors with origin of coordinates on the left lower
%     % corner of the scenario. The data stored is the distance of the sensor to
%     % the origin of coordinates in metres.
%     indx = 0;
%     for p_x=Start_FZ1_x+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
%         for p_y=Start_FZ1_y+Sep_sensors/2:Sep_sensors:Start_FZ2_y-Sep_sensors/2
%     %         ind_pos_x = p_x/Sep_sensors + 1;
%     %         ind_pos_y = p_y/Sep_sensors + 1;
%             indx = indx + 1;
%     %         Pos_sensors_x(ind_pos_y,ind_pos_x) = p_x; 
%     %         Pos_sensors_y(ind_pos_y,ind_pos_x) = p_y; 
%             Sensors(indx,:)=[p_x;p_y;hs];
%         end
%     end
% 
%     for p_x=Start_FZ2_x+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
%         for p_y=Start_FZ2_y+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
%     %         ind_pos_x = p_x/Sep_sensors + 1;
%     %         ind_pos_y = p_y/Sep_sensors + 1;
%     %         Pos_sensors_x(ind_pos_y,ind_pos_x) = p_x; 
%     %         Pos_sensors_y(ind_pos_y,ind_pos_x) = p_y; 
%             indx = indx + 1;
%             Sensors(indx,:)=[p_x;p_y;hs];
%         end
%     end
% else
%     
%     % If type of Scenario is 1, the enemy and friend areas are mixed and
%     % cover all the scenario area
%     
%     Area_FZ = Size_Scenario*Size_Scenario;
%     
%     Num_sensors = floor(Area_FZ/(Sep_sensors)^2);
%     
%     Sensors = zeros(Num_sensors,3);
%     
%     indx = 0;
%     for p_x=0+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
%         for p_y=0+Sep_sensors/2:Sep_sensors:Size_Scenario-Sep_sensors/2
%     %         ind_pos_x = p_x/Sep_sensors + 1;
%     %         ind_pos_y = p_y/Sep_sensors + 1;
%             indx = indx + 1;
%     %         Pos_sensors_x(ind_pos_y,ind_pos_x) = p_x; 
%     %         Pos_sensors_y(ind_pos_y,ind_pos_x) = p_y; 
%             Sensors(indx,:)=[p_x;p_y;hs];
%         end
%     end
%     
% end


% Set all 0 values to NAN
% Pos_sensors_x (Pos_sensors_x==0) = nan;
% Pos_sensors_y (Pos_sensors_y==0) = nan;

% Define sensor velocities. For now, all are static. The velocity of the
% sensors cannot be zero, therefore, if we want to analyse static sensors,
% we need to put very small velocities of the sensors.
Vel_sensors=ones(Num_sensors,3).*0.01;





%% Antenna and Antenna Array generation for all the sensors and target

% From Pat's code in MainSimCode:
% Array preprocessing -- EADF approximation for antenna patterns.

% Antenna spacing for arrays
dist = (c/Fc)*0.5; %lambda/2 spacing

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

% Generation of the Antenna Arrays considering the distribution
% (uniform), number of elements, distances, radiation patterns and sampling
% angles. If no FP is defined (FP-ECS and pattern), then by default it is a
% isotropic, vertically polarized antenna with XPD=inf

% Generate an arrays. Apparently it does not provide values of the pattern,
% just information about the array
Arrays(1) = AntennaArray('ULA',1,Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-1 
%Arrays(2) = AntennaArray('ULA',2,Dists(2),'FP-ECS',pattern,'Azimuth',Az); %ULA-2 




%% Defining the layoutpar of the scenario

% Define the type of arrays for each sensor and target. MsAAIdx has as many
% elements as sensors and the number in it will set what array in arrays is
% set to each of the sensors. BsAAIdxCell is the same but for target (BST).
% If the target/BST has more than one sector, then {[1 1]} or {[1 1 1]} and
% so on. Also, it is possible to mix arrays for different sensors and
% target/BST i.e. MsAAIdx = [1 1 1 3 2 1 2 3 ...] and BsAAIdxCell = {[1
% 2];[1];[3 2]} and so on.
MsAAIdx = ones(Num_sensors,1);    % All sensor the same. 1 element array
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





%% Set of the general parameters for the scenario

% Overshampling factor (for Doppler analysis). Time_sample_interval = wavelength/sensor_velocity*sample_density in samples/half-wavelength. 
% Recommended in the WINNER-II documentation to be 64.
% Sample_Density = 64;
                                    
% Time samples per drop (4th dimension of the output CIR array) 
% Time_samples = 1;   

% Desired Sampling freuqency
% Fs = 31e6;

% Calculating the delay interval for the multipath components
Delay_interval = 1/Fs;


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
                'UseManualPropCondition','yes');        % If 'yes' the propagation condition NLOS/LOS is set as it is in layoutpar. If 'no', then it is set following probability equations set in tables for specific scenarios. This is done in our code by ourself, but we could just write here 'no' and let the WIN function do it for us.



% Int_target_x = 10;        % Set the distance between each change of target position
% Int_target_y = 10;

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

% Initialise the matrices to store the probabilities of detection and no
% detection for each position of target and run of the montecarlo sim.

% BN_Pd = zeros(N_target_pos_x,N_target_pos_y,N_monte);       % Probability of the best sensor detects
% BN_Pnd = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Probability of the best sensor no detects
% NS_Pnd = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Probability of no sensor detects
% OS_Pd = zeros(N_target_pos_x,N_target_pos_y,N_monte);       % Probability that at least one sensor detects

   
Avg_BN_Pd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_BN_Pnd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_NS_Pnd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_OS_Pd = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
% % Avg_PeBN = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
% Avg_PeALL_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
% Avg_PeALL_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation


%% Option 1
% Best_snr = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Matrix to store the best snr at each position for each Montecarlo run
% Best_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Matrix to store the BPSK BER for the best snr at each position for each Montecarlo run
% Best_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Matrix to store the QPSK BER for the best snr at each position for each Montecarlo run
% Best_BER_4AM = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Matrix to store the 4-AM BER for the best snr at each position for each Montecarlo run
% Best_BER_8AM = zeros(N_target_pos_x,N_target_pos_y,N_monte);      % Matrix to store the 8-AM BER for the best snr at each position for each Montecarlo run

%Avg_Best_snr = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_Best_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_Best_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_Best_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_Best_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average value result from the montecarlo simulation
Avg_Best_BER_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average value result from the montecarlo simulation
Avg_Best_BER_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average value result from the montecarlo simulation

%% Option 2
Avg_All_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average BPSK for option 2 Q formulas
Avg_All_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average QPSK for option 2 Q formulas
Avg_All_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average 4AM for option 2 Alouini formulas
Avg_All_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the average 8AM for option 2 Alouini formulas
% Avg_sensor_BPSK = zeros(Num_sensors,1);             % Vector to store the average BPSK for each sensor in option 2 Q formulas
% Avg_sensor_QPSK = zeros(Num_sensors,1);             % Vector to store the average QPSK for each sensor in option 2 Q formulas
% Avg_sensor_4AM = zeros(Num_sensors,1);              % Vector to store the average 4AM for each sensor in option 2 Alouini formulas
% Avg_sensor_8AM = zeros(Num_sensors,1);              % Vector to store the average 8AM for each sensor in option 2 Alouini formulas
% Pe_sensor_BPSK_LLRT = zeros(Num_sensors,1);         % Vector to store the average BPSK for each sensor in option 2 John's formulas
% Pe_sensor_4PAM_LLRT = zeros(Num_sensors,1);         % Vector to store the average BPSK for each sensor in option 2 John's formulas
% Avg_All_BER_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average BPSK for option 2 Jonh's formulas
% Avg_All_BER_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the average 4PAM for option 2 Jonh's formulas
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

Wrong_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
Wrong_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
Wrong_4AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
Wrong_8AM = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
Wrong_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors
Wrong_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the best 3 sensors


%% Option 3
ALL_snr = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);     % This matrix will store the snr values of each sensor at each target position for each Montecarlo run
% Avg_snr = zeros(N_target_pos_x,N_target_pos_y,Num_sensors);
% Diversity_BER_BPSK_LLRT = zeros(N_target_pos_x,N_target_pos_y);     % Matrix to store the BPSK for option 3 John paper
% Diversity_BER_4PAM_LLRT = zeros(N_target_pos_x,N_target_pos_y);     % Matrix to store the 4PAM for option 3 John paper
%added_snr = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total snr for option 3
Diversity_BER_BPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total BPSK for option 3 Q formulas
Diversity_BER_QPSK = zeros(N_target_pos_x,N_target_pos_y);   % Matrix to store the total QPSK for option 3 Q formulas
Diversity_BER_4AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 4AM for option 3 Alouini formulas
Diversity_BER_8AM = zeros(N_target_pos_x,N_target_pos_y);    % Matrix to store the total 8AM for option 3 Alouini formulas

% total_BPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);
% total_QPSK = zeros(N_target_pos_x,N_target_pos_y,N_monte);
% total_4AM = zeros(N_target_pos_x,N_target_pos_y,N_monte);
% total_8AM = zeros(N_target_pos_x,N_target_pos_y,N_monte);





for m=1:1:N_monte




    %% Start the run for each possible position of the target

    indx_x = 1;
    indx_y = 1;
    
    process2 = 0;
    
    waitbar(process2/T_target_pos,w2);

    for t_x=0:Int_target_x:Size_EZ_x

        for t_y=0:Int_target_y:Size_EZ_y
            % Set target position from origin of coordinates in metres. Now, the target
            % position is set, but later it needs to be changed to all possible
            % positions within the enemy area and repeat the calculations
            % Pos_target_x = 100;
            % Pos_target_y = 100;
            Pos_target = [t_x;t_y;ht];
            Vel_target = [0;0;0];

            % Changing the position coordinates randomly set in layoutpar
            % and the velocity of the target to the desired values.
            layoutpar.Stations(1).Pos = Pos_target;
            layoutpar.Stations(1).Velocity = Vel_target;

            %% Changing the random generated values in layoutpar for each sensor to the desired values and configuration
            % This has to be done here everytime we change the position of the target.
            
            [layoutpar,distance] = sensor_settings(layoutpar,Sensors,Num_sensors,Type_Environment,Pos_target,Vel_sensors);

%             distance = zeros(Num_sensors,1);
% 
%             for i=1:1:Num_sensors
%                 % Set the position of the sensor i in the structure
%                 layoutpar.Stations(i+1).Pos = [Sensors(i,1,1);Sensors(i,2,1);Sensors(i,3,1)];
% 
%                 % Set the velocity of the sensor i in the structure
%                 layoutpar.Stations(i+1).Velocity = [Vel_sensors(i,1,1);Vel_sensors(i,2,1);Vel_sensors(i,3,1)];
% 
%                 % Calculate the 2D distance between target and sensor i
%                 distance(i) = sqrt((Sensors(i,1,1)-Pos_target(1))^2+(Pos_target(2)-Sensors(i,2,1))^2);
% 
%                 % Check what environment is the scenario (Urban or rural) and then
%                 % calculate the corresponding probability of the sensor i being in NLOS
%                 % or LOS
%                 if Type_Environment == 0
%                     if distance(i)<=1
%                         PLOS = (18/1)*(1-exp(-distance(i)/63))+exp(-distance(i)/63);
%                     else
%                         PLOS = (18/distance(i))*(1-exp(-distance(i)/63))+exp(-distance(i)/63);
%                     end
%                 else
%                     PLOS = exp(-distance(i)/1000);
%                 end
% 
%                 % Variable to store temp whether the link is NLOS or LOS (NLOS=0, LOS=1)
%                 % depending on the PLOS
%                 env = randsrc(1,1,[0 1; (1-PLOS) PLOS]);
% 
%                 % Change for the specific sensor its link condition NLOS or LOS
%                 
%                 layoutpar.PropagConditionVector(i) = env;
% 
%             end


            % For test, here we can visualise the scenario evaluated
            % NTlayout(layoutpar)

            % Plot target position and sensor position
            %  figure(1)
            %  plot3(Sensors(:,1,1),Sensors(:,2,1),Sensors(:,3,1),'xr')
            %  hold on
            %  plot3(Pos_target(1),Pos_target(2),Pos_target(3),'ob')
            %  hold off
            %  title('Target position x and sensor location o')
            %  xlabel('x coordinate (metres)')
            %  ylabel('y coordinate (metres)')
            %  zlabel('z coordinate (metres)')

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

            [cir,delays,out] = wim(wimpar,layoutpar);
            
            % Due to the CIR and delays are for 100MHz (5ns=200MHz^-1), we
            % need to modify the delays in order to have a delay sampling
            % interval proportional to 31MHz (maximum sampling rate)
            % Delay_interval=1/Fs. Most of the code is originally from
            % Pat's code in WINUnpack.m
            
            cir = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples);
            
%             % Get the number of taps or multipath components obtained in
%             % the cir
%             
%             Num_taps = size(delays,2);
%             
%             % Get the value of the highest delay value obtained
%             max_delay_sample = max(max(delays));
%             
%             % Create a vector with the desired delay values (grid points)
%             delay_grid = [0:Delay_interval:max_delay_sample];
%             
%             % To add an extra delay sample if required
%             if delay_grid(end) <= max_delay_sample
%                 delay_grid = [delay_grid (delay_grid(end) + Delay_interval)];
%             end
%             
%             % Create a temporal cir matrix to store the new CIR values at
%             % the new delays as there can be more or less multipath components. Currently only one target is assumed, if more
%             % targets, we need to change the 1 for Num_targets
%             cir_temp = zeros(Num_sensors,1,length(delay_grid),Time_samples);
%             
%             for xx1 = 1:1:Num_sensors   % For each sensor
%                 for xx2 = 1:1:1         % For each target
%                     % Check if there is any NaN values in cir for this
%                     % sensor and target link. If there is we set it equal
%                     % to zero because we assume the value received was very
%                     % small
%                     cir{xx1,xx2}(isnan(cir{xx1,xx2}))=0;
%                     
%                     for xx4 = 1:1:Time_samples      % For each time sample
%                         amplitude_tmp = zeros(size(delay_grid));
%                         for xx3= 1:1:Num_taps   % For each multipath component
%                             [~, delay_ind] = min(abs(delays(xx1,xx3) - delay_grid));  [cir] = downsampling_cir(delays,Delay_interval,Num_sensors,Time_samples)  % Here we calculate the distances in time between a specific delay and the desired delay and we take the shortest
% 
%                             amplitude_tmp(delay_ind) = amplitude_tmp(delay_ind) + cir{xx1,xx2}(:,:,xx3,xx4);     % We store or add (if already a multipath component was placed here) the multipath coefficient to the new delay
%                         end
%                         cir_temp(xx1,xx2,:,xx4) = amplitude_tmp;     % The new multipath coefficients calculated for each new delay are put into the temporal cir matrix
%                     end
%                 end
%             end
%             
%             % Now the old cir is changed to the temporal cir. The resulting
%             % cir now has different delays and multipath coefficient
%             % values. The delay matrix does not need to change as long as
%             % we keep in mind that the delay_grid vector are the new delays
%             % valid for all sensors. 
%             
%             % *CAUTION: Originally, the delay matrix
%             % could have different delay values for each multipath
%             % component and for each sensor, but now, we are forcing the
%             % delays to be exactly a multiple value of Delay_interval.
%             
%            
%             for ii=1:1:Num_sensors
%                 cir{ii,1} = cir_temp(ii,:,:,:);
%             end    
            
              SNR = SNR_calculation(cir,distance,lambda,Type_Environment,d_0,sigma,Num_sensors,Time_samples,Pt,NF,n,BW);


%             % Calculate the large scale path loss for each link (because wim.m is not
%             % doing it). 
% 
%             % This option for the simplest calculation using the Friis formula
% 
%             FSL1 = 20.*log10(4.*pi.*distance./lambda);     % In dB
% 
%             % This option for a more empirical approximation for indoor and
%             % outdoor channels. It sets a determined fixed distance d_0 and
%             % then calculates the Friis formula (FSL) at d_0 + an empirical
%             % path loss (EPL)
% 
% 
% 
% %             if Type_Environment==0
% %                 n = 3;              % Urban is between 2.7 and 3.5
% %                 d_0 = 200;          % Outdoor is between 100m to 1km
% %             else
% %                 n = 2;              % This is for free space (LOS) which it is assumed for rural
% %                 d_0 = 1000;         % Outdoor is between 100m to 1km
% %             end
% 
%             FSL2 = 20.*log10(4.*pi.*d_0./lambda);     % In dB
% 
%             EPL = n.*10.*log10(distance./d_0);            % In dB
% 
%             % Total path loss
% 
%             PL1 = FSL1;
% 
%             PL2 = FSL2 + EPL;
% 
%             % Now calculate the random distributed fading by getting a random
%             % value of shadowing that follows normal disribution with mean=0
%             % and sigma (empirically obtianed, sigma can be between 6 and 12 dB).
% 
% %             sigma = 9;
% 
%             SHD = normrnd(0,sigma,[Num_sensors 1]);
%             %SHD = 0;
% 
%             % Calculate received power of the multipath components for each link at
%             % each time sample. Small scale "losses".
% 
%             % Initialise matrix CIR where the squared coefficients of the channel
%             % responser are stored. To have the same structure, CIR is just equal to
%             % cir.
%             CIR = cir;
% 
%             % Initialise the matrix where the addition of all the squared coefficients
%             % of the channel respones (taps) are added for each time sample (ii) 
%             % and sensor (i).
%             MP = zeros(Num_sensors,Time_samples);
% 
%             for i=1:1:Num_sensors 
%                 % For each link between sensor (i) and target, we calculate the module
%                 % of each tap component
%                 CIR{i,1}=abs(cir{i,1}).^2;
% 
%                 % Check if there is any NaN values in CIR
%                 CIR{i,1}(isnan(CIR{i,1}))=0;
% 
%                 % Then, for each time sample, we add all the squared coefficients
%                 % ("power ratio coefficients") (square not done because the coefficient
%                 % at the begining is 20).
%                 for ii=1:1:Time_samples
%                     MP(i,ii) = 10.*log10(sum(CIR{i,1}(:,:,:,ii)));
%                 end
%             end
% 
%             % Calculating the total power received considering free space (FSL),
%             % shadowing (SHD) and multipath propagation (MP).
%             
% %             P_target = 0.00005;     % In W
% %             P_target = -43;     % In dBW
% 
% %             Pt = 10*log10(P_target);        % In dBW. Target powers if the target is: BST=40W, WIFI 
% %                                           % user=50mW and LTE user=100mW.
% 
%             % Initizalise the matrix Pr for each sensor and time sample
%             Pr = zeros(Num_sensors,Time_samples);
% 
%             for ii=1:1:Time_samples
%                 Pr(:,ii) = Pt - PL2 - SHD + MP(:,ii);      % For each sensor and time sample calculates the received power. Here we can choose what path loss model we want by changing PL1 to PL2
%             end
% 
%             % Calculate the Noise
% 
%             Kb = 1.38064852e-23;    % Boltzmann constant in  J/K
%             T = 295;                % Temeprature in K
% %             BW = 20e6;              % Signal bandwidth in Hz. Up to 20MHz.
% %             NF = 3.5;               % Noise figure of the RF receiver in dB
% 
%             Noise = 10*log10(Kb*T*BW)+NF;    
% 
%             % Calculate the SNR
%             % Initialise the matrix SNR for each sensor and time sample
%             SNR = zeros(Num_sensors,Time_samples);
% 
%             for ii=1:1:Time_samples
%                 SNR(:,ii) = Pr(:,ii) - Noise;
%             end


            % Calculate the Pd (probability of detection)
            
            [bn_pd,bn_pnd,ns_pnd,os_pd,snr,best_snr,BN_indx,BN_indx2] = calculating_Prob_detection(AC_sample,Td,Tc,SNR,Pfa,Num_sensors);
            
%             BN_Pd(indx_x,indx_y,m) = bn_pd;
%             BN_Pnd(indx_x,indx_y,m) = bn_pnd;
%             NS_Pnd(indx_x,indx_y,m) = ns_pnd;
%             OS_Pd(indx_x,indx_y,m) = os_pd;
%             Best_snr(indx_x,indx_y,m) = best_snr;
            
                        % For option 1 Detection
            Avg_BN_Pd(indx_x,indx_y) = Avg_BN_Pd(indx_x,indx_y) + bn_pd;
            Avg_BN_Pnd(indx_x,indx_y) = Avg_BN_Pnd(indx_x,indx_y) + bn_pnd;

            % For option 2 Detecion
            Avg_NS_Pnd(indx_x,indx_y) = Avg_NS_Pnd(indx_x,indx_y) + ns_pnd;
            Avg_OS_Pd(indx_x,indx_y) = Avg_OS_Pd(indx_x,indx_y) + os_pd;
            
            

            
            
            ALL_snr(indx_x,indx_y,m,:) = snr;   % Store the resulting snr in this target position for this run. No it does not consider more than 1 time sample!


% %             Tc = 144;       % # of samples in the cyclic prefix (CP)
% %             Td = 2048;      % Number of samples of data in the LTE trace
% %             
% %             AC_sample = 6;
% 
%             M = AC_sample*(2*Td+Tc);    % Autocorrelation size
% 
%             snr = 10.^(SNR./10);
%             
%             ALL_snr(indx_x,indx_y,m,:) = snr;   % Store the resulting snr in this target position for this run. No it does not consider more than 1 time sample!
% 
%             rho = (Tc/(Td+Tc)).*(snr./(1+snr)); 
% 
% %             Pfa = 0.1;      % Probability of false alarm
% 
%             %eta = (1/sqrt(M))*erfcinv(2*Pfa);
% 
%             eta = (1/sqrt(M))*(erfc(2*Pfa))^(-1);
% 
%             Pd = (1/2).*erfc(sqrt(M).*((eta-rho)./(1-rho.^2)));
% 
% 
% 
%             % Calculating the probability of the best node (BN) to detect and not detect
%             % (with the highest SNR) (Option 1)
% 
%             [BN_SNR,BN_indx] = max(SNR);
%             [BN_SNR,BN_indx2] = max(BN_SNR);
%             
%             % Save the best snr for this target position and Montecarlo run
%             
%             Best_snr(indx_x,indx_y,m) = snr(BN_indx(BN_indx2));
% 
%             % Initialise a vector to store the probability of detection of the
%             % best sensor for each time sample
%             %bn_pd = zeros(Time_samples,1);
% 
%             % Store the Pd of the best node for each time sample
% 
%             bn_pd = Pd(BN_indx(BN_indx2),:);
% 
%             % Calculate the average probability along all the time samples for the best sensor
%             Avg_Pd = mean(bn_pd);
% 
%             BN_Pd(indx_x,indx_y,m) = Avg_Pd;
% 
%             BN_Pnd(indx_x,indx_y,m) = 1 - BN_Pd(indx_x,indx_y,m);
% 
% 
% 
%             % Calculating the probability of no sensor (NS) detects and that at least one
%             % sensor (OS) detects (Option 2)
% 
%             % Calculate the average probability along the time samples of detection for each sensor
%             Avg_Pd = zeros(Num_sensors,1);
% 
%             for i=1:1:Num_sensors
%                 Avg_Pd(i) = mean(Pd(i,:));
%             end
% 
%             NS_Pnd(indx_x,indx_y,m) = prod(1-Avg_Pd);
% 
%             OS_Pd(indx_x,indx_y,m) = 1 - NS_Pnd(indx_x,indx_y,m);
            
            %% Calculating the BER for different modulations, best snr, for the best node option 1
            
            snr_ = snr(BN_indx(BN_indx2));
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(snr_);
            
%             Best_BER_BPSK(indx_x,indx_y,m) = Pe_BPSK; 
%             Best_BER_QPSK(indx_x,indx_y,m) = Pe_QPSK;
%             Best_BER_4AM(indx_x,indx_y,m) = Pe_4AM;
%             Best_BER_8AM(indx_x,indx_y,m) = Pe_8AM;
            
                        % For option 1 BER
            Avg_Best_BER_BPSK(indx_x,indx_y) = Avg_Best_BER_BPSK(indx_x,indx_y) + Pe_BPSK;
            Avg_Best_BER_QPSK(indx_x,indx_y) = Avg_Best_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
            Avg_Best_BER_4AM(indx_x,indx_y) = Avg_Best_BER_4AM(indx_x,indx_y) + Pe_4AM;
            Avg_Best_BER_8AM(indx_x,indx_y) = Avg_Best_BER_8AM(indx_x,indx_y) + Pe_8AM;
            
%             % Calculating the BER (Proakis) for BPSK for the best snr and
%             % save it. Q(z)=(1/2)erfc(z/sqrt(2))
%             
%             Pe_BPSK = (1./2).*erfc(sqrt(2.*snr(BN_indx(BN_indx2)))./sqrt(2));
%             Best_BER_BPSK(indx_x,indx_y,m) = Pe_BPSK; 
%             
%             % Calculating the BER (Proakis) for QPSK for the best snr
%             
%             Pe_QPSK = (erfc(sqrt(2.*snr(BN_indx(BN_indx2)))./sqrt(2))).*(1-(1./4).*(erfc(sqrt(2.*snr(BN_indx(BN_indx2)))./sqrt(2))));
%             Best_BER_QPSK(indx_x,indx_y,m) = Pe_QPSK;
%             
%             % Calculating the BER (Alouini paper) for 4-PAM/QAM
%             
%             Pe_4AM = (3./8).*(erfc(sqrt(snr(BN_indx(BN_indx2))./5))) + (1./4).*(erfc(3.*sqrt(snr(BN_indx(BN_indx2))./5))) - (1./8).*(erfc(5.*sqrt(snr(BN_indx(BN_indx2))./5)));
%             Best_BER_4AM(indx_x,indx_y,m) = Pe_4AM;
%             
%             % Calculating the BER (Alouini paper) for 8-PAM/QAM
%             
%             Pe_8AM = (7./24).*(erfc(sqrt(snr(BN_indx(BN_indx2))./21))) + (1./4).*(erfc(3.*sqrt(snr(BN_indx(BN_indx2))./21))) - (1./24).*(erfc(5.*sqrt(snr(BN_indx(BN_indx2))./21))) + (1./24).*(erfc(9.*sqrt(snr(BN_indx(BN_indx2))./21))) - (1./24).*(erfc(13.*sqrt(snr(BN_indx(BN_indx2))./21)));
%             Best_BER_8AM(indx_x,indx_y,m) = Pe_8AM;
            
            
            %% Calculating the BER for different modulations, added snr for diversity, option 3
            
            % This is the summation of the snr from each sensor for diversity
            % gain
            added_snr = sum(snr);
            
            [Pe_BPSK,Pe_QPSK,Pe_4AM,Pe_8AM] = calculating_BER(added_snr);
            
            Diversity_BER_BPSK(indx_x,indx_y) = Diversity_BER_BPSK(indx_x,indx_y) + Pe_BPSK;
            Diversity_BER_QPSK(indx_x,indx_y) = Diversity_BER_QPSK(indx_x,indx_y) + Pe_QPSK;
            Diversity_BER_4AM(indx_x,indx_y) = Diversity_BER_4AM(indx_x,indx_y) + Pe_4AM;
            Diversity_BER_8AM(indx_x,indx_y) = Diversity_BER_8AM(indx_x,indx_y) + Pe_8AM;
            

            % Calculating the BER (Proakis) for BPSK for the total snr and
            % save it. Q(z)=(1/2)erfc(z/sqrt(2))

%             Pe_BPSK = (1./2).*erfc(sqrt(2.*added_snr)./sqrt(2));
%             total_BPSK(indx_x,indx_y,m) = Pe_BPSK; 
%             
%             Pe_QPSK = (erfc(sqrt(2.*added_snr)./sqrt(2))).*(1-(1./4).*(erfc(sqrt(2.*added_snr)./sqrt(2))));
%             total_QPSK(indx_x,indx_y,m) = Pe_QPSK; 
%             
%             Pe_4AM = (3./8).*(erfc(sqrt(added_snr./5))) + (1./4).*(erfc(3.*sqrt(added_snr./5))) - (1./8).*(erfc(5.*sqrt(added_snr./5)));
%             total_4AM(indx_x,indx_y,m) = Pe_4AM;
%             
%             Pe_8AM = (7./24).*(erfc(sqrt(added_snr./21))) + (1./4).*(erfc(3.*sqrt(added_snr./21))) - (1./24).*(erfc(5.*sqrt(added_snr./21))) + (1./24).*(erfc(9.*sqrt(added_snr./21))) - (1./24).*(erfc(13.*sqrt(added_snr./21)));
%             total_8AM(indx_x,indx_y,m) = Pe_8AM;
            
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
    %         s_Avg_sensor_BPSK_LLRT = sort(Pe_sensor_BPSK_LLRT);
    %         s_Avg_sensor_4PAM_LLRT = sort(Pe_sensor_4PAM_LLRT);

            % The probability of all 3 sensors decoding correctly is =
            % (1-BER1)*(1-BER2)*(1-BER3)
            All_3_correct_BPSK(indx_x,indx_y) = All_3_correct_BPSK(indx_x,indx_y) + (1-s_Avg_sensor_BPSK(end)).*(1-s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2));
            All_3_correct_QPSK(indx_x,indx_y) = All_3_correct_QPSK(indx_x,indx_y) + (1-s_Avg_sensor_QPSK(end)).*(1-s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2));
            All_3_correct_4AM(indx_x,indx_y) = All_3_correct_4AM(indx_x,indx_y) + (1-s_Avg_sensor_4AM(end)).*(1-s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2));
            All_3_correct_8AM(indx_x,indx_y) = All_3_correct_8AM(indx_x,indx_y) + (1-s_Avg_sensor_8AM(end)).*(1-s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2));
    %         All_3_correct_BPSK_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_BPSK_LLRT(end)).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2));
    %         All_3_correct_4PAM_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_4PAM_LLRT(end)).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2));

            % The probability of 1 sensor decoding wrongly is =
            % BER1*(1-BER2)*(1-BER3) + BER2*(1-BER1)*(1-BER3) + ... so on
            one_sensor_wrong_BPSK(indx_x,indx_y) = one_sensor_wrong_BPSK(indx_x,indx_y) + s_Avg_sensor_BPSK(end).*(1-s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2)) + (1-s_Avg_sensor_BPSK(end)).*(s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2)) + (1-s_Avg_sensor_BPSK(end)).*(1-s_Avg_sensor_BPSK(end-1)).*(s_Avg_sensor_BPSK(end-2));
            one_sensor_wrong_QPSK(indx_x,indx_y) = one_sensor_wrong_QPSK(indx_x,indx_y) + s_Avg_sensor_QPSK(end).*(1-s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2)) + (1-s_Avg_sensor_QPSK(end)).*(s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2)) + (1-s_Avg_sensor_QPSK(end)).*(1-s_Avg_sensor_QPSK(end-1)).*(s_Avg_sensor_QPSK(end-2));
            one_sensor_wrong_4AM(indx_x,indx_y) = one_sensor_wrong_4AM(indx_x,indx_y) + s_Avg_sensor_4AM(end).*(1-s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2)) + (1-s_Avg_sensor_4AM(end)).*(s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2)) + (1-s_Avg_sensor_4AM(end)).*(1-s_Avg_sensor_4AM(end-1)).*(s_Avg_sensor_4AM(end-2));
            one_sensor_wrong_8AM(indx_x,indx_y) = one_sensor_wrong_8AM(indx_x,indx_y) + s_Avg_sensor_8AM(end).*(1-s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2)) + (1-s_Avg_sensor_8AM(end)).*(s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2)) + (1-s_Avg_sensor_8AM(end)).*(1-s_Avg_sensor_8AM(end-1)).*(s_Avg_sensor_8AM(end-2));
    %         one_sensor_wrong_BPSK_LLRT(indx_x,indx_y) = s_Avg_sensor_BPSK_LLRT(end).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2)) + (1-s_Avg_sensor_BPSK_LLRT(end)).*(s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2)) + (1-s_Avg_sensor_BPSK_LLRT(end)).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(s_Avg_sensor_BPSK_LLRT(end-2));
    %         one_sensor_wrong_4PAM_LLRT(indx_x,indx_y) = s_Avg_sensor_4PAM_LLRT(end).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2)) + (1-s_Avg_sensor_4PAM_LLRT(end)).*(s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2)) + (1-s_Avg_sensor_4PAM_LLRT(end)).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(s_Avg_sensor_4PAM_LLRT(end-2));

            % The same proceedure for 2 sensors wrong
            two_sensor_wrong_BPSK(indx_x,indx_y) = two_sensor_wrong_BPSK(indx_x,indx_y) + (1-s_Avg_sensor_BPSK(end)).*(s_Avg_sensor_BPSK(end-1)).*(s_Avg_sensor_BPSK(end-2)) + (s_Avg_sensor_BPSK(end)).*(1-s_Avg_sensor_BPSK(end-1)).*(s_Avg_sensor_BPSK(end-2)) + (s_Avg_sensor_BPSK(end)).*(s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2));
            two_sensor_wrong_QPSK(indx_x,indx_y) = two_sensor_wrong_QPSK(indx_x,indx_y) + (1-s_Avg_sensor_QPSK(end)).*(s_Avg_sensor_QPSK(end-1)).*(s_Avg_sensor_QPSK(end-2)) + (s_Avg_sensor_QPSK(end)).*(1-s_Avg_sensor_QPSK(end-1)).*(s_Avg_sensor_QPSK(end-2)) + (s_Avg_sensor_QPSK(end)).*(s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2));
            two_sensor_wrong_4AM(indx_x,indx_y) = two_sensor_wrong_4AM(indx_x,indx_y) + (1-s_Avg_sensor_4AM(end)).*(s_Avg_sensor_4AM(end-1)).*(s_Avg_sensor_4AM(end-2)) + (s_Avg_sensor_4AM(end)).*(1-s_Avg_sensor_4AM(end-1)).*(s_Avg_sensor_4AM(end-2)) + (s_Avg_sensor_4AM(end)).*(s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2));
            two_sensor_wrong_8AM(indx_x,indx_y) = two_sensor_wrong_8AM(indx_x,indx_y) + (1-s_Avg_sensor_8AM(end)).*(s_Avg_sensor_8AM(end-1)).*(s_Avg_sensor_8AM(end-2)) + (s_Avg_sensor_8AM(end)).*(1-s_Avg_sensor_8AM(end-1)).*(s_Avg_sensor_8AM(end-2)) + (s_Avg_sensor_8AM(end)).*(s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2));
    %         two_sensor_wrong_BPSK_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_BPSK_LLRT(end)).*(s_Avg_sensor_BPSK_LLRT(end-1)).*(s_Avg_sensor_BPSK_LLRT(end-2)) + (s_Avg_sensor_BPSK_LLRT(end)).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(s_Avg_sensor_BPSK_LLRT(end-2)) + (s_Avg_sensor_BPSK_LLRT(end)).*(s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2));
    %         two_sensor_wrong_4PAM_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_4PAM_LLRT(end)).*(s_Avg_sensor_4PAM_LLRT(end-1)).*(s_Avg_sensor_4PAM_LLRT(end-2)) + (s_Avg_sensor_4PAM_LLRT(end)).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(s_Avg_sensor_4PAM_LLRT(end-2)) + (s_Avg_sensor_4PAM_LLRT(end)).*(s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2));

            % The probability of not decoding correct is
            % =(1-Pe_all_right)=1_sensor_wrong+2_sensor_wrong+3_sensor_wrong
            Wrong_BPSK(indx_x,indx_y) = Wrong_BPSK(indx_x,indx_y) + 1 - All_3_correct_BPSK(indx_x,indx_y);
            Wrong_QPSK(indx_x,indx_y) = Wrong_QPSK(indx_x,indx_y) + 1 - All_3_correct_QPSK(indx_x,indx_y);
            Wrong_4AM(indx_x,indx_y) = Wrong_4AM(indx_x,indx_y) + 1 - All_3_correct_4AM(indx_x,indx_y);
            Wrong_8AM(indx_x,indx_y) = Wrong_8AM(indx_x,indx_y) + 1 - All_3_correct_8AM(indx_x,indx_y);
    %         Wrong_BPSK_LLRT(indx_x,indx_y) = 1 - All_3_correct_BPSK_LLRT(indx_x,indx_y);
    %         Wrong_4PAM_LLRT(indx_x,indx_y) = 1 - All_3_correct_4PAM_LLRT(indx_x,indx_y);
            
            
            
            

            
            

            indx_y = indx_y + 1;
            
            process2 = process2 + 1;
    
            waitbar(process2/T_target_pos,w2);

        end

        indx_y = 1;

        indx_x = indx_x + 1;

    end
   
    process = process + 1;

    waitbar(process/N_monte,w)
    
end

% Delete the waitbars
delete(w)
delete(w2)

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

All_3_correct_BPSK = All_3_correct_BPSK./N_monte;
All_3_correct_QPSK = All_3_correct_QPSK./N_monte;
All_3_correct_4AM = All_3_correct_4AM./N_monte;
All_3_correct_8AM = All_3_correct_8AM./N_monte;

one_sensor_wrong_BPSK = one_sensor_wrong_BPSK./N_monte;
one_sensor_wrong_QPSK = one_sensor_wrong_QPSK./N_monte;
one_sensor_wrong_4AM = one_sensor_wrong_4AM./N_monte;
one_sensor_wrong_8AM = one_sensor_wrong_8AM./N_monte;

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



% indx_x = 1;
% indx_y = 1;
% 
% for t_x=0:Int_target_x:Size_EZ_x
%     for t_y=0:Int_target_y:Size_EZ_y
%         
%         %% Detecion
%         % For option 1 Detection
% %         Avg_BN_Pd(indx_x,indx_y) = mean(BN_Pd(indx_x,indx_y,:));
% %         Avg_BN_Pnd(indx_x,indx_y) = (1-Avg_BN_Pd(indx_x,indx_y));
% %         
% %         % For option 2 Detecion
% %         Avg_NS_Pnd(indx_x,indx_y) = mean(NS_Pnd(indx_x,indx_y,:));
% %         Avg_OS_Pd(indx_x,indx_y) = (1-Avg_NS_Pnd(indx_x,indx_y));
% % %         Avg_PeBN(indx_x,indx_y) = mean(PeBN(indx_x,indx_y,m));
% %         Avg_PeALL_BPSK_LLRT(indx_x,indx_y) = mean(PeALL_BPSK_LLRT(indx_x,indx_y,m));
% %         Avg_PeALL_4PAM_LLRT(indx_x,indx_y) = mean(PeALL_4PAM_LLRT(indx_x,indx_y,m));
%         
% 
% 
% 
% 
% 
% 
%         %% BER calculation
%         % For option 1 BER
%         % After the Montecarlo simulation, the best snr values for each run and
%         % target position are stored. In order to use the formulas provided in
%         % John's paper, the snr used must be the average of lots of channel
%         % realizations. Therefore, now, the average snr is calculated for each
%         % target position. In addition, there is no diversity and hence M=1 in the
%         % formula
%         
% %         Avg_Best_snr(indx_x,indx_y) = mean(Best_snr(indx_x,indx_y,:));
%         
% %         % For BPSK. Note that here, L=Inf, so BETTA becomes just snr
% %         Avg_Best_BER_BPSK_LLRT(indx_x,indx_y) = (1./2).*(1-sqrt(Avg_Best_snr(indx_x,indx_y)./(1+Avg_Best_snr(indx_x,indx_y))));
% %         
% %         % For 4PAM. Following formulas (24)(26)(29)(30) of John's paper and
% %         % considering again L=Inf and M=1 (no diversity), then the resulting Pe is
% %         
% %         Pe1_4PAM_LLRT = zeros(1,Time_samples);
% %         Pe2_4PAM_LLRT = zeros(1,Time_samples);
% %         Pe3_4PAM_LLRT = zeros(1,Time_samples);
% %         Pe4_4PAM_LLRT = zeros(1,Time_samples);
% %         Pe5_4PAM_LLRT = zeros(1,Time_samples);
% %         Pe6_4PAM_LLRT = zeros(1,Time_samples);
% %         
% %         d1 = 3*sqrt(2/5);
% %         d2 = sqrt(2/5);
% %             
% %         dmod1 = d1-2*sqrt(2/5);
% %         dmod2 = d1+2*sqrt(2/5);
% %         dmod3 = d2-2*sqrt(2/5);
% %         dmod4 = d2+2*sqrt(2/5);
% %         
% %         Pe1_4PAM_LLRT = (1./2).*(1./(1+Avg_Best_snr(indx_x,indx_y).*(abs(d1).^2)+abs(dmod1).*sqrt(((abs(d1).^2).*(Avg_Best_snr(indx_x,indx_y).^2).*(abs(dmod1).^2))+Avg_Best_snr(indx_x,indx_y))));
% %         Pe2_4PAM_LLRT = (1./2).*(1./(1+Avg_Best_snr(indx_x,indx_y).*(abs(d1).^2)+abs(dmod2).*sqrt(((abs(d1).^2).*(Avg_Best_snr(indx_x,indx_y).^2).*(abs(dmod2).^2))+Avg_Best_snr(indx_x,indx_y))));
% %         Pe3_4PAM_LLRT = (1./2).*(1./(1+Avg_Best_snr(indx_x,indx_y).*(abs(d2).^2)+abs(dmod3).*sqrt(((abs(d2).^2).*(Avg_Best_snr(indx_x,indx_y).^2).*(abs(dmod3).^2))+Avg_Best_snr(indx_x,indx_y))));
% %         Pe4_4PAM_LLRT = (1./2).*(1./(1+Avg_Best_snr(indx_x,indx_y).*(abs(d2).^2)+abs(dmod4).*sqrt(((abs(d2).^2).*(Avg_Best_snr(indx_x,indx_y).^2).*(abs(dmod4).^2))+Avg_Best_snr(indx_x,indx_y))));
% %         Pe5_4PAM_LLRT = (1./2).*(1-sqrt((Avg_Best_snr(indx_x,indx_y).*abs(d1).^2)./(1+(Avg_Best_snr(indx_x,indx_y).*abs(d1).^2))));
% %         Pe6_4PAM_LLRT = (1./2).*(1-sqrt((Avg_Best_snr(indx_x,indx_y).*abs(d2).^2)./(1+(Avg_Best_snr(indx_x,indx_y).*abs(d2).^2))));
% %         
% %         Pe4right = Pe1_4PAM_LLRT-Pe2_4PAM_LLRT;
% %         Pe3right = Pe3_4PAM_LLRT+Pe4_4PAM_LLRT;
% %         Pe_4PAM_LLRT = (1./2).*((1./2).*(Pe4right+Pe3right)+(1./2).*(Pe5_4PAM_LLRT+Pe6_4PAM_LLRT));
% %         Avg_Best_BER_4PAM_LLRT(indx_x,indx_y) = mean(Pe_4PAM_LLRT);
% %         
% %         % Likewise, the obtained Probability of errors for BPSK, QPSK,
% %         % 4/8-AM from the best snr are also average. For large enough runs
% %         % of the Montecarlo simulation, these averages and the results from
% %         % John's paper formulas should be very close
%         
% %         Avg_Best_BER_BPSK(indx_x,indx_y) = mean(Best_BER_BPSK(indx_x,indx_y,:));
% %         Avg_Best_BER_QPSK(indx_x,indx_y) = mean(Best_BER_QPSK(indx_x,indx_y,:));
% %         Avg_Best_BER_4AM(indx_x,indx_y) = mean(Best_BER_4AM(indx_x,indx_y,:));
% %         Avg_Best_BER_8AM(indx_x,indx_y) = mean(Best_BER_8AM(indx_x,indx_y,:));
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         % For option 2 BER
%         % Here, first the snr for each sensor and each Montecarlo run is
%         % used to calculate the BPSK, QPSK, 4-AM, 8-AM and 4PAM from the Q
%         % formulas, Jonh's formulas and Alouini's formulas. The results are
%         % BER that are calculated for each sensor and Montecarlo run. Then,
%         % the average for each Montecarlo run and then the average for each
%         % sensor is carried out to get final average BERs
%         
%         % Calculating the BER (Proakis) for BPSK, QPSK, 4-AM and 8-AM from
%         % Proakis and Alouini formulas for each sensor and Montecarlo run
%             
% %         Pe_BPSK = (1./2).*erfc(sqrt(2.*ALL_snr(indx_x,indx_y,:,:))./sqrt(2));
% %         Pe_QPSK = (erfc(sqrt(2.*ALL_snr(indx_x,indx_y,:,:))./sqrt(2))).*(1-(1./4).*(erfc(sqrt(2.*ALL_snr(indx_x,indx_y,:,:))./sqrt(2))));
% %         Pe_4AM = (3./8).*(erfc(sqrt(ALL_snr(indx_x,indx_y,:,:)./5))) + (1./4).*(erfc(3.*sqrt(ALL_snr(indx_x,indx_y,:,:)./5))) - (1./8).*(erfc(5.*sqrt(ALL_snr(indx_x,indx_y,:,:)./5)));
% %         Pe_8AM = (7./24).*(erfc(sqrt(ALL_snr(indx_x,indx_y,:,:)./21))) + (1./4).*(erfc(3.*sqrt(ALL_snr(indx_x,indx_y,:,:)./21))) - (1./24).*(erfc(5.*sqrt(ALL_snr(indx_x,indx_y,:,:)./21))) + (1./24).*(erfc(9.*sqrt(ALL_snr(indx_x,indx_y,:,:)./21))) - (1./24).*(erfc(13.*sqrt(ALL_snr(indx_x,indx_y,:,:)./21)));
%         
% %         % Here the average of the Pe for each sensor is obtained
% %         for i=1:1:Num_sensors
% %             Avg_sensor_BPSK(i) = mean(Pe_BPSK(:,:,:,i));
% %             Avg_sensor_QPSK(i) = mean(Pe_QPSK(:,:,:,i));
% %             Avg_sensor_4AM(i) = mean(Pe_4AM(:,:,:,i));
% %             Avg_sensor_8AM(i) = mean(Pe_8AM(:,:,:,i));
% %         end
% %         
% %         Avg_All_BER_BPSK(indx_x,indx_y) = mean(Avg_sensor_BPSK); 
% %             
% %         % Calculating the BER (Proakis) for QPSK for the best snr
% %             
% %         
% %         Avg_All_BER_QPSK(indx_x,indx_y) = mean(Avg_sensor_QPSK);
% %             
% %         % Calculating the BER (Alouini paper) for 4-PAM/QAM
% %             
% %         
% %         Avg_All_BER_4AM(indx_x,indx_y) = mean(Avg_sensor_4AM);
% %             
% %         % Calculating the BER (Alouini paper) for 8-PAM/QAM
% %             
% %         
% %         Avg_All_BER_8AM(indx_x,indx_y) = mean(Avg_sensor_8AM);
%         
%         
%         
% %         % Calculating the BPSK and 4AM BER from John's formulas for each
% %         % sensor. Notice that we need to calculate the average snr in each
% %         % sensor for the Montecarlo runs
% %         
% %         % This is the average snr for each sensor considering the
% %         % Montecarlo runs
% %         for i=1:1:Num_sensors
% %             Avg_snr(indx_x,indx_y,i) = mean(ALL_snr(indx_x,indx_y,:,i));
% %         end
% %         
% %         for i=1:1:Num_sensors
% %             % For BPSK. Note that here, L=Inf, so BETTA becomes just snr.
% %             % The BER is calculated without diversity M=1, so each BER is
% %             % for each sensor
% %             Pe_sensor_BPSK_LLRT(i) = (1./2).*(1-sqrt(Avg_snr(indx_x,indx_y,i)./(1+Avg_snr(indx_x,indx_y,i))));
% %             
% % 
% % 
% %             Pe1_4PAM_LLRT = (1./2).*(1./(1+Avg_snr(indx_x,indx_y,i).*(abs(d1).^2)+abs(dmod1).*sqrt(((abs(d1).^2).*(Avg_snr(indx_x,indx_y,i).^2).*(abs(dmod1).^2))+Avg_snr(indx_x,indx_y,i))));
% %             Pe2_4PAM_LLRT = (1./2).*(1./(1+Avg_snr(indx_x,indx_y,i).*(abs(d1).^2)+abs(dmod2).*sqrt(((abs(d1).^2).*(Avg_snr(indx_x,indx_y,i).^2).*(abs(dmod2).^2))+Avg_snr(indx_x,indx_y,i))));
% %             Pe3_4PAM_LLRT = (1./2).*(1./(1+Avg_snr(indx_x,indx_y,i).*(abs(d2).^2)+abs(dmod3).*sqrt(((abs(d2).^2).*(Avg_snr(indx_x,indx_y,i).^2).*(abs(dmod3).^2))+Avg_snr(indx_x,indx_y,i))));
% %             Pe4_4PAM_LLRT = (1./2).*(1./(1+Avg_snr(indx_x,indx_y,i).*(abs(d2).^2)+abs(dmod4).*sqrt(((abs(d2).^2).*(Avg_snr(indx_x,indx_y,i).^2).*(abs(dmod4).^2))+Avg_snr(indx_x,indx_y,i))));
% %             Pe5_4PAM_LLRT = (1./2).*(1-sqrt((Avg_snr(indx_x,indx_y,i).*abs(d1).^2)./(1+(Avg_snr(indx_x,indx_y,i).*abs(d1).^2))));
% %             Pe6_4PAM_LLRT = (1./2).*(1-sqrt((Avg_snr(indx_x,indx_y,i).*abs(d2).^2)./(1+(Avg_snr(indx_x,indx_y,i).*abs(d2).^2))));
% % 
% %             Pe4right = Pe1_4PAM_LLRT-Pe2_4PAM_LLRT;
% %             Pe3right = Pe3_4PAM_LLRT+Pe4_4PAM_LLRT;
% %             Pe_4PAM_LLRT = (1./2).*((1./2).*(Pe4right+Pe3right)+(1./2).*(Pe5_4PAM_LLRT+Pe6_4PAM_LLRT));
% %             Pe_sensor_4PAM_LLRT(i) = Pe_4PAM_LLRT;
% %         end
% %         
% %         % Then, the total average BER is the average BER obtained for each sensor
% %         % (no gain from diversity)
% %         Avg_All_BER_BPSK_LLRT(indx_x,indx_y) = mean(Pe_sensor_BPSK_LLRT);
% %         Avg_All_BER_4PAM_LLRT(indx_x,indx_y) = mean(Pe_sensor_4PAM_LLRT);
%         
%         
%         
%         % Now, from the calculated BERs, we choose the best 3 (from the
%         % best 3 nodes), then calculate the probability of these 3 sensors
%         % to decode right, 1 sensor wrong, 2 sensors wrong and all
%         % wrong
%         
% %         % sort from smallest to the higest the BER obtained
% %         s_Avg_sensor_BPSK = sort(Avg_sensor_BPSK);
% %         s_Avg_sensor_QPSK = sort(Avg_sensor_QPSK);
% %         s_Avg_sensor_4AM = sort(Avg_sensor_4AM);
% %         s_Avg_sensor_8AM = sort(Avg_sensor_8AM);
% % %         s_Avg_sensor_BPSK_LLRT = sort(Pe_sensor_BPSK_LLRT);
% % %         s_Avg_sensor_4PAM_LLRT = sort(Pe_sensor_4PAM_LLRT);
% %         
% %         % The probability of all 3 sensors decoding correctly is =
% %         % (1-BER1)*(1-BER2)*(1-BER3)
% %         All_3_correct_BPSK(indx_x,indx_y) = (1-s_Avg_sensor_BPSK(end)).*(1-s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2));
% %         All_3_correct_QPSK(indx_x,indx_y) = (1-s_Avg_sensor_QPSK(end)).*(1-s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2));
% %         All_3_correct_4AM(indx_x,indx_y) = (1-s_Avg_sensor_4AM(end)).*(1-s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2));
% %         All_3_correct_8AM(indx_x,indx_y) = (1-s_Avg_sensor_8AM(end)).*(1-s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2));
% % %         All_3_correct_BPSK_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_BPSK_LLRT(end)).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2));
% % %         All_3_correct_4PAM_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_4PAM_LLRT(end)).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2));
% %         
% %         % The probability of 1 sensor decoding wrongly is =
% %         % BER1*(1-BER2)*(1-BER3) + BER2*(1-BER1)*(1-BER3) + ... so on
% %         one_sensor_wrong_BPSK(indx_x,indx_y) = s_Avg_sensor_BPSK(end).*(1-s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2)) + (1-s_Avg_sensor_BPSK(end)).*(s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2)) + (1-s_Avg_sensor_BPSK(end)).*(1-s_Avg_sensor_BPSK(end-1)).*(s_Avg_sensor_BPSK(end-2));
% %         one_sensor_wrong_QPSK(indx_x,indx_y) = s_Avg_sensor_QPSK(end).*(1-s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2)) + (1-s_Avg_sensor_QPSK(end)).*(s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2)) + (1-s_Avg_sensor_QPSK(end)).*(1-s_Avg_sensor_QPSK(end-1)).*(s_Avg_sensor_QPSK(end-2));
% %         one_sensor_wrong_4AM(indx_x,indx_y) = s_Avg_sensor_4AM(end).*(1-s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2)) + (1-s_Avg_sensor_4AM(end)).*(s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2)) + (1-s_Avg_sensor_4AM(end)).*(1-s_Avg_sensor_4AM(end-1)).*(s_Avg_sensor_4AM(end-2));
% %         one_sensor_wrong_8AM(indx_x,indx_y) = s_Avg_sensor_8AM(end).*(1-s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2)) + (1-s_Avg_sensor_8AM(end)).*(s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2)) + (1-s_Avg_sensor_8AM(end)).*(1-s_Avg_sensor_8AM(end-1)).*(s_Avg_sensor_8AM(end-2));
% % %         one_sensor_wrong_BPSK_LLRT(indx_x,indx_y) = s_Avg_sensor_BPSK_LLRT(end).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2)) + (1-s_Avg_sensor_BPSK_LLRT(end)).*(s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2)) + (1-s_Avg_sensor_BPSK_LLRT(end)).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(s_Avg_sensor_BPSK_LLRT(end-2));
% % %         one_sensor_wrong_4PAM_LLRT(indx_x,indx_y) = s_Avg_sensor_4PAM_LLRT(end).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2)) + (1-s_Avg_sensor_4PAM_LLRT(end)).*(s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2)) + (1-s_Avg_sensor_4PAM_LLRT(end)).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(s_Avg_sensor_4PAM_LLRT(end-2));
% % 
% %         % The same proceedure for 2 sensors wrong
% %         two_sensor_wrong_BPSK(indx_x,indx_y) = (1-s_Avg_sensor_BPSK(end)).*(s_Avg_sensor_BPSK(end-1)).*(s_Avg_sensor_BPSK(end-2)) + (s_Avg_sensor_BPSK(end)).*(1-s_Avg_sensor_BPSK(end-1)).*(s_Avg_sensor_BPSK(end-2)) + (s_Avg_sensor_BPSK(end)).*(s_Avg_sensor_BPSK(end-1)).*(1-s_Avg_sensor_BPSK(end-2));
% %         two_sensor_wrong_QPSK(indx_x,indx_y) = (1-s_Avg_sensor_QPSK(end)).*(s_Avg_sensor_QPSK(end-1)).*(s_Avg_sensor_QPSK(end-2)) + (s_Avg_sensor_QPSK(end)).*(1-s_Avg_sensor_QPSK(end-1)).*(s_Avg_sensor_QPSK(end-2)) + (s_Avg_sensor_QPSK(end)).*(s_Avg_sensor_QPSK(end-1)).*(1-s_Avg_sensor_QPSK(end-2));
% %         two_sensor_wrong_4AM(indx_x,indx_y) = (1-s_Avg_sensor_4AM(end)).*(s_Avg_sensor_4AM(end-1)).*(s_Avg_sensor_4AM(end-2)) + (s_Avg_sensor_4AM(end)).*(1-s_Avg_sensor_4AM(end-1)).*(s_Avg_sensor_4AM(end-2)) + (s_Avg_sensor_4AM(end)).*(s_Avg_sensor_4AM(end-1)).*(1-s_Avg_sensor_4AM(end-2));
% %         two_sensor_wrong_8AM(indx_x,indx_y) = (1-s_Avg_sensor_8AM(end)).*(s_Avg_sensor_8AM(end-1)).*(s_Avg_sensor_8AM(end-2)) + (s_Avg_sensor_8AM(end)).*(1-s_Avg_sensor_8AM(end-1)).*(s_Avg_sensor_8AM(end-2)) + (s_Avg_sensor_8AM(end)).*(s_Avg_sensor_8AM(end-1)).*(1-s_Avg_sensor_8AM(end-2));
% % %         two_sensor_wrong_BPSK_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_BPSK_LLRT(end)).*(s_Avg_sensor_BPSK_LLRT(end-1)).*(s_Avg_sensor_BPSK_LLRT(end-2)) + (s_Avg_sensor_BPSK_LLRT(end)).*(1-s_Avg_sensor_BPSK_LLRT(end-1)).*(s_Avg_sensor_BPSK_LLRT(end-2)) + (s_Avg_sensor_BPSK_LLRT(end)).*(s_Avg_sensor_BPSK_LLRT(end-1)).*(1-s_Avg_sensor_BPSK_LLRT(end-2));
% % %         two_sensor_wrong_4PAM_LLRT(indx_x,indx_y) = (1-s_Avg_sensor_4PAM_LLRT(end)).*(s_Avg_sensor_4PAM_LLRT(end-1)).*(s_Avg_sensor_4PAM_LLRT(end-2)) + (s_Avg_sensor_4PAM_LLRT(end)).*(1-s_Avg_sensor_4PAM_LLRT(end-1)).*(s_Avg_sensor_4PAM_LLRT(end-2)) + (s_Avg_sensor_4PAM_LLRT(end)).*(s_Avg_sensor_4PAM_LLRT(end-1)).*(1-s_Avg_sensor_4PAM_LLRT(end-2));
% %          
% %         % The probability of not decoding correct is
% %         % =(1-Pe_all_right)=1_sensor_wrong+2_sensor_wrong+3_sensor_wrong
% %         Wrong_BPSK(indx_x,indx_y) = 1 - All_3_correct_BPSK(indx_x,indx_y);
% %         Wrong_QPSK(indx_x,indx_y) = 1 - All_3_correct_QPSK(indx_x,indx_y);
% %         Wrong_4AM(indx_x,indx_y) = 1 - All_3_correct_4AM(indx_x,indx_y);
% %         Wrong_8AM(indx_x,indx_y) = 1 - All_3_correct_8AM(indx_x,indx_y);
% % %         Wrong_BPSK_LLRT(indx_x,indx_y) = 1 - All_3_correct_BPSK_LLRT(indx_x,indx_y);
% % %         Wrong_4PAM_LLRT(indx_x,indx_y) = 1 - All_3_correct_4PAM_LLRT(indx_x,indx_y);
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         % For option 3 BER
%         % Here, the matrix containing the snr of each sensor at each target
%         % position and for each Montecarlo run is used to calculate the BER
%         % for BPSK, QPSK, 4-AM, 8-AM and 4PAM using Q formulas, from John's paper and from Alouini paper. The used snr
%         % is the average snr of all the Montecarlo runs. Now, there is
%         % diversity so M=Number of sensors
%         
% %         % This is the summation of the snr from each sensor for diversity
% %         % gain
% %         added_snr(indx_x,indx_y) = sum(Avg_snr(indx_x,indx_y,:));
% %         
% %         % Calculating the BER (Proakis) for BPSK for the total snr and
% %         % save it. Q(z)=(1/2)erfc(z/sqrt(2))
% %             
% %         Pe_BPSK = (1./2).*erfc(sqrt(2.*added_snr(indx_x,indx_y))./sqrt(2));
% %         total_BPSK(indx_x,indx_y) = Pe_BPSK; 
% %             
% %         % Calculating the BER (Proakis) for QPSK for the best snr
% %             
% %         Pe_QPSK = (erfc(sqrt(2.*added_snr(indx_x,indx_y))./sqrt(2))).*(1-(1./4).*(erfc(sqrt(2.*added_snr(indx_x,indx_y))./sqrt(2))));
% %         total_QPSK(indx_x,indx_y) = Pe_QPSK;
% %             
% %         % Calculating the BER (Alouini paper) for 4-PAM/QAM
% %             
% %         Pe_4AM = (3./8).*(erfc(sqrt(added_snr(indx_x,indx_y)./5))) + (1./4).*(erfc(3.*sqrt(added_snr(indx_x,indx_y)./5))) - (1./8).*(erfc(5.*sqrt(added_snr(indx_x,indx_y)./5)));
% %         total_4AM(indx_x,indx_y) = Pe_4AM;
% %             
% %         % Calculating the BER (Alouini paper) for 8-PAM/QAM
% %             
% %         Pe_8AM = (7./24).*(erfc(sqrt(added_snr(indx_x,indx_y)./21))) + (1./4).*(erfc(3.*sqrt(added_snr(indx_x,indx_y)./21))) - (1./24).*(erfc(5.*sqrt(added_snr(indx_x,indx_y)./21))) + (1./24).*(erfc(9.*sqrt(added_snr(indx_x,indx_y)./21))) - (1./24).*(erfc(13.*sqrt(added_snr(indx_x,indx_y)./21)));
% %         total_8AM(indx_x,indx_y) = Pe_8AM;
% 
% %         % The final BER for the BPSK case with diversity gain is the
% %         % average of the BPSK BER calculated at each montecarlo run. This
% %         % should be similar to John's formulas
% %         Diversity_BER_BPSK(indx_x,indx_y) = mean(total_BPSK(indx_x,indx_y,:));
% %         Diversity_BER_QPSK(indx_x,indx_y) = mean(total_QPSK(indx_x,indx_y,:));
% %         Diversity_BER_4AM(indx_x,indx_y) = mean(total_4AM(indx_x,indx_y,:));
% %         Diversity_BER_8AM(indx_x,indx_y) = mean(total_8AM(indx_x,indx_y,:));
%         
%         
%             
%         
%         
% %         Pe_BPSK = 0;
% %         Pe1_4PAM_LLRT = 0;
% %         Pe2_4PAM_LLRT = 0;
% %         Pe3_4PAM_LLRT = 0;
% %         Pe4_4PAM_LLRT = 0;
% %         Pe5_4PAM_LLRT = 0;
% %         Pe6_4PAM_LLRT = 0;
% % 
% %         for i=1:1:Num_sensors
% %             Fm_BPSK_LLRT = 1;
% %             Fm1_4PAM_LLRT = 1;
% %             Fm2_4PAM_LLRT = 1;
% %             Fm3_4PAM_LLRT = 1;
% %             Fm4_4PAM_LLRT = 1;
% %             Fm5_4PAM_LLRT = 1;
% %             Fm6_4PAM_LLRT = 1;
% %             for k=1:1:Num_sensors
% %                     if k~=i
% %                         Fm_BPSK_LLRT = Fm_BPSK_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                         
% %                         % For 4PAM, Fm is the same. Fm is independent on d
% %                         % and dmod
% %                         
% %                         Fm1_4PAM_LLRT = Fm1_4PAM_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                         Fm2_4PAM_LLRT = Fm2_4PAM_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                         Fm3_4PAM_LLRT = Fm3_4PAM_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                         Fm4_4PAM_LLRT = Fm4_4PAM_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                         Fm5_4PAM_LLRT = Fm5_4PAM_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                         Fm6_4PAM_LLRT = Fm6_4PAM_LLRT.*(Avg_snr(indx_x,indx_y,i))./(Avg_snr(indx_x,indx_y,i)-Avg_snr(indx_x,indx_y,k));
% %                          
% %                     end
% %             end
% %             
% %             % For BPSK
% %             Pe_BPSK = Pe_BPSK + (Fm_BPSK_LLRT./2).*(1-sqrt(Avg_snr(indx_x,indx_y,i)./(1+Avg_snr(indx_x,indx_y,i))));
% %             
% %             Pe1_4PAM_LLRT = Pe1_4PAM_LLRT + (Fm1_4PAM_LLRT./2).*(1./(1+Avg_snr(indx_x,indx_y).*(abs(d1).^2)+abs(dmod1).*sqrt(((abs(d1).^2).*(Avg_snr(indx_x,indx_y).^2).*(abs(dmod1).^2))+Avg_snr(indx_x,indx_y))));
% %             Pe2_4PAM_LLRT = Pe2_4PAM_LLRT + (Fm2_4PAM_LLRT./2).*(1./(1+Avg_snr(indx_x,indx_y).*(abs(d1).^2)+abs(dmod2).*sqrt(((abs(d1).^2).*(Avg_snr(indx_x,indx_y).^2).*(abs(dmod2).^2))+Avg_snr(indx_x,indx_y))));
% %             Pe3_4PAM_LLRT = Pe3_4PAM_LLRT + (Fm3_4PAM_LLRT./2).*(1./(1+Avg_snr(indx_x,indx_y).*(abs(d2).^2)+abs(dmod3).*sqrt(((abs(d2).^2).*(Avg_snr(indx_x,indx_y).^2).*(abs(dmod3).^2))+Avg_snr(indx_x,indx_y))));
% %             Pe4_4PAM_LLRT = Pe4_4PAM_LLRT + (Fm4_4PAM_LLRT./2).*(1./(1+Avg_snr(indx_x,indx_y).*(abs(d2).^2)+abs(dmod4).*sqrt(((abs(d2).^2).*(Avg_snr(indx_x,indx_y).^2).*(abs(dmod4).^2))+Avg_snr(indx_x,indx_y))));
% %             Pe5_4PAM_LLRT = Pe5_4PAM_LLRT + (Fm5_4PAM_LLRT./2).*(1-sqrt((Avg_snr(indx_x,indx_y).*abs(d1).^2)./(1+(Avg_snr(indx_x,indx_y).*abs(d1).^2))));
% %             Pe6_4PAM_LLRT = Pe6_4PAM_LLRT + (Fm6_4PAM_LLRT./2).*(1-sqrt((Avg_snr(indx_x,indx_y).*abs(d2).^2)./(1+(Avg_snr(indx_x,indx_y).*abs(d2).^2))));
% %             
% % 
% %             
% %         end
% %         
% %         Diversity_BER_BPSK_LLRT(indx_x,indx_y) = Pe_BPSK;
% %         
% %         Pe4right = Pe1_4PAM_LLRT-Pe2_4PAM_LLRT;
% %         Pe3right = Pe3_4PAM_LLRT+Pe4_4PAM_LLRT;
% %         Pe_4PAM_LLRT = (1./2).*((1./2).*(Pe4right+Pe3right)+(1./2).*(Pe5_4PAM_LLRT+Pe6_4PAM_LLRT));
% %         Diversity_BER_4PAM_LLRT(indx_x,indx_y) = Pe_4PAM_LLRT;
%         
%         indx_y = indx_y + 1;
%     end
%     indx_y = 1;
%     indx_x = indx_x + 1;
% end

    
%Saving the results into a MATLAB file (could be changed to a TXT files
% filename = ['Results_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
% save(filename,'Avg_BN_Pd','Avg_BN_Pnd','Avg_NS_Pnd','Avg_OS_Pd','Avg_Best_BER_BPSK','Avg_Best_BER_QPSK','Avg_Best_BER_4AM','Avg_Best_BER_8AM','Avg_Best_BER_BPSK_LLRT','Avg_Best_BER_4PAM_LLRT',...
%     'Avg_All_BER_BPSK','Avg_All_BER_QPSK','Avg_All_BER_4AM','Avg_All_BER_8AM','Avg_All_BER_BPSK_LLRT','Avg_All_BER_4PAM_LLRT','Diversity_BER_BPSK_LLRT','Diversity_BER_4PAM_LLRT','Diversity_BER_BPSK','Diversity_BER_QPSK','Diversity_BER_4AM',...
%     'Diversity_BER_8AM','All_3_correct_BPSK','All_3_correct_QPSK',...
%     'All_3_correct_4AM','All_3_correct_8AM','All_3_correct_BPSK_LLRT','All_3_correct_4PAM_LLRT','one_sensor_wrong_BPSK','one_sensor_wrong_QPSK','one_sensor_wrong_4AM','one_sensor_wrong_8AM','one_sensor_wrong_BPSK_LLRT',...
%     'one_sensor_wrong_4PAM_LLRT','two_sensor_wrong_BPSK','two_sensor_wrong_QPSK','two_sensor_wrong_4AM','two_sensor_wrong_8AM','two_sensor_wrong_BPSK_LLRT',...
%     'two_sensor_wrong_4PAM_LLRT','Wrong_BPSK','Wrong_QPSK','Wrong_4AM','Wrong_8AM','Wrong_BPSK_LLRT','Wrong_4PAM_LLRT');

filename = ['Results_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
save(filename,'Avg_BN_Pd','Avg_BN_Pnd','Avg_NS_Pnd','Avg_OS_Pd','Avg_Best_BER_BPSK','Avg_Best_BER_QPSK','Avg_Best_BER_4AM','Avg_Best_BER_8AM',...
    'Avg_All_BER_BPSK','Avg_All_BER_QPSK','Avg_All_BER_4AM','Avg_All_BER_8AM','Diversity_BER_BPSK','Diversity_BER_QPSK','Diversity_BER_4AM',...
    'Diversity_BER_8AM','All_3_correct_BPSK','All_3_correct_QPSK',...
    'All_3_correct_4AM','All_3_correct_8AM','one_sensor_wrong_BPSK','one_sensor_wrong_QPSK','one_sensor_wrong_4AM','one_sensor_wrong_8AM',...
    'two_sensor_wrong_BPSK','two_sensor_wrong_QPSK','two_sensor_wrong_4AM','two_sensor_wrong_8AM',...
    'Wrong_BPSK','Wrong_QPSK','Wrong_4AM','Wrong_8AM');

%% Plot heat maps for detection

% Heat map option 1 detection
hmo1 = HeatMap(Avg_BN_Pd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo1, 'Probability of being detected by the best sensor');

% % Heat map option 1 no detection
hmo2 = HeatMap(Avg_BN_Pnd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo2, 'Probability of not being detected by the best sensor');

% Heat map option 2 no detection
hmo3 = HeatMap(Avg_NS_Pnd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo3, 'Probability of not being detected by any sensor');

% Heat map option 2 detection
hmo4 = HeatMap(Avg_OS_Pd,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo4, 'Probability of being detected by at least one sensor');


%% Plot the heat maps for BER


%% Option 1
% % % Heat map option 1 BER
% % hmo5 = HeatMap(Avg_PeBN,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% % addTitle(hmo5, 'BER of the best sensor / BPSK / LLRT');
% 
% % Heat map option 2 BER
% hmo6 = HeatMap(Avg_PeALL_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo6, 'BER when all sensors are contributing / BPSK / LLRT');
% 
% % Heat map option 2 BER
% hmo7 = HeatMap(Avg_PeALL_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo7, 'BER when all sensors are contributing / 4PAM / LLRT');

% Heat map option 1 BER BPSK (Proakis)
hmo5 = HeatMap(Avg_Best_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo5, 'BER of the best sensor BPSK option 1 Q formulas');

% % Heat map option 1 BER BPSK (John)
% hmo6 = HeatMap(Avg_Best_BER_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo6, 'BER of the best sensor BPSK option 1 John paper');

% % Heat map option 1 BER QPSK (Proakis)
% hmo8 = HeatMap(Avg_Best_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo8, 'BER of the best sensor QPSK option 1 Q formulas');

% Heat map option 1 BER 4-AM (Alouini)
hmo9 = HeatMap(Avg_Best_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo9, 'BER of the best sensor 4-AM option 1 Alouini paper');

% % Heat map option 1 BER 4-AM (John)
% hmo10 = HeatMap(Avg_Best_BER_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo10, 'BER of the best sensor 4PAM option 1 John paper');

% % Heat map option 1 BER 8-AM (Alouini)
% hmo11 = HeatMap(Avg_Best_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo11, 'BER of the best sensor 8-AM option 1 Alouini paper');




%% Option 3
% % Heat map option 3 BER BPSK (John)
% hmo12 = HeatMap(Diversity_BER_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo12, 'BER BPSK all sensors (diversity) option 3 John paper');

% % Heat map option 3 BER 4PAM (John)
% hmo12 = HeatMap(Diversity_BER_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo12, 'BER 4PAM all sensors (diversity) option 3 John paper');

% Heat map option 3 BER BPSK  (Proakis)
hmo13 = HeatMap(Diversity_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo13, 'BER BPSK all sensors (diversity) option 3 Q formulas');

% % Heat map option 3 BER QPSK  (Proakis)
% hmo14 = HeatMap(total_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo14, 'BER BPSK all sensors (diversity) option 3 Q formulas');

% Heat map option 3 BER 4-AM  (Alouini)
hmo15 = HeatMap(Diversity_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo15, 'BER BPSK all sensors (diversity) option 3 Q formulas');

% % Heat map option 3 BER 8-AM  (Alouini)
% hmo15 = HeatMap(Diversity_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo15, 'BER BPSK all sensors (diversity) option 3 Q formulas');




%% Option 2
% Heat map option 2 BER BPSK (Proakis)
hmo16 = HeatMap(Avg_All_BER_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo16, 'BER of all sensors (average) BPSK option 2 Q formulas');

% Heat map option 2 BER QPSK (Proakis)
hmo17 = HeatMap(Avg_All_BER_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo17, 'BER of all sensors (average) QPSK option 2 Q formulas');

% Heat map option 2 BER 4-AM (Alouini)
hmo18 = HeatMap(Avg_All_BER_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo18, 'BER of all sensors (average) 4-AM option 2 Alouini formulas');

% Heat map option 2 BER 8-AM (Alouini)
hmo19 = HeatMap(Avg_All_BER_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo19, 'BER of all sensors (average) 8-AM option 2 Alouini formulas');

% % Heat map option 2 BER BPSK (John)
% hmo20 = HeatMap(Avg_All_BER_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo20, 'BER of all sensors (average) BPSK option 2 John formulas');
% 
% % Heat map option 2 BER 4PAM (John)
% hmo21 = HeatMap(Avg_All_BER_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo21, 'BER of all sensors (average) 4PAM option 2 John formulas');




% Heat map option 2 Logic combinations Best 3: ALL correct (John)
hmo22 = HeatMap(All_3_correct_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo22, 'Option 2 best 3: Probability of all sensors receive right BPSK Q formulas');

% % Heat map option 2 Logic combinations Best 3: ALL correct (John)
% hmo23 = HeatMap(All_3_correct_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo23, 'Option 2 best 3: Probability of all sensors receive right BPSK John paper');

% Heat map option 2 Logic combinations Best 3: ALL correct (John)
hmo24 = HeatMap(All_3_correct_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo24, 'Option 2 best 3: Probability of all sensors receive right QPSK Q formulas');

% Heat map option 2 Logic combinations Best 3: ALL correct (John)
hmo25 = HeatMap(All_3_correct_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo25, 'Option 2 best 3: Probability of all sensors receive right 4-AM Q formulas');

% % Heat map option 2 Logic combinations Best 3: ALL correct (John)
% hmo26 = HeatMap(All_3_correct_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo26, 'Option 2 best 3: Probability of all sensors receive right 4PAM John paper');

% Heat map option 2 Logic combinations Best 3: ALL correct (John)
hmo27 = HeatMap(All_3_correct_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo27, 'Option 2 best 3: Probability of all sensors receive right 8-AM Q formulas');



% Heat map option 2 Logic combinations Best 3: One wrong (John)
hmo28 = HeatMap(one_sensor_wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo28, 'Option 2 best 3: Probability of one sensor receive wrong BPSK');

% % Heat map option 2 Logic combinations Best 3: One wrong (John)
% hmo29 = HeatMap(one_sensor_wrong_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo29, 'Option 2 best 3: Probability of one sensor receive wrong BPSK John paper');

% Heat map option 2 Logic combinations Best 3: One wrong (John)
hmo30 = HeatMap(one_sensor_wrong_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo30, 'Option 2 best 3: Probability of one sensor receive wrong QPSK Q formulas');

% Heat map option 2 Logic combinations Best 3: One wrong (John)
hmo31 = HeatMap(one_sensor_wrong_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo31, 'Option 2 best 3: Probability of one sensor receive wrong 4-AM Q formulas');

% % Heat map option 2 Logic combinations Best 3: One wrong (John)
% hmo32 = HeatMap(one_sensor_wrong_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo32, 'Option 2 best 3: Probability of one sensor receive wrong 4PAM John paper');

% Heat map option 2 Logic combinations Best 3: One wrong (John)
hmo33 = HeatMap(one_sensor_wrong_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo33, 'Option 2 best 3: Probability of one sensor receive wrong 8-AM Q formulas');



% Heat map option 2 Logic combinations Best 3: Two wrong (John)
hmo34 = HeatMap(two_sensor_wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo34, 'Option 2 best 3: Probability of two sensor receive wrong BPSK');

% % Heat map option 2 Logic combinations Best 3: Two wrong (John)
% hmo35 = HeatMap(two_sensor_wrong_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo35, 'Option 2 best 3: Probability of two sensor receive wrong BPSK John paper');

% Heat map option 2 Logic combinations Best 3: Two wrong (John)
hmo36 = HeatMap(two_sensor_wrong_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo36, 'Option 2 best 3: Probability of two sensor receive wrong QPSK Q formulas');

% Heat map option 2 Logic combinations Best 3: Two wrong (John)
hmo37 = HeatMap(two_sensor_wrong_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo37, 'Option 2 best 3: Probability of two sensor receive wrong 4-AM Q formulas');

% % Heat map option 2 Logic combinations Best 3: Two wrong (John)
% hmo38 = HeatMap(two_sensor_wrong_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo38, 'Option 2 best 3: Probability of two sensor receive wrong 4PAM John paper');

% Heat map option 2 Logic combinations Best 3: Two wrong (John)
hmo39 = HeatMap(two_sensor_wrong_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo39, 'Option 2 best 3: Probability of two sensor receive wrong 8-AM Q formulas');




% Heat map option 2 Logic combinations Best 3: all wrong (John)
hmo40 = HeatMap(Wrong_BPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo40, 'Option 2 best 3: Probability of all sensor receive wrong BPSK');

% % Heat map option 2 Logic combinations Best 3: all wrong (John)
% hmo41 = HeatMap(Wrong_BPSK_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo41, 'Option 2 best 3: Probability of all sensor receive wrong BPSK John paper');

% Heat map option 2 Logic combinations Best 3: all wrong (John)
hmo42 = HeatMap(Wrong_QPSK,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo42, 'Option 2 best 3: Probability of all sensor receive wrong QPSK Q formulas');

% Heat map option 2 Logic combinations Best 3: all wrong (John)
hmo43 = HeatMap(Wrong_4AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo43, 'Option 2 best 3: Probability of all sensor receive wrong 4-AM Q formulas');

% % Heat map option 2 Logic combinations Best 3: all wrong (John)
% hmo44 = HeatMap(Wrong_4PAM_LLRT,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
% addTitle(hmo44, 'Option 2 best 3: Probability of all sensor receive wrong 4PAM John paper');

% Heat map option 2 Logic combinations Best 3: all wrong (John)
hmo45 = HeatMap(Wrong_8AM,'RowLabels',0:Int_target_x:Size_EZ_x,'ColumnLabels',0:Int_target_y:Size_EZ_y,'Symmetric',false);
addTitle(hmo45, 'Option 2 best 3: Probability of all sensor receive wrong 8-AM Q formulas');






