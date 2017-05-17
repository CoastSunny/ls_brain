% Calculations based on stored results from phase simulations &
% measurements.
clear
cdir = cd;


%% Calculation paramters.

% Number of samples from each measurement set to analyse (determined by inspection).
% N_samples_May = 4000;
% N_samples_Sep = 3500;

N_samples_May = 3000 - 1;
N_samples_Sep = 3000 - 1;


%% Calculation paramters.


% Number of probe antennas (to average out receive powers).
N_probes = 4;

% Number of probe channels.
N_probe_channels = 3;

% Number of transmitters (to correct Tx power per Tx RF chain vs total Tx power from array).
NTx = 2;

% Nbins for pdfs
Nbins = 50;

% User distance from laptop/distance from the emmiter.
U_d = 0.5;

% Carrier frequency.
Fc = 2.3e9;
lambda = 3e8/Fc;

% Desired Tx power from each Tx
tx_total = 23;
tx_Power_desired = tx_total - 10*log10(NTx);

% Antenna gains
G_Tx = 2.3;
G_probe = 2.3;
G_probe_lin = 10^(G_probe/10);

% EIRP across the entire array
% (Normalisation to unity of measurements means average across probes and total power is split between Tx antennas whose individual antennas gains are removed) 

P_rad = tx_Power_desired + G_Tx;

% Power density conversion factor.
PD_convert = (4*pi)/((lambda^2)*G_probe_lin);

% Number of concatenated files (the batch processing of the SAR Codes
% results -- not needed for null steering)

N_cat = 3;

% Technique

Tx_signal_type = 'Null Steering';  % 'Null Steering', 'SARCode', or 'SAR_hybrid'


%% Load post processed measurements and give appropriate names to results.


% Load sounder settings -- common to both signal types.

cd('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014');
Results_desk_static = load('LEXNET_15May2014Desk1.mat');
sounderSettings_May = Results_desk_static.sounderSettings;

cd('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014');        
Results_BackPat = load('LEXNET_03Sep2014BackPat.mat');
sounderSettings_Sep = Results_BackPat.sounderSettings;


switch Tx_signal_type 
    
    case 'Null Steering'

cd('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014');
Results_desk_static = load('LEXNET_15May2014Desk1.mat');
Results_desk_dynamic = load('LEXNET_15May2014Desk2.mat');
Results_bench_static = load('LEXNET_15May2014Bench1.mat');
Results_bench_dynamic = load('LEXNET_15May2014Bench2.mat');
Results_farbench_static = load('LEXNET_15May2014FarBench1.mat');
Results_farbench_dynamic = load('LEXNET_15May2014FarBench2.mat');



cd('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014');        
%Results_BackPat = load('LEXNET_03Sep2014BackTim.mat');
Results_FrontPat = load('LEXNET_03Sep2014FrontPat.mat');
Results_LeftEdgePat = load('LEXNET_03Sep2014LeftEdgePat.mat');
Results_RightEdgePat = load('LEXNET_03Sep2014RightEdgePat.mat');
Results_LeftPat = load('LEXNET_03Sep2014LeftPat.mat');
Results_RightPat = load('LEXNET_03Sep2014RightPat.mat');






% Probe channels.
Rx_power{1} = Results_desk_static.Power_P1_probe;
Rx_power{2} = Results_desk_static.Power_P2_probe;
Rx_power{3} = Results_desk_static.Power_P3_probe;

Rx_power{4} = Results_desk_dynamic.Power_P1_probe;
Rx_power{5} = Results_desk_dynamic.Power_P2_probe;
Rx_power{6} = Results_desk_dynamic.Power_P3_probe;

Rx_power{7} = Results_bench_static.Power_P1_probe;
Rx_power{8} = Results_bench_static.Power_P2_probe;
Rx_power{9} = Results_bench_static.Power_P3_probe;

Rx_power{10} = Results_bench_dynamic.Power_P1_probe;
Rx_power{11} = Results_bench_dynamic.Power_P2_probe;
Rx_power{12} = Results_bench_dynamic.Power_P3_probe;

Rx_power{13} = Results_farbench_static.Power_P1_probe;
Rx_power{14} = Results_farbench_static.Power_P2_probe;
Rx_power{15} = Results_farbench_static.Power_P3_probe;

Rx_power{16} = Results_farbench_dynamic.Power_P1_probe;
Rx_power{17} = Results_farbench_dynamic.Power_P2_probe;
Rx_power{18} = Results_farbench_dynamic.Power_P3_probe;




% Access point channels.
Rx_power{19} = Results_desk_static.Power_P1_AP;
Rx_power{20} = Results_desk_static.Power_P2_AP;
Rx_power{21} = Results_desk_static.Power_P3_AP;

Rx_power{22} = Results_desk_dynamic.Power_P1_AP;
Rx_power{23} = Results_desk_dynamic.Power_P2_AP;
Rx_power{24} = Results_desk_dynamic.Power_P3_AP;

Rx_power{25} = Results_bench_static.Power_P1_AP;
Rx_power{26} = Results_bench_static.Power_P2_AP;
Rx_power{27} = Results_bench_static.Power_P3_AP;

Rx_power{28} = Results_bench_dynamic.Power_P1_AP;
Rx_power{29} = Results_bench_dynamic.Power_P2_AP;
Rx_power{30} = Results_bench_dynamic.Power_P3_AP;

Rx_power{31} = Results_farbench_static.Power_P1_AP;
Rx_power{32} = Results_farbench_static.Power_P2_AP;
Rx_power{33} = Results_farbench_static.Power_P3_AP;

Rx_power{34} = Results_farbench_dynamic.Power_P1_AP;
Rx_power{35} = Results_farbench_dynamic.Power_P2_AP;
Rx_power{36} = Results_farbench_dynamic.Power_P3_AP;


% Only probe channels needed for Sep campaign.

Rx_power{37} = Results_FrontPat.Power_P1_probe;
Rx_power{38} = Results_FrontPat.Power_P2_probe;
Rx_power{39} = Results_FrontPat.Power_P3_probe;

Rx_power{40} = Results_RightEdgePat.Power_P1_probe;
Rx_power{41} = Results_RightEdgePat.Power_P2_probe;
Rx_power{42} = Results_RightEdgePat.Power_P3_probe;

Rx_power{43} = Results_RightPat.Power_P1_probe;
Rx_power{44} = Results_RightPat.Power_P2_probe;
Rx_power{45} = Results_RightPat.Power_P3_probe;

% LEXNET_03Sep2014TimBackP1MIMO_OFDM_copy.mat

Rx_power{46} = [];
Rx_power{47} = [];
Rx_power{48} = [];

%LEXNET_03Sep2014TimBackP3Null_Steering.mat

