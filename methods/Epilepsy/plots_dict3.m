set(0,'defaultlinelinewidth',3)
tt=(-32:32)/200*1000;
ttt=4*65+1:5*65;
figure, hold on,
plot(tt,mean(Xi(ttt,tst),2)),plot(tt,mean(D(ttt,:)*Y2,2),'r')
plot(tt,mean(Dyi(ttt,:)*Yy2,2),'g')
plot(tt,mean(Dx(ttt,:)*Yx2,2),'k')
xlabel('time (milliseconds)')
ylabel('normalised amplitude')
legend('true signal','ours','[3]','DLSA+function')
legend boxoff
