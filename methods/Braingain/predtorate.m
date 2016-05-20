function rate = predtorate(preds,target,code)

    tpred=[];
    for i=1:numel(target)
               
       tpred=[tpred lettertopred(target(i),code)];
    
    end
    
    rate=sum(preds==tpred);

end