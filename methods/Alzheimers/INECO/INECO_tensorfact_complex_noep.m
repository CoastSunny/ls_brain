
%%

fidx_patients=find(gc_idx(:,1)==1);
fidx_patients_shape=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==1));
fidx_patients_bind=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==0));

fidx_controls=find(gc_idx(:,1)==0);


Er=[];Options=0.001;Options(4)=2;W=[];Fp=[];Rpen=[];

clear j

% Alpha=[0 10 50 100 300 500 1000 1500 2000 3000 5000 7000 ];icassp
Alpha=[0 1 10 20 35 50 100 500 1000];%icassp
Alpha=[0];
AA=random_modular_graph(128,4,1,1);
%%

for a=1:numel(Alpha)
    for q = 1:length(conn_full)
        G=[];Y=[];err=[];
        X=(freqc{q}.fourierspctrm);
             
        dis_pen=0;
        temp=AA;temp(33:end,33:end)=0;
        temp([33:end],[1:32])=dis_pen;temp([1:32],[33:end])=dis_pen;temp(eye(128)==1)=0;G{1}=temp;
        temp=AA;temp([1:32 65:end],[1:32 65:end])=0;
        temp([1:32 65:end],[33:64])=dis_pen;temp([33:64],[1:32 65:end])=dis_pen;temp(eye(128)==1)=0;G{2}=temp;
        temp=AA;temp([1:64 97:end],[1:64 97:end])=0;
        temp([1:64 97:end],[65:96])=dis_pen;temp([65:96],[1:64 97:end])=dis_pen;temp(eye(128)==1)=0;G{3}=temp;
        temp=AA;temp([1:96],[1:96])=0;
        temp([1:96],[97:end])=dis_pen;temp([97:end],[1:96])=dis_pen;temp(eye(128)==1)=0;G{4}=temp;
        temp=zeros(size(AA));temp([1:32],[65:96])=1;temp([65:96],[1:32])=1;
        temp([65:96], [33:end])=dis_pen;temp([33:end],[65:96])=dis_pen;temp(eye(128)==1)=0;G{5}=temp;       
     
        Y=permute(X,[3 2 1]);
        Ys{q}=Y;
        ntrials=size(Y,3);
        Ytst=Y(:,:,round(ntrials/2)+1:end,:);
        Ytr=Y(:,:,1:round(ntrials/2),:);clear i
        %Y=squeeze(mean(Ytst,3));
%         for trial=1:size(Ytst,3)
            
%             Y=squeeze(Ytst(:,:,trial,:));
            %Ytst=randn(10,10,10)+randn(10,10,10)*i;
            %[Fp{q},Ip(q),Exp(q),e,Concp(q)]=parafac_reg(Y,8,G,Options,[0 0 0 0]);
        [Fp{a,q},Yest,Ip(q),Exp(q,a),e,Rpen{a,q}]=parafac_reg(Y,55,G,Alpha(a),Options,[9 9 0]);
            
%         end
%         [tmp]=parafac(Ytst,22,Options,[0 0 0 0]);

%         mYtst=mean(Ytst,3);
        mYtr=mean(Ytr,3);
        for i=1:size(Yest,3)
            tmp=Yest(:,:,i,:);
            err(i)=norm(abs(tmp(:))-abs(mYtr(:)),'fro');
        end
         Er(a,q,:)=[ e mean(err)];
%         %     [Ft{q},Gt{q},Ext(q)]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
        
        
    end
end



