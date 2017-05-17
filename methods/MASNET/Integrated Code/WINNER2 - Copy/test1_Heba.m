clear all
close all
c = 3e8; % speed of light
f = 2e9;
lambda = c/f;
n = 10; % number of sensors
m = 3; % number of transmitters
xt_min=-500;
xt_max=-200;
yt_min=200;
yt_max=500;
T=[(xt_max-xt_min)*rand(m,1)+xt_min,(yt_max-yt_min)*rand(m,1)+yt_min];
xr_min=-200;
xr_max=200;
yr_min=-300;
yr_max=300;
R=[(xr_max-xr_min)*rand(n,1)+xr_min,(yr_max-yr_min)*rand(n,1)+yr_min];
figure(1)
scatter(T(:,1),T(:,2),'rx');
hold on
scatter(R(:,1),R(:,2),'bo');
hold off
title('Location of Targets and sensors')
legend ('Target', 'Sensor')
PtdB=100;  % in dBm
Pt=(10^(PtdB/10))/1000; % in watt
S=4;       % in dB, shadowing standard deviation
Xi_lin=10^(S*randn/10);
d = zeros(n,m);
t = zeros(n,m);
Pr = zeros(n,m);

for mm=1:m
    d = sqrt((T(mm,1)-R(:,1)).^2 + (T(mm,2)-R(:,2)).^2);
    t(:,mm) = d/c;
    h = sqrt(1/2)*(randn(1,1)+1i*randn(1,1));
    Pr(:,mm) = Pt*abs(h).^2*Xi_lin*(lambda^2./(4*pi*d).^2);
end
 figure(2)
 subplot(311)
 stem(t(:,1),Pr(:,1),'m');
 xlabel('Time')
 ylabel('received Power')
 subplot(312)
 stem(t(:,2),Pr(:,2),'g');
 xlabel('Time')
 ylabel('received Power')
 subplot(313)
 stem(t(:,3),Pr(:,3),'c');
 xlabel('Time')
 ylabel('received Power')
 








