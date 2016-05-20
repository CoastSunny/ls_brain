
itest=1:numel(subj);
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
ktype='gaussian';
order=1000;

for sici=1:numel(subj)
    
    fprintf(num2str(sici))
    try cd /media/louk/Storage/Raw/Epilepsy/
    catch err
        cd ~/Documents/Epilepsy/
    end
    load(subj{sici})
    eval(['X=' subj{sici} ';'])
    
    fs=200;
    len=size(X,2);
    filt=mkFilter(freqband,floor(len/2),fs/len);
    X=fftfilter(X,filt,[0 len],2,1);
    X=X(sEEG_idx,:);
    X = repop(X,'-',mean(X,1));
    X=X(iall(:,sici),:);
    
    fprintf(num2str(sici))
    labels=full_labels;
    labels(subj_idx{sici})=0;
    outidxs=labels;
    outidxs(outidxs~=0)=-1;
    outidxs(outidxs==0)=1;
    excl=[1 5 9 4 8];
   
    Xtst=Xx(:,:,:,labels==0);
    elem=size(Xtst,4)/2;
    Ytst_sp=Xtst(:,:,:,1:elem);
    Ytst_sp=reshape(Ytst_sp,[],size(Ytst_sp,4))';
    Ytst_nsp=Xtst(:,:,:,elem+1:end);
    Ytst_nsp=reshape(Ytst_nsp,[],size(Ytst_nsp,4))';
    for excli=1:numel(excl)    
        labels(subj_idx{excl(excli)})=0;        
    end    
    Xtr=Xx(:,:,:,labels~=0);
    Xtr=reshape(Xtr,[],size(Xtr,4))';
    tic
    [a{sici} b{sici} c{sici} d{sici}]=svmoneclass(Xtr,ktype,order,.9,0);
    toc
    y=svmoneclassval(Ytst_sp,a{sici},b{sici},c{sici},ktype,order);
    yr=svmoneclassval(Ytst_nsp,a{sici},b{sici},c{sici},ktype,order);
    perf(sici)=( 1-sum(yr<mean(y))/numel(y)+sum(y<mean(y))/numel(y))/2
    fp{si}=y;
    fn{sici}=yr;
    
%     fsY=zeros(16,9,7,size(X,2)-l);
%     
%     for i=2*l+1:1:size(X,2)-l
%         
%         bsEEG=mean(X(:,i-2*pre_samples-1*post_samples-1:i-1*pre_samples-1),2);
%         sY=repop(X(:,i-pre_samples:i+post_samples),'-',bsEEG);
%         sY=ls_whiten(sY,5,0);
%         sY=detrend(sY,2);
%         fsY(:,:,:,i)=spectrogram(sY,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);                
%         
%     end
%     
%     dv=[];
%     for i2=1:round(size(fsY,4)/10000)
%         nl=10000;
%         if i2==round(size(fsY,4)/10000)
%             nl2=size(fsY,4)-(i2-1)*10000;
%             dv=[dv svmoneclassval(reshape(fsY(:,:,:,(i2-1)*nl+1:end),[],nl2)',a{sici},b{sici},c{sici},ktype,order)'];
%         else
%             dv=[dv svmoneclassval(reshape(fsY(:,:,:,(i2-1)*nl+1:i2*nl),[],nl)',a{sici},b{sici},c{sici},ktype,order)'];
% 
%         end
%     end
% 
%     
%     eval([subj{sici} 'sRw=dv;'])
    

    
end