for b = 1:3
BackPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014TimBackP');
Rx_power_temp = load([BackPatLoad,int2str(b),'Null_Steering.mat'],'Power_P1_probe');
Rx_power{46} = cat(2,Rx_power{46}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([BackPatLoad,int2str(b),'Null_Steering.mat'],'Power_P2_probe');
Rx_power{47} = cat(2,Rx_power{47}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([BackPatLoad,int2str(b),'Null_Steering.mat'],'Power_P3_probe');
Rx_power{48} = cat(2,Rx_power{48}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];

end





Rx_power{49} = Results_LeftPat.Power_P1_probe;
Rx_power{50} = Results_LeftPat.Power_P2_probe;
Rx_power{51} = Results_LeftPat.Power_P3_probe;

Rx_power{52} = Results_LeftEdgePat.Power_P1_probe;
Rx_power{53} = Results_LeftEdgePat.Power_P2_probe;
Rx_power{54} = Results_LeftEdgePat.Power_P3_probe;



    case 'SARCode'
        
% Load the sounder settings.

         

Entire_SAR = load('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_3SARCode.mat');        
Bench_static_part1 = load('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_1SARCode.mat');

 
% Probe channels (note: the order is different for the case of null
% steering). -- Can this be changed/rectified?


% Bench
Rx_power{1} = cat(2, Bench_static_part1.Power_P1_probe, Entire_SAR.Power_P1_probe(:,1:2000));       
Rx_power{2} = cat(2, Bench_static_part1.Power_P2_probe, Entire_SAR.Power_P2_probe(:,1:2000));
Rx_power{3} = cat(2, Bench_static_part1.Power_P3_probe, Entire_SAR.Power_P3_probe(:,1:2000)); 

Rx_power{4} = cat(2, Bench_static_part1.Power_P1_probe, Entire_SAR.Power_P1_probe(:,2001:5000));       
Rx_power{5} = cat(2, Bench_static_part1.Power_P2_probe, Entire_SAR.Power_P2_probe(:,2001:5000));
Rx_power{6} = cat(2, Bench_static_part1.Power_P3_probe, Entire_SAR.Power_P3_probe(:,2001:5000));


%  Far Bench
Rx_power{7} = Entire_SAR.Power_P1_probe(:,11001:14000);
Rx_power{8} = Entire_SAR.Power_P2_probe(:,11001:14000);
Rx_power{9} = Entire_SAR.Power_P3_probe(:,11001:14000);

Rx_power{10} = Entire_SAR.Power_P1_probe(:,14001:17000);
Rx_power{11} = Entire_SAR.Power_P2_probe(:,14001:17000);
Rx_power{12} = Entire_SAR.Power_P3_probe(:,14001:17000);

% Desk
Rx_power{13} = Entire_SAR.Power_P1_probe(:,5001:8000);
Rx_power{14} = Entire_SAR.Power_P2_probe(:,5001:8000);
Rx_power{15} = Entire_SAR.Power_P3_probe(:,5001:8000);

Rx_power{16} = Entire_SAR.Power_P1_probe(:,8001:11000);
Rx_power{17} = Entire_SAR.Power_P2_probe(:,8001:11000);
Rx_power{18} = Entire_SAR.Power_P3_probe(:,8001:11000);




% Access point channels.

% Bench
Rx_power{19} = cat(2, Bench_static_part1.Power_P1_AP, Entire_SAR.Power_P1_AP(:,1:2000));       
Rx_power{20} = cat(2, Bench_static_part1.Power_P2_AP, Entire_SAR.Power_P2_AP(:,1:2000));
Rx_power{21} = cat(2, Bench_static_part1.Power_P3_AP, Entire_SAR.Power_P3_AP(:,1:2000)); 

Rx_power{22} = cat(2, Bench_static_part1.Power_P1_AP, Entire_SAR.Power_P1_AP(:,2001:5000));       
Rx_power{23} = cat(2, Bench_static_part1.Power_P2_AP, Entire_SAR.Power_P2_AP(:,2001:5000));
Rx_power{24} = cat(2, Bench_static_part1.Power_P3_AP, Entire_SAR.Power_P3_AP(:,2001:5000)); 


%  Desk
Rx_power{25} = Entire_SAR.Power_P1_AP(:,11001:14000);
Rx_power{26} = Entire_SAR.Power_P2_AP(:,11001:14000);
Rx_power{27} = Entire_SAR.Power_P3_AP(:,11001:14000);

Rx_power{28} = Entire_SAR.Power_P1_AP(:,14001:17000);
Rx_power{29} = Entire_SAR.Power_P2_AP(:,14001:17000);
Rx_power{30} = Entire_SAR.Power_P3_AP(:,14001:17000);


% Far Bench
Rx_power{31} = Entire_SAR.Power_P1_AP(:,5001:8000);
Rx_power{32} = Entire_SAR.Power_P2_AP(:,5001:8000);
Rx_power{33} = Entire_SAR.Power_P3_AP(:,5001:8000);

Rx_power{34} = Entire_SAR.Power_P1_AP(:,8001:11000);
Rx_power{35} = Entire_SAR.Power_P2_AP(:,8001:11000);
Rx_power{36} = Entire_SAR.Power_P3_AP(:,8001:11000);



%Only probe channels needed for Sep campaign.


Rx_power_temp = [];
Rx_power{37} = [];
Rx_power{38} = [];
Rx_power{39} = [];
Rx_power{40} = [];
Rx_power{41} = [];
Rx_power{42} = [];
Rx_power{43} = [];
Rx_power{44} = [];
Rx_power{45} = [];
Rx_power{46} = [];
Rx_power{47} = [];
Rx_power{48} = [];
Rx_power{49} = [];
Rx_power{50} = [];
Rx_power{51} = [];
Rx_power{52} = [];
Rx_power{53} = [];
Rx_power{54} = [];




for b = 1:N_cat

FrontPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatFrontP');
Rx_power_temp = load([FrontPatLoad,int2str(b),'SARCode.mat'],'Power_P1_probe');
Rx_power{37} = cat(2,Rx_power{37}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([FrontPatLoad,int2str(b),'SARCode.mat'],'Power_P2_probe');
Rx_power{38} = cat(2,Rx_power{38}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([FrontPatLoad,int2str(b),'SARCode.mat'],'Power_P3_probe');
Rx_power{39} = cat(2,Rx_power{39}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];


RightEdgePatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatRightEdgeP');
Rx_power_temp = load([RightEdgePatLoad,int2str(b),'SARCode.mat'],'Power_P1_probe');
Rx_power{40} = cat(2,Rx_power{40}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightEdgePatLoad,int2str(b),'SARCode.mat'],'Power_P2_probe');
Rx_power{41} = cat(2,Rx_power{41}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightEdgePatLoad,int2str(b),'SARCode.mat'],'Power_P3_probe');
Rx_power{42} = cat(2,Rx_power{42}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



RightPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatRightP');
Rx_power_temp = load([RightPatLoad,int2str(b),'SARCode.mat'],'Power_P1_probe');
Rx_power{43} = cat(2,Rx_power{43}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightPatLoad,int2str(b),'SARCode.mat'],'Power_P2_probe');
Rx_power{44} = cat(2,Rx_power{44}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightPatLoad,int2str(b),'SARCode.mat'],'Power_P3_probe');
Rx_power{45} = cat(2,Rx_power{45}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



BackPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatBackP');
Rx_power_temp = load([BackPatLoad,int2str(b),'SARCode.mat'],'Power_P1_probe');
Rx_power{46} = cat(2,Rx_power{46}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([BackPatLoad,int2str(b),'SARCode.mat'],'Power_P2_probe');
Rx_power{47} = cat(2,Rx_power{47}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([BackPatLoad,int2str(b),'SARCode.mat'],'Power_P3_probe');
Rx_power{48} = cat(2,Rx_power{48}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];


LeftPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatLeftP');
Rx_power_temp = load([LeftPatLoad,int2str(b),'SARCode.mat'],'Power_P1_probe');
Rx_power{49} = cat(2,Rx_power{49}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftPatLoad,int2str(b),'SARCode.mat'],'Power_P2_probe');
Rx_power{50} = cat(2,Rx_power{50}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftPatLoad,int2str(b),'SARCode.mat'],'Power_P3_probe');
Rx_power{51} = cat(2,Rx_power{51}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];


LeftEdgePatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatLeftEdgeP');
Rx_power_temp = load([LeftEdgePatLoad,int2str(b),'SARCode.mat'],'Power_P1_probe');
Rx_power{52} = cat(2,Rx_power{52}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftEdgePatLoad,int2str(b),'SARCode.mat'],'Power_P2_probe');
Rx_power{53} = cat(2,Rx_power{53}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftEdgePatLoad,int2str(b),'SARCode.mat'],'Power_P3_probe');
Rx_power{54} = cat(2,Rx_power{54}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];

