mtype=[];
noise_values=0+(0.05:0.05:1.5);
clear E1 E2 E3  M1 M2 M3
iters=10;
E1=zeros(2,iters,numel(noise_values));
E2=zeros(2,iters,numel(noise_values));
E3=zeros(2,iters,numel(noise_values));

% for j=1:numel(noise_values)
%     for i=1:iters
%         mtype='trans';
%         [W,We]=wHub(16,16,noise_values(j));
%         [a , m , it]=optimise_network(We,mtype,ls_network_metric(W,mtype));
%
%         tmp=[norm(vec(W)-vec(a)) norm(vec(W)-vec(We))];
%         M1(:,i,j)=[m(end) ls_network_metric(W,mtype) ls_network_metric(We,mtype)];
%         E1(:,i,j)=tmp;
%
%     end
% end
%
% for j=1:numel(noise_values)
%     for i=1:iters
%
%         [W,We]=wHub(16,16,noise_values(j));
%         mtype='trans';
%         [a , m , it]=optimise_network(We,mtype,ls_network_metric(W,mtype));
%         tmp=[norm(vec(W)-vec(a)) norm(vec(W)-vec(We))];
%         M1(:,i,j)=[m(end) ls_network_metric(W,mtype) ls_network_metric(We,mtype)];
%         E1(:,i,j)=tmp;
%
%         mtype='clust';
%         [a , m , it]=optimise_network(a,mtype,ls_network_metric(W,mtype));
%         tmp=[norm(vec(W)-vec(a)) norm(vec(W)-vec(We))]   ;
%         M2(:,i,j)=[m(end) ls_network_metric(W,mtype) ls_network_metric(We,mtype)];
%         E2(:,i,j)=tmp;
%
%         mtype=[];
%         mtype{1}='trans';
%         mtype{2}='clust';
%         [a , m , it]=optimise_network_two(We,mtype,...
%             [ls_network_metric(W,mtype{1}) ;ls_network_metric(W,mtype{2})]);
%
%         tmp=[norm(vec(W)-vec(a)) norm(vec(W)-vec(We))];
%         M3(:,:,i,j)=[m(1,end) ls_network_metric(W,mtype{1}) ls_network_metric(We,mtype{1});...
%             m(2,end) ls_network_metric(W,mtype{2}) ls_network_metric(We,mtype{2})];
%         E3(:,i,j)=tmp;
%
%     end
% end
%



[bm , mods] = random_modular_graph(32,4,1,.90);
mod_matrix = ind2mod(mods,bm);
for j=1:numel(noise_values)
    for i=1:iters
        
        [W, We]=ls_bin2wei(bm,noise_values(j),1);
        mtype=[];
        mtype{1}='modul';
        
        [a , m , it]=optimise_network_multi(We,mtype,{ls_network_metric(W,mtype,...
            'modules',mod_matrix)},'modules',mod_matrix,'structure',bm);
        tmp1=[norm(W-a,'fro') norm(W-We,'fro')];
        M1(:,i,j)=[m(end) ls_network_metric(W,mtype,'modules',mod_matrix)...
            ls_network_metric(We,mtype,'modules',mod_matrix)];
        E1(:,i,j)=tmp1;
        
        mtype=[];
        mtype{1}='trans';
        mtype{2}='clust';
        mtype{3}='modul';
        mtype{4}='deg';
        
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},'modules',mod_matrix,'structure',bm);          
        end
        [b , m , it]=optimise_network_multi(We,mtype,...
            M','modules',mod_matrix,'structure',bm);
        
        tmp2=[norm(W-b,'fro') norm(W-We,'fro')];
        
        M2(:,:,i,j)=[m(1,end) ls_network_metric(W,mtype{1}) ls_network_metric(We,mtype{1});...
            m(2,end) ls_network_metric(W,mtype{2}) ls_network_metric(We,mtype{2});...
            m(3,end) ls_network_metric(W,mtype{3}, 'modules',mod_matrix,'structure',bm)...
            ls_network_metric(We,mtype{3}, 'modules',mod_matrix,'structure',bm)];
        E2(:,i,j)=tmp2;
        RES{i,j}={{W} {We} {a} {b}};
        i
    end
end
%i=1;j=5;figure,subplot(2,2,1),imagesc(RES{i,j}{1}{1}),title('original'),subplot(2,2,2),imagesc(RES{i,j}{2}{1}),title('noisy'),subplot(2,2,3),imagesc(RES{i,j}{3}{1}),title('one measure'),subplot(2,2,4),imagesc(RES{i,j}{4}{1}),title('four measures')










