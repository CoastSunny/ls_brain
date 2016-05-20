
G=APLO3;
members=sort(properties(G));
for i=1:3
    S=G.(members{i});
    S.default.train_classifier('trials','all','classes',{{22};{16}},'channels',1:64,'time',1:64,'blocks_in',1:4,'vis','off','trainav','no','calibrate','cr');
    A(i,1)=mean((S.default.test.pp+S.default.test.np)/2);
    A(i,2)=S.default.test.perf;
end
    
    