for j=1:3
    Uf{j}=[];Ufc{j}=[];
end
Us=[];Gs=[];
sels=1:6;self=1:6;selt=1:6;
for i=Itest
    
    [Us{i},Gs{i}]=tucker(cat(4,fxA{i},frxA{i}),[numel(sels) numel(self) numel(selt) -1],[],[0 0 0 0]);
    
    for j=1:3 
        Uf{j}=cat(2,Uf{j},Us{i}{j});
    end
    
end

for i=Itest
    
    [Uc{i},Gc{i}]=tucker(cat(4,cat(1,fxA{i},fxiA{i}),cat(1,frxA{i},frxiA{i})),[numel(sels) numel(self) numel(selt) -1],[],[0 0 0 0]);
    
    for j=1:3 
        Ufc{j}=cat(2,Uf{j},Us{i}{j});
    end
    
end


