%% Control of WINNER 2 channel model -- PChambers

% Code written to try to control and experiment with WINNER 2 channel model
% Initially an amalgamtion of, 'example_channel_matrix.m',
% 'example_EADF_approx.m'

%**************************************************************************

clear

%% Paramters

c = 3e8;
Fc = 5.25e9;
chan_pairing = 4;
SectPerBs = 1;
scenario = 3; % A1, A2, B1, B2, B3, B4, B5a, B5c, B5f, C1, C2, C3, D1, D2a 

wimpar=struct(  'range',1,...  
                'end_time',1,...                        % Observation end time for B5 - time points are taken as:  wimpar.TimeVector=linspace(0,wimpar.end_time,T);
                'SampleDensity', 2,...                  % in samples/half-wavelength
                'NumTimeSamples',100,...         
                'UniformTimeSampling','no',... 
                'IntraClusterDsUsed','yes',...          % Two strongest clusters are divided into three subclusters
                'NumSubPathsPerPath',20,...             % only value supported is 20.
                'FixedPdpUsed','no',...                 % Use fixed delays and path powers
                'FixedAnglesUsed','no',...              % Use fixed AoD/AoAs
                'PolarisedArrays','yes',...             % Obsolite - always polarised arrays are used!
                'TimeEvolution','no',...                % use of time evolution option
                'CenterFrequency',Fc,...                % in Herz
                'DelaySamplingInterval',5e-9,...        
                'PathLossModelUsed','no',...            
                'ShadowingModelUsed','no',...           
                'PathLossModel','pathloss',...
                'PathLossOption','CR_light',...         % 'CR_light' or 'CR_heavy' or 'RR_light' or 'RR_heavy', CR = Corridor-Room, RR = Room-Room nlos  
                'RandomSeed',[],...                     % if empty, seed is not set. 
                'UseManualPropCondition','yes');


wimpar.NumTimeSamples=1000;     % 100 time samples per link



%% Array preprocessing -- EADF approximation for antenna patterns.

dist = (c/Fc)*0.5; %lambda/2 spacing
Dists = [dist, dist, dist, dist, dist, dist];
NAz=120; %3 degree sampling interval
Az=linspace(-180,180-1/NAz,NAz);

%% Radiation pattern antenna arrays.

NAz=120; %3 degree sampling interval
Az=linspace(-180,180-1/NAz,NAz);

pattern(1,:,1,:)=dipoleHeba(Az,12); % slanted by 12 degree
%pcode Aperture_Calc 

Arrays(1)=AntennaArray('ULA',2,Dists(1),'FP-ECS',pattern,'Azimuth',Az); %ULA-2 
Arrays(2)=AntennaArray('ULA',4,Dists(2),'FP-ECS',pattern,'Azimuth',Az); %ULA-4 
Arrays(3)=AntennaArray('ULA',8,Dists(3),'FP-ECS',pattern,'Azimuth',Az); %ULA-8 
Arrays(4)=AntennaArray('UCA',4,Dists(4),'FP-ECS',pattern,'Azimuth',Az); %UCA-4 
% Arrays(5)=AntennaArray('UCA',8,Dists(5),'FP-ECS',pattern,'Azimuth',Az); %UCA-8 
% 
% NAz=3*120; %3 degree sampling interval
% Az=linspace(-180,180-1/NAz,NAz);
% pattern=ones(2,2,1,NAz);
% Arrays(6)=AntennaArray('ULA',2,dist,'FP-ECS',pattern); % isotropic antenna





%% Comparison
ar=AntennaResponse(Arrays(1),Az);

for el=1:1 %first element in array
    for pol=1:2
        subplot(1,2,2*(el-1)+pol)
        fp=squeeze(pattern(1,pol,1,:));
        h(1)=polar(Az'*pi/180,fp);
        set(h(1),'LineWidth',2)
        hold on


        h(2)=polar(Az'*pi/180,abs(squeeze(ar{1}(el,pol,:))),'rx');
        set(h(2),'LineWidth',2)
        legend(h,{'original','EADF approx'})
        xlabel({['antenna element: ',int2str(el)];['polarization: ',int2str(pol)]}) 
        hold off
    end %for pol
end %for el


%% Channel Model: generation of 3D-AA has to be performed in pre-processing phase
%Arrays=example_syntetic_arrays;

%% Network layout
MsAAIdx = [1 1 2 3];
BsAAIdxCell = {[1 3]; [2]; [1 1 2]};

%MsAAIdx = [1];
%BsAAIdxCell = {[1];};
layoutpar=layoutparset(MsAAIdx, BsAAIdxCell, chan_pairing, Arrays);
layoutpar.PropagConditionVector=zeros(1,chan_pairing);  % (NLOS=0/LOS=1)
layoutpar.ScenarioVector=scenario*ones(1,chan_pairing);  % B1 scenario
layoutpar.Stations(2).Rot=[0 0 pi]; %Rotate sector array -180
layoutpar.Stations(5).Rot=[0 0 -pi/2]; % 90
layoutpar.Stations(6).Rot=[0 0 2*pi/3]; % -120

% Visualization
%NTlayout(layoutpar);


%% Generation of channel matrix
[H1,delays,out]=wim(wimpar, layoutpar);

%% External initialization of structural parameters in consequtive calls
[H2,delays,out]=wim(wimpar,layoutpar,out);

x_axis1 = [1:20]*5e-9;
x_axis2 = [1:512]*(100e6/512);

sample_in_time = squeeze(H1{1}(1,1,:,1)/max(abs(H1{1}(1,1,:,1))));

figure(2)
plot(x_axis2, squeeze(20*log10(abs(fft(fftshift(sample_in_time),512)))))
xlabel('Frequency, [Hz]')
ylabel('Gain, [dB]')
grid on

figure(3)
plot(x_axis1, squeeze((20*log10(abs(sample_in_time)))),'b-s')
xlabel('Time, [s]')
ylabel('Gain, [dB]')
grid on

