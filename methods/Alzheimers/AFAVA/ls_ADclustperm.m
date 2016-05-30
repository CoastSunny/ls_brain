cfg = [];
save=0;
cfg.channel          = 'all';
% cfg.latency          = [0 10];
cfg.frequency        = [0 40];
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 500;
% specifies with which sensors other sensors can form clusters
cfg_neighb.method    = 'distance';
cfg_neighb.neighbourdist=.4;
cfg_neighb.layout=[home '/Documents/ls_brain/global/AFAVA.lay'];
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, freq{1});

subj1 = 12;subj2=11;
design = zeros(2,subj1+subj2);
for i = 1:subj1
  design(1,i) = i;
end
for i = 1:subj2
  design(1,subj1+i) = i;
end
design(2,1:subj1)        = 1;
design(2,subj1+1:subj1+subj2) = 2;

cfg.design   = design;
% cfg.uvar     = 1;
cfg.ivar     = 2;
cfg_freq     = [];
cfg_freq.keepindividual     = 'yes';
Pat = ft_freqgrandaverage(cfg_freq,freq{fidx_patient});
Con = ft_freqgrandaverage(cfg_freq,freq{fidx_control});
[stat] = ft_freqstatistics(cfg, Pat, Con);
% 
cfg=[];
cfg.layout=[home '/Documents/ls_brain/global/AFAVA.lay'];
cfg.subplotsize=[2 4];
ft_clusterplot(cfg, stat);
if save==1;saveaspdf(gcf,'ClusterPSD');end;