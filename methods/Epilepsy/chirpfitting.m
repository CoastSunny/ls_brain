
for ci=1:numel(subj)
    
    eval([subj{ci} '_sERP=mean(' subj{ci} '_sEEG,3);']);
    eval(['X=' subj{ci} '_sERP;']);
    
    for ch=1:size(X,1)
    
        p=find_chirplets(X(ch,:),1,2,64,0);
        chirp_param(:,:,ch)=real(p);
        cEEG(ch,:)=real(chirplets(64,p));
        
    end

    eval([subj{ci} '_cERP=cEEG;']);
    
end