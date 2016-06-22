read_bible

clear bRes E Prec M dPrec dPrec2 dPrec3 fPrec dPrec4
Worig=W;
iters=100;

mtype=[];
mtype{1}='trans';
for k=1:numel(mtype)
    M{k}=ls_network_metric(W,mtype{k});
end

nodes=size(W,1);

permi=[.1];
j=1;

topL=100;

for i=1:iters
        
       W=Worig;
       
    struc=zeros(nodes);
    S=zeros(nodes);
    dS=zeros(nodes);
    dS2=zeros(nodes);
    dS3=zeros(nodes);
    dS4=zeros(nodes);
    
        
    idx_upper=find(triu(ones(nodes)));
    idx_diag=find(eye(nodes));
    idx=setdiff(idx_upper,idx_diag);
    
    idx_links = find( W>0 & triu(ones(nodes)) );
    idx_nonlinks = find( W==0 & triu(ones(nodes)) & ~eye(nodes) );
    
    tmp=randperm(numel(idx_links));
    no_el=round(permi(j)*numel(idx_links));
    idx_probe=idx_links(tmp(1:no_el));
    
    idx_test=union(idx_probe,idx_nonlinks);
    
    [row col]=ind2sub([nodes,nodes],idx_probe);
    for ii=1:numel(row)
        W(row(ii),col(ii))=0;
        W(col(ii),row(ii))=W(row(ii),col(ii));
        struc(row(ii),col(ii))=1;
        struc(col(ii),row(ii))=struc(row(ii),col(ii));
    end
    
              
    dW=0;
    for k=1:numel(mtype)
        dW=dW+network_gradient_wu(W,mtype{k});
    end
    
    [row col]=ind2sub([nodes,nodes],idx_test);             
    
    for jj=1:numel(row)
        
        idxr=find(abs(W(row(jj),:)>0));
        idxc=find(abs(W(:,col(jj))>0));
        idxn=intersect(idxr,idxc);
        if ~isempty(idxn)
        Sr=sum(W(row(jj),idxn));
        Sc=sum(W(idxn,col(jj)));
        S(row(jj),col(jj))=( Sr + Sc );S(col(jj),row(jj))=S(row(jj),col(jj));
        
        Sr=sum(abs(dW(row(jj),idxn)));
        Sc=sum(abs(dW(idxn,col(jj))));
        dS(row(jj),col(jj))=(( Sr + Sc ));dS(col(jj),row(jj))=dS(row(jj),col(jj));
        dS2(row(jj),col(jj))=numel( idxn );dS2(col(jj),row(jj))=dS2(row(jj),col(jj));
        
        ctmp=corrcoef(dW(row(jj),:), dW(:,col(jj)));
        dS3(row(jj),col(jj))= ctmp(1,2);dS3(col(jj),row(jj))= dS3(row(jj),col(jj));
        end
        
    end
%     
%     dW=weight_conversion(rand(nodes),'normalize');
%     
%     for jj=1:numel(row)
%         
%         idxr=find(abs(W(row(jj),:)>0));
%         idxc=find(abs(W(:,col(jj))>0));
%         idxn=intersect(idxr,idxc);
%         Sr=sum(abs(dW(row(jj),idxn)));
%         Sc=sum(abs(dW(idxn,col(jj))));
%         dS4(row(jj),col(jj))=(( Sr + Sc ));
%         dS4(col(jj),row(jj))=dS(row(jj),col(jj));
%         
%         
%     end
    
    idx_s=find(S>0 & triu(ones(nodes)) & ~eye(nodes));
    [inc id]=sort(S(idx_s));
    tmp=id(end-topL+1:end);
    L=idx_s(tmp);   
    Lr=intersect(idx_probe,L);
    Prec(i,j)=numel(Lr)/numel(L);
    
    idx_s=find(dS>0 & triu(ones(nodes)) & ~eye(nodes));
    [inc id]=sort(dS(idx_s));
    tmp=id(end-topL+1:end);
    L=idx_s(tmp);   
    Lr=intersect(idx_probe,L);
    dPrec(i,j)=numel(Lr)/numel(L);
    
    idx_s=find(dS2>0 & triu(ones(nodes)) & ~eye(nodes));
    [inc id]=sort(dS2(idx_s));
    tmp=id(end-topL+1:end);
    L=idx_s(tmp);   
    Lr=intersect(idx_probe,L);
    dPrec2(i,j)=numel(Lr)/numel(L);
    
    idx_s=find(dS3>0 & triu(ones(nodes)) & ~eye(nodes));
    [inc id]=sort(dS3(idx_s));
    tmp=id(end-topL+1:end);
    L=idx_s(tmp);   
    Lr=intersect(idx_probe,L);
    dPrec3(i,j)=numel(Lr)/numel(L);
   
%     idx_s=find(dS4>0 & triu(ones(nodes)) & ~eye(nodes));
%     [inc id]=sort(dS4(idx_s));
%     tmp=id(end-topL+1:end);
%     L=idx_s(tmp);   
%     Lr=intersect(idx_probe,L);
%     dPrec4(i,j)=numel(Lr)/numel(L);
    
    [inc id]=sort(dS(:) + S(:));
    L=id(end-topL+1:end);
    Lr=intersect(idx_probe,L);
    fPrec(i,j)=numel(Lr)/numel(L);
    
    bRes(i,:)=[Prec(i,j) dPrec(i,j) dPrec2(i,j) dPrec3(i,j) fPrec(i,j)]

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











