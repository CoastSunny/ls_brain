sRw=[];
iRw=[];
fsRw=[];fiRw=[];
fsi=[];ffsi=[];fwsi=[];fR=[];ft=[];ft2=[];ft3=[];ft4=[];ft5=[];

Res=[];
labels=[];
labels(1:numel(tst_examples))=-1;
labels(numel(tst_examples)+1:numel(tst_examples)+numel(rtst_examples))=1;
labels=labels';
sD=cat(3,sEEG(schannels,:,tst_examples),rsEEG(schannels,:,rtst_examples));
wsD=cat(3,sy(:,:,tst_examples),rsy(:,:,rtst_examples));
fsD=cat(4,fsEEG(schannels,:,:,tst_examples),frsEEG(schannels,:,:,rtst_examples));
fsD2=cat(4,fsEEG2(:,:,:,tst_examples),frsEEG2(:,:,:,rtst_examples));

% cD=cat(3,cEEG(schannels,:,tst_examples),rcEEG(schannels,:,rtst_examples));
% fcD=spectrogram(cD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);


iD=cat(3,iEEG(ichannels,:,tst_examples),riEEG(ichannels,:,rtst_examples));
fiD=cat(4,fiEEG(ichannels,:,:,tst_examples),friEEG(ichannels,:,:,rtst_examples));
X_dash=[];
K=12;
for i=1:size(sD,3)

    Z=kron(eye(K),sD(:,:,i))';
    X_dash(:,i)=tprod(w,[-1],Z,[-1 2]);
    
end


% [csi]=applyLinearClassifier(cD,csclsfr);
% [fcsi]=applyLinearClassifier(fcD,fcsclsfr);

[fsi]=applyLinearClassifier(sD,sclsfr);
[fwsi]=applyLinearClassifier(wsD,wsclsfr);
[ffsi]=applyLinearClassifier(fsD,fsclsfr);
[ffsi2]=applyLinearClassifier(fsD2,fsclsfr2);

[fii]=applyLinearClassifier(iD,iclsfr);
[ffii]=applyLinearClassifier(fiD,ficlsfr);

w2clsfr.spKey=[1 -1];
w2clsfr.spMx=[1 -1];
w3clsfr.spKey=[1 -1];
w3clsfr.spMx=[1 -1];
fw3clsfr.spKey=[1 -1];
fw3clsfr.spMx=[1 -1];

fw2=applyLinearClassifier(X_dash,w2clsfr);
isD=tprod(B,[1 -1],sD,[-1 2 3]);
fw3=applyLinearClassifier(isD,w3clsfr);
fisD=spectrogram(isD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
ffw3=applyLinearClassifier(fisD,fw3clsfr);

fw4=applyLinearClassifier(isD,iclsfr);
ffw4=applyLinearClassifier(fisD,ficlsfr);
% 
% Res(end+1)= fperf(csi,labels);
% Res(end+1)= fperf(fcsi,labels);

Res(end+1)= fperf(fsi,labels);
Res(end+1)= fperf(fwsi,labels);
Res(end+1)= fperf(ffsi,labels);
Res(end+1)= fperf(ffsi2,labels);

Res(end+1)= fperf(fii,labels);
Res(end+1)= fperf(ffii,labels);

Res(end+1)= fperf(fw2,labels);
Res(end+1)= fperf(fw3,labels);
Res(end+1)= fperf(ffw3,labels);

Res(end+1)= fperf(fw4,labels);
Res(end+1)= fperf(ffw4,labels);


% ft=fsi+fwsi;
% Res(end+1)=( sum( ft(1:numel(ft)/2) <0) +sum( ft(numel(ft)/2:end) >=0) )/numel(ft);
% %ftR=[Rs(1:200) Rrs(1:200)];
% %[Ab pf dvAb]=dvCalibrate(labels',ftR','bal');
% fR=[Rs(idx2:idx3) Rrs(idx2:idx3)];
% %fR=Ab(1)*fR+Ab(2);
% fR=(fR-mean(fR))/norm(fR)*norm(fsi);
% %fR=fR/norm(fR);
% Res(end+1)=( sum( fR(1:numel(fR)/2) <0) +sum( fR(numel(fR)/2:end) >=0) )/numel(fR);
% 
% ft2=fsi+fR';
% Res(end+1)=( sum( ft2(1:numel(ft2)/2) <0) +sum( ft2(numel(ft2)/2:end) >=0) )/numel(ft2);
% 
% ft3=ft+fR';
% Res(end+1)=( sum( ft3(1:numel(ft3)/2) <0) +sum( ft3(numel(ft3)/2:end) >=0) )/numel(ft3);
% 
% ft4=we(1)*fsi+we(2)*fwsi;
% Res(end+1)=( sum( ft4(1:numel(ft4)/2) <0) +sum( ft4(numel(ft4)/2:end) >=0) )/numel(ft4);
% 
% ft5=fsi+fwsi/std(fwsi)*std(fsi);
% Res(end+1)=( sum( ft5(1:numel(ft5)/2) <0) +sum( ft5(numel(ft5)/2:end) >=0) )/numel(ft5);
Res