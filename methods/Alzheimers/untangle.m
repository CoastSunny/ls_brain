for simcool=1:50
clear M1 M2 E dR RE
max_iter=5;
noise_values=0+(0.05:0.05:1.5);
j=10;
nodes=16;
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
REorig=norm(R1orig+R2orig-Wm,'fro');
iter=1;
dR1=Inf;dR2=Inf;
R1=R1orig;
R2=R2orig;
R11=R1;
R22=R2;
R111=R1;
R222=R2;
R1111=R1;
R2222=R2;
check=Inf;
pen=.01;
while ( check>.01 && iter<max_iter) 
R1old=R1;
R2old=R2;

tmp=Wm-R2;tmp(tmp<0)=0;tmp(tmp>1)=1;
tmp1=Wm-R22;tmp1(tmp1<0)=0;tmp1(tmp1>1)=1;
tmp11=Wm-R222;tmp11(tmp11<0)=0;tmp11(tmp11>1)=1;
tmp111=Wm-R2222;tmp111(tmp111<0)=0;tmp111(tmp111>1)=1;

R1 = optimise_network_multi(R1,mtype,M1','constraint',{tmp pen});
R11 = optimise_network_multi(Wm,mtype,M1','constraint',{tmp1 pen});
R111 = optimise_network_multi(tmp11,mtype,M1');
R1111 = optimise_network_multi(tmp111,mtype,M1','constraint',{tmp111 pen});


tmp=Wm-R1;tmp(tmp<0)=0;tmp(tmp>1)=1;
tmp2=Wm-R11;tmp2(tmp2<0)=0;tmp2(tmp2>1)=1;
tmp22=Wm-R111;tmp22(tmp22<0)=0;tmp22(tmp22>1)=1;
tmp222=Wm-R1111;tmp222(tmp222<0)=0;tmp222(tmp222>1)=1;

R2 = optimise_network_multi(R2,mtype,M2','constraint',{tmp pen});
R22 = optimise_network_multi(Wm,mtype,M2','constraint',{tmp2 pen});
R222 = optimise_network_multi(tmp22,mtype,M2');
R2222 = optimise_network_multi(tmp222,mtype,M2','constraint',{tmp222 pen});

dR1=norm(R1-R1old,'fro');
dR2=norm(R2-R2old,'fro');
tmp=[norm(R1-W1,'fro') norm(R11-W1,'fro') norm(R111-W1,'fro') norm(R1111-W1,'fro')...
    norm(R2-W2,'fro') norm(R22-W2,'fro') norm(R222-W2,'fro') norm(R2222-W2,'fro')];
dR(iter,:)=[dR1 dR2];
E(iter,:)=tmp;
RE(iter,:)=[norm(R1+R2-Wm,'fro') norm(R11+R22-Wm,'fro')...
    norm(R111+R222-Wm,'fro') norm(R1111+R2222-Wm,'fro')];
check=RE(iter,1);
iter=iter+1;
iter
end

SIMCOOL{simcool}={{Eorig} {E} {RE} {dR} {REorig} {W1} {W2} {R1} {R2} {R1orig} {R2orig}};

end











































