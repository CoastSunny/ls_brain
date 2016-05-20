function G=v2G(v)

dims=numel(v);

root=roots([1 -1 -2*dims]);

ch_dim=root(1);

tmpG=ones(ch_dim,ch_dim);

idx_upper=find(triu((tmpG)));
idx_diag=find(diag(1:(ch_dim)));
idx=setdiff(idx_upper,idx_diag);
tmpG(idx)=v;
tmpG=tmpG+tmpG';
tmpG(idx_diag)=0;
G=tmpG;