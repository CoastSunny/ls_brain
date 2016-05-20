
for i=1:numel(subj)
    
    eval([subj{ci} '_sERP=mean(' subj{ci} '_sEEG,3);']);
    eval(['X=' subj{ci} '_sERP;']);
    
    for ch=1:size(X,1)
    
        
        
    end

end