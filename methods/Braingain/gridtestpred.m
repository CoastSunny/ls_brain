k=1;
%S.default.train_classifier('classes',{{0};{1}},'channels',1:10,'freqband',[0.1 10],'Cs',[5.^(3:-1:-3) 0]);
tmp=S.default.train_classifier('classes',{{0};{1}},'channels',1:10,'freqband',[0.1 10],'vis','off','calibrate',[],'balYs',0,'sorti','yes'); 
rate(j,k)=tmp.rate;
S.default.test.res.opt.Ci
%out1=S.default.apply_classifier(S.default,'classes',{{10};{11}});
%out2=S.default.apply_classifier(S.default,'classes',{{20};{21}});

out1=S.default.apply_classifier(S.default,'classes',{{10};{11}},'sorti','yes','channels',1:10,'freqband',[0.1 10]);
out2=S.default.apply_classifier(S.default,'classes',{{20};{21}},'sorti','yes','channels',1:10,'freqband',[0.1 10]);  

%test1_idxs=find(S.default.markers>9 & S.default.markers<12);
%test2_idxs=find(S.default.markers>19 & S.default.markers<22);
test1_idxs=find(S.default.markers==10 | S.default.markers==11);
test2_idxs=find(S.default.markers==20 | S.default.markers==21);

selections=find(S.default.markers==241);
selections1=selections(1:12);
selections2=selections(13:24);

f1=out1.fraw;
f2=out2.fraw;
begtest1=test1_idxs(1);
begtest2=test2_idxs(1);
s1=diff(selections1)-1;
s1=[75 s1'];
s2=diff(selections2)-1;
s2=[75 s2'];
t1l=[];t2l=[];
f1s=[];
test1=dv2pred(f1,s1,GRID_LETTERS);
test2=dv2pred(f2,s2,GRID_LETTERS);


test1.tl
r1=predtorate(test1.ip,'zoeken',GRID_LETTERS)
test2.tl
r2=predtorate(test2.ip,'jaguar',GRID_LETTERS)


