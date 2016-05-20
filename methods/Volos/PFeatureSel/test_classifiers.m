
for i=1:64
    
    outr{i}=S.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,...
        'time',1:64,'channels',Ir(1:i),'freqband',[.5 13]);
    outp{i}=S.default.train_classifier('classes',{{14};{20}},'blocks_in',1:4,...
        'time',1:64,'channels',Ip(1:i),'freqband',[.5 13]);
    
end

for i=1:64
   
    Rr(i)=outr{i}.rate;
    Rp(i)=outp{i}.rate;
    
end