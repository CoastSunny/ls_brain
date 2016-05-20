clear members
members=properties(gNLv);
idx=strmatch('all',members);
members(idx)=[];
for i=1:numel(members)
if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )
    xl_m2m_rateL(  i) = gjpv_all.default.apply_classifier( gNLv.(  members{i} ).default , 'name' , 'groupL' , 'target_markers'  , [15 25 35 45] , 'target_label' ,  1 );
    xl_m2m_rateM(  i) = gjpv_all.default.apply_classifier( gNLv.(  members{i} ).default , 'name' , 'groupL' , 'target_markers'  , [16 26 36 46] , 'target_label' ,  1 );
    xl_m2m_rateS(  i) = gjpv_all.default.apply_classifier( gNLv.(  members{i} ).default , 'name' , 'groupL' , 'target_markers'  , [17 27 37 47] , 'target_label' ,  1 );
    xl_m2m_ratest( i) = gjpv_all.default.apply_classifier( gNLv.(  members{i} ).default , 'name' , 'groupL' , 'target_markers'  , [50 51 52 53] , 'target_label' , -1 );    
end
end
XL_M2M=[mean(xl_m2m_rateL) mean(xl_m2m_rateM) mean(xl_m2m_rateS) mean(xl_m2m_ratest)]