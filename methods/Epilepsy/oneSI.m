dim=4;
txt=[];
rtxt=[];
subj_idx_no(1)=0;
nj=numel(subj);
for ci=1:numel(subj)
    
    txt=[txt ',' subj{ci} '_fsEEG(iall(:,' num2str(ci) '),:,:,:)'];
    rtxt=[rtxt ',' subj{ci} '_frsEEG(iall(:,' num2str(ci) '),:,:,:)'];
    if ci==1
    eval(['subj_idx_no(ci)=size(' subj{ci} '_fsEEG,dim);'])
    else
    eval(['subj_idx_no(ci)=subj_idx_no(ci-1)+size(' subj{ci} '_fsEEG,dim);'])
    end   
    
end
for ci=numel(subj)+1:2*numel(subj)
       
    eval(['subj_idx_no(ci)=subj_idx_no(ci-1)+size(' subj{ci-numel(subj)} '_frsEEG,dim);'])   
    
end
eval(['Xx=cat(4' txt rtxt ');'])
for ci=1:numel(subj)
    if ci==1
    subj_idx{ci}=[ 1:subj_idx_no(ci) subj_idx_no(ci+nj-1)+1:subj_idx_no(ci+nj)];
    else
    subj_idx{ci}=[ subj_idx_no(ci-1)+1:subj_idx_no(ci) subj_idx_no(ci+nj-1)+1:subj_idx_no(ci+nj)];
    end      
end

full_labels(1:size(Xx,dim))=1;
full_labels(subj_idx_no(nj)+1:end)=-1;

Xspike=Xx(:,:,:,full_labels==1);
ktype='poly';
order=1;

for sici=1:numel(subj)
    
    fprintf(num2str(sici))
    labels=full_labels;
    labels(subj_idx{sici})=0;     
    outidxs=labels;
    outidxs(outidxs~=0)=-1;
    outidxs(outidxs==0)=1;
    
    Xtr=Xx(:,:,:,labels~=0);
    Xtr=reshape(Xtr,size(Xtr,4),[]);
    Xtst=Xx(:,:,:,labels==0);
    elem=size(Xtst,4)/2;
    Ytst_sp=Xtst(:,:,:,1:elem);
    Ytst_sp=reshape(Ytst_sp,size(Ytst_sp,4),[]);
    Ytst_nsp=Xtst(:,:,:,elem+1:end);
    Ytst_nsp=reshape(Ytst_nsp,size(Ytst_nsp,4),[]);
    
    [a b c d]=svmoneclass(Xtr,ktype,order,.9,0);
    y=svmoneclassval(Ytst_sp,a,b,c,ktype,order);
    yr=svmoneclassval(Ytst_nsp,a,b,c,ktype,order);
    
    perf(sici)=( 1-sum(yr<mean(y))/numel(y)+sum(y<mean(y))/numel(y))/2;
    fp{si}=y;
    fn{sici}=yr;
    
end

