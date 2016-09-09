function [metric,numer,denom] = ls_network_metric(W,metric_type,varargin)

n=size(W,1);
O=ones(n);
H=O-eye(n);

if any(strcmp(metric_type,{'trans' 'transitivity'}))
    
    alfa=trace(W^3);
    beta=trace(W*H*W);
    metric=alfa/beta;
    
elseif any(strcmp(metric_type,{'clust' 'clustering'}))
    
    gamma=diag(W^3);
    zeta=diag(W*H*W);
    idx_to_remove=find(zeta==0);
    metric=(gamma./zeta);
    metric(idx_to_remove)=0;
    
    numer=gamma;denom=zeta;
    
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
    
     W(W<0)=0;  
 W=abs(W);
    metric = sum(W)';
    
elseif any(strcmp(metric_type,{'avndeg' 'average_neighbour_degree'}))
    
    rho=sum(W^2)/n;
    tau=sum(W);
    idx_to_remove=find(tau==0);
    nd=rho./tau;
    nd(idx_to_remove)=0;
    metric = mean(nd);
        
end

end