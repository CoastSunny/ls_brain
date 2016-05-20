% JPsv.train_classifiers('big',[12 20]);
% NLsv.train_classifiers('big',[12 20]);
% JPv.train_classifiers('big',[50 51 52 53; 15 25 35 45]);
% NLv.train_classifiers('big',[50 51 52 53; 15 25 35 45]);

temp=properties(JPsv);
try JPsv.addprop('apply_big_on_small');
catch err
   
end

counter=1;
for i=1:length(temp)

    if (strcmp( class( JPsv.( temp{i} ) ) , 'Subject' ) )
        
        JPsv.apply_big_on_small{counter}(1)=max(JPsv.(temp{i}).big.classifier.result.tstbin);
        JPsv.apply_big_on_small{counter}(2)=JPsv.(temp{i}).apply_classifier('big',JPsv.(temp{i}).marker21);
        JPsv.apply_big_on_small{counter}(3)=JPsv.(temp{i}).apply_classifier('big',JPsv.(temp{i}).marker22);
        counter=counter+1;
    end

end

temp=properties(NLsv);
try NLsv.addprop('apply_big_on_small');
catch err
   
end
counter=1;
for i=1:length(temp)

    if (strcmp( class( NLsv.( temp{i} ) ) , 'Subject' ) )
        
        NLsv.apply_big_on_small{counter}(1)=max(NLsv.(temp{i}).big.classifier.result.tstbin);
        NLsv.apply_big_on_small{counter}(2)=NLsv.(temp{i}).apply_classifier('big',NLsv.(temp{i}).marker21);
        NLsv.apply_big_on_small{counter}(3)=NLsv.(temp{i}).apply_classifier('big',NLsv.(temp{i}).marker22);
        counter=counter+1;
    end

end


temp=properties(JPv);
try JPv.addprop('apply_big_on_small');
catch err
   
end

counter=1;
for i=1:length(temp)

    if (strcmp( class( JPv.( temp{i} ) ) , 'Subject' ) )
        JPv.(temp{i}).combine_markers('marker20',[15 25 35 45]);
        JPv.(temp{i}).combine_markers('marker21',[16 26 36 46]);
        JPv.(temp{i}).combine_markers('marker22',[17 27 37 47]);
        JPv.apply_big_on_small{counter}(1)=max(JPv.(temp{i}).big.classifier.result.tstbin);
        JPv.apply_big_on_small{counter}(2)=JPv.(temp{i}).apply_classifier('big',JPv.(temp{i}).marker21);
        JPv.apply_big_on_small{counter}(3)=JPv.(temp{i}).apply_classifier('big',JPv.(temp{i}).marker22);
        counter=counter+1;
    end

end


temp=properties(NLv);
try NLv.addprop('apply_big_on_small');
catch err
   
end

counter=1;
for i=1:length(temp)

    if (strcmp( class( NLv.( temp{i} ) ) , 'Subject' ) )
        NLv.(temp{i}).combine_markers('marker20',[15 25 35 45]);
        NLv.(temp{i}).combine_markers('marker21',[16 26 36 46]);
        NLv.(temp{i}).combine_markers('marker22',[17 27 37 47]);
        NLv.apply_big_on_small{counter}(1)=max(NLv.(temp{i}).big.classifier.result.tstbin);
        NLv.apply_big_on_small{counter}(2)=NLv.(temp{i}).apply_classifier('big',NLv.(temp{i}).marker21);
        NLv.apply_big_on_small{counter}(3)=NLv.(temp{i}).apply_classifier('big',NLv.(temp{i}).marker22);
        counter=counter+1;
    end

end