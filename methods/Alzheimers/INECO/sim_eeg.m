
ch=128;
freqs=30;
ep=5;
tr=50;
clear j xf xch xep PC0 PC7 FC0 FC7 xtr
Y=0;
nsource=2;
Options=[];
G=[];FC=[];PC1=[];PC2=[];xf=[];xch=[];xtr=[];ph=[];
for si=1:nsource
    xf(:,si)=rand(freqs,1);
%     xch(:,si)=randn(ch,1);    
    xch(:,si)=normpdf(1:128,mod(19*si,128),10);
    xch(:,si)=xch(:,si)/norm(xch(:,si));
    ph(:,si)=1*randn(tr,1);
    xtr(:,si)=exp(j*ph(:,si));
    if si==2
          xtr(:,si)=exp(j*(ph(:,1)+1+ph(:,2)));
    end
    if si==5
%           xtr(:,si)=exp(j*(ph(:,3)+1+ph(:,5)));
    end
   
%     if si==8
%         xtr(:,si)=exp(-j*(ph(:,4)+.1+ph(:,8)));
%     end
    temp=tprod(xf(:,si),[1 -2],xch(:,si),[2 -2]);
%     temp=tprod(temp,[1 2 -3],xep(:,si),[3 -3]); old
    S=tprod(temp,[1 2 -3],xtr(:,si),[3 -3]);
    Y=Y+S;
end
Y=Y+.00*(randn(freqs,ch,tr)+j*randn(freqs,ch,tr));
Fy{1}{1}=xf;Fy{1}{2}=xch;Fy{1}{3}=xtr;
ncomps=2;

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
        PC1(jj,ii)=temp(1,2);
        PC2(jj,ii)=norm(xch(:,ii)-Fp{1}{2}(:,jj),'fro');
        
    end
end
%FC,
PC1,max(abs(PC1)),max(PC2)
out=tensor_connectivity(Fp,1,3);
figure,subplot(1,2,1),imagesc(out)
out_tr=tensor_connectivity(Fy,1,3);
subplot(1,2,2),imagesc(out_tr)
% figure,imagesc(out)
Cpli=ls_pli(Y,[]);
Cx=topoconn_av(Fp,out,1,[],freq,[],0);
Cx=topoconn_av(Fy,out_tr,1,1,freq,[],0);
% resgood(end+1,:)=[mean(max(abs(PC0))) mean(diag(abs(PC7))) mean(max(abs(FC0))) mean(diag(abs(FC7)))]