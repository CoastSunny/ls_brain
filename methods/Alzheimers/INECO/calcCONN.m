Q=B;
W=A;
z1=Q(1,:)==1;
b1=Q(:,z1);
z0=Q(1,:)==0;
b0=Q(:,z0);
count=0;
tmp=[];
CON=[];
thr=0:0.01:0.5;
res=[];

for th=1:numel(thr)
    
    c=(b1(3,:)>thr(th));
    d=(b0(3,:)<thr(th));
    e=[c d];
    res(th)=(sum(e==0)*(-2) + sum(e==1)*1)/numel(e);

%      tmp{count}=[ones(1,c+d) -2*ones(1,d)];
end
% for i=1:count
%     CON(i)=mean(tmp{i});
% end
    
plot(thr,res)
figure,hold on,scatter(b1(2,:),b1(3,:)),scatter(b0(2,:),b0(3,:),'r')