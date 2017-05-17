%% Plotter for WINNER II results

clear
%cd('H:\MATLAB\DSTL\MASNET_Project\WINNER2');
%cd('C:\Users\EM130\Desktop\PatChambers\MASNET_ProgressJune2016\DSTL\MASNET_Project\WINNER2')
cd('C:\Users\mathini\Desktop\PatChambersJune2016\MASNET_ProgressJune2016\DSTL\MASNET_Project\WINNER2')

los = load('los.mat');
nlos = load('nlos.mat');
norm_fac = max(los.CIR_out(1,1,:,1));
norm_fac2 = max(los.CIR_out2(1,1,:,1));

los.CIR_out(1,1,:,1) = los.CIR_out(1,1,:,1)/norm_fac;
delayslos = los.newdelays;
nlos.CIR_out(1,1,:,1) = nlos.CIR_out(1,1,:,1)/norm_fac;
delaysnlos = nlos.newdelays;


los.CIR_out2(1,1,:,1) = los.CIR_out2(1,1,:,1)/norm_fac2;
delayslos2 = los.newdelays2;
nlos.CIR_out2(1,1,:,1) = nlos.CIR_out2(1,1,:,1)/norm_fac2;
delaysnlos2 = nlos.newdelays2;


ymin = 20*log10(abs(squeeze(los.CIR_out(1,1,:,1))));
ymin = min(ymin(ymin~= -inf));
ystartlos = ymin*ones(size(squeeze(los.CIR_out(1,1,:,1))));
yendlos = 20*log10(abs(squeeze(los.CIR_out(1,1,:,1))));
xstartlos = delayslos;
xendlos = xstartlos;


figure(1)
%subplot(1,2,1)
hold on
for idx = 1 : numel(ystartlos)
plot([xstartlos(idx) xendlos(idx)], [ystartlos(idx) yendlos(idx)],'b'); 
end
plot(delayslos,yendlos,'bo')
grid on
axis([min(xstartlos), max(xstartlos), ymin, max(yendlos)]);
xlabel('Excess delay, [s]')
ylabel('Normalised amplitude, [dB]')


ymin = 20*log10(abs(squeeze(nlos.CIR_out(1,1,:,1))));
ymin = min(ymin(ymin~= -inf));
ystartnlos = ymin*ones(size(squeeze(nlos.CIR_out(1,1,:,1))));
yendnlos = 20*log10(abs(squeeze(nlos.CIR_out(1,1,:,1))));
xstartnlos = delaysnlos;
xendnlos = xstartnlos;

subplot(1,2,2)
hold on
for idx = 1 : numel(ystartnlos)
plot([xstartnlos(idx) xendnlos(idx)], [ystartnlos(idx) yendnlos(idx)],'b'); 
end
plot(delaysnlos,yendnlos,'bo')
grid on
axis([min(xstartnlos), max(xstartnlos), ymin, max(yendnlos)]);
xlabel('Excess delay, [s]')
ylabel('Normalised amplitude, [dB]')






ymin = 20*log10(abs(squeeze(los.CIR_out2(1,1,:,1))));
ymin = min(ymin(ymin~= -inf));
ystartlos = ymin*ones(size(squeeze(los.CIR_out2(1,1,:,1))));
yendlos = 20*log10(abs(squeeze(los.CIR_out2(1,1,:,1))));
xstartlos = delayslos2;
xendlos = xstartlos;


figure(2)
subplot(1,2,1)
hold on
for idx = 1 : numel(ystartlos)
plot([xstartlos(idx) xendlos(idx)], [ystartlos(idx) yendlos(idx)],'b'); 
end
plot(delayslos2,yendlos,'bo')
grid on
axis([min(xstartlos), max(xstartlos), ymin, max(yendlos)]);
xlabel('Excess delay, [s]')
ylabel('Normalised amplitude, [dB]')


ymin = 20*log10(abs(squeeze(nlos.CIR_out2(1,1,:,1))));
ymin = min(ymin(ymin~= -inf));
ystartnlos = ymin*ones(size(squeeze(nlos.CIR_out2(1,1,:,1))));
yendnlos = 20*log10(abs(squeeze(nlos.CIR_out2(1,1,:,1))));
xstartnlos = delaysnlos2;
xendnlos = xstartnlos;

subplot(1,2,2)
hold on
for idx = 1 : numel(ystartnlos)
plot([xstartnlos(idx) xendnlos(idx)], [ystartnlos(idx) yendnlos(idx)],'b'); 
end
plot(delaysnlos2,yendnlos,'bo')
grid on
axis([min(xstartnlos), max(xstartnlos), ymin, max(yendnlos)]);
xlabel('Excess delay, [s]')
ylabel('Normalised amplitude, [dB]')















