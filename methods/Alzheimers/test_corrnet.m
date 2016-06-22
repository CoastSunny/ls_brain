
mtype='clust';
n=10;
Xo=mvnrnd(zeros(1,n),eye(n),50 )';
Wo=WfromX(Xo);
mo=ls_network_metric(Wo,mtype);
mo=ls_corrnetwork_metric(Xo,mtype);

idx=1;
tidx=1;

X=Xo;
X(idx,tidx)=X(idx,tidx)+10;
W=WfromX(X);

[Y my ity]=optimise_corrnetwork(X,idx,tidx,{mtype},{mo});
Wy=WfromX(Y);

[Ww mw itw]=optimise_network_multi(W,{mtype},{mo});

tmp=[norm(Wy-Wo,'fro') norm(Ww-Wo,'fro') my{:,end}-mo mw{:,end}-mo ity itw];