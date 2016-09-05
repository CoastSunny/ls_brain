figure,
for i=1:6
    subplot(2,3,i),hold on, if i<6; title(['period ' num2str(i)]); end;
    plot(Fp{1,1}{4}(:,i),'b')
    plot(Fp{3,1}{4}(:,i),'r')
%     plot(Fp{4,1}{4}(:,i),'g')
    
end