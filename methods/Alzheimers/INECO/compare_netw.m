Fp=Fpd08c2;
calc_allCx2_mci_netw

for ji=1:numel(Ps)

    pQd(:,ji)=Fp{Ps(ji)}{1}(:,ci);
    
end
Fp=Fpt15c2;
calc_allCx2_mci_netw

for ji=1:numel(Ps)

    pQt15(:,ji)=Fp{Ps(ji)}{1}(:,ci);
    
end

Fp=Fpt075c2;
calc_allCx2_mci_netw

for ji=1:numel(Ps)

    pQt075(:,ji)=Fp{Ps(ji)}{1}(:,ci);
    
end

% Fp=Fpt2c2;
% calc_allCx2_mci_netw
% 
% for ji=1:numel(Ps)
% 
%     pQt2(:,ji)=Fp{Ps(ji)}{1}(:,ci);
%     
% end
% Fp=Fpt3c2;
% calc_allCx2_mci_netw
% 
% for ji=1:numel(Ps)
% 
%     pQt3(:,ji)=Fp{Ps(ji)}{1}(:,ci);
%     
% end
% Fp=Fpt075c2;
% calc_allCx2_mci_netw
% 
% for ji=1:numel(Ps)
% 
%     pQt4(:,ji)=Fp{Ps(ji)}{1}(:,ci);
%     
% end

Fp=Fporig;
calc_allCx2_mci_netw

for ji=1:numel(Cb)

    cQo(:,ji)=Fp{Cb(ji)}{1}(:,ci);
    
end
for ji=1:numel(Ps)

    pQo(:,ji)=Fp{Ps(ji)}{1}(:,ci);
    
end

PQd=mean(pQd,2);
PQt15=mean(pQt15,2);
PQt075=mean(pQt075,2);
% PQt2=mean(pQt2,2);
% PQt3=mean(pQt3,2);
% PQt4=mean(pQt4,2);
PQo=mean(pQo,2);
CQo=mean(cQo,2);

% Rc=[norm(PQo-CQo) norm(PQd-CQo) norm(PQt15-CQo) norm(PQt2-CQo) norm(PQt3-CQo)];
Rc=[norm(PQo-CQo)  norm(PQt075-CQo) norm(PQt15-CQo) norm(PQd-CQo) ]






