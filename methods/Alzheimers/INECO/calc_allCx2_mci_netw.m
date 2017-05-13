% band=4:7;
Cpli=[];Cx=[];O=[];SNR=[];Cxp=[];Fx=[];Ex=[];Tx=[];Clx=[];Dx=[];
O1=[1 2 3 32+1 32+3 32+20 64+1 64+2 64+23 96+1 96+15 96+2 96+14 96+15 96+16];
O2=setdiff(1:32,O1);
O3=setdiff(33:64,O1);
O4=setdiff(65:96,O1);
O5=setdiff(97:128,O1);
O{1}=O1;O{2}=O2;O{3}=O3;O{4}=O4;O{5}=O5;
M=ind2mod(O,eye(128));
idcs=[O1 O2 O3 O4 O5];
ci=2;
for i=[1:64]%length(Fp)
%     try
    W=v2G(Fp{i}{1}(:,ci));
    Cx(:,:,i)=weight_conversion(W,'normalize');
    Tx(:,i)=ls_network_metric(W,'trans');
    Dx(:,i)=ls_network_metric(W,'deg');
    Clx(:,i)=mean(ls_network_metric(W,'clust'));
    Mx(:,i)=ls_network_metric(W,'modul','modules',M);
    Fx(:,i)=Fp{i}{2}(:,ci);
    Ex(:,i)=Fp{i}{3}(:,ci);
%     catch 
       
%     end
end

Cb=[2:6 8:10 12:15 18:19];
Cs=Cb+19;
Pb=[39:51];
Ps=[52:64];

cc='auto'; 
% cc=[0 2*10^-3];
cc=[0 .3];
ll=[ 12  37 62 87 112];
kk={'cen' 'back' 'right' 'front' 'left'};

RR(:,1)=[mean(mean(Clx(:,Cb))) mean(mean(Clx(:,Cs))) mean(mean(Clx(:,Pb))) mean(mean(Clx(:,Ps)))];
RR(:,2)=[mean(mean(Dx(:,Cb))) mean(mean(Dx(:,Cs))) mean(mean(Dx(:,Pb))) mean(mean(Dx(:,Ps)))];
RR(:,3)=[(mean(Tx(:,Cb))) (mean(Tx(:,Cs))) (mean(Tx(:,Pb))) (mean(Tx(:,Ps)))];
RR(:,4)=[(mean(Mx(:,Cb))) (mean(Mx(:,Cs))) (mean(Mx(:,Pb))) (mean(Mx(:,Ps)))];
% 
% 
% figure,
% subplot(2,2,1),imagesc(squeeze(mean(Cx(idcs,idcs,Cb),3))),title('C-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% subplot(2,2,2),imagesc(squeeze(mean(Cx(idcs,idcs,Cs),3))),title('C-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% subplot(2,2,3),imagesc(squeeze(mean(Cx(idcs,idcs,Pb),3))),title('P-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% subplot(2,2,4),imagesc(squeeze(mean(Cx(idcs,idcs,Ps),3))),title('P-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% 
% figure,
% subplot(2,2,1),plot(mean(Fx(:,Cb),2)),title('fC-b'),ylim([0 0.5])
% subplot(2,2,2),plot(mean(Fx(:,Cs),2)),title('fC-s'),ylim([0 0.5])
% subplot(2,2,3),plot(mean(Fx(:,Pb),2)),title('fP-b'),ylim([0 0.5])
% subplot(2,2,4),plot(mean(Fx(:,Ps),2)),title('fP-s'),ylim([0 0.5])
% 
% figure,
% subplot(2,2,1),plot(mean(Ex(:,Cb),2)),title('eC-b'),ylim([0.2 0.5])
% subplot(2,2,2),plot(mean(Ex(:,Cs),2)),title('eC-s'),ylim([0.2 0.5])
% subplot(2,2,3),plot(mean(Ex(:,Pb),2)),title('eP-b'),ylim([0.2 0.5])
% subplot(2,2,4),plot(mean(Ex(:,Ps),2)),title('eP-s'),ylim([0.2 0.5])