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
par1=.001;par2=1000;
Cs=5.^[6:-1:-6];

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

% cD=cat(3,cEEG(schannels,:,:),rcEEG(schannels,:,:));
% [cclsfr, cres]=cvtrainLinearClassifier(cD,labels,[],10,'dim',3);
% cperf=cvPerf(full_labels',cres.tstf(:,:,cres.opt.Ci),[1 2 3],outidxs',losstype);
%
% fcD=spectrogram(cD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% [fcclsfr, fcres]=cvtrainLinearClassifier(fcD,labels,[],10,'dim',4);
% fcperf=cvPerf(full_labels',fcres.tstf(:,:,fcres.opt.Ci),[1 2 3],outidxs',losstype);
%
% ciD=cat(3,ciEEG(ichannels,:,:),rciEEG(ichannels,:,:));
% [ciclsfr, cires]=cvtrainLinearClassifier(ciD,labels,[],10,'dim',3);
% ciperf=cvPerf(full_labels',cres.tstf(:,:,cres.opt.Ci),[1 2 3],outidxs',losstype);
%
% fciD=spectrogram(ciD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% [fciclsfr, fcires]=cvtrainLinearClassifier(fciD,labels,[],10,'dim',4);
% fciperf=cvPerf(full_labels',fcires.tstf(:,:,fcres.opt.Ci),[1 2 3],outidxs',losstype);

% for chi=1:size(sEEG,1)
%
%     sD=cat(3,sEEG(chi,:,:),rsEEG(chi,:,:));
%     [clsfr, res]=cvtrainLinearClassifier(sD,labels,[],10,'dim',3);%,options);
%
%     temp=cvPerf(full_labels',res.tstf(:,:,res.opt.Ci),[1 2 3],outidxs',losstype);
%     schstst(chi)=temp.tstbin;
%     schstrn(chi)=temp.trnbin;
%
% end
% %schannels=find(schstrn>0.5);
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

sD=cat(3,sEEG(schannels,:,:),rsEEG(schannels,:,:));
[sclsfr, sres]=cvtrainKernelClassifier(sD,labels,Cs,10,'dim',3,'par1',par1,'par2',par2,'kerType',kerType);%,options);
sperf=cvPerf(full_labels',sres.tstf(:,:,sres.opt.Ci),[1 2 3],outidxs',losstype);

fsD=cat(4,fsEEG(schannels,:,:,:),frsEEG(schannels,:,:,:));
[fsclsfr, fsres]=cvtrainKernelClassifier(fsD,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
fsperf=cvPerf(full_labels',fsres.tstf(:,:,fsres.opt.Ci),[1 2 3],outidxs',losstype);

[U,G]=tucker(x,[8 8 -1]);
y=tprod(U{1},[-1 1],sD,[-1 2 3]);
z=tprod(y,[1 -1 3],U{2},[-1 2]);
[tclsfr, tres]=cvtrainKernelClassifier(z,labels,Cs,10,'dim',3,'par1',par1,'par2',par2,'kerType',kerType);%,options);
tperf=cvPerf(full_labels',tres.tstf(:,:,tres.opt.Ci),[1 2 3],outidxs',losstype);

