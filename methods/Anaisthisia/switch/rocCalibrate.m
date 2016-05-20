function roc = rocCalibrate( dv , Y , pc, opts )

ofpr = sum( pc * dv >=0 & Y== - pc)/sum(Y==-pc);
otpr = sum( pc * dv >=0 & Y== pc)/sum(Y==pc);

pc=single(pc);
bias_min=min(dv);
bias_max=max(dv);
bias_steps = -max(dv):(max(dv)-min(dv))/opts.steps:-min(dv);

for i=1:opts.steps+1
    
    fpr(i) = sum( pc * dv + pc * bias_steps(i) >=0 & Y == - pc)/sum(Y == -pc);
    tpr(i) = sum( pc * dv + pc * bias_steps(i) >=0 & Y == pc)  /sum(Y == pc);

end


if (ofpr <= opts.fpr)
    
    roc.bias_change  = 0;
    roc.calfpr=ofpr;
    roc.caltpr=otpr;
    return;

else
    
    idx = find(fpr<=opts.fpr);
    roc.calfpr=fpr(idx(1));
    roc.caltpr=tpr(idx(1));
    roc.bias_change=bias_steps(idx(1));% NB the bias change is for the original problem without 
                                    % the label inversion for the class   
        
end

 roc.ofpr=ofpr;
 roc.otpr=otpr;

end