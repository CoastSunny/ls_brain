
noise_values=0+(0.05:0.05:.5);
clear E1 E2 M1 M2
iters=20;
E1=zeros(2,iters,numel(noise_values));
E2=zeros(2,iters,numel(noise_values));

for j=1:numel(noise_values)
    for i=1:iters
        mtype='clust';
        [W,We]=wHub(32,32,noise_values(j));
        [a , m , it]=optimise_network(We,mtype,ls_network_metric(W,mtype));

        tmp=[norm(vec(W)-vec(a)) norm(vec(W)-vec(We))];
        M1(:,i,j)=[m(end) ls_network_metric(W,mtype) ls_network_metric(We,mtype)];
        E1(:,i,j)=tmp;

    end
end
% 
% 
% % 
% % [bm , mods] = random_modular_graph(64,8,1,.90);
% % mod_matrix = ind2mod(mods,bm);
% % for j=1:numel(noise_values)
% %     for i=1:20
% %         mtype='modul';
% %         [W, We]=ls_bin2wei(bm,noise_values(j),1);
% %         [a , m , it]=optimise_network(We,mtype,ls_network_metric(W,mtype,...
% %             'modules',mod_matrix),'modules',mod_matrix,'structure',bm);
% %         tmp=[norm(vec(W)-vec(a)) norm(vec(W)-vec(We))];
% %         M1(:,i,j)=[m(end) ls_network_metric(W,mtype,'modules',mod_matrix)...
% %             ls_network_metric(We,mtype,'modules',mod_matrix)];
% %         E1(:,i,j)=tmp;
% % 
% %     end
% % end
