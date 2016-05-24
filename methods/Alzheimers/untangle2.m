for simcool=1:50
clear M1 M2 E dR RE
max_iter=100;
noise_values=0+(0.05:0.05:1.5);
j=10;
nodes=8;
[W1,We1]=wHub(nodes,nodes,noise_values(j));
[W2,We2]=wHub(nodes,nodes,noise_values(j));
W2=We2;
mtype=[];
mtype{1}='trans';
mtype{2}='clust';
mtype{3}='deg';

for i=1:numel(mtype)
    M1{i}=ls_network_metric(W1,mtype{i});
    M2{i}=ls_network_metric(W2,mtype{i});
end

Wm=W1+W2;
% Wm=Wm/max(max(Wm));


R1orig = optimise_network_multi(Wm,mtype,M1');
R2orig = optimise_network_multi(Wm,mtype,M2');
Eorig=[norm(R1orig-W1,'fro') norm(R2orig-W2,'fro')];
iter=1;
dR1=Inf;dR2=Inf;
R1=R1orig;
R2=R2orig;
check=Inf;
while ( check>.05 && iter<max_iter)
R1old=R1;
R2old=R2;
tmp=Wm-R2;tmp(tmp<0)=0;tmp(tmp>1)=1;
R1 = optimise_network_multi(Wm-R2,mtype,M1');%,'net',tmp);
tmp=Wm-R1;tmp(tmp<0)=0;tmp(tmp>1)=1;
R2 = optimise_network_multi(Wm-R1,mtype,M2');%,'net',tmp);
dR1=norm(R1-R1old,'fro');
dR2=norm(R2-R2old,'fro');
tmp=[norm(R1-W1,'fro') norm(R2-W2,'fro')];
dR(iter,:)=[dR1 dR2];
E(iter,:)=tmp;
RE(iter,:)=norm(R1+R2-Wm,'fro');
check=RE(iter,:);
iter=iter+1;
iter
end

SIMCOOL{simcool}={{Eorig} {E} {RE} {dR}};

end












































