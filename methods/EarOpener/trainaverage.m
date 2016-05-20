G=APLO2;


members=sort(properties(G));
for k=1:3%numel(members)
    
    S=G.(members{k}).copy;
    S.default.train_classifier('trials','all','classes',{{22};{16}},'channels',1:64,'time',1:64,'blocks_in',1:4,'vis','on','trainav','yes');
    S.default.train_classifier('trials','all','classes',{{22};{16}},'channels',1:64,'time',1:64,'blocks_in',1:4,'vis','on','trainav','no');
    
end
