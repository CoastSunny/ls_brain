function Phi = singen(f,nS_per_hop,total_samples)

blocks=total_samples/nS_per_hop/numel(f);
count=0;
f=repmat(f,1,blocks);
   
for i=1:numel(f)
    
    if i>1
    Dphi(i) = ( f(i) - f(i-1) ) * (i-1) * nS_per_hop;
    cDphi=cumsum(Dphi);
    phi(i,:) = f(i) * ( ( i-1 ) * nS_per_hop  : ( i-1 ) * nS_per_hop + nS_per_hop - 1 )...
        -cDphi(end) ;   
    else 
        phi(i,:) = f(i) * ( ( i-1 ) * nS_per_hop  : ( i-1 ) * nS_per_hop + nS_per_hop - 1);
    end
    
end
phi=phi';
Phi=2*pi*phi(:);

end