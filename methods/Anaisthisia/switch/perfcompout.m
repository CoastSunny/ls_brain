clear a b c
for si=1:10
    
    a(si)=(cs1{si}(2).out.tpr.sav(end,51)+(1-cs1{si}(2).out.fpr.sav(end,51)))/2;
    b(si)=(cs2{si}(2).out.tpr.sav(end,51)+(1-cs2{si}(2).out.fpr.sav(end,51)))/2;
    c(si)=(cs3{si}(2).out.tpr.sav(end,51)+(1-cs3{si}(2).out.fpr.sav(end,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(cs1{si}(1).out.tpr.sav(end,51)+(1-cs1{si}(1).out.fpr.sav(end,51)))/2;
    b(si)=(cs2{si}(1).out.tpr.sav(end,51)+(1-cs2{si}(1).out.fpr.sav(end,51)))/2;
    c(si)=(cs3{si}(1).out.tpr.sav(end,51)+(1-cs3{si}(1).out.fpr.sav(end,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(cs1{si}(2).out.tpr.sav(end/2,51)+(1-cs1{si}(2).out.fpr.sav(end/2,51)))/2;
    b(si)=(cs2{si}(2).out.tpr.sav(end/2,51)+(1-cs2{si}(2).out.fpr.sav(end/2,51)))/2;
    c(si)=(cs3{si}(2).out.tpr.sav(end/2,51)+(1-cs3{si}(2).out.fpr.sav(end/2,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(cs1{si}(1).out.tpr.sav(end/2,51)+(1-cs1{si}(1).out.fpr.sav(end/2,51)))/2;
    b(si)=(cs2{si}(1).out.tpr.sav(end/2,51)+(1-cs2{si}(1).out.fpr.sav(end/2,51)))/2;
    c(si)=(cs3{si}(1).out.tpr.sav(end/2,51)+(1-cs3{si}(1).out.fpr.sav(end/2,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(cs1{si}(2).out.tpr.sav(1,51)+(1-cs1{si}(2).out.fpr.sav(1,51)))/2;
    b(si)=(cs2{si}(2).out.tpr.sav(1,51)+(1-cs2{si}(2).out.fpr.sav(1,51)))/2;
    c(si)=(cs3{si}(2).out.tpr.sav(1,51)+(1-cs3{si}(2).out.fpr.sav(1,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

clear a b c
for si=1:10
    
    a(si)=(cs1{si}(1).out.tpr.sav(1,51)+(1-cs1{si}(1).out.fpr.sav(1,51)))/2;
    b(si)=(cs2{si}(1).out.tpr.sav(1,51)+(1-cs2{si}(1).out.fpr.sav(1,51)))/2;
    c(si)=(cs3{si}(1).out.tpr.sav(1,51)+(1-cs3{si}(1).out.fpr.sav(1,51)))/2;
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    
end

figure,hold on,bar([a;b;c;])

%%%%%%%%%%%%%%

clear a b c d e f
for si=1:10
    
    a(si)=cs1{si}(2).out.tpr.sav(end,51);
    b(si)=cs2{si}(2).out.tpr.sav(end,51);
    c(si)=cs3{si}(2).out.tpr.sav(end,51);
    d(si)=cs1{si}(2).out.fpr.sav(end,51);
    e(si)=cs2{si}(2).out.fpr.sav(end,51);
    f(si)=cs3{si}(2).out.fpr.sav(end,51);
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
    
    a(si)=cs1{si}(1).out.tpr.sav(end,51);
    b(si)=cs2{si}(1).out.tpr.sav(end,51);
    c(si)=cs3{si}(1).out.tpr.sav(end,51);
    d(si)=cs1{si}(1).out.fpr.sav(end,51);
    e(si)=cs2{si}(1).out.fpr.sav(end,51);
    f(si)=cs3{si}(1).out.fpr.sav(end,51);
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
    
    a(si)=cs1{si}(2).out.tpr.sav(end/2,51);
    b(si)=cs2{si}(2).out.tpr.sav(end/2,51);
    c(si)=cs3{si}(2).out.tpr.sav(end/2,51);
    d(si)=cs1{si}(2).out.fpr.sav(end/2,51);
    e(si)=cs2{si}(2).out.fpr.sav(end/2,51);
    f(si)=cs3{si}(2).out.fpr.sav(end/2,51);
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
    
    a(si)=cs1{si}(1).out.tpr.sav(end/2,51);
    b(si)=cs2{si}(1).out.tpr.sav(end/2,51);
    c(si)=cs3{si}(1).out.tpr.sav(end/2,51);
    d(si)=cs1{si}(1).out.fpr.sav(end/2,51);
    e(si)=cs2{si}(1).out.fpr.sav(end/2,51);
    f(si)=cs3{si}(1).out.fpr.sav(end/2,51);
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
    
    a(si)=cs1{si}(2).out.tpr.sav(1,51);
    b(si)=cs2{si}(2).out.tpr.sav(1,51);
    c(si)=cs3{si}(2).out.tpr.sav(1,51);
    d(si)=cs1{si}(2).out.fpr.sav(1,51);
    e(si)=cs2{si}(2).out.fpr.sav(1,51);
    f(si)=cs3{si}(2).out.fpr.sav(1,51);
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
    
    a(si)=cs1{si}(1).out.tpr.sav(1,51);
    b(si)=cs2{si}(1).out.tpr.sav(1,51);
    c(si)=cs3{si}(1).out.tpr.sav(1,51);
    d(si)=cs1{si}(1).out.fpr.sav(1,51);
    e(si)=cs2{si}(1).out.fpr.sav(1,51);
    f(si)=cs3{si}(1).out.fpr.sav(1,51);
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
    
    a(si)=cs1{si}(2).out.tpr.sav(end,13);
    b(si)=cs2{si}(2).out.tpr.sav(end,13);
    c(si)=cs3{si}(2).out.tpr.sav(end,13);
    d(si)=cs1{si}(2).out.fpr.sav(end,13);
    e(si)=cs2{si}(2).out.fpr.sav(end,13);
    f(si)=cs3{si}(2).out.fpr.sav(end,13);
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
    
    a(si)=cs1{si}(1).out.tpr.sav(end,12);
    b(si)=cs2{si}(1).out.tpr.sav(end,12);
    c(si)=cs3{si}(1).out.tpr.sav(end,12);
    d(si)=cs1{si}(1).out.fpr.sav(end,12);
    e(si)=cs2{si}(1).out.fpr.sav(end,12);
    f(si)=cs3{si}(1).out.fpr.sav(end,12);
    a(end+1)=mean(a);
    b(end+1)=mean(b);
    c(end+1)=mean(c);
    d(end+1)=mean(d);
    e(end+1)=mean(e);
    f(end+1)=mean(f);
    
end

figure,hold on,bar([a;d;b;e;c;f;])