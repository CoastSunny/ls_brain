function out = ls_ica ( obj, varargin )

opts = struct( ...
    'classes' , [] , ...
    'blocks_in'  , 'all' , ...
    'channels' , 'all' , ...
    'time' , 'all' , ...
    'dim' , 3 , ...
    'trials' , 'all' , ...
    'method' , 'runica' ) ;
[ opts ] = parseOpts( opts , varargin ) ;
opts2var

[time channels]=convertall2var(obj,time,channels);
[blocks_in blocks_excluded]=getBlocks(obj,blocks_in);
[indices classlength labels]=getIndices(obj,classes,blocks_excluded,trials);
[indices si]=sort(indices);
cfg.preproc.lpfilter='yes';
cfg.preproc.lpfreq=20;
cfg.preproc.hpfilter='yes';
cfg.preproc.hpfreq=.5;

cfg.preproc.demean='yes';
cfg.preproc.detrend='yes';
cfg.preproc.baselinewindow=[0 0.6];

cfg.covariance='yes';
%                 %cfg.lpfilter='yes';
%                 % cfg.lpfreq=.20;
  cfg.trials=indices;
  cfg.keeptrials='yes';
var = ft_timelockanalysis( cfg , obj.data ) ;

cfg.numcomponent=9;
cfg.method=method;
cfg.trials=indices(1:end);
cfg.channel=[1 3:10];
cfg.layout='EEG1010.lay';

comp = ft_componentanalysis( cfg , var );
out.comp=comp;
%  ft_databrowser(cfg,comp);
% avg = ft_timelockanalysis(cfg,comp);


%  out.avg=avg;

end