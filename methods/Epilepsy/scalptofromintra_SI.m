tRes=[];
sRes=[];
sR=[];
tR=[];
tlYtst=[];
tgYtst=[];
tYtst=[];
tlrYtst=[];
tgrYtst=[];
trYtst=[];
for ci=[1:3 5:8]%1:numel(subj)
    
    fprintf(num2str(ci))
    
    eval(['sEEG=' subj{ci} '_sEEG;']);
    eval(['rsEEG=' subj{ci} '_rsEEG;']);
    eval(['iEEG=' subj{ci} '_iEEG;']);
    eval(['riEEG=' subj{ci} '_riEEG;']);
    tmp=isnan(iEEG(:,1,1));
    iEEG(tmp,:,:)=[];
    riEEG(tmp,:,:)=[];
    sidx1=round(size(sEEG,3)/2);
    ridx1=round(size(rsEEG,3)/2);
    sidx2=size(sEEG,3);
    ridx2=size(rsEEG,3);
    
    I=iEEG;
    rI=riEEG;
    S=sEEG;
    rS=rsEEG;
    
    %% spatial method    
    ppp=1;
    
    %% TF
    
    Ytr=I(:,:,1:sidx2);%%Y-->Intra
    Ytst=I(:,:,1:sidx2);
    rYtr=rI(:,:,1:sidx2);%%Y-->Intra
    rYtst=rI(:,:,1:sidx2);%%Y-->Intra
    
    Xtr=S(:,:,1:sidx2);
    Xtst=S(:,:,1:sidx2);
    rXtr=rS(:,:,1:sidx2);
    rXtst=rS(:,:,1:sidx2);
    
    Ytr=cat(3,Ytr,rYtr);
    Xtr=cat(3,Xtr,rXtr);
    Ytst=cat(3,Ytst,rYtst);
    Xtst=cat(3,Xtst,rXtst);
    sY=I(:,:,1:sidx2);
    rsY=rI(:,:,1:sidx2);
    sX=sEEG(:,:,1:sidx2);
    rsX=rsEEG(:,:,1:sidx2);
    yD=cat(3,sY,rsY);
    xD=cat(3,sX,rsX);
    fyD=spectrogram(yD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxD=spectrogram(xD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    
    [clsfr, fyres]=cvtrainKernelClassifier(fyD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, fxres]=cvtrainKernelClassifier(fxD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    
    fyTr=spectrogram(Ytr,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxTr=spectrogram(Xtr,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    Xtr=reshape(fxTr,size(fxTr,1)*size(fxTr,2)*size(fxTr,3),size(fxTr,4));
    Ytr=reshape(fyTr,size(fyTr,1)*size(fyTr,2)*size(fyTr,3),size(fyTr,4));
    fyTs=spectrogram(Ytst,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxTs=spectrogram(Xtst,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    Xtst=reshape(fxTs,size(fxTs,1)*size(fxTs,2)*size(fxTs,3),size(fxTs,4));
    Ytst=reshape(fyTs,size(fyTs,1)*size(fyTs,2)*size(fyTs,3),size(fyTs,4));
    
    XX=[Xtr XX];
    YY=[Ytr YY];
    
    Copt=get_cv_krr(Xtr',Ytr');
    [alpha Y2l]=km_krr2(Xtr',Ytr','linear',[],Copt,Xtst');
    [Copt Sopt]=get_cv_sigma_krr(Xtr',Ytr');
    [alpha Y2g]=km_krr2(Xtr',Ytr','gauss',Sopt,Copt,Xtst');
%     [Copt S1opt S2opt]=get_cv_poly_krr(Xtr',Ytr');
%     [alpha Y2p]=km_krr2(Xtr',Ytr','poly',[S1opt S2opt],Copt,Xtst');
%     Y2g=Y2g(randperm(size(Y2g,1)),:);
    [clsfr, fgres]=cvtrainKernelClassifier(Y2g',labels,[],10,'dim',2,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, fpres]=cvtrainKernelClassifier(Y2p',labels,[],10,'dim',2,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, flres]=cvtrainKernelClassifier(Y2l',labels,[],10,'dim',2,'par1',par1,'par2',par2,'kerType','linear');
    
    Rf(ci,:)=[max(fyres.tstbin) max(fxres.tstbin) max(fgres.tstbin) max(fpres.tstbin) max(flres.tstbin)]
    Cl(ci)=Copt;
    Pg(ci,:)=[Copt Sopt];
    
end
