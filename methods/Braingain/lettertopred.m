function pred = lettertopred(letter,code)

for i=1:numel(code)

    if (~isempty(strmatch(letter,code{i})))
        pred =[i strmatch(letter,code{i})];
        return
    end
    
end

end