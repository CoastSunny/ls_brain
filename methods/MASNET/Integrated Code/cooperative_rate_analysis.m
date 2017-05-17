function cooperative_rate_analysis()

%% This function analyses what is the maximum achievable data rate between sensors in the cooperative operation for diversity combination.

close all force
clear all
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
pattern(1,:,1,:)=winner2.dipole(Az,Antenna_slant); 

FP = [pattern;pattern];

% Generation of the Antenna Arrays considering the distribution
% (uniform), number of elements, distances, radiation patterns and sampling
% angles. If no FP is defined (FP-ECS and pattern), then by default it is a
% isotropic, vertically polarized antenna with XPD=inf

% Generate an arrays. Apparently it does not provide values of the pattern,
% just information about the array
Arrays(1) = winner2.AntennaArray('UCA',1,Dists(1),'FP-ACS',pattern,'Azimuth',Az); %ULA-1 
Arrays(2) = winner2.AntennaArray('ULA',10,Dists(1),'FP-ACS',pattern,'Azimuth',Az); %ULA-10






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

%% Scenario and network generation

Num_sensors = 2;

Num_Pt = 7;     % Number of the evaluated transmitted powers at the source
Num_Pt2 = 100;   % Number of the evaluated transmitted powers at the relays

% Define sensor velocities. For now, all are static. The velocity of the
% sensors cannot be zero, therefore, if we want to analyse static sensors,
% we need to put very small velocities of the sensors.
Vel_sensors=ones(Num_sensors,3).*0.01;


% This matrix will store the snr values of each sensor at each target position for each Montecarlo run

ALL_SNR1 = zeros(N_monte,Num_sensors,Num_Pt);
ALL_SNR2 = zeros(N_monte,Num_sensors-1,Num_Pt2);

% These vectors are for storing the channel information for each montecarlo
% run
hsr = zeros(N_monte,1);
hsd = zeros(N_monte,1);
hrd = zeros(N_monte,1);


%% Defining the layoutpar of the scenario

% Define the type of arrays for each sensor and target. MsAAIdx has as many
% elements as sensors and the number in it will set what array in arrays is
% set to each of the sensors. BsAAIdxCell is the same but for target (BST).
% If the target/BST has more than one sector, then {[1 1]} or {[1 1 1]} and
% so on. Also, it is possible to mix arrays for different sensors and
% target/BST i.e. MsAAIdx = [1 1 1 3 2 1 2 3 ...] and BsAAIdxCell = {[1
% 2];[1];[3 2]} and so on.
MsAAIdx1 = ones(Num_sensors,1);    % All sensor the same. 1 element array
MsAAIdx2 = ones(Num_sensors-1,1);    % All sensor the same. 1 element array
MsAAIdx1 = MsAAIdx1'.*1;
MsAAIdx2 = MsAAIdx2'.*1;
BsAAIdxCell = {[1]};                % target/BST also same as sensors

% Define number of channel pair (link between target and each sensor).
% There are as many as sensors are if there is one target, 2 times as many
% if there are 2 targets, so on
chan_pairing1 = length(MsAAIdx1);
chan_pairing2 = length(MsAAIdx2);

% Define network layot structure for wim function. Careful! the function
% layoutparset will generate a random 500mX500m cell with random stations
% position and velocities. Many of the parameters need to be changed.
layoutpar1 = winner2.layoutparset(MsAAIdx1, BsAAIdxCell, chan_pairing1, Arrays);
layoutpar2 = winner2.layoutparset(MsAAIdx2, BsAAIdxCell, chan_pairing2, Arrays);

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
    layoutpar1.ScenarioVector(layoutpar1.ScenarioVector==1) = 10; % Ideally 9, but it does not work.
    layoutpar2.ScenarioVector(layoutpar2.ScenarioVector==1) = 10; % Ideally 9, but it does not work.
