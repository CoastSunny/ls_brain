N=48;
T=96;
K=48;
S=96;
G=4;
D=1;
fpr_idx=1;
idx=0;
thr=0.1;
ND_seq=[];ND_gr=[];ACC_seq=[];ACC_gr=[];TTD_seq=[];TTD_gr=[];CD_seq=[];CD_gr=[];

g=[1 2 4 8 16 32];
k=1:24;
d=0.1:0.1:1;
for g_idx=1:numel(g)
    for k_idx=1:numel(k)
        for d_idx=1:numel(d)
            [res]=get_results(pbsens_av,acc_av, N , k(k_idx) , g(g_idx) , T , S, d(d_idx) ,fpr_idx);
            ND_seq(g_idx,k_idx,d_idx,:)=res.nd_seq;
            ND_seq(g_idx,k_idx,ND_seq(g_idx,k_idx,:,:)>=k(k_idx))=k(k_idx);
            ND_gr(g_idx,k_idx,d_idx,:)=res.nd_gr;
            ND_gr(g_idx,k_idx,ND_gr(g_idx,k_idx,:,:)>=k(k_idx))=k(k_idx);
            ND_rnd(g_idx,k_idx,d_idx,:)=res.nd_rnd;
            ND_rnd(g_idx,k_idx,ND_rnd(g_idx,k_idx,:,:)>=k(k_idx))=k(k_idx);
            CD_seq(g_idx,k_idx,d_idx,:)=res.cum_dis_seq;
            CD_gr(g_idx,k_idx,d_idx,:)=res.cum_dis_gr;
            ACC_seq(g_idx,k_idx,d_idx,:)=k(k_idx)*mean(res.acc_seq(:));
            ACC_gr(g_idx,k_idx,d_idx,:)=k(k_idx)*mean(res.acc_gr(:));
            ACC_rnd(g_idx,k_idx,d_idx,:)=k(k_idx)*mean(res.acc_rnd(:));
            TTD_seq(g_idx,k_idx,d_idx,:)=res.ttd_seq;
            TTD_gr(g_idx,k_idx,d_idx,:)=res.ttd_gr;
            TTD_rnd(g_idx,k_idx,d_idx,:)=res.ttd_rnd;
        end
        
    end
end

dd=10;
figure
imagesc(g,k,ACC_gr(:,:,dd)),xlim([g(1) g(end)]),ylim([k(1) k(end)])
xlabel('Number of Groups'),ylabel('Number of Targets')
title(['Cumulative CRLB for ' num2str(N) ' channels'])

kk=24;
figure, hold on
plot(squeeze(ND_gr(:,kk,d_idx,:))'),
plot(squeeze(ND_rnd(1,kk,d_idx,:))','.-'),
xlim([1 T]),ylim([1 kk+1])
legend({'G=1' 'G=2' 'G=4' 'G=8' 'G=16' 'G=32' 'rnd'},'Location','southeast')
xlabel('time slot'),ylabel('number of target detections (>100%)')
title(['Cumulative number of detections for ' num2str(kk) ' targets'])

kk=24;gg=5;
figure, hold on
plot(squeeze(ND_gr(gg,kk,:,:))'),
xlim([1 T]),ylim([1 kk+1])
legend({'D=0.1' 'D=0.2' 'D=0.3' 'D=0.4' 'D=0.5' 'D=0.6' 'D=0.7' 'D=0.8' 'D=0.9' 'D=1'},'Location','southeast')
xlabel('time slot'),ylabel('number of target detections (>100%)')
title(['Cumulative number of detections for ' num2str(kk) ' targets and ' num2str(gg) ' groups'])
legend boxoff

kk=24;gg=5;
figure, hold on
plot(squeeze(ND_rnd(gg,kk,:,:))'),
xlim([1 T]),ylim([1 kk+1])
legend({'D=0.1' 'D=0.2' 'D=0.3' 'D=0.4' 'D=0.5' 'D=0.6' 'D=0.7' 'D=0.8' 'D=0.9' 'D=1'},'Location','northwest')
xlabel('time slot'),ylabel('number of target detections (>100%)')
title(['Cumulative number of detections for ' num2str(kk) ' targets and the rnd method'])
legend boxoff

figure,hold on
dd=10;
h=[]
for kk=1:24
    
    ttd=squeeze(TTD_gr(:,kk,dd));
    cacc=squeeze(ACC_gr(:,kk,dd));
    h(kk)=plot(ttd,cacc);
    ttd=squeeze(TTD_rnd(:,kk,dd));
    cacc=squeeze(ACC_rnd(:,kk,dd));
    hh(kk)=plot(ttd,cacc,'o');
    
end

xlabel('time to detect all'),ylabel('Cumulative CRLB (meters)')
xlim([1 60]),ylim([-5 100])
legend([h(1) h(end) hh(1) hh(15)],{'k=1' 'k=24' 'rnd1' 'rnd15'})
