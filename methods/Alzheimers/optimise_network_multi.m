function [ W , metric , iter, d] = optimise_network_multi(W,metric_type,target_value,varargin)

opts = struct ( 'modules', [] ,'structure', [] , 'net' , [] ,...
    'constraint' , [] , 'learn' , [] ,'true_net', [] ) ;
[ opts  ] = parseOpts( opts , varargin );
opts2var

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
    l=1;
else
    l=learn;
end

penalty=inf;
iter=1;
dW=Inf;
max_iter=20000;
%while penalty>0.001 | iter>10000
metric={inf};
check=inf;
while check>10^-3 && iter<max_iter
    
    %     [penalty,tmp]=network_penalty_wu(W,metric_type,target_value,'modules',modules);
    %     metric(iter)=tmp;
    %     dW=l*(abs(penalty))*sign(penalty)*network_gradient_wu(W,metric_type,...
    %         'modules',modules,'structure',structure);
    
    for i=1:numel(target_value)
        
        [metric{ i , iter }]= ls_network_metric( W , metric_type{ i } , opts );
                
        if numel(metric{ i , iter }) > 1 & strcmp(metric_type{i},'deg')
            
            dw = network_gradient_wu( W , metric_type{ i } , opts );
            igrad = 1/n * dw * ones(n,1) * (metric{i,iter} - target_value{ i }).' ;
            grad(:,:,i) = igrad + igrad.';
            
        elseif numel(metric{ i , iter }) > 1 & ~strcmp(metric_type{i},'deg')
                    
            [metric{ i , iter } numer denom]= ls_network_metric( W , metric_type{ i } , opts );
            igrad=0;            
            for j=1:numel(metric{i,iter})
               
                dw = network_gradient_wu( W , metric_type{ i } , 'node' , j ,...
                    'numer', numer , 'denom' ,denom ,'W2',W^2);
                igrad = igrad + 1 / n *dw...
                    * ( metric{ i , iter }( j ) - target_value{ i }( j ) );
               
            end
            
            grad(:,:,i) = igrad + igrad.';
            
        else
            dw = network_gradient_wu( W , metric_type{ i } , opts );
            grad( : , : , i ) = dw * ( metric{ i , iter } - target_value{ i } );
            grad( : , : , i ) = grad( : , : , i ) + grad( : , : , i )';
        end
    end
    %     dW=( dw{1} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) )...
    %        + dw{2} * (metric(1,iter) + metric(2,iter) - target_value(1) - target_value(2) ) );
    if ~isempty(constraint)
        dc = pen*(W-Y)*norm(W-Y,'fro') / n^2;
    else
        dc=0;
    end
    dW = ( sum( grad , 3 ) + dc ) .* S;
    if (max(max(abs(l*dW))))>0.1
        l=l/10;
        continue;
    end
    W = W - l * dW;
    W( W < 0 ) = 0;
    W( W > 1 ) = 1;
    %     W=W/max(max(W));
    if (~isempty(true_net))
        d(iter)=1/numel(W)*norm(W-true_net,'fro');
    end
    iter = iter + 1;
    %     check=norm(l*dW,'fro');
    check=max(abs(cat(1,metric{:,end})-cat(1,target_value{:})));
    if mod(iter,500)==0
        %  fprintf(num2str(check));
    end
end

% W=W/max(max(W));

end