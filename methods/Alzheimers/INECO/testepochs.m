aa=[];bb=[];
figure, 
for j=1:6
for i=1:64
    
    aa(j,i,:)=Fp{1,i}{4}(:,j);
    bb(j,i,:)=Fp{5,i}{4}(:,j);
    cc(j,i,:)=Fp{10,i}{4}(:,j);

end

subplot(2,3,j),hold on, if j<6; title(['period ' num2str(j)]); end;
plot(squeeze(mean(aa(j,:,:),2)),'b'),
plot(squeeze(mean(bb(j,:,:),2)),'r'), 
plot(squeeze(mean(cc(j,:,:),2)),'g')
xlim([1 5]),ylim([0.3 0.5])
end
