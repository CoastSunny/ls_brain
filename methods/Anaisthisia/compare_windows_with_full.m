combined=[];
tnrtpr=[];
nz_idx=[];
for i=[1:3 5:10]
    
    combined(end+1)=(1-seq{i}(1).fpr.sav(9)+seq{i}(1).tpr.sav(9))/2;
    tnrtpr(end+1)=(abs(1-seq{i}(1).fpr.sav(9)-combined(end)));
    if (tnrtpr(end) ==0);tnrtpr(end)=0.00001;end;
end

bar(combined);
hold on
errorb(combined,tnrtpr)