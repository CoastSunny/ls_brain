
noise_values=0+(0.05:0.15:1.5);
clear E1 E2 E3  M1 M2 M3 f
iters=1;
E1=zeros(2,iters,numel(noise_values));
E2=zeros(2,iters,numel(noise_values));
E3=zeros(2,iters,numel(noise_values));


nodes=16;
modules=2;
[bm , mods] = random_modular_graph(nodes,modules,1,.90);
nel=numel(bm);
mod_matrix = ind2mod(mods,bm);
H=ones(nodes)-eye(nodes);
[W, We]=ls_bin2wei(bm,noise_values(1),1);


mtype=[];
mtype{1}='modul';
opts={'modules',mod_matrix,'structure',bm};

for k=1:numel(mtype)
    
    K{k}=ls_network_metric(W,mtype{k},opts);
    
end

sig=0.01;
R=zeros(nodes);
E=zeros(nodes);
R(:,3)=1;
We(:,:,1)=W;
f(1,:)=ls_network_metric(We(:,:,1),mtype,opts);
g=@(t,f,fs,T) sin(2*pi*f/fs*(t-T));
for dt=2:400
    
  
    if dt<100
        E=sig*0*randn(nodes).*bm;
    else
%         E = sig * ( R * g(dt,1,100,100)+ 1 * randn(nodes) ) .*bm;
        E(1,15)=sig*g(dt,1,100,100);
%         E(1,14)=sig*g(dt,2,100,100);
    end
    e(:,:,dt)=E+E.';
    We( : , : , dt ) = We(:,:,dt-1) + (E+E.') ;
    tmp=We(:,:,dt);
    tmp(tmp<0)=0;tmp(tmp>1)=1;
    We(:,:,dt)=tmp;
    f(dt,:)=ls_network_metric(We(:,:,dt),mtype,opts);    
    
end
df=diff(f);
close all
figure,plot(f-mean(f)),hold on,plot(df)
We(:,:,end)










