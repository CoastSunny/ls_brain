% band=4:7;
Cpli=[];Cx=[];O=[];SNR=[];Cxp=[];Fx=[];Ex=[];
ci=2;
for i=1:length(Fp)
  
    Cx(:,:,i)=weight_conversion(v2G(Fp{i}{1}(:,ci)),'normalize');
    Fx(:,i)=Fp{i}{2}(:,ci);
    Ex(:,i)=Fp{i}{3}(:,ci);
end


Cb=[1:10];
Cs=[11:20];
Pb=[21:30];
Ps=[31:40];
cc='auto'; 
cc=[0 .4];
ll=[10 30 50];
kk={'front' 'central' 'back'};

figure,
subplot(2,2,1),imagesc(squeeze(mean(Cx(:,:,Cb),3))),title('C-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,2),imagesc(squeeze(mean(Cx(:,:,Cs),3))),title('C-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,3),imagesc(squeeze(mean(Cx(:,:,Pb),3))),title('P-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
subplot(2,2,4),imagesc(squeeze(mean(Cx(:,:,Ps),3))),title('P-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),

figure,
subplot(2,2,1),plot(mean(Fx(:,Cb),2)),title('fC-b'),ylim([0 0.5])
subplot(2,2,2),plot(mean(Fx(:,Cs),2)),title('fC-s'),ylim([0 0.5])
subplot(2,2,3),plot(mean(Fx(:,Pb),2)),title('fP-b'),ylim([0 0.5])
subplot(2,2,4),plot(mean(Fx(:,Ps),2)),title('fP-s'),ylim([0 0.5])

figure,
subplot(2,2,1),plot(mean(Ex(:,Cb),2)),title('eC-b'),ylim([0.2 0.5])
subplot(2,2,2),plot(mean(Ex(:,Cs),2)),title('eC-s'),ylim([0.2 0.5])
subplot(2,2,3),plot(mean(Ex(:,Pb),2)),title('eP-b'),ylim([0.2 0.5])
subplot(2,2,4),plot(mean(Ex(:,Ps),2)),title('eP-s'),ylim([0.2 0.5])