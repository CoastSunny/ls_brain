mtype=[];
noise_values=0+(0.05:0.15:1.5);
clear Ec RESc Ecc E M
iters=10; 
E1=zeros(2,iters,numel(noise_values));
E2=zeros(2,iters,numel(noise_values));
E3=zeros(2,iters,numel(noise_values));



Nodes=[16 32 64 128];
%  modules=4;
% 
% [bm , mods] = random_modular_graph(nodes,modules,1,.90);
% mod_matrix = ind2mod(mods,bm);
% opts={'modules',mod_matrix,'structure',bm};
for n=1:numel(Nodes)
    nodes=Nodes(n);
permi=[0.025 0.05 0.1 0.15 0.2 0.25];
l=1;
for j=1:numel(permi)
    
    for i=1:iters
        
%         [W]=ls_bin2wei(bm,0,1);
        W=wRand(nodes,0.1);
        Worig=W;
        mtype=[];
        mtype{1}='deg';
        mtype{2}='trans';
        mtype{3}='clust';
%         mtype{4}='trans';
        
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k});
        end
               
        struc=zeros(nodes);
        idx=find(triu(ones(nodes)) & ~eye(nodes));
        tmp=randperm(numel(idx));
        no_el=round(permi(j)*numel(idx));
        mis_idx=idx(tmp(1:no_el));
        [row col]=ind2sub([nodes,nodes],mis_idx);
        for jj=1:numel(row) 
            struc(row(jj),col(jj))=1;
            struc(col(jj),row(jj))=1;
            W(row(jj),col(jj))=0.5;
            W(col(jj),row(jj))=0.5;
        end
        Winit=W;
        [c , m , it]=optimise_network_multi(Winit,mtype,...
            M','modules',[],'structure',struc,'learn',l);
       
        tmp=Worig-c;
        idx_struc=find(struc);
        e=mean(abs(tmp(idx_struc)));
        E(:,i,j,n)=e;
        tmpinit=Worig-Winit;
        Es(:,i,j,n)=[norm(tmp,'fro') norm(tmpinit,'fro')];
        %     Eccc(:,i,j)=mean(e);
        RESc{i,j}={{Worig} {Winit} {c} {struc} {M} {m(:,end)}};
        i
    end
    
end
       

end

for i=1:numel(Nodes)
    
    nodes=Nodes(n);
    res(i,:)=squeeze(mean(E(:,:,:,i),2));    
    
end









