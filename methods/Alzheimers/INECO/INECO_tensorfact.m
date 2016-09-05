if isunix==0
    data_folder='D:\Raw\AlzheimerEEG\Multivariate AFAVA artefact free';
    save_folder='D:\Extracted\Alzheimer\Multivariate AFAVA artefact free\AFAVA_1sectrials\';
else
    data_folder='/home/engbiome/INECO/INECO_fieldtrip/';
    save_folder='/home/lspyrou/Documents/results/INECO/';
end


%%

fidx_patients=find(gc_idx(:,1)==1);
fidx_patients_shape=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==0));
fidx_patients_bind=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==1));

fidx_controls=find(gc_idx(:,1)==0);
periods=5;

Er=[];Options=[];W=[];Fp=[];Rpen=[];
for si=1:length(conn_full)
    for period=1:periods
        W(si,period,:,:,:)=(weight_conversion(mean(abs(conn_full{si,period}.(parameter)(:,:,:)),3),'normalize'));
    end
end


% Alpha=[0 10 50 100 300 500 1000 1500 2000 3000 5000 7000 ];
Alpha=[0 300 2000 ];

AA=random_modular_graph(128,4,1,1);
for a=1:numel(Alpha)
    for q = [32 64]%1%:length(Conn_full)
        G=[];Y=[];err=[];
        X=abs(freqc{q}.fourierspctrm);
        
        fbin=10;
        for period=1:periods
            Y(period,:,:,:)=X(period:5:end,:,:);
            G{period}=(weight_conversion(mean(abs(conn_full{q,period}.(parameter)(:,:,:)),3),'normalize'));
            
            %         G{period}=weight_conversion(rand(128,128),'normalize');
                    G{period}=ones(128);
            %         G{period}=squeeze(mean(W(fidx_patients_bind,period,:,:),1));
            G{period}(eye(128)==1)=0;
           
        end
        temp=AA;temp(33:end,33:end)=0;temp(temp==0)=-1;temp(eye(128)==1)=0;G{1}=temp;
        temp=AA;temp([1:32 65:end],[1:32 65:end])=0;temp(temp==0)=-1;temp(eye(128)==1)=0;G{2}=temp;
        temp=AA;temp([1:64 97:end],[1:64 97:end])=0;temp(temp==0)=-1;temp(eye(128)==1)=0;G{3}=temp;
        temp=AA;temp([1:96],[1:96])=0;temp(temp==0)=-1;temp(eye(128)==1)=0;G{4}=temp;
        temp=AA;temp([33:64 97:end],[33:64 97:end]);temp(temp==0)=-1;temp(eye(128)==1)=0;G{5}=temp;
%         A{1}=[0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0];A{1}=A{1}+A{1}';A{1}(A{1}>1)=1;
%         A{2}=[0 1 0 0 0; 1 0 1 0 0; 0 0 0 0 0 ; 0 0 0 0 0 ; 0 0 0 0 0];A{2}=A{2}+A{2}';A{2}(A{2}>1)=1;
%         A{3}=[0 0 0 0 0; 0 0 1 0 0; 0 1 0 1 0 ; 0 0 0 0 0 ; 0 0 0 0 0];A{3}=A{3}+A{3}';A{3}(A{3}>1)=1;
%         A{4}=[0 0 0 0 0; 0 0 0 0 0; 0 0 0 1 0 ; 0 0 1 0 1 ; 0 0 0 1 0];
%         A{5}=[0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0 ; 0 0 0 0 1 ; 0 0 0 1 0];
%         A{1}(A{1}==0)=-1;A{1}(eye(5)==1)=0;
%         A{2}(A{2}==0)=-1;A{2}(eye(5)==1)=0;        
%         A{3}(A{3}==0)=-1;A{3}(eye(5)==1)=0;        
%         A{4}(A{4}==0)=-1;A{4}(eye(5)==1)=0;        
%         A{5}(A{5}==0)=-1;A{5}(eye(5)==1)=0;
%         
        
        
        %     A=[0 1 0 0 0; 1 0 1 0 0; 0 1 0 1 0 ; 0 0 1 0 1 ; 0 0 0 1 0];
        Y=permute(Y,[4 3 2 1]);
        Ys{q}=Y;
        ntrials=size(Y,3);
        Ytst=Y(:,:,round(ntrials/2)+1:end,:);
        Ytr=Y(:,:,1:round(ntrials/2),:);
        %     [Fp{q},Ip(q),Exp(q),e,Concp(q)]=parafac_reg(Y,8,G,Options,[0 0 0 0]);
        [Fp{a,q},Yest,Ip(q),Exp(q),e,Rpen{a,q}]=parafac_reg(Ytst,6,G,Alpha(a),Options,[2 7 2 2]);
        mYtst=mean(Ytst,3);
        mYtr=mean(Ytr,3);
        for i=1:size(Yest,3)
            tmp=Yest(:,:,i,:);
            err(i)=norm(tmp(:)-mYtr(:),'fro');
        end
        Er(a,q,:)=[ e mean(err)];
        %     [Ft{q},Gt{q},Ext(q)]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
        
        
    end
end



