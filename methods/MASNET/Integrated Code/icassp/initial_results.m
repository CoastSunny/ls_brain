N=25;
T=25;
K=15;
S=100;
G=4;
D=1;
fpr_idx=1;
idx=0;
thr=0.1;
ND_seq=[];ND_gr=[];ND_rnd=[];
ACC_seq=[];ACC_gr=[];ACC_rnd=[];;
TTD_seq=[];TTD_gr=[];TTD_rnd=[];
CD_seq=[];CD_gr=[];CD_rnd=[];

g=[1 5 10 20 25];
k=1:K;
d=0.1:0.1:1;
loc_thr=0.5:0.5:2.5;
for g_idx=1:numel(g)
    for k_idx=1:numel(k)
        for d_idx=1:numel(d)
             [res]=get_results(pbsens_av,acc_av, N , k(k_idx) , g(g_idx) , T , S, d(d_idx) ,fpr_idx, prd, msh);
                ND_seq(g_idx,k_idx,d_idx,:)=res.nd_seq;
                ND_seq(g_idx,k_idx,d_idx,ND_seq(g_idx,k_idx,d_idx,:)>=k(k_idx))=k(k_idx);
                STD_seq(g_idx,k_idx,d_idx,:)=res.std_seq;
                ND_gr(g_idx,k_idx,d_idx,:)=res.nd_gr;
                ND_gr(g_idx,k_idx,d_idx,ND_gr(g_idx,k_idx,d_idx,:)>=k(k_idx))=k(k_idx);
                STD_gr(g_idx,k_idx,d_idx,:)=res.std_gr;
                ND_rnd(g_idx,k_idx,d_idx,:)=res.nd_rnd;
                ND_rnd(g_idx,k_idx,d_idx,ND_rnd(g_idx,k_idx,d_idx,:)>=k(k_idx))=k(k_idx);
                ND_rnd_good(g_idx,k_idx,d_idx,:)=res.nd_rnd_good;
                ND_rnd_good(g_idx,k_idx,d_idx,ND_rnd_good(g_idx,k_idx,d_idx,:)>=k(k_idx))=k(k_idx);
                STD_rnd(g_idx,k_idx,d_idx,:)=res.std_rnd;
                CD_seq(g_idx,k_idx,d_idx,:)=res.cum_dis_seq;
                CD_gr(g_idx,k_idx,d_idx,:)=res.cum_dis_gr;
%                 ACC_seq(g_idx,k_idx,d_idx,:)=k(k_idx)*mean(res.acc_seq(:));
%                 ACC_gr(g_idx,k_idx,d_idx,:)=k(k_idx)*mean(res.acc_gr(:));
%                 ACC_rnd(g_idx,k_idx,d_idx,:)=k(k_idx)*mean(res.acc_rnd(:));
                ACC_seq(g_idx,k_idx,d_idx,:)=mean(res.acc_seq(:));
                ACC_gr(g_idx,k_idx,d_idx,:)=mean(res.acc_gr(:));
                ACC_rnd(g_idx,k_idx,d_idx,:)=mean(res.acc_rnd(:));
                TTD_seq(g_idx,k_idx,d_idx,:)=res.ttd_seq;
                TTD_gr(g_idx,k_idx,d_idx,:)=res.ttd_gr;
                TTD_rnd(g_idx,k_idx,d_idx,:)=res.ttd_rnd;
            for l_idx=1:numel(loc_thr)               
                Ploc_seq(g_idx,k_idx,d_idx,l_idx)=sum(res.acc_seq<loc_thr(l_idx))/numel(res.acc_seq);
                Ploc_gr(g_idx,k_idx,d_idx,l_idx)=sum(res.acc_gr<loc_thr(l_idx))/numel(res.acc_gr);
                Ploc_rnd(g_idx,k_idx,d_idx,l_idx)=sum(res.acc_rnd<loc_thr(l_idx))/numel(res.acc_rnd);
            end
        end
        
    end
end

