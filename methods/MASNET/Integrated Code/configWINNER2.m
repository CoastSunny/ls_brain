% CNA 24/10/2016
% Configuration file. Each input parameter can be defined here. Any line that starts with % is a comment line and will not be read by the MATLAB script (except the first 4 lines of this file). The name and value of each variable needs to be separated by a ;

clear all

%
cfg.snrfolder='~/Documents/projects/ls_brain/results/masnet/snr/';
cfg.probsfolder='~/Documents/projects/ls_brain/results/masnet/probs/';
%
cfg.filename='_icassp_';

% Number of sensors
cfg.Num_sensors=100;

% Expected power transmitted by the target {in dBW}. Currently this is not taken as input
cfg.Pt=-33;

% Number of samples along the time of observation of the channel
cfg.Time_samples=1;

% Number of runs in the Montecarlo simulation
cfg.N_monte=50;

% The rate of false alarm where a sensor says it detected by it did not
cfg.Pfa=0.1;

% Carrier frequency {in Hz}
cfg.Fc=2.4e9;

% Sets the type of scenario: 0=Separated Enemy and Friend zones, 1=Mixed zones
cfg.Type_Scenario=1;

% Sets the type of environment: 0=urban, 1=rural
cfg.Type_Environment=0;

% Total size of the scenarion to simulate {in metres}. The value will define the side of the squared scenario 
cfg.Size_Scenario=2000;

% Horizontal size of the ENEMY zone {in metres}
cfg.Size_EZ_x=200;

% Vertical size of the ENEMY zone {in metres}
cfg.Size_EZ_y=200;

% Horizontal size of the FRIEND zone 1 {in metres}
cfg.Size_FZ1_x=200;

% Vertical size of the FRIEND zone 1 {in metres}
cfg.Size_FZ1_y=2000;

% Horizontal size of the FRIEND zone 2 {in metres}
cfg.Size_FZ2_x=1800;

% Vertical size of the FRIEND zone 2 {in metres}
cfg.Size_FZ2_y=200;

% Distance between sensors {in metres}
cfg.Sep_sensors=500;

% Height of the sensors {in metres}
cfg.hs=1.5;

% Height of the target {in metres}
cfg.ht=3;

% Velocity of the sensors {in metres/second}. Cannot be 0. Currently it is not taking this input.
cfg.Vel_sensors=0.01;

% Velocity of the target {in metres/second}. Cannot be 0. Currently it is not taking this input.
cfg.Vel_target=0.01;

% Distance between antenna elements in the array {in metres}. Could be changed to be {in lambda}. Currently it is not taking this input
cfg.dist=0.0625;

% Number of values to evaluate the azimuth angle for antenna pattern.
cfg.NAz=120;

% Shift of the antenna orientation {in degrees}
cfg.Antenna_slant=0;

% Defines the oversampling factor when calculating the CIR values. Important to be high to account for the Doppler effect.
cfg.Sample_Density=64;

% Desired sampling frequency {in Hz}. Depends on the bandwidth of the expected WIFI or LTE signal
cfg.Fs=30.72e6;

% Sets how much the target is moved in the horizontal space within the ENEMY zone {in metres}. The smaller this value the smaller the area where a specific value of probability and BER is calculated
cfg.Int_target_x=500;

% Sets how much the target is moved in the vertical space within the ENEMY zone {in metres}. The smaller this value the smaller the area where a specific value of probability and BER is calculated
cfg.Int_target_y=500;

% SIGMA value for the shadowing model {in dB}. Set 0 for no random shadowing
cfg.sigm=9;

% Empirical coefficient for the free space path loss calculation. It can be from 2.7 to 3.5 for urban scenarios, and 2 for rural
cfg.n=3;

% Pre-defined distance set as a critical distance for calculating the free space path loss {in metres}. It can be from 200 metres to 1000 metres in outdoors
cfg.d_0=200;

% Expected signal bandwidth in Hz
cfg.BW=20e6;

% Noise figure of the RF receiver {in dB}
cfg.NF=3.5;

% Number of samples that forms the cyclic prefix. It depends on the bandwidth of the LTE or WIFI signal
cfg.Tc=144;

% Number of samples that forms the data. It depends on the bandwidth of the LTE or WIFI signal
cfg.Td=2048;

% Autocorrelation sample coefficient. It indicates how many LTE traces have been taken. The bigger it is the more samples are taken for the autocorrelation.
cfg.AC_sample=6;






