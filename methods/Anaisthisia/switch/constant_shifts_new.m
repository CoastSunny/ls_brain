function [cs] = constant_shifts_new ( z ,n_con_ex, positive_class,foldtype)

res = z.prep(end).info.res;
Yall=z.Y;
outfIdxs=z.outfIdxs;
pc=positive_class;

for sp=1:size(Yall,2)
    
    Y=Yall(:,sp);
    dv  =  res.tstf( : , sp , res.opt.Ci ) ; %-res.roc.bias_change;
    louk=res.opt.Ci;
    
    dv_val  =   dv( outfIdxs == -1 & Y ~= 0 ) ;
    dv_out  =   dv( outfIdxs ==  1 & Y ~= 0 ) ;
    
    Y_val   =   Y( outfIdxs == -1 & Y ~= 0 ) ;
    Y_out   =   Y( outfIdxs ==  1 & Y ~= 0 ) ;
    
    i_val_nclass    =  Y_val ==  -1*pc ;
    i_val_pclass    =  Y_val == pc ;
    i_out_nclass    =  Y_out ==  -1*pc ;
    i_out_pclass    =  Y_out == pc ;
    
    Y_val_nclass     =  Y_val( i_val_nclass ) ;
    Y_val_pclass     =  Y_val( i_val_pclass ) ;
    Y_out_nclass     =  Y_out( i_out_nclass ) ;
    Y_out_pclass     =  Y_out( i_out_pclass ) ;
    
    dv_val_positive  =  dv_val( i_val_pclass ) * pc; %%%% add pc and for later for >0 <0!!!!!
    dv_val_negative  =  dv_val( i_val_nclass ) * pc;
    dv_out_positive  =  dv_out( i_out_pclass ) * pc;
    dv_out_negative  =  dv_out( i_out_nclass ) * pc;        
    
    if (strcmp(n_con_ex,'all'))
        %n_con_ex=numel(dv_out_positive);
        
        columns_val_positive=1;
        columns_val_negative=1;
        
    else
        
        columns_val_positive = numel( dv_val_positive ) / n_con_ex ;
        dv_val_positive = reshape( dv_val_positive , n_con_ex , columns_val_positive ) ;
        columns_val_negative = numel( dv_val_negative ) / n_con_ex ;
        dv_val_negative = reshape( dv_val_negative , n_con_ex , columns_val_negative ) ;
        
    end
    
    % bias_mod=[0 -1 -2 -5];
    bias_mod=[-5*pc:0.1*pc:5*pc];
    for tr_per_seq=1:n_con_ex
        
        clear sav_dv_val_positive sav_dv_val_negative pro_dv_val_negative pro_dv_val_positive sav_dv_val_positive sav_dv_val_negative A B sig_dv_val_positive sig_dv_val_negative
        
        for j=1:numel(bias_mod)
            
            for i=1:columns_val_positive
                
                sav_dv_val_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_val_positive( : , i ) + bias_mod(j) ) ;                
                
            end
            for i=1:columns_val_negative
                
                sav_dv_val_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_val_negative( : , i ) + bias_mod(j) ) ;
                                
            end
            
            fpr.vanilla = sum( dv_val_negative( : ) > 0 ) / numel( dv_val_negative( : ) ) ;
            tpr.vanilla = sum( dv_val_positive( : ) > 0 ) / numel( dv_val_positive( : ) ) ;                        
            
            temp1 = sav_dv_val_negative( tr_per_seq : end , : ) ;
            temp2 = sav_dv_val_positive( tr_per_seq : end , : ) ;
            fpr.sav( tr_per_seq , j) = sum( temp1( : ) > 0 ) / numel( temp1( : ) ) ;
            tpr.sav( tr_per_seq , j) = sum( temp2( : ) > 0 ) / numel( temp2( : ) ) ;
            
        end
                
        cs(sp).val.fpr = fpr ;
        cs(sp).val.tpr = tpr ;
        
                
    end            
    
end

end