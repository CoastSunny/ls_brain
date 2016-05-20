sum1=0;sum2=0;sum3=0;
s=find(S.default.markers==50 | S.default.markers==51 | S.default.markers==52 | S.default.markers==53);
d=find(S.default.markers==15 | S.default.markers==25 | S.default.markers==35 | S.default.markers==45)
clear X w
ch=1:1:64;
for i=1:numel(s)
    
    X(:,:,i)=S.default.data.trial{s(i)}(ch,1:128);
    [e v Z(:,:,i)]=pcsquash(X(:,:,i),16);
    
end

for i=1:numel(d)
    
    X(:,:,i+numel(s))=S.default.data.trial{d(i)}(ch,1:128);
    [e v Z(:,:,i+numel(s))]=pcsquash(X(:,:,i+numel(s)),16);
    
end
K=numel(s)+numel(d);

for i=1:K
   if (i<=numel(s))
       y=y2;
   else
       y=y1;
   end
  
   sum1=sum1+y*Z(:,:,i)';
   sum2=sum2+(Z(:,:,i)*Z(:,:,i)');
   sum3=sum3+y*Z(:,:,i)'*(Z(:,:,i)*Z(:,:,i)');
end

w=1/K*sum1*inv(1/K*sum2);
w2=1/K/K*sum3;

for i=1:K
    r=w*Z(:,:,i);
    r2=w2*Z(:,:,i);
    ds(i)=norm(y2-r2/norm(r2));
    dd(i)=norm(y1/norm(y1)-r/norm(r));
    c1(i)=(y1-mean(y1))*(r-mean(r))'/norm(y1)/norm(r);
    c2(i)=(y2-mean(y1))*(r-mean(r))'/norm(y1)/norm(r);
end
% stest=find(S.default.markers==51);
% dtest=find(S.default.markers==16);
% 
% for i=1:numel(stest)
%     x=S.default.data.trial{stest(i)};
%     ds(i,:)=[norm(w*x-y2) norm(w*x-y1)];
% end
% 
% 
% for i=1:numel(dtest)
%     dd(i,:)=[norm(w*S.default.data.trial{dtest(i)}-y2) norm(w*S.default.data.trial{dtest(i)}-y1)];
% end



