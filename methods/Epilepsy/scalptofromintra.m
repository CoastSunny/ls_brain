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
for ci=1:numel(subj)
    
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
    
    %% temporal method
    %     for chi=1:size(I,1)
    %         parfor chs=1:size(S,1)
    %             Xtr=squeeze(I(chi,:,1:sidx1))';
    %             Ytr=squeeze(S(chs,:,1:sidx1))';
    %             Xtst=squeeze(I(chi,:,sidx1+1:sidx2))';
    %             Ytst=squeeze(S(chs,:,sidx1+1:sidx2))';
    %             rXtr=squeeze(rI(chi,:,1:sidx1))';
    %             rYtr=squeeze(rS(chs,:,1:sidx1))';
    %             rXtst=squeeze(rI(chi,:,sidx1+1:sidx2))';
    %             rYtst=squeeze(rS(chs,:,sidx1+1:sidx2))';
    %             Xtr=cat(1,Xtr,rXtr);
    %             Ytr=cat(1,Ytr,rYtr);
    %             Copt=get_cv_krr(Xtr,Ytr);
    %             [alpha Y2l]=km_krr(Xtr,Ytr,'linear',[],Copt,Xtst);
    %             [alhpa rY2l]=km_krr(Xtr,Ytr,'linear',[],Copt,rXtst);
    %             [Copt Sopt]=get_cv_sigma_krr(Xtr,Ytr);
    %             [alpha Y2g]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,Xtst);
    %             [alpha rY2g]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,rXtst);
    %             tlYtst{chi,chs}=Y2l;
    %             tgYtst{chi,chs}=Y2g;
    %             tYtst{chi,chs}=Ytst;
    %             tlrYtst{chi,chs}=rY2l;
    %             tgrYtst{chi,chs}=rY2g;
    %             trYtst{chi,chs}=rYtst;
    %             tRes(chi,chs,:)=[norm(Y2l-Ytst) norm(Y2g-Ytst)];
    %         end
    %     end
    
