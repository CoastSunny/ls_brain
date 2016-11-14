clear E RES W We Mpat Mcon Mself

mtype=[];
mtype{1}='trans'; 
% mtype{2}='deg';
% mtype{3}='clust';
% mtype{4}='deg';

delta=1+(2:4);
theta=1+(5:7);
alpha=1+(8:13);
beta=1+(14:30);
band=alpha;
lr=0.5;

for i=1:numel(PSI_full_mci)
    
    W_mci(:,:,i)=weight_conversion(mean(PSI_full_mci{i}(:,:,band),3),'normalize');
    for tr=1:size(PSI_mci{i},4)
        We_mci{i}(:,:,tr)=weight_conversion(mean(PSI_mci{i}(:,:,band,tr),3),'normalize');
    end
    
end

for i=1:numel(PSI_full_fad)
    
    W_fad(:,:,i)=weight_conversion(mean(PSI_full_fad{i}(:,:,band),3),'normalize');
    for tr=1:size(PSI_fad{i},4)
        We_fad{i}(:,:,tr)=weight_conversion(mean(PSI_fad{i}(:,:,band,tr),3),'normalize');
    end
    
end


nel_mci=numel(W_mci(:,:,1));
nel_fad=numel(W_fad(:,:,1));

for si=1:numel(PSI_full_fad)
        
    fidx_patient=find(gc_idx_mci(:,1)==1);    
    fidx_control=find(gc_idx_mci(:,1)==0);    
    Wpat=mean(W_mci(:,:,setdiff(fidx_patient,si)),3);
    Wcon=mean(W_mci(:,:,setdiff(fidx_control,si)),3);
    Wsi=We_fad{si};   
    Wsi_mean=W_fad(:,:,si);
    ispat=logical(gc_idx_fad(si,1));
    
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
            E(si,trial,:)=1/nel_fad*[norm(Wp_est-Wsi_mean,'fro') norm(Wc_est-Wsi_mean,'fro') norm(Ws_est-Wsi_mean,'fro') norm(Wsi(:,:,trial)-Wsi_mean,'fro')];
        else
            E(si,trial,:)=1/nel_fad*[norm(Wc_est-Wsi_mean,'fro') norm(Wp_est-Wsi_mean,'fro') norm(Ws_est-Wsi_mean,'fro') norm(Wsi(:,:,trial)-Wsi_mean,'fro')];
        end
        RES{si,trial}={Wp_est Wc_est Ws_est Wsi(:,:,trial) Wsi_mean mp(:,end) mc(:,end) ms(:,end) ip ic is};
        
    end
    si
end
