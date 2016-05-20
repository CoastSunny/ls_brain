G=JPsv;
members=properties(G);
classes1={{12};{20}};
classes2={{12};{21}};
classes3={{12};{22}};
for i=1:numel(members)

%      G.(members{i}).default.train_classifier('name','c1220','classes',classes1,'blocks_in',1:10,'channels',1:64,'time',1:64);
%      G.(members{i}).default.train_classifier('name','c1221','classes',classes2,'blocks_in',1:10,'channels',1:64,'time',1:64);
%      G.(members{i}).default.train_classifier('name','c1222','classes',classes3,'blocks_in',1:10,'channels',1:64,'time',1:64);
    clsfr(i).W=G.(members{i}).default.c1220.W;
    [U S V]=svd(clsfr(i).W);
    
    if (abs(max(V(30:40,1)))>abs(min(V(30:40))) && max(V(30:40,1)>0))
        V(:,1)=-V(:,1);
    end
    clsfr(i).V=V(:,1);
    clsfr(i).s=S(1,1)/sum(diag(S).^2);
    clsfr(i).p=max(G.(members{i}).default.c1220.res.tstbin);
    
end

figure,hold
for i=1:numel(members)
plot(clsfr(i).V)
end