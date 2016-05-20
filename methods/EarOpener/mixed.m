gNLv.train_classifiers( 'mixed' , [ 15 25 35 45 17 27 37 47 ; 50 51 52 53 12 22 32 42 ] ) ;
gNLv.train_classifiers( 'simple' , [ 15 25 35 45 ; 50 51 52 53 ] ) ;
members = properties( gNLv ) ;

for i=1:length( members )
        
    if ( strcmp( class( gNLv.( members{ i } ) ) , 'Subject' ) && ~strcmp( members{ i } , 'all' ) )

        gNLv.( members{ i } ).combine_markers( 'marker16263646' , [ 16 26 36 46 ] );
        [ drate_simple( i ) ddv_simple{ i } ] = gNLv.( members{ i } ).apply_classifier( 'simple' , gNLv.( members{ i } ).marker16263646 ) ;
        [ drate_mixed( i )  ddv_mixed{ i }  ] = gNLv.( members{ i } ).apply_classifier( 'mixed'  , gNLv.( members{ i } ).marker16263646 ) ;        
        
    end

end
