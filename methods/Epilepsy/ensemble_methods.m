function out = ensemble_methods(F,labels,voters,positive_class)

if nargin<4
    positive_class=1;
end
pc=positive_class;
labels=labels*pc;
F=F*pc;
trdim=max(size(F,1),size(F,2));
clsfrdim=min(size(F,1),size(F,2));
F=reshape(F,trdim,clsfrdim);
dv_positive=F(labels==1,:);
dv_negative=F(labels==-1,:);

labels=reshape(labels,trdim,1);

for i=1:size(F,1)

    f(i) = sum(sign(F(i,:))==1);
    decision(i) = f(i) >= voters;

end

out.f=f;
out.decision=decision;
out.pdecision=(decision(labels==1)==1);
out.ndecision=(decision(labels==-1)==1);
out.tpr=sum(decision(labels==1))/numel(labels(labels==1));
out.fpr=sum(decision(labels==-1))/numel(labels(labels==-1));
out.perf=(out.tpr+1-out.fpr)/2;

end