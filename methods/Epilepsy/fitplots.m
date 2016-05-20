yl=[-.15 .15];

for ci=1:numel(subj)
    
    figure
    subplot(2,2,1)
    plot((Xtrn{ci})),title('intra-true')%,ylim(yl)
    subplot(2,2,2)
    plot(mean(Ytst{ci},3)'),title('scalp-true')%,ylim(yl)   
    subplot(2,2,3)
    plot(mean(slYtst{ci},3)'),title('spatial-modelled')%,ylim(yl)
    subplot(2,2,4)
    plot(mean(stlYtst{ci},3)'),title('spatiotemporal-modelled')%,ylim(yl)

end