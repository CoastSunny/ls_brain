if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/INECO/INECO_fieldtrip/';
    save_folder='/home/lspyrou/Documents/results/INECO/';
end

%%
fidx_patients=find(gc_idx(:,1)==1);
fidx_controls=find(gc_idx(:,1)==0);

for q = 1:length(Conn_full)
      
    Y=Conn_full{q};
    Options=.01;
    [Fp{q},Ip(q),Exp(q),e,Concp(q)]=parafac(Y,2,Options,[0 0 0]);
    [Ft{q},Gt{q},Ext(q)]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
    
    
end




