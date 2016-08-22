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
Er=[];
Options=[];
Alpha=[0 10 50 100 300 500 1000];
for a=1:numel(Alpha)
for q = 1:length(Conn_full)
    G=[];Y=[];err=[];
    X=abs(freqc{q}.fourierspctrm);
    
    fbin=10;
    for period=1:periods
        Y(period,:,:,:)=X(period:5:end,:,:);
        G{period}=(weight_conversion(mean((conn_full{q,period}.(parameter)(:,:,:)),3),'normalize'));
    
%           G{period}=weight_conversion(rand(128,128),'normalize');
             G{period}(eye(128)==1)=0;
    end      
%     A=[0 1 0 0 0; 1 0 1 0 0; 0 1 0 1 0 ; 0 0 1 0 1 ; 0 0 0 1 0];
    Y=permute(Y,[4 3 2 1]);
    ntrials=size(Y,3);
    Ytst=Y(:,:,round(ntrials/2)+1:end,:);
   
%     [Fp{q},Ip(q),Exp(q),e,Concp(q)]=parafac_reg(Y,8,G,Options,[0 0 0 0]);
    [Fp{q},Yest,Ip(q),Exp(q),e]=parafac_reg(Ytst,6,G,Alpha(a),Options,[2 8 2 2]);
    mYtst=mean(Ytst,3);
    for i=1:size(Yest,3)
        tmp=Yest(:,:,i,:);
        err(i)=norm(tmp(:)-mYtst(:),'fro');
    end
    Er(a,q,:)=[ e mean(err)];
    %     [Ft{q},Gt{q},Ext(q)]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
    
    
end
end



