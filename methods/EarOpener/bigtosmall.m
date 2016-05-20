
gNLv.train_classifiers('simple',[15 25 35 45; 50 51 52 53]);

members=properties(gNLv);

for i=1:numel(members)

    if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) )
                        
       gNLv.(members{i}).combine_markers('marker16263646',[16 26 36 46]);
       gNLv.(members{i}).combine_markers('marker17273747',[17 27 37 47]);
       [ratem(i) dvm{i}]=gNLv.(members{i}).apply_classifier('simple',gNLv.(members{i}).marker16263646);
       mratem{i}=multitrial_classifier(dvm{i},15);
       [rates(i) dvs{i}]=gNLv.(members{i}).apply_classifier('simple',gNLv.(members{i}).marker17273747);
       mrates{i}=multitrial_classifier(dvs{i},15);
       
    end
    
    
end
    
    