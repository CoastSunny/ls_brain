
Cbmci=[2:6 8:10 12:15 18:19];
Csmci=Cbmci+19;
Pbmci=[39:51];
Psmci=[52:64];
llmci=[ 12  37 62 87 112];
kkmci={'cen' 'back' 'right' 'front' 'left'};
O1=[1 2 3 32+1 32+3 32+20 64+1 64+2 64+23 96+1 96+15 96+2 96+14 96+15 96+16];
O2=setdiff(1:32,O1);O3=setdiff(33:64,O1);O4=setdiff(65:96,O1);O5=setdiff(97:128,O1);
idcs=[O1 O2 O3 O4 O5];

Cbfad=[1:10];
Csfad=[11:20];
Pbfad=[21:30];
Psfad=[31:40];
llfad=[10 30 50];
kkfad={'front' 'central' 'back'};
fadperm=[41:60 21:40 1:20];
kkfad={ 'back' 'central' 'front' };
cc='auto'; 
ccmci=[0 1];
ccfad=[0 1];
figure,
subplot(2,4,1),imagesc(squeeze(mean(CxAmci(idcs,idcs,Pbmci),3))),title('Patient'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,5),imagesc(squeeze(mean(CxAmci(idcs,idcs,Psmci),3))),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,2),imagesc(squeeze(mean(CxAmci(idcs,idcs,Cbmci),3))),title('Control'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,6),imagesc(squeeze(mean(CxAmci(idcs,idcs,Csmci),3))),%title('Control shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,3),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Pbfad),3))),title('Patient'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,7),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Psfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,4),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Cbfad),3))),title('Control'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,8),imagesc(squeeze(mean(CxAfad(fadperm,fadperm,Csfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)

ccmci=[0 1];
ccfad=[0 1];
figure,
subplot(2,4,1),imagesc(squeeze(mean(CxBmci(idcs,idcs,Pbmci),3))),title('Patient'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,5),imagesc(squeeze(mean(CxBmci(idcs,idcs,Psmci),3))),%title('MCI shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,2),imagesc(squeeze(mean(CxBmci(idcs,idcs,Cbmci),3))),title('Control'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,6),imagesc(squeeze(mean(CxBmci(idcs,idcs,Csmci),3))),%title('Control shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,3),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Pbfad),3))),title('Patient'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,7),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Psfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,4),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Cbfad),3))),title('Control'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,8),imagesc(squeeze(mean(CxBfad(fadperm,fadperm,Csfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)

ccmci=[0 1];
ccfad=[0 1];
figure,
subplot(2,4,1),imagesc(squeeze(mean(CxDmci(idcs,idcs,Pbmci),3))),title('Patient'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,5),imagesc(squeeze(mean(CxDmci(idcs,idcs,Psmci),3))),%title('MCI shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,2),imagesc(squeeze(mean(CxDmci(idcs,idcs,Cbmci),3))),title('Control'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,6),imagesc(squeeze(mean(CxDmci(idcs,idcs,Csmci),3))),%title('Control shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,3),imagesc(squeeze(mean(CxDfad(fadperm,fadperm,Pbfad),3))),title('Patient'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,7),imagesc(squeeze(mean(CxDfad(fadperm,fadperm,Psfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,4),imagesc(squeeze(mean(CxDfad(fadperm,fadperm,Cbfad),3))),title('Control'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,8),imagesc(squeeze(mean(CxDfad(fadperm,fadperm,Csfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)

ccmci=[.17 0.18];
ccfad=[.17 0.22];
figure,
subplot(2,4,1),imagesc(squeeze(mean(CpBmci(idcs,idcs,Pbmci),3))),title('Patient'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,5),imagesc(squeeze(mean(CpBmci(idcs,idcs,Psmci),3))),%title('MCI shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,2),imagesc(squeeze(mean(CpBmci(idcs,idcs,Cbmci),3))),title('Control'),
caxis(ccmci)
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,6),imagesc(squeeze(mean(CpBmci(idcs,idcs,Csmci),3))),%title('Control shape'),
caxis(ccmci),
set(gca,'Xtick',llmci),set(gca,'Xticklabels',kkmci),set(gca,'Ytick',llmci),set(gca,'Yticklabels',kkmci)
subplot(2,4,3),imagesc(squeeze(mean(CpBfad(fadperm,fadperm,Pbfad),3))),title('Patient'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,7),imagesc(squeeze(mean(CpBfad(fadperm,fadperm,Psfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,4),imagesc(squeeze(mean(CpBfad(fadperm,fadperm,Cbfad),3))),title('Control'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
subplot(2,4,8),imagesc(squeeze(mean(CpBfad(fadperm,fadperm,Csfad),3))),%title('MCI-FAD shape'),
caxis(ccfad),
set(gca,'Xtick',llfad),set(gca,'Xticklabels',kkfad),set(gca,'Ytick',llfad),set(gca,'Yticklabels',kkfad)