[U,G]=tucker(fx,[6 6 6 -1]);
y=tprod(U{1},[-1 1],fsD,[-1 2 3 4]);
z=tprod(y,[1 -1 3 4],U{2},[-1 2]);
q=tprod(z,[1 2 -1 4],U{3},[-1 3]);
[ftclsfr, ftres]=cvtrainKernelClassifier(q,labels,Cs,10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);%,options);
ftperf=cvPerf(full_labels',ftres.tstf(:,:,ftres.opt.Ci),[1 2 3],outidxs',losstype);
% rand('state',0)
% sae=[];nn=[];
% tr_idx=3;
% ch=schannels;
% schstrn=ch;
% ch=1:16;
% tm=1:65;
% Xfull=cat(3,sEEG(ch,:,:),rsEEG(ch,:,:));
% Xtr=cat(3,sEEG(ch,:,tr_examples),rsEEG(ch,:,rtr_examples));
% n_examples=size(Xtr,tr_idx);
% szf=numel(ch)*numel(tm);
% Xtst=cat(3,sEEG(ch,:,numel(tr_examples)+1:end),rsEEG(ch,:,numel(rtr_examples)+1:end));
% layers=[szf szf/2 szf/4 szf/8];
% %layers=[szf szf szf];
% %layers=[szf 200 100 50];
% 
% sae=saesetup(layers);
% opts.numepochs =  5;
% opts.batchsize = n_examples;
% 
% for i=1:numel(layers)-1
%     
%     sae.ae{i}.activation_function       = 'sigm';
%     sae.ae{i}.learningRate              = 1;%.00000100;
%     sae.ae{i}.inputZeroMaskedFraction   = 0.0;
%     sae.ae{i}.output                    = 'linear';
%     sae.ae{i}.weightPenaltyL2           = 1.1;
%     sae.ae{i}.nonSparsityPenalty        = 1.1;
%     sae.ae{i}.scaling_learningRate      = 0.9;
%     
% end
% xtr=permute(Xfull,[2 1 3]);
% xtr=reshape(xtr,[],size(xtr,tr_idx))';
% xtr=(xtr(:,1:130));
% W=sae.ae{1}.W;w1=W{1};
% w1(1:5,1:5)
% [sae]=saetrain(sae,xtr,opts);
% W=sae.ae{1}.W;w1=W{1};
% w1(1:5,1:5)
% xin=sae.ae{1}.a{1}(:,2:end);er1=sae.ae{1}.e;xout1=sae.ae{1}.a{3};
% sae.ae{1}
% figure,hold on,plot(xin(3,:)','b'),plot(xout1(3,:)','r-.')
% 
% un_layers=fliplr(layers);
% flayers=[layers un_layers(2:end)];
% nn = nnsetup(flayers);
% nn.activation_function = 'tanh_opt';
% nn.output='linear';
% nn.learningRate = 1;
% nn.weightPenaltyL2 = 0.1;
% for i=1:numel(layers)-1
%     nn.W{i} = sae.ae{i}.W{1};
%     
% end
% for i=numel(layers):numel(flayers)-1
%     if i~=numel(flayers)-1
%         tmp=sae.ae{numel(flayers)-i}.W{1}(:,1:end-1);
%         tmp=[tmp' sae.ae{numel(flayers)-i-1}.W{1}(:,end)];
%         nn.W{i} = tmp;
%     else
%         tmp=sae.ae{numel(flayers)-i}.W{1}(:,1:end-1);
%         tmp=[tmp' nn.W{numel(flayers)-1}(:,end)];
%         nn.W{i} = tmp;
%     end
% end
% % Train the FFNN
% opts.numepochs =  5;
% opts.batchsize = n_examples;
% nn = nntrain(nn, xtr, xtr, opts);
% 
% Xfull=permute(Xfull,[ 2 1 3]);
% xf=reshape(Xfull,[],size(Xfull,tr_idx))';
% m=size(xf, 1);
% xf=[ones(m,1) xf];
% 
% yf{1}=xf;
% for i=2:numel(layers)
%     yf{i}=sigm(yf{i-1} * nn.W{i - 1}');
%     yf{i}=[ones(m,1) yf{i}];
% end
% 
% HOF=yf{numel(layers)};

% [ertst, bad] = nntest(nn, Xtst, ytst'==1);
% [ertr, bad] = nntest(nn, Xtr, ytr'==1);
% HOF=outx;
%XHOF=reshape(HOF,numel(ch),numel(tm),n_examples);
% HOF=HOF(randperm(size(HOF,1)),:);
% labels(1:end)=-1;labels(1:size(sEEG,3))=1;
% [hofclsfr, hofres]=cvtrainKernelClassifier(HOF',labels,Cs,2,'dim',2,'par1',par1,'par2',par2,'kerType',kerType);
% hofperf=cvPerf(full_labels',hofres.tstf(:,:,hofres.opt.Ci),[1 2 3],outidxs',losstype);

% iD=cat(3,iEEG(ichannels,:,:),riEEG(ichannels,:,:));
% [iclsfr, ires]=cvtrainKernelClassifier(iD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType',kerType);
% iperf=cvPerf(full_labels',ires.tstf(:,:,ires.opt.Ci),[1 2 3],outidxs',losstype);
%
% fiD=cat(4,fiEEG(ichannels,:,:,:).^pp,friEEG(ichannels,:,:,:).^pp);
% [ficlsfr, fires]=cvtrainKernelClassifier(fiD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType',kerType);
% fiperf=cvPerf(full_labels',fires.tstf(:,:,fires.opt.Ci),[1 2 3],outidxs',losstype);

% wsD=cat(3,sy(:,:,:),rsy(:,:,:));
% [wsclsfr, wsres]=cvtrainLinearClassifier(wsD,labels,[],10,'dim',3);
% wsperf=cvPerf(full_labels',wsres.tstf(:,:,wsres.opt.Ci),[1 2 3],outidxs',losstype);
%
% fwsD=cat(4,fsEEG2(:,:,:,:),frsEEG2(:,:,:,:));
% [fwsclsfr, fwsres]=cvtrainLinearClassifier(fwsD,labels,[],10,'dim',4);
% fwsperf=cvPerf(full_labels',fwsres.tstf(:,:,fwsres.opt.Ci),[1 2 3],outidxs',losstype);


% K=numel(ichannels);M=numel(schannels);
% K;M;
% q=[];e=[];dv=ires.tstf(:,:,ires.opt.Ci);
% W=iclsfr.W';
% w=W(:);
% %w=randn(size(w));
% for i=1:size(sD,3)
%
%     Z(:,:,i)=kron(eye(K),sD(:,:,i))';
%     z=Z(:,:,i);
%     %     q(:,:,i) = inv( z' * w * w' * z ) ;
%     %     e(:,i) = z' * w * dv(i);
%
% end
%
% f=ires.tstf(labels~=0,:,ires.opt.Ci);
% tr=1:numel(f);
% %f=ires.opt.f(1:size(sEEG,3));
% X_dash=tprod(w,[-1],Z(:,:,labels~=0),[-1 1 2]);
% Bls=inv(X_dash(:,tr)*X_dash(:,tr)'+1*norm(X_dash(:,tr),'fro')*eye(size(X_dash,1)))*X_dash(:,tr)*f;
% f2=ires.tstf(labels==0,:,ires.opt.Ci);
% tr2=1:numel(f2);
% X_dash=tprod(w,[-1],Z(:,:,labels==0),[-1 1 2]);
% Bls2=inv(X_dash(:,tr2)*X_dash(:,tr2)'+1*norm(X_dash(:,tr2),'fro')*eye(size(X_dash,1)))*X_dash(:,tr2)*f2;
% X_dash=tprod(w,[-1],Z,[-1 1 2]);
% fprintf('check BLS on tst set if same');
%
% %labels=sign(ires.tstf(:,:,ires.opt.Ci));
% %labels=sign(ires.opt.f);
% [w2clsfr w2res]=cvtrainLinearClassifier(X_dash,labels,[],10,'dim',2);
% w2perf=cvPerf(full_labels',w2res.tstf(:,:,w2res.opt.Ci),[1 2 3],outidxs',losstype);
% %w2clsfr.W=randn(size(w2clsfr.W));
% B=reshape(w2clsfr.W,M,K)';
% isD=tprod(B,[1 -1],sD,[-1 2 3]);
% [w3clsfr w3res]=cvtrainLinearClassifier(isD,labels,[],10,'dim',3);
% w3perf=cvPerf(full_labels',w3res.tstf(:,:,w3res.opt.Ci),[1 2 3],outidxs',losstype);
%
% fisD=spectrogram(isD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% [fw3clsfr fw3res]=cvtrainLinearClassifier(fisD,labels,[],10,'dim',4);
% fw3perf=cvPerf(full_labels',fw3res.tstf(:,:,fw3res.opt.Ci),[1 2 3],outidxs',losstype);
%
% B2=reshape(Bls,M,K)';
% isD2=tprod(B2,[1 -1],sD,[-1 2 3]);
% [w4clsfr w4res]=cvtrainLinearClassifier(isD2,labels,[],10,'dim',3);
% w4perf=cvPerf(full_labels',w4res.tstf(:,:,w4res.opt.Ci),[1 2 3],outidxs',losstype);
%
% fisD2=spectrogram(isD2,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% [fw4clsfr fw4res]=cvtrainLinearClassifier(fisD2,labels,[],10,'dim',4);
% fw4perf=cvPerf(full_labels',fw4res.tstf(:,:,fw4res.opt.Ci),[1 2 3],outidxs',losstype);
%
% misD=cat(3,iD(:,:,1:numel(tr_examples)),isD2(:,:,numel(tr_examples)+1:size(sEEG,3)),...
%     iD(:,:,size(sEEG,3)+1:size(sEEG,3)+numel(rtr_examples)),...
%     isD2(:,:,size(sEEG,3)+numel(rtr_examples)+1:size(sEEG,3)+size(rsEEG,3)));
% [coolclsfr coolres]=cvtrainLinearClassifier(misD,labels,[],10,'dim',3);
% coolperf=cvPerf(full_labels',coolres.tstf(:,:,coolres.opt.Ci),[1 2 3],outidxs',losstype);
%
% fmisD=spectrogram(misD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% [fcoolclsfr fcoolres]=cvtrainLinearClassifier(fmisD,labels,[],10,'dim',4);
% fcoolperf=cvPerf(full_labels',fcoolres.tstf(:,:,fcoolres.opt.Ci),[1 2 3],outidxs',losstype);













