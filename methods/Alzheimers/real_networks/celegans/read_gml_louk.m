function W = read_gml_louk(filename)
% READ_GML returns hierarchical datastructure of information in % .gml file.

    nodes=297;
    W=zeros(nodes);
    
    content = fileread(filename);
    content = strrep(content, sprintf('\n'), ''); 
    
    %for consistent input
    content = strrep(content, '[', ' [ ');
    content = strrep(content, ']', ' ] ');
    
    %remove multiple whitespaces in the content:
    loop = 1; 
    i = 1;
    
    while loop
        
        i = i + 1;
        
        if size(strfind(content, repmat(' ', 1, i)), 2) == 0
            
            loop = 0;
            
        end
        
    end
    
    for ii = 1:(i-2)
        
        content = strrep(content, '  ', ' ');
        
    end
    
    content = regexp(content, ' ', 'split');
    
    idx = strmatch('edge',content);
    
    for i=1:2:numel(idx)
        
        W(str2num(content{idx(i)+3})+1,str2num(content{idx(i)+5})+1)=str2num(content{idx(i)+7});
        
    end
    
    W=W+W.';
    W=weight_conversion(W,'normalize');
    
end