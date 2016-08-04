for simcool=1:30
clear M1 M2 E dR RE E2 RE2
max_iter=30;
noise_values=0+(0.05:0.15:1.5);
j=10;

nel=nodes*(nodes-1)/2;
rng('shuffle')
degree_target=5;
[bm1] = BAgraph_dir(nodes,degree_target,degree_target);
bm1=bm1+bm1.';
bm1=bm1>0;
rng('shuffle')
[W1, We1]=ls_bin2wei(bm1,noise_values(j),0);

rng('shuffle')
modules=4;
[bm2 , mods] = random_modular_graph(nodes,modules,1,.90);
mod_matrix = ind2mod(mods,bm2);
[W2, We2]=ls_bin2wei(bm2,noise_values(j),1);


mtype=[];
mtype1{1}='trans';
% mtype{2}='avndeg';
% mtype{3}='deg';

for i=1:numel(mtype1)
    M1{i}=ls_network_metric(W1,mtype1{i});  
end

mtype=[];
mtype2{1}='modul';
% mtype{2}='avndeg';
% mtype{3}='deg';

for i=1:numel(mtype2)
    M2{i}=ls_network_metric(W2,mtype2{i},'modules',mod_matrix);  
end
Wm=W1+W2;
% Wm=Wm/max(max(Wm));
l=1;
opts={'learn',l,'structure',[],'modules',mod_matrix};


[R1orig asd it1] = optimise_network_multi(Wm,mtype1,M1',opts);
[R2orig asd it2] = optimise_network_multi(Wm,mtype2,M2',opts);

Eorig=[norm(R1orig-W1,'fro') norm(R2orig-W2,'fro')];
REorig=norm(R1orig+R2orig-Wm,'fro');
iter=1;
dR1=Inf;dR2=Inf;
R1=R1orig;
R2=R2orig;
R12=R1;
R22=R2;
R13=R1;
R23=R2;
R14=R1;
R24=R2;
check=Inf;


while ( check>.001 && iter<max_iter) 
R1old=R1;
R2old=R2;

tmp1=Wm-R2;tmp1(tmp1<0)=0;tmp1(tmp1>1)=1;
% tmp12=Wm-R22;tmp12(tmp12<0)=0;tmp12(tmp12>1)=1;
% tmp13=Wm-R23;tmp13(tmp13<0)=0;tmp13(tmp13>1)=1;
% tmp14=Wm-R24;tmp14(tmp14<0)=0;tmp14(tmp14>1)=1;


R1 = optimise_network_multi(R1,mtype1,M1','constraint',{tmp1 pen},'learn',l);
% R12 = optimise_network_multi(Wm,mtype,M1','constraint',{tmp12 pen},'learn',l);
% R13 = optimise_network_multi(tmp13,mtype,M1','learn',l);
% R14 = optimise_network_multi(tmp14,mtype,M1','constraint',{tmp14 pen},'learn',l);


tmp2=Wm-R1;tmp2(tmp2<0)=0;tmp2(tmp2>1)=1;
% tmp22=Wm-R12;tmp22(tmp22<0)=0;tmp22(tmp22>1)=1;
% tmp23=Wm-R13;tmp23(tmp23<0)=0;tmp23(tmp23>1)=1;
% tmp24=Wm-R14;tmp24(tmp24<0)=0;tmp24(tmp24>1)=1;

R2 = optimise_network_multi(R2,mtype2,M2','constraint',{tmp2 pen},'learn',l,'modules',mod_matrix);
% R22 = optimise_network_multi(Wm,mtype,M2','constraint',{tmp22 pen},'learn',l);
% R23 = optimise_network_multi(tmp22,mtype,M2','learn',l);
% R24 = optimise_network_multi(tmp24,mtype,M2','constraint',{tmp24 pen},'learn',l);

dR1=norm(R1-R1old,'fro');
dR2=norm(R2-R2old,'fro');
tmp=[norm(R1-W1,'fro')...% norm(R12-W1,'fro') norm(R13-W1,'fro') norm(R14-W1,'fro')...
    norm(R2-W2,'fro')];% norm(R22-W2,'fro') norm(R23-W2,'fro') norm(R24-W2,'fro')];
dR(iter,:)=[dR1 dR2];
E(iter,:)=tmp;
RE(iter,:)=[norm(R1+R2-Wm,'fro')];% norm(R12+R22-Wm,'fro')...
    %norm(R13+R23-Wm,'fro') norm(R14+R24-Wm,'fro')];
check=max(dR(iter,:));
iter=iter+1;
fprintf(num2str(iter))
end
% 
% mtype=[];
% mtype{1}='deg';
% % mtype{2}='clust';
% % mtype{2}='trans';
% clear M1 M2
% for i=1:numel(mtype)
%     M1{i}=ls_network_metric(W1,mtype{i});
%     M2{i}=ls_network_metric(W2,mtype{i});
% end
% [R1orig asd it1] = optimise_network_multi(Wm,mtype,M1');
% [R2orig asd it2] = optimise_network_multi(Wm,mtype,M2');
% 
% E2orig=1/nel*[norm(R1orig-W1,'fro') norm(R2orig-W2,'fro')];
% RE2orig=1/nel*norm(R1orig+R2orig-Wm,'fro');
% iter=1;
% dR1=Inf;dR2=Inf;
% R1=R1orig;
% R2=R2orig;
% R12=R1;
% R22=R2;
% R13=R1;
% R23=R2;
% R14=R1;
% R24=R2;
% check=Inf;
% 
% 
% while ( check>.001 && iter<max_iter) 
% R1old=R1;
% R2old=R2;
% 
% tmp1=Wm-R2;tmp1(tmp1<0)=0;tmp1(tmp1>1)=1;
% 
% R1 = optimise_network_multi(R1,mtype,M1','constraint',{tmp1 pen},'learn',l);
% 
% tmp2=Wm-R1;tmp2(tmp2<0)=0;tmp2(tmp2>1)=1;
% 
% 
% R2 = optimise_network_multi(R2,mtype,M2','constraint',{tmp2 pen},'learn',l);
% 
% dR1=norm(R1-R1old,'fro');
% dR2=norm(R2-R2old,'fro');
% tmp=[norm(R1-W1,'fro') ...
%     norm(R2-W2,'fro') ];
% dR(iter,:)=[dR1 dR2];
% E2(iter,:)=1/nel*tmp;
% RE2(iter,:)=1/nel*[norm(R1+R2-Wm,'fro') norm(R12+R22-Wm,'fro')...
%     norm(R13+R23-Wm,'fro') norm(R14+R24-Wm,'fro')];
% check=RE(iter,1);
% iter=iter+1;
% iter
% end
SIMCOOL{simcool}={{Eorig} {E} {RE} {dR} {REorig} {W1} {W2} {R1} {R2} {R1orig} {R2orig}};

end











































