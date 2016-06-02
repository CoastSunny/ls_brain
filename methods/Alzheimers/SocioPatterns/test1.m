
mtype=[];
mtype{1}='trans';
mtype{2}='clust';


for k=1:numel(mtype)
    
    K{k}=ls_network_metric(A,mtype{k});    
    
end

Wf=optimise_network_multi(weight_conversion(W,'normalize'),mtype,K,'learn',0.01);