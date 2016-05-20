function out = letter2row(letter,CODE)

    for i=1:size(CODE,2)
    
        tmp=strmatch(letter,CODE{i});
        if (~isempty(tmp))
            out=i;
            
            return
        end
        
    end

end