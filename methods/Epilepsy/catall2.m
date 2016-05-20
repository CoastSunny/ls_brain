x=[];fx=[];rx=[];frx=[];
xi=[];fxi=[];rxi=[];frxi=[];
Xs=[];Xi=[];rXs=[];rXi=[];
time=1:65;freq=1:size(fiEEG,2);

eval(['size(' subj{si} '_iEEG,3)']);
eval(['x=cat(3,x,' subj{si} '_sEEG(:,time,:));']);
eval(['rx=cat(3,rx,' subj{si} '_rsEEG(:,time,:));']);
eval(['fx=cat(4,fx,' subj{si} '_fsEEG(:,freq,:,:));']);
eval(['frx=cat(4,frx,' subj{si} '_frsEEG(:,freq,:,:));']);

eval(['xi=cat(3,xi,' subj{si} '_iEEG(:,time,:));']);
eval(['rxi=cat(3,rxi,' subj{si} '_riEEG(:,time,:));']);
eval(['fxi=cat(4,fxi,' subj{si} '_fiEEG(:,freq,:,:));']);
eval(['frxi=cat(4,frxi,' subj{si} '_friEEG(:,freq,:,:));']);


Xs=reshape(permute(x,[2 1 3]),[],size(x,3));Xs=normc(Xs);
Xi=reshape(permute(xi,[2 1 3]),[],size(x,3));Xi=normc(Xi);
rXs=reshape(permute(rx,[2 1 3]),[],size(rx,3));rXs=normc(rXs);
rXi=reshape(permute(rxi,[2 1 3]),[],size(rx,3));rXi=normc(rXi);

fXs=reshape(mean(fx,3),[],size(fx,4));%fXs=normc(fXs);
fXi=reshape(mean(fxi,3),[],size(fx,4));%fXi=normc(fXi);
frXs=reshape(mean(frx,3),[],size(frx,4));%frXs=normc(frXs);
frXi=reshape(mean(frxi,3),[],size(frx,4));%frXi=normc(frXi);

% fXs=reshape(fx,[],size(fx,4));%fXs=normc(fXs);
% fXi=reshape(fxi,[],size(fx,4));%fXi=normc(fXi);
% frXs=reshape(frx,[],size(frx,4));%frXs=normc(frXs);
% frXi=reshape(frxi,[],size(frx,4));%frXi=normc(frXi);