else
    layoutpar1.ScenarioVector(layoutpar1.ScenarioVector==1) = 12;
    layoutpar2.ScenarioVector(layoutpar2.ScenarioVector==1) = 12;
end




    % Set target position from origin of coordinates in metres. Now, the target
    % position is set, but later it needs to be changed to all possible
    % positions within the enemy area and repeat the calculations
    Pos_target = [0;0;ht];
    Vel_target = [0;0;0];
    
    Sensor1 = [500;1500;hs];    % Sensor 1 will be a "Relay Sensor"
    Sensor2 = [1500;500;hs];    % Sensor 2 will be a "Destination Sensors" or "data fusion sensor"    

    % Here, the target is assumed to be the source in layoutpar, where we
    % have two more sensors. Then, in layoutpar2, the source is the Sensor1 
    % instead of the source. This is neccessary to get the CIR
    % between the sensors.
    layoutpar1.Stations(1).Pos = Pos_target;
    layoutpar1.Stations(1).Velocity = Vel_target;
    
    layoutpar2.Stations(1).Pos = Sensor1;
    layoutpar2.Stations(1).Velocity = [Vel_sensors(2,1,1);Vel_sensors(2,2,1);Vel_sensors(2,3,1)];
    
    layoutpar1.Stations(2).Pos = Sensor1;
    layoutpar1.Stations(3).Pos = Sensor2;
    
    layoutpar2.Stations(2).Pos = Sensor2;

    % Set the velocity of the sensor i in the structure
    layoutpar1.Stations(2).Velocity = [Vel_sensors(1,1,1);Vel_sensors(1,2,1);Vel_sensors(1,3,1)];
    layoutpar1.Stations(3).Velocity = [Vel_sensors(2,1,1);Vel_sensors(2,2,1);Vel_sensors(2,3,1)];
    
    layoutpar2.Stations(2).Velocity = [Vel_sensors(2,1,1);Vel_sensors(2,2,1);Vel_sensors(2,3,1)];

    % Calculate the 2D distance between target and sensor i
    distance(1) = sqrt((Sensor1(1)-Pos_target(1))^2+(Pos_target(2)-Sensor1(2))^2);
    distance(2) = sqrt((Sensor2(1)-Pos_target(1))^2+(Pos_target(2)-Sensor2(2))^2);
    % This is the distance between the relay and the destination sensors
    distance(3) = sqrt((Sensor2(1)-Sensor1(1))^2+(Sensor1(2)-Sensor2(2))^2);
    
    distance = distance';



% Initialise wait bar for the Montecarlo runs
w = waitbar(0,'Running Montecarlo simulation. Please wait...','Position', [500 400 280 50]);

process = 0;

% Run the Montecarlo simulation N times

% N_monte = 100;

waitbar(process/N_monte,w);


