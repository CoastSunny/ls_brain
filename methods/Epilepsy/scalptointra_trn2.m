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
    N=sidx2-sidx1;
    I=iEEG;
    rI=riEEG;
    S=sEEG;
    rS=rsEEG;    
    
    %% spatiotemporal method
    clear *sY*
    
    Ytr=I(:,:,1:sidx1);
    Ytr=reshape(Ytr,size(Ytr,1)*size(Ytr,2),size(Ytr,3));
    rYtr=rI(:,:,1:sidx1);
    rYtr=reshape(rYtr,size(rYtr,1)*size(rYtr,2),size(rYtr,3));
    Ytst=I(:,:,sidx1+1:sidx2);
    Ytst=reshape(Ytst,size(Ytst,1)*size(Ytst,2),size(Ytst,3));
    rYtst=rI(:,:,sidx1+1:sidx2);
    rYtst=reshape(rYtst,size(rYtst,1)*size(rYtst,2),size(rYtst,3));
    
    Xtr=S(:,:,1:sidx1);
    Xtr=reshape(Xtr,size(Xtr,1)*size(Xtr,2),size(Xtr,3));
    Xtst=S(:,:,sidx1+1:sidx2);
    Xtst=reshape(Xtst,size(Xtst,1)*size(Xtst,2),size(Xtst,3));
    rXtr=rS(:,:,1:sidx1);
    rXtr=reshape(rXtr,size(rXtr,1)*size(rXtr,2),size(rXtr,3));
    rXtst=rS(:,:,sidx1+1:sidx2);
    rXtst=reshape(rXtst,size(rXtst,1)*size(rXtst,2),size(rXtst,3));
       
    sz=size(iEEG(:,:,sidx1+1:sidx2));
    lCopt=get_cv_krr(Xtr',Ytr');   
    [gCopt gSopt]=get_cv_sigma_krr(Xtr',Ytr');
    [alpha Y2l]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtst');
    [alpha rY2l]=km_krr(Xtr',Ytr','linear',[],lCopt,rXtst');
    [alpha Y2g]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtst');
    [alpha rY2g]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,rXtst');
    gsY=reshape(Y2g',sz);
    lsY=reshape(Y2l',sz);
    grsY=reshape(rY2g',sz);
    lrsY=reshape(rY2l',sz);
    stlYtst{ci}=lsY;
    stgYtst{ci}=gsY;
    stlrYtst{ci}=lrsY;
    stgrYtst{ci}=grsY;   
    
    Xtst=S(:,:,sidx1+1:sidx2);       
    rXtst=rS(:,:,sidx1+1:sidx2);   
    Ytst=I(:,:,sidx1+1:sidx2);    
    rYtst=rI(:,:,sidx1+1:sidx2);
    xD=cat(3,Xtst,rXtst);
    yD=cat(3,Ytst,rYtst);
    styD=cat(3,lsY,lrsY);
    stygD=cat(3,gsY,grsY);
    labels=[];labels(1:size(lsY,3))=1;labels(size(lsY,3)+1:2*size(lsY,3))=-1;par1=[];par2=[];
    [clsfr, xres]=cvtrainKernelClassifier(xD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [iclsfr, yres]=cvtrainKernelClassifier(yD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, styres]=cvtrainKernelClassifier(styD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    [clsfr, stygres]=cvtrainKernelClassifier(stygD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
    f=applyNonLinearClassifier(styD,iclsfr);
    pp=fperf(f,labels');
    clRes(ci,:)=[max(xres.tstbin) max(yres.tstbin) max(styres.tstbin)...
        max(stygres.tstbin) pp.perf]
    
    
    
    %% spatiotemporal method 1-ch
%     clear *sY*
%     for chs=1:size(S,1)
%         Ytr=S(chs,:,1:sidx1);
%         Ytr=reshape(Ytr,size(Ytr,1)*size(Ytr,2),size(Ytr,3));
%         rYtr=rS(chs,:,1:sidx1);
%         rYtr=reshape(rYtr,size(rYtr,1)*size(rYtr,2),size(rYtr,3));
%         
%         Xtr=I(:,:,1:sidx1);
%         Xtr=reshape(Xtr,size(Xtr,1)*size(Xtr,2),size(Xtr,3));
%         Xtst=I(:,:,sidx1+1:sidx2);
%         Xtst=reshape(Xtst,size(Xtst,1)*size(Xtst,2),size(Xtst,3));
%         rXtr=rI(:,:,1:sidx1);
%         rXtr=reshape(rXtr,size(rXtr,1)*size(rXtr,2),size(rXtr,3));
%         rXtst=rI(:,:,sidx1+1:sidx2);
%         rXtst=reshape(rXtst,size(rXtst,1)*size(rXtst,2),size(rXtst,3));
%         
%         sz=size(sEEG(chs,:,1:sidx1));
%         lCopt=get_cv_krr(Xtr',Ytr');
%         [alpha, Y2l, Kl]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtr');
%         rlCopt=get_cv_krr(rXtr',rYtr');
%         [alpha, rY2l, Krl]=km_krr(rXtr',rYtr','linear',[],rlCopt,rXtr');
%         [gCopt, gSopt]=get_cv_sigma_krr(Xtr',Ytr');
%         [alpha, Y2g, Kg]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtr');
%         [rgCopt, rgSopt]=get_cv_sigma_krr(rXtr',rYtr');
%         [alpha, rY2g]=km_krr(rXtr',rYtr','gauss',rgSopt,rgCopt,rXtr');
%         gsY(chs,:,:)=reshape(Y2g',sz);
%         lsY(chs,:,:)=reshape(Y2l',sz);
%         grsY(chs,:,:)=reshape(rY2g',sz);
%         lrsY(chs,:,:)=reshape(rY2l',sz);
%         stlYtr{ci}=lsY;
%         stgYtr{ci}=gsY;
%         stlrYtr{ci}=lrsY;
%         stgrYtr{ci}=grsY;
%         sz=size(sEEG(chs,:,sidx1+1:sidx2));
%         [alpha Y2l]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtst');
%         [alpha rY2l]=km_krr(Xtr',Ytr','linear',[],lCopt,rXtst');
%         [alpha Y2g]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtst');
%         [alpha rY2g]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,rXtst');
%         tgsY(chs,:,:)=reshape(Y2g',sz);
%         tlsY(chs,:,:)=reshape(Y2l',sz);
%         tgrsY(chs,:,:)=reshape(rY2g',sz);
%         tlrsY(chs,:,:)=reshape(rY2l',sz);
%         stlYtst{ci}=lsY;
%         stgYtst{ci}=gsY;
%         stlrYtst{ci}=lrsY;
%         stgrYtst{ci}=grsY;
%     end
%     
%     stiRestr1ch(ci,:)=[...
%         1/N*sum(tprod(lsY-Ytrn{ci},[-1 -2 1],lsY-Ytrn{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(gsY-Ytrn{ci},[-1 -2 1],gsY-Ytrn{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(lrsY-rYtrn{ci},[-1 -2 1],lrsY-rYtrn{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(grsY-rYtrn{ci},[-1 -2 1],grsY-rYtrn{ci},[-1 -2 1]).^.5)...
%         ];
%     
%     stiRes1ch(ci,:)=[...
%         1/N*sum(tprod(tlsY-Ytst{ci},[-1 -2 1],tlsY-Ytst{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(tgsY-Ytst{ci},[-1 -2 1],tgsY-Ytst{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(tlrsY-rYtst{ci},[-1 -2 1],tlrsY-rYtst{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(tgrsY-rYtst{ci},[-1 -2 1],tgrsY-rYtst{ci},[-1 -2 1]).^.5)...
%         ];
%     
%     %% convolution method
%     clear *sY* x *xtst* rx
%     Xtr=I(:,:,1:sidx1);
%     rXtr=rI(:,:,1:sidx1);
%     Xtst=I(:,:,sidx1+1:sidx2);
%     rXtst=rI(:,:,sidx1+1:sidx2);
%     
%     Xc=mean(Xtr,3);
%     rXc=mean(rXtr,3);
%     
%     for T=1:size(Xtr,2)
%         
%         temp=lagmatrix(Xc',size(Xc,2)-T)';
%         temp(isnan(temp))=0;
%         
%         x(:,T)=vec(temp');
%         
%         temp=lagmatrix(rXc',size(rXc,2)-T)';
%         temp(isnan(temp))=0;
%         
%         rx(:,T)=vec(temp');
%         
%     end
%     
%     for chs=1:size(S,1)
%         
%         Ytr=S(chs,:,1:sidx1);
%         rYtr=rS(chs,:,1:sidx1);
%         Yc=mean(Ytr,3);
%         rYc=mean(rYtr,3);
%         
%         lCopt=get_cv_krr(x',Yc');
%         [lalpha]=km_krr(x',Yc','linear',[],lCopt);
%         rlCopt=get_cv_krr(rx',rYc');
%         [rlalpha]=km_krr(rx',rYc','linear',[],rlCopt);
%         [gCopt, gSopt]=get_cv_sigma_krr(x',Yc');
%         [galpha]=km_krr(x',Yc','gauss',gSopt,gCopt);
%         [rgCopt, rgSopt]=get_cv_sigma_krr(rx',rYc');
%         [rgalpha]=km_krr(rx',rYc','gauss',rgSopt,rgCopt);
%         cal{chs,ci}=lalpha;
%         cag{chs,ci}=galpha;
%         for tr=1:size(Xtst,3)
%             
%             Xc=Xtst(:,:,tr);
%             rXc=rXtst(:,:,tr);
%             
%             for T=1:size(Xtst,2)
%                 
%                 temp=lagmatrix(Xc',size(Xc,2)-T)';
%                 temp(isnan(temp))=0;
%                 
%                 xtst(:,T)=vec(temp');
%                 
%                 temp=lagmatrix(rXc',size(rXc,2)-T)';
%                 temp(isnan(temp))=0;
%                 
%                 rxtst(:,T)=vec(temp');
%                 
%             end
%             
%             [dumb ly]=km_krr(x',Yc','linear',[],lCopt,xtst',lalpha);
%             [dumb gy]=km_krr(x',Yc','gauss',gSopt,gCopt,xtst',galpha);
%             [dumb lry]=km_krr(rx',rYc','linear',[],rlCopt,rxtst',rlalpha);
%             [dumb gry]=km_krr(rx',rYc','gauss',rgSopt,rgCopt,rxtst',rgalpha);
%             clsY(chs,:,tr)=ly;
%             cgsY(chs,:,tr)=gy;
%             clrsY(chs,:,tr)=lry;
%             cgrsY(chs,:,tr)=gry;
%             
%         end
%         
%         
%         
%     end
%     cvlY{ci}=clsY;
%     cvgY{ci}=cgsY;
%     cvlrY{ci}=clrsY;
%     cvgrY{ci}=cgrsY;
%     ciRes1ch(ci,:)=[...
%         1/N*sum(tprod(clsY-Ytst{ci},[-1 -2 1],clsY-Ytst{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(cgsY-Ytst{ci},[-1 -2 1],cgsY-Ytst{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(clrsY-rYtst{ci},[-1 -2 1],clrsY-rYtst{ci},[-1 -2 1]).^.5)...
%         1/N*sum(tprod(cgrsY-rYtst{ci},[-1 -2 1],cgrsY-rYtst{ci},[-1 -2 1]).^.5)...
%         ];
end


