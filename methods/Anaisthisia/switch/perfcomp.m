function out = perfcomp(dm,foldtype,method,move_duration)
   
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
            
            res(sp,si,ci)=(dm{si}(sp).(foldtype).tpr.(method)(move_duration,idx_noncal,ci)+...
                (1-dm{si}(sp).(foldtype).fpr.(method)(move_duration,idx_noncal,ci)))/2;
            
            
        end
        res(sp,numel(dm)+1,ci)=nanmean(res(sp,1:numel(dm),ci));
        
        
    end
    
    out.res=res;
    out.n_comb_tr=move_duration;
    
end

end
