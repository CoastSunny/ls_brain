  gJPsv.combine_subjects( 'all' , [ 12 20 21 22 ] , [] ) ;
  gJPsv.all.train_classifier( 'simple' , [ 12 20 ] ) ;

members=properties(gNLv);

for i=1:length(members)
        
    if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )
                                      
        gNLv.( members{ i } ).combine_markers( 'marker50515253' , [ 50 51 52 53 ] );
        gNLv.( members{ i } ).combine_markers( 'marker15253545' , [ 15 25 35 45 ] );                
        gNLv.( members{ i } ).combine_markers( 'marker16263646' , [ 16 26 36 46 ] );
        gNLv.( members{ i } ).combine_markers( 'marker17273747' , [ 17 27 37 47 ] );  
        
        [srate_s2mxl(i) sdv_s2mxl{i}]     = gJPsv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker50515253 ) ;
        [drate_s2mxl_l(i) ddv_s2mxl_l{i}] = gJPsv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker15253545 ) ;
        [drate_s2mxl_m(i) ddv_s2mxl_m{i}] = gJPsv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker16263646 ) ;
        [drate_s2mxl_s(i) ddv_s2mxl_s{i}] = gJPsv.all.apply_classifier( 'simple' , gNLv.( members{ i } ).marker17273747 ) ;
        
        [srate_s2mxl_multi(i,:) sdv_s2mxl_multi{i}]     = multitrial_classifier( sdv_s2mxl  { i } , 20 );
        [drate_s2mxl_multi_l(i,:) ddv_s2mxl_multi_l{i}] = multitrial_classifier( ddv_s2mxl_l{ i } , 20 );
        [drate_s2mxl_multi_m(i,:) ddv_s2mxl_multi_m{i}] = multitrial_classifier( ddv_s2mxl_m{ i } , 20 );
        [drate_s2mxl_multi_s(i,:) ddv_s2mxl_multi_s{i}] = multitrial_classifier( ddv_s2mxl_s{ i } , 20 );
        
    end

end
