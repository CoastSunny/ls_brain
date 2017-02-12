function v=G2v(G)

 idx_toremove      = find(tril(ones(size(G,1),size(G,2))));
 if numel(size(G))==2
 tmp=G;
 tmp(idx_toremove) = [];
 v=tmp;
 else
     for i=1:size(G,3)
         tmp=G(:,:,i);
         tmp(idx_toremove)=[];
         v(:,i)=tmp;
     end
 end