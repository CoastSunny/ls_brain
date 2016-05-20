

FPRam=0;
TPRam=0;
for i=1:10
   
    FPRam=FPRam+ap{i}(2).out.fpr.sav;
    TPRam=TPRam+ap{i}(2).out.tpr.sav;
    
end
FPRam=0.1*FPRam;
TPRam=0.1*TPRam;