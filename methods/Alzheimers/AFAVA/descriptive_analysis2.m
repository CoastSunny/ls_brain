figure('units','normalized','outerposition',[0 0 1 1])
for i=1:numel(fidx_patient)
fi=fidx_patient(i);
subplot(6,2,i),plot(Fp{fi}{2}),xlabel('freq(Hz'),ylabel('normalised power')
end
saveaspdf(gcf,'ParaPat')
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:numel(fidx_control)
fi=fidx_control(i);
subplot(6,2,i),plot(Fp{fi}{2}),xlabel('freq(Hz'),ylabel('normalised power')
end
saveaspdf(gcf,'ParaCont')
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:numel(fidx_patient)
fi=fidx_patient(i);
subplot(6,2,i),plot(Ft{fi}{2}),xlabel('freq(Hz'),ylabel('normalised power')
end
saveaspdf(gcf,'TuckerPat')
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:numel(fidx_control)
fi=fidx_control(i);
subplot(6,2,i),plot(Ft{fi}{2}),xlabel('freq(Hz'),ylabel('normalised power')
end
saveaspdf(gcf,'TuckerCont')

figure('units','normalized','outerposition',[0 0 1 1])
plot((F_patient)'),title('PSD'),xlabel('freq(Hz')
saveaspdf(gcf,'PatientPSDs')
figure('units','normalized','outerposition',[0 0 1 1])
plot(F_control'),title('PSD'),xlabel('freq(Hz')
saveaspdf(gcf,'ControlPSDs')

