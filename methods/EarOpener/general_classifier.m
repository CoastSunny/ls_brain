clear members
members=properties(gNLv);
idx=strmatch('all',members);
members(idx)=[];
for i=1:length(members)        
    if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )                              
        gNLv.combine_subjects('name','all','exclusion',{'all',members{i}});
        gNLv.all.default.train_classifier('name','groupL','classes' , {{50 51 52 53 };{15 25 35 45}});
        mv_gen_rateL(i) = gNLv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [15 25 35 45] ,'target_label',1 );
        mv_gen_rateM(i) = gNLv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [16 26 36 46] ,'target_label',1);
        mv_gen_rateS(i) = gNLv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [17 27 37 47] ,'target_label',1);
        mv_gen_ratest(i) = gNLv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [50 51 52 53] ,'target_label',-1);
    end
end
MV_GEN=[mean(mv_gen_rateL) mean(mv_gen_rateM) mean(mv_gen_rateS) mean(mv_gen_ratest)];
