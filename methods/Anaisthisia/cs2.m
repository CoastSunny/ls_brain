function cs = constant_shifts( z , n_con_ex )

   % -- dv --  decision value
   % -- inc -- indices_negative_class
   % -- ipc -- indices_positive_class
   % -- n_con_ex -- number of consecutive examples
   
   res = z.prep(end).info.res;
   Yall = z.Y;
   outfIdxs = z.outfIdxs;
   
 for sp=1:size(res.tstf,2) 
     
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
   
   dv_val_positive = dv_val( i_val_pclass ) ;
   dv_val_negative = dv_val( i_val_nclass ) ;
   dv_out_positive = dv_out( i_out_pclass ) ;
   dv_out_negative = dv_out( i_out_nclass ) ;
   
   if (strcmp(n_con_ex,'all')); n_con_ex = numel(dv_out_positive); end;
   columns = numel( dv_out_positive ) / n_con_ex ;
   
   dv_out_positive = reshape( dv_out_positive , n_con_ex , columns ) ;
   dv_out_negative = reshape( dv_out_negative , n_con_ex , columns ) ;   
   bias_mod=0:0.1:5;
   
   
   for tr_per_seq=[1 2 3 4 5 6 7 8]
       
       clear sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_val_positive sav_dv_val_negative A B
       %%%%Simple Average %%%%% --sav--
       for j=1:numel(bias_mod);
       for i=1:columns

            sav_dv_out_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out_positive( : , i ) + bias_mod( j ) ) ;
            sav_dv_out_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out_negative( : , i ) + bias_mod( j ) ) ;
           
            pro_dv_out_negative( : , i ) = vec_elements_product( dv_out_negative( : , i ) + bias_mod( j ) , tr_per_seq  ) ;
            pro_dv_out_positive( : , i ) = vec_elements_product( dv_out_positive( : , i ) + bias_mod( j ) , tr_per_seq  ) ;
            
       end                     
       
       fpr.vanilla = sum( dv_out_negative( : ) < 0 ) / numel( dv_out_negative( : ) ) ;
       tpr.vanilla = sum( dv_out_positive( : ) < 0 ) / numel( dv_out_positive( : ) ) ;              
       
       fpr.pro( tr_per_seq , j ) = sum( pro_dv_out_negative( : ) < 0 ) / numel( pro_dv_out_negative( : ) ) ;
       tpr.pro( tr_per_seq , j ) = sum( pro_dv_out_positive( : ) < 0 ) / numel( pro_dv_out_positive( : ) ) ;
                    
       temp1 = sav_dv_out_negative( tr_per_seq : end , : ) ;
       temp2 = sav_dv_out_positive( tr_per_seq : end , : ) ;                               
       
       fpr.sav( tr_per_seq , j ) = sum( temp1( : ) < 0 ) / numel( temp1( : ) ) ;              
       tpr.sav( tr_per_seq , j ) = sum( temp2( : ) < 0 ) / numel( temp2( : ) ) ;                       
       end
   end

   cs(sp).fpr = fpr ;
   cs(sp).tpr = tpr ;
 
 end
 
end