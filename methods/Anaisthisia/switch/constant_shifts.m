function [cs] = constant_shifts ( z ,n_con_ex, positive_class)

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
    
   % bias_mod=[0 -1 -2 -5];
    bias_mod=[-5*pc:0.5*pc:5*pc];
    for tr_per_seq=[1 2 3 4 5 6 7 8 9]
        
        clear sav_dv_val_positive sav_dv_val_negative pro_dv_val_negative pro_dv_val_positive sav_dv_val_positive sav_dv_val_negative A B sig_dv_val_positive sig_dv_val_negative
        
        for j=1:numel(bias_mod)
            
            for i=1:columns_val_positive
                
                sav_dv_val_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_val_positive( : , i ) + bias_mod(j) ) ;
                pro_dv_val_positive( : , i ) = vec_elements_product( dv_val_positive( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                sig_dv_val_positive( : , i ) = sigm_comb( dv_val_positive( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                
            end
            for i=1:columns_val_negative
                
                sav_dv_val_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_val_negative( : , i ) + bias_mod(j) ) ;
                pro_dv_val_negative( : , i ) = vec_elements_product( dv_val_negative( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                sig_dv_val_negative( : , i ) = sigm_comb( dv_val_negative( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                
            end
            
            fpr.vanilla = sum( dv_val_negative( : ) > 0 ) / numel( dv_val_negative( : ) ) ;
            tpr.vanilla = sum( dv_val_positive( : ) > 0 ) / numel( dv_val_positive( : ) ) ;
            
            fpr.pro( tr_per_seq , j) = sum( pro_dv_val_negative( : ) > 0 ) / numel( pro_dv_val_negative( : ) ) ;
            tpr.pro( tr_per_seq , j) = sum( pro_dv_val_positive( : ) > 0 ) / numel( pro_dv_val_positive( : ) ) ;
            
            temp1 = sav_dv_val_negative( tr_per_seq : end , : ) ;
            temp2 = sav_dv_val_positive( tr_per_seq : end , : ) ;
            fpr.sav( tr_per_seq , j) = sum( temp1( : ) > 0 ) / numel( temp1( : ) ) ;
            tpr.sav( tr_per_seq , j) = sum( temp2( : ) > 0 ) / numel( temp2( : ) ) ;
            
        end
        
        Fp=lagmatrix(dv_val_positive(:),0:(tr_per_seq-1))';
        Fn=lagmatrix(dv_val_negative(:),0:(tr_per_seq-1))';
        F=[Fp Fn];
        %F(tr_per_seq+1,:)=ones(1,size(F,2));
        y=[3*ones(1,size(Fp,2)) -ones(1,size(Fn,2))];
        
        if(tr_per_seq~=1)
            w{tr_per_seq}=(F*F'+0*eye(size(F,1)))\(F*y');
        else
            %w{tr_per_seq}=[1 0];
            w{tr_per_seq}=1;
        end
        cs(sp).val.w{tr_per_seq}=w{tr_per_seq};
    end
    
    cs(sp).val.fpr = fpr ;
    cs(sp).val.tpr = tpr ;
    cs(sp).val.pclass=[mean(dv_val_positive(:)) std(dv_val_positive(:)) kurtosis(dv_val_positive(:))];
    cs(sp).val.nclass=[mean(dv_val_negative(:)) std(dv_val_negative(:)) kurtosis(dv_val_negative(:))];
    cs(sp).val.dvp=dv_out_positive;
    cs(sp).val.dvn=dv_out_negative;
%     if (std(dv_val_positive)>std(dv_val_negative))
%         dv_out_positive(dv_out_positive>0)= dv_out_positive(dv_out_positive>0)*std(dv_val_negative)/std(dv_val_positive) ;
%         dv_out_negative(dv_out_negative>0)= dv_out_negative(dv_out_negative>0)*std(dv_val_negative)/std(dv_val_positive) ;
%     end
    W=1.5;
    wdv_out_positive=dv_out_positive;
    wdv_out_negative=dv_out_negative;
    wdv_out_positive(wdv_out_positive<0)=W*wdv_out_positive(wdv_out_positive<0);
    wdv_out_negative(wdv_out_negative<0)=W*wdv_out_negative(wdv_out_negative<0);
    
    if (~isempty(dv_out))
        for tr_per_seq=[1 2 3 4 5 6 7 8 9]
            
            clear wsav_dv_out_positive wsav_dv_out_negative sav_dv_out_positive sav_dv_out_negative pro_dv_out_negative pro_dv_out_positive sav_dv_val_positive sav_dv_val_negative A B sig_dv_out_positive sig_dv_out_negative
            
            for j=1:numel(bias_mod)
                
                for i=1:columns_out_positive
                    
                    sav_dv_out_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out_positive( : , i ) + bias_mod(j) ) ;
                    %wav_dv_out_positive( : , i ) = filter( w{tr_per_seq}(1:tr_per_seq) , 1 , dv_out_positive( : , i ) + bias_mod(j) + w{tr_per_seq}(tr_per_seq+1) ) ;
                    wav_dv_out_positive( : , i ) = filter( w{tr_per_seq}(1:tr_per_seq) , 1 , dv_out_positive( : , i ) + bias_mod(j) ) ;
                    pro_dv_out_positive( : , i ) = vec_elements_product( dv_out_positive( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                    sig_dv_out_positive( : , i ) = sigm_comb( dv_out_positive( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                    wsav_dv_out_positive( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ), 1 , wdv_out_positive(:,i) + bias_mod(j) ) ;
                    
                end
                for i=1:columns_out_negative
                    
                    sav_dv_out_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ) , 1 , dv_out_negative( : , i ) + bias_mod( j ) ) ;
                    %wav_dv_out_negative( : , i ) = filter( w{tr_per_seq}(1:tr_per_seq) , 1 , dv_out_negative( : , i ) + bias_mod(j) + w{tr_per_seq}(tr_per_seq+1) ) ;
                    wav_dv_out_negative( : , i ) = filter( w{tr_per_seq}(1:tr_per_seq) , 1 , dv_out_negative( : , i ) + bias_mod(j) ) ;
                    pro_dv_out_negative( : , i ) = vec_elements_product( dv_out_negative( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                    sig_dv_out_negative( : , i ) = sigm_comb( dv_out_negative( : , i ) + bias_mod(j) , tr_per_seq  ) ;
                    wsav_dv_out_negative( : , i ) = filter( 1 / tr_per_seq*ones( 1 , tr_per_seq ), 1 , wdv_out_negative( : , i ) + bias_mod( j )  ) ;
                end
                
                fpr.vanilla = sum( dv_out_negative( : ) > 0 ) / numel( dv_out_negative( : ) ) ;
                tpr.vanilla = sum( dv_out_positive( : ) > 0 ) / numel( dv_out_positive( : ) ) ;
                
                fpr.pro( tr_per_seq , j) = sum( pro_dv_out_negative( : ) > 0 ) / numel( pro_dv_out_negative( : ) ) ;
                tpr.pro( tr_per_seq , j) = sum( pro_dv_out_positive( : ) > 0 ) / numel( pro_dv_out_positive( : ) ) ;
                
                fpr.sig( tr_per_seq , j) = sum( sig_dv_out_negative( : ) > 0 ) / numel( sig_dv_out_negative( : ) ) ;
                tpr.sig( tr_per_seq , j) = sum( sig_dv_out_positive( : ) > 0 ) / numel( sig_dv_out_positive( : ) ) ;
                
                temp1 = sav_dv_out_negative( tr_per_seq : end , : ) ;
                temp2 = sav_dv_out_positive( tr_per_seq : end , : ) ;
                fpr.sav( tr_per_seq , j) = sum( temp1( : ) > 0 ) / numel( temp1( : ) ) ;
                tpr.sav( tr_per_seq , j) = sum( temp2( : ) > 0 ) / numel( temp2( : ) ) ;
                temp3 = wav_dv_out_negative( tr_per_seq : end , : ) ;
                temp4 = wav_dv_out_positive( tr_per_seq : end , : ) ;
                fpr.wav( tr_per_seq , j) = sum( temp3( : ) > 0 ) / numel( temp3( : ) ) ;
                tpr.wav( tr_per_seq , j) = sum( temp4( : ) > 0 ) / numel( temp4( : ) ) ;
                temp5 = wsav_dv_out_negative( tr_per_seq : end , : ) ;
                temp6 = wsav_dv_out_positive( tr_per_seq : end , : ) ;
                fpr.wsav( tr_per_seq , j) = sum( temp5( : ) > 0 ) / numel( temp5( : ) ) ;
                tpr.wsav( tr_per_seq , j) = sum( temp6( : ) > 0 ) / numel( temp6( : ) ) ;
            end
        end
        
        cs(sp).out.fpr = fpr ;
        cs(sp).out.tpr = tpr ;
        cs(sp).out.tstauc = res.tstauc(:,:,res.opt.Ci);
        cs(sp).out.pclass=[mean(dv_out_positive(:)) std(dv_out_positive(:)) kurtosis(dv_out_positive(:))];
        cs(sp).out.nclass=[mean(dv_out_negative(:)) std(dv_out_negative(:)) kurtosis(dv_out_negative(:))];
        cs(sp).out.dvp=dv_out_positive;
        cs(sp).out.dvn=dv_out_negative;
        
        
    end
    
    
    
    
end


end