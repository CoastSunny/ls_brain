function out = topoconn(Fp,idx1,idx2,subj,freq)
temp=freq{1};
cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
% cfg.layout='C:\Users\Loukianos\Documents\ls_brain\global\biosemi128.lay';
cfg.parameter='powspctrm';
cfg.comment='no';
figure
subplot(1,2,1)
temp.powspctrm=abs(repmat((Fp{subj}{2}(:,idx1)),1,30)).^2;
ft_topoplotTFR(cfg,temp);
subplot(1,2,2)
temp.powspctrm=abs(repmat((Fp{subj}{2}(:,idx2)),1,30)).^2;
ft_topoplotTFR(cfg,temp);

