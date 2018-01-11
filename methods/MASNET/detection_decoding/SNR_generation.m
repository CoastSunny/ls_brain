%% This function runs N_monte times the WINNER-II CHANNEL and calculates the SNR at: Each target position, for each Montecarlo run and each sensor

function SNR_generation()

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
    Pfa = .1;%A.data(index);      % Probability of false alarm

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

    Num_sensors = 96;      % This number of sensors helps to get the right 
                           % number of sensors positioned later. For 
                           % Separated: Num_sensors=76 if Sep_sensors=100 or
                           % Num_sensors=96 if Sep_sensors=78, for Mixed: 
                           % Num_sensors=64 if Sep_sensors=250.
    %Pt = -43;
    %Sep_sensors = floor(sqrt(760000/144));
     Sep_sensors = 78;
    [Sensors,~] = sensor_positioning(Type_Scenario,Size_Scenario,Size_FZ1_x,Size_FZ1_y,Size_FZ2_x,Size_FZ2_y,Sep_sensors,hs);

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
    MsAAIdx = MsAAIdx'.*1;
    BsAAIdxCell = {[1]};                % target/BST also same as sensors

    % Define number of channel pair (link between target and each sensor).
    % There are as many as sensors are if there is one target, 2 times as many
    % if there are 2 targets, so on
    chan_pairing = length(MsAAIdx);

    % Define network layout structure for wim function. Careful! the function
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

    % This matrix will store the snr values of each sensor at each target position for each Montecarlo run

    ALL_SNR = zeros(N_target_pos_x,N_target_pos_y,N_monte,Num_sensors);     


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
                    % wim function has changed. Inside this function,
                    % there is another function called generatePathGains.m. In
                    % the line 364 of this function, there is a variable M that
                    % was originally initialised to M=20. The problme is that
                    % if Time_samples=1, then it creates an error. In fact the
                    % error happens as long as Time_samples<20. So, this M has
                    % been changed to M=1 to avoid this error.
                    [cir,delays,out] = winner2.wim(wimpar,layoutpar);

                    cir = downsampling_cir(cir,delays,Delay_interval,Num_sensors,Time_samples);

                    % Calculate the SNR

                    [SNR ALL_Pr(indx_x,indx_y,m,:) ALL_Noise(indx_x,indx_y,m)] = SNR_calculation(cir,distance,lambda,Type_Environment,d_0,sigma,Num_sensors,Time_samples,Pt,NF,n,BW);

                    ALL_SNR(indx_x,indx_y,m,:) = SNR;   % Store the resulting snr in this target position for this run. No it does not consider more than 1 time sample!

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


    %% Save results in file

    filename3 = ['./results/SNR_TS_' num2str(Type_Scenario) '_TE_' num2str(Type_Environment) '_Num_Sensors_' num2str(Num_sensors) '_SepTar_' num2str(Int_target_x) '_' num2str(Int_target_y) '_Pt_' num2str(Pt) 'dBW_sigma_' num2str(sigma) 'dB.mat'];
    save(filename3,'ALL_SNR','ALL_Pr','ALL_Noise');            
    
end