for m=1:1:N_monte
    

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

    % Due to having to use a new version of MATLAB
    % (Matlab2016b) and install the winner.channel toolbox, the
    % winner2.wim function has changed. Inside this function,
    % there is another function called generatePathGains.m. In
    % the line 364 of this function, there is a variable M that
    % was originally initialised to M=20. The problme is that
    % if Time_samples=1, then it creates an error. In fact the
    % error happens as long as Time_samples<20. So, this M has
    % been changed to M=1 to avoid this error.
    [cir1,delays1,out1] = winner2.wim(wimpar,layoutpar1);     % For case, Source+Relay+Destination
    [cir2,delays2,out2] = winner2.wim(wimpar,layoutpar2);     % Relay+Destination
    
    % Note that for now Time_samples=1 but eventually should be the size of
    % a OFDM symbol, or LTE symbol or LTE radio frame
    cir1 = downsampling_cir(cir1,delays1,Delay_interval,Num_sensors,Time_samples);
    cir2 = downsampling_cir(cir2,delays2,Delay_interval,Num_sensors-1,Time_samples);

    % Calculate the SNR
    
    SNR1 = zeros(Num_sensors,Num_Pt);
    
    index = 1;
    for Pt=-73:10:-13
        SNR1(:,index) = SNR_calculation(cir1,distance(1:2),lambda,Type_Environment,d_0,sigma,Num_sensors,Time_samples,Pt,NF,n,BW);
        index = index + 1;
    end
    
    BW2 = 100e3;        % The available bandwidth between the relay and the destination is only 100kHz
    
    SNR2 = zeros(Num_Pt2,1);
    
    index = 1;
    for Pt2=-99:1:0
        SNR2(index) = SNR_calculation(cir2,distance(3),lambda,Type_Environment,d_0,sigma,Num_sensors-1,Time_samples,Pt2,NF,n,BW2);
        index = index+1;
    end
        
    ALL_SNR1(m,:,:) = 10.^(SNR1./10);   % Store the resulting snr in this target position for this run. No it does not consider more than 1 time sample!
    ALL_SNR2(m,:,:) = 10.^(SNR2./10);   % Store the resulting snr in this target position for this run. No it does not consider more than 1 time sample!
    
    % Calculate the |hsr|, |hsd| and |hrd|
    
    hsr(m) = sum(cir1{1,1}(:,:,:,:));
    hsd(m) = sum(cir1{2,1}(:,:,:,:));
    hrd(m) = sum(cir2{1,1}(:,:,:,:));
    
    process = process + 1;

    waitbar(process/N_monte,w)


end

% After the MonteCarlo runs, we need the average SNR and H for each link
% (Source-Relay (sr), Source-Destination (sd) and Relay-Destination (rd)) in order to
% calculate the rates.

SNR_sr = mean(ALL_SNR1(:,1,:),1);
SNR_sr = squeeze(SNR_sr);
SNR_sd = mean(ALL_SNR1(:,2,:),1);
SNR_sd = squeeze(SNR_sd);
SNR_rd = mean(ALL_SNR2,1);
SNR_rd = squeeze(SNR_rd);


% We also need to calculate the "channel gain" for the links between
% Source-Relay (sr), Source-Destination (sd) and Relay-Destination (rd)

Hsr = abs(mean(hsr))^2;
Hsd = abs(mean(hsd))^2;
Hrd = abs(mean(hrd))^2;


% Initialise variables to store the rates

RDF1 = zeros(Num_Pt,Num_Pt2);
RDF2 = zeros(Num_Pt,Num_Pt2);
RDF = zeros(Num_Pt,Num_Pt2);
CDF1 = zeros(Num_Pt,Num_Pt2);
CDF2 = zeros(Num_Pt,Num_Pt2);
CDF = zeros(Num_Pt,Num_Pt2);


RCF = zeros(Num_Pt,Num_Pt2);
CCF = zeros(Num_Pt,Num_Pt2);

RAF = zeros(Num_Pt,Num_Pt2);
CAF = zeros(Num_Pt,Num_Pt2);

% Rsr = zeros(Num_Pt,1);
% Rsd = zeros(Num_Pt,1);
% Rrd = zeros(Num_Pt);

