band=[];
Cpli=[];Cx=[];
for i=1:numel(Fp)
    out=tensor_connectivity(Fp,i,3);
    Cx(:,:,i)=topoconn_av(Fp,out,i,[],freq,band,0,0);  
    Cpli(:,:,i)=ls_pli(Ys{i},band,0);
end
Cb=1:19;
Cs=20:38;
Pb=39:51;
Ps=52:64;
Cb=1:10;
Cs=11:20;
Pb=21:30;
Ps=31:40;
cc='auto';
ll=[16 48 80 112];
ll=[10 30 50];
kk={'back' 'right' 'front' 'left'};
kk={'front' 'central' 'back'};
figure,
subplot(2,2,1),imagesc(squeeze(mean(Cx(:,:,Cb),3))),title('C-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,2),imagesc(squeeze(mean(Cx(:,:,Cs),3))),title('C-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,3),imagesc(squeeze(mean(Cx(:,:,Pb),3))),title('P-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,4),imagesc(squeeze(mean(Cx(:,:,Ps),3))),title('P-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),

figure,
subplot(2,2,1),imagesc(squeeze(mean(Cpli(:,:,Cb),3))),title('C-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,2),imagesc(squeeze(mean(Cpli(:,:,Cs),3))),title('C-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,3),imagesc(squeeze(mean(Cpli(:,:,Pb),3))),title('P-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,4),imagesc(squeeze(mean(Cpli(:,:,Ps),3))),title('P-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
