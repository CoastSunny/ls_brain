
tmp={'d1' 'd2' 'd3' };

for i=1:numel(tmp)
    
a=APLO3.(tmp{i}).default.train_classifier('Cs',[],'calibrate','cr','classes',{{14};{20}},'blocks_in',1:4,'time',1:64,'channels',1:64);

fp=a.f(a.labels==1);
fn=a.f(a.labels==-1);
pp=1./(1+exp(-fp));
pn=1./(1+exp(-fn));

f=@(x)(1./(1+exp(-x)));
t=-10:0.01:10;

figure,hold,plot(t,f(t)),grid
plot(fp,pp,'ro');

figure,hold,plot(t,f(t)),grid
plot(fn,pn,'go');

end