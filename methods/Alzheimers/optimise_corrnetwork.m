function [ X , metric , iter] = optimise_corrnetwork(X,idx,tidx,metric_type,target_value,varargin)

opts = struct ( 'modules',[],'structure', [] ,'constraint', [] , 'learn' , []) ;
[ opts  ] = parseOpts( opts , varargin );
opts2var

W=WfromX(X);
n=size(W,1);
O=ones(n);
H=O-eye(n);
M=modules;

Winit=W;

if ~isempty(structure)
    S=structure;
else
    S=H;
end
if ~isempty(constraint)
    Y=constraint{1};
    pen=constraint{2};
else
    Y=0;
    pen=0;
end
if isempty(learn)
    l=1000;
else
    l=learn;
end

penalty=inf;
iter=1;
dX=Inf;
max_iter=10000;
%while penalty>0.001 | iter>10000
metric={inf};
check=inf;
while check>10^-6 && iter<max_iter
    
    %     [penalty,tmp]=network_penalty_wu(W,metric_type,target_value,'modules',modules);
    %     metric(iter)=tmp;
    %     dW=l*(abs(penalty))*sign(penalty)*network_gradient_wu(W,metric_type,...
    %         'modules',modules,'structure',structure);
    
    for i=1:numel(target_value)
        
        metric{ i , iter } = ls_corrnetwork_metric( X , metric_type{ i } , opts );
        dx{ i } = net_corr_grad( X , idx , tidx , metric_type{ i } , opts );
        
        if numel(metric{ i , iter }) > 1
            
            for j=1:numel(metric{i,iter})
                
                igrad( j , : ) = dx{ i }( j , : )...
                    * ( metric{ i , iter }( j ) - target_value{ i }( j ) );
                
            end
            
            grad( i , : ) = sum( igrad , 2 );
            
        else
            
            grad( i , : ) = dx{ i } * ( metric{ i , iter } - target_value{ i } );
            
        end
    end
    %     dW=( dw{1} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) )...
    %        + dw{2} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) ) );
    if ~isempty(constraint)
        dc = pen*(W-Y)*norm(W-Y,'fro') / n^2;
    else
        dc=0;
    end
    dX = ( sum( grad , 1 ) );
    
    X(idx,tidx) = X(idx,tidx) - l * dX;
    
    iter = iter + 1;
    check=norm(l*dX,'fro');
end

% W=W/max(max(W));

end