t=(1:116)/128;
s_delay=diag( ones( 1 , 116 - 8 ) , 8 );
u60_delay=diag( ones( 1 , 116 - 16 ) , 16 );
u150_delay=diag( ones( 1 , 116 - 27 ) , 27 );
u240_delay=diag( ones( 1 , 116 - 39 ) , 39 );
ax=[0 0.9 -6 6];

%%%real

as60u_jp=djp.default.plot('classes',{11},'blocks_in',1:200,'channels','Fz'),title('Real AS60U, JP'),axis(ax)
as150u_jp=djp.default.plot('classes',{14},'blocks_in',1:200,'channels','Fz'),title('Real AS150U, JP'),axis(ax)
as240u_jp=djp.default.plot('classes',{17},'blocks_in',1:200,'channels','Fz'),title('Real AS240U, JP'),axis(ax)

as60u_njp=dnjp.default.plot('classes',{11},'blocks_in',1:200,'channels','Fz'),title('Real AS60U, NJP'),axis(ax)
as150u_njp=dnjp.default.plot('classes',{14},'blocks_in',1:200,'channels','Fz'),title('Real AS150U, NJP'),axis(ax)
as240u_njp=dnjp.default.plot('classes',{17},'blocks_in',1:200,'channels','Fz'),title('Real AS240U, NJP'),axis(ax)

%%a+u
%%%JP

a_jp=djp.default.plot('classes',{21},'blocks_in',1:200,'channels','Fz','vis','off');
u_jp=djp.default.plot('classes',{41},'blocks_in',1:200,'channels','Fz','vis','off');
figure,plot(t,a_jp.avg + u_jp.avg * u60_delay)
figure,plot(t,a_jp.avg + u_jp.avg * u150_delay)
figure,plot(t,a_jp.avg + u_jp.avg * u240_delay)

%%%NJP

a_njp=dnjp.default.plot('classes',{21},'blocks_in',1:200,'channels','Fz','vis','off');
u_njp=dnjp.default.plot('classes',{41},'blocks_in',1:200,'channels','Fz','vis','off');
figure,plot(t,a_njp.avg + u_njp.avg * u60_delay)
figure,plot(t,a_njp.avg + u_njp.avg * u150_delay)
figure,plot(t,a_njp.avg + u_njp.avg * u240_delay)

%%%a+s+u

%%%JP



s60_jp=djp.default.plot('classes',{31},'blocks_in',1:200,'channels','Fz','vis','off');
s150_jp=djp.default.plot('classes',{32},'blocks_in',1:200,'channels','Fz','vis','off');
s240_jp=djp.default.plot('classes',{33},'blocks_in',1:200,'channels','Fz','vis','off');




ApS60pU_jp = a_jp.avg + s60_jp.avg * s_delay + u_jp.avg * u60_delay;
ApS150pU_jp = a_jp.avg + s150_jp.avg * s_delay + u_jp.avg * u150_delay;
ApS240pU_jp = a_jp.avg + s240_jp.avg * s_delay + u_jp.avg * u240_delay;

figure,plot(t,ApS60pU_jp),title('combined A+S60+U,JP'),axis(ax)
figure,plot(t,ApS150pU_jp),title('combined A+S150+U,JP'),axis(ax)
figure,plot(t,ApS240pU_jp),title('combined A+S240+U,JP'),axis(ax)
figure,hold on,plot(t,a_jp.avg,'r'),plot(t,s150_jp.avg * s_delay,'g'),plot(t,u_jp.avg * u_delay,'b'),title('individual')


%%%NJP


s60_njp=dnjp.default.plot('classes',{31},'blocks_in',1:200,'channels','Fz','vis','off');
s150_njp=dnjp.default.plot('classes',{32},'blocks_in',1:200,'channels','Fz','vis','off');
s240_njp=dnjp.default.plot('classes',{33},'blocks_in',1:200,'channels','Fz','vis','off');

u_njp=dnjp.default.plot('classes',{41},'blocks_in',1:200,'channels','Fz','vis','off');


ApS60pU_njp = a_njp.avg + s60_njp.avg * s_delay + u_njp.avg * u60_delay;
ApS150pU_njp = a_njp.avg + s150_njp.avg * s_delay + u_njp.avg * u150_delay;
ApS240pU_njp = a_njp.avg + s240_njp.avg * s_delay + u_njp.avg * u240_delay;


figure,plot(t,ApS60pU_njp),title('combined A+S60+U,NJP'),axis(ax)
figure,plot(t,ApS150pU_njp),title('combined A+S150+U,NJP'),axis(ax)
figure,plot(t,ApS240pU_njp),title('combined A+S240+U,NJP'),axis(ax)
%figure,hold on,plot(t,a_njp.avg,'r'),plot(t,s150_njp.avg * s_delay,'g'),plot(t,u_njp.avg * u_delay,'b'),title('individual')

