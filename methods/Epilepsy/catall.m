time=1:65;
%figure(1),hold on
for si=Itest
    
    eval(['size(' subj{si} '_iEEG,3)']);
    eval(['x=cat(3,x,' subj{si} '_sEEG(:,time,:));']);
    eval(['rx=cat(3,rx,' subj{si} '_rsEEG(:,time,:));']);
    eval(['fx=cat(4,fx,' subj{si} '_fsEEG(:,:,:,:));']);
    eval(['frx=cat(4,frx,' subj{si} '_frsEEG(:,:,:,:));']);

    eval(['xi=cat(3,xi,' subj{si} '_iEEG(:,time,:));']);
    eval(['rxi=cat(3,rxi,' subj{si} '_riEEG(:,time,:));']);
    eval(['fxi=cat(4,fxi,' subj{si} '_fiEEG(:,:,:,:));']);
    eval(['frxi=cat(4,frxi,' subj{si} '_friEEG(:,:,:,:));']);

%   eval(['yt(si,:)=mean(mean(' subj{si} '_iEEG(:,:,:),3),1);']);
%   eval(['ys(si,:)=mean(mean(' subj{si} '_iEEG(:,:,:),3),2);']);
    %eval(['x=cat(3,x,mean(' subj{si} '_iEEG,3));']);

end
% figure,plot(yt')
% figure,plot(ys')

% for ii=1:size(x,3)
% 
%     [u s v]=svd(x(:,:,ii));
%     Xs(:,ii)=v(15:end-14,1)/norm(v(15:end-14,1));
%     [u s v]=svd(xi(:,:,ii));
%     Xi(:,ii)=v(15:end-14,1)/norm(v(15:end-14,1));        
% 
% end
% for ii=1:size(rx,3)
% 
%     [u s v]=svd(rx(:,:,ii));
%     rXs(:,ii)=v(15:end-14,1)/norm(v(15:end-14,1)); 
%     [u s v]=svd(rxi(:,:,ii));
%     rXi(:,ii)=v(15:end-14,1)/norm(v(15:end-14,1));     
% 
% end
% Xs=Xs-ones(size(Xs))*diag(mean(Xs,1));
% Xi=Xi-ones(size(Xi))*diag(mean(Xi,1));
Xs=reshape(permute(x,[2 1 3]),[],size(x,3));Xs=normc(Xs);
Xi=reshape(permute(xi,[2 1 3]),[],size(x,3));Xi=normc(Xi);
rXs=reshape(permute(rx,[2 1 3]),[],size(rx,3));rXs=normc(rXs);
rXi=reshape(permute(rxi,[2 1 3]),[],size(rx,3));rXi=normc(rXi);

fXs=reshape(fx,[],size(fx,4));fXs=normc(fXs);
fXi=reshape(fxi,[],size(fx,4));fXi=normc(fXi);
frXs=reshape(frx,[],size(frx,4));frXs=normc(frXs);
frXi=reshape(frx,[],size(frx,4));frXi=normc(frXi);





