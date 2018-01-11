function distance = distance_EMterrano(Target_Pos,Out_Table)

    
    pos_idxs=[3 4 5];
    [tmp rows]=unique(Out_Table(:,2));
    for i=1:numel(rows)
        
        distance(i)=norm(Out_Table(rows(i),pos_idxs)'-Target_Pos);    
        
    end

end