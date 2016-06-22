function [metric] = ls_network_metric(W,metric_type,varargin)

n=size(W,1);
O=ones(n);
H=O-eye(n);

if any(strcmp(metric_type,{'trans' 'transitivity'}))
    
    alfa=trace(W^3);
    beta=trace(W*H*W);
    metric=alfa/beta;
    
elseif any(strcmp(metric_type,{'clust' 'clustering'}))
    
    S=zeros(n,n,n);
    for i=1:n
        
        S(i,i,i)=1;
        Si=S(:,:,i);
        gamma(i)=trace(Si*W^3);
        zeta(i)=trace(Si*W*H*W);
        
    end
    idx_to_remove=find(zeta==0);
%     zeta(idx_to_remove)=[];
%     gamma(idx_to_remove)=[];
    metric=(gamma./zeta);
    metric(idx_to_remove)=0;
elseif any(strcmp(metric_type,{'modul' 'modularity'}))
    
    opts = struct ( 'modules', [] ,'structure', [] , 'net' , [] ,...
        'constraint' , [] , 'learn' , [] ,'true_net',[]) ;
    [ opts  ] = parseOpts( opts , varargin );
    opts2var
    D=modules;
    l=trace(W*O);
    M1=trace(W*D.')/l;
    ch=1:n;
    for i=1:n; p(i,:)=circshift(ch',i-1)';end;
    P=permMatrices(n,p);
    
    for i=1:n
        
        Pn=P(:,:,i);
        Q=zeros(n);Q(i,:);
        m2( i ) = trace( W.' * Pn * W * D.' ) ;
        %         m2(i)=trace(W*(Pn*W).'*(Pn*D.'));
        
        
    end
    M2=sum(m2)/(l^2);
    metric=(M1-M2);
    
elseif any(strcmp(metric_type,{'deg' 'degree'}))
    
    R = zeros( n );
    
    for i=1:n
        
        R_i = R;
        R_i( : , i ) = ones( n , 1 ) ;
        dg( i ) = trace( W * R_i );
        
    end
    
    metric = dg;
    
elseif any(strcmp(metric_type,{'avndeg' 'average_neighbour_degree'}))
    
    R = zeros( n );
    
    for i=1:n
        
        R_i = R;
        R_i( : , i ) = ones( n , 1 );
        rho=trace(W^2*R_i);
        tau=trace(W*R_i);
        if tau~=0
            nd(i)=rho/tau;
        else
            nd(i)=0;
        end
        
    end
    
    metric = mean(nd);
    
    
end

end