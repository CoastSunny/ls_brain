
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
Fc = A.data(index(:));

index = find(strcmp(str, 'Type_Scenario'));    % Type of scenario. Separated or mixed enemy and friend zones
Type_Scenario = A.data(index(:));

index = find(strcmp(str, 'Type_Environment'));  % Type of environment. Urban or rural
Type_Environment = A.data(index(:));

index = find(strcmp(str, 'Size_Scenario'));     % Size of the scenario
Size_Scenario = A.data(index(:));

index = find(strcmp(str, 'Size_EZ_x')); % Size of the enemy zone (horizontal)
Size_EZ_x = A.data(index(:));

index = find(strcmp(str, 'Size_EZ_y')); % Size of the enemy zone (vertical)
Size_EZ_y = A.data(index(:));

index = find(strcmp(str, 'Size_FZ1_x')); % Size of the friend zone 1 (horizontal)
Size_FZ1_x = A.data(index(:));

index = find(strcmp(str, 'Size_FZ1_y')); % Size of the friend zone 1 (vertical)
Size_FZ1_y = A.data(index(:));

index = find(strcmp(str, 'Size_FZ2_x')); % Size of the friend zone 2 (horizontal)
Size_FZ2_x = A.data(index(:));

index = find(strcmp(str, 'Size_FZ2_y')); % Size of the friend zone 2 (vertical)
Size_FZ2_y = A.data(index(:));

index = find(strcmp(str, 'Sep_sensors'));   % Distance between sensors
Sep_sensors = A.data(index(:));

index = find(strcmp(str, 'hs'));    % Sensors height
hs = A.data(index(:));

index = find(strcmp(str, 'ht'));    % Target height
ht = A.data(index(:));


% Velocity of the sensors not used here yet


% The distance between elements in antenna array not used here yet

index = find(strcmp(str, 'NAz'));   % 3 degree sampling/resolution
NAz=A.data(index(:));

index = find(strcmp(str, 'Antenna_slant'));  % If =0, no shift on the orientation
Antenna_slant = A.data(index(:));

index = find(strcmp(str, 'Sample_Density'));    % Density of samples for Doppler effect
Sample_Density = A.data(index(:));

index = find(strcmp(str, 'Time_samples'));  % Number of time samples to obtain the CIR
Time_samples = A.data(index(:));

index = find(strcmp(str, 'Fs'));        % Desired sampling frequency
Fs = A.data(index(:));

index = find(strcmp(str, 'Int_target_x'));  % Set the distance between each change of target position
Int_target_x = A.data(index(:));

index = find(strcmp(str, 'Int_target_y'));
Int_target_y = A.data(index(:));

index = find(strcmp(str, 'N_monte'));   % Number of runs for the Montecarlo simulation
N_monte = A.data(index(:));

index = find(strcmp(str, 'sigma'));     % sigma value for the lognormal random shadowing
sigma = A.data(index(:));

index = find(strcmp(str, 'n'));     % Urban is between 2.7 and 3.5, rural is 2
n = A.data(index(:));

index = find(strcmp(str, 'd_0'));  % Outdoor is between 100m to 1km
d_0 = A.data(index(:));

index = find(strcmp(str, 'Pt'));   % Target power
Pt = A.data(index(:));

index = find(strcmp(str, 'BW'));
BW = A.data(index(:));              % Signal bandwidth in Hz. Up to 20MHz.

index = find(strcmp(str, 'NF'));
NF = A.data(index(:));               % Noise figure of the RF receiver in dB

index = find(strcmp(str, 'Tc'));
Tc = A.data(index(:));       % # of samples in the cyclic prefix (CP)

index = find(strcmp(str, 'Td'));
Td = A.data(index(:));      % Number of samples of data in the LTE trace

index = find(strcmp(str, 'AC_sample'));
AC_sample = A.data(index(:));

index = find(strcmp(str, 'Pfa'));
Pfa = A.data(index);      % Probability of false alarm

% Wavelength
lambda = c/Fc;




% Scenario and network generation

% Function that generates a matrix with the position of each sensor in
% the scenario
% The next line is commented for the calibration analysis
%[Sensors,Num_sensors] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);
% p = 3;
Num_sensors = 10;
Num_targets = 1;

