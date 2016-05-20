Fs=360;
NFFT=1024;
freq=Fs/2*linspace(0,1,NFFT/2+1);

cz12=[1 zeros(1,29)];
cz15=[1 zeros(1,23)];
cz20=[1 zeros(1,17)];
Cz12=repmat(cz12,1,24);
Cz15=repmat(cz15,1,30);
Cz20=repmat(cz20,1,40);
FCz12=abs(fft(Cz12,nfftcz));
FCz15=abs(fft(Cz15,nfftcz));
FCz20=abs(fft(Cz20,nfftcz));
% figure,hold on,stem(Cz12,'r'),stem(Cz15,'g'),stem(Cz20,'b')
figure,plot(freq,FCz12(1:NFFT/2+1),'r-')
figure,plot(freq,FCz15(1:NFFT/2+1),'g-.')
figure,plot(freq,FCz20(1:NFFT/2+1),'b:')
for i=1:15
   
   z=responses(i,:,2); 
   Fz=abs(fft(z,1024)); 
   FFF12=Fz.*FCz12;
   FFF15=Fz.*FCz15;
   FFF20=Fz.*FCz20;
   figure,hold on,plot(freq,FFF12(1:NFFT/2+1),'r-','Linewidth',3),...
       plot(freq,FFF15(1:NFFT/2+1),'g-.','Linewidth',3),...
       plot(freq,FFF20(1:NFFT/2+1),'b:','Linewidth',3),plot(freq,30*Fz(1:NFFT/2+1),'k','Linewidth',3)
    grid
    legend({'12' '15' '20' 'transient'})
    xlabel('Hz')
    ylabel('|FFT|')
end