for i=1:1:Num_Pt

    % Following equations from Jiang thesis where the reference Elements of
    % Information Theory by T. M. Cover (Chapter 15).

    % Decode-and-Forward
    % Careful, now it is assumed that the channel does not change between one
    % sample to another and that the energy/power transmitted by the source
    % does not change either between one sample to another
    RDF1(i,:) = (0.5.*log2(1+SNR_sr(i)) + 0.5.*log2(1+SNR_sd(i))).*ones(length(SNR_rd),1);
    RDF2(i,:) = 0.5.*log2(1+SNR_sd(i)) + 0.5.*log2(1+SNR_sd(i) + SNR_rd);  
    RDF(i,:) = min(RDF1(i),RDF2(i,:));
    
    % Decode-and-Forward considering different BW
    CDF1(i,:) = (BW.*log2(1+SNR_sr(i)) + BW.*log2(1+SNR_sd(i))).*ones(length(SNR_rd),1);
    CDF2(i,:) = 2.*BW.*log2(1+SNR_sd(i)) + BW2.*log2(1+SNR_rd);
    CDF(i,:) = min(CDF1(i),CDF2(i,:));
    
    
    

    % Compress-and-Forward
    sigma = (SNR_sr(i)+SNR_sd(i)+1)./((SNR_rd./(1+SNR_sd(i))).*(SNR_sd(i)+1));
    RCF(i,:) = 0.5.*log2(1+SNR_sd(i)+(SNR_sr(i)./(1+sigma))) + 0.5.*log2(1+SNR_sd(i));
    
    % Compress-and-Forward considering different BW
    sigma_ = (SNR_sr(i)+SNR_sd(i)+1)./(SNR_rd);
    CCF(i,:) = 2.*BW.*log2(1+SNR_sd(i)) + BW2.*log2(1+(SNR_sr(i)./(1+sigma_)));
    
    
    % Amplify-and-Forward    
    RAF(i,:) = 0.5.*(1+SNR_sd(i)+((SNR_rd.*Hsr)./(SNR_rd+SNR_sr(i)))) + 0.5.*(1+SNR_sd(i));
    
    % Amplify-and-Forward considering different BW
    CAF(i,:) = 2.*BW.*log2(1+SNR_sd(i)) + BW2.*log2(1+((SNR_rd.*Hsr)./(SNR_rd+SNR_sr(i))));



end

    % Counting for separated links
    Rsr = log2(1+SNR_sr);
    Rsd = log2(1+SNR_sd);
    Rrd = log2(1+SNR_rd);

figure(1)
plot(10.*log10(SNR_rd),RDF(1,:),'-oy')
hold on
plot(10.*log10(SNR_rd),RDF(2,:),'-oc')
plot(10.*log10(SNR_rd),RDF(3,:),'-om')
plot(10.*log10(SNR_rd),RDF(4,:),'-og')
plot(10.*log10(SNR_rd),RDF(5,:),'-or')
plot(10.*log10(SNR_rd),RDF(6,:),'-ok')
plot(10.*log10(SNR_rd),RDF(7,:),'-ob')

plot(10.*log10(SNR_rd),RDF1(1,:),'-y')
plot(10.*log10(SNR_rd),RDF1(2,:),'-c')
plot(10.*log10(SNR_rd),RDF1(3,:),'-m')
plot(10.*log10(SNR_rd),RDF1(4,:),'-g')
plot(10.*log10(SNR_rd),RDF1(5,:),'-r')
plot(10.*log10(SNR_rd),RDF1(6,:),'-k')
plot(10.*log10(SNR_rd),RDF1(7,:),'-b')

plot(10.*log10(SNR_rd),RDF2(1,:),'-xy')
plot(10.*log10(SNR_rd),RDF2(2,:),'-xc')
plot(10.*log10(SNR_rd),RDF2(3,:),'-xm')
plot(10.*log10(SNR_rd),RDF2(4,:),'-xg')
plot(10.*log10(SNR_rd),RDF2(5,:),'-xr')
plot(10.*log10(SNR_rd),RDF2(6,:),'-xk')
plot(10.*log10(SNR_rd),RDF2(7,:),'-xb')
hold off
title('Channel rate in Decode-and-Forward')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Rate C/BW [bits/s/Hz]')
legend('RDF Ps=-73dBW','RDF Ps=-63dBW','RDF Ps=-53dBW','RDF Ps=-43dBW','RDF Ps=-33dBW','RDF Ps=-23dBW','RDF Ps=-13dBW','RDF1 Ps=-73dBW','RDF1 Ps=-63dBW','RDF1 Ps=-53dBW','RDF1 Ps=-43dBW','RDF1 Ps=-33dBW','RDF1 Ps=-23dBW','RDF1 Ps=-13dBW','RDF2 Ps=-73dBW','RDF2 Ps=-63dBW','RDF2 Ps=-53dBW','RDF2 Ps=-43dBW','RDF2 Ps=-33dBW','RDF2 Ps=-23dBW','RDF2 Ps=-13dBW')
set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min([RDF(1,:) RDF1(1,:) RDF2(1,:)])) ceil(max([RDF(7,:) RDF1(7,:) RDF2(7,:)]))])
grid on

