if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/INECO/INECO_fieldtrip/';
    save_folder='/home/lspyrou/Documents/results/INECO/';
end

%%
% fidx_patients=find(gc_idx(:,1)==1);
% fidx_controls=find(gc_idx(:,1)==0);
for q =1% 1:length(Conn_full)
      
    Y=abs(freqc{q}.fourierspctrm);
    Options=1;
%     G=zeros(16);
%     G(1,2:5)=1;
    G=(abs(conn{1}.cohspctrm(:,:,4)));
    [Fp{q},Ip(q),Ep(q),Concp(q)]=parafac_reg(Y,4,G,Options,[0 7 2]);
%     [Ft{q},Gt{q}]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
    
    
end



