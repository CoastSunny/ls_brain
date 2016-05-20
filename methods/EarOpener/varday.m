G=APLO3;

G.d1.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64)
G.d2.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64)
G.d3.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64)
W11=G.d1.default.test.W;
[U S V] = svd(W11);
s=diag(S);
v(1)=s(1)^2/sum(s.^2);
W12=G.d2.default.test.W;
[U S V] = svd(W12);
s=diag(S);
v(2)=s(1)^2/sum(s.^2);
W13=G.d3.default.test.W;
[U S V] = svd(W13);
s=diag(S);
v(3)=s(1)^2/sum(s.^2);
v