figure(2)
plot(10.*log10(SNR_rd),RCF(1,:),'y')
hold on
plot(10.*log10(SNR_rd),RCF(2,:),'c')
plot(10.*log10(SNR_rd),RCF(3,:),'m')
plot(10.*log10(SNR_rd),RCF(4,:),'g')
plot(10.*log10(SNR_rd),RCF(5,:),'r')
plot(10.*log10(SNR_rd),RCF(6,:),'k')
plot(10.*log10(SNR_rd),RCF(7,:),'b')
hold off
title('Channel rate in Compress-and-Forward')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Rate C/BW [bits/s/Hz]')
legend('Ps=-73dBW','Ps=-63dBW','Ps=-53dBW','Ps=-43dBW','Ps=-33dBW','Ps=-23dBW','Ps=-13dBW')
set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min(RCF(1,:))) ceil(max(RCF(7,:)))])
grid on

figure(22)
plot(10.*log10(SNR_rd),RAF(1,:),'y')
hold on
plot(10.*log10(SNR_rd),RAF(2,:),'c')
plot(10.*log10(SNR_rd),RAF(3,:),'m')
plot(10.*log10(SNR_rd),RAF(4,:),'g')
plot(10.*log10(SNR_rd),RAF(5,:),'r')
plot(10.*log10(SNR_rd),RAF(6,:),'k')
plot(10.*log10(SNR_rd),RAF(7,:),'b')
hold off
title('Channel rate in Amplify-and-Forward')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Rate C/BW [bits/s/Hz]')
legend('Ps=-73dBW','Ps=-63dBW','Ps=-53dBW','Ps=-43dBW','Ps=-33dBW','Ps=-23dBW','Ps=-13dBW')
set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min(RAF(1,:))) ceil(max(RAF(7,:)))])
grid on

figure(3)
plot(10.*log10(SNR_rd),Rrd)
title('Channel rate for the link Relay-Destination')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Rate C/BW [bits/s/Hz]')
set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min(Rrd)) ceil(max(Rrd))])
grid on

figure(4)
plot(10.*log10(SNR_sr),Rsr)
hold on
plot(10.*log10(SNR_sd),Rsd,'k')
hold off
title('Channel rate for the links Source-Relay and Source-Destination')
xlabel('SNR in the Source-Relay or Source-Destination link [dB]')
ylabel('Rate C/BW [bits/s/Hz]')
legend('Rate Source-Relay','Rate Source-Destination')
grid on




figure(5)
plot(10.*log10(SNR_rd),CDF(1,:),'-oy')
hold on
plot(10.*log10(SNR_rd),CDF(2,:),'-oc')
plot(10.*log10(SNR_rd),CDF(3,:),'-om')
plot(10.*log10(SNR_rd),CDF(4,:),'-og')
plot(10.*log10(SNR_rd),CDF(5,:),'-or')
plot(10.*log10(SNR_rd),CDF(6,:),'-ok')
plot(10.*log10(SNR_rd),CDF(7,:),'-ob')

plot(10.*log10(SNR_rd),CDF1(1,:),'-y')
plot(10.*log10(SNR_rd),CDF1(2,:),'-c')
plot(10.*log10(SNR_rd),CDF1(3,:),'-m')
plot(10.*log10(SNR_rd),CDF1(4,:),'-g')
plot(10.*log10(SNR_rd),CDF1(5,:),'-r')
plot(10.*log10(SNR_rd),CDF1(6,:),'-k')
plot(10.*log10(SNR_rd),CDF1(7,:),'-b')

