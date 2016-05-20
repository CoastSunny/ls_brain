rest={2};
im={5};
am={3};
t=(-50:249)/10;
ax=[-5 25 -4 4];
remove=[];
tta=(1:200);
grcfg.keepindividual='yes';
%channel={['nirs_o2hb' ch]};
%% ACTUAL MOVEMENT %%

channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',7,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg]';
T(:,remove)=[];
scaleOA=std(T(tta,:));
%scaleOA=[1 1 1 1 1 1 1];
OTA=repop(T,'/',scaleOA);

channel={'nirs_hhba' 'nirs_hhbb'};
t1=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',am,'channels',channel,'blocks_in',7,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg]';
T(:,remove)=[];
scaleHA=std(T(tta,:));
%scaleHA=[1 1 1 1 1 1 1];
HTA=repop(T,'/',scaleHA);

figure,hold on,shadedErrorBar(t,mean(OTA,2),std(OTA,0,2),'r',1),...
    shadedErrorBar(t,mean(HTA,2),std(HTA,0,2),'g',1)
axis(ax);
%% IMAGINED MOVEMENT %%

channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',7,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg]';
T(:,remove)=[];
OTI=repop(T,'/',scaleOA);


channel={'nirs_hhba' 'nirs_hhbb'};
t1=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',im,'channels',channel,'blocks_in',7,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg]';
T(:,remove)=[];
HTI=repop(T,'/',scaleHA);

figure,hold on,shadedErrorBar(t,mean(OTI,2),std(OTI,0,2),'r',1),...
    shadedErrorBar(t,mean(HTI,2),std(HTI,0,2),'g',1)
axis(ax);

%% NO MOVEMENT %%
channel={'nirs_o2hba' 'nirs_o2hbb'};
t1=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',7,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg]';
T(:,remove)=[];
OTR=repop(T,'/',scaleOA);

channel={'nirs_hhba' 'nirs_hhbb'};
t1=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',1,'vis','off');
t2=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',2,'vis','off');
t3=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',3,'vis','off');
t4=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',4,'vis','off');
t5=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',5,'vis','off');
t6=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',6,'vis','off');
t7=patients.all.default.plot('classes',rest,'channels',channel,'blocks_in',7,'vis','off');

T=[t1.avg;t2.avg;t3.avg;t4.avg;t5.avg;t6.avg;t7.avg]';
T(:,remove)=[];
HTR=repop(T,'/',scaleHA);

figure,hold on,shadedErrorBar(t,mean(OTR,2),std(OTR,0,2),'r',1),...
    shadedErrorBar(t,mean(HTR,2),std(HTR,0,2),'g',1)
axis(ax);

%%

%close all
figure,hold on,plot(mean(OTA(1:200,:),2),'r'),plot(mean(OTI(1:200,:),2),'g'),plot(mean(OTR(1:200,:),2),'b')
figure,hold on,plot(mean(HTA(1:200,:),2),'r'),plot(mean(HTI(1:200,:),2),'g'),plot(mean(HTR(1:200,:),2),'b')

figure,plot(OTA)
figure,plot(OTI)
figure,plot(OTR)



