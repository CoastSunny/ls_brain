clear E RES W We Mpat Mcon Mself

mtype=[];
mtype{1}='trans'; 
mtype{2}='deg';
% mtype{3}='clust';
% mtype{4}='deg';

delta=1+(2:4);
theta=1+(5:7);
alpha=1+(8:13);
beta=1+(14:30);
band=alpha;
lr=0.5;

for i=1:23
    
    W(:,:,i)=weight_conversion(mean(PSI_full{i}(:,:,band),3),'normalize');
    for tr=1:size(PSI{i},4)
        We{i}(:,:,tr)=weight_conversion(mean(PSI{i}(:,:,band,tr),3),'normalize');
    end
    
end

nel=numel(W(:,:,1));

for si=1:23
        
    ispat=any(fidx_patient==si);    
    Wpat=mean(W(:,:,setdiff(fidx_patient,si)),3);
    Wcon=mean(W(:,:,setdiff(fidx_control,si)),3);
    Wsi=We{si};   
    Wsi_mean=W(:,:,si);
    
    
    for k=1:numel(mtype)
        
        Mpat{k}=ls_network_metric(Wpat,mtype{k});
        Mcon{k}=ls_network_metric(Wcon,mtype{k});
        Mself{k}=ls_network_metric(Wsi_mean,mtype{k});
        
    end
  
    for trial=1:min(size(Wsi,3),50)
        
        [Wp_est mp ip] = optimise_network_multi(Wsi(:,:,trial),mtype,Mpat','learn',lr);
        [Wc_est mc ic] = optimise_network_multi(Wsi(:,:,trial),mtype,Mcon','learn',lr);
        [Ws_est ms is] = optimise_network_multi(Wsi(:,:,trial),mtype,Mself','learn',lr);

        if ispat
            E(si,trial,:)=1/nel*[norm(Wp_est-Wsi_mean,'fro') norm(Wc_est-Wsi_mean,'fro') norm(Ws_est-Wsi_mean,'fro') norm(Wsi(:,:,trial)-Wsi_mean,'fro')];
        else
            E(si,trial,:)=1/nel*[norm(Wc_est-Wsi_mean,'fro') norm(Wp_est-Wsi_mean,'fro') norm(Ws_est-Wsi_mean,'fro') norm(Wsi(:,:,trial)-Wsi_mean,'fro')];
        end
        RES{si,trial}={Wp_est Wc_est Ws_est Wsi(:,:,trial) Wsi_mean mp(:,end) mc(:,end) ms(:,end) ip ic is};
        
    end
    si
end
