clear a b c
for si=1:10
    
    a(si)=(A1csERD{si}(2).out.tpr.dec(end,51)+(1-A1csERD{si}(2).out.fpr.dec(end,51)))/2;
    b(si)=(A2csERD{si}(2).out.tpr.dec(end,51)+(1-A2csERD{si}(2).out.fpr.dec(end,51)))/2;
    c(si)=(A3csERD{si}(2).out.tpr.dec(end,51)+(1-A3csERD{si}(2).out.fpr.dec(end,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(A1csERD{si}(1).out.tpr.dec(end,51)+(1-A1csERD{si}(1).out.fpr.dec(end,51)))/2;
    b(si)=(A2csERD{si}(1).out.tpr.dec(end,51)+(1-A2csERD{si}(1).out.fpr.dec(end,51)))/2;
    c(si)=(A3csERD{si}(1).out.tpr.dec(end,51)+(1-A3csERD{si}(1).out.fpr.dec(end,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(A1csERD{si}(2).out.tpr.dec(end/2,51)+(1-A1csERD{si}(2).out.fpr.dec(end/2,51)))/2;
    b(si)=(A2csERD{si}(2).out.tpr.dec(end/2,51)+(1-A2csERD{si}(2).out.fpr.dec(end/2,51)))/2;
    c(si)=(A3csERD{si}(2).out.tpr.dec(end/2,51)+(1-A3csERD{si}(2).out.fpr.dec(end/2,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(A1csERD{si}(1).out.tpr.dec(end/2,51)+(1-A1csERD{si}(1).out.fpr.dec(end/2,51)))/2;
    b(si)=(A2csERD{si}(1).out.tpr.dec(end/2,51)+(1-A2csERD{si}(1).out.fpr.dec(end/2,51)))/2;
    c(si)=(A3csERD{si}(1).out.tpr.dec(end/2,51)+(1-A3csERD{si}(1).out.fpr.dec(end/2,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(A1csERD{si}(2).out.tpr.dec(1,51)+(1-A1csERD{si}(2).out.fpr.dec(1,51)))/2;
    b(si)=(A2csERD{si}(2).out.tpr.dec(1,51)+(1-A2csERD{si}(2).out.fpr.dec(1,51)))/2;
    c(si)=(A3csERD{si}(2).out.tpr.dec(1,51)+(1-A3csERD{si}(2).out.fpr.dec(1,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(A1csERD{si}(1).out.tpr.dec(1,51)+(1-A1csERD{si}(1).out.fpr.dec(1,51)))/2;
    b(si)=(A2csERD{si}(1).out.tpr.dec(1,51)+(1-A2csERD{si}(1).out.fpr.dec(1,51)))/2;
    c(si)=(A3csERD{si}(1).out.tpr.dec(1,51)+(1-A3csERD{si}(1).out.fpr.dec(1,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

%%%%%%%%%%%%%%

clear a b c d e f
for si=1:10
    
    a(si)=A1csERD{si}(2).out.tpr.dec(end,51);
    b(si)=A2csERD{si}(2).out.tpr.dec(end,51);
    c(si)=A3csERD{si}(2).out.tpr.dec(end,51);
    d(si)=A1csERD{si}(2).out.fpr.dec(end,51);
    e(si)=A2csERD{si}(2).out.fpr.dec(end,51);
    f(si)=A3csERD{si}(2).out.fpr.dec(end,51);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])

clear a b c d e f
for si=1:10
    
    a(si)=A1csERD{si}(1).out.tpr.dec(end,51);
    b(si)=A2csERD{si}(1).out.tpr.dec(end,51);
    c(si)=A3csERD{si}(1).out.tpr.dec(end,51);
    d(si)=A1csERD{si}(1).out.fpr.dec(end,51);
    e(si)=A2csERD{si}(1).out.fpr.dec(end,51);
    f(si)=A3csERD{si}(1).out.fpr.dec(end,51);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])


clear a b c d e f
for si=1:10
    
    a(si)=A1csERD{si}(2).out.tpr.dec(end/2,51);
    b(si)=A2csERD{si}(2).out.tpr.dec(end/2,51);
    c(si)=A3csERD{si}(2).out.tpr.dec(end/2,51);
    d(si)=A1csERD{si}(2).out.fpr.dec(end/2,51);
    e(si)=A2csERD{si}(2).out.fpr.dec(end/2,51);
    f(si)=A3csERD{si}(2).out.fpr.dec(end/2,51);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])

clear a b c d e f
for si=1:10
    
    a(si)=A1csERD{si}(1).out.tpr.dec(end/2,51);
    b(si)=A2csERD{si}(1).out.tpr.dec(end/2,51);
    c(si)=A3csERD{si}(1).out.tpr.dec(end/2,51);
    d(si)=A1csERD{si}(1).out.fpr.dec(end/2,51);
    e(si)=A2csERD{si}(1).out.fpr.dec(end/2,51);
    f(si)=A3csERD{si}(1).out.fpr.dec(end/2,51);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])


clear a b c d e f
for si=1:10
    
    a(si)=A1csERD{si}(2).out.tpr.dec(1,51);
    b(si)=A2csERD{si}(2).out.tpr.dec(1,51);
    c(si)=A3csERD{si}(2).out.tpr.dec(1,51);
    d(si)=A1csERD{si}(2).out.fpr.dec(1,51);
    e(si)=A2csERD{si}(2).out.fpr.dec(1,51);
    f(si)=A3csERD{si}(2).out.fpr.dec(1,51);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])

clear a b c d e f
for si=1:10
    
    a(si)=A1csERD{si}(1).out.tpr.dec(1,51);
    b(si)=A2csERD{si}(1).out.tpr.dec(1,51);
    c(si)=A3csERD{si}(1).out.tpr.dec(1,51);
    d(si)=A1csERD{si}(1).out.fpr.dec(1,51);
    e(si)=A2csERD{si}(1).out.fpr.dec(1,51);
    f(si)=A3csERD{si}(1).out.fpr.dec(1,51);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])


