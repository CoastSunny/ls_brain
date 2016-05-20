function seq = seq_classify( res , Yall , outfIdxs )

% -- dv --  decision value
% -- inc -- indices_negative_class
% -- ipc -- indices_positive_class
% -- n_con_ex -- number of consecutive examples



for sp=1:size(Yall,2)
    
    dv = res.tstf( : , sp , res.opt.Ci ) ;%-res.roc.bias_change;
    Y=Yall(:,sp);
    
    dv_val = dv( outfIdxs == -1 & Y ~= 0 ) ;
    dv_out = dv( outfIdxs == 1 & Y ~= 0 ) ;
    
    Y_val = Y( outfIdxs == -1 & Y ~= 0 ) ;
    Y_out = Y( outfIdxs == 1 & Y ~= 0 ) ;
    
    i_val_nclass = Y_val ==  1 ;
    i_val_pclass = Y_val == -1 ;
    i_out_nclass = Y_out ==  1 ;
    i_out_pclass = Y_out == -1 ;
    
    Y_val_nclass = Y_val( i_val_nclass ) ;
    Y_val_pclass = Y_val( i_val_pclass ) ;
    Y_out_nclass = Y_out( i_out_nclass ) ;
    Y_out_pclass = Y_out( i_out_pclass ) ;
    
    n_con_ex = 9;
    
    dv_val_positive = dv_val( i_val_pclass ) ;
    dv_val_negative = dv_val( i_val_nclass ) ;
    dv_out_positive = dv_out( i_out_pclass ) ;
    dv_out_negative = dv_out( i_out_nclass ) ;
    
    
    columns_val = numel( dv_val_positive ) / n_con_ex ;
    dv_val_positive = reshape( dv_val_positive , n_con_ex , columns_val ) ;
    dv_val_negative = reshape( dv_val_negative , n_con_ex , columns_val ) ;
    
    columns_out = numel( dv_out_positive ) / n_con_ex ;
    dv_out_positive = reshape( dv_out_positive , n_con_ex , columns_out ) ;
    dv_out_negative = reshape( dv_out_negative , n_con_ex , columns_out ) ;
    
    %figure,imagesc(sign(dv_out_negative)) ;
    columns = numel( dv_out_positive ) / n_con_ex ;
    
    for tr_per_seq = [1 2 3 4 5 6 7 8 9]
        
        clear sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_val_positive sav_dv_val_negative A B
        %%%%Simple Average %%%%% --sav--
        for i=1:columns_val
            
            sav_dv_val_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_val_positive( : , i ) ) ;
            sav_dv_val_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_val_negative( : , i ) ) ;
            
        end
        
        for i=1:columns_out
            
            sav_dv_out_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out_positive( : , i ) ) ;
            sav_dv_out_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out_negative( : , i ) ) ;
            
        end
        
        fpr.vanilla = sum( dv_out_negative( : ) < 0 ) / numel( dv_out_negative( : ) ) ;
        tpr.vanilla = sum( dv_out_positive( : ) < 0 ) / numel( dv_out_positive( : ) ) ;
        
        %        fpr.pro( tr_per_seq ) = sum( pro_dv_out_negative( : ) < 0 ) / numel( pro_dv_out_negative( : ) ) ;
        %        tpr.pro( tr_per_seq ) = sum( pro_dv_out_positive( : ) < 0 ) / numel( pro_dv_out_positive( : ) ) ;
        
        %        opts.fpr=fpr.pro(tr_per_seq);
        
        temp1 = sav_dv_val_negative( tr_per_seq : end , : ) ;%%%%%FIX tr_per_seq??
        temp2 = sav_dv_val_positive( tr_per_seq : end , : ) ;
        %
        opts.visualise='off';
        opts.fpr=0.03;
        roc = rocCalibrate( [ temp2(:)' temp1(:)' ] , [ -ones( 1 , numel(temp2( : )) ) ones( 1 , numel(temp1(:)) ) ] , opts ) ;
        %        %roc
        temp1 = sav_dv_out_negative( tr_per_seq : end , : ) ;
        temp2 = sav_dv_out_positive( tr_per_seq : end , : ) ;
             
        fpr.sav( tr_per_seq ) = sum( temp1( : ) + roc.bias_change < 0 ) / numel( temp1( : ) ) ;
        tpr.sav( tr_per_seq ) = sum( temp2( : ) + roc.bias_change < 0 ) / numel( temp2( : ) ) ;
        
        %        fpr.louk(tr_per_seq) = sum( sign( temp1( : ) + roc.bias_change2 ) + sign( pro_dv_out_negative(:) )  <=0 ) / numel(temp1(:));
        %        tpr.louk(tr_per_seq) = sum( sign( temp2( : ) + roc.bias_change2 ) + sign( pro_dv_out_positive(:) )  <=0 ) / numel(temp2(:));
        %
        %        temp2 = dv_val_negative( : ) ;
        %        temp3 = dv_val_positive( : ) ;
        %        temp4 = floor( numel( temp2 ) / tr_per_seq ) ;
        %        A = reshape( temp2( 1 : temp4 * tr_per_seq ) , tr_per_seq , temp4 )' ;
        %        B = reshape( temp3( 1 : temp4 * tr_per_seq ) , tr_per_seq , temp4 )' ;
        %        z = ones(numel( temp2 ) / tr_per_seq , 1 ) ;
        %        w = inv( A'*A ) * A' * z ;
        %        temp5 = dv_out_negative ;
        %        temp6 = dv_out_positive ;
        %        temp7 = floor( numel ( temp5 )/ tr_per_seq ) ;
        %        A_out = reshape( temp5( 1 : temp7 * tr_per_seq ) , tr_per_seq , temp7 )' ;
        %        B_out = reshape( temp6( 1 : temp7 * tr_per_seq ) , tr_per_seq , temp7 )' ;
        %
        %        fpr.wav( tr_per_seq ) = sum( sign( A_out * w ) < 0 ) / numel ( A_out * w) ;
        %        tpr.wav( tr_per_seq ) = sum( sign( B_out * w ) < 0 ) / numel ( B_out * w) ;
        
    end
    
    seq(sp).fpr = fpr ;
    seq(sp).tpr = tpr ;
end
end