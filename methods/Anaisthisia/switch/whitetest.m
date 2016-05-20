tic
%clear all
t=1:1000;
fs=1000;
f1=20;
s1=3*sin(2*pi*t*f1/fs);%+randn(1,1000);

A=5;
B=4;
% s2=A*peak(1000,1,1000,1,200);
% s3=A*peak(1000,1,1000,.5,400);
% s4=A*peak(1000,1,1000,.5,600);
% s5=A*peak(1000,1,1000,2,800);
extra_sources=2;
channels=2;
herd=[1 2 ]';randn(channels,1);

for i=1:1000

%S=[s2;s3];%s4;s5];
S=A*randn(extra_sources,1000);
hother=randn(channels,extra_sources);
%hother=[-1 1]';%; 0 1]';
Xp=[herd hother]*[s1;S];
S=A*randn(extra_sources,1000);
hother=randn(channels,extra_sources);
Xn=[herd hother]*[B*s1;S];

Xp=repop(Xp,'-',mean(Xp,2));
Xn=repop(Xn,'-',mean(Xn,2));

Wp=inv(sqrtm(cov(Xp')));
Wn=inv(sqrtm(cov(Xn')));
 Wp=eye(2);
 Wn=eye(2);

Yp=Wp*Xp;
Yn=Wn*Xn;
% for i=1:channels
% Yp(i,:)=Yp(i,:)/norm(Yp(i,:));
% Yn(i,:)=Yn(i,:)/norm(Yn(i,:));
% end
%figure,hold on,plot(Yn(1,:),'r'),plot(Yp(1,:),'g')
%figure,hold on,plot(Yn(2,:),'r'),plot(Yp(2,:),'g')

NFFT=2^nextpow2(size(Yp,2));
freqs=fs/2*linspace(0,1,NFFT/2+1);

fYp=fft(Yp,1024,2)/size(Yp,2);
fYn=fft(Yn,1024,2)/size(Yn,2);
sel=1:40;
%figure,plot(freqs(sel),abs(fs(sel)))
FYp1(i,:)=abs(fYp(1,sel));
FYp2(i,:)=abs(fYp(2,sel));
% FYp3(i,:)=abs(fYp(3,sel));
% FYp4(i,:)=abs(fYp(4,sel));
% FYp5(i,:)=abs(fYp(5,sel));

% FYp3(i,:)=abs(fYp(3,sel));
FYn1(i,:)=abs(fYn(1,sel));
FYn2(i,:)=abs(fYn(2,sel));
% FYn3(i,:)=abs(fYn(3,sel));
% FYn4(i,:)=abs(fYn(4,sel));
% FYn5(i,:)=abs(fYn(5,sel));

% FYn3(i,:)=abs(fYn(2,sel));
WP(:,:,i)=Wp;
WN(:,:,i)=Wn;
pr(i,:)=norm(B*s1)/(norm(S,'fro'));
end

h1=figure,hold on,plot(freqs(sel),mean(FYn1,1),'r'),plot(freqs(sel),mean(FYp1,1),'g')%,axis([0 40 0 0.6])

title(['Channel 1 with ERD ' num2str(B)...
    ' times bigger at the no-movement class and ' num2str(extra_sources) ' extra sources.'...
    'Power of ERD/power of interference=' num2str(mean(pr))])
xlabel('Hz'),ylabel('PSD')

h2=figure,hold on,plot(freqs(sel),mean(FYn2,1),'r'),plot(freqs(sel),mean(FYp2,1),'g')%,axis([0 40 0 0.6])

title(['Channel 2 with ERD ' num2str(B)...
    ' times bigger at the no-movement class and ' num2str(extra_sources) ' extra sources.'...
    'Power of ERD/power of interference=' num2str(mean(pr))])
xlabel('Hz'),ylabel('PSD')

% h3=figure,hold on,plot(freqs(sel),mean(FYn3,1),'r'),plot(freqs(sel),mean(FYp3,1),'g'),axis([0 40 0 0.6])
% 
% title(['Channel 3 with ERD ' num2str(B)...
%     ' times bigger at the no-movement class and ' num2str(extra_sources) ' extra sources.'...
%     'Power of ERD/power of interference=' num2str(mean(pr))])
% xlabel('Hz'),ylabel('PSD')
% 
% h4=figure,hold on,plot(freqs(sel),mean(FYn4,1),'r'),plot(freqs(sel),mean(FYp4,1),'g'),axis([0 40 0 0.6])
% 
% title(['Channel 4 with ERD ' num2str(B)...
%     ' times bigger at the no-movement class and ' num2str(extra_sources) ' extra sources.'...
%     'Power of ERD/power of interference=' num2str(mean(pr))])
% xlabel('Hz'),ylabel('PSD')
% 
% h5=figure,hold on,plot(freqs(sel),mean(FYn5,1),'r'),plot(freqs(sel),mean(FYp5,1),'g'),axis([0 40 0 0.6])
% 
% title(['Channel 5 with ERD ' num2str(B)...
%     ' times bigger at the no-movement class and ' num2str(extra_sources) ' extra sources.'...
%     'Power of ERD/power of interference=' num2str(mean(pr))])
% xlabel('Hz'),ylabel('PSD')
% h3=figure,hold on,plot(freqs(sel),mean(FYn3,1),'r'),plot(freqs(sel),mean(FYp3,1),'g'),axis([0 40 0 0.4])
% 
% title(['Channel 3 with ERD ' num2str(B)...
%     ' times bigger at the no-movement class and ' num2str(extra_sources) ' extra sources.'...
%     'Power of ERD/power of interference=' num2str(mean(pr))])
% xlabel('Hz'),ylabel('PSD')

figmerge([1 2]);% 3 4 5])
legend({'no-movement' 'movement'}),
close(h1)
close(h2)
% close(h3)
% close(h4)
% close(h5)

a=mean(WP,3);
b=mean(WN,3);
