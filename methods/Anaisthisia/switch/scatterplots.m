
figure,subplot(3,2,1),hold on
for si=1:10
   
    q=mean(wtYYY(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b');
    q=mean(wtZZZ(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b*');
        
end
axis([0.15 0.45 0.2 0.5])
xlabel('ERD'),ylabel('ERS')
subplot(3,2,2),hold on
for si=1:10
   
    q=mean(whYYY(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b');
    q=mean(whZZZ(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b*');
        
end
axis([0.15 0.45 0.2 0.5])
xlabel('ERD'),ylabel('ERS')
subplot(3,2,3),hold on
for si=1:10
   
    q=mean(ntYYY(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b');
    q=mean(ntZZZ(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b*');
        
end
axis([.002 .015 0.002 0.015])
xlabel('ERD'),ylabel('ERS')
subplot(3,2,4),hold on
for si=1:10
   
    q=mean(nhYYY(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b');
    q=mean(nhZZZ(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b*');
        
end

axis([.002 .015 0.002 0.015])
xlabel('ERD'),ylabel('ERS')
subplot(3,2,5),hold on
for si=1:10
   
    q=mean(vtYYY(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b');
    q=mean(vtZZZ(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b*');
        
end
axis([0.8 4 0.7 4])
xlabel('ERD'),ylabel('ERS')
subplot(3,2,6),hold on
for si=1:10
   
    q=mean(vhYYY(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b');
    q=mean(vhZZZ(1:2,:,:,si),2);
    scatter(mean(q(:,:,1)),mean(q(:,:,2)),'b*');
        
end

axis([0.8 4 0.7 4])
xlabel('ERD'),ylabel('ERS')