%     for chi=1:size(I,1)
%         chi
%         Ytr=squeeze(I(chi,:,1:sidx1))';%%Y-->Intra
%         Ytst=squeeze(I(chi,:,sidx1+1:sidx2))';
%         rYtr=squeeze(rI(chi,:,1:sidx1))';
%         rYtst=squeeze(rI(chi,:,sidx1+1:sidx2))';
%         % Ytr=cat(1,Ytr,rYtr);
%         for chs=1:size(S,1)
%             fprintf(num2str(chs))
%             Xtr=squeeze(S(chs,:,1:sidx1))';%%X-->Scalp
%             Xtst=squeeze(S(chs,:,sidx1+1:sidx2))';
%             rXtr=squeeze(rS(chs,:,1:sidx1))';
%             rXtst=squeeze(rS(chs,:,sidx1+1:sidx2))';
%             %   Xtr=cat(1,Xtr,rXtr);
%             Copt=get_cv_krr(Xtr,Ytr);
%             [alpha Y2l]=km_krr(Xtr,Ytr,'linear',[],Copt,Xtst);
%             [alhpa rY2l]=km_krr(Xtr,Ytr,'linear',[],Copt,rXtst);
%             [Copt Sopt]=get_cv_sigma_krr(Xtr,Ytr);
%             [alpha Y2g]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,Xtst);
%             [alpha rY2g]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,rXtst);
%             tlYtst{chi,chs}=Y2l;
%             tgYtst{chi,chs}=Y2g;
%             tYtst{chi}=Ytst;
%             tXtst{chs}=Xtst;
%             tlrYtst{chi,chs}=rY2l;
%             tgrYtst{chi,chs}=rY2g;
%             trYtst{chi}=rYtst;
%             trXtst{chs}=rXtst;
%             %    tRes(chi,chs,:)=[norm(Y2l-Ytst,'fro') norm(Y2g-Ytst,'fro') norm(rY2l-rYtst,'fro') norm(rY2g-Ytst,'fro')];
%         end
%     end
%     clear *sY* *sX*
%     for chi=1:size(I,1)
%         for chs=1:size(S,1)
%             lsY(chi,chs,:,:)=tlYtst{chi,chs}';
%             lrsY(chi,chs,:,:)=tlrYtst{chi,chs}';
%             gsY(chi,chs,:,:)=tgYtst{chi,chs}';
%             grsY(chi,chs,:,:)=tgrYtst{chi,chs}';
%             sY(chi,:,:)=tYtst{chi}';
%             rsY(chi,:,:)=trYtst{chi}';
%             sX(chs,:,:)=tXtst{chs}';
%             rsX(chs,:,:)=trXtst{chs}';
%         end
%     end
%     dim=4;
%     yD=cat(3,sY,rsY);
%     xD=cat(3,sX,rsX);
%     gsD=cat(dim,gsY,grsY);
%     lsD=cat(dim,lsY,lrsY);
%     labels=[];labels(1:size(sY,3))=1;labels(size(sY,3)+1:size(yD,3))=-1;
%     par1=[];par2=[];
%     ppp=1;
%     [clsfr, yres]=cvtrainKernelClassifier(yD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, xres]=cvtrainKernelClassifier(xD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, gres]=cvtrainKernelClassifier(gsD.^ppp,labels,[],10,'dim',dim,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, lres]=cvtrainKernelClassifier(lsD.^ppp,labels,[],10,'dim',dim,'par1',par1,'par2',par2,'kerType','linear');
%     fyD=spectrogram(yD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%     fxD=spectrogram(xD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%     fgsD=spectrogram(gsD,3,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%     flsD=spectrogram(lsD,3,'fs',fs,'width_ms',width_ms,'overlap',overlap);
%     [clsfr, fyres]=cvtrainKernelClassifier(fyD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, fxres]=cvtrainKernelClassifier(fxD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, fgres]=cvtrainKernelClassifier(fgsD,labels,[],10,'dim',5,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, flres]=cvtrainKernelClassifier(flsD,labels,[],10,'dim',5,'par1',par1,'par2',par2,'kerType','linear');
%     Rt(ci,:)=[max(yres.tstbin) max(xres.tstbin) max(gres.tstbin) max(lres.tstbin)...
%         max(fyres.tstbin) max(fxres.tstbin) max(fgres.tstbin) max(flres.tstbin)]
    
    
    %% spatial method
    %         for chs=1:size(S,1)
    %             Xtr=mean(I(:,:,1:sidx1),3)';
    %             Ytr=mean(S(chs,:,1:sidx1),3)';
    %             Xtst=mean(I(:,:,sidx1+1:sidx2),3)';
    %             Ytst=mean(S(chs,:,sidx1+1:sidx2),3)';
    %             Copt=get_cv_krr(Xtr,Ytr);
    %             [alpha Y2l]=km_krr(Xtr,Ytr,'linear',[],Copt,Xtst);
    %             [Copt Sopt]=get_cv_sigma_krr(Xtr,Ytr);
    %             [alpha Y2g]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,Xtst);
    %             [Copt Sopt]=get_cv_poly_krr(Xtr,Ytr);
    %             [alpha Y2p]=km_krr(Xtr,Ytr,'poly',Sopt,Copt,Xtst);
    %             slYtst{chs}=Y2l;
    %             spYtst{chs}=Y2p;
    %             sgYtst{chs}=Y2g;
    %             sYtst{chs}=Ytst;
    %             sRes(chs,:)=[norm(Y2l-Ytst) norm(Y2g-Ytst) norm(Y2p-Ytst)];
    %         end
    %
    %         sR(ci,:)=mean(sRes);
    %         tR(ci,:)=mean(mean(tRes,1),2);
    ppp=1;
    labels=[];labels(1:sidx1)=1;labels(sidx1+1:2*sidx1)=-1;
    par1=[];par2=[];
    chtrn=[];
    for chi=1:size(I,1)
        
        sY=iEEG(chi,:,1:sidx1);
        rsY=riEEG(chi,:,1:sidx1);
        yD=cat(3,sY,rsY);
        [clsfr, yres]=cvtrainKernelClassifier(yD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
        chtrn(chi)=max(yres.tstbin);
    end
    i_idx=chtrn>0.60;
    I=I(i_idx,:,:);
    rI=rI(i_idx,:,:);
    clear *sX* *sY*
    for chi=1:size(I,1)
        Xtr=mean(S(:,:,1:sidx1),3)';
        Ytr=mean(I(chi,:,1:sidx1),3)';
        rXtr=mean(rS(:,:,1:sidx1),3)';
        rYtr=mean(rI(chi,:,1:sidx1),3)';
        %             Xtst=mean(S(:,:,sidx1+1:sidx2),3)';
        %             Ytst=mean(I(chs,:,sidx1+1:sidx2),3)';
        lCopt=get_cv_krr(Xtr,Ytr);
        [lalpha]=km_krr(Xtr,Ytr,'linear',[],lCopt);
        [gCopt, gSopt]=get_cv_sigma_krr(Xtr,Ytr);
        [galpha]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt);
        %             [alpha Y2g]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,Xtst);
        %[Copt Sopt]=get_cv_poly_krr(Xtr,Ytr);
        %             [alpha Y2p]=km_krr(Xtr,Ytr,'poly',Sopt,Copt,Xtst);
        Xtst=S(:,:,sidx1+1:sidx2);
        Ytst=I(chi,:,sidx1+1:sidx2);
        rXtst=rS(:,:,sidx1+1:sidx2);
        rYtst=rI(chi,:,sidx1+1:sidx2);
       
        for tr=1:size(Xtst,3)
            
            [dumb ly]=km_krr(Xtr,Ytr,'linear',[],lCopt,Xtst(:,:,tr)',lalpha);
            [dumb gy]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt,Xtst(:,:,tr)',galpha);
            [dumb lry]=km_krr(Xtr,Ytr,'linear',[],lCopt,rXtst(:,:,tr)',lalpha);
            [dumb gry]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt,rXtst(:,:,tr)',galpha);
            lsY(chi,:,tr)=ly;
            gsY(chi,:,tr)=gy;
            lrsY(chi,:,tr)=lry;
            grsY(chi,:,tr)=gry;
            
        end
        
        %             iRes(chs,:)=[norm(Y2l-Ytst) norm(Y2g-Ytst) norm(Y2p-Ytst)];
    end
    
    sY=I(:,:,sidx1+1:sidx2);
    rsY=rI(:,:,sidx1+1:sidx2);
    sX=sEEG(:,:,sidx1+1:sidx2);
    rsX=rsEEG(:,:,sidx1+1:sidx2);
    yD=cat(3,sY,rsY);
    xD=cat(3,sX,rsX);
    gsD=cat(3,gsY,grsY);
    lsD=cat(3,lsY,lrsY);
    labels=[];labels(1:size(sY,3))=1;labels(size(sY,3)+1:size(yD,3))=-1;
    
    [clsfr, yres]=cvtrainKernelClassifier(yD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, xres]=cvtrainKernelClassifier(xD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, gres]=cvtrainKernelClassifier(gsD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, lres]=cvtrainKernelClassifier(lsD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    fyD=spectrogram(yD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxD=spectrogram(xD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fgsD=spectrogram(gsD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    flsD=spectrogram(lsD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    [clsfr, fyres]=cvtrainKernelClassifier(fyD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, fxres]=cvtrainKernelClassifier(fxD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, fgres]=cvtrainKernelClassifier(fgsD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, flres]=cvtrainKernelClassifier(flsD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    Rs(ci,:)=[max(yres.tstbin) max(xres.tstbin) max(gres.tstbin) max(lres.tstbin)...
             max(fyres.tstbin) max(fxres.tstbin) max(fgres.tstbin) max(flres.tstbin)]
    
    %% spatiotemporal method
    
%     I=iEEG;
%     ri=riEEG;
    
    Ytr=I(:,:,1:sidx1);%%Y-->Intra
    Ytr=reshape(Ytr,size(Ytr,1)*size(Ytr,2),size(Ytr,3));
    Ytst=I(:,:,sidx1+1:sidx2);
    Ytst=reshape(Ytst,size(Ytst,1)*size(Ytst,2),size(Ytst,3));
    rYtr=rI(:,:,1:sidx1);%%Y-->Intra
    rYtr=reshape(rYtr,size(rYtr,1)*size(rYtr,2),size(rYtr,3));
    rYtst=rI(:,:,sidx1+1:sidx2);%%Y-->Intra
    rYtst=reshape(rYtst,size(rYtst,1)*size(rYtst,2),size(rYtst,3));
    
    Xtr=S(:,:,1:sidx1);%%Y-->Intra
    Xtr=reshape(Xtr,size(Xtr,1)*size(Xtr,2),size(Xtr,3));
    Xtst=S(:,:,sidx1+1:sidx2);
    Xtst=reshape(Xtst,size(Xtst,1)*size(Xtst,2),size(Xtst,3));
    rXtr=rS(:,:,1:sidx1);%%Y-->Intra
    rXtr=reshape(rXtr,size(rXtr,1)*size(rXtr,2),size(rXtr,3));
    rXtst=rS(:,:,sidx1+1:sidx2);%%Y-->Intra
    rXtst=reshape(rXtst,size(rXtst,1)*size(rXtst,2),size(rXtst,3));
    
    Ytr=cat(2,Ytr,rYtr);
    Xtr=cat(2,Xtr,rXtr);
        
    Copt=get_cv_krr(Xtr',Ytr');
    [alpha Y2l]=km_krr(Xtr',Ytr','linear',[],Copt,Xtst');
    [alhpa rY2l]=km_krr(Xtr',Ytr','linear',[],Copt,rXtst');
    [Copt Sopt]=get_cv_sigma_krr(Xtr',Ytr');
    [alpha Y2g]=km_krr(Xtr',Ytr','gauss',Sopt,Copt,Xtst');
    [alpha rY2g]=km_krr(Xtr',Ytr','gauss',Sopt,Copt,rXtst');
    
    yD=cat(3,sY,rsY);
    xD=cat(3,sX,rsX);
    gsD=cat(2,Y2g',rY2g');gsD=reshape(gsD,size(yD,1),size(yD,2),size(yD,3));
    lsD=cat(2,Y2l',rY2l');lsD=reshape(lsD,size(yD,1),size(yD,2),size(yD,3));
    labels=[];labels(1:size(sY,3))=1;labels(size(sY,3)+1:size(yD,3))=-1;
    [clsfr, yres]=cvtrainKernelClassifier(yD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, xres]=cvtrainKernelClassifier(xD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, gres]=cvtrainKernelClassifier(gsD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, lres]=cvtrainKernelClassifier(lsD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    fyD=spectrogram(yD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxD=spectrogram(xD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fgsD=spectrogram(gsD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    flsD=spectrogram(lsD,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    [clsfr, fyres]=cvtrainKernelClassifier(fyD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, fxres]=cvtrainKernelClassifier(fxD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, fgres]=cvtrainKernelClassifier(fgsD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, flres]=cvtrainKernelClassifier(flsD,labels,[],10,'dim',4,'par1',par1,'par2',par2,'kerType','linear');
   
    Rst(ci,:)=[max(yres.tstbin) max(xres.tstbin) max(gres.tstbin) max(lres.tstbin)...
         max(fyres.tstbin) max(fxres.tstbin) max(fgres.tstbin) max(flres.tstbin)]
     
     %% TF
     
    Ytr=I(:,:,1:sidx1);%%Y-->Intra
    Ytst=I(:,:,sidx1+1:sidx2);  
    rYtr=rI(:,:,1:sidx1);%%Y-->Intra    
    rYtst=rI(:,:,sidx1+1:sidx2);%%Y-->Intra   
    
    Xtr=S(:,:,1:sidx1);%%Y-->Intra   
    Xtst=S(:,:,sidx1+1:sidx2);   
    rXtr=rS(:,:,1:sidx1);%%Y-->Intra    
    rXtst=rS(:,:,sidx1+1:sidx2);%%Y-->Intra    
    
    Ytr=cat(3,Ytr,rYtr);
    Xtr=cat(3,Xtr,rXtr);
    Ytst=cat(3,Ytst,rYtst);
    Xtst=cat(3,Xtst,rXtst);
     
    fyTr=spectrogram(Ytr,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxTr=spectrogram(Xtr,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    Xtr=reshape(fxTr,size(fxTr,1)*size(fxTr,2)*size(fxTr,3),size(fxTr,4));
    Ytr=reshape(fyTr,size(fyTr,1)*size(fyTr,2)*size(fyTr,3),size(fyTr,4));
    fyTs=spectrogram(Ytst,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    fxTs=spectrogram(Xtst,2,'fs',fs,'width_ms',width_ms,'overlap',overlap);
    Xtst=reshape(fxTs,size(fxTs,1)*size(fxTs,2)*size(fxTs,3),size(fxTs,4));
    Ytst=reshape(fyTs,size(fyTs,1)*size(fyTs,2)*size(fyTs,3),size(fyTs,4));
    Copt=get_cv_krr(Xtr',Ytr');
    [alpha Y2l]=km_krr(Xtr',Ytr','linear',[],Copt,Xtst');    
    [Copt Sopt]=get_cv_sigma_krr(Xtr',Ytr');
    [alpha Y2g]=km_krr(Xtr',Ytr','gauss',Sopt,Copt,Xtst');
    
    [clsfr, fgres]=cvtrainKernelClassifier(Y2g',labels,[],10,'dim',2,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, flres]=cvtrainKernelClassifier(Y2l',labels,[],10,'dim',2,'par1',par1,'par2',par2,'kerType','linear');
    
    Rf(ci,:)=[max(fgres.tstbin) max(flres.tstbin)]
    Cl(ci)=Copt;
    Pg(ci,:)=[Copt Sopt];
    
end
