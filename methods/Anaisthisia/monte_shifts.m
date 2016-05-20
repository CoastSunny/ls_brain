function [ms] = monte_shifts ( z ,n_con_ex, positive_class)

res = z.prep(end).info.res;
Yall=z.Y;
outfIdxs=z.outfIdxs;
pc=positive_class;

for sp=1:size(Yall,2)
    
    Y=Yall(:,sp);
    dv  =  res.tstf( : , sp , res.opt.Ci ) ; %-res.roc.bias_change;
    louk=res.opt.Ci
    
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
        columns_out_positive=1;
        columns_out_negative=1;
        columns_val_positive=1;
        columns_val_negative=1;
        
    else
        
        columns_out_positive = numel( dv_out_positive ) / n_con_ex ;
        dv_out_positive = reshape( dv_out_positive , n_con_ex , columns_out_positive ) ;
        columns_out_negative = numel( dv_out_negative ) / n_con_ex ;
        dv_out_negative = reshape( dv_out_negative , n_con_ex , columns_out_negative ) ;
        
        columns_val_positive = numel( dv_val_positive ) / n_con_ex ;
        dv_val_positive = reshape( dv_val_positive , n_con_ex , columns_val_positive ) ;
        columns_val_negative = numel( dv_val_negative ) / n_con_ex ;
        dv_val_negative = reshape( dv_val_negative , n_con_ex , columns_val_negative ) ;
        
    end    
    
    bias_mod=[-5*pc:0.5*pc:5*pc];
    s_max=0.5:0.5:3;
    s_thresh=0.5;%:0.02:0.7;
    s_skew=1:0.5:4;
    for b=1:numel(s_max)
        for n=1:numel(s_thresh)
            for p=1:numel(s_skew)
                if (~isempty(dv_out))
                    for tr_per_seq=[1 2 3 4 5 6 7 8 9]
                        
                        clear sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_val_positive sav_dv_val_negative A B sig_dv_out_positive sig_dv_out_negative
                        
                        for j=1:numel(bias_mod)
                            
                            for i=1:columns_out_positive
                                
                                sig_dv_out_positive( : , i ) = sigm_comb( dv_out_positive( : , i ) + bias_mod(j) , tr_per_seq , s_max(b) , s_thresh(n) , s_skew(p) ) ;
                                
                            end
                            for i=1:columns_out_negative
                                
                                sig_dv_out_negative( : , i ) = sigm_comb( dv_out_negative( : , i ) + bias_mod(j) , tr_per_seq , s_max(b) , s_thresh(n) , s_skew(p) ) ;
                                
                            end
                            
                            fpr.vanilla = sum( dv_out_negative( : ) > 0 ) / numel( dv_out_negative( : ) ) ;
                            tpr.vanilla = sum( dv_out_positive( : ) > 0 ) / numel( dv_out_positive( : ) ) ;
                            
                            fpr.sig( tr_per_seq , j , b , n , p) = sum( sig_dv_out_negative( : ) > 0 ) / numel( sig_dv_out_negative( : ) ) ;
                            tpr.sig( tr_per_seq , j , b , n , p) = sum( sig_dv_out_positive( : ) > 0 ) / numel( sig_dv_out_positive( : ) ) ;
                            
                        end
                    end
                    
                    ms(sp).out.fpr = fpr ;
                    ms(sp).out.tpr = tpr ;
                    ms(sp).out.tstauc = res.tstauc(:,:,res.opt.Ci);
                    
                end
                
            end
        end
    end            
    
end

end