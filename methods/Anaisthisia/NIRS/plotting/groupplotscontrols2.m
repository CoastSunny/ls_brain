rest={2};
im={5};
am={3};
t=(-50:249)/10;
tt=1:300;
ax=[-5 25 -.15 .15];
remove=[];
tta=(1:250);
grcfg.keepindividual='yes';
Oshaded_properties={'Color',[0 0 0],'LineWidth',4};
Dshaded_properties={'Color',[0.3 0.3 0.3],'LineWidth',4};
trans=1;

%channel={['nirs_o2hb' ch]};
%% ACTUAL MOVEMENT %%

channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',1,'vis','off');
t2=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',2,'vis','off');
t3=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',3,'vis','off');
t4=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',4,'vis','off');
t5=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',5,'vis','off');
t6=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',6,'vis','off');
t7=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',7,'vis','off');
t8=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',8,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg;t8.avg]';
T(:,remove)=[];
scaleOA=std(T(tta,:));
scaleOA=ones(1,8);
scaleOA=[norm(t1.avg) norm(t2.avg) norm(t3.avg) norm(t4.avg)...
    norm(t5.avg) norm(t6.avg) norm(t7.avg) norm(t8.avg)];
%scaleOA=[1 1 1 1 1 1 1];
OTA=repop(T,'/',scaleOA);

channel={'nirs_hhba' 'nirs_hhbb'};
t1=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',1,'vis','off');
t2=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',2,'vis','off');
t3=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',3,'vis','off');
t4=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',4,'vis','off');
t5=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',5,'vis','off');
t6=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',6,'vis','off');
t7=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',7,'vis','off');
t8=controls.all.default.plot('classes',am,'channels',channel,'blocks_in',8,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg;t8.avg]';
T(:,remove)=[];
scaleHA=std(T(tta,:));
scaleHA=ones(1,8);
scaleHA=[norm(t1.avg) norm(t2.avg) norm(t3.avg) norm(t4.avg)...
    norm(t5.avg) norm(t6.avg) norm(t7.avg) norm(t8.avg)];
%scaleHA=[1 1 1 1 1 1 1];
HTA=repop(T,'/',scaleHA);

figure,hold on,shadedErrorBar(t,mean(OTA(tt,:),2),[ std(OTA(tt,:),0,2) zeros(numel(tt),1)],Oshaded_properties,trans),...
    shadedErrorBar(t,mean(HTA(tt,:),2),[zeros(numel(tt),1) std(HTA(tt,:),0,2)],Dshaded_properties,trans)
axis(ax);
xlabel('time in seconds')
ylabel('normalised concentration change')
title('Group averaged HbO and HbR for controls and actual movement');
line([-5 25],[0 0],'Color','k','LineStyle',':','LineWidth',3)
%% IMAGINED MOVEMENT %%

channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',1,'vis','off');
t2=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',2,'vis','off');
t3=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',3,'vis','off');
t4=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',4,'vis','off');
t5=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',5,'vis','off');
t6=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',6,'vis','off');
t7=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',7,'vis','off');
t8=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',8,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg;t8.avg]';
T(:,remove)=[];
OTI=repop(T,'/',scaleOA);


channel={'nirs_hhba' 'nirs_hhbb'};
t1=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',1,'vis','off');
t2=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',2,'vis','off');
t3=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',3,'vis','off');
t4=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',4,'vis','off');
t5=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',5,'vis','off');
t6=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',6,'vis','off');
t7=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',7,'vis','off');
t8=controls.all.default.plot('classes',im,'channels',channel,'blocks_in',8,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg;t8.avg]';
T(:,remove)=[];
HTI=repop(T,'/',scaleHA);

figure,hold on,shadedErrorBar(t,mean(OTI(tt,:),2),[ std(OTI(tt,:),0,2) zeros(numel(tt),1)],Oshaded_properties,trans),...
    shadedErrorBar(t,mean(HTI(tt,:),2),[zeros(numel(tt),1) std(HTI(tt,:),0,2)],Dshaded_properties,trans)
axis(ax);
xlabel('time in seconds')
ylabel('normalised concentration change')
title('Group averaged HbO and HbR for controls and imagined movement');
line([-5 25],[0 0],'Color','k','LineStyle',':','LineWidth',3)
%% NO MOVEMENT %%
channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',1,'vis','off');
t2=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',2,'vis','off');
t3=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',3,'vis','off');
t4=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',4,'vis','off');
t5=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',5,'vis','off');
t6=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',6,'vis','off');
t7=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',7,'vis','off');
t8=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',8,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg;t8.avg]';
T(:,remove)=[];
OTR=repop(T,'/',scaleOA);

channel={'nirs_hhba' 'nirs_hhbb'};
t1=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',1,'vis','off');
t2=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',2,'vis','off');
t3=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',3,'vis','off');
t4=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',4,'vis','off');
t5=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',5,'vis','off');
t6=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',6,'vis','off');
t7=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',7,'vis','off');
t8=controls.all.default.plot('classes',rest,'channels',channel,'blocks_in',8,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg;t8.avg]';
T(:,remove)=[];
HTR=repop(T,'/',scaleHA);

figure,hold on,shadedErrorBar(t,mean(OTR(tt,:),2),[ zeros(numel(tt),1) std(OTR(tt,:),0,2) ],Oshaded_properties,trans),...
    shadedErrorBar(t,mean(HTR(tt,:),2),[ std(HTR(tt,:),0,2) zeros(numel(tt),1)],Dshaded_properties,trans)
axis(ax);
xlabel('time in seconds')
ylabel('normalised concentration change')
title('Group averaged HbO and HbR for controls and no movement');
line([-5 25],[0 0],'Color','k','LineStyle',':','LineWidth',3)




