data=[];

for ci=1:numel(subj)

    eval(['temp1=' subj{ci} '_iEEG;'])
    eval(['temp2=' subj{ci} '_riEEG;'])
    temp1=reshape(permute(temp1,[2 1 3]),[],size(temp1,3));
    temp2=reshape(permute(temp2,[2 1 3]),[],size(temp2,3));
    data(ci).X=cat(2,temp1,temp2);
    data(ci).Y=[ones(size(temp1,2),1) ;-ones(size(temp1,2),1)];

end