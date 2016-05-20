

timeperiod=[0 1000];
label_win={'ers_window'};


trblocks=[1];
exblocks=[2 3];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out 
code_louk_asynch
% aws1=dm;
awsR1o=Res_out;
awsR1i=Res_in;
% aws1perf=calperf(aws1,'out','dec');
zers1=ztype;

trblocks=[2];
exblocks=[1 3];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out 
code_louk_asynch
% aws2=dm;
awsR2o=Res_out;
awsR2i=Res_in;
% aws2perf=calperf(aws2,'out','dec');
zers2=ztype;

trblocks=[3];
exblocks=[1 2];
outblocks=[4 5];
n_con_ex=60;
clear dm Res_in Res_out
code_louk_asynch
% aws3=dm;
awsR3o=Res_out;
awsR3i=Res_in;
% aws3perf=calperf(aws3,'out','dec');
zers3=ztype;

% trblocks=[1 2 3];
% exblocks=[];
% outblocks=[4 5];
% n_con_ex=60;
% clear dm Res_in Res_out 
% code_louk_asynch
% % aws=dm;
% awsRo=Res_out;
% awsRi=Res_in;
% % awsperf=calperf(aws,'out','dec');
% 


