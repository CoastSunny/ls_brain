clc
R1=[];
F1=[];
T1=[];
tp=0.01;
method=2;%
cheating_bias=000;
plotN=9;
for N=1:plotN
    
    embc
    R1(1,:,N)=mean(Gsav');
    R1(2,:,N)=mean(GsavC');
    R1(3,:,N)=mean(Gnrow');
    R1(4,:,N)=mean(GnrowC');
    F1(1,N)=max(Gsav(3,:));
    F1(2,N)=max(GsavC(3,:));
    T1(1,N)=min(Gsav(1,:));
    T1(2,N)=min(GsavC(1,:));
%     R1(3,:,N)=mean(Gnrow');
%     R1(4,:,N)=mean(GnrowC');
   RT(N,:)=[min(TTD) mean(TTD) median(TTD) max(TTD)]*6;

end

SAV=squeeze(R1(1,[1 2 3 4],1:plotN))';
SAVfm=(F1(1,1:plotN))';
SAVtm=(T1(1,1:plotN))';
% SAV(:,end+1)=SAVfm;
% SAV(:,end+1)=SAVtm;
SAVC=squeeze(R1(2,[1 2 3 4],1:plotN))';
SAVCfm=(F1(2,1:plotN))';
SAVCtm=(T1(2,1:plotN))';
% SAVC(:,end+1)=SAVCfm;
% SAVC(:,end+1)=SAVCtm;
NROW=squeeze(R1(3,[1 2 3 4],1:plotN))';

NROWC=squeeze(R1(4,[1 2 3 4],1:plotN))';



figure,
subplot(2,2,1)
bar(SAV),xlabel('number of combined trials'),ylabel('TPR/FPR')
title('Training dataset')
subplot(2,2,2)
bar(SAVC),xlabel('number of combined trials'),ylabel('TPR/FPR')
title('Holdout dataset')
%figure,
subplot(2,2,3)
bar(NROW),xlabel('number of combined trials'),ylabel('TPR/FPR')
title('Training dataset')
subplot(2,2,4)
bar(NROWC),xlabel('number of combined trials'),ylabel('TPR/FPR')
title('Holdout dataset')



% figure,bar(NROW),xlabel('number of averaged trials'),ylabel('TPR/FPR')
% title('True and false positive rate comparison between the model and the actual data')
% figure,bar(NROWC),xlabel('number of averaged trials'),ylabel('TPR/FPR')
% title('True and false positive rate comparison between the model and the actual data')

% figure,bar(SAVm),xlabel('number of averaged trials'),ylabel('TPR/FPR')
% title('True and false positive rate comparison between the model and the actual data on the training dataset')
% figure,bar(SAVCm),xlabel('number of averaged trials'),ylabel('TPR/FPR')
% title('True and false positive rate comparison between the model and the actual data on the holdout dataset')

% figure, hold on
% plot(squeeze(R1(1,1,:)),'Linewidth',3)
% plot(squeeze(R1(2,1,:)),'Linewidth',3,'Linestyle','-.')
% plot(squeeze(R1(3,1,:)),'Linewidth',3,'Color','r')
% plot(squeeze(R1(4,1,:)),'Linewidth',3,'Linestyle','-.','Color','r')
% legend({'navTraining' 'navHoldout' 'nrowTraining' 'nrowHoldout'}),xlabel('number of combined trials')
% ylabel('TPR'),title('NAV and NROW uncalibrated, all data')
% figure,hold on,
% plot(squeeze(R1(1,3,:)),'Linewidth',3)
% plot(squeeze(R1(2,3,:)),'Linewidth',3,'Linestyle','-.')
% plot(squeeze(R1(3,3,:)),'Linewidth',3,'Color','r')
% plot(squeeze(R1(4,3,:)),'Linewidth',3,'Linestyle','-.','Color','r')
% legend({'navTraining' 'navHoldout' 'nrowTraining' 'nrowHoldout'})
% xlabel('number of combined trials')
% ylabel('FPR'),
% title('NAV and NROW uncalibrated, all data')
ax=[0 10 0.8 1];
figure,subplot(1,2,1),hold on,
plot( (0.5*(SAV(:,1)+(1-SAV(:,3)))),'Linewidth',4),...
    plot((0.5*(NROW(:,1)+(1-NROW(:,3)))),'Linewidth',4,'Color','r','Linestyle','-.'),axis(ax),...
    xlabel('number of combined trials'),ylabel('Classification performance'),title('Training set')
subplot(1,2,2),hold on,
plot((0.5*(SAVC(:,1)+(1-SAVC(:,3)))),'Linewidth',4),...
    plot((0.5*(NROWC(:,1)+(1-NROWC(:,3)))),'Linewidth',4,'Color','r','Linestyle','-.'),axis(ax),...
    xlabel('number of combined trials'),ylabel('Classification performance'),title('Holdout set')
 legend({'NAV' 'NROW'})   
    
    
    
    