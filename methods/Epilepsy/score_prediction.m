flogit=@(p)(log(p./(1-p)));

ftiD=cat(2,ftiEEG,rftiEEG);
Z=ftiD;
Z=cat(1,[Z;ones(1,size(Z,2))]);
ztr=Z(:,[tr_examples size(sEEG,3)+rtr_examples]);
ztst=Z(:,[tst_examples size(sEEG,3)+rtst_examples]);
nonIEDscore=3;

ftr=[spikes(2,tr_examples) nonIEDscore*ones(1,numel(rtr_examples))];
ftst=[spikes(2,tst_examples) nonIEDscore*ones(1,numel(rtst_examples))];
ftr(ftr==10)=9.9;
ftst(ftst==10)=9.9;
ytr=flogit(ftr/10);
ytst=flogit(ftst/10);

for jj=1:10
    
    reg=10^jj;
    w=ytr*ztr'*inv(ztr*ztr'+reg*eye(size(ztr*ztr')));
    
    prtr=10./(1+exp(-w*ztr));
    prtst=10./(1+exp(-w*ztst));
    
    figure,hold on,plot(ftr),plot(prtr,'r')
    figure,hold on,plot(ftst),plot((prtst),'r')
    
    tmp1=corrcoef(ftr,prtr);
    tmp2=corrcoef(ftst,prtst);
    tmp3=norm(ftr-prtr);
    tmp4=norm(ftst-prtst);
    R(:,jj)=[tmp1(2) tmp2(2) tmp3 tmp4]
end