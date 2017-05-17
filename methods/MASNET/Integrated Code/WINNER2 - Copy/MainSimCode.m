%% Control of WINNER 2 channel model -- PChambers

% Code written to try to control and experiment with WINNER 2 channel model
% Initially an amalgamtion of, 'example_channel_matrix.m',
% 'example_EADF_approx.m'

%************************************************************************************************

clear

%% Decide to save channels, 'y' or 'n'.
save_channels = 'n';
save_path = 'H:\MATLAB\DSTL\MASNET_Project\WINNER2';
cdir = cd;

%% Decide on large scale (arbitrary sensor position) scenario or small scale with fixed sensor positions

scale = 'small'; % 'large' or 'small'. 

%% Channel Paramters

% Speed of light
c = 3e8;

% Carrier Frequency
Fc = 2.4e9;

% Distances to apply delays (and path losses if not satisfied how
% WINNER model does path loss). 0 means no delay.
d = 0;
 
% Scenario.
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


% Sample density, recommended: 64.
Sample_Density = 64;

% Time samples per drop (4th dimension of array) 
Time_samples = 1000;

% Number of drops 
Ndrops = 15;

% Large scale paramters (if using large scale option).
sensor_number = 250;
scenario = 3;
nlos_los = 0;


% Antenna spacing for arrays
dist = (c/Fc)*0.5; %lambda/2 spacing

% Slant on the antenna orientation.
Antenna_slant = 0;


switch scale 
    case 'small'
% Define the pairings. 
% Upper row refers to which BsAAIdxCell sector is active, i.e., which row of BsAAIdxCell is active. 
% Lower row refers to which MsAAIdx user array (or single antenna user) is active, i.e., which element of MsAAIdx is active. 
% The referencing system for the bottom row seems to be length(BsAAIdxCell) + index to MsAAIdx. 
MsAAIdx = [1 1 1 1 1 1 1 1 1 1];
BsAAIdxCell = {[1]};

Pairing_matrix(1,:) = MsAAIdx;
Pairing_matrix(2,:) = length(BsAAIdxCell) + [1:length(MsAAIdx)];
chan_pairing = length(MsAAIdx);

% Vector of scenarios for whose elements correpond to each link -- the vector must be same as
% length(chan_pairing) as defined below).
scenario = [3 3 3 3 3 3 3 3 3 3];

% NLOS or LOS conditions for each link, (NLOS=0/LOS=1) -- the vector must be same as
% length(chan_pairing) as defined below.
nlos_los = [1 1 1 1 1 1 1 1 1 1];

    case 'large'   
scenario = scenario*ones(1,sensor_number);
nlos_los = nlos_los*ones(1,sensor_number);
MsAAIdx = ones(1,sensor_number);
BsAAIdxCell = {[1]};

Pairing_matrix(1,:) = MsAAIdx;
Pairing_matrix(2,:) = length(BsAAIdxCell) + [1:length(MsAAIdx)];
chan_pairing = length(MsAAIdx);

end
        

%% Receiver paramters

% Sampling frequency. WINNER uses 100MHz, this can be set to
% change this by process of downscaling 

Fs_desired = 31e6;

wimpar = struct(  'range',1,...  
                'end_time',1,...                        % Observation end time for B5 - time points are taken as:  wimpar.TimeVector=linspace(0,wimpar.end_time,T);
                'SampleDensity', Sample_Density,...                  % in samples/half-wavelength
                'NumTimeSamples',Time_samples,...         
                'UniformTimeSampling','no',... 
                'IntraClusterDsUsed','yes',...          % Two strongest clusters are divided into three subclusters
                'NumSubPathsPerPath',20,...             % only value supported is 20.
                'FixedPdpUsed','no',...                 % Use fixed delays and path powers
                'FixedAnglesUsed','no',...              % Use fixed AoD/AoAs
                'PolarisedArrays','yes',...             % Obsolete - always polarised arrays are used!
                'TimeEvolution','no',...                % use of time evolution option
                'CenterFrequency',Fc,...                % in Hertz
                'DelaySamplingInterval',5e-9,...        
                'PathLossModelUsed','yes',...            
                'ShadowingModelUsed','yes',...           
                'PathLossModel','pathloss',...
                'PathLossOption','CR_light',...         % 'CR_light' or 'CR_heavy' or 'RR_light' or 'RR_heavy', CR = Corridor-Room, RR = Room-Room nlos  
                'RandomSeed',[],...                     % if empty, seed is not set. 
                'UseManualPropCondition','yes');




