band=[];
Cpli=[];Cx=[];
for i=1:64
    out=tensor_connectivity(Fp,i,3);
    Cx(:,:,i)=topoconn_av(Fp,out,i,1,freq,band,1,0);  
    Cpli(:,:,i)=ls_pli(Ys{i},band,0);
end
Cb=1:19;
Cs=20:38;
Pb=39:51;
Ps=52:64;
cc=[0 0.2];
figure,
subplot(2,2,1),imagesc(squeeze(mean(Cx(:,:,Cb),3))),title('C-b'),caxis(cc)
subplot(2,2,2),imagesc(squeeze(mean(Cx(:,:,Cs),3))),title('C-s'),caxis(cc)
subplot(2,2,3),imagesc(squeeze(mean(Cx(:,:,Pb),3))),title('P-b'),caxis(cc)
subplot(2,2,4),imagesc(squeeze(mean(Cx(:,:,Ps),3))),title('P-s'),caxis(cc)
figure,
subplot(2,2,1),imagesc(squeeze(mean(Cpli(:,:,Cb),3))),title('C-b'),caxis(cc)
subplot(2,2,2),imagesc(squeeze(mean(Cpli(:,:,Cs),3))),title('C-s'),caxis(cc)
subplot(2,2,3),imagesc(squeeze(mean(Cpli(:,:,Pb),3))),title('P-b'),caxis(cc)
subplot(2,2,4),imagesc(squeeze(mean(Cpli(:,:,Ps),3))),title('P-s'),caxis(cc)