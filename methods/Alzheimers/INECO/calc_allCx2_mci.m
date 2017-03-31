% band=4:7;
Cpli=[];Cx=[];O=[];SNR=[];Cxp=[];
for i=1:length(FT)
    fprintf(num2str(i))
    out=tensor_connectivity3(FT{1,i}{4},FT{1,i}{2},FT{1,i}{3},band);
%     out=tensor_connectivity2(FT{1,i}{4},FT{1,i}{2},band);

%     out=mean(out,3);
    out=mean(out(:,:,band),3);
    O(i)=max(max(out));
    Cx(:,:,i)=topoconn_av2(FT,out,i,1,freq,band,0,1,0);  
    Cxp(:,:,i)=topoconn_av2(FT,out,i,1,freq,band,0,0,0);  

    out=triu(out);
    [tmp itmp]=sort(out(:));
    tmp=flipud(itmp);
    [tmpr tmpc]=ind2sub(size(out),tmp(1));
    r=tmpr;
    c=tmpc;
    [powr,pow,powf,snr]=ls_pf2fit(FT{1,i}{5},FT{1,i}{1},FT{1,i}{2},FT{1,i}{3},FT{1,i}{4},40,[r c]);
    [powr2,pow2,powf,snr2]=ls_pf2fit(FT{1,i}{5},FT{1,i}{1},FT{1,i}{2},FT{1,i}{3},FT{1,i}{4},40,setdiff(1:8,[r c]));

%     [powc,pow,snr]=ls_pf2fit(y,FT{count,q}{1},FT{count,q}{2},FT{count,q}{3},FT{count,q}{4},40,c);
    SNR(i)=powr/(pow2+powr);
    L(i,:)=[r c];
%     Cpli(:,:,i)=ls_pli(permute(Ys{i},[2 1 3]),band,0);
end

Cb=[2:6 8:10 12:15 18:19];
Cs=Cb+19;
Pb=[39:51];
Ps=[52:64];

cc='auto'; 
% cc=[0 2*10^-3];
cc=[0 6];
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
% % 
% figure,
% subplot(2,2,1),imagesc(squeeze(mean(Cpli(:,:,Cb),3))),title('C-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% subplot(2,2,2),imagesc(squeeze(mean(Cpli(:,:,Cs),3))),title('C-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% subplot(2,2,3),imagesc(squeeze(mean(Cpli(:,:,Pb),3))),title('P-b'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% subplot(2,2,4),imagesc(squeeze(mean(Cpli(:,:,Ps),3))),title('P-s'),caxis(cc),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% % 
% for i=1:size(Cx,1)
%     for j=1:size(Cx,2)
%         [hB(i,j) pB(i,j)]=ttest2(Cx(i,j,Cb),Cx(i,j,Pb),'tail','right','alpha',0.05);
%     end
% end
% figure,imagesc(hB),set(gca,'Xtick',ll),set(gca,'Xticklabels',kk),set(gca,'Ytick',ll),set(gca,'Yticklabels',kk),
% 
% ci=2;
% cfg=[];
% cfg.layout=[home '\Documents\ls_brain\global\biosemi128.lay'];
% cfg.comment='no';
% cfreq=freq{1};
% cfreq.freq='all';%cfreq=rmfield(cfreq,'cumsumcnt');cfreq=rmfield(cfreq,'cumtapcnt');
% % cfreq.dimord='chan_freq';
% cfreq.powspctrm=abs(FT{1,ci}{1}(:,L(ci,1)));
% % figure('units','normalized','outerposition',[0 0 1 1]),
% figure,subplot(2,2,1),title('component 1'),ft_topoplotTFR(cfg,cfreq);
% cfreq.powspctrm=abs(FT{1,ci}{1}(:,L(ci,2)));
% subplot(2,2,2),,title('component 2'),ft_topoplotTFR(cfg,cfreq);
% subplot(2,2,3),plot(abs(FT{1,ci}{3}(:,L(ci,1))),'Linewidth',2),ylabel('PSD'),xlabel('freq')
% subplot(2,2,4),plot(abs(FT{1,ci}{3}(:,L(ci,2))),'Linewidth',2),ylabel('PSD'),xlabel('freq')

