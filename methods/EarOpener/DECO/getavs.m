%base={'blocks_in',1:200,'channels',[4 27 31 1 30 32 8 23],'vis','on','time',1:77,'badrem','yes'}
base={'blocks_in',1:200,'channels',[32],'vis','on','time',1:77,'badrem','yes'}

aj=P.JP.default.plot([{'classes',{71}} base]);title('/a/ JP');
anj=P.NJP.default.plot([{'classes',{71}} base]);title('/a/ NJP')

s60j=P.JP.default.plot([{'classes',{31}} base]);title('/s60/ JP')
s60nj=P.NJP.default.plot([{'classes',{31}} base]);title('/s60/ NJP')

s150j=P.JP.default.plot([{'classes',{32}} base]);title('/s150/ JP')
s150nj=P.NJP.default.plot([{'classes',{32}} base]);title('/s150/ NJP')

s240j=P.JP.default.plot([{'classes',{33}} base]);title('/s240/ JP')
s240nj=P.NJP.default.plot([{'classes',{33}} base]);title('/s240/ NJP')

uj=P.JP.default.plot([{'classes',{41}} base]);title('/u/ JP')
unj=P.NJP.default.plot([{'classes',{41}} base]);title('/u/ NJP')
erpax=[0 0.6 -4 5];
as60uj=P.JP.default.plot( [{'classes',{11}} base] );axis(erpax)
as90uj=P.JP.default.plot( [{'classes',{12}} base] );axis(erpax)
as120uj=P.JP.default.plot( [{'classes',{13}} base] );axis(erpax)
as150uj=P.JP.default.plot( [{'classes',{14}} base] );axis(erpax)
as180uj=P.JP.default.plot( [{'classes',{15}} base] );axis(erpax)
as210uj=P.JP.default.plot( [{'classes',{16}} base] );axis(erpax)
as240uj=P.JP.default.plot( [{'classes',{17}} base] );axis(erpax)

as60unj=P.NJP.default.plot( [{'classes',{11}} base] );axis(erpax)
as90unj=P.NJP.default.plot( [{'classes',{12}} base] );axis(erpax)
as120unj=P.NJP.default.plot( [{'classes',{13}} base] );axis(erpax)
as150unj=P.NJP.default.plot( [{'classes',{14}} base] );axis(erpax)
as180unj=P.NJP.default.plot( [{'classes',{15}} base] );axis(erpax)
as210unj=P.NJP.default.plot( [{'classes',{16}} base] );axis(erpax)
as240unj=P.NJP.default.plot( [{'classes',{17}} base] );axis(erpax)

E60J=0;E150J=0;E240J=0;
E60NJ=0;E150NJ=0;E240NJ=0;
for i=1:11

if i<6
    E60J=E60J+E{i}{4};
    E150J=E150J+E{i}{5};
    E240J=E240J+E{i}{6};
else
    E60NJ=E60NJ+E{i}{4};
    E150NJ=E150NJ+E{i}{5};
    E240NJ=E240NJ+E{i}{6};
end
end
E60J=E60J/5;E150J=E150J/5;E240J=E240J/5;
E60NJ=E60NJ/6;E150NJ=E150NJ/6;E240NJ=E240NJ/6;

%%%%JP%%%%%
tdeco=(1:77)/128;
ax=[0 0.6 -3.5 6];
lw=4;
target='k-';
est='k--';
figure,plot(tdeco,aj.avg,'k','Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('ERP response to /a/, JP'),axis(ax);

figure,hold on,plot(tdeco,s60j.avg,'k','Linewidth',lw),plot(tdeco,s150j.avg,'k:','Linewidth',lw),...
    plot(tdeco,s240j.avg,'k-.','Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('ERP response to /s/, JP'),axis(ax);legend({'s60','s150','s240'})

figure,plot(tdeco,uj.avg,'k','Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('ERP response to /u/, JP'),axis(ax);

figure,hold on,plot(tdeco,as60uj.avg,target,'Linewidth',lw),plot(tdeco,E60J,est,'Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('Actual versus estimated ERP for asu(60), JP'),axis(ax);
figure,hold on,plot(tdeco,as150uj.avg,target,'Linewidth',lw),plot(tdeco,E150J,est,'Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('Actual versus estimated ERP for asu(150), JP'),axis(ax);
figure,hold on,plot(tdeco,as240uj.avg,target,'Linewidth',lw),plot(tdeco,E240J,est,'Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('Actual versus estimated ERP for asu(240), JP'),axis(ax);

%%%%NJP%%%%%

figure,plot(tdeco,anj.avg,'k','Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('ERP response to /a/, NJP'),axis(ax);
figure,hold on,plot(tdeco,s60nj.avg,'k','Linewidth',lw),plot(tdeco,s150nj.avg,'k:','Linewidth',lw),...
    plot(tdeco,s240nj.avg,'k-.','Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('ERP response to /s/, NJP'),axis(ax);legend({'s60','s150','s240'})
figure,plot(tdeco,unj.avg,'k','Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('ERP response to /u/, NJP'),axis(ax);

figure,hold on,plot(tdeco,as60unj.avg,target,'Linewidth',lw),plot(tdeco,E60NJ,est,'Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('Actual versus estimated ERP for asu(60), NJP'),axis(ax);
figure,hold on,plot(tdeco,as150unj.avg,target,'Linewidth',lw),plot(tdeco,E150NJ,est,'Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('Actual versus estimated ERP for asu(150), NJP'),axis(ax);
figure,hold on,plot(tdeco,as240unj.avg,target,'Linewidth',lw),plot(tdeco,E240NJ,est,'Linewidth',lw)
xlabel('Time (s)'),ylabel('Amplitude (uV)'),title('Actual versus estimated ERP for asu(240), NJP'),axis(ax);
