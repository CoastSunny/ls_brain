function v=G2v(G)

 idx_toremove      = find(tril(ones(size(G))));
 tmp=G;
 tmp(idx_toremove) = [];
 v=tmp;