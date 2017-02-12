figure, hold on
plot(median([EV09(:,1) EV05(:,1) EV02(:,1)]),'Linewidth',2)
plot(median([EV0910(:,1) EV0510(:,1) EV0210(:,1)]),'-.','Linewidth',2)
plot(median([EV0930(:,1) EV0530(:,1) EV0230(:,1)]),':','Linewidth',2)
set(gca,'Xtick',[1 2 3]),set(gca,'Xticklabel',[0.9 0.5 0.2])
xlabel('SNR'),ylabel('Explained Variance')
legend({'2 components' '10 components' '30 components'})
legend boxoff

figure, hold on
plot(mean([L09(:,1) L05(:,1) L02(:,1)]),'Linewidth',2)
plot(mean([L0910(:,1) L0510(:,1) L0210(:,1)]),'-.','Linewidth',2)
plot(mean([L0930(:,1) L0530(:,1) L0230(:,1)]),':','Linewidth',2)
set(gca,'Xtick',[1 2 3]),set(gca,'Xticklabel',[0.9 0.5 0.2])
xlabel('SNR'),ylabel('Source Reconstruction Similarity')
legend({'2 components' '10 components' '30 components'})
legend boxoff

Gloc=[0.3864 0.2549 -0.28];
Gloc10=[0.33 0.28 -0.1981];
Gloc30=[0.61 0.34 -0.1981];

figure, hold on
plot(Gloc,'Linewidth',2)
plot(Gloc10,'-.','Linewidth',2)
plot(Gloc30,':','Linewidth',2)
set(gca,'Xtick',[1 2 3]),set(gca,'Xticklabel',[0.9 0.5 0.2])
xlabel('SNR'),ylabel('LOC metric')
legend({'2 components' '10 components' '30 components'})
legend boxoff
% 
% c=hgload('ExpVar.fig');
% k=hgload('SouRe.fig');
% m=hgload('LOC.fig');
% figure
% h(1)=subplot(1,3,1)
% h(2)=subplot(1,3,2);
% h(3)=subplot(1,3,3);
% copyobj(allchild(get(c,'CurrentAxes')),h(1));
% copyobj(allchild(get(k,'CurrentAxes')),h(2));
% copyobj(allchild(get(m,'CurrentAxes')),h(3));
