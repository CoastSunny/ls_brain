rest={2};
im={5};
am={3};
t=(-50:249)/10;
ax=[-5 25 -1 1];
ch='a';
grcfg.keepindividual='yes';
%channel={['nirs_o2hb' ch]};
channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',7,'vis','off');
scaleOR=mean(mean([t1.norm_avg t2.norm_avg t3.norm_avg t4.norm_avg t5.norm_avg t6.norm_avg t7.norm_avg],2));
OR=ft_timelockgrandaverage([],t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
iOR=ft_timelockgrandaverage(grcfg,t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
channel={['nirs_hhb' ch]};
channel={'nirs_hhba' 'nirs_hhbb'};
t1=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',7,'vis','off');
scaleDR=mean(mean([t1.norm_avg t2.norm_avg t3.norm_avg t4.norm_avg t5.norm_avg t6.norm_avg t7.norm_avg],2));
HR=ft_timelockgrandaverage([],t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
iHR=ft_timelockgrandaverage(grcfg,t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
%figure,hold on,shadedErrorBar(t,C1.avg,C1.var.^(1/2),'r',1),shadedErrorBar(t,C2.avg,C2.var.^(1/2),'g',1)
figure,hold on,shadedErrorBar(t,scaleOR*mean(OR.avg),scaleOR*mean(OR.var).^(1/2),'r',1),shadedErrorBar(t,scaleDR*mean(HR.avg),scaleDR*mean(HR.var).^(1/2),'g',1)
axis(ax);

channel={['nirs_o2hb' ch]};
channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',7,'vis','off');
scaleOI=mean(mean([t1.norm_avg t2.norm_avg t3.norm_avg t4.norm_avg t5.norm_avg t6.norm_avg t7.norm_avg],2));
OI=ft_timelockgrandaverage([],t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
iOI=ft_timelockgrandaverage(grcfg,t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
channel={['nirs_hhb' ch]};
channel={'nirs_hhba' 'nirs_hhbb'};
t1=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',7,'vis','off');
scaleDI=mean(mean([t1.norm_avg t2.norm_avg t3.norm_avg t4.norm_avg t5.norm_avg t6.norm_avg t7.norm_avg],2));
HI=ft_timelockgrandaverage([],t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
iHI=ft_timelockgrandaverage(grcfg,t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
%figure,hold on,shadedErrorBar(t,C1.avg,C1.var.^(1/2),'r',1),shadedErrorBar(t,C2.avg,C2.var.^(1/2),'g',1)
figure,hold on,shadedErrorBar(t,scaleOI*mean(OI.avg),scaleOI*mean(OI.var).^(1/2),'r',1),shadedErrorBar(t,scaleDI*mean(HI.avg),scaleDI*mean(HI.var).^(1/2),'g',1)
axis(ax);

channel={['nirs_o2hb' ch]};
channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',7,'vis','off');
scaleOA=mean(mean([t1.norm_avg t2.norm_avg t3.norm_avg t4.norm_avg t5.norm_avg t6.norm_avg t7.norm_avg],2));
OA=ft_timelockgrandaverage([],t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
iOA=ft_timelockgrandaverage(grcfg,t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
channel={['nirs_hhb' ch]};
channel={'nirs_hhba' 'nirs_hhbb'};
t1=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',7,'vis','off');
scaleDA=mean(mean([t1.norm_avg t2.norm_avg t3.norm_avg t4.norm_avg t5.norm_avg t6.norm_avg t7.norm_avg],2));
HA=ft_timelockgrandaverage([],t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
iHA=ft_timelockgrandaverage(grcfg,t1.full,t2.full,t3.full,t4.full,t5.full,t6.full,t7.full);
%figure,hold on,shadedErrorBar(t,C1.avg,C1.var.^(1/2),'r',1),shadedErrorBar(t,C2.avg,C2.var.^(1/2),'g',1)
figure,hold on,shadedErrorBar(t,scaleOA*mean(OA.avg),scaleOA*mean(OA.var).^(1/2),'r',1),shadedErrorBar(t,scaleDA*mean(HA.avg),scaleDA*mean(HA.var).^(1/2),'g',1)
axis(ax);


%%%%%STATS%%%%%
trtime=(1:200);
mOA=mean(OA.avg(:,trtime));
mOI=mean(OI.avg(:,trtime));
mOR=mean(OR.avg(:,trtime));
mHA=mean(HA.avg(:,trtime));
mHI=mean(HI.avg(:,trtime));
mHR=mean(HR.avg(:,trtime));

for i=1:numel(mOA)

    [hOA(i) pOA(i)]=ttest(squeeze(mean(iOA.individual(:,:,i),2)) , squeeze(mean(iOR.individual(:,:,i),2)) );
    [hOI(i) pOI(i)]=ttest(squeeze(mean(iOI.individual(:,:,i),2)) , squeeze(mean(iOR.individual(:,:,i),2)) );
    
    [hHA(i) pHA(i)]=ttest(squeeze(mean(iHA.individual(:,:,i),2)) , squeeze(mean(iHR.individual(:,:,i),2)) );
    [hHI(i) pHI(i)]=ttest(squeeze(mean(iHI.individual(:,:,i),2)) , squeeze(mean(iHR.individual(:,:,i),2)) );

end
% figure,hold on,shadedErrorBar(t,scaleOA*mean(OA.avg),scaleOA*mean(OA.var).^(1/2),'k',1),shadedErrorBar(t,scaleOR*mean(OR.avg),scaleOR*mean(OR.var).^(1/2),'k-.',1)
% figure,hold on,shadedErrorBar(t,scaleDA*mean(HA.avg),scaleDA*mean(HA.var).^(1/2),'k',1),shadedErrorBar(t,scaleDR*mean(HR.avg),scaleDR*mean(HR.var).^(1/2),'k-.',1)
% figure,hold on,shadedErrorBar(t,scaleOI*mean(OI.avg),scaleOI*mean(OI.var).^(1/2),'k',1),shadedErrorBar(t,scaleOR*mean(OR.avg),scaleOR*mean(OR.var).^(1/2),'k-.',1)
% figure,hold on,shadedErrorBar(t,scaleDI*mean(HI.avg),scaleDI*mean(HI.var).^(1/2),'k',1),shadedErrorBar(t,scaleDR*mean(HR.avg),scaleDR*mean(HR.var).^(1/2),'k-.',1)

Td=[pOA;pOI;pHA;pHI];


trax=(-49:150)/10;
ax2=[-5 15 -1 1];
figure,subplot(2,1,1),hold on,plot(trax,mean(OA.avg(:,trtime)*scaleOA),'k'),plot(trax,mean(OR.avg(:,trtime))*scaleOR,'k-.'),axis(ax2)
subplot(2,1,2),imagesc(pOA),colormap(cmap),axis off
figure,subplot(2,1,1),hold on,plot(trax,mean(HA.avg(:,trtime)*scaleDA),'k'),plot(trax,mean(HR.avg(:,trtime))*scaleDR,'k-.'),axis(ax2)
subplot(2,1,2),imagesc(pHA),colormap(cmap),axis off

figure,subplot(2,1,1),hold on,plot(trax,mean(OI.avg(:,trtime)*scaleOI),'k'),plot(trax,mean(OR.avg(:,trtime))*scaleOR,'k-.'),axis(ax2)
subplot(2,1,2),imagesc(pOI),colormap(cmap),axis off
figure,subplot(2,1,1),hold on,plot(trax,mean(HI.avg(:,trtime)*scaleDI),'k'),plot(trax,mean(HR.avg(:,trtime))*scaleDR,'k-.'),axis(ax2)
subplot(2,1,2),imagesc(pHI),colormap(cmap),axis off