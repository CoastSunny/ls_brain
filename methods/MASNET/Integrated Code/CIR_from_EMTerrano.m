clear all
close all
clc

Num_rays = 12;

CIR = zeros(2,Num_rays);

% Delays (ns)
CIR(1,1) = 3766.393;
CIR(1,2) = 3015.665;
CIR(1,3) = 2018.635;
CIR(1,4) = 2006.761;
CIR(1,5) = 2095.664;
CIR(1,6) = 2021.341;
CIR(1,7) = 3043.253;
CIR(1,8) = 2367.691;
CIR(1,9) = 2561.712;
CIR(1,10) = 2421.914;
CIR(1,11) = 2087.469;
CIR(1,12) = 2006.354;

% Received power (dBm)
CIR(2,1) = -124.568;
CIR(2,2) = -125.085;
CIR(2,3) = -99.497;
CIR(2,4) = -95.480;
CIR(2,5) = -105.247;
CIR(2,6) = -102.078;
CIR(2,7) = -126.092;
CIR(2,8) = -110.453;
CIR(2,9) = -122.589;
CIR(2,10) = -91.824;
CIR(2,11) = -87.423;
CIR(2,12) = -69.629;

% Receiver sensitivity (in dBm)
Psens = -150;

figure(1)
stem(CIR(1,:)./1e3,CIR(2,:)-Psens,'filled','LineWidth',2,'LineStyle','-.')
title('Channel Impulse Response for Link Transmitter-Sensor 1')
xlabel('Time of Flight [\mus]')
ylabel('Normalized Received Power (Pr - Sensitivity) [dB]')
