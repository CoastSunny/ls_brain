
Cbmci=[1:19];
Csmci=[20:38];
Pbmci=[39:51];
Psmci=[52:64];
llmci=[16 48 80 112];
kkmci={'back' 'right' 'front' 'left'};

Cbfad=[1:10];
Csfad=[11:20];
Pbfad=[21:30];
Psfad=[31:40];
llfad=[10 30 50];
kkfad={'front' 'central' 'back'};
fadperm=[41:60 21:40 1:20];
kkfad={ 'back' 'central' 'front' };
cc='auto'; 
ccmci=[0 60];
ccfad=[0 60];
figure,
subplot(2,4,1),imagesc(squeeze(mean(CxAmci(:,:,Pbmci),3))),%title('MCI binding'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,5),imagesc(squeeze(mean(CxAmci(:,:,Psmci),3))),%title('MCI shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,2),imagesc(squeeze(mean(CxAmci(:,:,Cbmci),3))),%title('Control binding'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,6),imagesc(squeeze(mean(CxAmci(:,:,Csmci),3))),%title('Control shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,3),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Pbfad),3))),%title('MCI-FAD binding'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,7),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Psfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,4),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Cbfad),3))),%title('MCI-FAD binding'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,8),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Csfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)

figure,
subplot(2,4,1),imagesc(squeeze(mean(CxBmci(:,:,Pbmci),3))),%title('MCI binding'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,5),imagesc(squeeze(mean(CxBmci(:,:,Psmci),3))),%title('MCI shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,2),imagesc(squeeze(mean(CxBmci(:,:,Cbmci),3))),%title('Control binding'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,6),imagesc(squeeze(mean(CxBmci(:,:,Csmci),3))),%title('Control shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,3),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Pbfad),3))),%title('MCI-FAD binding'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,7),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Psfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,4),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Cbfad),3))),%title('MCI-FAD binding'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,8),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Csfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)