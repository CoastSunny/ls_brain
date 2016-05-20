pnav=@(theta,n,m,s)( 1-normcdf(theta,m,s/sqrt(n)) );
pnrow=@(theta,n,m,s)( (1-normcdf(theta,m,s))^n );
tnav=@(c,n,m,s)( norminv(1-c,m,s/sqrt(n)) );
tnrow=@(c,n,m,s)( norminv(1-c^(1/n),m,s) );

dm=0;
dp=0;

mp=.7+dm+dp;sp=1;mn=-.7+dm;sn=1;
subj=4;
%mp=A(subj,1);sp=A(subj,3);mn=A(subj,2);sn=A(subj,4);
n0=2;
c0=0.01;
c=c0;
n=n0;
%clear dfs dfm dff
pnav(0,n,mp,sp)
1-pnav(0,n,mn,sn)
dfsn=[];dfsn2=[];
ssn=0.01:0.01:5;
for i=1:500
   
    theta_nav=tnav(c,n,mn,sn*ssn(i));
    theta_nrow=tnrow(c,n,mn,sn*ssn(i));
    theta_prime=tnav(pnrow(theta_nrow,n,mp,sp),n,mp,sp);
    dfsn(i)=theta_prime-theta_nav;
    z=pnrow(theta_nrow,n,mp,sp);
    dfsn2(i)=norminv(1-z)*sp/sqrt(n)-norminv(1-c)*sn*ssn(i)/sqrt(n)+mp-mn;
end
%figure,plot(ssn,dfsn,'Linewidth',4),grid
figure,
plot(ssn,dfsn2,'Linewidth',4,'Color','k'),grid on
dfdm=[];dfdm2=[];
sdm=0.01:0.01:3;
for i=1:300
   dp=sdm(i);
    theta_nav=tnav(c,n,mn+dm,sn);
    theta_nrow=tnrow(c,n,mn+dm,sn);
    theta_prime=tnav(pnrow(theta_nrow,n,mp+dm+dp,sp),n,mp+dm+dp,sp);
    dfdm(i)=theta_prime-theta_nav;
    z=pnrow(theta_nrow,n,mp+dm+dp,sp);
    dfdm2(i)=norminv(1-z)*sp/sqrt(n)-norminv(1-c)*sn/sqrt(n)+mp+dp-mn;
    tmp1(i)=norminv(1-z);
    tmp2(i)=mp+dp-mn;
end
figure,
plot(sdm,dfdm2,'Linewidth',4,'Color','k'),grid on
dm=0;
dp=0;
dfdn=[];dfdn2=[];
for n=1:30
   
    theta_nav=tnav(c,n,mn+dm,sn);
    theta_nrow=tnrow(c,n,mn+dm,sn);
    theta_prime=tnav(pnrow(theta_nrow,n,mp+dm+dp,sp),n,mp+dm+dp,sp);
    dfdn(n)=theta_prime-theta_nav;
    z=pnrow(theta_nrow,n,mp+dm+dp,sp);
    dfdn2(n)=norminv(1-z)*sp/sqrt(n)-norminv(1-c)*sn/sqrt(n)+mp+dp-mn;
end
 figure,
 plot(1:30,dfdn2,'Linewidth',4,'Color','k'),grid on
dm=0;
dp=0;
n=n0;
dfdc=[];dfdc2=[];
scn=0.001:0.001:0.3;
for i=1:numel(scn)
    c=scn(i);
    theta_nav=tnav(c,n,mn+dm,sn);
    theta_nrow=tnrow(c,n,mn+dm,sn);
    theta_prime=tnav(pnrow(theta_nrow,n,mp+dm+dp,sp),n,mp+dm+dp,sp);
    dfdc(i)=theta_prime-theta_nav;
    z=pnrow(theta_nrow,n,mp+dm+dp,sp);
    dfdc2(i)=norminv(1-z)*sp/sqrt(n)-norminv(1-c)*sn/sqrt(n)+mp+dp-mn;
end
figure,
 plot(scn,dfdc2,'Linewidth',4,'Color','k'),grid on
% 
% ssp=0.01:0.01:3;
% for i=1:numel(ssp)
%    
%     theta_nav=tnav(c,n,mn,sn);
%     theta_nrow=tnrow(c,n,mn,sn);
%     theta_prime=tnav(pnrow(theta_nrow,n,mp,sp*ssn(i)),n,mp,sp*ssn(i));
%     dfsp(i)=theta_prime-theta_nav;
%     
% end
% 
% 
% mmn=-2:0.01:3;
% for i=1:numel(mmn)
%    
%     theta_nav=tnav(c,n,mn*mmn(i),sn);
%     theta_nrow=tnrow(c,n,mn*mmn(i),sn);
%     theta_prime=tnav(pnrow(theta_nrow,n,mp,sp),n,mp,sp);
%     dfmn(i)=theta_prime-theta_nav;
%     
% end
% 
% mmp=-2:0.01:3;
% for i=1:numel(mmp)
%    
%     theta_nav=tnav(c,n,mn,sn);
%     theta_nrow=tnrow(c,n,mn,sn);
%     theta_prime=tnav(pnrow(theta_nrow,n,mp*mmp(i),sp),n,mp*mmp(i),sp);
%     dfmp(i)=theta_prime-theta_nav;
%     
% end


%figure,hold on,plot(ssn,dfsn,'r'),plot(ssp,dfsp,'g'),grid
%figure,hold on,plot(mmn,dfmn,'r'),plot(mmp,dfmp,'g'),grid
% ssn=0.01:0.02:3;
% mmn=0.01:0.02:3;
% for n=1:14
% for i=1:numel(ssn)
% for j=1:numel(mmn)
%    
%     theta_nav=tnav(c,n,mn*mmn(j),sn*ssn(i));
%     theta_nrow=tnrow(c,n,mn*mmn(j),sn*ssn(i));
%     theta_prime=tnav(pnrow(theta_nrow,n,mp,sp),n,mp,sp);
%     dff(i,j,n)=theta_prime-theta_nav;
%     
% end
% end
% end
% Y=dff(:,:,4);
% y=vec(Y);
% M=mmn;
% M=repmat(M,numel(mmn),1);
% M=vec(M);
% M2=M.^2;
% M3=M.^3;
% S=repmat(ssn,1,numel(ssn))';
% S2=S.^2;
% S3=S.^3;
% A=[S S2 S3 M M2 M3];
% %A=[S M ];
% b=inv(A'*A)*A'*y;
% yhat=A*b;
% tp=0.1;N=4;method=2;correc=1;
% qq=checkmethod(.5,.7,-.5,.7,N,tp,method,correc)
% figure,hold on,grid,ylabel('TPR/FRR')
% plot(qq.x,qq.PSCDF,'Linewidth',4)
% plot(qq.x,qq.PNCDF,'Linewidth',4,'Color','r')
% plot(qq.x,qq.NSCDF,'Linewidth',4,'Linestyle','-.')
% plot(qq.x,qq.NNCDF,'Linewidth',4,'Color','r','Linestyle','-.')



