method=4;
trdim=3;
time_window=1:897;
T=24;
timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};
xi=0:34;
clear HFT1 HFT2 HFT3
for L=0:40
    
    labels={'3sec'};
    nomove='NO3';
    immove='IM3';
    ammove='AM3';
    code_louk_2_gen
    code_louk_justdata
    code_louk_or
    HFT1(:,L+1)=Res_out(:,2);
    HFT2(:,L+1)=r(:,3);
    HFT3(:,L+1)=r2(:,3);
    
end

 figure,hold on,plot(xi,mean(HFT1),'r','Linewidth',4),plot(xi,mean(HFT2),'g','Linewidth',4)...
     ,plot(xi,mean(HFT3),'b','Linewidth',4)
 xlabel('half life in trials (0 corresponds to single trial whitening)');ylabel('classification performance');
 title('Group average cross-subject classification performance in terms of the half life parameter')
 legend({'139','plosone','rocuronium'})