plot(10.*log10(SNR_rd),CDF2(1,:),'-xy')
plot(10.*log10(SNR_rd),CDF2(2,:),'-xc')
plot(10.*log10(SNR_rd),CDF2(3,:),'-xm')
plot(10.*log10(SNR_rd),CDF2(4,:),'-xg')
plot(10.*log10(SNR_rd),CDF2(5,:),'-xr')
plot(10.*log10(SNR_rd),CDF2(6,:),'-xk')
plot(10.*log10(SNR_rd),CDF2(7,:),'-xb')
hold off
title('Channel capacity in Decode-and-Forward considering different bandwidths')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Capacity C [bits/s]')
legend('RDF Ps=-73dBW','RDF Ps=-63dBW','RDF Ps=-53dBW','RDF Ps=-43dBW','RDF Ps=-33dBW','RDF Ps=-23dBW','RDF Ps=-13dBW','RDF1 Ps=-73dBW','RDF1 Ps=-63dBW','RDF1 Ps=-53dBW','RDF1 Ps=-43dBW','RDF1 Ps=-33dBW','RDF1 Ps=-23dBW','RDF1 Ps=-13dBW','RDF2 Ps=-73dBW','RDF2 Ps=-63dBW','RDF2 Ps=-53dBW','RDF2 Ps=-43dBW','RDF2 Ps=-33dBW','RDF2 Ps=-23dBW','RDF2 Ps=-13dBW')
% set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min([CDF(1,:) CDF1(1,:) CDF2(1,:)])) ceil(max([CDF(7,:) CDF1(7,:) CDF2(7,:)]))])
grid on

figure(6)
plot(10.*log10(SNR_rd),CCF(1,:),'y')
hold on
plot(10.*log10(SNR_rd),CCF(2,:),'c')
plot(10.*log10(SNR_rd),CCF(3,:),'m')
plot(10.*log10(SNR_rd),CCF(4,:),'g')
plot(10.*log10(SNR_rd),CCF(5,:),'r')
plot(10.*log10(SNR_rd),CCF(6,:),'k')
plot(10.*log10(SNR_rd),CCF(7,:),'b')
hold off
title('Channel capacity in Compress-and-Forward considering different bandwidths')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Capacity C [bits/s]')
legend('Ps=-73dBW','Ps=-63dBW','Ps=-53dBW','Ps=-43dBW','Ps=-33dBW','Ps=-23dBW','Ps=-13dBW')
% set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min(CCF(1,:))) ceil(max(CCF(7,:)))])
grid on

figure(7)
plot(10.*log10(SNR_rd),CAF(1,:),'y')
hold on
plot(10.*log10(SNR_rd),CAF(2,:),'c')
plot(10.*log10(SNR_rd),CAF(3,:),'m')
plot(10.*log10(SNR_rd),CAF(4,:),'g')
plot(10.*log10(SNR_rd),CAF(5,:),'r')
plot(10.*log10(SNR_rd),CAF(6,:),'k')
plot(10.*log10(SNR_rd),CAF(7,:),'b')
hold off
title('Channel capacity in Amplify-and-Forward considering different bandwidths')
xlabel('SNR in the Relay-Destination link [dB]')
ylabel('Capacity C [bits/s]')
legend('Ps=-73dBW','Ps=-63dBW','Ps=-53dBW','Ps=-43dBW','Ps=-33dBW','Ps=-23dBW','Ps=-13dBW')
% set(gca,'XLim',[floor(10*log10(min(SNR_rd))) ceil(10*log10(max(SNR_rd)))],'YLim',[floor(min(CCF(1,:))) ceil(max(CCF(7,:)))])
grid on


delete(w)

end