%% Array preprocessing -- EADF approximation for antenna patterns.

Dists = [dist, dist, dist, dist, dist, dist];
NAz=120; %3 degree sampling interval
Az=linspace(-180,180-1/NAz,NAz);

%% Radiation patterns & antenna arrays.

pattern(1,:,1,:)=dipole(Az,Antenna_slant); 

Arrays(1) = AntennaArray('ULA',1,Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-2 
Arrays(2) = AntennaArray('ULA',2,Dists(2),'FP-ECS',pattern,'Azimuth',Az); %ULA-4 



%% Channel preparation

% Links, pairing, propagation
ar = AntennaResponse(Arrays(1),Az);
layoutpar = layoutparset(MsAAIdx, BsAAIdxCell, chan_pairing, Arrays);
layoutpar.PropagConditionVector = nlos_los; 
layoutpar.ScenarioVector = scenario;  
layoutpar.Pairing = Pairing_matrix; 

% Fix station positions (Base & Mobile)
switch scale
    case 'small'
layoutpar.Stations(1,1).Pos = [265; 435; 3];
layoutpar.Stations(1,2).Pos = [449.0000; 250; 1.5];
layoutpar.Stations(1,3).Pos = [276.0000; 175.0000; 1.5];
layoutpar.Stations(1,4).Pos = [99.0000; 299.0000; 1.5];
layoutpar.Stations(1,5).Pos = [469.0000;  190.0000; 1.5];
layoutpar.Stations(1,6).Pos = [314.0000; 198.0000; 1.5];
layoutpar.Stations(1,7).Pos = [104.0000; 283.0000; 1.5];
layoutpar.Stations(1,8).Pos = [189.0000; 217.0000; 1.5];
layoutpar.Stations(1,9).Pos = [463.0000; 120.0000; 1.5];
layoutpar.Stations(1,10).Pos = [44.0000; 261.000; 1.5];
layoutpar.Stations(1,11).Pos = [157.0000; 357.0000; 1.5];
Station_positions = layoutpar.Stations;

    case 'large'
Station_positions = layoutpar.Stations;       
end

% Visualization
NTlayout(layoutpar);


%% Generation of channel matrices
CIR_out = cell(chan_pairing,Ndrops);
newdelays = cell(chan_pairing,Ndrops);

for Nd = 1:Ndrops
    if Nd == 1
        [CIR_in,delays,out] = wim(wimpar,layoutpar);        
            for link_K = 1:chan_pairing            
                [CIR_out{link_K,Nd},~,newdelays{link_K,Nd}] = WINUnpack(CIR_in{link_K},delays(link_K,:), d, Fc, Fs_desired);
            end
        
    else
        [CIR_in,delays,out] = wim(wimpar,layoutpar,out);        
            for link_K = 1:chan_pairing            
                [CIR_out{link_K,Nd},~,newdelays{link_K,Nd}] = WINUnpack(CIR_in{link_K},delays(link_K,:), d, Fc, Fs_desired);
            end         
    end
    disp(['Drop number: ',num2str(Nd),' of: ',int2str(Ndrops),' complete']) 
end
        

%% Save channels
switch save_channels
    case 'y'
        cd(save_path)
        save_name = (['WINNER_channels_',scale,'scale.mat']);
        save(save_name,'CIR_out','newdelays','Station_positions','nlos_los','scenario','Pairing_matrix','Fs_desired');
    case 'n'
end
        
    
    









