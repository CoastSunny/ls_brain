sRw=[];
iRw=[];
fsRw=[];fiRw=[];
fsi=[];ffsi=[];fwsi=[];fR=[];ft=[];ft2=[];ft3=[];ft4=[];ft5=[];
labels=[];
labels2=[];
Res=[];Z=[];
schannels=1:size(sEEG,1);
ichannels=1:size(iEEG,1);
options=[];
%options={'calibrate' []};
losstype='bal';
kerType='linear';
par1=500;par2=[];
Cs=5.^[6:-1:-6];
nfolds=10;

labels=[];
labels(1:size(sEEG,3)+size(rsEEG,3))=0;
labels(1:numel(tr_examples))=1;
labels(size(sEEG,3)+1:size(sEEG,3)+numel(rtr_examples))=-1;
outidxs=labels;
outidxs(outidxs~=0)=-1;
outidxs(outidxs==0)=1;
full_labels=[];
full_labels(1:size(sEEG,3))=1;
full_labels(size(sEEG,3)+1:size(sEEG,3)+size(rsEEG,3))=-1;


%% single channel classifiers
% f=[];
% SCfsclsfr=[];
% for chi=1:size(sEEG,1)
%
%     fsD=cat(4,fsEEG(chi,:,:,:),frsEEG(chi,:,:,:));
%     [clsfr, res]=cvtrainKernelClassifier(fsD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
%
%     temp=cvPerf(full_labels',res.tstf(:,:,res.opt.Ci),[1 2 3],outidxs',losstype);
%     schstrn(chi)=temp.trnbin;
%     f(:,chi)=res.tstf(:,:,res.opt.Ci);
%     SCfsclsfr{end+1}=clsfr;
% end
% out=fperf(mean(f,2),labels');
% cr=out.perf;
%  eval(['schstrn=' subj{ci} 'schstrn;']);
% [m i]=sort(schstrn);
% schannels=i(end-15:end)
%schannels=find(schstrn>0.65);

% % chstst=[];chstrn=[];
% for chi=1:size(iEEG,1)
%
%     iD=cat(3,iEEG(chi,:,:),riEEG(chi,:,:));
%     [clsfr, res]=cvtrainLinearClassifier(iD,labels,[],10,'dim',3);%,options);
%
%     temp=cvPerf(full_labels',res.tstf(:,:,res.opt.Ci),[1 2 3],outidxs',losstype);
%     ichstst(chi)=temp.tstbin;
%     ichstrn(chi)=temp.trnbin;
%
% end
% %ichannels=find(ichstrn>0.5);

%% multi channel classifiers pp=1;

sD=cat(3,sEEG(schannels,:,:,:),rsEEG(schannels,:,:,:));
[sclsfr, sres]=cvtrainKernelClassifier(sD,labels,Cs,nfolds,'dim',3,'par1',par1,'par2',par2,'kerType',kerType);%,options);
sperf=cvPerf(full_labels',sres.tstf(:,:,sres.opt.Ci),[1 2 3],outidxs',losstype);

fsD=cat(4,fsEEG(schannels,:,:,:),frsEEG(schannels,:,:,:));
[fsclsfr, fsres]=cvtrainKernelClassifier(fsD,labels,Cs,nfolds,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
fsperf=cvPerf(full_labels',fsres.tstf(:,:,fsres.opt.Ci),[1 2 3],outidxs',losstype);

% %% intra
iD=cat(3,iEEG(:,:,:),riEEG(:,:,:));
[iclsfr, ires]=cvtrainKernelClassifier(iD,labels,Cs,10,'dim',3,'par1',par1,'par2',par2,'kerType',kerType);%,options);
iperf=cvPerf(full_labels',ires.tstf(:,:,ires.opt.Ci),[1 2 3],outidxs',losstype);

fiD=cat(4,fiEEG(ichannels,:,:,:),friEEG(ichannels,:,:,:));
[ficlsfr, fires]=cvtrainKernelClassifier(fiD,labels,Cs,nfolds,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);
fiperf=cvPerf(full_labels',fires.tstf(:,:,fires.opt.Ci),[1 2 3],outidxs',losstype);


