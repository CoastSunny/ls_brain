
fA=0;fB=0;fC=0;

for si=1:10

    fA=fA+A1csERD{si}(2).out.fpr.dec;
    fB=fB+A2csERD{si}(2).out.fpr.dec;
    fC=fC+A3csERD{si}(2).out.fpr.dec;

end
fA=fA/10;fB=fB/10;fC=fC/10;


tA=0;tB=0;tC=0;

for si=1:10

    tA=tA+A1csERD{si}(2).out.tpr.dec;
    tB=tB+A2csERD{si}(2).out.tpr.dec;
    tC=tC+A3csERD{si}(2).out.tpr.dec;

end
tA=tA/10;tB=tB/10;tC=tC/10;