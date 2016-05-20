function out = finalperf(dm,foldtype,method,move_duration,fpr_target)

res=[];
for ci=1:size(dm{1}(1).(foldtype).tpr.(method),3)
    
    bias=dm{1}(1).out.bias;
    idx_noncal=ceil(numel(bias)/2);
    if (strcmp(move_duration,'all'))
        move_duration=size(dm{1}(1).(foldtype).fpr.(method),1);
    elseif (strcmp(move_duration,'half'))
        move_duration=size(dm{1}(1).(foldtype).(method),1)/2;
    end
    
    for sp=1:numel(dm{1})
        
        
        for si=1:numel(dm)
            
            fpr=dm{si}(sp).(foldtype).fpr.(method)(move_duration,:,ci);
            tpr=dm{si}(sp).(foldtype).tpr.(method)(move_duration,:,ci);
            [row col]=find(fpr<=fpr_target);
            
            if (~isempty(col))
                res(sp,si,ci).fpr=fpr(col(end));
                res(sp,si,ci).tpr=tpr(col(end));
                res(sp,si,ci).bias=dm{si}(sp).(foldtype).bias(col(end));
            else
               error('no fpr found');
            end
            
            
            
            
        end
        
        res(sp,numel(dm)+1,ci).fpr=nanmean([res(sp,1:numel(dm),ci).fpr]);
        res(sp,numel(dm)+1,ci).tpr=nanmean([res(sp,1:numel(dm),ci).tpr]);
        
        
    end
    
    out.res=res;
    out.n_comb_tr=move_duration;
    
end

end