function out = getdiversity(F1,F2)

for i=1:size(F1,3)
    
    dv1=F1{:,:,i};
    dv2=-F2{:,:,i};
    rest1=dv1(1:12,:);
    movement1=dv1(13:end,:);    
    rest2=dv2(1:12,:);
    movement2=dv2(13:end,:);
    
    f1=[-1*rest1(:)' movement1(:)'];
    f2=[-1*rest2(:)' movement2(:)'];
    noe=numel(f1);
    a = sum(f1>0 & f2>0) / noe;
    b = sum(f1>0 & f2<0) / noe;
    c = sum(f1<0 & f2>0) / noe;
    d = sum(f1<0 & f2<0) / noe;
    
    correlation(i)  = (a*d-b*c)/sqrt((a+b)*(c+d)*(a+c)*(b+d));
    qstatistic(i)   = (a*d-b*c)/(a*d+b*c);
    disagreement(i) = b+c;
    doublefault(i)  = d;
    
end

out.correlation  = correlation;
out.qstatistic   = qstatistic;
out.disagreement = disagreement;
out.doublefault  = doublefault;
a+b+c+d

end