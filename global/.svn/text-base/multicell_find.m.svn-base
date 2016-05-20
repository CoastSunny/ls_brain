function idx = multicell_find(name,cell,pos)
    
    
    idx=0;

    for i=1:length(cell)
            
        if (isempty(pos)) flag = strmatch(name,cell{i});
        else              flag = strmatch(name,cell{i}(pos));
        end

        if (flag==1)
            idx=i;
            return;
        end

    end


end
    
