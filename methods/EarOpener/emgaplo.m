
ffiles=rdir('**/*/feedback.mat');
dfiles=rdir('**/*/mmndataFB.mat');
dfiles.name
tmp={dfiles.name};
filenames=sort_nat(tmp(:));
tmp=load([pwd filesep filenames{end-1}]);
data=tmp.v;


Dp=[];Sp=[];Cp=[];
Df=[];Sf=[];Cf=[];
tmp={ffiles.name};
filenames=sort_nat(tmp(:));

for i=1:numel(ffiles)-1
    
    tmp=load([pwd filesep filenames{i}]);
    feed=tmp.v;
    c=feed.cFB;d=feed.dFB;s=feed.sFB;
    Df=[Df d];
    Sf=[Sf s];
    Cf=[Cf c];
    
    didxs=strmatch(feed.deviant_marker,data.labels(data.block_ids==i))';
    X=data.data(67:72,:,didxs);
    for j=1:numel(didxs)
        dp(j)=norm(X(5:6,:,j))^2;
    end
    dp=filter(1/5*ones(1,5),1,dp);
    dp=dp(5:end);
    Dp=[Dp dp];
    
    sidxs=strmatch(feed.standard_marker,data.labels(data.block_ids==i))';
    X=data.data(67:72,:,sidxs);
    for j=1:numel(sidxs)
        sp(j)=norm(X(5:6,:,j))^2;
    end
    sp=filter(1/5*ones(1,5),1,sp);
    sp=sp(5:end);
    Sp=[Sp sp];
    
    Y=data.data(38,:,didxs);
     for j=1:numel(didxs)
        cp(j)=norm(X(1,:,j))^2;
    end
    cp=filter(1/5*ones(1,5),1,cp);
    cp=cp(5:end);
    Cp=[Cp cp];
                 
    
end
% figure,hold on,plot(Cf,'r','LineWidth',2),plot(Dp/norm(Dp)*norm(Cf),'g','LineWidth',2),plot(Cpd/norm(Cpd)*norm(Cf),'b','LineWidth',2),
dx=xcorr(Df-mean(Df),Dp-mean(Dp),30,'coeff');
sx=xcorr(Sf-mean(Sf),Sp-mean(Sp),30,'coeff');
cxd=xcorr(Cf-mean(Cf),Dp-mean(Dp),30,'coeff');
cxs=xcorr(Cf-mean(Cf),Sp-mean(Sp),30,'coeff');
xcorr(Df-mean(Df),Dp-mean(Dp),0,'coeff')
xcorr(Sf-mean(Sf),Sp-mean(Sp),0,'coeff')
xcorr(Cf-mean(Cf),Dp-mean(Dp),0,'coeff')
xcorr(Cf-mean(Cf),Sp-mean(Sp),0,'coeff')
%figure,hold on,plot(-30:30,dx,'r'),plot(-30:30,sx,'g'),plot(-30:30,cxd,'b'),plot(-30:30,cxs,'m')
% figure,[a,h1,h2]=plotyy(1:336,Dp,1:336,Df)
% set(h1,'LineWidth',2),set(h2,'LineWidth',2)