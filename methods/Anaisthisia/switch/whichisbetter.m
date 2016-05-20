
% trblocks=[1 2 3];
% exblocks=[];
% 
% code_louk_2jf
% Ro=Res_out;
% Ri=Res_in;
timeperiod={{[0 100 900 1000]} {[1000 1200 2800 3000]}};
trblocks=[1];
exblocks=[2 3];
n_con_ex=9;
code_louk_2
cs1=cs;
clear cs
R1o=Res_out;
R1i=Res_in;
dv1=decision_values;
Y1=Y;

timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
trblocks=[2];
exblocks=[1 3];
n_con_ex=6;
code_louk_2
cs2=cs;
clear cs
R2o=Res_out;
R2i=Res_in;
dv2=decision_values;
Y2=Y;

timeperiod={{[0 500 8500 9000]} {[9000 9250 11750 12000]}};
trblocks=[3];
exblocks=[2 1];
n_con_ex=3;
code_louk_2
cs3=cs;
clear cs
R3o=Res_out;
R3i=Res_in;
dv3=decision_values;
Y3=Y;

%trblocks=[4 5];
%exblocks=[2 1 3];
% 
% code_louk_2jf
% Ra=Res_out;
% Ri=Res_in;


