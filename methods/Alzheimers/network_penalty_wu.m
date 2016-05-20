function [penalty, metric] = network_penalty_wu(W,metric_type,target_value,varargin)


metric=ls_network_metric(W,metric_type,varargin);
penalty=metric-target_value;

end