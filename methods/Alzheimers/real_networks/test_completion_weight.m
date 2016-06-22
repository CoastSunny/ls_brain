% read_usair
% read_bible
% read_celegans
read_baywet
clear Res E Prec M dPrec dPrec2 dPrec3 fPrec dPrec4 Prec2 Prec3
Worig=W;

mtype=[];
mtype{1}='deg';
%     mtype{2}='clust';
%     mtype{3}='deg';
%     mtype{4}='avndeg';

for k=1:numel(mtype)
    M{k}=ls_network_metric(W,mtype{k});
end

iters=5;

nodes=size(W,1);

permi=[.05];
l=0.1;
for j=1:numel(permi)
    
    for i=1:iters
        
        W=Worig;                
        struc=zeros(nodes);
        
        no_missing=round(nodes*permi(j));               
        idx_upper = find(triu(ones(nodes)));
        idx_diag = find(eye(nodes));
        idx = setdiff(idx_upper,idx_diag);
        
        tmp=randperm(numel(idx));
        no_el=round(permi(j)*numel(idx));
        idx_probe=idx(tmp(1:no_el));
             
        [row col] = ind2sub( [nodes,nodes] , idx_probe );
        
        for ii=1:numel(row)
            W(row(ii),col(ii))=0.25;
            W(col(ii),row(ii))=W(row(ii),col(ii));
            struc(row(ii),col(ii))=1;
            struc(col(ii),row(ii))=struc(row(ii),col(ii));
        end
        
        Winit=W;
        [c , m , it]=optimise_network_multi(Winit,mtype,...
            M','modules',[],'structure',struc,'learn',l);
        
        tmp=Worig-c;
        idx_struc=find(struc);
        e=mean(abs(tmp(idx_struc))); 
        idx_lstruc=find(struc>0 & Worig>0);       
        el=mean(abs(tmp(idx_lstruc)));
        tmpinit=Worig-Winit;
        ei=mean(abs(tmpinit(idx_struc))); 
        eli=mean(abs(tmpinit(idx_lstruc)));
        E(:,i,j)=[e el ei eli];
        %     Eccc(:,i,j)=mean(e);
        RESc{i,j}={{Worig} {Winit} {c} {struc} {M} {m(:,end)}};
        i
        
        
    end
end

%         struc=zeros(nodes);
%         idx=find(bm>0);
%         tmp=randperm(numel(idx));
%         no_el=round(permi(j)*numel(idx));
%         mis_idx=idx(tmp(1:no_el));
%         [row col]=ind2sub([nodes,nodes],mis_idx);
%         for jj=1:numel(row)
%             struc(row(jj),col(jj))=1;
%             W(row(jj),col(jj))=0.5;
%         end
%         Winit=W;











