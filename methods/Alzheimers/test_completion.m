mtype=[];

clear Ec RESc
iters=5;
E1=zeros(2,iters,numel(noise_values));
E2=zeros(2,iters,numel(noise_values));
E3=zeros(2,iters,numel(noise_values));

nodes=32;
modules=4;
[bm , mods] = random_modular_graph(nodes,modules,1,.90);
mod_matrix = ind2mod(mods,bm);
struc=zeros(nodes);
for j=1:5
    idx(1,:)=[1 2];
    idx(2,:)=[1 3];
    idx(3,:)=[1 4];
    idx(4,:)=[1 10];
    idx(5,:)=[1 11];
    
    for i=1:iters
        
        [W]=ls_bin2wei(bm,0,1);
        Worig=W;
        mtype=[];
        mtype{1}='trans';
        mtype{2}='clust';
        mtype{3}='modul';
        mtype{4}='deg';
        
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},'modules',mod_matrix,'structure',bm);
        end
        for jj=1:j
            struc(idx(jj,1),idx(jj,2))=1;
            struc(idx(jj,2),idx(jj,1))=1;
            W(idx(jj,1),idx(jj,2))=0.5;
            W(idx(jj,2),idx(jj,1))=0.5;
        end
        [c , m , it]=optimise_network_multi(W,mtype,...
            M','modules',mod_matrix,'structure',struc);
        
        
        Ec(:,i,j)=[norm(Worig-c,'fro') ];
        RESc{i,j}={{Worig} {c}};
        i
    end
end











