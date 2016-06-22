
clear E RES M Mr

mtype=[];
%mtype{1}='deg';
 mtype{1}='clust';
 mtype{2}='trans';


delta=1+(2:4);
theta=1+(5:7);
alpha=1+(8:13);
beta=1+(14:30);
band=alpha;
tst_idx=50;

for q=1:length(DirCon)
    
    Worig=weight_conversion(mean(PSI_full{q}(:,:,band),3),'normalize');
    We=squeeze(mean(PSI{q}(:,:,band,tst_idx+1:end),3));
    
for k=1:numel(mtype)
    
    M{k}=ls_network_metric(Worig,mtype{k});
    Mr{k}=rand(1,numel(M{k}));    
    
end


for trial=(tst_idx+1):size(We,3)
    
    Ww=weight_conversion(We(:,:,trial),'normalize');
    Wd = optimise_network_multi(Ww,mtype,M');
    Wr = optimise_network_multi(Ww,mtype,Mr');
    E{q}.e(trial-tst_idx,:)=[norm(Wd-Worig,'fro') norm(Wr-Worig,'fro') norm(Ww-Worig,'fro')];
    RES{q}.r{trial-tst_idx}={Worig Wd Wr Ww};
    
end

end