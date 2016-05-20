clear members
members=properties(gNLsv);
idx=strmatch('all',members);
members(idx)=[];
for i=1:numel(members)
if ( strcmp( class( gNLsv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )
    xl_s2s_rateL(i)  = gjpsv_all.default.apply_classifier( gNLsv.(members{i}).default  ,  'name' , 'groupL' , 'target_markers' , [20],'target_label',1 );
    xl_s2s_rateM(i)  = gjpsv_all.default.apply_classifier( gNLsv.(members{i}).default  ,  'name' , 'groupL' , 'target_markers' , [21],'target_label',1 );
    xl_s2s_rateS(i)  = gjpsv_all.default.apply_classifier( gNLsv.(members{i}).default  ,  'name' , 'groupL' , 'target_markers' , [22] ,'target_label',1);
    xl_s2s_ratest(i) = gjpsv_all.default.apply_classifier( gNLsv.(members{i}).default ,  'name' , 'groupL' , 'target_markers' , [12] ,'target_label',-1);
end    
end
XL_S2S=[mean(xl_s2s_rateL) mean(xl_s2s_rateM) mean(xl_s2s_rateS) mean(xl_s2s_ratest)]