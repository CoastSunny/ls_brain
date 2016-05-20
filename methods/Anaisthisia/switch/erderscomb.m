function [dm] = erderscomb ( zerd, zers ,n_con_ex, positive_class, outerfold, method, fullclsfr,refractory_segments)

erd = zerd.prep(end).info.res;
ers = zers.prep(end).info.res;
Yall_erd=zerd.Y;
Yall_ers=zers.Y;
outfIdxs_erd=zerd.outfIdxs;
outfIdxs_ers=zers.outfIdxs;
pc=positive_class;

if (outerfold==1)
    foldtype='out';
else
    foldtype='val';
end

for sp=1:size(Yall_erd,2)^2
    
    if (sp<=size(Yall_erd,2))
        spdv=sp;
        spY=sp;
    else
        spdv=mod(sp+1,size(Yall_erd,2))+1;
        spY=mod(sp,size(Yall_erd,2))+1;
    end
    Y_erd=Yall_erd(:,spY);
    Y_ers=Yall_ers(:,spY);
    Ci_erd=erd.opt.Ci;
    Ci_ers=ers.opt.Ci;
    if (fullclsfr==1)
        dv_all_erd  =  erd.opt.f( : , spdv ) ; %-res.roc.bias_change;
        dv_all_ers  =  ers.opt.f( : , spdv ) ; %-res.roc.bias_change;
    else
        dv_all_erd  =  erd.tstf( : , spdv , Ci_erd ) ; %-res.roc.bias_change;
        dv_all_ers  =  ers.tstf( : , spdv , Ci_ers ) ; %-res.roc.bias_change;
    end
    
    
    dv_erd = dv_all_erd( outfIdxs_erd == 1 * outerfold & Y_erd ~= 0 ) ;
    dv_erd = dv_erd*pc;
    
    dv_ers = dv_all_ers( outfIdxs_ers == 1 * outerfold & Y_ers ~= 0 ) ;
    dv_ers = dv_ers*pc;
    
    Y = Y_erd( outfIdxs_erd ==  1 * outerfold & Y_erd ~= 0 ) ;
    
    i_nclass    =  Y ==  -1*pc ;
    i_pclass    =  Y == pc ;
    
    Y_nclass     =  Y( i_nclass ) ;
    Y_pclass     =  Y( i_pclass ) ;
    
    %     dv_positive_erd  =  dv_erd( i_pclass );
    %     dv_negative_erd  =  dv_erd( i_nclass );
    
    
    % bias_mod=[0 -1 -2 -5];
    bias_mod=[-2*pc:0.01*pc:2*pc];
    
    if (strcmp(method,'asynch_dec_sav'))
        
        anycellfn = @(x) any(x>0);
        
        if (strcmp(n_con_ex,'all'))
            
            n_con_ex=numel(dv);
            columns=1;
            
        else
            
            columns = numel( dv ) / n_con_ex ;
            dv = reshape( dv , n_con_ex , columns) ;
            i_nclass = reshape( i_nclass, n_con_ex, columns );
            i_pclass = reshape( i_pclass, n_con_ex, columns );
            
        end
        
        for dwell_segments=1:5
            
            for move_duration=1:10
                
                clear move_dv_pclass move_dv_nclass
                
                for j=1:numel(bias_mod)
                    
                    for i=1:columns
                        
                        dv_trial = filter( ones( 1 , dwell_segments ) , 1 , dv( : , i ) )';
                        %dv_trial = dv;
                        
                        temp_pclass = dv_trial(i_pclass(:,i)) ;
                        temp_nclass = dv_trial(i_nclass(:,i)) ;
                        
                        if (move_duration<=numel(temp_pclass))
                            move_dv_pclass{i} = temp_pclass(1:move_duration) + bias_mod(j);
                        else
                            move_dv_pclass{i} = NaN ;
                        end
                        
                        if (move_duration<=numel(temp_nclass))
                            move_dv_nclass{i} = temp_nclass + bias_mod(j);
                        else
                            move_dv_nclass{i} = NaN ;
                        end
                        
                        
                    end
                    
                    dv_neg_full = cat( 2 , move_dv_nclass{:} );
                    
                    nan_pos_trials=cellfun(@isnan,move_dv_pclass,'UniformOutput',0);
                    move_dv_pclass(cellfun(@(x) any(x>0),nan_pos_trials))=[];
                    
                    fpr.dec( move_duration , j , dwell_segments) = sum( dv_neg_full(:) > 0 ) / numel( dv_neg_full(:) ) ;
                    tpr.dec( move_duration , j , dwell_segments) = sum( cellfun( anycellfn , move_dv_pclass )) / numel( move_dv_pclass );
                    
                end
                
            end
            
        end
        
    elseif (strcmp(method,'asynch_dec_nrow'))
        
        anycellfn = @(x) any(x>0);
        
        if (strcmp(n_con_ex,'all'))
            
            n_con_ex=numel(dv_erd);
            columns=1;
            
        else
            
            columns = numel( dv_erd ) / n_con_ex ;
            dv_erd = reshape( dv_erd , n_con_ex , columns) ;
            dv_ers = reshape( dv_ers , n_con_ex , columns) ;
            i_nclass = reshape( i_nclass, n_con_ex, columns );
            i_pclass = reshape( i_pclass, n_con_ex, columns );
            
        end
        
        for dwell_segments=1:5
            
            for move_duration=1:10
                
                clear move_dv_pclass move_dv_nclass
                
                for j=1:numel(bias_mod)
                    
                    for i=1:columns
                        
                        pos_segments=find(i_pclass(:,i)==1);
                        neg_segments=find(i_nclass(:,i)==1);
                        
                        
                        dv_trial_erd=dv_erd(:,i);
                        dv_trial_ers=dv_ers(:,i);
                        %% 1
                        if ( move_duration < numel( pos_segments ) )
                            keep_pos_segments=pos_segments(1:move_duration);
                            dv_trial_erd( pos_segments( move_duration+1:end ) )=[];
                            dv_trial_ers( pos_segments( move_duration+1:end ) )=[];
                            
                            detections = find( dv_trial_erd + bias_mod(j) > 0 );
                            
                            for di=1:numel(detections)
                                if (detections(di)<=numel(dv_trial_erd)-4)
                                    if (isempty(intersect(detections(di),keep_pos_segments)))
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(detections(di)+1:detections(di)+3));
                                    else
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(pos_segments(end)+1:pos_segments+3));
                                    end
                                else
                                    if (isempty(intersect(detections(di),keep_pos_segments)))
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(detections(di)+1:end));
                                    else
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(pos_segments(end)+1:end));
                                    end
                                end
                                
                            end
                            %% 1
                        elseif (move_duration==numel(pos_segments))
                            keep_pos_segments=pos_segments(1:move_duration);
                            detections = find( dv_trial_erd > 0 );
                            
                            for di=1:numel(detections)
                                if (detections(di)<=numel(dv_trial_erd)-4)
                                    if (isempty(intersect(detections(di),keep_pos_segments)))
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(detections(di)+1:detections(di)+3));
                                    else
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(pos_segments(end)+1:pos_segments+3));
                                    end
                                else
                                    if (isempty(intersect(detections(di),keep_pos_segments)))
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(detections(di)+1:end));
                                    else
                                        dv_trial_erd(detections(di))=dv_trial_erd(detections(di))+...
                                            sum(dv_trial_ers(pos_segments(end)+1:end));
                                    end
                                end
                                
                            end
                        elseif (move_duration>numel(pos_segments))
                            
                            move_dv_pclass{i} = NaN ;
                            
                        end
                        
                        dv_trial_erd = vec_elements_product( dv_trial_erd + bias_mod(j) , dwell_segments );
                        detections = find(dv_trial_erd==1);
                        while ~isempty(detections)
                            dv_trial_erd(detections(1))=2;
                            if (detections(1)<n_con_ex-2)
                                dv_trial_erd(detections(1)+1:detections(1)+refractory_segments)=-1;
                            end
                            detections=find(dv_trial_erd==1);
                        end
                        dv_trial_erd(dv_trial_erd==2)=1;
                        
                        temp_pclass_erd = dv_trial_erd(keep_pos_segments) ;
                        temp_nclass_erd = dv_trial_erd(setdiff(1:numel(dv_trial_erd),keep_pos_segments) );
                        %                         if (sp==2 & j==51)
                        %                             keyboard
                        %                         end
                        if (move_duration<=numel(temp_pclass_erd))
                            move_dv_pclass{i} = temp_pclass_erd(1:move_duration);
                        else
                            move_dv_pclass{i} = NaN ;
                        end
                        
                        if (move_duration<=numel(temp_nclass_erd))
                            move_dv_nclass{i} = temp_nclass_erd;
                        else
                            move_dv_nclass{i} = NaN ;
                        end
                        
                        
                    end
                    
                    dv_neg_full = cat( 2 , move_dv_nclass{:} );
                    
                    nan_pos_trials=cellfun(@isnan,move_dv_pclass,'UniformOutput',0);
                    move_dv_pclass(cellfun(anycellfn,nan_pos_trials))=[];
                    
                    fpr.dec( move_duration , j , dwell_segments) = sum( dv_neg_full(:) > 0 ) / numel( dv_neg_full(:) ) ;
                    tpr.dec( move_duration , j , dwell_segments) = sum( cellfun( anycellfn , move_dv_pclass )) / numel( move_dv_pclass );
                    
                end
                
            end
            
        end
     
    end
    
    dm(sp).(foldtype).fpr = fpr ;
    dm(sp).(foldtype).tpr = tpr ;
    dm(sp).(foldtype).bias=bias_mod;
    clear fpr tpr
end

end