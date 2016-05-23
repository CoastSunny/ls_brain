function [ W , metric , iter, asd] = optimise_network_two(W,metric_type,target_value,varargin)

opts = struct ( 'modules',[],'structure', [] ) ;
[ opts  ] = parseOpts( opts , varargin );
opts2var

n=size(W,1);
O=ones(n);
H=O-eye(n);
metric=inf;


Winit=W;
l=1;
penalty=inf;
iter=1;
dW=Inf;
max_iter=15000;
%while penalty>0.001 | iter>10000
while norm(metric(:,end)-target_value)>10^-6 && iter<max_iter
   
    %     [penalty,tmp]=network_penalty_wu(W,metric_type,target_value,'modules',modules);
    %     metric(iter)=tmp;
    %     dW=l*(abs(penalty))*sign(penalty)*network_gradient_wu(W,metric_type,...
    %         'modules',modules,'structure',structure);
    for i=1:2
        metric(i,iter)=ls_network_metric(W,metric_type{i},opts);
        dw{i}=network_gradient_wu(W,metric_type{i},opts);        
    end
%     dW=( dw{1} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) )...
%        + dw{2} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) ) );
   
    dW=( dw{1} * (metric(1,iter) - target_value(1) )...
       + dw{2} * (metric(2,iter) - target_value(2) ) );
   
    W = W - l * dW;
    W(W<0)=0;
    W(W>1)=1;
    %     W=W/max(max(W));
    iter=iter+1;
    
end
asd=norm(dW);
% W=W/max(max(W));

end