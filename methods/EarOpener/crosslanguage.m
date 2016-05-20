 gJPv.combine_subjects( 'all' , [ 15 16 17 25 26 27 35 36 37 45 46 47 50 51 52 53 ] , [] ) ;
 gJPv.all.train_classifier( 'simple' , [ 15 25 35 45 ; 50 51 52 53 ] ) ;

members=properties(gNLv);

for i=1:length(members)
        
    if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )
                                      
        gNLv.( members{ i } ).combine_markers( 'marker50515253' , [ 50 51 52 53 ] );
        gNLv.( members{ i } ).combine_markers( 'marker15253545' , [ 15 25 35 45 ] );                
        gNLv.( members{ i } ).combine_markers( 'marker16263646' , [ 16 26 36 46 ] );
        gNLv.( members{ i } ).combine_markers( 'marker17273747' , [ 17 27 37 47 ] );  
        
        [srate_xl(i) sdv_xl{i}]     = gJPv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker50515253 ) ;
        [drate_xl_l(i) ddv_xl_l{i}] = gJPv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker15253545 ) ;
        [drate_xl_m(i) ddv_xl_m{i}] = gJPv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker16263646 ) ;
        [drate_xl_s(i) ddv_xl_s{i}] = gJPv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker17273747 ) ;
        
        [srate_xl_multi(   i , : ) sdv_xl_multi{   i }  ] = multitrial_classifier( sdv_xl  { i } , 20 );
        [drate_xl_multi_l( i , : ) ddv_xl_multi_l{ i }]   = multitrial_classifier( ddv_xl_l{ i } , 20 );
        [drate_xl_multi_m( i , : ) ddv_xl_multi_m{ i }]   = multitrial_classifier( ddv_xl_m{ i } , 20 );
        [drate_xl_multi_s( i , : ) ddv_xl_multi_s{ i }]   = multitrial_classifier( ddv_xl_s{ i } , 20 );
        
    end

end
