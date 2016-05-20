function out = letter2cell(letter,CODE)

    for i=1:size(CODE,2)
    
        tmp=strmatch(letter,CODE{i});
        if (~isempty(tmp))
            out=tmp;
            
            return
        end
        
    end

end