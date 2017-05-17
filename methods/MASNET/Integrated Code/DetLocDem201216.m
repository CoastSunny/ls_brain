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




%% Scenario and network generation

% Function that generates a matrix with the position of each sensor in
% the scenario
% The next line is commented for the calibration analysis
[Sensors,Num_sensors] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);

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
pattern(1,:,1,:)=winner2.dipole(Az,Antenna_slant);

% Generation of the Antenna Arrays considering the distribution
% (uniform), number of elements, distances, radiation patterns and sampling
% angles. If no FP is defined (FP-ECS and pattern), then by default it is a
% isotropic, vertically polarized antenna with XPD=inf

% Generate an arrays. Apparently it does not provide values of the pattern,
% just information about the array
Arrays(1) = winner2.AntennaArray('ULA',1,Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-1
Arrays(2) = winner2.AntennaArray('ULA',10, Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-10



%% Defining the layoutpar of the scenario

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
BsAAIdxCell = {1};                % target/BST also same as sensors

% Define number of channel pair (link between target and each sensor).
% There are as many as sensors are if there is one target, 2 times as many
% if there are 2 targets, so on
chan_pairing = length(MsAAIdx);

% Define network layot structure for wim function. Careful! the function
% layoutparset will generate a random 500mX500m cell with random stations
% position and velocities. Many of the parameters need to be changed.
layoutpar = winner2.layoutparset(MsAAIdx, BsAAIdxCell, chan_pairing, Arrays);

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
%% Localization

% Load Pd and BER values from Montecarlo simulations
filename = 'Results_TS_1_TE_1SepSen_500SepTar_500_500_Pt_-43dBW_sigma_9dB.mat';
load(filename);

% Loading of the LTE signal
Tx_vector_20M = load('Tx_20MHz');
Tx_vector_20M = Tx_vector_20M.Tx_LTE_20MHz_QPSK;
Tx_signal = Tx_vector_20M;


% Placing randonmly the target


if Type_Scenario == 1
    % This is for mixed zones
    t_x = rand*Size_Scenario;
    t_y = rand*Size_Scenario;
    T_target_pos= [t_x t_y];
else
    t_x = rand*Size_EZ_x;
    t_y = rand*Size_EZ_y;
    T_target_pos=[t_x t_y];
end

Pos_target = [t_x;t_y;ht];
Vel_target = [0;0;0];
layoutpar.Stations(1).Pos = Pos_target;
layoutpar.Stations(1).Velocity = Vel_target;
est_target_los= zeros(2,N_monte);
iter_target_los= zeros(N_monte,2);
Det_sensors = zeros(Num_sensors,N_monte);

for tt= 1:1:N_monte
    
    % Calculating distances between target and sensors
    [layoutpar,distance(:,tt)] = sensor_settings(layoutpar,Sensors,Num_sensors,Type_Environment,T_target_pos,Vel_sensors);
    
    % Generate the CIR
    [cir,delays,out] = winner2.wim(wimpar,layoutpar);
    % Find the sensors that have LOS
    [~,idx]= find(layoutpar.PropagConditionVector==1);
    LOS_sensor=Sensors(idx,:);
    
    % Find the sensors that have NLOS
    [~,nidx]= find(layoutpar.PropagConditionVector==0);
    nLOS_sensor=Sensors(nidx,:);
    cir_ds_los = cell(1,length(idx));
    cir_ds_nlos = cell(1,length(nidx));
    
    % downsampling of channel coefficients
    cir_ds = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples);
    for kk= 1:length(idx)
        cir_ds_los{kk} = cir_ds{idx(kk)};
        %[~,s_idx(kk)]=find( size(cir_ds_los{kk},1)>1);
    end
    for ll= 1:length(nidx)
        cir_ds_nlos{ll} = cir_ds{nidx(ll)};
    end
    %find(size(cir_ds{nidx}>1))
    
    
    % Calculate the received times for the LOS and NLOS sensors
    [rx_times_los,rx_times_nlos] = delay_calc(distance(:,tt),Type_Environment,cir_ds,idx,nidx,c);
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
    
    % Det_LOS_sensors = zeros(length(idx),1);
    % Det_NLOS_sensors = zeros(length(nidx),1);
    
    for ii=1:1:Num_sensors
        Det_sensors(ii,tt) = randsrc(1,1,[0 1; (1-Pd_final(ii)) Pd_final(ii)]);
    end
    
    Det_LOS_sensors = Det_sensors(idx,tt);
    
    Det_NLOS_sensors = Det_sensors(nidx,tt);
    
    % Pd_LOS_final = Pd_final(idx);
    %
    % for ii=1:1:length(idx)
    %     Det_LOS_sensors(ii) = randsrc(1,1,[0 1; (1-Pd_final(ii)) Pd_final(ii)]);
    % end
    %
    % Pd_NLOS_final = Pd_final(nidx);
    %
    % for ii=1:1:length(nidx)
    %     Det_NLOS_sensors(ii) = randsrc(1,1,[0 1; (1-Pd_final(ii)) Pd_final(ii)]);
    % end
    % %Estimation of the target position for TDOA
    if length(idx) >= 3
        [est_target_los(:,tt),iter_target_los(tt,:)]= TDOA_localization(rx_times_los(:,1),LOS_sensor,c);
    end
    if sum(Det_LOS_sensors) >= 3
        [est_target_los_pd(:,tt),iter_target_los_pd(tt,:)]= TDOA_localization(rx_times_los(find(Det_LOS_sensors),1),LOS_sensor(find(Det_LOS_sensors),:),c);
    end
    if length(nidx)>=3
        [est_target_nlos(:,tt),iter_target_nlos(tt,:)]= TDOA_localization(rx_times_nlos(:,1),nLOS_sensor,c);
    end
    if sum(Det_NLOS_sensors) >= 3
        [est_target_nlos_pd(:,tt),iter_target_nlos_pd(tt,:)]= TDOA_localization(rx_times_nlos(find(Det_NLOS_sensors),1),nLOS_sensor(find(Det_NLOS_sensors),:),c);
    end
    [est_target(:,tt),iter_target(tt,:)]= TDOA_localization(rx_times(:,1),Sensors,c);
    if sum(Det_sensors(:,tt)) >=3
        [est_target_pd(:,tt),iter_target_pd(tt,:)]= TDOA_localization(rx_times(find(Det_sensors(:,tt)),1),Sensors(find(Det_sensors(:,tt)),:),c);
    end
    
end


%% The lines below are commented because we do not want the 90% of the values in the estimation of x and y values
% T_est_los_x = prctile(est_target_los(1,:),90);
% T_est_los_y = prctile(est_target_los(2,:),90);
% T_iter_los_x = prctile(iter_target_los(:,1),90);
% T_iter_los_y = prctile(iter_target_los(:,2),90);
% T_est_los_pd_x = prctile(est_target_los_pd(1,:),90);
% T_est_los_pd_y = prctile(est_target_los_pd(2,:),90);
% T_iter_los_pd_x = prctile(iter_target_los_pd(:,1),90);
% T_iter_los_pd_y = prctile(iter_target_los_pd(:,2),90);
% 
% T_est_nlos_x = prctile(est_target_nlos(1,:),90);
% T_est_nlos_y = prctile(est_target_nlos(2,:),90);
% T_iter_nlos_x = prctile(iter_target_nlos(:,1),90);
% T_iter_nlos_y = prctile(iter_target_nlos(:,2),90);
% T_est_nlos_pd_x = prctile(est_target_nlos_pd(1,:),90);
% T_est_nlos_pd_y = prctile(est_target_nlos_pd(2,:),90);
% T_iter_nlos_pd_x = prctile(iter_target_nlos_pd(:,1),90);
% T_iter_nlos_pd_y = prctile(iter_target_nlos_pd(:,2),90);
% 
% T_est_x = prctile(est_target(1,:),90);
% T_est_y = prctile(est_target(2,:),90);
% T_iter_x = prctile(iter_target(:,1),90);
% T_iter_y = prctile(iter_target(:,2),90);
% T_est_pd_x = prctile(est_target_pd(1,:),90);
% T_est_pd_y = prctile(est_target_pd(2,:),90);
% T_iter_pd_x = prctile(iter_target_pd(:,1),90);
% T_iter_pd_y = prctile(iter_target_pd(:,2),90);

% We calculate the estimation error for each case
error_only_LOS_est = sqrt((t_x-est_target_los(1,:)).^2+(t_y-est_target_los(2,:)).^2);
error_only_LOS_iter = sqrt((t_x-iter_target_los(:,1)).^2+(t_y-iter_target_los(:,2)).^2);

error_only_LOS_est_pd = sqrt((t_x-est_target_los_pd(1,:)).^2+(t_y-est_target_los_pd(2,:)).^2);
error_only_LOS_iter_pd = sqrt((t_x-iter_target_los(:,1)).^2+(t_y-iter_target_los(:,2)).^2);

error_only_NLOS_est = sqrt((t_x-est_target_nlos(1,:) ).^2+(t_y-est_target_nlos(2,:)).^2);
error_only_NLOS_iter = sqrt((t_x-iter_target_nlos(:,1)).^2+(t_y-iter_target_nlos(:,2)).^2);

error_only_NLOS_est_pd = sqrt((t_x-est_target_nlos_pd(1,:)).^2+(t_y-est_target_nlos_pd(1,:)).^2);
error_only_NLOS_iter_pd = sqrt((t_x-iter_target_nlos(:,1)).^2+(t_y-iter_target_nlos(:,2)).^2);

error_est = sqrt((t_x-est_target(1,:)).^2+(t_y-est_target(2,:)).^2);
error_iter = sqrt((t_x-iter_target(:,1)).^2+(t_y-iter_target(:,2)).^2);

error_est_pd = sqrt((t_x-est_target_pd(1,:)).^2+(t_y-est_target_pd(2,:)).^2);
error_iter_pd = sqrt((t_x-iter_target_pd(:,1)).^2+(t_y-iter_target_pd(:,2)).^2);

% And then, from the values of the estimation error, we take the 90% of it.
% This means that our actual estimation error will be these values or
% lower.
T_error_only_LOS_est = prctile(error_only_LOS_est,90);
T_error_only_LOS_iter = prctile(error_only_LOS_iter,90);

T_error_only_LOS_est_pd = prctile(error_only_LOS_est_pd,90);
T_error_only_LOS_iter_pd = prctile(error_only_LOS_iter_pd,90);

T_error_only_NLOS_est = prctile(error_only_NLOS_est,90);
T_error_only_NLOS_iter = prctile(error_only_NLOS_iter,90);

T_error_only_NLOS_est_pd = prctile(error_only_NLOS_est_pd,90);
T_error_only_NLOS_iter_pd = prctile(error_only_NLOS_iter_pd,90);

T_error_est = prctile(error_est,90);
T_error_iter = prctile(error_iter,90);

T_error_est_pd = prctile(error_est_pd,90);
T_error_iter_pd = prctile(error_iter_pd,90);

figure(1)
title('Target position estimation using only LOS sensors')
subplot(2,1,1)
plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
plot(prctile(T_target_pos(:,1),90),prctile(T_target_pos(:,2),90),'bo','MarkerSize',16);hold on
%plot(LOS_sensor(:,1),LOS_sensor(:,2),'gx','MarkerSize',16); hold on
plot(est_target_los(1,:),est_target_los(2,:),'k+','MarkerSize',16); hold on
plot(iter_target_los(:,1),iter_target_los(:,2),'m+','MarkerSize',16); hold off
legend('Sensor Pos','True Target Pos','All LOS Sensors Pos','Est Target Pos','Iter Target Pos')
subplot(2,1,2)
plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
plot(t_x,t_y,'bo','MarkerSize',16);hold on
%plot(LOS_sensor(find(Det_LOS_sensors),1),LOS_sensor(find(Det_LOS_sensors),2),'g*','MarkerSize',16); hold on
plot(est_target_los_pd(1,:) ,est_target_los_pd(2,:),'k+','MarkerSize',16); hold on
plot(iter_target_los_pd(:,1),iter_target_los_pd(:,2),'m+','MarkerSize',16); hold off
legend('Sensor Pos','True Target Pos','Detected LOS Sensors Pos','Est Target Pos','Iter Target Pos')

figure(2)
title('Target position estimation using only NLOS sensors')
subplot(2,1,1)
plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
plot(t_x,t_y,'bo','MarkerSize',16);hold on
%plot(nLOS_sensor(:,1),nLOS_sensor(:,2),'c*','MarkerSize',16); hold on
plot(est_target_nlos(1,:),est_target_nlos(2,:),'k*','MarkerSize',16); hold on
plot(iter_target_nlos(:,1),iter_target_nlos(:,2),'m*','MarkerSize',16); hold off
legend('Sensor Pos','True Target Pos','All NLOS Sensors Pos','Est Target Pos','Iter Target Pos')
subplot(2,1,2)
plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
plot(t_x,t_y,'bo','MarkerSize',16);hold on
%plot(nLOS_sensor(find(Det_NLOS_sensors),1),nLOS_sensor(find(Det_NLOS_sensors),2),'c^','MarkerSize',16); hold on
plot(est_target_nlos_pd(1,:),est_target_nlos_pd(2,:),'k*','MarkerSize',16); hold on
plot(iter_target_nlos_pd(:,1),iter_target_nlos_pd(:,2),'m*','MarkerSize',16); hold off
legend('Sensor Pos','True Target Pos','Detected NLOS Sensors Pos','Est Target Pos','Iter Target Pos')


figure(3)
title('Target position estimation using ALL sensors')
subplot(2,1,1)
plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
plot(t_x,t_y,'bo','MarkerSize',16);hold on
plot(est_target(1,:),est_target(2,:),'k*','MarkerSize',16); hold on
plot(iter_target(:,1),iter_target(:,2),'m*','MarkerSize',16); hold off
legend('Sensor Pos','True Target Pos','Est Target Pos','Iter Target Pos')
subplot(2,1,2)
plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
plot(t_x,t_y,'bo','MarkerSize',16);hold on
%plot(Sensors(find(Det_sensors),1),Sensors(find(Det_sensors),2),'c^','MarkerSize',16); hold on
plot(est_target_pd(1,:),est_target_pd(2,:),'k*','MarkerSize',16); hold on
plot(iter_target_pd(:,1),iter_target_pd(:,2),'m*','MarkerSize',16); hold off
legend('Sensor Pos','True Target Pos','Detected Sensors','Est Target Pos','Iter Target Pos')

% % AoA localization (linear least square problem)
% [aoa_los,aoa_b_los,Pmu_los,Pbar_los,AA] = AOA_Detection(Type_Environment,LOS_sensor,Tx_signal,cir_ds_los,T_target_pos,1);
% [aoa_nlos,aoa_b_nlos,Pmu_nlos,Pbar_nlos,AA] = AOA_Detection(Type_Environment,nLOS_sensor,Tx_signal,cir_ds_nlos,T_target_pos,0);
% figure(7)
% subplot(2,1,1)
% for kk =1:size(LOS_sensor,1)
%     plot(AA,Pmu_los{kk});hold on
% end
% %plot(AA,Pmu_los{1});
% subplot(2,1,2)
% for ll =1:size(nLOS_sensor,1)
%     plot(AA,Pmu_nlos{ll});hold on
% end
% %plot(AA,Pmu_nlos{1},'r');
% figure(8)
% subplot(2,1,1)
% for kk =1:size(LOS_sensor,1)
%     plot(AA,Pbar_los{kk});hold on
% end
% %plot(AA,Pbar_los{2});
% subplot(2,1,2)
% for ll =1:size(nLOS_sensor,1)
%     plot(AA,Pbar_nlos{ll});hold on
% end
% 
% az_mu = zeros(1,Num_sensors);
% az_mu(idx) = aoa_los;
% az_mu(nidx) = aoa_nlos;
% az_bar = zeros(1,Num_sensors);
% az_bar(idx) = aoa_b_los;
% az_bar(nidx) = aoa_b_nlos;
% % localization for all LOS sensors
% if length(idx) >= 2
%     [pos_los]=AOA_localization(aoa_los,size(aoa_los,2),LOS_sensor);
%     [pos_b_los]=AOA_localization(aoa_b_los,size(aoa_b_los,2),LOS_sensor);
%     figure(4)
%     subplot(2,1,1)
%     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%     plot(t_x,t_y,'bo','MarkerSize',16);hold on
%     plot(LOS_sensor(:,1),LOS_sensor(:,2),'g*','MarkerSize',16); hold on
%     plot(pos_los(2),pos_los(1),'k+','MarkerSize',16); hold on
%     plot(pos_b_los(2),pos_b_los(1),'m+','MarkerSize',16); hold off
%     legend('Sensor Pos','True Target Pos','All LOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')
%     error_only_LOS_MU = sqrt((t_x-pos_los(2))^2+(t_y-pos_los(1))^2)
%     error_only_LOS_BAR = sqrt((t_x-pos_b_los(2))^2+(t_y-pos_b_los(1))^2)
%     % localization for DETECTING LOS sensors only
%     
%     if sum(Det_LOS_sensors) >= 2
%         [pos_los_pd]= AOA_localization(aoa_los(find(Det_LOS_sensors)),size(aoa_los(find(Det_LOS_sensors)),2),LOS_sensor(find(Det_LOS_sensors),:));
%         [pos_b_los_pd]= AOA_localization(aoa_b_los(find(Det_LOS_sensors)),size(aoa_b_los(find(Det_LOS_sensors)),2),LOS_sensor(find(Det_LOS_sensors),:));
%         subplot(2,1,2)
%         plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%         plot(t_x,t_y,'bo','MarkerSize',16);hold on
%         plot(LOS_sensor(find(Det_LOS_sensors),1),LOS_sensor(find(Det_LOS_sensors),2),'c^','MarkerSize',16); hold on
%         plot(pos_los_pd(2),pos_los_pd(1),'k+','MarkerSize',16); hold on
%         plot(pos_b_los_pd(2),pos_b_los_pd(1),'m+','MarkerSize',16); hold off
%         legend('Sensor Pos','True Target Pos','Detected LOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')
%         
%         error_Det_mu_los = sqrt((t_x-pos_los_pd(2))^2+(t_y-pos_los_pd(1))^2)
%         error_Det_bar_los = sqrt((t_x-pos_b_los_pd(2))^2+(t_y-pos_b_los_pd(1))^2)
%     end
% end
% % localization for all NLOS sensors
% if length(nidx) >= 2
%     [pos_nlos]=AOA_localization(aoa_nlos,size(aoa_nlos,2),nLOS_sensor);
%     [pos_b_nlos]=AOA_localization(aoa_b_nlos,size(aoa_b_nlos,2),nLOS_sensor);
%     figure(5)
%     subplot(2,1,1)
%     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%     plot(t_x,t_y,'bo','MarkerSize',16);hold on
%     plot(nLOS_sensor(:,1),nLOS_sensor(:,2),'g*','MarkerSize',16); hold on
%     plot(pos_nlos(2),pos_nlos(1),'k+','MarkerSize',16); hold on
%     plot(pos_b_nlos(2),pos_b_nlos(1),'m+','MarkerSize',16); hold off
%     legend('Sensor Pos','True Target Pos','All NLOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')
%     error_only_nLOS_MU = sqrt((t_x-pos_nlos(2))^2+(t_y-pos_nlos(1))^2)
%     error_only_nLOS_BAR = sqrt((t_x-pos_b_nlos(2))^2+(t_y-pos_b_nlos(1))^2)
%     % localization for DETECTING NLOS sensors only
%     
%     if sum(Det_NLOS_sensors) >= 2
%         [pos_nlos_pd]= AOA_localization(aoa_nlos(find(Det_NLOS_sensors)),size(aoa_nlos(find(Det_NLOS_sensors)),2),nLOS_sensor(find(Det_NLOS_sensors),:));
%         [pos_b_nlos_pd]= AOA_localization(aoa_b_nlos(find(Det_NLOS_sensors)),size(aoa_b_nlos(find(Det_NLOS_sensors)),2),nLOS_sensor(find(Det_NLOS_sensors),:));
%         subplot(2,1,2)
%         plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%         plot(t_x,t_y,'bo','MarkerSize',16);hold on
%         plot(nLOS_sensor(find(Det_NLOS_sensors),1),nLOS_sensor(find(Det_NLOS_sensors),2),'c^','MarkerSize',16); hold on
%         plot(pos_nlos_pd(2),pos_nlos_pd(1),'k+','MarkerSize',16); hold on
%         plot(pos_b_nlos_pd(2),pos_b_nlos_pd(1),'m+','MarkerSize',16); hold off
%         legend('Sensor Pos','True Target Pos','Detected NLOS Sensors Pos','MUSIC Target Pos','BARTLETT Target Pos')
%         error_Det_mu_nlos = sqrt((t_x-pos_nlos_pd(2))^2+(t_y-pos_nlos_pd(1))^2)
%         error_Det_bar_nlos = sqrt((t_x-pos_b_nlos_pd(2))^2+(t_y-pos_b_nlos_pd(1))^2)
%         
%     end
% end
% % localization using all sensors
% [pos_mu]= AOA_localization(az_mu,size(az_mu,2),Sensors);
% [pos_bar]= AOA_localization(az_bar,size(az_bar,2),Sensors);
% figure(6)
% title('Target position estimation using ALL sensors')
% subplot(2,1,1)
% plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
% plot(t_x,t_y,'bo','MarkerSize',16);hold on
% plot(pos_mu(2),pos_mu(1),'k*','MarkerSize',16); hold on
% plot(pos_bar(2),pos_bar(1),'m*','MarkerSize',16); hold off
% legend('Sensor Pos','True Target Pos','MUSIC Target Pos','BARTLETT Target Pos')
% error_all_mu = sqrt((t_x-pos_mu(2))^2+(t_y-pos_mu(1))^2)
% error_all_bar = sqrt((t_x-pos_bar(2))^2+(t_y-pos_bar(1))^2)
% if sum(Det_sensors) >=2
%     [pos_mu_pd]= AOA_localization(az_mu(find(Det_sensors)),size(az_mu(find(Det_sensors)),2),Sensors(find(Det_sensors),:));
%     [pos_bar_pd]= AOA_localization(az_bar(find(Det_sensors)),size(az_bar(find(Det_sensors)),2),Sensors(find(Det_sensors),:));
%     
%     subplot(2,1,2)
%     plot(Sensors(:,1),Sensors(:,2),'rx','MarkerSize',16); hold on
%     plot(t_x,t_y,'bo','MarkerSize',16);hold on
%     plot(Sensors(find(Det_sensors),1),Sensors(find(Det_sensors),2),'c^','MarkerSize',16); hold on
%     plot(pos_mu_pd(2),pos_mu_pd(1),'k*','MarkerSize',16); hold on
%     plot(pos_bar_pd(2),pos_bar_pd(1),'m*','MarkerSize',16); hold off
%     legend('Sensor Pos','True Target Pos','Detected Sensors','MUSIC Target Pos','BARTLETT Target Pos')
%     
%     error_all_Det_mu = sqrt((t_x-pos_mu_pd(2))^2+(t_y-pos_mu_pd(1))^2)
%     error_all_Det_bar = sqrt((t_x-pos_bar_pd(2))^2+(t_y-pos_bar_pd(1))^2)
%     
% end











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





