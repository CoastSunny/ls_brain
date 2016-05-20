
[Factors,G]=tucker(x,[6 6 6]);

figure
for ii=1:size(Factors{1},2)
    
    subplot(2,size(Factors{1},2)/2,ii)
    plot(Factors{1}(:,ii))   
    xlabel('electrode number'),ylabel('amplitude')
end
figure
for ii=1:size(Factors{2},2)
    
    subplot(2,size(Factors{2},2)/2,ii)
    plot((1:65)/200,Factors{2}(:,ii))   
    xlabel('time'),ylabel('amplitude')
end
figure
for ii=1:size(Factors{1},2)
    
    subplot(2,size(Factors{1},2)/2,ii)
    imagesc(G(:,:,ii))
    if ii==1
        cmaplouk=colormap;
    end
   
end
