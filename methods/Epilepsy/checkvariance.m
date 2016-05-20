StdevSpike=[];
StdevRest=[];
for ci=1:numel(subj)
    
    eval(['sEEG=' subj{ci} '_sEEG;']);
    eval(['rsEEG=' subj{ci} '_rsEEG;']);
    eval(['fsEEG=' subj{ci} '_fsEEG;']);
    eval(['frsEEG=' subj{ci} '_frsEEG;']);    
    eval(['cEEG=' subj{ci} '_cEEG;']);
    eval(['rcEEG=' subj{ci} '_rcEEG;']);
   
    eval(['iEEG=' subj{ci} '_iEEG;']);
    eval(['riEEG=' subj{ci} '_riEEG;']);
    eval(['fiEEG=' subj{ci} '_fiEEG;']);
    eval(['friEEG=' subj{ci} '_friEEG;']);   
    X=sEEG;
    Y=rsEEG;
for i=1:size(X,1)
    for j=25:35
        StdevSpike(i,j)=var(X(i,j,:));
        StdevRest(i,j)=var(Y(i,j,:));
    end
end
vv(ci,:)=[sum(sum(StdevSpike)) sum(sum(StdevRest))];
end

