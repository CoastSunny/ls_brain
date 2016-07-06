mtype=[];
noise_values=0+(0.05:0.15:1.5);
clear Ec RESc Ecc E M Me Es
iters=50;
%  read_usair
% read_bible
read_celegans
Mods=[];
%  read_baywet
% getWM
Worig=weight_conversion(W,'normalize');
% Worig=W;
nodes=size(W,1);
permi=[0.025 0.05 0.1 0.15 0.2 0.25];
l=1;
for j=1:numel(permi)
    
    for i=1:iters
        
        %         [W]=ls_bin2wei(bm,0,1);
        W=Worig;
        struc=zeros(nodes);
        idx=find(triu(ones(nodes)) & ~eye(nodes));
        tmp=randperm(numel(idx));
        no_el=round(permi(j)*numel(idx));
        mis_idx=idx(tmp(1:no_el));
        [row col]=ind2sub([nodes,nodes],mis_idx);
        for jj=1:numel(row)
            struc(row(jj),col(jj))=1;
            struc(col(jj),row(jj))=1;
            W(row(jj),col(jj))=0;
            W(col(jj),row(jj))=W(row(jj),col(jj));
        end
        Winit=W;
        prior=1-sum(sum(Worig>0))/numel(Worig);
        
        mtype=[];
        mtype{1}='trans';
        %         mtype{2}='trans';
        %         mtype{3}='avndeg';
        %         mtype{4}='trans';
        for k=1:numel(mtype)
            M{k}=ls_network_metric(Worig,mtype{k},'modules',Mods);
            Me{k}=ls_network_metric(W,mtype{k},'modules',Mods);
        end
        [c , m , it ]=optimise_network_multi(Winit,mtype,...
            M','modules',Mods,'structure',struc,'learn',l);
        
        co=c;
        tmp=find(c.*struc>0);
        [val idxc]=sort(c(tmp));
        
        a=tmp(idxc(1:round(numel(val)*prior)));
        c(a)=0;
        tmp=Worig-co;
        idx_struc=find(struc);
        e=mean(abs(tmp(idx_struc)));
        tmp2=Worig-c;
        e2=mean(abs(tmp2(idx_struc)));
        idx_lstruc=find(struc>0 & Worig>0);
        idx_nstruc=find(struc>0 & Worig==0);
        
        el=mean(abs(tmp(idx_lstruc)));
        el2=mean(abs(tmp2(idx_lstruc)));
        en=mean(abs(tmp(idx_nstruc)));
        en2=mean(abs(tmp2(idx_nstruc)));
        tmpinit=Worig-Winit;
        ei=mean(abs(tmpinit(idx_struc)));
        eli=mean(abs(tmpinit(idx_lstruc)));
        eni=mean(abs(tmpinit(idx_nstruc)));
        E(:,i,j)=[e el en 666 e2  el2  en2 666 ei eli eni];
        Es(:,i,j)=[norm(tmp,'fro') norm(tmp2,'fro') norm(tmpinit,'fro')];
        %     Eccc(:,i,j)=mean(e);
        RESc{i,j}={{Worig} {Winit} {c} {struc} {M} {m(:,end)}};
        fprintf(num2str(i));
    end
    Es
    
    
end









