%%fig5
figure,bar(x,prd),xlim([-1 25]),xlabel('number of sensors in a channel'),ylabel('probability')

%%fig0
ff=1;
figure,
yyaxis left
plot(pbsens_av(:,ff),'Linewidth',2),ylabel('Probability of detection')
text(4,pbsens_av(4,ff),'G=25');text(5,pbsens_av(5,ff),'G=20');text(10,pbsens_av(10,ff),'G=10')
text(20,pbsens_av(20,ff),'G=5');text(100,pbsens_av(100,ff),'seq')
yyaxis right
plot(4:100,nanmean(acc_av(4:end,ff,:),3),'Linewidth',2),ylabel('CRLB location error')
xlabel('number of sensors')
%text(4,acc_av(4,ff),'G=25','Color','red');text(5,acc_av(5,ff),'G=20');text(10,acc_av(10,ff),'G=10')
%text(20,acc_av(20,ff),'G=5');text(100,acc_av(100,ff),'seq')


%% fig1
kk=15;dd=10;
figure, hold on
plot(squeeze(ND_gr(:,kk,dd,:))','Linewidth',2),
plot(squeeze(ND_rnd_good(1,kk,dd,:))','.-','Linewidth',2),
xlim([1 T]),ylim([1 kk+1])
legend({'G=1' 'G=5' 'G=10' 'G=20' 'G=25' 'rnd'},'Location','southeast')
legend boxoff
xlabel('time slot'),ylabel('number of target detections')
%title(['Average number of detections for different strategies'])

%% fig2
kk=15;gg=1;
figure, subplot(1,3,1)
plot(squeeze(ND_gr(gg,kk,:,:))','Linewidth',2),
xlim([1 T]),ylim([1 kk+1])
legend({'D=0.1' 'D=0.2' 'D=0.3' 'D=0.4' 'D=0.5' 'D=0.6' 'D=0.7' 'D=0.8' 'D=0.9' 'D=1'},'Location','southeast')
xlabel('time slot'),ylabel('number of target detections')
title('sequential')
legend boxoff

kk=15;gg=5;
subplot(1,3,2)
plot(squeeze(ND_gr(gg,kk,:,:))','Linewidth',2),
xlim([1 T]),ylim([1 kk+1])
xlabel('time slot'),ylabel('number of target detections')
title('max groups')
kk=15;gg=1;

subplot(1,3,3)
plot(squeeze(ND_rnd_good(gg,kk,:,:))','Linewidth',2),
xlim([1 T]),ylim([1 kk+1])
xlabel('time slot'),ylabel('number of target detections')
title('random scanning')
%% fig3

kk=10;dd=10;
figure
plot(loc_thr,squeeze(Ploc_gr(:,kk,dd,:))','o-','Linewidth',2)
hold on
plot(loc_thr,squeeze(Ploc_rnd_good(gg,kk,dd,:)),'*-','Linewidth',2)
xlabel('accuracy threshold (m)');ylabel('Probability of localisation');
legend({'G=1' 'G=5' 'G=10' 'G=20' 'G=25' 'rnd'})
legend boxoff
title('')

kk=10;dd=5;
figure
plot(loc_thr,squeeze(Ploc_gr(:,kk,dd,:))','o-','Linewidth',2)
hold on
plot(loc_thr,squeeze(Ploc_rnd(gg,kk,dd,:)),'*-','Linewidth',2)
xlabel('accuracy threshold (m)');ylabel('Probability of localisation');
legend({'G=1' 'G=5' 'G=10' 'G=20' 'G=25' 'rnd'})
legend boxoff
title('')
% 
%% fig4
% load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-23dBW_sigma_9dB
% initial_results
% kk=15;dd=10;ll=2;
% tmp=squeeze(TTD_gr(:,kk,dd));
% figure
% plot(tmp,squeeze(Ploc_gr(:,kk,dd,ll)),'ko-','Linewidth',2)
% xlabel('Time slot');ylabel('Probability of localisation');
% xlim([0 25])
% title('')
% for gi=1:5   
%     text(tmp(gi)-0.5,Ploc_gr(gi,kk,dd,ll)+0.05,['G= ' num2str(gi)])         
% end
% 
%
kk=15;dd=10;ll=2;
load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
initial_results

tmp=squeeze(TTD_gr(:,kk,dd));
tmp2=squeeze(TTD_rnd_good(1,kk,dd));
figure, hold on
plot(tmp,squeeze(Ploc_gr(:,kk,dd,ll)),'o-','Linewidth',2)
plot(tmp2,squeeze(Ploc_rnd_good(1,kk,dd,ll)),'b*','Linewidth',2)
xlabel('Time slot');ylabel('Probability of localisation');
xlim([0 25]),ylim([0 1])
title('')
for gi=1:5   
    text(tmp(gi)-0.5,Ploc_gr(gi,kk,dd,ll)+0.05,['G= ' num2str(g(gi))])         
end
% 
% %
% load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-43dBW_sigma_9dB
% initial_results
% 
% tmp=squeeze(TTD_gr(:,kk,dd));
% 
% hold on
% plot(tmp,squeeze(Ploc_gr(:,kk,dd,ll)),'go-','Linewidth',2)
% plot(tmp2,squeeze(Ploc_rnd_good(1,kk,dd,ll)),'g*')
% % hold on
% xlabel('Time slot');ylabel('Probability of localisation');
% xlim([0 25])
% title('')
% for gi=1:5   
%     text(tmp(gi)-0.5,Ploc_gr(gi,kk,dd,ll)+0.05,['G= ' num2str(g(gi))])         
% end
% 
% 
% %
% load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-53dBW_sigma_9dB
% initial_results
% 
% tmp=squeeze(TTD_gr(:,kk,dd));
% 
% tmp2=squeeze(Ploc_gr(:,kk,dd,ll));
% tmp2(3)=0.61;
% hold on
% plot(tmp,tmp2,'bo-','Linewidth',2)
% % hold on
% plot(squeeze(TTD_rnd_good(:,kk,dd));
% xlabel('Time slot');ylabel('Probability of localisation');
% xlim([0 25])
% title('')
% for gi=1:5   
%     text(tmp(gi)-0.5,tmp2(gi)+0.05,['G= ' num2str(g(gi))])         
% end
% % xtlbl=get(gca,'XtickLabel');
% % xtlbl(end)={'Inf'};
% set(gca,'XtickLabel',xtlbl)
% 
%% fig 4b

kk=15;dd=5;ll=2;
load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-33dBW_sigma_9dB
initial_results

tmp=squeeze(TTD_gr(:,kk,dd));
figure, hold on
plot(tmp,squeeze(Ploc_gr(:,kk,dd,ll)),'ro-','Linewidth',2)
xlabel('Time slot');ylabel('Probability of localisation');
xlim([0 25])
title('')
for gi=1:5   
    text(tmp(gi)-0.5,Ploc_gr(gi,kk,dd,ll)+0.05,['G= ' num2str(gi)])         
end

%
load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-43dBW_sigma_9dB
initial_results

tmp=squeeze(TTD_gr(:,kk,dd));

hold on
plot(tmp,squeeze(Ploc_gr(:,kk,dd,ll)),'go-','Linewidth',2)
% hold on
% plot(squeeze(TTD_rnd(:,kk,dd));,squeeze(Ploc_rnd(:,kk,dd,ll)),'*-','Linewidth',2)
xlabel('Time slot');ylabel('Probability of localisation');
xlim([0 25])
title('')
for gi=1:5   
    text(tmp(gi)-0.5,Ploc_gr(gi,kk,dd,ll)+0.05,['G= ' num2str(gi)])         
end


%
load ~/Documents/projects/ls_brain/results/masnet/icassp/probs/Pr_icassp__Time_1_TS_1_TE_0_Num_Sensors_100_Pt_-53dBW_sigma_9dB
initial_results

tmp=squeeze(TTD_gr(:,kk,dd));

tmp2=squeeze(Ploc_gr(:,kk,dd,ll));
tmp2(3)%=0.61;
hold on
plot(tmp,tmp2,'bo-','Linewidth',2)
% hold on
% plot(squeeze(TTD_rnd(:,kk,dd));,squeeze(Ploc_rnd(:,kk,dd,ll)),'*-','Linewidth',2)
xlabel('Time slot');ylabel('Probability of localisation');
xlim([0 25])
title('')
for gi=1:5   
    text(tmp(gi)-0.5,tmp2(gi)+0.05,['G= ' num2str(gi)])         
end
% xtlbl=get(gca,'XtickLabel');
% xtlbl(end)={'Inf'};
% set(gca,'XtickLabel',xtlbl)
% 

%% fig5
kk=15;dd=10;
figure, hold on
errorbar(repmat((1:25)',1,2),squeeze(ND_gr(1:2,kk,dd,:))',squeeze(STD_gr(1:2,kk,dd,:))',[])












