mtype=[];
noise_values=0+(0.05:0.15:1.5);
clear E1 E2 E3  M1 M2 M3 f
iters=1;
E1=zeros(2,iters,numel(noise_values));
E2=zeros(2,iters,numel(noise_values));
E3=zeros(2,iters,numel(noise_values));


nodes=6;
modules=2;
H=ones(nodes)-eye(nodes);
[W,We]=wHub(nodes,nodes,noise_values(1));

mtype=[];
mtype{1}='avndeg';


for k=1:numel(mtype)
    
    K{k}=ls_network_metric(W,mtype{k});
    
end

sig=0.01;
R=zeros(nodes);
R(:,3)=1;
We(:,:,1)=W;
f(1,:)=ls_network_metric(We(:,:,1),mtype);

for dt=2:400
    
    E = sig * lagmatrix(eye( nodes ),1) .* randn( nodes );
    E = (sig * randn(nodes) .* R) .*H;
    if dt<100
        E=sig*randn(nodes).*H;
    else
        E = sig * ( R +  randn(nodes) ) .*H;
    end
    We( : , : , dt ) = We(:,:,dt-1) + (E+E.') ;
    We(We<0)=0;We(We>1)=1;
    f(dt,:)=ls_network_metric(We(:,:,dt),mtype);
    
end
plot(f)
We(:,:,end)










