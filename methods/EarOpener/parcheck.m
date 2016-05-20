
subj={'APLO1' 'APLO2' 'APLO3'};
day={'d1' 'd2' 'd3'};

for ss=1:numel(subj)
    for dd=1:numel(day)
    eval(['s=' subj{ss}]);  
a=s.(day{dd}).default.train_classifier('classes',{{16};{22}},'blocks_in',1:4,'time',1:64,'channels',1:64);
b=s.(day{dd}).default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64);

q1(ss,dd)=mean([a.rate b.rate]);

a=APLO1.d1.default.apply_classifier(s.(day{dd}).default,'classes',{{16};{22}},'blocks_in',1:4,'time',1:64,'channels',1:64,'W',-ones(64,1)*W,'bias',0);
b=APLO1.d1.default.apply_classifier(s.(day{dd}).default,'classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64,'W',-ones(64,1)*W,'bias',0);

q2(ss,dd)=mean([a.rate(3) b.rate(3)]);

    end
end