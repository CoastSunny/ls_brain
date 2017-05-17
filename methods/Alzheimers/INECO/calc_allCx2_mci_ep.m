% band=4:7;
Cpli=[];Cx=[];O=[];SNR=[];Cxp=[];
for i=1:length(Fp)
    fprintf(num2str(i))
   
    Cx(:,:,i)=weight_conversion(v2G(Fp{i}{1}(:,1)),'akyro');
    
end

Cb=[2:6 8:10 12:15 18:19];
Cs=Cb+19;
Pb=[39:51];
Ps=[52:64];

cc='auto'; 
% cc=[0 2*10^-3];
cc=[0.2 1];
ll=[ 12  37 62 87 112];
kk={'cen' 'back' 'right' 'front' 'left'};
O1=[1 2 3 32+1 32+3 32+20 64+1 64+2 64+23 96+1 96+15 96+2 96+14 96+15 96+16];
O2=setdiff(1:32,O1);
O3=setdiff(33:64,O1);
O4=setdiff(65:96,O1);
O5=setdiff(97:128,O1);
idcs=[O1 O2 O3 O4 O5];
figure,
subplot(2,2,1),imagesc(squeeze(mean(Cx(idcs,idcs,Cb),3))),title('C-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,2),imagesc(squeeze(mean(Cx(idcs,idcs,Cs),3))),title('C-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,3),imagesc(squeeze(mean(Cx(idcs,idcs,Pb),3))),title('P-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,4),imagesc(squeeze(mean(Cx(idcs,idcs,Ps),3))),title('P-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
