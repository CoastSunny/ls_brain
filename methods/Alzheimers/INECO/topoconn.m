function out = topoconn(Fp,idx1,idx2,subj,freq)
temp=freq{1};
if isunix==1
    cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
else
    cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
end
cfg.parameter='powspctrm';
cfg.comment='no';
figure
subplot(1,2,1)
temp.powspctrm=abs(repmat((Fp{subj}{2}(:,idx1)),1,30)).^2;
ft_topoplotTFR(cfg,temp);
subplot(1,2,2)
temp.powspctrm=abs(repmat((Fp{subj}{2}(:,idx2)),1,30)).^2;
ft_topoplotTFR(cfg,temp);
% figure
% subplot(1,2,1)
% plot(Fp{subj}{1}(:,idx1))
% subplot(1,2,2)
% plot(Fp{subj}{1}(:,idx2))
