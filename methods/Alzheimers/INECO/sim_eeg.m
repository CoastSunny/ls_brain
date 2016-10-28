
ch=128;
freqs=30;
ep=5;
tr=150;
clear j xf xch xep PC0 PC7 FC0 FC7
Y=0;
nsource=15;
Options=[];
G=[];FC=[];PC=[];xf=[];xch=[];xtr=[];ph=[];
for si=1:nsource
    xf(:,si)=rand(freqs,1);
%     xch(:,si)=randn(ch,1);    
    xch(:,si)=normpdf(1:128,mod(19*si,128),5);
    ph(:,si)=randn(tr,1);
    xtr(:,si)=exp(-j*ph(:,si));
    if si==5
         xtr(:,si)=exp(-j*(ph(:,3)+1+ph(:,5)));
    end
    if si==2
          xtr(:,si)=exp(-j*(ph(:,1)+1+ph(:,2)));
    end
    if si==8
        xtr(:,si)=exp(-j*(ph(:,6)+1+ph(:,8)));
    end
    temp=tprod(xf(:,si),[1 -2],xch(:,si),[2 -2]);
%     temp=tprod(temp,[1 2 -3],xep(:,si),[3 -3]); old
    S=tprod(temp,[1 2 -3],xtr(:,si),[3 -3]);
    Y=Y+S;
end
Y=Y+.01*(randn(freqs,ch,tr)+j*randn(freqs,ch,tr));
ncomps=15;

[Fp,Ye,Ip,Exp,e,Rpen]=parafac_reg(Y,ncomps,[],[],Options,[9 9 0]);
temp=Fp;Fp=[];
Fp{1}=temp;
% figure,plot(abs(Fp{3})./(ones(5,1)*abs(std(Fp{3},0,1))))
% figure,plot(abs(xep)./(ones(5,1)*abs(std(xep,0,1))))

% figure,plot(abs(Fp{2})./(ones(128,1)*abs(std(Fp{2},0,1))))
% figure,plot(abs(xch)./(ones(128,1)*abs(std(xch,0,1))))

for jj=1:ncomps
    for ii=1:nsource
        
        x=angle(Fp{1}{2}(:,jj));
        y=angle(xch(:,ii));
        temp=corrcoef(x,y);
        FC(jj,ii)=temp(1,2);
        
    end
end
for jj=1:ncomps
    for ii=1:nsource
        
        x=abs(Fp{1}{2}(:,jj));
        y=abs(xch(:,ii));
        temp=corrcoef(x,y);
        PC(jj,ii)=temp(1,2);
        
    end
end
%FC,
PC,max(abs(PC))
out=tensor_connectivity(Fp,1,3);
% figure,imagesc(out)
Cpli=ls_pli(Y);
Cx=topoconn_av(Fp,out,1,3,freq);
% resgood(end+1,:)=[mean(max(abs(PC0))) mean(diag(abs(PC7))) mean(max(abs(FC0))) mean(diag(abs(FC7)))]