%%%as+u

%%%JP


as60_jp  = djp.default.plot('classes',{51},'blocks_in',1:200,'channels','Fz','vis','off');
as150_jp = djp.default.plot('classes',{52},'blocks_in',1:200,'channels','Fz','vis','off');
as240_jp = djp.default.plot('classes',{53},'blocks_in',1:200,'channels','Fz','vis','off');

u_jp=djp.default.plot('classes',{41},'blocks_in',1:200,'channels','Fz','vis','off');


AS60pU_jp  = as60_jp.avg   + u_jp.avg * u60_delay;
AS150pU_jp = as150_jp.avg  + u_jp.avg * u150_delay;
AS240pU_jp = as240_jp.avg  + u_jp.avg * u240_delay;

figure,plot(t,AS60pU_jp) ,title('combined AS60+U,JP') ,axis(ax)
figure,plot(t,AS150pU_jp),title('combined AS150+U,JP'),axis(ax)
figure,plot(t,AS240pU_jp),title('combined AS240+U,JP'),axis(ax)
%figure,hold on,plot(t,a_jp.avg,'r'),plot(t,s150_jp.avg * s_delay,'g'),plot(t,u_jp.avg * u_delay,'b'),title('individual')


%%%NJP


as60_njp =dnjp.default.plot('classes',{51},'blocks_in',1:200,'channels','Fz','vis','off');
as150_njp=dnjp.default.plot('classes',{52},'blocks_in',1:200,'channels','Fz','vis','off');
as240_njp=dnjp.default.plot('classes',{53},'blocks_in',1:200,'channels','Fz','vis','off');



AS60pU_njp  = as60_njp.avg  + u_njp.avg * u60_delay;
AS150pU_njp = as150_njp.avg + u_njp.avg * u150_delay;
AS240pU_njp = as240_njp.avg + u_njp.avg * u240_delay;


figure,plot(t,AS60pU_njp),title('combined  AS60+U,NJP'),axis(ax)
figure,plot(t,AS150pU_njp),title('combined AS150+U,NJP'),axis(ax)
figure,plot(t,AS240pU_njp),title('combined AS240+U,NJP'),axis(ax)
%figure,hold on,plot(t,a_njp.avg,'r'),plot(t,s150_njp.avg * s_delay,'g'),plot(t,u_njp.avg * u_delay,'b'),title('individual')


%%%a+su


%%%JP


su60_jp  = djp.default.plot('classes',{61},'blocks_in',1:200,'channels','Fz','vis','off');
su150_jp = djp.default.plot('classes',{62},'blocks_in',1:200,'channels','Fz','vis','off');
su240_jp = djp.default.plot('classes',{63},'blocks_in',1:200,'channels','Fz','vis','off');



ApS60U_jp  = a_jp.avg + su60_jp.avg * s_delay;
ApS150U_jp  = a_jp.avg + su150_jp.avg * s_delay;
ApS240U_jp  = a_jp.avg + su240_jp.avg * s_delay;


figure,plot(t,ApS60U_jp) ,title('combined A+S60U,JP') ,axis(ax)
figure,plot(t,ApS150U_jp),title('combined A+S150U,JP'),axis(ax)
figure,plot(t,ApS240U_jp),title('combined A+S240U,JP'),axis(ax)
%figure,hold on,plot(t,a_jp.avg,'r'),plot(t,s150_jp.avg * s_delay,'g'),plot(t,u_jp.avg * u_delay,'b'),title('individual')


%%%NJP


su60_njp  = dnjp.default.plot('classes',{61},'blocks_in',1:200,'channels','Fz','vis','off');
su150_njp = dnjp.default.plot('classes',{62},'blocks_in',1:200,'channels','Fz','vis','off');
su240_njp = dnjp.default.plot('classes',{63},'blocks_in',1:200,'channels','Fz','vis','off');



ApS60U_njp  = a_njp.avg  + su60_njp.avg * s_delay;
ApS150U_njp  = a_njp.avg + su150_njp.avg * s_delay;
ApS240U_njp  = a_njp.avg + su240_njp.avg * s_delay;


figure,plot(t,ApS60U_njp) ,title('combined A+S60U,NJP') ,axis(ax)
figure,plot(t,ApS150U_njp),title('combined A+S150U,NJP'),axis(ax)
figure,plot(t,ApS240U_njp),title('combined A+S240U,NJP'),axis(ax)
%figure,hold on,plot(t,a_njp.avg,'r'),plot(t,s150_njp.avg * s_delay,'g'),plot(t,u_njp.avg * u_delay,'b'),title('individual')

