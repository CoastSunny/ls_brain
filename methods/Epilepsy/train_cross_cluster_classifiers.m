
Fp=[];Fn=[];
fsccx=[];
sccx=[];
dim=4
kerType='linear';par1=10;par2=0;
subj_idx_no(1)=size(A_S_fsEEG,dim);
subj_idx_no(2)=subj_idx_no(1)+size(B_G_fsEEG,dim);
subj_idx_no(3)=subj_idx_no(2)+size(E_N_fsEEG,dim);
subj_idx_no(4)=subj_idx_no(3)+size(C_R_fsEEG,dim);
subj_idx_no(5)=subj_idx_no(4)+size(D_L_fsEEG,dim);
subj_idx_no(6)=subj_idx_no(5)+size(A_S_frsEEG,dim);
subj_idx_no(7)=subj_idx_no(6)+size(B_G_frsEEG,dim);
subj_idx_no(8)=subj_idx_no(7)+size(E_N_frsEEG,dim);
subj_idx_no(9)=subj_idx_no(8)+size(C_R_frsEEG,dim);
subj_idx_no(10)=subj_idx_no(9)+size(D_L_frsEEG,dim);

subj_idx{1}=[ 1:subj_idx_no(1) subj_idx_no(5)+1:subj_idx_no(6)];
subj_idx{2}=[ subj_idx_no(1)+1:subj_idx_no(2) subj_idx_no(6)+1:subj_idx_no(7)];
subj_idx{3}=[ subj_idx_no(2)+1:subj_idx_no(3) subj_idx_no(7)+1:subj_idx_no(8)];
subj_idx{4}=[ subj_idx_no(3)+1:subj_idx_no(4) subj_idx_no(8)+1:subj_idx_no(9)];
subj_idx{5}=[ subj_idx_no(4)+1:subj_idx_no(5) subj_idx_no(9)+1:subj_idx_no(10)];

full_labels(1:size(Xx,dim))=1;
full_labels(subj_idx_no(5)+1:end)=-1;
clusters=4;
%%
for sici=1:numel(subj)
    fprintf(num2str(sici))
    labels=full_labels;
    labels(subj_idx{sici})=0;    
    outidxs=labels;
    outidxs(outidxs~=0)=-1;
    outidxs(outidxs==0)=1;
    
    Xx=cat(dim,A_S_fsEEG(iall(:,1),:,:,:),B_G_fsEEG(iall(:,2),:,:,:),E_N_fsEEG(iall(:,3),:,:,:),...
        C_R_fsEEG(iall(:,4),:,:,:),D_L_fsEEG(iall(:,5),:,:,:),...
        A_S_frsEEG(iall(:,1),:,:,:),B_G_frsEEG(iall(:,2),:,:,:),E_N_frsEEG(iall(:,3),:,:,:),...
        C_R_frsEEG(iall(:,4),:,:,:),D_L_frsEEG(iall(:,5),:,:,:));
    fsccx=[]; 
    Yy=Xx(:,:,:,outidxs==-1);
    labels=labels(outidxs==-1);
    for i=1:(size(Yy,4)/2)
      
        fsccx(i,:)=vec(Yy(:,:,:,i));              
        
    end
    [idx c]=kmeans(fsccx,clusters);
    
    for ci=1:clusters
        
        cidx=find(idx==ci);
        cidx=[cidx; cidx+(size(Yy,4)/2)];
        [fXxclsfr(sici,ci), fXxres(sici,ci)]=cvtrainKernelClassifier(Yy(:,:,:,cidx),labels(cidx),[],10,'dim',dim,'par1',par1,'par2',par2,'kerType',kerType);
        %Xxperf(sici)=cvPerf(full_labels',fXxres(sici).tstf(:,:,fXxres(sici).opt.Ci),[1 2 3],outidxs','bal');
       % f=apply
        
    end
    
   
    
end
%%
