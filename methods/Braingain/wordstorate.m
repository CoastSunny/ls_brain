function rate = wordstorate(word,target,code)

    wpred=[];tpred=[];
    for i=1:numel(word)
        
       wpred=[wpred lettertopred(word(i),code)];
       tpred=[tpred lettertopred(target(i),code)];
    
    end

    rate=sum(wpred==tpred);
    
end