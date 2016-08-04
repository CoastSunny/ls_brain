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
periods=5;
G=[];Y=[];
Options=[];
for q = 15%1:length(Conn_full)
    
    X=abs(freqc{q}.fourierspctrm);
      fbin=5;
    for period=1:periods
        Y(period,:,:,:)=X(period:5:end,:,:);
        G{period}=(weight_conversion(mean(abs(conn_full{q,period}.wpli_debiasedspctrm(:,:,fbin)),3),'normalize'));
    end      
    Y=permute(Y,[4 3 2 1]);
    [Fp{q},Ip(q),Exp(q),e,Concp(q)]=parafac_reg(Y,6,G,Options,[2 7 2 2]);
    %     [Ft{q},Gt{q},Ext(q)]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
    
    
end