p=2; % dimension p=2 or 3
nt=1; % number of targets
%for ns = 1:length(Num_sensors)
% R_z = hs*ones(Num_sensors,1);
% if Type_Scenario == 1
%     Sensors = [floor(rand(Num_sensors,p)*Size_Scenario), R_z];
%     %This is for mixed zones
%     t_x = floor(rand(nt,1)*Size_Scenario);
%     t_y = floor(rand(nt,1)*Size_Scenario);
%     t_z = ht*ones(nt,1); %rand*Size_Scenario;
%     Pos_target= [t_x t_y t_z];
% else
%     Sensors1 = [floor(rand(5,1)*2000) ,floor(rand(5,1)*(2000-1800)+1800), R_z(1:5)];
%     Sensors2 = [floor(rand(5,1)*(2000-1800)+1800) ,floor(rand(5,1)*1800), R_z(6:end)];
%     Sensors = [Sensors1;Sensors2];
%     t_x = floor(rand(nt,1)*Size_EZ_x);
%     t_y = floor(rand(nt,1)*Size_EZ_y);
%     t_z = ht*ones(nt,1);%rand*Size_EZ_z;
%     Pos_target=[t_x t_y t_z];
% end
% when we assume we know the target position this is only for simulations but in measurements we will only have TDOA information
% and sensor locations 


%save('location.mat','Pos_target','Sensors');
load('location.mat');


% Define sensor velocities. For now, all are static. The velocity of the
% sensors cannot be zero, therefore, if we want to analyse static sensors,
% we need to put very small velocities of the sensors.
Vel_sensors=ones(Num_sensors,3).*0.01;


% Antenna and Antenna Array generation for all the sensors and target

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
pattern(1,:,1,:)=dipoleWINNER(Az,Antenna_slant);

% Generation of the Antenna Arrays considering the distribution
% (uniform), number of elements, distances, radiation patterns and sampling
% angles. If no FP is defined (FP-ECS and pattern), then by default it is a
% isotropic, vertically polarized antenna with XPD=inf

