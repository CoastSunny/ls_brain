function out = calperf(cs,foldtype,method)

for ci=1:size(cs{1}(1).(foldtype).fpr.(method),3)

for j=1:numel(cs{1})
    
    for i=1:numel(cs)
        
        FPR{j}(:,:,i)=cs{i}(j).(foldtype).fpr.(method)(:,:,ci);
        TPR{j}(:,:,i)=cs{i}(j).(foldtype).tpr.(method)(:,:,ci);
        
    end
    
end

for j=1:numel(cs{1})
    meanFPR{j}=nanmean(FPR{j},3);
    meanTPR{j}=nanmean(TPR{j},3);
    [maxFPR{j} fmidx{j}]=max(FPR{j},[],3);
    [minTPR{j} tmidx{j}]=min(TPR{j},[],3);
    out.FPR{j}=meanFPR{j};
    out.TPR{j}=meanTPR{j};
    [out.maxFPR{j}]=maxFPR{j};
    [out.minTPR{j}]=minTPR{j};
    
end
f=@(x,t)(x.*(sum(t.*(1-x).^t)));
t=1:200;
fpr_range=0:0.2:25;
for j=1:numel(cs{1})
    rows=size(FPR{j},1);
    cols=size(FPR{j},2);
    for fpr=1:numel(fpr_range)
        
        temp=fpr_range(fpr)/100;
        [row col]=find(meanFPR{j}<=temp);
        [row2 col2]=find(maxFPR{j}<=temp);
        for i=1:rows
            row_idx=find(row==i);
            col_idx=col(row_idx);
            if (~isempty(col_idx))
                tpr(fpr,i)=meanTPR{j}(i,col_idx(end));
                bias(fpr,i)=col_idx(end);
            else
                tpr(fpr,i)=NaN;
                bias(fpr,i)=NaN;
            end
            
            %             row2_idx=find(row2==i);
            %             col2_idx=col2(row2_idx);
            %             tpr2(fpr,i)=TPR{j}(i,col2_idx(1),fmidx{j}(i,col2_idx(1)));
            %             bias2(fpr,i)=col2_idx(1);
        end
        
    end
    
    out.tpr{j}{ci}=tpr;
    % out.tpr2{j}=tpr2;
    
    for r=1:25
        for c=1:rows
            out.delay{j}(r,c)=f(tpr(r,c),t);
            % out.delay2{j}(r,c)=f(tpr2(r,c),t);
        end
    end
    out.bias{j}{ci}=bias;
    % out.bias2{j}=bias2;
end

for si=1:numel(cs)
    for j=1:numel(cs{1})
        rows=size(FPR{j},1);
        cols=size(FPR{j},2);
        for fpr=1:numel(fpr_range)
            
            temp=fpr_range(fpr)/100;
            [row col]=find(FPR{j}(:,:,si)<=temp);
            
            for i=1:rows
                row_idx=find(row==i);
                col_idx=col(row_idx);
                if (~isempty(col_idx))
                    tpr(fpr,i)=TPR{j}(i,col_idx(end),si);
                    bias(fpr,i)=col_idx(end);
                else
                    tpr(fpr,i)=NaN;
                    bias(fpr,i)=NaN;
                end
                
                
                
            end
            
        end
        
        out.indi_tpr{si}{j}{ci}=tpr;
        out.indi_bias{si}{j}{ci}=bias;
        
        
    end
end

out.fpr_range=fpr_range;

end

end