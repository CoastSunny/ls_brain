function [grad]= network_gradient_wu(W,metric_type,varargin)

n=size(W,1);
O=ones(n);
H=O-eye(n);

if any(strcmp(metric_type,{'trans' 'transitivity'}))
    
    alfa=trace(W^3);
    beta=trace(W*H*W');
    grad=((3*beta*W^2-alfa*(W*H+H*W))/beta^2 ).*H;
   
    
elseif any(strcmp(metric_type,{'clust' 'clustering'}))
    
    opts = struct ( 'node' , [] , 'numer' , [] , 'denom', [] ,'W2',[]) ;
    [ opts  ] = parseOpts( opts , varargin );
    opts2var
    i=node;
    Si=zeros(n,n);
    Si(i,i)=1;
    if isempty(numer)
        gamma=diag(W^3);
    else
        gamma=numer;
    end
    if isempty(denom)
        zeta=diag(W*H*W);
    else
        zeta=denom;
    end;
   
    swh=Si.'*W.'*H.';
    if isempty(W2);W2=W^2;end;
    siw2=W2;
    siw2(setdiff(1:n,i),:)=0;

    if zeta(i)~=0
        igrad = (zeta(i)*(siw2+W*Si*W+siw2.').'-gamma(i)*(swh+(swh).'))/zeta(i)^2;        
    else
        igrad=zeros(n);
    end

    grad=igrad;
    
elseif any(strcmp(metric_type,{'modul' 'modularity'}))
    
    opts = struct ( 'modules', [] ,'structure', [] , 'net' , [] ,...
        'constraint' , [] , 'learn' , [] ,'true_net',[]) ;
    [ opts  ] = parseOpts( opts , varargin );
    opts2var
    D = modules ;
    
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
    grad = ( dM1 - dM2 )  ;
   
    
    
elseif any(strcmp(metric_type,{'deg' 'degree'}))       
    
    grad = 1/n * (ones(n)-diag(diag(ones(n))));
    
elseif any(strcmp(metric_type,{'avndeg' 'average_neighbour_degree'}))
    
    R = zeros( n );
    rho=sum(W^2);
    tau=sum(W);
       
    for i=1:n
       
        R_i = R;
        R_i( : , i ) = ones( n , 1 ) / n;   
        wr=W * R_i;
        igrad( : , : , i ) = (tau(i) * ( wr + wr' ) - rho(i) * R_i.')/tau(i)^2 ;       
       
    end
    
    idx_to_remove=find(tau(i)==0);
    if ~isempty(idx_to_remove)
        igrad(:,:,idx_to_remove)=zeros(n);
    end
    grad = mean( igrad , 3 );
      
end


end % function end


%( Pn * W * D.' + Pn.' * W * D ).' -diag(diag( Pn * W * D.' + Pn.' * W * D))