figure
temp=freq{1};
cfg=[];
cfg.layout='/home/lspyrou/Documents/ls_brain/global/biosemi128.lay';
cfg.parameter='powspctrm';
cfg.figurename=' ';
f1=2;
f2=9;
si=10;
temp.powspctrm=repmat(Fp{f1,si}{2}(:,1),1,15);
subplot(5,2,1),title('\lambda=0')
ft_topoplotTFR(cfg,temp)
temp.powspctrm=repmat(Fp{f2,si}{2}(:,1),1,15);
subplot(5,2,2),title('\lambda=1000')
ft_topoplotTFR(cfg,temp)


temp.powspctrm=repmat(Fp{f1,si}{2}(:,2),1,15);
subplot(5,2,3)
ft_topoplotTFR(cfg,temp)
temp.powspctrm=repmat(Fp{f2,si}{2}(:,2),1,15);
subplot(5,2,4)
ft_topoplotTFR(cfg,temp)

temp.powspctrm=repmat(Fp{f1,si}{2}(:,3),1,15);
subplot(5,2,5)
ft_topoplotTFR(cfg,temp)
temp.powspctrm=repmat(Fp{f2,si}{2}(:,3),1,15);
subplot(5,2,6)
ft_topoplotTFR(cfg,temp)

temp.powspctrm=repmat(Fp{f1,si}{2}(:,4),1,15);
subplot(5,2,7)
ft_topoplotTFR(cfg,temp)
temp.powspctrm=repmat(Fp{f2,si}{2}(:,4),1,15);
subplot(5,2,8)
ft_topoplotTFR(cfg,temp)

temp.powspctrm=repmat(Fp{f1,si}{2}(:,5),1,15);
subplot(5,2,9)
ft_topoplotTFR(cfg,temp)
temp.powspctrm=repmat(Fp{f2,si}{2}(:,5),1,15);
subplot(5,2,10)
ft_topoplotTFR(cfg,temp)


    