
figure, hold on, plot(tt,x1,'Color',[.5 .5 .5],'Linewidth',1),plot(tt,y1,'Color',[.1 .1 .1],'Linewidth',4),plot(tt,ym,'-.','Color',[0.1 0.1 0.1],'Linewidth',4)
xlabel('time in seconds')
ylabel('HbO concentration change')
title('reconstructed trend, original series, and low frequency mayer wave')
hl=legend({'original series' 'reconstructed trend' 'mayer wave component'})
legend boxoff
set(hl,'FontSize',14)
xlhand = get(gca,'xlabel')
ylhand = get(gca,'ylabel')
thand = get(gca,'title')
set(thand,'fontsize',12)
set(xlhand,'fontsize',14)
set(ylhand,'fontsize',14)
set(gca,'Fontsize',14)



figure, hold on, plot(tt,x1,'Color',[.5 .5 .5],'Linewidth',1),plot(tt,y1,'Color',[.1 .1 .1],'Linewidth',4),plot(tt,yh,'-.','Color',[0.1 0.1 0.1],'Linewidth',4)
xlabel('time in seconds')
ylabel('HbO concentration change')
title('reconstructed trend, original series, and heart rate component')
hl=legend({'original series' 'reconstructed trend' 'heart rate component'})
legend boxoff
set(hl,'FontSize',14)
xlhand = get(gca,'xlabel')
ylhand = get(gca,'ylabel')
thand = get(gca,'title')
set(thand,'fontsize',16)
set(xlhand,'fontsize',16)
set(ylhand,'fontsize',16)
set(gca,'Fontsize',16)