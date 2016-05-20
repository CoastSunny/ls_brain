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
fprintf('one vs many iEEG spikes, cluster seeg-ieeg')
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
    
%     ppp=1;
%     chtrn=[];
%     labels=[];labels(1:sidx1)=1;labels(sidx1+1:2*sidx1)=-1;
%     for chi=1:size(I,1)
%         
%         sY=iEEG(chi,:,1:sidx1);
%         rsY=riEEG(chi,:,1:sidx1);
%         yD=cat(3,sY,rsY);
%         [clsfr, yres]=cvtrainKernelClassifier(yD.^ppp,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%         chtrn(chi)=max(yres.tstbin);
%         
%     end
%     i_idx=chtrn>0.60;
%     [mm ii]=sort(chtrn);
%    i_idx=ii;
%     I=I(i_idx,:,:);
%     rI=rI(i_idx,:,:);
    
    %% temporal method
    %    for chs=1:size(S,1)
    %         chs
    %         Ytr=squeeze(S(chs,:,1:sidx1))';%%Y-->Intra
    %         Ytst=squeeze(S(chs,:,sidx1+1:sidx2))';
    %         rYtr=squeeze(rS(chs,:,1:sidx1))';
    %         rYtst=squeeze(rS(chs,:,sidx1+1:sidx2))';
    %         sYtst{chs,ci}=Ytst;
    %         srYtst{chs,ci}=rYtst;
    %         % Ytr=cat(1,Ytr,rYtr);
    %         for chi=1:size(I,1)
    %             fprintf(num2str(chs))
    %             Xtr=squeeze(I(chi,:,1:sidx1))';%%X-->Scalp
    %             Xtst=squeeze(I(chi,:,sidx1+1:sidx2))';
    %             rXtr=squeeze(rI(chi,:,1:sidx1))';
    %             rXtst=squeeze(rI(chi,:,sidx1+1:sidx2))';
    %             %   Xtr=cat(1,Xtr,rXtr);
    %             Copt=get_cv_krr(Xtr,Ytr);
    %             [alpha, Y2l, K]=km_krr(Xtr,Ytr,'linear',[],Copt,Xtst);
    %             [alhpa, rY2l,K]=km_krr(Xtr,Ytr,'linear',[],Copt,rXtst);
    %             sAl{chi,chs,ci}=alpha;
    %             sKl{chi,chs,ci}=K;
    %             [Copt Sopt]=get_cv_sigma_krr(Xtr,Ytr);
    %             [alpha, Y2g,K]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,Xtst);
    %             [alpha, rY2g,K]=km_krr(Xtr,Ytr,'gauss',Sopt,Copt,rXtst);
    %             sAg{chi,chs,ci}=alpha;
    %             sKg{chi,chs,ci}=K;
    %
    %             slYtst{chi,chs,ci}=Y2l;
    %             sgYtst{chi,chs,ci}=Y2g;
    %
    %             sXtst{chi,ci}=Xtst;
    %             slrYtst{chi,chs,ci}=rY2l;
    %             sgrYtst{chi,chs,ci}=rY2g;
    %
    %             srXtst{chi,ci}=rXtst;
    %             sRes(chi,chs,:)=[norm(Y2l-Ytst,'fro') norm(Y2g-Ytst,'fro') norm(rY2l-rYtst,'fro') norm(rY2g-Ytst,'fro')];
    %         end
    %     end
    %
    %  T{ci}=sRes;
    
    %% spatial method - 1ch
    clear *sY*
    
    for chs=1:size(S,1)
        
        Xtr=mean(I(:,:,1:sidx1),3)';
        Ytr=mean(S(chs,:,1:sidx1),3)';
        rXtr=mean(rI(:,:,1:sidx1),3)';
        rYtr=mean(rS(chs,:,1:sidx1),3)';
        lCopt=get_cv_krr(Xtr,Ytr);
        [lalpha]=km_krr(Xtr,Ytr,'linear',[],lCopt);
        [gCopt, gSopt]=get_cv_sigma_krr(Xtr,Ytr);
        [galpha]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt);
        rlCopt=get_cv_krr(rXtr,rYtr);
        [rlalpha]=km_krr(rXtr,rYtr,'linear',[],rlCopt);
        [rgCopt, rgSopt]=get_cv_sigma_krr(rXtr,rYtr);
        [rgalpha]=km_krr(rXtr,rYtr,'gauss',rgSopt,rgCopt);
        Wsl{ci}(chs,:)=lalpha'*Xtr;
        Wsg{ci}(chs,:)=galpha'*Xtr;
        Xtst=I(:,:,sidx1+1:sidx2);
        
        rXtst=rI(:,:,sidx1+1:sidx2);
        
        
        for tr=1:size(Xtst,3)
            
            [dumb ly]=km_krr(Xtr,Ytr,'linear',[],lCopt,Xtst(:,:,tr)',lalpha);
            [dumb gy]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt,Xtst(:,:,tr)',galpha);
            [dumb lry]=km_krr(rXtr,rYtr,'linear',[],rlCopt,rXtst(:,:,tr)',rlalpha);
            [dumb gry]=km_krr(rXtr,rYtr,'gauss',gSopt,rgCopt,rXtst(:,:,tr)',rgalpha);
            lsY(chs,:,tr)=ly;
            gsY(chs,:,tr)=gy;
            lrsY(chs,:,tr)=lry;
            grsY(chs,:,tr)=gry;
            
        end
        
    end
    Xtrn{ci}=Xtr;
    Xts{ci}=Xtst;
    rXts{ci}=rXtst;
    Ytrn{ci}=S(:,:,1:sidx1);
    rYtrn{ci}=rS(:,:,1:sidx1);
    Ytst{ci}=S(:,:,sidx1+1:sidx2);
    rYtst{ci}=rS(:,:,sidx1+1:sidx2);
    sgYtst{ci}=gsY;
    sgrYtst{ci}=grsY;
    slYtst{ci}=lsY;
    slrYtst{ci}=lrsY;
    zY=zeros(size(lsY));
    
    siRes(ci,:)=[...
        1/N*sum(tprod(lsY-Ytst{ci},[-1 -2 1],lsY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(gsY-Ytst{ci},[-1 -2 1],gsY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(lrsY-rYtst{ci},[-1 -2 1],lrsY-rYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(grsY-rYtst{ci},[-1 -2 1],grsY-rYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-Ytst{ci},[-1 -2 1],zY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-rYtst{ci},[-1 -2 1],zY-rYtst{ci},[-1 -2 1]).^.5)...
        ];
     
    siRes2(ci,:)=[...
        tensor_distance(lsY,Ytst{ci},1,3)...
        tensor_distance(gsY,Ytst{ci},1,3)...
        tensor_distance(lrsY,Ytst{ci},1,3)...
        tensor_distance(grsY,Ytst{ci},1,3)...
        ];
%     siRes(ci,:)=[...
%         1/N*sum(tprod(lsY,[-1 -2 1],Ytst{ci},[-1 -2 1]))...
%         1/N*sum(tprod(gsY,[-1 -2 1],Ytst{ci},[-1 -2 1]))...
%         1/N*sum(tprod(lrsY,[-1 -2 1],rYtst{ci},[-1 -2 1]))...
%         1/N*sum(tprod(grsY,[-1 -2 1],rYtst{ci},[-1 -2 1]))...
%         ];
    %% spatial method - mch
    
    %     Xtr=mean(I(:,:,1:sidx1),3)';
    %     Ytr=mean(S(:,:,1:sidx1),3)';
    %     rXtr=mean(rI(:,:,1:sidx1),3)';
    %     rYtr=mean(rS(:,:,1:sidx1),3)';
    %     lCopt=get_cv_krr(Xtr,Ytr);
    %     [lalpha]=km_krr(Xtr,Ytr,'linear',[],lCopt);
    %     [gCopt, gSopt]=get_cv_sigma_krr(Xtr,Ytr);
    %     [galpha]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt);
    %
    %     Xtst=I(:,:,1:sidx2);
    %     Ytst=S(:,:,1:sidx2);
    %     rXtst=rI(:,:,1:sidx2);
    %     rYtst=rS(:,:,1:sidx2);
    %
    %     for tr=1:size(Xtst,3)
    %
    %         [dumb ly]=km_krr(Xtr,Ytr,'linear',[],lCopt,Xtst(:,:,tr)',lalpha);
    %         [dumb gy]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt,Xtst(:,:,tr)',galpha);
    %         [dumb lry]=km_krr(Xtr,Ytr,'linear',[],lCopt,rXtst(:,:,tr)',lalpha);
    %         [dumb gry]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt,rXtst(:,:,tr)',galpha);
    %         lsY(:,:,tr)=ly;
    %         gsY(:,:,tr)=gy;
    %         lrsY(:,:,tr)=lry;
    %         grsY(:,:,tr)=gry;
    %
    %     end
    %
    %     smRes(chs,:,ci)=[norm(lsY-Ytst,'fro') norm(gsY-Ytst,'fro') norm(lrsY-rYtst,'fro') norm(grsY-rYtst,'fro')];
    
    %% spatiotemporal method
    clear *sY*
    
    Ytr=S(:,:,1:sidx1);
    Ytr=reshape(Ytr,size(Ytr,1)*size(Ytr,2),size(Ytr,3));
    rYtr=rS(:,:,1:sidx1);
    rYtr=reshape(rYtr,size(rYtr,1)*size(rYtr,2),size(rYtr,3));  
    
    Xtr=I(:,:,1:sidx1);
    Xtr=permute(Xtr,[2 1 3]);
    Xtr=reshape(Xtr,size(Xtr,1)*size(Xtr,2),size(Xtr,3));
    Xtst=I(:,:,sidx1+1:sidx2);
    Xtst=permute(Xtst,[2 1 3]);
    Xtst=reshape(Xtst,size(Xtst,1)*size(Xtst,2),size(Xtst,3));
    rXtr=rI(:,:,1:sidx1);
    rXtr=permute(rXtr,[2 1 3]);
    rXtr=reshape(rXtr,size(rXtr,1)*size(rXtr,2),size(rXtr,3));
    rXtst=rI(:,:,sidx1+1:sidx2);
    rXtst=permute(rXtst,[2 1 3]);
    rXtst=reshape(rXtst,size(rXtst,1)*size(rXtst,2),size(rXtst,3));
    
    sz=size(sEEG(:,:,1:sidx1));
    lCopt=get_cv_krr(Xtr',Ytr');
    [lalpha, Y2l, Kl]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtr');
    rlCopt=get_cv_krr(rXtr',rYtr');
    [rlalpha, rY2l, Krl]=km_krr(rXtr',rYtr','linear',[],lCopt,rXtr');
    [gCopt gSopt]=get_cv_sigma_krr(Xtr',Ytr')
    [galpha, Y2g, Kg]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtr');
    [rgCopt rgSopt]=get_cv_sigma_krr(rXtr',rYtr');
    [rgalpha, rY2g, Krg]=km_krr(rXtr',rYtr','gauss',rgSopt,rgCopt,rXtr');
    gsY=reshape(Y2g',sz);
    lsY=reshape(Y2l',sz);
    grsY=reshape(rY2g',sz);
    lrsY=reshape(rY2l',sz);
    stlYtr{ci}=lsY;
    stgYtr{ci}=gsY;
    stlrYtr{ci}=lrsY;
    stgrYtr{ci}=grsY;
    stal{ci}=lalpha;
    stag{ci}=galpha;
    Wstl{ci}=lalpha'*Xtr';
    Wstg{ci}=galpha'*Xtr';
    stiRestr(ci,:)=[...
        sum(tprod(lsY-Ytrn{ci},[-1 -2 1],lsY-Ytrn{ci},[-1 -2 1]).^.5)...
        sum(tprod(gsY-Ytrn{ci},[-1 -2 1],gsY-Ytrn{ci},[-1 -2 1]).^.5)...
        sum(tprod(lrsY-rYtrn{ci},[-1 -2 1],lrsY-rYtrn{ci},[-1 -2 1]).^.5)...
        sum(tprod(grsY-rYtrn{ci},[-1 -2 1],grsY-rYtrn{ci},[-1 -2 1]).^.5)...
        ];
    sz=size(sEEG(:,:,sidx1+1:sidx2));
%     rXtr(end+1,:)=1;
%     rXtst(end+1,:)=1;
%     Xtr(end+1,:)=1;
%     Xtst(end+1,:)=1;
    [alpha Y2l]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtst');
    [alpha rY2l]=km_krr(Xtr',Ytr','linear',[],rlCopt,rXtst');
    [alpha Y2g]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtst');
    [alpha rY2g]=km_krr(rXtr',rYtr','gauss',rgSopt,rgCopt,rXtst');
    gsY=reshape(Y2g',sz);
    lsY=reshape(Y2l',sz);
    grsY=reshape(rY2g',sz);
    lrsY=reshape(rY2l',sz);
    stlYtst{ci}=lsY;
    stgYtst{ci}=gsY;
    stlrYtst{ci}=lrsY;
    stgrYtst{ci}=grsY;
%     yD=cat(3,Ytst{ci},rYtst{ci});
%     styD=cat(3,lsY,lrsY);
%     labels=[];labels(1:size(lsY,3))=1;labels(size(lsY,3)+1:2*size(lsY,3))=-1;par1=[];par2=[];
%     [clsfr, yres]=cvtrainKernelClassifier(yD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, styres]=cvtrainKernelClassifier(styD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     clRes(ci,:)=[max(yres.tstbin) max(styres.tstbin)]
    stiRes(ci,:)=[...
        1/N*sum(tprod(lsY-Ytst{ci},[-1 -2 1],lsY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(gsY-Ytst{ci},[-1 -2 1],gsY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(lrsY-rYtst{ci},[-1 -2 1],lrsY-rYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(grsY-rYtst{ci},[-1 -2 1],grsY-rYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-Ytst{ci},[-1 -2 1],zY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-rYtst{ci},[-1 -2 1],zY-rYtst{ci},[-1 -2 1]).^.5)...
        ];
    stiRes2(ci,:)=[...
        tensor_distance(lsY,Ytst{ci},1,3)...
        tensor_distance(gsY,Ytst{ci},1,3)...
        tensor_distance(lrsY,Ytst{ci},1,3)...
        tensor_distance(grsY,Ytst{ci},1,3)...        
        ];
    
   clear *sY* x *xtst* rx
    Xtr=I(:,:,1:sidx1);
    rXtr=rI(:,:,1:sidx1);
    Xtst=I(:,:,sidx1+1:sidx2);
    rXtst=rI(:,:,sidx1+1:sidx2);
    
    Xc=mean(Xtr,3);
    rXc=mean(rXtr,3);
    
    for T=1:size(Xtr,2)
        
        temp=lagmatrix(Xc',size(Xc,2)-T)';
        temp(isnan(temp))=0;
        
        x(:,T)=vec(temp');
        
        temp=lagmatrix(rXc',size(rXc,2)-T)';
        temp(isnan(temp))=0;
        
        rx(:,T)=vec(temp');
        
    end
    
    for chs=1:size(S,1)
        
        Ytr=S(chs,:,1:sidx1);
        rYtr=rS(chs,:,1:sidx1);
        Yc=mean(Ytr,3);
        rYc=mean(rYtr,3);
        
        lCopt=get_cv_krr(x',Yc');
        [lalpha]=km_krr(x',Yc','linear',[],lCopt);
        rlCopt=get_cv_krr(rx',rYc');
        [rlalpha]=km_krr(rx',rYc','linear',[],rlCopt);
        [gCopt, gSopt]=get_cv_sigma_krr(x',Yc');
        [galpha]=km_krr(x',Yc','gauss',gSopt,gCopt);
        [rgCopt, rgSopt]=get_cv_sigma_krr(rx',rYc');
        [rgalpha]=km_krr(rx',rYc','gauss',rgSopt,rgCopt);
        cal{chs,ci}=lalpha;
        cag{chs,ci}=galpha;
        for tr=1:size(Xtst,3)
            
            Xc=Xtst(:,:,tr);
            rXc=rXtst(:,:,tr);
            
            for T=1:size(Xtst,2)
                
                temp=lagmatrix(Xc',size(Xc,2)-T)';
                temp(isnan(temp))=0;
                
                xtst(:,T)=vec(temp');
                
                temp=lagmatrix(rXc',size(rXc,2)-T)';
                temp(isnan(temp))=0;
                
                rxtst(:,T)=vec(temp');
                
            end
            
            [dumb ly]=km_krr(x',Yc','linear',[],lCopt,xtst',lalpha);
            [dumb gy]=km_krr(x',Yc','gauss',gSopt,gCopt,xtst',galpha);
            [dumb lry]=km_krr(rx',rYc','linear',[],rlCopt,rxtst',rlalpha);
            [dumb gry]=km_krr(rx',rYc','gauss',rgSopt,rgCopt,rxtst',rgalpha);
            clsY(chs,:,tr)=ly;
            cgsY(chs,:,tr)=gy;
            clrsY(chs,:,tr)=lry;
            cgrsY(chs,:,tr)=gry;
            
        end
        
        
        
    end  
    
    cvlY{ci}=clsY;
    cvgY{ci}=cgsY;
    cvlrY{ci}=clrsY;
    cvgrY{ci}=cgrsY;
    ciRes1ch(ci,:)=[...
        1/N*sum(tprod(clsY-Ytst{ci},[-1 -2 1],clsY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(cgsY-Ytst{ci},[-1 -2 1],cgsY-Ytst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(clrsY-rYtst{ci},[-1 -2 1],clrsY-rYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(cgrsY-rYtst{ci},[-1 -2 1],cgrsY-rYtst{ci},[-1 -2 1]).^.5)...
        ];
%     Yts=S(:,:,sidx1+1:sidx2);
%     Yts=reshape(Yts,size(Yts,1)*size(Yts,2),size(Yts,3));
%     rYts=rS(:,:,sidx1+1:sidx2);
%     rYts=reshape(rYts,size(rYts,1)*size(rYts,2),size(rYts,3));
%     yD=cat(3,reshape(Yts,sz),reshape(rYts,sz)); 
%     sz=size(iEEG(:,:,sidx1+1:sidx2));
%     hlyD=cat(3,reshape(pinv(Wstl{ci})*Yts,sz),reshape(pinv(Wstl{ci})*rYts,sz));
%     labels=[];labels(1:size(Yts,2))=1;labels(size(Yts,2)+1:2*size(Yts,2))=-1;
%     [clsfr, yres]=cvtrainKernelClassifier(yD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, lyres]=cvtrainKernelClassifier(hlyD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     cl(ci,:)=[max(yres.tstbin) max(lyres.tstbin)]
%     stiRes(ci,:)=[...
%         1/N*sum(tprod(lsY,[-1 -2 1],Ytst{ci},[-1 -2 1]))...
%         1/N*sum(tprod(gsY,[-1 -2 1],Ytst{ci},[-1 -2 1]))...
%         1/N*sum(tprod(lrsY,[-1 -2 1],rYtst{ci},[-1 -2 1]))...
%         1/N*sum(tprod(grsY,[-1 -2 1],rYtst{ci},[-1 -2 1]))...
%         ];
clear *sY*
    
    for chs=1:size(I,1)
        
        Xtr=mean(S(:,:,1:sidx1),3)';
        Ytr=mean(I(chs,:,1:sidx1),3)';
        rXtr=mean(rS(:,:,1:sidx1),3)';
        rYtr=mean(rI(chs,:,1:sidx1),3)';
        lCopt=get_cv_krr(Xtr,Ytr);
        [lalpha]=km_krr(Xtr,Ytr,'linear',[],lCopt);
        [gCopt, gSopt]=get_cv_sigma_krr(Xtr,Ytr);
        [galpha]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt);
        rlCopt=get_cv_krr(rXtr,rYtr);
        [rlalpha]=km_krr(rXtr,rYtr,'linear',[],rlCopt);
        [rgCopt, rgSopt]=get_cv_sigma_krr(rXtr,rYtr);
        [rgalpha]=km_krr(rXtr,rYtr,'gauss',rgSopt,rgCopt);
        vWsl{ci}(chs,:)=lalpha'*Xtr;
        vWsg{ci}(chs,:)=galpha'*Xtr;
        Xtst=S(:,:,sidx1+1:sidx2);
        
        rXtst=rS(:,:,sidx1+1:sidx2);
        
        
        for tr=1:size(Xtst,3)
            
            [dumb ly]=km_krr(Xtr,Ytr,'linear',[],lCopt,Xtst(:,:,tr)',lalpha);
            [dumb gy]=km_krr(Xtr,Ytr,'gauss',gSopt,gCopt,Xtst(:,:,tr)',galpha);
            [dumb lry]=km_krr(rXtr,rYtr,'linear',[],rlCopt,rXtst(:,:,tr)',rlalpha);
            [dumb gry]=km_krr(rXtr,rYtr,'gauss',gSopt,rgCopt,rXtst(:,:,tr)',rgalpha);
            lsY(chs,:,tr)=ly;
            gsY(chs,:,tr)=gy;
            lrsY(chs,:,tr)=lry;
            grsY(chs,:,tr)=gry;
            
        end
        
    end
       
    vsgYtst{ci}=gsY;
    vsgrYtst{ci}=grsY;
    vslYtst{ci}=lsY;
    vslrYtst{ci}=lrsY;
    vXtrn{ci}=Xtr;
    %Xtst{ci}=Xtst;
    vYtrn{ci}=I(:,:,1:sidx1);
    vrYtrn{ci}=rI(:,:,1:sidx1);
    vYtrn{ci}=I(:,:,1:sidx1);
    vrYtrn{ci}=rI(:,:,1:sidx1);
    vYtst{ci}=I(:,:,sidx1+1:sidx2);
    vrYtst{ci}=rI(:,:,sidx1+1:sidx2);
    
    zY=zeros(size(lsY));
    
    vsiRes(ci,:)=[...
        1/N*sum(tprod(lsY-vYtst{ci},[-1 -2 1],lsY-vYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(gsY-vYtst{ci},[-1 -2 1],gsY-vYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(lrsY-vrYtst{ci},[-1 -2 1],lrsY-vrYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(grsY-vrYtst{ci},[-1 -2 1],grsY-vrYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-vYtst{ci},[-1 -2 1],zY-vYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-vrYtst{ci},[-1 -2 1],zY-vrYtst{ci},[-1 -2 1]).^.5)...
        ];
     
    vsiRes2(ci,:)=[...
        tensor_distance(lsY,vYtst{ci},1,3)...
        tensor_distance(gsY,vYtst{ci},1,3)...
        tensor_distance(lrsY,vYtst{ci},1,3)...
        tensor_distance(grsY,vYtst{ci},1,3)...
        ];
    
 clear *sY*
    
    Ytr=I(:,:,1:sidx1);  
    Ytr=reshape(Ytr,size(Ytr,1)*size(Ytr,2),size(Ytr,3));
    rYtr=rI(:,:,1:sidx1);
    rYtr=reshape(rYtr,size(rYtr,1)*size(rYtr,2),size(rYtr,3));  
    
    Xtr=S(:,:,1:sidx1);    
    Xtr=permute(Xtr,[2 1 3]);
    Xtr=reshape(Xtr,size(Xtr,1)*size(Xtr,2),size(Xtr,3));
    Xtst=S(:,:,sidx1+1:sidx2);   
    Xtst=permute(Xtst,[2 1 3]);
    Xtst=reshape(Xtst,size(Xtst,1)*size(Xtst,2),size(Xtst,3));
    rXtr=rS(:,:,1:sidx1);
    rXtr=permute(rXtr,[2 1 3]);
    rXtr=reshape(rXtr,size(rXtr,1)*size(rXtr,2),size(rXtr,3));
    rXtst=rS(:,:,sidx1+1:sidx2);
    rXtst=permute(rXtst,[2 1 3]);
    rXtst=reshape(rXtst,size(rXtst,1)*size(rXtst,2),size(rXtst,3));
    
   
    sz=size(iEEG(:,:,1:sidx1));
    lCopt=get_cv_krr(Xtr',Ytr');
    [lalpha, Y2l, Kl]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtr');
    rlCopt=get_cv_krr(rXtr',rYtr');
    [rlalpha, rY2l, Krl]=km_krr(rXtr',rYtr','linear',[],lCopt,rXtr');
    [gCopt gSopt]=get_cv_sigma_krr(Xtr',Ytr')
    [galpha, Y2g, Kg]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtr');
    [rgCopt rgSopt]=get_cv_sigma_krr(rXtr',rYtr');
    [rgalpha, rY2g, Krg]=km_krr(rXtr',rYtr','gauss',rgSopt,rgCopt,rXtr');
    gsY=reshape(Y2g',sz);
    lsY=reshape(Y2l',sz);
    grsY=reshape(rY2g',sz);
    lrsY=reshape(rY2l',sz);
    vstlYtr{ci}=lsY;
    vstgYtr{ci}=gsY;
    vstlrYtr{ci}=lrsY;
    vstgrYtr{ci}=grsY;
    vstal{ci}=lalpha;
    vstag{ci}=galpha;
    vWstl{ci}=lalpha'*Xtr';
    vWstg{ci}=galpha'*Xtr';
    vstiRestr(ci,:)=[...
        sum(tprod(lsY-vYtrn{ci},[-1 -2 1],lsY-vYtrn{ci},[-1 -2 1]).^.5)...
        sum(tprod(gsY-vYtrn{ci},[-1 -2 1],gsY-vYtrn{ci},[-1 -2 1]).^.5)...
        sum(tprod(lrsY-vrYtrn{ci},[-1 -2 1],lrsY-vrYtrn{ci},[-1 -2 1]).^.5)...
        sum(tprod(grsY-vrYtrn{ci},[-1 -2 1],grsY-vrYtrn{ci},[-1 -2 1]).^.5)...
        ];
    vsz=size(iEEG(:,:,sidx1+1:sidx2));
%     rXtr(end+1,:)=1;
%     rXtst(end+1,:)=1;
%     Xtr(end+1,:)=1;
%     Xtst(end+1,:)=1;
    [alpha Y2l]=km_krr(Xtr',Ytr','linear',[],lCopt,Xtst');
    [alpha rY2l]=km_krr(Xtr',Ytr','linear',[],rlCopt,rXtst');
    [alpha Y2g]=km_krr(Xtr',Ytr','gauss',gSopt,gCopt,Xtst');
    [alpha rY2g]=km_krr(rXtr',rYtr','gauss',rgSopt,rgCopt,rXtst');
    gsY=reshape(Y2g',vsz);
    lsY=reshape(Y2l',vsz);
    grsY=reshape(rY2g',vsz);
    lrsY=reshape(rY2l',vsz);
    vstlYtst{ci}=lsY;
    vstgYtst{ci}=gsY;
    vstlrYtst{ci}=lrsY;
    vstgrYtst{ci}=grsY;
    zY=zeros(size(lsY));
%     yD=cat(3,Ytst{ci},rYtst{ci});
%     styD=cat(3,lsY,lrsY);
%     labels=[];labels(1:size(lsY,3))=1;labels(size(lsY,3)+1:2*size(lsY,3))=-1;par1=[];par2=[];
%     [clsfr, yres]=cvtrainKernelClassifier(yD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     [clsfr, styres]=cvtrainKernelClassifier(styD,labels,[],10,'dim',3,'par1',par1,'par2',par2,'kerType','linear');
%     clRes(ci,:)=[max(yres.tstbin) max(styres.tstbin)]
    vstiRes(ci,:)=[...
        1/N*sum(tprod(lsY-vYtst{ci},[-1 -2 1],lsY-vYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(gsY-vYtst{ci},[-1 -2 1],gsY-vYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(lrsY-vrYtst{ci},[-1 -2 1],lrsY-vrYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(grsY-vrYtst{ci},[-1 -2 1],grsY-vrYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-vYtst{ci},[-1 -2 1],zY-vYtst{ci},[-1 -2 1]).^.5)...
        1/N*sum(tprod(zY-vrYtst{ci},[-1 -2 1],zY-vrYtst{ci},[-1 -2 1]).^.5)...
        ];
    vstiRes2(ci,:)=[...
        tensor_distance(lsY,vYtst{ci},1,3)...
        tensor_distance(gsY,vYtst{ci},1,3)...
        tensor_distance(lrsY,vYtst{ci},1,3)...
        tensor_distance(grsY,vYtst{ci},1,3)...        
        ];
    
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
  
   
end


