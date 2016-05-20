
subj={'APLO1' 'APLO2' 'APLO3'};
day={'d1' 'd2' 'd3'};

for ss=1:numel(subj)
    for dd=1:numel(day)
    eval(['s=' subj{ss}]);  
%a=s.(day{dd}).default.train_classifier('classes',{{16};{22}},'blocks_in',1:4,'time',1:64,'channels',1:64);
a=NLsv.NLsv33.default.train_classifier('classes',{{12};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64);

fp=a.f(a.labels==1);fn=a.f(a.labels==-1);
pn=a.p(a.labels==-1);pp=a.p(a.labels==1);
nn=[];np=[];ppp=[];ppn=[];
ii=-5:0.5:5;
f=@(x)(1./(1+exp(-x)));
for i=ii
    
    ip=fp>i & fp<i+0.2;
    in=fn>i & fn<i+0.2;
    f0=fn(in);
    f1=fp(ip);
    np(end+1)=numel(f1);%np(np==1)=0;
    nn(end+1)=numel(f0);%nn(nn==1)=0;
    try
    ppp(end+1)=mean(pp(ip));
    catch err
    %    ppp(end+1)=0;
    end
        try
    ppn(end+1)=mean(pn(in));
        catch err
     %       ppn(end+1)=0;
        end

end

%figure,hold on,plot(ii,np,'r'),plot(ii,nn,'g'),plot(ii,ppp,'r.')%,plot(ii,ppn,'g.');
figure,hold on,plot(ii,np./(nn+np)),plot(ii,ppp,'r*','LineWidth',4),plot(ii,f(ii),'k','LineWidth',2)

dv=[fp;fn;];
d=hist(dv,ii);

dp=d(ii>=0);
dn=d(ii<0);

tmp1=ppp(ii>=0);
nanp=isnan(tmp1);
dp(nanp)=[];
tmp1=tmp1(~nanp);

Pp=sum(dp/sum(dp).*tmp1);

tmp2=ppn(ii<0);
nann=isnan(tmp2);
dn(nann)=[];
tmp2=tmp2(~nann);

Pn=sum(dn/sum(dn).*tmp2);

1-Pn,Pp
1-mean(pn(pn<0.5))
mean(pp(pp>=0.5))
louk(ss,dd)=mean([abs(a.rn-1+Pn) abs(a.rp-Pp)]);
louk2(ss,dd)=max([abs(a.rn-1+Pn) abs(a.rp-Pp)]);
louk3(ss,dd)=var(fn)/var(fp);
louk4(ss,dd)=max([abs(a.rn-1+mean(pn(pn<0.5))) abs(a.rp-mean(pp(pp>=0.5)))]);

    end
end