% Generate an arrays. Apparently it does not provide values of the pattern,
% just information about the array
Arrays(1) =AntennaArray('ULA',1,Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-1
Arrays(2) = AntennaArray('ULA',10, Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-10



% Defining the layoutpar of the scenario
% Define the type of arrays for each sensor and target. MsAAIdx has as many
% elements as sensors and the number in it will set what array in arrays is
% set to each of the sensors. BsAAIdxCell is the same but for target (BST).
% If the target/BST has more than one sector, then {[1 1]} or {[1 1 1]} and
% so on. Also, it is possible to mix arrays for different sensors and
% target/BST i.e. MsAAIdx = [1 1 1 3 2 1 2 3 ...] and BsAAIdxCell = {[1
% 2];[1];[3 2]} and so on.
MsAAIdx = ones(1,Num_sensors);    % All sensor the same. 1 element array
%MsAAIdx = 1*MsAAIdx;
%MsAAIdx3 = 2*MsAAIdx1(end);
%MsAAIdx = [MsAAIdx2, MsAAIdx1(2:end-1), MsAAIdx3];
% B = ones(1,nt);
% Bs = cell(size(B,2),1);
% for bs = 1:nt
%     Bs{bs} = 1;
% end
BsAAIdxCell = {[1]};% target/BST also same as sensors
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





% Set of the general parameters for the scenario

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
    'UseManualPropCondition','yes');        % If 'yes' the propagation condition NLOS/LOS is set as it is in layoutpar. If 'no', then it is set following probability equations set in tables for specific scenarios. This is done in our code by ourself, but we could just write here 'no' and let the WIN function do it for us.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Localization

%localization depending on the probability of detection

% Loading of the LTE signal
Tx_vector_20M = load('Tx_20MHz');
Tx_vector_20M = Tx_vector_20M.Tx_LTE_20MHz_QPSK;
Tx_signal = Tx_vector_20M;
Vel_target = [0 0 0];

layoutpar.Stations(1).Pos = Pos_target.';
layoutpar.Stations(1).Velocity = Vel_target.';
P_t = -53:10:-13;
SNR_tot = zeros(Num_sensors,100);
SNR_avg = zeros(length(P_t),Num_sensors);
Pd = zeros(length(P_t),Num_sensors);
Det_sensors = zeros(1,Num_sensors);
err_pos_pd = inf*zeros(length(P_t),1);
err_est_pd = inf*zeros(length(P_t),1);



tic
for pt = 1:length(P_t)
    for cs = 1:100
        % Calculating distances between target and sensors
        [layoutpar,distance] = sensor_settings_update(layoutpar,Sensors,Num_sensors,Type_Environment,Pos_target(1:nt,1:p).',Vel_sensors,nt);
        
        % Generate the CIR
        [~,~,out] = wim(wimpar,layoutpar);
        
        [cir,delays,out] = wim(wimpar,layoutpar,out);
        % downsampling of channel coefficients
        cir_ds = downsampling_cir(cir,delays,Delay_interval,nt*Num_sensors,Time_samples);
        % Calculate the SNR
        SNR = SNR_calculation_update(cir_ds,distance,lambda,Type_Environment,d_0,sigma,Num_sensors,Time_samples,P_t(pt),NF,n,BW);
        SNR_tot(:,cs) = 10.^(SNR./10);
        
    end
    SNR_avg(pt,:) = sum(SNR_tot,2)/100;
    % Calculate the Pd (probability of detection)
    Pd = calculating_Prob_detection(AC_sample,Td,Tc,SNR,Pfa,Num_sensors);
    
    
    for ii =1:Num_sensors
        Det_sensors(ii) = randsrc(1,1,[0 1; (1-Pd(ii)) Pd(ii)]);
    end
    rx_times_pd = delay_calc(distance,Type_Environment,cir_ds,Num_sensors,c);
    %rx_times(:,1)
    D_meas =  (rx_times_pd(:,1).'*c).^2 ;
    norm_S = sum(Sensors(:,1:p)'.^2);
    edm_S = bsxfun(@plus, norm_S',norm_S) -2*(Sensors(:,1:p)*Sensors(:,1:p)'); % EDM for sensor nodes
    D_init = [0 D_meas; D_meas.' edm_S];
    
    
    if sum(Det_sensors) >=3
        %est_target= TDOA_localization_update(rx_times_pd(find(Det_sensors),1),Sensors(find(Det_sensors),1:p),c);
        W_pd = generate_MDU_pd(Sensors(:,1:p),Det_sensors);
        [D_pd,X_pd] = rank_complete_edm(D_init, W_pd, p, 1);
        [d1,Z,transform] = procrustes(Sensors(:,1:p),X_pd(:,2:end).');
        Z_pd  = ((transform.b * X_pd(:,1)).'* transform.T) + transform.c(1,:);
        %[d,Z_p,T] = procrustes([Pos_target(1,1:p);Sensors(:,1:p)],X_pd.');
        %err_pos_pd(pt) = sqrt((Pos_target(1,1)-Z_p(1,1))^2+(Pos_target(1,2)-Z_p(1,2))^2);%+(Pos_target(1,3)-Z_t(vd,1,3))^2);%norm((Pos_target(1,1:2)-Z_t(vd,1,:)),'fro');
        err_pos_pd(pt) = sqrt((Pos_target(1,1)-Z_pd(1,1))^2+(Pos_target(1,2)-Z_pd(1,2))^2);%+(Pos_target(1,3)-Z_t(vd,1,3))^2);%norm((Pos_target(1,1:2)-Z_t(vd,1,:)),'fro');
        %err_est_pd(pt) = sqrt((Pos_target(1,1)-est_target(1,1))^2+(Pos_target(1,2)-est_target(2,1))^2);%+(Pos_target(1,3)-Z_t(vd,1,3))^2);%norm((Pos_target(1,1:2)-Z_t(vd,1,:)),'fro');

    else
        fprintf('Not enough sensors detected the signal')
        
    end
end
figure(1)
subplot(2,1,1)
plot(P_t,prctile(err_pos_pd,90,2),'r');hold on
%plot(P_t,prctile(err_pos_p,90,2),'g');hold off
%subplot(2,1,2)
%plot(P_t,prctile(err_est_pd,90,2),'b'); hold on
%% Localization with respect to different delays
mu =-8:0.2:-7;%[-7.8, -7.6, -7.4, -7.12] ;
err_pos_est = zeros(length(mu),100);
err_pos_rank = zeros(length(mu),100);


for vd = 1:length(mu)
    for tt = 1:1:100
        [rx_times] = var_delay_calc(distance,size(cir_ds{1},3),c,mu(vd),Num_sensors);
        %[est_target]= TDOA_localization_update(rx_times(:,1),Sensors,c);
        D_meas =  (rx_times(:,1).'*c).^2;
        norm_S = sum(Sensors(:,1:p)'.^2);
        edm_S = bsxfun(@plus, norm_S',norm_S) -2*(Sensors(:,1:p)*Sensors(:,1:p)'); % EDM for sensor nodes
        D_init = [0 D_meas; D_meas.' edm_S];
        W = generate_MDU(Sensors(:,1:p),nt);
        [D_t,X_t] = rank_complete_edm(D_init, W, p, 1);
        [~,Z,trans] = procrustes(Sensors(:,1:p),X_t(:,2:end).');
        Z_t  = ((trans.b * X_t(:,1)).'* trans.T) + trans.c(1,:);
        %err_pos_est(vd,tt) =  norm((Pos_target(1,1:p)-est_target.'),'fro');
        err_pos_rank(vd,tt) = sqrt((Pos_target(1,1)-Z_t(1,1))^2+(Pos_target(1,2)-Z_t(1,2))^2);
    end
    
    
    
    
end
figure(2)
%subplot(2,1,1)
%plot(mu,prctile(err_pos_est,90,2),'r');
%subplot(2,1,2)
plot(mu,prctile(err_pos_rank,90,2),'b');





