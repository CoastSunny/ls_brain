
figure(1),hold on,title('Patients, Coherence, F1'),xlabel('freq(Hz)')%,ylim([0.14 0.19])
figure(2),hold on,title('Controls, Coherence, F1'),xlabel('freq(Hz)')%,ylim([0.14 0.19])

for i=1:23
if idx_patient(i)==1
figure(1),plot(Ft{i}{2}(:,1))
else 
figure(2),plot(Ft{i}{2}(:,1))
end
end


figure(3),hold on,title('Patients, Coherence, C1'),xlabel('freq(Hz)')%,ylim([0.08 0.13])
figure(4),hold on,title('Controls, Coherence, C1'),xlabel('freq(Hz)')%,ylim([0.08 0.13])

for i=1:23
if idx_patient(i)==1
figure(3),plot(Ft{i}{1}(:,1))
else 
figure(4),plot(Ft{i}{1}(:,1))
end
end
 