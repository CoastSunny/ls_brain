function [ W , metric , iter] = optimise_network_multi(W,metric_type,target_value,varargin)

opts = struct ( 'modules',[],'structure', [] ,'net',[]) ;
[ opts  ] = parseOpts( opts , varargin );
opts2var

n=size(W,1);
O=ones(n);
H=O-eye(n);

M=modules;
if ~isempty(structure)
S=structure;
else
    S=H;
end
Y=net;
Winit=W;
l=1;
penalty=inf;
iter=1;
dW=Inf;
max_iter=30000;
%while penalty>0.001 | iter>10000
metric={inf};
while norm([metric{:,end}]-[target_value{:}])>10^-6 && iter<max_iter
   
    %     [penalty,tmp]=network_penalty_wu(W,metric_type,target_value,'modules',modules);
    %     metric(iter)=tmp;
    %     dW=l*(abs(penalty))*sign(penalty)*network_gradient_wu(W,metric_type,...
    %         'modules',modules,'structure',structure);
    
    for i=1:numel(target_value)
        
        metric{ i , iter } = ls_network_metric( W , metric_type{ i } , opts );
        dw{ i } = network_gradient_wu( W , metric_type{ i } , opts );  
        
        if numel(metric{ i , iter }) > 1 
            
            for j=1:numel(metric{i,iter})
                
                igrad( : , : , j ) = dw{ i }( : , : , j )...
                    * ( metric{ i , iter }( j ) - target_value{ i }( j ) ); 
                
            end
            
            grad( : , : , i ) = sum( igrad , 3 );
        
        else
        
            grad( : , : , i ) = dw{ i } * ( metric{ i , iter } - target_value{ i } );
            
        end
    end
%     dW=( dw{1} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) )...
%        + dw{2} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) ) );
   if ~isempty(net)
       dc = .05*(W-Y)*norm(W-Y,'fro') / n^2;
   else 
       dc=0;
   end
    dW = ( sum( grad , 3 ) + dc ) .* S;
   
    W = W - l * dW;
    W( W < 0 ) = 0;
    W( W > 1 ) = 1;
    %     W=W/max(max(W));
    iter = iter + 1;
    
end

% W=W/max(max(W));

end