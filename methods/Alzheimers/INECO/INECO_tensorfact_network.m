if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/INECO/INECO_fieldtrip/';
    save_folder='/home/lspyrou/Documents/results/INECO/';
end


%%

fidx_patients=find(gc_idx(:,1)==1);
fidx_patients_shape=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==1));
fidx_patients_bind=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==0));

fidx_controls=find(gc_idx(:,1)==0);
fidx_controls_shape=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==1));
fidx_controls_bind=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==0));

periods=5;

Er=[];Options(1)=.1;Options(6)=100;W=[];Fp=[];Rpen=[];conc=[];Exp=[];Ip=[];Yest=[];
for si=1:length(conn_full)
    for period=1:periods
        W(si,period,:,:)=G2v(weight_conversion(abs(conn_full{si,period}.(parameter)(:,:,:)),'normalize'));
    end
end

W=permute(W,[3 4 2 1]);

for q=1:length(Conn_full)
    
    Y=W(:,:,:,q);    
    [Fp{q},Yest{q},Ip(q),Exp(q),e,conc(q)]=parafac(Y,4,Options,[2 3 2]);
           
end


