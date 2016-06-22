clear Fp Ip Exp Concp Et Gt Ext
for comps=2:10

for q = 1:length(Conn_full)
      
    Y=Conn_full{q};
    Options=.01;
    [Fp{q,comps},Ip(q,comps),Exp(q,comps),e,Concp(q,comps)]=parafac(Y,comps,Options,[0 0 0]);
    [Ft{q,comps},Gt{q,comps},Ext(q,comps)]=tucker(Y,[comps comps -1],Options,[0 0 -1]);
    
    
end

end

G1.Fp=Fp;
G1.Ft=Ft;
G1.Exp=Exp;
G1.Ext=Ext;
G1.Concp=Concp;
G1.Gt=Gt;

clear Fp Ip Exp Concp Et Gt Ext
for comps=2:10

for q = 1:length(Conn_full)
      
    Y=Conn_full{q};
    Options=.01;
    [Fp{q,comps},Ip(q,comps),Exp(q,comps),e,Concp(q,comps)]=parafac(Y,comps,Options,[0 3 0]);
    [Ft{q,comps},Gt{q,comps},Ext(q,comps)]=tucker(Y,[comps comps -1],Options,[0 4 -1]);
    
    
end

end

G2.Fp=Fp;
G2.Ft=Ft;
G2.Exp=Exp;
G2.Ext=Ext;
G2.Concp=Concp;
G2.Gt=Gt;