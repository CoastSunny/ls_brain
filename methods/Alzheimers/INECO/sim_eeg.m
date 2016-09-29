
ch=128;
freqs=15;
ep=5;
clear j xf xch xep
Y=0;
for si=1:15
    xf(:,si)=randn(freqs,1)+j*randn(freqs,1);
    xch(:,si)=randn(ch,1)+j*randn(ch,1);
    xep(:,si)=randn(ep,1)+j*randn(ep,1);
    temp=tprod(xf(:,si),[1 -2],xch(:,si),[2 -2]);
    S=tprod(temp,[1 2 -3],xep(:,si),[3 -3]);
    Y=Y+S;
end
Y=Y+0*randn(freqs,ch,ep);

[Fp,Ye,Ip,Exp,e,Rpen]=parafac_reg(Y,5,G,Alpha(a),Options,[0 0 0]);
% figure,plot(abs(Fp{3}))
% figure,plot(abs([xep]));