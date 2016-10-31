band=[];
Cpli=[];Cx=[];
for i=1:64
    out=tensor_connectivity(Fp,i,3);
    Cx(:,:,i)=topoconn_av(Fp,out,i,1,freq,band,0);  
    Cpli(:,:,i)=ls_pli(Ys{i},band,0);
end
figure,
subplot(2,2,1),imagesc(squeeze(mean(Cx(:,:,1:16),3))),title('C-b')
subplot(2,2,2),imagesc(squeeze(mean(Cx(:,:,17:32),3))),title('C-s')
subplot(2,2,3),imagesc(squeeze(mean(Cx(:,:,33:48),3))),title('P-b')
subplot(2,2,4),imagesc(squeeze(mean(Cx(:,:,49:64),3))),title('P-s')
figure,
subplot(2,2,1),imagesc(squeeze(mean(Cpli(:,:,1:16),3))),title('C-b')
subplot(2,2,2),imagesc(squeeze(mean(Cpli(:,:,17:32),3))),title('C-s')
subplot(2,2,3),imagesc(squeeze(mean(Cpli(:,:,33:48),3))),title('P-b')
subplot(2,2,4),imagesc(squeeze(mean(Cpli(:,:,49:64),3))),title('P-s')