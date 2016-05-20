set(0,'defaultlinelinewidth',3)
tt=(-18:18)/200*1000;
figure, hold on, plot(tt,mean(Xi(:,trn),2),'Linewidth',3),plot(tt,mean(Xs(:,trn),2),'r-.','Linewidth',3)
xlabel('time (milliseconds)')
ylabel('normalised amplitude')
legend('iEEG','sEEG')

figure,hold on,
plot(tt,mean(Xi(:,tst),2)),plot(tt,mean(D*Y2,2),'r-.'),plot(tt,mean(Dx*Yx2,2),'g--'),plot(tt,mean(Dyi*Yy2,2),'k:')
xlabel('time (milliseconds)')
ylabel('normalised amplitude')
legend('true signal','ours','DLSA+function','[3]')
legend boxoff
figure,hold on,plot(tt,mean(Xs(:,tst),2)),plot(tt,mean(Dc*Y2,2),'r-.'),plot(tt,mean(Dxc*Yx2,2),'g--'),plot(tt,mean(Dys*Yy2,2),'k:')
%figure,hold on,plot(tt,mean(Xi,2)),plot(tt,mean(Dx*Yx2i,2),'r-.')
