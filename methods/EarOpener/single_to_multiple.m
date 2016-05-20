
members=properties(gNLv);

for i=1:numel(members)
if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )
    sl_s2m_rateL(i)=gNLsv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [15 25 35 45] );
    sl_s2m_rateM(i)=gNLsv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [16 26 36 46] );
    sl_s2m_rateS(i)=gNLsv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [17 27 37 47] );
    sl_s2m_ratest(i)=gNLsv.all.default.apply_classifier( gNLv.(members{i}).default , 'name' , 'groupL' , 'target_markers' , [50 51 52 53] );
end
end
