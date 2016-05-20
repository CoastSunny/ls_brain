%f=[10 15 20];

% Phi1=singen(f,30,360);
% s1=sin([Phi1]*Ts);
% L=numel(s1);
% Fs=60;
% NFFT=2^nextpow2(L);
% freqs=Fs/2*linspace(0,1,NFFT/2+1);
% 
% S1=fft(s1,NFFT)/L;
% fS1=abs(S1);
% fS1=fS1(1:NFFT/2+1);
% figure,plot(freqs,fS1);
% 
% Phi2=singen(f,60,360);
% s2=sin([Phi2]*Ts);
% L=numel(s2);
% Fs=60;
% NFFT=2^nextpow2(L);
% freqs=Fs/2*linspace(0,1,NFFT/2+1);
% 
% S2=fft(s2,NFFT)/L;
% fS2=abs(S2);
% fS2=fS2(1:NFFT/2+1);
% figure,plot(freqs,fS2);
% 
% Phi3=singen(f,120,360);
% s3=sin([Phi3]*Ts);
% L=numel(s3);
% Fs=60;
% NFFT=2^nextpow2(L);
% freqs=Fs/2*linspace(0,1,NFFT/2+1);
% 
% S3=fft(s3,NFFT)/L;
% fS3=abs(S3);
% fS3=fS3(1:NFFT/2+1);
% figure,plot(freqs,fS3);

% out1=S.default.plot('classes',{51},'channels',7:10,'method','fft','badrem','no');
% out2=S.default.plot('classes',{52},'channels',7:10,'method','fft','badrem','no');
% out3=S.default.plot('classes',{53},'channels',7:10,'method','fft','badrem','no');
% 
% fX1=mean(out1.power);
% fX2=mean(out2.power);
% fX3=mean(out3.power);
% figure,hold on,plot(out1.freqs,fX1,'r'),plot(out2.freqs,fX2,'g'),plot(out3.freqs,fX3,'b')
% figure,hold on,plot(freqs,fS1,'r'),plot(freqs,fS2,'g'),plot(freqs,fS3,'b')


ch=3:10;
nF=1;
out0=S.default.plot('classes',{50},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out0b=S0.default.plot('classes',{50},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out1=S.default.plot('classes',{51},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out1b=S0.default.plot('classes',{51},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out2=S.default.plot('classes',{52},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out2b=S0.default.plot('classes',{52},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out3=S.default.plot('classes',{53},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out3b=S0.default.plot('classes',{53},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out4=S.default.plot('classes',{54},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');
out4b=S0.default.plot('classes',{54},'channels',ch,'method','fft2','badrem','no','nF',nF,'trials','all');

fX0=mean(out0.power);%-mean(out0b.power);
fX1=mean(out1.power);%-mean(out1b.power);
fX2=mean(out2.power);%-mean(out2b.power);
fX3=mean(out3.power);%-mean(out3b.power);
fX4=mean(out4.power);%-mean(out4b.power);
figure,hold on,plot(out0.freqs,fX0,'k'),plot(out1.freqs,fX1,'r'),plot(out2.freqs,fX2,'g'),plot(out3.freqs,fX3,'b'),plot(out4.freqs,fX4,'m')
%figure,hold on,plot(out4.freqs,fX4,'m')

% o1=S.default.plot('classes',{51},'channels',7:10,'badrem','no');
% o2=S.default.plot('classes',{52},'channels',7:10,'badrem','no');
% o3=S.default.plot('classes',{53},'channels',7:10,'badrem','no');
% figure,tfestimate(subsample(o1.avg,360),s1)
% figure,tfestimate(subsample(o2.avg,360),s2)
% figure,tfestimate(subsample(o3.avg,360),s3)

figure
plot(out4.freqs,mean(out0.power))
hold on
plot(out4.freqs,mean(out0b.power),'r')
axis([ 6 30 0.2 2])
addarrows
figure
plot(out4.freqs,mean(out1b.power),'r')
hold on
plot(out4.freqs,mean(out1.power))
axis([ 6 30 0.2 2])
addarrows
figure
plot(out4.freqs,mean(out2b.power),'r')
hold on
plot(out4.freqs,mean(out2.power))
axis([ 6 30 0.2 2])
addarrows
figure
plot(out4.freqs,mean(out3b.power),'r')
hold on
plot(out4.freqs,mean(out3.power))
axis([ 6 30 0.2 2])
addarrows
figure
plot(out4.freqs,mean(out4b.power),'r')
hold on
plot(out4.freqs,mean(out4.power))
axis([ 6 30 0.2 2])
addarrows