end



    case 'SAR_hybrid'

 
Rx_power_temp = [];
Rx_power{1} = [];
Rx_power{2} = [];
Rx_power{3} = [];
Rx_power{4} = [];
Rx_power{5} = [];
Rx_power{6} = [];
Rx_power{7} = [];
Rx_power{8} = [];
Rx_power{9} = [];
Rx_power{10} = [];
Rx_power{11} = [];
Rx_power{12} = [];
Rx_power{13} = [];
Rx_power{15} = [];
Rx_power{16} = [];
Rx_power{17} = [];
Rx_power{18} = [];
Rx_power{19} = [];
Rx_power{20} = [];
Rx_power{21} = [];
Rx_power{22} = [];
Rx_power{23} = [];
Rx_power{24} = [];
Rx_power{25} = [];
Rx_power{26} = [];
Rx_power{27} = [];
Rx_power{28} = [];
Rx_power{29} = [];
Rx_power{30} = [];
Rx_power{31} = [];
Rx_power{32} = [];
Rx_power{33} = [];
Rx_power{34} = [];
Rx_power{35} = [];
Rx_power{36} = [];
Rx_power{37} = [];
Rx_power{38} = [];
Rx_power{39} = [];
Rx_power{40} = [];
Rx_power{41} = [];
Rx_power{42} = [];
Rx_power{43} = [];
Rx_power{44} = [];
Rx_power{45} = [];
Rx_power{46} = [];
Rx_power{47} = [];
Rx_power{48} = [];
Rx_power{49} = [];
Rx_power{50} = [];
Rx_power{51} = [];
Rx_power{52} = [];
Rx_power{53} = [];
Rx_power{54} = [];
       
        
        
        
for b = 1:N_cat

% Probes: Desk, Bench, FarBench -- Same order as null steering.
        
