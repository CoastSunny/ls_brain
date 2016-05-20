
timeperiod=[0 1000];
label_win={'1s_windows_shifted'};
method=4;
L=20;
trdim=3;
T=22;
time_window=1:128;

trblocks=[1];
exblocks=[2 3];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out 
code_louk_asynch_gen
%gawd1=dm;
%gawd1sav=dmsav;
gawdR1o=Res_out;
gawdR1i=Res_in;
FpA1=FpA;
FnA1=FnA;
%gawd1perf=perfcomp(gawd1,'out','dec',1);
%gawd1cal=calperf(gawd1,'out','dec');

trblocks=[2];
exblocks=[1 3];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out 
code_louk_asynch_gen
% gawd2sav=dmsav;
% gawd2nrow=dmnrow;
gawdR2o=Res_out;
gawdR2i=Res_in;
FpA2=FpA;
FnA2=FnA;
%gawd2perf=perfcomp(gawd2,'out','dec',1);
%gawd2cal=calperf(gawd2,'out','dec');

trblocks=[3];
exblocks=[1 2];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out
code_louk_asynch_gen
%gawd3=dm;
%gawd3sav=dmsav;
gawdR3o=Res_out;
gawdR3i=Res_in;
FpA3=FpA;
FnA3=FnA;
%gawd3perf=perfcomp(gawd3,'out','dec',1);
%gawd3cal=calperf(gawd3,'out','dec');

% trblocks=[1 2 3];
% exblocks=[];
% outblocks=[4 5];
% n_con_ex=60;
% clear dm Res_in Res_out 
% code_louk_asynch_gen
% gawd=dm;
% gawdRo=Res_out;
% gawdRi=Res_in;
% gawdperf=calperf(gawd,'out','dec');



