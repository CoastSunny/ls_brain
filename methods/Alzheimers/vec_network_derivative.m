function [grad]= vec_network_derivative(W,metric_type,varargin)

n=size(W,1);
O=ones(n);
H=O-eye(n);

if any(strcmp(metric_type,{'trans' 'transitivity'}))
    
    alfa=trace(W^3);
    beta=trace(W*H*W');
    grad=(3*vec( (W.')^2 ).' * beta - alfa * vec( (W*H+H*W).').' ) / beta^2;
    
    
elseif any(strcmp(metric_type,{'clust' 'clustering'}))
    
    S=zeros(n,n,n);
    
    for i=1:n
        
        S(i,i,i)=1;
        Si=S(:,:,i);
        gamma(i)=trace(Si*W^3);
        zeta(i)=trace(Si*W*H*W);
        if zeta(i)~=0
            dgamma = ( vec( (W^2*Si).' ) + vec( (W*Si*W).' ) + vec( (Si*W^2).' ) ).';
            dzeta  = ( vec( (H*W*Si).' ) + vec( (Si*W*H).' ) ).';
            igrad(:,i)=  ( dgamma * zeta(i) - dzeta * gamma(i) ) / zeta(i)^2;
        else
            igrad( : , : , i )=vec(zeros(n));
        end
    end
%     idx_to_remove=find(zeta==0);
%     igrad(:,:,idx_to_remove)=[];
%     grad=mean(igrad,3);
%     grad = grad + grad.' - diag(diag(grad));
        grad=igrad;
    
elseif any(strcmp(metric_type,{'modul' 'modularity'}))
    
    opts = struct ( 'modules', [] ,'structure', [] , 'net' , [] ,...
        'constraint' , [] , 'learn' , [] ,'true_net',[]) ;
    [ opts  ] = parseOpts( opts , varargin );
    opts2var
    D = modules ;
    S = structure;
    
    theta = trace( W * O ) ;
    iota = trace( W * D.' ) ;
    dM1 = ( D * theta - O.' * iota) / theta^2 ;
    
    ch =1:n ;
    for i = 1:n ; p( i , : ) = circshift( ch' , i-1 )' ; end ;
    P = permMatrices( n , p ) ;
    
    for i=1:n
        
        Pn = P( : , : , i ) ;
        kappa( i ) = trace( W.' * Pn * W * D.' ) ;
        dm2( : , : , i ) = ( theta ...
            *( ( Pn * W * D.' + Pn.' * W * D ))...
            - 2 * kappa(i) * O.' ) / theta^3 ;
        
    end
    
    dM2 = sum( dm2 , 3 );
    grad = ( dM1 - dM2 ) .* S ;
    grad = grad + grad.' - diag(diag(grad));
    
    
elseif any(strcmp(metric_type,{'deg' 'degree'}))
    
    R = zeros( n );
    
    for i=1:n
        
        R_i = R;
        R_i( : , i ) = ones( n , 1 ) / n;
        igrad( : , : , i ) = R_i.' ;
        igrad( : , : , i ) = igrad( : , : , i ) + igrad( : , : , i ).' - diag(diag(igrad(:,:,i)));
        
    end
    
    %     grad = sum( igrad , 3 );
    %     grad = grad + grad.' - diag(diag(grad));
    
    grad = igrad;
    
elseif any(strcmp(metric_type,{'avndeg' 'average_neighbour_degree'}))
    
    R = zeros( n );
    
    for i=1:n
        
        R_i = R;
        R_i( : , i ) = ones( n , 1 ) / n;
        rho=trace(W^2*R_i);
        tau(i)=trace(W*R_i);
        igrad( : , : , i ) = (tau(i) * ( W * R_i + R_i * W ) .' - rho * R_i.')/tau(i)^2 ;
        igrad( : , : , i ) = igrad( : , : , i ) + igrad( : , : , i ).' - diag(diag(igrad(:,:,i)));
        
    end
    
    idx_to_remove=find(tau(i)==0);
    if ~isempty(idx_to_remove)
        igrad(:,:,idx_to_remove)=zeros(n);
    end
    grad = mean( igrad , 3 );
    grad = grad + grad.' - diag(diag(grad));
    
    grad = grad;
    
end




end % function end


%( Pn * W * D.' + Pn.' * W * D ).' -diag(diag( Pn * W * D.' + Pn.' * W * D))