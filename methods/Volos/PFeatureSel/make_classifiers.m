
out=[];
thetap=[];
thetan=[];
Fp=[];
Fn=[];
for i=1:size(channels,2)
    
    out{i}=S.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',i,'freqband',[.5 13]);
    thetap(i,:)=[ out{i}.rp mean(out{i}.f(out{i}.labels==1)) std(out{i}.f(out{i}.labels==1)) ];
    thetan(i,:)=[ out{i}.rn mean(out{i}.f(out{i}.labels==-1)) std(out{i}.f(out{i}.labels==-1)) ];
    Fp(end+1,:)=out{i}.f(out{i}.labels==1)';
    Fn(end+1,:)=out{i}.f(out{i}.labels==-1)';
    
end

[mpr ipr]=sort(thetap(:,1),1,'descend');
[mpm ipm]=sort(thetap(:,2),1,'descend');
[mps ips]=sort(thetap(:,3),1,'descend');
[mpp ipp]=sort(thetap(:,2)./thetap(:,3),1,'descend');


[mnr inr]=sort(thetan(:,1),1,'descend');
[mnm inm]=sort(thetan(:,2),1,'ascend');
[mns ins]=sort(thetan(:,3),1,'ascend');
[mnp inp]=sort(thetan(:,2)./thetan(:,3),1,'ascend');

[Mp Ip]=sort(thetap(:,2)./thetap(:,3)-thetan(:,2)./thetan(:,3),1,'descend');
[Mr Ir]=sort(thetap(:,1)+thetan(:,1),1,'descend');