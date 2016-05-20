function out=trial_amp(obj,varargin)

opts = struct( ...
    'classes' , [] , ...
    'blocks_in'  , [] , ...
    'channels' , 'all' , ...
    'time' , 'all' , ...
    'trials' , 'all' , ...
    'vis' , 'on' , ...
    'badrem' , 'no') ;

[ opts ] = parseOpts( opts , varargin ) ;
opts2var

blocks=1:numel(obj.block_idx);
blocks_out=setdiff(blocks,blocks_in);
cfg.channel=channels;
[time channels]=convertall2var(obj,time,channels);
[indices classlength labels]=getIndices(obj,classes,blocks_out,trials);
if (strcmp(badrem,'yes'))
    X=cat(3,obj.data.trial{indices});
    X=X(channels,time,:);
    [badtr,vars]=idOutliers(X,3,3);
    indices=indices(~badtr);
    labels=labels(:,~badtr);%%%%changed cardinality oeo
end
clear X
cfg.lpfilter='yes';
cfg.lpfreq=20;
cfg.hpfilter='yes';
cfg.hpfreq=.5;
cfg.covariance='yes';
cfg.demean='yes';
cfg.detrend='yes';
cfg.baselinewindow=[0 0.6];
cfg.keeptrials='yes';
cfg.trials=indices;
var = ft_timelockanalysis( cfg , obj.data ) ;

for i=1:numel(indices)
    
    m(i,:) = std(squeeze(var.trial(i,channels,time))');
    
end
out.m=m';

end