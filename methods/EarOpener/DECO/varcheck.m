t=(1:307)/512;

chann=32;%Cz
for cond=4

VJ=0;
for i=1:8
   
    VJ=VJ+V{i}{chann}{cond};
    
end
VJ=VJ/8;
VD=0;
for i=9:16
    
    VD=VD+V{i}{chann}{cond};
    
end
VD=VD/8;
figure,plot(t,VD-VJ)
figure,plot(t,VD-mean(VD)-VJ+mean(VJ),'g')

end

cond=11;
figure,hold on
for i=1:16
    if i<9
        plot(t,V{i}{chann}{cond})
    else
        plot(t,V{i}{chann}{cond},'r')
    end
end