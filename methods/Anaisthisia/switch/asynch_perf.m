function [cs] = asynch_perf( z ,n_con_ex, positive_class)

res = z.prep(end).info.res;
Yall=z.Y;
outfIdxs=z.outfIdxs;
pc=positive_class;

for sp=1:size(Yall,2)
    
    Y=Yall(:,sp);
    opt_Ci=res.opt.Ci;
    dv  =  res.tstf( : , sp , opt_Ci ) ; %-res.roc.bias_change;
    
    dv_out  =   dv( outfIdxs ==  1 & Y ~= 0 ) * pc ;
    
    Y_out   =   Y( outfIdxs ==  1 & Y ~= 0 ) ;
    
    i_out_nclass    =  Y_out ==  -1*pc ;
    i_out_pclass    =  Y_out == pc ;
    
    Y_out_nclass     =  Y_out( i_out_nclass ) ;
    Y_out_pclass     =  Y_out( i_out_pclass ) ;
    
    dv_out_positive  =  dv_out( i_out_pclass );
    dv_out_negative  =  dv_out( i_out_nclass );
    fpr.vanilla = sum( dv_out_negative( : ) > 0 ) / numel( dv_out_negative( : ) ) ;
    tpr.vanilla = sum( dv_out_positive( : ) > 0 ) / numel( dv_out_positive( : ) ) ;
    
    if (strcmp(n_con_ex,'all'))
        
        n_con_ex=numel(dv_out);
        columns_out=1;
        
    else
        
        columns_out = numel( dv_out ) / n_con_ex ;
        dv_out = reshape( dv_out , n_con_ex , columns_out) ;
        i_out_nclass = reshape( i_out_nclass, n_con_ex, columns_out );
        i_out_pclass = reshape( i_out_pclass, n_con_ex, columns_out );
        
    end
    
    % bias_mod=[0 -1 -2 -5];
    bias_mod=[-5*pc:0.1*pc:5*pc];
    for tr_per_seq=1:n_con_ex
        
        clear sav_dv_out sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_out_positive sav_dv_out_negative
        
        for j=1:numel(bias_mod)
            
            for i=1:columns_out
                
                sav_dv_out( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out( : , i ) + bias_mod(j) ) ;
                
            end
           
            temp = sav_dv_out( tr_per_seq : end , : ) ;
            temp_i_pclass=i_out_pclass( tr_per_seq : end , : ) ;
            temp_i_nclass=i_out_nclass( tr_per_seq : end , : ) ;                       
            
            sav_dv_out_negative = temp(temp_i_nclass);
            sav_dv_out_positive = temp(temp_i_pclass);
            
            if (tr_per_seq==1 && j==51)
            cs(sp).out.dv.pos=sav_dv_out_positive;
            cs(sp).out.dv.neg=sav_dv_out_negative;
            end
            
            fpr.sav( tr_per_seq , j) = sum( sav_dv_out_negative > 0 ) / numel( sav_dv_out_negative( : ) ) ;
            tpr.sav( tr_per_seq , j) = sum( sav_dv_out_positive > 0 ) / numel( sav_dv_out_positive( : ) ) ;
            
        end
        
        
        
        
    end
    
    bias_mod=[-5*pc:0.1*pc:5*pc];
    for tr_per_seq=1:6
        
        clear move_dv_pclass move_dv_nclass sav_dv_out sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_out_positive sav_dv_out_negative
        
        for j=1:numel(bias_mod)
            
            for i=1:columns_out
                
                temp_pclass = dv_out(i_out_pclass(:,i),i) + bias_mod(j) ;
                temp_nclass = dv_out(i_out_nclass(:,i),i) + bias_mod(j) ;
                move_dv_pclass( : , i ) = sum( temp_pclass(1:tr_per_seq) ) ;
                move_dv_nclass{i} = filter( 1/tr_per_seq*ones(1,tr_per_seq),1,temp_nclass ) ;
                
            end
            temp=[move_dv_nclass{1};move_dv_nclass{2};move_dv_nclass{3};move_dv_nclass{4};move_dv_nclass{5};];
            fpr.dec( tr_per_seq , j) = sum( temp > 0 ) / numel( temp ) ;
            tpr.dec( tr_per_seq , j) = sum( move_dv_pclass(:) > 0 ) / numel( move_dv_pclass(:) ) ;
            
        end
        
        
        
    end
    
    bias_mod=[-5*pc:0.1*pc:5*pc];
    for tr_per_seq=1:6
        
        clear move_dv_pclass move_dv_nclasssav_dv_out sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_out_positive sav_dv_out_negative
        
        for j=1:numel(bias_mod)
            
            for i=1:columns_out
                
                temp_pclass = dv_out(i_out_pclass(:,i),i) + bias_mod(j) ;
                temp_nclass = dv_out(i_out_nclass(:,i),i) + bias_mod(j) ;
                move_dv_pclass{i} = filter( ones(1,tr_per_seq),1,temp_pclass ) ;
                move_dv_nclass{i} = filter( ones(1,tr_per_seq),1,temp_nclass ) ;
                
            end
            temp_pos=[move_dv_pclass{1};move_dv_pclass{2};move_dv_pclass{3};move_dv_pclass{4};move_dv_pclass{5};];
            temp_neg=[move_dv_nclass{1};move_dv_nclass{2};move_dv_nclass{3};move_dv_nclass{4};move_dv_nclass{5};];
            fpr.dec2( tr_per_seq , j) = sum( temp_neg > 0 ) / numel( temp_neg ) ;
            tpr.dec2( tr_per_seq , j) = sum( temp_pos > 0 ) / numel( temp_pos ) ;
            
        end
        
        
        
    end
    
    cs(sp).out.fpr = fpr ;
    cs(sp).out.tpr = tpr ;
end

end