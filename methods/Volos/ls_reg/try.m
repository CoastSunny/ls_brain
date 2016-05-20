clear G
G=Group;
G.addprop('APLO1');
G.addprop('APLO2');
G.addprop('APLO3');
G.APLO1=APLO1;
G.APLO2=APLO2;
G.APLO3=APLO3;

subjects={'APLO1' 'APLO2' 'APLO3'};
days={'d1' 'd2' 'd3'};
day=1;

for i=1:numel(subjects)

    G.(subjects{i}).(days{day}).default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'channels',38,'time',1:64,'Cs',0)    
    W{i}=G.(subjects{i}).(days{day}).default.test.W;
    
end


