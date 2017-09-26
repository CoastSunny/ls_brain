function [ res ] = get_results( pbsens_av , acc_av , N , K , G , T , S, D, fpr_idx )

pr_hit_seq = D*K/N;
pr_hit_gr  = D*G*K/N;
pr_hit_rnd = D*1;

res.acc_seq=acc_av(S,fpr_idx,:);
res.acc_gr=acc_av(S/G,fpr_idx,:);
res.acc_rnd=acc_av(S/N,fpr_idx,:);

for t=1:T
    
    if t==1
        nd_seq(t) = pr_hit_seq * pbsens_av(S,fpr_idx); 
        nd_gr(t) = pr_hit_gr * pbsens_av(S/G,fpr_idx);
        nd_rnd(t) = pr_hit_rnd * pbsens_av(S/N,fpr_idx); 
        cum_dis_seq(t) = mean(acc_av(S,fpr_idx,:));
        cum_dis_gr(t) = mean(acc_av(S/G,fpr_idx,:));
        cum_dis_rnd(t) = mean(acc_av(S/N,fpr_idx,:));
    else
        nd_seq(t) = nd_seq(t-1) + pr_hit_seq * pbsens_av(S,fpr_idx);
        nd_gr(t) = nd_gr(t-1) + pr_hit_gr * pbsens_av(S/G,fpr_idx);
        nd_rnd(t) = nd_rnd(t-1) + pr_hit_rnd * pbsens_av(S/N,fpr_idx); 
        cum_dis_seq(t) = cum_dis_seq(t-1) + mean(acc_av(S,fpr_idx,:));
        cum_dis_gr(t) = cum_dis_gr(t-1) + mean(acc_av(S/G,fpr_idx,:));
        cum_dis_rnd(t) = cum_dis_rnd(t-1) + mean(acc_av(S/N,fpr_idx,:));
    end    

end     
res.nd_seq=nd_seq;
res.nd_gr=nd_gr;
res.nd_rnd=nd_rnd;
res.cum_dis_seq=cum_dis_seq;
res.cum_dis_gr=cum_dis_gr;
res.cum_dis_rnd=cum_dis_rnd;


tmp=find(nd_seq>=K);
if isempty(tmp);tmp=Inf;end;
res.ttd_seq=tmp(1);

tmp=find(nd_gr>=K);
if isempty(tmp);tmp=Inf;end;
res.ttd_gr=tmp(1);

tmp=find(nd_rnd>=K);
if isempty(tmp);tmp=Inf;end;
res.ttd_rnd=tmp(1);