ch=108;
freqs=10;
tr=36;
clear j xf xch xep PC0 PC7 FC0 FC7 xtr
Y=0;
nsource=2;
Options=[];
G=[];FC=[];PC1=[];PC2=[];xf=[];xch=[];xtr=[];ph=[];
for si=1:nsource
    xf(:,si)=randn(freqs,1)+j*randn(freqs,1);
    xch(:,si)=normpdf(1:128,mod(19*si,128),10);
    xch(:,si)=xch(:,si)/norm(xch(:,si));
    xtr(:,si)=randn(tr,1);
    if si==2
        
          xtr(:,2)=xtr(:,1)+xtr(:,2);
        
    end
    temp=tprod(xf(:,si),[1 -2],xch(:,si),[2 -2]);
    S=tprod(temp,[1 2 -3],xtr(:,si),[3 -3]);
    Y=Y+S;
end
Y=permute(Y,[3 2 1]);
[a b c d]=tucker_complex(Y,[2 2 -1],[],[2 3 -1]);
mean(abs(b),3)
mean(angle(b),3)