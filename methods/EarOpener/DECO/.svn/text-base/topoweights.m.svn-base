jp=1:8;
nl=9:16;
weighlims=[-0.7 0.7];

figure,title('Topoplot of weights difference of /a/')
subplot(1,3,1),jplot(Q,mean(wA60(jp,:)-wA60(nl,:))')
colorbar,caxis(weighlims)
subplot(1,3,2),jplot(Q,mean(wA150(jp,:)-wA150(nl,:))')
colorbar,caxis(weighlims)
subplot(1,3,3),jplot(Q,mean(wA240(jp,:)-wA240(nl,:))')
colorbar,caxis(weighlims)

figure,title('Topoplot of weights difference of /s/')
subplot(1,3,1),jplot(Q,mean(wS60(jp,:)-wS60(nl,:))')
colorbar,caxis(weighlims)
subplot(1,3,2),jplot(Q,mean(wS150(jp,:)-wS150(nl,:))')
colorbar,caxis(weighlims)
subplot(1,3,3),jplot(Q,mean(wS240(jp,:)-wS240(nl,:))')
colorbar,caxis(weighlims)

figure,title('Topoplot of weights difference of /u/')
subplot(1,3,1),jplot(Q,mean(wU60(jp,:)-wU60(nl,:))')
colorbar,caxis(weighlims)
subplot(1,3,2),jplot(Q,mean(wU150(jp,:)-wU150(nl,:))')
colorbar,caxis(weighlims)
subplot(1,3,3),jplot(Q,mean(wU240(jp,:)-wU240(nl,:))')
colorbar,caxis(weighlims)

[ha60 pa60]=ttest2(wA60(jp,:),wA60(nl,:));
[ha150 pa150]=ttest2(wA150(jp,:),wA150(nl,:));
[ha240 pa240]=ttest2(wA240(jp,:),wA240(nl,:));

[hs60 ps60]=ttest2(wS60(jp,:),wS60(nl,:));
[hs150 ps150]=ttest2(wS150(jp,:),wS150(nl,:));
[hs240 ps240]=ttest2(wS240(jp,:),wS240(nl,:));

[hu60 pu60]=ttest2(wU60(jp,:),wU60(nl,:));
[hu150 pu150]=ttest2(wU150(jp,:),wU150(nl,:));
[hu240 pu240]=ttest2(wU240(jp,:),wU240(nl,:));

ttestlims=[0 1];
figure,title('Topoplot of weights difference of /a/')
subplot(1,3,1),jplot(Q,ha60')
colorbar,caxis(ttestlims)
subplot(1,3,2),jplot(Q,ha150')
colorbar,caxis(ttestlims)
subplot(1,3,3),jplot(Q,ha240')
colorbar,caxis(ttestlims)

figure,title('Topoplot of weights difference of /s/')
subplot(1,3,1),jplot(Q,hs60')
colorbar,caxis(ttestlims)
subplot(1,3,2),jplot(Q,hs150')
colorbar,caxis(ttestlims)
subplot(1,3,3),jplot(Q,hs240')
colorbar,caxis(ttestlims)

figure,title('Topoplot of weights difference of /u/')
subplot(1,3,1),jplot(Q,hu60')
colorbar,caxis(ttestlims)
subplot(1,3,2),jplot(Q,hu150')
colorbar,caxis(ttestlims)
subplot(1,3,3),jplot(Q,hu240')
colorbar,caxis(ttestlims)