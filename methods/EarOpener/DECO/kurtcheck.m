tk=(1:359)/512;

for cond=1:7
KJ=0;
KE=0;
for si=1:8
  
    KJ=KJ+K{si}{cond};
    
end


for si=9:16
  
    KE=KE+K{si}{cond};
    
end
figure,hold on,plot(tk,KJ),plot(tk,KE,'r')

end


    