Desk_stat_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_';
Rx_power_temp = load([Desk_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');

Rx_power{1} = cat(2,Rx_power{1}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([Desk_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{2} = cat(2,Rx_power{2}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([Desk_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{3} = cat(2,Rx_power{3}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



Desk_dyn_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_';
Rx_power_temp = load([Desk_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');

Rx_power{4} = cat(2,Rx_power{4}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([Desk_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{5} = cat(2,Rx_power{5}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([Desk_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{6} = cat(2,Rx_power{6}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



Bench_stat_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_';
Rx_power_temp = load([Bench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');

Rx_power{7} = cat(2,Rx_power{7}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([Bench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{8} = cat(2,Rx_power{8}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([Bench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{9} = cat(2,Rx_power{9}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



Bench_dyn_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_';
Rx_power_temp = load([Bench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');

Rx_power{10} = cat(2,Rx_power{10}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([Bench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{11} = cat(2,Rx_power{11}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([Bench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{12} = cat(2,Rx_power{12}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];





FarBench_stat_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_';
Rx_power_temp = load([FarBench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');

Rx_power{13} = cat(2,Rx_power{13}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{14} = cat(2,Rx_power{14}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{15} = cat(2,Rx_power{15}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



FarBench_dyn_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_';
Rx_power_temp = load([FarBench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');

Rx_power{16} = cat(2,Rx_power{16}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{17} = cat(2,Rx_power{17}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{18} = cat(2,Rx_power{18}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];





% Access Point; Desk, Bench, FarBench -- Same order as null steering.
        
Desk_stat_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_';
Rx_power_temp = load([Desk_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_AP');

Rx_power{19} = cat(2,Rx_power{19}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load([Desk_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_AP');
Rx_power{20} = cat(2,Rx_power{20}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load([Desk_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_AP');
Rx_power{21} = cat(2,Rx_power{21}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];


Desk_dyn_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_';
Rx_power_temp = load([Desk_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_AP');

Rx_power{22} = cat(2,Rx_power{22}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load([Desk_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_AP');
Rx_power{23} = cat(2,Rx_power{23}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load([Desk_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_AP');
Rx_power{24} = cat(2,Rx_power{24}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];



Bench_stat_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_';
Rx_power_temp = load([Bench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_AP');

Rx_power{25} = cat(2,Rx_power{25}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load([Bench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_AP');
Rx_power{26} = cat(2,Rx_power{26}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load([Bench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_AP');
Rx_power{27} = cat(2,Rx_power{27}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];


Bench_dyn_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_';
Rx_power_temp = load([Bench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_AP');

Rx_power{28} = cat(2,Rx_power{28}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load([Bench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_AP');
Rx_power{29} = cat(2,Rx_power{29}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load([Bench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_AP');
Rx_power{30} = cat(2,Rx_power{30}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];



FarBench_stat_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_';
Rx_power_temp = load([FarBench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_AP');

Rx_power{31} = cat(2,Rx_power{31}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_AP');
Rx_power{32} = cat(2,Rx_power{32}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_stat_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_AP');
Rx_power{33} = cat(2,Rx_power{33}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];


FarBench_dyn_SARCode_hybrid = 'C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_';
Rx_power_temp = load([FarBench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P1_AP');

Rx_power{34} = cat(2,Rx_power{34}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P2_AP');
Rx_power{35} = cat(2,Rx_power{35}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load([FarBench_dyn_SARCode_hybrid,int2str(b),'SARCode_hybrid.mat'],'Power_P3_AP');
Rx_power{36} = cat(2,Rx_power{36}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];



% September campaign



FrontPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatFrontP');
Rx_power_temp = load([FrontPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');
Rx_power{37} = cat(2,Rx_power{37}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([FrontPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{38} = cat(2,Rx_power{38}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([FrontPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{39} = cat(2,Rx_power{39}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];


RightEdgePatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatRightEdgeP');
Rx_power_temp = load([RightEdgePatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');
Rx_power{40} = cat(2,Rx_power{40}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightEdgePatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{41} = cat(2,Rx_power{41}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightEdgePatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{42} = cat(2,Rx_power{42}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



RightPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatRightP');
Rx_power_temp = load([RightPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');
Rx_power{43} = cat(2,Rx_power{43}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{44} = cat(2,Rx_power{44}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([RightPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{45} = cat(2,Rx_power{45}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



BackPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014TimBackP');
Rx_power_temp = load([BackPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');
Rx_power{46} = cat(2,Rx_power{46}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([BackPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{47} = cat(2,Rx_power{47}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([BackPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{48} = cat(2,Rx_power{48}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];


LeftPatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatLeftP');
Rx_power_temp = load([LeftPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');
Rx_power{49} = cat(2,Rx_power{49}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{50} = cat(2,Rx_power{50}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftPatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{51} = cat(2,Rx_power{51}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];


LeftEdgePatLoad = ('C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_03Sep2014\LEXNET_03Sep2014PatLeftEdgeP');
Rx_power_temp = load([LeftEdgePatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P1_probe');
Rx_power{52} = cat(2,Rx_power{52}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftEdgePatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P2_probe');
Rx_power{53} = cat(2,Rx_power{53}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load([LeftEdgePatLoad,int2str(b),'SARCode_hybrid.mat'],'Power_P3_probe');
Rx_power{54} = cat(2,Rx_power{54}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];



        
end



end

%% Load MIMO OFDM signals for comparison.


Rx_power_temp = [];
Rx_power_MO{1} = [];
Rx_power_MO{2} = [];
Rx_power_MO{3} = [];
Rx_power_MO{4} = [];
Rx_power_MO{5} = [];
Rx_power_MO{6} = [];
Rx_power_MO{7} = [];
Rx_power_MO{8} = [];
Rx_power_MO{9} = [];
Rx_power_MO{10} = [];
Rx_power_MO{11} = [];
Rx_power_MO{12} = [];
Rx_power_MO{13} = [];
Rx_power_MO{15} = [];
Rx_power_MO{16} = [];
Rx_power_MO{17} = [];
Rx_power_MO{18} = [];
Rx_power_MO{19} = [];
Rx_power_MO{20} = [];
Rx_power_MO{21} = [];
Rx_power_MO{22} = [];
Rx_power_MO{23} = [];
Rx_power_MO{24} = [];
Rx_power_MO{25} = [];
Rx_power_MO{26} = [];
Rx_power_MO{27} = [];
Rx_power_MO{28} = [];
Rx_power_MO{29} = [];
Rx_power_MO{30} = [];
Rx_power_MO{31} = [];
Rx_power_MO{32} = [];
Rx_power_MO{33} = [];
Rx_power_MO{34} = [];
Rx_power_MO{35} = [];
Rx_power_MO{36} = [];
Rx_power_MO{37} = [];
Rx_power_MO{38} = [];
Rx_power_MO{39} = [];
Rx_power_MO{40} = [];
Rx_power_MO{41} = [];
Rx_power_MO{42} = [];
Rx_power_MO{43} = [];
Rx_power_MO{44} = [];
Rx_power_MO{45} = [];
Rx_power_MO{46} = [];
Rx_power_MO{47} = [];
Rx_power_MO{48} = [];
Rx_power_MO{49} = [];
Rx_power_MO{50} = [];
Rx_power_MO{51} = [];
Rx_power_MO{52} = [];
Rx_power_MO{53} = [];
Rx_power_MO{54} = [];



for b = 1:N_cat
 
% Desk, Bench, Far Bench.    
Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_probe');
Rx_power_MO{1} = cat(2, Rx_power_MO{1}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_probe');
Rx_power_MO{2} = cat(2, Rx_power_MO{2}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_probe');
Rx_power_MO{3} = cat(2, Rx_power_MO{3}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];
    
    
    

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_probe');
Rx_power_MO{4} = cat(2, Rx_power_MO{4}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = []

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_probe');
Rx_power_MO{5} = cat(2, Rx_power_MO{5}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_probe');
Rx_power_MO{6} = cat(2, Rx_power_MO{24}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];

    
    
    
    
Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_probe');
Rx_power_MO{7} = cat(2, Rx_power_MO{7}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_probe');
Rx_power_MO{8} = cat(2, Rx_power_MO{8}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_probe');
Rx_power_MO{9} = cat(2,Rx_power_MO{9}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = []; 



Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_probe');
Rx_power_MO{10} = cat(2, Rx_power_MO{10}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_probe');
Rx_power_MO{11} = cat(2, Rx_power_MO{11}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_probe');
Rx_power_MO{12} = cat(2, Rx_power_MO{12}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];
    
    
    
    
Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_probe');
Rx_power_MO{13} = cat(2, Rx_power_MO{13}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_probe');
Rx_power_MO{14} = cat(2, Rx_power_MO{14}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_probe');
Rx_power_MO{15} = cat(2, Rx_power_MO{15}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];    
    
    
    
    
Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_probe');
Rx_power_MO{16} = cat(2, Rx_power_MO{16}, Rx_power_temp.Power_P1_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_probe');
Rx_power_MO{17} = cat(2, Rx_power_MO{17}, Rx_power_temp.Power_P2_probe);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_probe');
Rx_power_MO{18} = cat(2, Rx_power_MO{18}, Rx_power_temp.Power_P3_probe);
Rx_power_temp = [];    
    
   

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_AP');
Rx_power_MO{19} = cat(2, Rx_power_MO{19}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_AP');
Rx_power_MO{20} = cat(2, Rx_power_MO{20}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk1_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_AP');
Rx_power_MO{21} = cat(2, Rx_power_MO{21}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];


Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_AP');
Rx_power_MO{22} = cat(2, Rx_power_MO{22}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = []

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_AP');
Rx_power_MO{23} = cat(2, Rx_power_MO{23}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Desk2_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_AP');
Rx_power_MO{24} = cat(2, Rx_power_MO{24}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];



Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_AP');
Rx_power_MO{25} = cat(2, Rx_power_MO{25}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_AP');
Rx_power_MO{26} = cat(2, Rx_power_MO{26}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_AP');
Rx_power_MO{27} = cat(2, Rx_power_MO{27}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];


Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_AP');
Rx_power_MO{28} = cat(2, Rx_power_MO{28}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_AP');
Rx_power_MO{29} = cat(2, Rx_power_MO{29}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014Bench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_AP');
Rx_power_MO{30} = cat(2, Rx_power_MO{30}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];



Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_AP');
Rx_power_MO{31} = cat(2, Rx_power_MO{31}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_AP');
Rx_power_MO{32} = cat(2, Rx_power_MO{32}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench1_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_AP');
Rx_power_MO{33} = cat(2, Rx_power_MO{33}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];


Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P1_AP');
Rx_power_MO{34} = cat(2, Rx_power_MO{34}, Rx_power_temp.Power_P1_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P2_AP');
Rx_power_MO{35} = cat(2, Rx_power_MO{35}, Rx_power_temp.Power_P2_AP);
Rx_power_temp = [];

Rx_power_temp = load(['C:\Users\pc0027\Desktop\Work\MATLAB\Channel_Sounding\LEXNET_15May2014\LEXNET_15May2014FarBench2_',int2str(b),'MIMO_OFDM.mat'],'Power_P3_AP');
Rx_power_MO{36} = cat(2, Rx_power_MO{36}, Rx_power_temp.Power_P3_AP);
Rx_power_temp = [];

end







% Specify significant cell indices of 'Rx_power'.

May_Results_Probe_end = 18;
May_Results_end = 36;
Sep_Results_Start = 37;
Sep_Results_end = 54;


Probe1 = [1:3:16];
Probe2 = [2:3:17];
Probe3 = [3:3:18];

AP1 = [19:3:34];
AP2 = [20:3:35];
AP3 = [21:3:36];

Sep_Probe1 = [37:3:52];
Sep_Probe2 = [38:3:53];
Sep_Probe3 = [39:3:54];

clear Results_*

%% Set gain factors for probe channels - RF cable losses, antenna gains, etc.

% Construct free space path loss and derive indoor 2.45 GHz path loss.
x = [0:0.1:10];     % 0  to 10 metres in 0.1 metre increments

% Check U_d against x, verify existance of point return error.
x_test = find(x == U_d);
if min(size(x_test)) == 0
    error('U_d must be an integer multiple of 0.1 in the range 0 to 10 (metres)')
end

% Free space path loss (FSL).
FSL = 20*log10((4*pi*x/lambda));

% Indoor path loss (IL).
L_0 = FSL(find(x == 1));
IL = L_0 + 13.5*log10(x);


% Normalise probe channels based on FSL and average over NTx and NProbes -- Appropriate correction factor.
Probe_norm_fac_dB = P_rad - FSL(find(x == U_d));
Probe_norm_fac_lin = 10^(Probe_norm_fac_dB/10); % for results in dBm
P_TXPL = 10^((Probe_norm_fac_dB - 30)/10); % for SAR calculations.



%% Correct to desired Tx power based in combination with FSL and calculate SAR.

% Initialise cells/arrays.
Pd = cell(size(Rx_power));
SAR_0 = cell(size(Rx_power));
SARwb = cell(size(Rx_power));
SAR1g = cell(size(Rx_power));
SAR10g = cell(size(Rx_power));
min_angle = cell(size(Rx_power));
probe_norm_fac = zeros(1,May_Results_Probe_end);

min_angle_cat_p1 = [];
min_angle_cat_p2 = [];
min_angle_cat_p3 = [];

min_angle_cat_AP1 = [];
min_angle_cat_AP2 = [];
min_angle_cat_AP3 = [];

Rx_power_cat_p1 = [];
Rx_power_cat_p2 = [];
Rx_power_cat_p3 = [];

Rx_power_cat_AP1 = [];
Rx_power_cat_AP2 = [];
Rx_power_cat_AP3 = [];

Rx_Power_cat_sep_p1 = [];
Rx_Power_cat_sep_p2 = [];
Rx_Power_cat_sep_p3 = [];

EI_child_DI = [];
EI_young_DI = [];
EI_adults_DI = [];
EI_seniors_DI = [];


EI_child_DO = [];
EI_young_DO = [];
EI_adults_DO = [];
EI_seniors_DO = [];

EI_child_NI = [];
EI_young_NI = [];
EI_adults_NI = [];
EI_seniors_NI = [];


EI_child_NO = [];
EI_young_NO = [];
EI_adults_NO = [];
EI_seniors_NO = [];


SARwb_cat_p1 = [];
SAR1g_cat_p1 = [];
SAR10g_cat_p1 = []; 



cd(cdir)



for m = 1:length(Rx_power)
    
    
    
    % The probes from the May campaign -- Normalise to overall average and
    % scale this average to expected path loss.
    if m <= May_Results_Probe_end        
        N_samples = N_samples_May;
        Rx_power{m} = Probe_norm_fac_lin*(Rx_power{m}(:,1:N_samples))/mean(mean(squeeze(Rx_power{m}(:,1:N_samples))));
        Rx_powerPD{m} = PD_convert*P_TXPL*(Rx_power{m}(:,1:N_samples))/mean(mean(squeeze(Rx_power{m}(:,1:N_samples))));
        
        
        % SAR.
        [SAR_0{m}, SARwb{m}, SAR1g{m}, SAR10g{m}] = SARCalc((Rx_powerPD{m}(:,1:N_samples)), Fc);
        [~,min_angle{m}] = min(Rx_power{m}(:,1:N_samples));
        
        % Exposure coeeficient.
        SARwb_norm{m} = SARwb{m}/(10^((P_rad-30)/10)); 
        [EI_child_DI{m}, EI_young_DI{m}, EI_adults_DI{m}, EI_seniors_DI{m}] = UplinkEICalc(SARwb_norm{m}, 34e-9, 'Day_indoor'); 
        [EI_child_DO{m}, EI_young_DO{m}, EI_adults_DO{m}, EI_seniors_DO{m}] = UplinkEICalc(SARwb_norm{m}, 34e-9, 'Day_outdoor');
        [EI_child_NI{m}, EI_young_NI{m}, EI_adults_NI{m}, EI_seniors_NI{m}] = UplinkEICalc(SARwb_norm{m}, 34e-9, 'Night_indoor'); 
        [EI_child_NO{m}, EI_young_NO{m}, EI_adults_NO{m}, EI_seniors_NO{m}] = UplinkEICalc(SARwb_norm{m}, 34e-9, 'Night_outdoor');
        
    
    
    % The access point from the May campaign -- Normalise to overall average.    
    elseif m > May_Results_Probe_end && m < Sep_Results_Start
        N_samples = N_samples_May;       
        Rx_power{m} = Rx_power{m}(:,1:N_samples)/mean(mean(squeeze(Rx_power{m}(:,1:N_samples))));
        
        [SAR_0{m}, SARwb{m}, SAR1g{m}, SAR10g{m}] = SARCalc((Rx_power{m}(:,1:N_samples)), Fc);
        [~,min_angle{m}] = min(Rx_power{m}(:,1:N_samples));
        
    
    % The probes from the September campaign -- Normalise to the case where no phasing technique is applied and the user is in front of laptop.   
    elseif m >= Sep_Results_Start
        N_samples = N_samples_Sep; 
        
        
        if  size(find(Sep_Probe1 == m),2) ~= 0
             Rx_power{m} = Probe_norm_fac_lin*(Rx_power{m}(:,1:N_samples)/mean(mean(squeeze(Rx_power{1}(:,1:N_samples)))));
             
        elseif size(find(Sep_Probe2 == m),2) ~= 0
             Rx_power{m} = Probe_norm_fac_lin*(Rx_power{m}(:,1:N_samples)/mean(mean(squeeze(Rx_power{2}(:,1:N_samples)))));
             
        elseif size(find(Sep_Probe3 == m),2) ~= 0
            Rx_power{m} = Probe_norm_fac_lin*(Rx_power{m}(:,1:N_samples)/mean(mean(squeeze(Rx_power{3}(:,1:N_samples)))));
        end
            
               
        [SAR_0{m}, SARwb{m}, SAR1g{m}, SAR10g{m}] = SARCalc((Rx_power{m}(:,1:N_samples)), Fc);
        [~,min_angle{m}] = min(Rx_power{m}(:,1:N_samples));
       
    end
    

    
end


%% Amalgamate received powers according to probe.




ppp = 0;

for pp = 1:length(Probe1)
    
    ppp = ppp + 1; 
    
    Rx_power_cat_p1 = cat(2,Rx_power_cat_p1, Rx_power{Probe1(ppp)});
    Rx_power_cat_p2 = cat(2,Rx_power_cat_p2, Rx_power{Probe2(ppp)});
    Rx_power_cat_p3 = cat(2,Rx_power_cat_p3, Rx_power{Probe3(ppp)});
    
    % Just for probe pair one.   
    
    SARwb_cat_p1 = cat(2,SARwb_cat_p1, SARwb{Probe1(ppp)});
    SAR1g_cat_p1 = cat(2,SAR1g_cat_p1, SAR1g{Probe1(ppp)});
    SAR10g_cat_p1 = cat(2,SAR10g_cat_p1, SAR10g{Probe1(ppp)});   
    
    Rx_power_cat_AP1 = cat(2,Rx_power_cat_AP1, Rx_power{AP1(ppp)});
    Rx_power_cat_AP2 = cat(2,Rx_power_cat_AP2, Rx_power{AP2(ppp)});
    Rx_power_cat_AP3 = cat(2,Rx_power_cat_AP3, Rx_power{AP3(ppp)});
    
    min_angle_cat_p1 = cat(2,min_angle_cat_p1, min_angle{Probe1(ppp)});
    min_angle_cat_p2 = cat(2,min_angle_cat_p2, min_angle{Probe2(ppp)});
    min_angle_cat_p3 = cat(2,min_angle_cat_p3, min_angle{Probe3(ppp)});
    
    min_angle_cat_AP1 = cat(2,min_angle_cat_AP1, min_angle{AP1(ppp)});
    min_angle_cat_AP2 = cat(2,min_angle_cat_AP2, min_angle{AP2(ppp)});
    min_angle_cat_AP3 = cat(2,min_angle_cat_AP3, min_angle{AP3(ppp)});
    
    Rx_Power_cat_sep_p1 = cat(2,Rx_Power_cat_sep_p1, Rx_power{Sep_Probe1(ppp)});
    Rx_Power_cat_sep_p2 = cat(2,Rx_Power_cat_sep_p2, Rx_power{Sep_Probe2(ppp)});
    Rx_Power_cat_sep_p3 = cat(2,Rx_Power_cat_sep_p3, Rx_power{Sep_Probe3(ppp)});
    
    
end



% Rx_Power_cat_sep_p1 = Rx_Power_cat_sep_p1*Probe_norm_fac_lin;
% Rx_Power_cat_sep_p2 = Rx_Power_cat_sep_p2*Probe_norm_fac_lin;
% Rx_Power_cat_sep_p3 = Rx_Power_cat_sep_p3*Probe_norm_fac_lin;


min_angle_cat_all = cat(2,min_angle_cat_p1,min_angle_cat_p2,min_angle_cat_p3); 
min_angle_cat_all_AP = cat(2,min_angle_cat_AP1,min_angle_cat_AP2,min_angle_cat_AP3); 

%% First order statistical analysis of minimum probe angles: pdfs and histograms.

% PDFs. 

[bin4, min_angle_cat_all_pdf, min_angle_cat_all_fitpdf] = distfitbin(min_angle_cat_all,Nbins,'poisson');
[bin5, min_angle_cat_all_AP_pdf, min_angle_cat_all_AP_fitpdf] = distfitbin(min_angle_cat_all_AP,Nbins,'uniform');

% Histograms.

[bin6, min_angle_cat_all_hist] = hist(min_angle_cat_all, Nbins);
[bin7, min_angle_cat_all_AP_hist] = hist(min_angle_cat_all_AP, Nbins);


%% Determine the phase angle for minimum Rx_power (Probe & AP).

[pdf_max,bin_max] = max(min_angle_cat_all_pdf);
[pdf_max_AP,bin_max_AP] = max(min_angle_cat_all_AP_pdf);
Angle_min = round(bin4(bin_max));

% Another attempt to fit to a poisson pdf.

min_angle_cat_all_fitpdf2 = poisspdf(bin4,Angle_min);


% Change in AP power and exposure.

% DeltaP_Rx_power_cat_AP1 = 10*log10(Rx_power_cat_AP1(1,:)) - 10*log10(Rx_power_cat_AP1(Angle_min,:));
% DeltaP_Rx_power_cat_AP2 = 10*log10(Rx_power_cat_AP2(1,:)) - 10*log10(Rx_power_cat_AP2(Angle_min,:));
% DeltaP_Rx_power_cat_AP3 = 10*log10(Rx_power_cat_AP3(1,:)) - 10*log10(Rx_power_cat_AP3(Angle_min,:));

% DeltaP_Rx_power_cat_p1 = 10*log10(Rx_power_cat_p1(1,:)) - 10*log10(Rx_power_cat_p1(Angle_min,:));
% DeltaP_Rx_power_cat_p2 = 10*log10(Rx_power_cat_p2(1,:)) - 10*log10(Rx_power_cat_p2(Angle_min,:));
% DeltaP_Rx_power_cat_p3 = 10*log10(Rx_power_cat_p3(1,:)) - 10*log10(Rx_power_cat_p3(Angle_min,:));
% 
% DeltaP_Sep_Rx_power_cat_p1 = 10*log10(Rx_Power_cat_sep_p1(1,:)) - 10*log10(Rx_Power_cat_sep_p1(Angle_min,:));
% DeltaP_Sep_Rx_power_cat_p2 = 10*log10(Rx_Power_cat_sep_p2(1,:)) - 10*log10(Rx_Power_cat_sep_p2(Angle_min,:));
% DeltaP_Sep_Rx_power_cat_p3 = 10*log10(Rx_Power_cat_sep_p3(1,:)) - 10*log10(Rx_Power_cat_sep_p3(Angle_min,:));

DeltaP_Rx_power_cat_AP1 = 10*log10(Rx_power_cat_AP1(Angle_min,:));
DeltaP_Rx_power_cat_AP2 = 10*log10(Rx_power_cat_AP2(Angle_min,:));
DeltaP_Rx_power_cat_AP3 = 10*log10(Rx_power_cat_AP3(Angle_min,:));

DeltaP_Rx_power_cat_p1 = 10*log10(Rx_power_cat_p1(Angle_min,:));
DeltaP_Rx_power_cat_p2 = 10*log10(Rx_power_cat_p2(Angle_min,:));
DeltaP_Rx_power_cat_p3 = 10*log10(Rx_power_cat_p3(Angle_min,:));

DeltaP_Sep_Rx_power_cat_p1 = 10*log10(Rx_Power_cat_sep_p1(Angle_min,:));
DeltaP_Sep_Rx_power_cat_p2 = 10*log10(Rx_Power_cat_sep_p2(Angle_min,:));
DeltaP_Sep_Rx_power_cat_p3 = 10*log10(Rx_Power_cat_sep_p3(Angle_min,:));




%% Axis calibrations.

% May campaign.

% x axis - time.
SampleTime_May = sounderSettings_May.ex.cycleInterval;
SampleFreq_May = 1 / SampleTime_May;
t_meas_May = (1/SampleFreq_May)*[0:(N_samples_May - 1)]/60; % in minutes. 
t_meas_cat_May = (1/SampleFreq_May)*[0:(length(min_angle_cat_p1) - 1)]/60; % in minutes

% y axis - angle variation.
a_meas_May = [0:(size(Rx_power{1},1) - 1)];

% Bordering of campaigns - Rx power
min_may_min_DeltaP = min([min(DeltaP_Rx_power_cat_AP1), min(DeltaP_Rx_power_cat_AP2),  min(DeltaP_Rx_power_cat_AP3)]);
max_may_min_DeltaP = max([max(DeltaP_Rx_power_cat_AP1), max(DeltaP_Rx_power_cat_AP2),  max(DeltaP_Rx_power_cat_AP3)]);



% September campaign.

% x axis - time.
SampleTime_Sep = sounderSettings_Sep.ex.cycleInterval;
SampleFreq_Sep = 1 / SampleTime_Sep;
t_meas_Sep = (1/SampleFreq_Sep)*[0:(N_samples_Sep - 1)]/60; % in minutes.
t_meas_cat_Sep = (1/SampleFreq_Sep)*[0:(length(DeltaP_Sep_Rx_power_cat_p1) - 1)]/60; % in minutes


% Bordering of campaigns - Rx power.
min_sep_min_DeltaP = min([min(DeltaP_Sep_Rx_power_cat_p1), min(DeltaP_Sep_Rx_power_cat_p2),  min(DeltaP_Sep_Rx_power_cat_p3)]);
max_sep_min_DeltaP = max([max(DeltaP_Sep_Rx_power_cat_p1), max(DeltaP_Sep_Rx_power_cat_p2),  max(DeltaP_Sep_Rx_power_cat_p3)]);

min_sep_Rx_Power_cat_sep_p1 = 10*log10(min(min(Rx_Power_cat_sep_p1)));
min_sep_Rx_Power_cat_sep_p2 = 10*log10(min(min(Rx_Power_cat_sep_p2)));
min_sep_Rx_Power_cat_sep_p3 = 10*log10(min(min(Rx_Power_cat_sep_p3)));

max_sep_Rx_Power_cat_sep_p1 = 10*log10(max(max(Rx_Power_cat_sep_p1)));
max_sep_Rx_Power_cat_sep_p2 = 10*log10(max(max(Rx_Power_cat_sep_p2)));
max_sep_Rx_Power_cat_sep_p3 = 10*log10(max(max(Rx_Power_cat_sep_p3)));



%% Plots




% figure(1)
% min_angle_cat_p1_plot = plot(t_meas_cat_May, min_angle_cat_p1);
% hold on
% grid on
% line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
% line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
% line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
% line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
% line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
% line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
% xlabel('t_{Meas}, [Mins]','FontSize',34);
% ylabel('\theta, [Degrees]','FontSize',34);
% min_angle_cat_p2_plot = plot(t_meas_cat_May, min_angle_cat_p2,'r');
% min_angle_cat_p3_plot = plot(t_meas_cat_May, min_angle_cat_p3,'g');
% Handles = 0;
% Handles = [min_angle_cat_p1_plot, min_angle_cat_p2_plot, min_angle_cat_p3_plot];
% legend(Handles, 'Probe pair 1','Probe pair 2','Probe pair 3','FontSize',34,'Location','NorthEastOutside');



figure(2)
%DeltaP_Sep_cat_p1_plot = plot(t_meas_cat_Sep, DeltaP_Sep_Rx_power_cat_p1);
hold on
grid on
line([t_meas_cat_Sep(N_samples_Sep) t_meas_cat_Sep(N_samples_Sep)], [min_sep_min_DeltaP max_sep_min_DeltaP]);
line([t_meas_cat_Sep(2*N_samples_Sep) t_meas_cat_Sep(2*N_samples_Sep)], [min_sep_min_DeltaP max_sep_min_DeltaP]);
line([t_meas_cat_Sep(3*N_samples_Sep) t_meas_cat_Sep(3*N_samples_Sep)], [min_sep_min_DeltaP max_sep_min_DeltaP]);
line([t_meas_cat_Sep(4*N_samples_Sep) t_meas_cat_Sep(4*N_samples_Sep)], [min_sep_min_DeltaP max_sep_min_DeltaP]);
line([t_meas_cat_Sep(5*N_samples_Sep) t_meas_cat_Sep(5*N_samples_Sep)], [min_sep_min_DeltaP max_sep_min_DeltaP]);
line([t_meas_cat_Sep(6*N_samples_Sep) t_meas_cat_Sep(6*N_samples_Sep)], [min_sep_min_DeltaP max_sep_min_DeltaP]);
xlabel('t_{Meas}, [Mins]','FontSize',34);
ylabel('Gain, [dB]','FontSize',34);
axis([min(t_meas_cat_Sep), max(t_meas_cat_Sep), min([min(DeltaP_Sep_Rx_power_cat_p2),  min(DeltaP_Sep_Rx_power_cat_p3)]), max([max(DeltaP_Sep_Rx_power_cat_p2),  max(DeltaP_Sep_Rx_power_cat_p3)])]);
DeltaP_Sep_cat_p2_plot = plot(t_meas_cat_Sep, DeltaP_Sep_Rx_power_cat_p2,'r');
DeltaP_Sep_cat_p3_plot = plot(t_meas_cat_Sep, DeltaP_Sep_Rx_power_cat_p3,'g');
Handles = 0;
%Handles = [DeltaP_Sep_cat_p1_plot, DeltaP_Sep_cat_p2_plot,  DeltaP_Sep_cat_p3_plot];
Handles = [DeltaP_Sep_cat_p2_plot,  DeltaP_Sep_cat_p3_plot];
legend(Handles, 'Probe pair 1','Probe pair 2','Probe pair 3','FontSize',34,'Location','NorthEastOutside');


figure(35)
%DeltaP_Rx_power_cat_AP1_plot = plot(t_meas_cat_May, DeltaP_Rx_power_cat_AP1);
hold on
grid on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min_may_min_DeltaP max_may_min_DeltaP]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min_may_min_DeltaP max_may_min_DeltaP]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min_may_min_DeltaP max_may_min_DeltaP]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min_may_min_DeltaP max_may_min_DeltaP]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min_may_min_DeltaP max_may_min_DeltaP]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min_may_min_DeltaP max_may_min_DeltaP]);
xlabel('t_{Meas}, [Mins]','FontSize',34);
ylabel('Gain, [dB]','FontSize',34);
DeltaP_Rx_power_cat_AP2_plot = plot(t_meas_cat_May, DeltaP_Rx_power_cat_AP2,'r');
DeltaP_Rx_power_cat_AP3_plot = plot(t_meas_cat_May, DeltaP_Rx_power_cat_AP3,'g');
axis([min(t_meas_cat_May), max(t_meas_cat_May), min([min(DeltaP_Rx_power_cat_AP2),  min(DeltaP_Rx_power_cat_AP3)]), max([max(DeltaP_Rx_power_cat_AP2),  max(DeltaP_Rx_power_cat_AP3)])]);
Handles = 0;
%Handles = [DeltaP_Rx_power_cat_AP1_plot, DeltaP_Rx_power_cat_AP2_plot,  DeltaP_Rx_power_cat_AP3_plot];
Handles = [DeltaP_Rx_power_cat_AP2_plot,  DeltaP_Rx_power_cat_AP3_plot];
legend(Handles, 'Probe pair 1','Probe pair 2','Probe pair 3','FontSize',34,'Location','NorthEastOutside');


figure(4)
pdf_all_plot = plot(bin4, min_angle_cat_all_pdf, 'b-o','MarkerEdgeColor','b');
hold on
grid on
pdf_all_fit_plot = plot(bin4, min_angle_cat_all_fitpdf2,'r')
plot(bin4(bin_max), pdf_max, 'k*','MarkerSize',10)
line([bin4(bin_max) bin4(bin_max)], [0 pdf_max]);
Handles = 0;
Handles = [pdf_all_plot, pdf_all_fit_plot];
legend(Handles, '\theta_{min} over all scenarios (Probes)');
ylabel('PDF of \theta_{min}', 'FontSize',34);
xlabel('\theta_{min}, [Degrees]','FontSize',34);


figure (5)
FSLplot = plot(x,-FSL,'bs-','MarkerEdgeColor','b','MarkerFaceColor','b')
hold on
grid on
line([U_d U_d], [-FSL(end) -FSL(find(x == U_d))])
Handles = 0;
Handles = [FSLplot];
legend(Handles, 'Free space path loss')
ylabel('Gain, [dB]', 'FontSize',34);
xlabel('Distance, [m]','FontSize',34);


figure (6)

hist(min_angle_cat_all, Nbins)
legend('\theta over all scenarios (ProbesP)');
ylabel('Degrees/bin', 'FontSize',34);
xlabel('\theta, [Degrees]','FontSize',34);

figure (7)

hist(min_angle_cat_all_AP, Nbins)
legend('\theta over all scenarios (AP)');
ylabel('Degrees/bin', 'FontSize',34);
xlabel('\theta, [Degrees]','FontSize',34);


figure (8)

Rx_power_cat_p1_plot = imagesc(t_meas_cat_May, a_meas_May, 10*log10(Rx_power_cat_p1)); 
hold on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
Handles = 0;
Handles = [Rx_power_cat_p1_plot];
colorbar
legend(Handles, 'Probe pair 1','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);


figure (9)

Rx_power_cat_p2_plot = imagesc(t_meas_cat_May, a_meas_May, 10*log10(Rx_power_cat_p2)); 
hold on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
colorbar
Handles = 0;
Handles = [Rx_power_cat_p2_plot];
legend(Handles, 'Probe pair 2','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);

figure (10)

Rx_power_cat_p3_plot = imagesc(t_meas_cat_May, a_meas_May, 10*log10(Rx_power_cat_p3)); 
hold on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
colorbar
Handles = 0;
Handles = [Rx_power_cat_p3_plot];
legend(Handles, 'Probe pair 3','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);



figure (11)

Rx_power_cat_AP1_plot = imagesc(t_meas_cat_May, a_meas_May, 10*log10(Rx_power_cat_AP1)); 
hold on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
Handles = 0;
Handles = [Rx_power_cat_AP1_plot];
colorbar
legend(Handles, 'AP pair 1','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);


figure (12)

Rx_power_cat_AP2_plot = imagesc(t_meas_cat_May, a_meas_May, 10*log10(Rx_power_cat_AP2)); 
hold on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
Handles = 0;
Handles = [Rx_power_cat_AP2_plot];
colorbar
legend(Handles, 'AP pair 2','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);


figure (13)

Rx_power_cat_AP3_plot = imagesc(t_meas_cat_May, a_meas_May, 10*log10(Rx_power_cat_AP3)); 
hold on
line([t_meas_cat_May(N_samples_May) t_meas_cat_May(N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(2*N_samples_May) t_meas_cat_May(2*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(3*N_samples_May) t_meas_cat_May(3*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(4*N_samples_May) t_meas_cat_May(4*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(5*N_samples_May) t_meas_cat_May(5*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_May(6*N_samples_May) t_meas_cat_May(6*N_samples_May)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
Handles = 0;
Handles = [Rx_power_cat_AP3_plot];
colorbar
legend(Handles, 'AP pair 3','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);




figure (14)

Rx_Power_cat_sep_p2_plot = imagesc(t_meas_cat_Sep, a_meas_May, 10*log10(Rx_Power_cat_sep_p2)); 
hold on
line([t_meas_cat_Sep(N_samples_Sep) t_meas_cat_Sep(N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(2*N_samples_Sep) t_meas_cat_Sep(2*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(3*N_samples_Sep) t_meas_cat_Sep(3*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(4*N_samples_Sep) t_meas_cat_Sep(4*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(5*N_samples_Sep) t_meas_cat_Sep(5*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(6*N_samples_Sep) t_meas_cat_Sep(6*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
Handles = 0;
Handles = [Rx_Power_cat_sep_p2_plot];
colorbar
legend(Handles, 'Probe pair 2','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);


figure (15)

Rx_Power_cat_sep_p3_plot = imagesc(t_meas_cat_Sep, a_meas_May, 10*log10(Rx_Power_cat_sep_p3)); 
hold on
line([t_meas_cat_Sep(N_samples_Sep) t_meas_cat_Sep(N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(2*N_samples_Sep) t_meas_cat_Sep(2*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(3*N_samples_Sep) t_meas_cat_Sep(3*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(4*N_samples_Sep) t_meas_cat_Sep(4*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(5*N_samples_Sep) t_meas_cat_Sep(5*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
line([t_meas_cat_Sep(6*N_samples_Sep) t_meas_cat_Sep(6*N_samples_Sep)], [min(a_meas_May) max(a_meas_May)]);
%imagesc(t_meas_May, a_meas_May, 10*log10(Rx_power_cat_p1))
Handles = 0;
Handles = [Rx_Power_cat_sep_p3_plot];
colorbar
legend(Handles, 'Probe pair 3','FontSize',34,'Location','NorthEastOutside');
ylabel('\theta, [Degrees]', 'FontSize',34);
xlabel('t_{Meas}, [Mins]','FontSize',34);



figure (16)

SARwbplot = plot(mean(SARwb_cat_p1,2));
hold on
grid on
xlabel('\theta, [Degrees]','FontSize',34);
ylabel('SAR, [Watts/kg]','FontSize',34)
Handles = 0;
Handles = [SARwbplot];
legend(Handles, 'SARwb' ,'FontSize',34,'Location','SouthEast');


figure (17)

SAR10gplot = plot(mean(SAR10g_cat_p1,2));
hold on
grid on
xlabel('\theta, [Degrees]','FontSize',34);
ylabel('SAR, [Watts/kg]','FontSize',34)
Handles = 0;
Handles = [SAR10gplot];
legend(Handles, 'SAR10g' ,'FontSize',34,'Location','SouthEast');



figure (18)

SAR1gplot = plot(mean(SAR1g_cat_p1,2));
hold on
grid on
xlabel('\theta, [Degrees]','FontSize',34);
ylabel('SAR, [Watts/kg]','FontSize',34)
Handles = 0;
Handles = [SAR1gplot];
legend(Handles, 'SAR1g' ,'FontSize',34,'Location','SouthEast');







