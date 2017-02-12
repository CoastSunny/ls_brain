
%%

fidx_patients=find(gc_idx(:,1)==1);
fidx_patients_shape=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==1));
fidx_patients_bind=intersect(find(gc_idx(:,1)==1),find(gc_idx(:,2)==0));

fidx_controls=find(gc_idx(:,1)==0);


% Options=0.00001;Options(4)=2;
Options=[];
Options(1)=10^-3;
Options(3)=0;
Options(5)=0;
Er=[];W=[];Fp=[];Rpen=[];FT=[];EV=[];

clear j

% Alpha=[0 10 50 100 300 500 1000 1500 2000 3000 5000 7000 ];icassp
Alpha=[0 1 10 20 35 50 100 500 1000];%icassp
Alpha=[0];

%%
count=0;
for a=1
     count=count+1; 
    for q = 1:length(freqc)
        G=[];Y=[];err=[];
        X=(freqc{q}.fourierspctrm);
          
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
        %         [Fp{a,q},Yest,Ip(q),Exp(q,a),e,Rpen{a,q}]=parafac_reg(Y,35,G,Alpha(a),Options,[9 9 0]);
        ncomps=100;
        Y=permute(Y,[2 3 1]);
        [FT{count,q}{1} FT{count,q}{2} FT{count,q}{3} FT{count,q}{4} FT{count,q}{5} EV(count,q)]=parafac2(Y,ncomps,[4 4],Options);
        
        %         end
        %         [tmp]=parafac(Ytst,22,Options,[0 0 0 0]);
        
%         %         mYtst=mean(Ytst,3);
%         mYtr=mean(Ytr,3);
%         for i=1:size(Yest,3)
%             tmp=Yest(:,:,i,:);
%             err(i)=norm(abs(tmp(:))-abs(mYtr(:)),'fro');
%         end
%         Er(a,q,:)=[ e mean(err)];
        %         %     [Ft{q},Gt{q},Ext(q)]=tucker(Y,[2 2 -1],Options,[0 0 -1]);
        
        
    end
end



