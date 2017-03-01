ll=[16 48 80 112];
kk={'back' 'right' 'front' 'left'};
si=1;
figure,
subplot(2,2,1),imagesc(v2G(Fp{si}{1}(:,1))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,2),imagesc(v2G(Fp{si}{1}(:,2))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,3),imagesc(v2G(Fp{si}{1}(:,3))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,4),imagesc(v2G(Fp{si}{1}(:,4))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),

figure,
subplot(2,2,1),plot(Fp{si}{3}(:,1))
subplot(2,2,2),plot(Fp{si}{3}(:,2))
subplot(2,2,3),plot(Fp{si}{3}(:,3))
subplot(2,2,4),plot(Fp{si}{3}(:,4))

si=2;
figure,
subplot(2,2,1),imagesc(v2G(Fp{si}{1}(:,1))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,2),imagesc(v2G(Fp{si}{1}(:,2))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,3),imagesc(v2G(Fp{si}{1}(:,3))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,4),imagesc(v2G(Fp{si}{1}(:,4))),colorbar,set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),

figure,
subplot(2,2,1),plot(Fp{si}{3}(:,1))
subplot(2,2,2),plot(Fp{si}{3}(:,2))
subplot(2,2,3),plot(Fp{si}{3}(:,3))
subplot(2,2,4),plot(Fp{si}{3}(:,4))