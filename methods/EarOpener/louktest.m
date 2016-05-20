for i=1:251
    APLO2.d1.default.train_classifier('name','c1420','classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'trials',i:i+49)
    W=APLO2.d1.default.c1420.W;
    [U S V]=svd(W);
    pc(i,:)=V(:,1)';
    if (abs(max(pc(i,20:25)))>abs(min(pc(i,15:25))) & max(pc(i,15:25))>0)
        pc(i,:)=-pc(i,:);
    end
    s=diag(S);
    s=s.^2;
    q(i,1)=max(APLO2.d1.default.c1420.res.tstbin(max(APLO2.d1.default.c1420.res.opt.Ci)));
    q(i,2)=s(1)/sum(s);
end
    