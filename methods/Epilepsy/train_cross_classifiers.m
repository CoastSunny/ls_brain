%% 1) channel selection
%% 2) spatial information
%% 3) adaptive classifier
%% 4) rank 1- hs approximation for channel selection problem
%% 5) permute manually the channels for the test subject and see what happens
Fp=[];Fn=[];

% % for tr=1:size(A_S_fsEEG,3)
% %  A_S_fsEEG(:,:,:,tr)=A_S_fsEEG(randperm(18),:,:,tr); 
% %  A_S_frsEEG(:,:,:,tr)=A_S_frsEEG(randperm(18),:,:,tr);       
% % end
% for tr=1:size(B_G_fsEEG,3)
%  B_G_fsEEG(:,:,:,tr)=B_G_fsEEG(randperm(18),:,:,tr);
%  B_G_frsEEG(:,:,:,tr)=B_G_frsEEG(:,:,:,tr);
% end
% for tr=1:size(E_N_fsEEG,3)
%  E_N_fsEEG(:,:,:,tr)=E_N_fsEEG(randperm(18),:,:,tr);
%  E_N_frsEEG(:,:,:,tr)=E_N_frsEEG(:,:,:,tr);
% end
% for tr=1:size(C_R_fsEEG,3)
%  C_R_fsEEG(:,:,:,tr)=C_R_fsEEG(randperm(18),:,:,tr);
%  C_R_frsEEG(:,:,:,tr)=C_R_frsEEG(:,:,:,tr);
% end
% for tr=1:size(D_L_fsEEG,3)
%   D_L_fsEEG(:,:,:,tr)=D_L_fsEEG(randperm(18),:,:,tr);
%   D_L_frsEEG(:,:,:,tr)=D_L_frsEEG(:,:,:,tr);
% end                           
    
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
       
    eval(['subj_idx_no(ci)=subj_idx_no(ci-1)+size(' subj{ci-26} '_frsEEG,dim);'])   
    
end
eval(['Xx=cat(4' txt rtxt ');'])
y=tprod(U{1},[-1 1],Xx,[-1 2 3 4]);
z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
for ci=1:numel(subj)
    if ci==1
    subj_idx{ci}=[ 1:subj_idx_no(ci) subj_idx_no(ci+nj-1)+1:subj_idx_no(ci+nj)];
    else
    subj_idx{ci}=[ subj_idx_no(ci-1)+1:subj_idx_no(ci) subj_idx_no(ci+nj-1)+1:subj_idx_no(ci+nj)];
    end      
end

full_labels(1:size(Xx,dim))=1;
full_labels(subj_idx_no(nj)+1:end)=-1;

%%
for sici=1:numel(subj)
    fprintf(num2str(sici))
    labels=full_labels;
    labels(subj_idx{sici})=0;    
    outidxs=labels;
    outidxs(outidxs~=0)=-1;
    outidxs(outidxs==0)=1;
    
    [fXxclsfr(sici), fXxres(sici)]=cvtrainKernelClassifier(q,labels,[],4,'dim',dim,'par1',par1,'par2',par2,'kerType',kerType);
    Xxperf(sici)=cvPerf(full_labels',fXxres(sici).tstf(:,:,fXxres(sici).opt.Ci),[1 2 3],outidxs','bal');
    
    fl=full_labels;
    fl(outidxs==-1)=0;
    f=Xxperf(sici).fold.f;
%     dm(sici)=multitrial_performance(f,fl','all',1,'sav',1,1,0,0,[]);
    xfSS(sici,:)=[Xxperf(sici).tstconf(4)/(Xxperf(sici).tstconf(3)+Xxperf(sici).tstconf(4))...
        Xxperf(sici).tstconf(1)/(Xxperf(sici).tstconf(1)+Xxperf(sici).tstconf(2))];
    
    xtfSS(sici,:)=[Xxperf(sici).trnconf(4)/(Xxperf(sici).trnconf(3)+Xxperf(sici).trnconf(4))...
        Xxperf(sici).trnconf(1)/(Xxperf(sici).trnconf(1)+Xxperf(sici).trnconf(2))];
    
    Fp{sici}=f(fl==1);
    Fn{sici}=f(fl==-1);
    
end
%%
