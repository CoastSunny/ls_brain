clear all
mtype=[];
iters=10;
noise_values(1)=1;
Nodes=[16 32 64 128];

for j=1:numel(Nodes)
    nodes=Nodes(j);
    nel=nodes*(nodes-1)/2;
    for i=1:iters
        clear M
        [W We]=wHub(nodes,nodes,noise_values(1));
        opts={'true_net',W};
        %%
        mtype=[];
        mtype{1}='clust';
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},opts);
            Me{k}=ls_network_metric(We,mtype{k},opts);
        end
        
        [west , m , it , dclu]=optimise_network_multi(We,mtype,M,opts);
        tmp=1/nel*[norm(W-west,'fro') norm(W-We,'fro')];
        Mclu{i,j}={{m{end}} {M{:}} {Me{:}}};
        Eclu(:,i,j)=tmp;
        wclu=west;
        
        clear M
        mtype=[];
        mtype{1}='deg';
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},opts);
            Me{k}=ls_network_metric(We,mtype{k},opts);
        end
        
        [west , m , it , ddeg]=optimise_network_multi(We,mtype,M,opts);
        tmp=1/nel*[norm(W-west,'fro') norm(W-We,'fro')];
        Mdeg{i,j}={{m{end}} {M{:}} {Me{:}}};
        Edeg(:,i,j)=tmp;
        wdeg=west;
        
        clear M
        mtype=[];
        mtype{1}='trans';
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},opts);
            Me{k}=ls_network_metric(We,mtype{k},opts);
        end
        
        [west , m , it , dtrans]=optimise_network_multi(We,mtype,M,opts);
        tmp=1/nel*[norm(W-west,'fro') norm(W-We,'fro')];
        Mtrans{i,j}={{m{end}} {M{:}} {Me{:}}};
        Etrans(:,i,j)=tmp;
        wtrans=west;
        
        clear M
        mtype=[];
        mtype{1}='avndeg';
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},opts);
            Me{k}=ls_network_metric(We,mtype{k},opts);
        end
        
        [west , m , it , davndeg]=optimise_network_multi(We,mtype,M,opts);
        tmp=1/nel*[norm(W-west,'fro') norm(W-We,'fro')];
        Mavndeg{i,j}={{m{end}} {M{:}} {Me{:}}};
        Eavndeg(:,i,j)=tmp;
        wavndeg=west;
        
        clear M
        mtype=[];
        mtype{1}='trans';
        mtype{2}='clust';
        mtype{3}='avndeg';
        mtype{4}='deg';
        for k=1:numel(mtype)
            M{k}=ls_network_metric(W,mtype{k},opts);
            Me{k}=ls_network_metric(We,mtype{k},opts);
        end
        
        [west , m , it , dall]=optimise_network_multi(We,mtype,M,opts);
        tmp=1/nel*[norm(W-west,'fro') norm(W-We,'fro')];
        Mall{i,j}={{m{end}} {M{:}} {Me{:}}};
        Eall(:,i,j)=tmp;
        wall=west;
        %%
        RESconv{i,j}={{W} {We} {wclu} {wdeg} {wtrans} {wavndeg} {wall}...
            {dclu} {ddeg} {dtrans} {davndeg} {dall} ...
            {Eclu} {Edeg} {Etrans} {Eavndeg} {Eall} ...
            {Mclu} {Mdeg} {Mtrans} {Mavndeg} {Mall} };
        fprintf(num2str(i))
    end
end
%i=1;j=5;figure,subplot(2,2,1),imagesc(RES{i,j}{1}{1}),title('original'),subplot(2,2,2),imagesc(RES{i,j}{2}{1}),title('noisy'),subplot(2,2,3),imagesc(RES{i,j}{3}{1}),title('one measure'),subplot(2,2,4),imagesc(RES{i,j}{4}{1}),title('four measures')










