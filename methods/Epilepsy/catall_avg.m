time=1:65;
%figure(1),hold on
for si=Itest
    
    eval(['size(' subj{si} '_iEEG,3);']);
    eval(['x=cat(3,x,' subj{si} '_sEEG(:,time,:));']);
    eval(['rx=cat(3,rx,' subj{si} '_rsEEG(:,time,:));']);
    eval(['fxA{si}=' subj{si} '_fsEEG(:,:,:,:);']);
    eval(['frxA{si}=' subj{si} '_frsEEG(:,:,:,:);']);

    eval(['xi=cat(3,xi,' subj{si} '_iEEG(:,time,:));']);
    eval(['rxi=cat(3,rxi,' subj{si} '_riEEG(:,time,:));']);
    eval(['fxiA{si}=' subj{si} '_fiEEG(:,:,:,:);']);
    eval(['frxiA{si}=' subj{si} '_friEEG(:,:,:,:);']);

    eval(['mxA(:,:,:,si)=mean(' subj{si} '_fsEEG(:,:,:,:),4);']);
    eval(['mrxA(:,:,:,si)=mean(' subj{si} '_frsEEG(:,:,:,:),4);']);
end






