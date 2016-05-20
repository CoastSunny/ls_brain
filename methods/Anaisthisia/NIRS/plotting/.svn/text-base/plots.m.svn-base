suba=[1:2 4:7];
subb=[1:7];
names={ 'mean' 'C4' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11'};
%names={ 'mean' 'T2' 'T3' 'T4' 'T5' 'T6' 'T9' 'T10'};

figure,hold on,title('actual movement-ch(a)'),grid
set(gca,'Ytick',[-5 0 5 10 15 20 25 30 ])
set(gca,'YTickLabel',names);

for j=suba

for i=1:12
    plot(tp,Pl(j).ama(:,:,i)+5*(j-1))
end
   plot(tp,mean(Pl(j).ama(:,:,:),3)+5*(j-1),'r','LineWidth',2); 
end
MAM=0;
for j=suba
    for i=1:12
        MAM=MAM+Pl(j).ama(:,:,i);
    end

end
MAM=MAM/(numel(suba)*12);
plot(tp,(10*MAM-5),'r','LineWidth',3)

figure,hold on,title('imaginary movement-ch(a)'),grid
set(gca,'Ytick',[-5 0 5 10 15 20 25 30 ])
set(gca,'YTickLabel',names);

for j=suba

for i=1:12
    plot(tp,Pl(j).ima(:,:,i)+5*(j-1))
end
  plot(tp,mean(Pl(j).ima(:,:,:),3)+5*(j-1),'r','LineWidth',2); 
end
MIM=0;
for j= suba
    for i=1:12
        MIM=MIM+Pl(j).ima(:,:,i);
    end

end
MIM=MIM/(numel(suba)*12);
plot(tp,(10*MIM-5),'r','LineWidth',3)

figure,hold on,title('no movement-ch(a)'),grid
set(gca,'Ytick',[-5 0 5 10 15 20 25 30 ])
set(gca,'YTickLabel',names);

for j=suba

for i=1:12
    plot(tp,Pl(j).noma(:,:,i)+5*(j-1))
end
    plot(tp,mean(Pl(j).noma(:,:,:),3)+5*(j-1),'r','LineWidth',2); 
end
MNOM=0;
for j=suba
    for i=1:12
        MNOM=MNOM+Pl(j).noma(:,:,i);
    end

end
MNOM=MNOM/(numel(suba)*12);
plot(tp,(10*MNOM-5),'r','LineWidth',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



figure,hold on,title('actual movement-ch(b)'),grid
set(gca,'Ytick',[-5 0 5 10 15 20 25 30 ])
set(gca,'YTickLabel',names);

for j=subb

for i=1:12
    plot(tp,Pl(j).amb(:,:,i)+5*(j-1))
end
    plot(tp,mean(Pl(j).amb(:,:,:),3)+5*(j-1),'r','LineWidth',2); 
end
MAM=0;
for j=subb
    for i=1:12
        MAM=MAM+Pl(j).amb(:,:,i);
    end

end
MAM=MAM/(numel(subb)*12);
plot(tp,(10*MAM-5),'r','LineWidth',3)

figure,hold on,title('imaginary movement-ch(b)'),grid
set(gca,'Ytick',[-5 0 5 10 15 20 25 30 ])
set(gca,'YTickLabel',names);

for j=subb

for i=1:12
    plot(tp,Pl(j).imb(:,:,i)+5*(j-1))
end
    plot(tp,mean(Pl(j).imb(:,:,:),3)+5*(j-1),'r','LineWidth',2); 
end
MIM=0;
for j=subb
    for i=1:12
        MIM=MIM+Pl(j).imb(:,:,i);
    end

end
MIM=MIM/(numel(subb)*12);
plot(tp,(10*MIM-5),'r','LineWidth',3)

figure,hold on,title('no movement-ch(b)'),grid
set(gca,'Ytick',[-5 0 5 10 15 20 25 30 ])
set(gca,'YTickLabel',names);

for j=subb

for i=1:12
    plot(tp,Pl(j).nomb(:,:,i)+5*(j-1))
end
   plot(tp,mean(Pl(j).nomb(:,:,:),3)+5*(j-1),'r','LineWidth',2); 
end
MNOM=0;
for j=subb
    for i=1:12
        MNOM=MNOM+Pl(j).nomb(:,:,i);
    end

end
MNOM=MNOM/(numel(subb)*12);
plot(tp,(10*MNOM-5),'r','LineWidth',3)



