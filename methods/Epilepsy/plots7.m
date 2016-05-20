
for si=1:numel(subj)
    
    figure,plot(mean(FSP{si},1)),hold on,plot(mean(FNSP{si},1),'r')

end