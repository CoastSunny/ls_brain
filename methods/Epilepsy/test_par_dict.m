qwe=10:10:250;
res=[];
for iqwe=1:numel(qwe)
param.K=qwe(iqwe);
s = RandStream('swb2712','Seed',1);RandStream.setGlobalStream(s);
[rDs rYs]=nnsc(rXs(:,drtrn),param);
res(iqwe)=norm(rDs*rYs-rXs(:,drtrn),'fro');
end