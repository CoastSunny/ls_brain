sRw=[];
iRw=[];
fsRw=[];fiRw=[];
fsi=[];ffsi=[];fwsi=[];fR=[];ft=[];ft2=[];ft3=[];ft4=[];ft5=[];
labels=[];
labels2=[];
Res=[];Z=[];
% schannels=[11 3];

%idx2=min(num_examples+1,round(size(spikes,2)/2+1));
% idx1=round(size(spikes,2)/2);
% idx2=round(size(spikes,2)/2+1);


[badtr,vars]=idOutliers(sEEG,3,2);
sEEG=sEEG(:,:,~badtr);iEEG=iEEG(:,:,~badtr);
%cEEG=cEEG(:,:,~badtr);
spikes=spikes(:,~badtr);
idx1=min(num_examples,round(size(sEEG,3)/2));
idx2=idx1+1;
tr_examples=1:idx1;
tst_examples=idx2:round(size(spikes,2));
[badtr,vars]=idOutliers(rsEEG,3,2);
rsEEG=rsEEG(:,:,~badtr);riEEG=riEEG(:,:,~badtr);
%rcEEG=rcEEG(:,:,~badtr);
idx1=min(rnum_examples,round(size(rsEEG,3)/2));
idx2=idx1+1;
rtr_examples=1:idx1;
rtst_examples=idx2:size(rsEEG,3);


%tr_examples=tr_examples(spikes(2,tr_examples)>5);numel(tr_examples)

labels(tr_examples)=-1;
labels(numel(tr_examples)+1:numel(tr_examples)+numel(rtr_examples))=1;

full_labels(1:size(sEEG,3))=1;
full_labels(size(sEEG,3)+1:size(sEEG,3)+1+size(rsEEG,3))=1;

% cD=cat(3,cEEG(schannels,:,tr_examples),rcEEG(schannels,:,tr_examples));
% [csclsfr cfsres]=cvtrainLinearClassifier(cD,labels,[],10,'dim',3);
% fcD=spectrogram(cD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
% [fcsclsfr fcfsres]=cvtrainLinearClassifier(fcD,labels,[],10,'dim',4);

sD=cat(3,sEEG(schannels,:,tr_examples),rsEEG(schannels,:,rtr_examples));
[sclsfr sres]=cvtrainLinearClassifier(sD,labels,[],10,'dim',3);
ftrsres=sres.tstf(:,:,sres.opt.Ci);
wsD=cat(3,sy(:,:,tr_examples),rsy(:,:,rtr_examples));
[wsclsfr wsres]=cvtrainLinearClassifier(wsD,labels,[],10,'dim',3);
ftrwsres=wsres.tstf(:,:,wsres.opt.Ci);
F=[ftrsres ftrwsres];
we=inv(F'*F+1*norm(F,'fro'))*F'*labels';
fsD=cat(4,fsEEG(schannels,:,:,tr_examples),frsEEG(schannels,:,:,rtr_examples));
[fsclsfr fsres]=cvtrainLinearClassifier(fsD,labels,[],10,'dim',4);
fsD2=cat(4,fsEEG2(:,:,:,tr_examples),frsEEG2(:,:,:,rtr_examples));
[fsclsfr2 fsres2]=cvtrainLinearClassifier(fsD2,labels,[],10,'dim',4);

iD=cat(3,iEEG(ichannels,:,tr_examples),riEEG(ichannels,:,rtr_examples));
[iclsfr ires]=cvtrainLinearClassifier(iD,labels,[],10,'dim',3);

fiD=cat(4,fiEEG(ichannels,:,:,tr_examples),friEEG(ichannels,:,:,rtr_examples));
[ficlsfr fires]=cvtrainLinearClassifier(fiD,labels,[],10,'dim',4);

K=12;
q=[];e=[];dv=ires.tstf(:,:,ires.opt.Ci);
W=iclsfr.W';
w=W(:);
%w=randn(size(w));
for i=1:size(sD,3)

    Z(:,:,i)=kron(eye(K),sD(:,:,i))';
    z=Z(:,:,i);
%     q(:,:,i) = inv( z' * w * w' * z ) ;
%     e(:,i) = z' * w * dv(i);
    
end

f=ires.tstf(:,:,ires.opt.Ci);
X_dash=tprod(w,[-1],Z(:,:,:),[-1 1 2]);
%Bls=inv(X_dash*X_dash'+0*norm(X_dash,'fro'))*X_dash*f;
X_dash=tprod(w,[-1],Z,[-1 1 2]);

%labels=sign(ires.tstf(:,:,ires.opt.Ci));
%labels=sign(ires.opt.f);
[w2clsfr w2res]=cvtrainLinearClassifier(X_dash,labels,[],10,'dim',2);
%w2clsfr.W=randn(size(w2clsfr.W));
B=reshape(w2clsfr.W,20,12)';
%B=ws';
% b=sum(q,3)*sum(e,2);
%B=reshape(Bls,18,14)';
isD=tprod(B,[1 -1],sD,[-1 2 3]);
[w3clsfr w3res]=cvtrainLinearClassifier(isD,labels,[],10,'dim',3);

fisD=spectrogram(isD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
[fw3clsfr fw3res]=cvtrainLinearClassifier(fisD,labels,[],10,'dim',4);



    








