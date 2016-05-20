function [ rate , dv_output ] = multitrial_classifier( dv_input , no_trials)

    for i = 1 : no_trials
        filt = 1 / i * ( ones( i , 1 ) ) ;                
        dv_output{ i } = filter( filt , 1 , dv_input ) ;
        rate( i ) = sum( sign( dv_output{i}( i : end ) ) > 0 ) / numel( dv_output{ i }( i : end ) ) ; 
    end

end