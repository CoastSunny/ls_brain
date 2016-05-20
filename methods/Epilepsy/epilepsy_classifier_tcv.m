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
Cs=5.^[4:-1:-4];
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

fsD=cat(4,fsEEG(schannels,:,:,:),frsEEG(schannels,:,:,:));
[fsclsfr, fsres]=cvtrainKernelClassifier(fsD,labels,Cs,nfolds,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
fsperf=cvPerf(full_labels',fsres.tstf(:,:,fsres.opt.Ci),[1 2 3],outidxs',losstype);
%
% fiD=cat(4,fiEEG(ichannels,:,:,:),friEEG(ichannels,:,:,:));
% [ficlsfr, fires]=cvtrainKernelClassifier(fiD,labels,Cs,nfolds,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);
% fiperf=cvPerf(full_labels',fires.tstf(:,:,fires.opt.Ci),[1 2 3],outidxs',losstype);

% [U,G]=tucker(fx,[6 6 6 -1]);
% sels=SEL{ci};
% U=Us{ci};
y=tprod(U{1}(:,sels),[-1 1],fsD,[-1 2 3 4]);
z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
q=tprod(z,[1 2 -1 4],U{3}(:,selt),[-1 3]);
[ftsclsfr, ftsres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
ftsperf=cvPerf(full_labels',ftsres.tstf(:,:,ftsres.opt.Ci),[1 2 3],outidxs',losstype);

% y=tprod(U{1}(:,sels),[-1 1],cat(1,fsD,fiD),[-1 2 3 4]);
% z=tprod(y,[1 -1 3 4],U{2}(:,self),[-1 2]);
% q=tprod(z,[1 2 -1 4],U{3}(:,selt),[-1 3]);
% [fticlsfr, ftires]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
% ftiperf=cvPerf(full_labels',ftires.tstf(:,:,ftires.opt.Ci),[1 2 3],outidxs',losstype);

for idxf=self
            y=tprod(U{1},[-1 1],fsD,[-1 2 3 4]);
            z=tprod(y,[1 -1 3 4],U{2}(:,idxf),[-1 2]);
            q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
            [temp, ftsres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
            ftsclsfrsf{idxf}=temp;
            ftsperfs=cvPerf(full_labels',ftsres.tstf(:,:,ftsres.opt.Ci),[1 2 3],outidxs',losstype);
            resultf(idxf,ci)=ftsperfs.trnbin;
            fresultf(idxf,ci)=mean(1./(1+exp(-(ftsres.tstf(ftsres.tstf(:,:,ftsres.opt.Ci)>0,:,ftsres.opt.Ci)))));
end
for idxt=selt
            y=tprod(U{1},[-1 1],fsD,[-1 2 3 4]);
            z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
            q=tprod(z,[1 2 -1 4],U{3}(:,idxt),[-1 3]);
            [temp, ftsres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
            ftsclsfrst{idxt}=temp;
            ftsperfs=cvPerf(full_labels',ftsres.tstf(:,:,ftsres.opt.Ci),[1 2 3],outidxs',losstype);
            resultt(idxt,ci)=ftsperfs.trnbin;
            fresultt(idxt,ci)=mean(1./(1+exp(-(ftsres.tstf(ftsres.tstf(:,:,ftsres.opt.Ci)>0,:,ftsres.opt.Ci)))));

end
for idxs=sels
            y=tprod(U{1}(:,idxs),[-1 1],fsD,[-1 2 3 4]);
            z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
            q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
            [temp, ftsres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
            ftsclsfrss{idxs}=temp;
            ftsperfs=cvPerf(full_labels',ftsres.tstf(:,:,ftsres.opt.Ci),[1 2 3],outidxs',losstype);
            results(idxs,ci)=ftsperfs.trnbin;
            fresults(idxs,ci)=mean(1./(1+exp(-(ftsres.tstf(ftsres.tstf(:,:,ftsres.opt.Ci)>0,:,ftsres.opt.Ci)))));

end
temp=2*size(fxA{ci},4);
ppp=binomial_confidence(temp);
ss=find(results(:,ci)<(0.5+ppp));
ss2=find(results(:,ci)>(0.5+ppp));if (isempty(ss2));ss2=1;end;
NSELs{ci}=ss;
SELs{ci}=ss2;
ff=find(resultf(:,ci)<(0.5+ppp));
ff2=find(resultf(:,ci)>(0.5+ppp));if (isempty(ff2));ff2=1;end;
NSELf{ci}=ff;
SELf{ci}=ff2;
tt=find(resultt(:,ci)<(0.5+ppp));
tt2=find(resultt(:,ci)>(0.5+ppp));if (isempty(tt2));tt2=1;end;
NSELt{ci}=tt;
SELt{ci}=tt2;
% 
y=tprod(U{1}(:,ss2),[-1 1],fsD,[-1 2 3 4]);
z=tprod(y,[1 -1 3 4],U{2}(:,:),[-1 2]);
q=tprod(z,[1 2 -1 4],U{3}(:,:),[-1 3]);
[ftsclsfr, ftsres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
ftsperf=cvPerf(full_labels',ftsres.tstf(:,:,ftsres.opt.Ci),[1 2 3],outidxs',losstype);
% 
% 
% for idxs=sels
%     for idxf=self
%         for idxt=selt
%             y=tprod(U{1}(1:20,idxs),[-1 1],fsD,[-1 2 3 4]);
%             z=tprod(y,[1 -1 3 4],U{2}(:,idxf),[-1 2]);
%             q=tprod(z,[1 2 -1 4],U{3}(:,idxt),[-1 3]);
%             [temp, ftsres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
%             ftsclsfrs{idxs,idxf,idxt}=temp;
%             ftsperfs=cvPerf(full_labels',ftsres.tstf(:,:,ftsres.opt.Ci),[1 2 3],outidxs',losstype);
%             result(idxs,idxf,idxt)=ftsperfs.trnbin;
%         end
%     end
% end