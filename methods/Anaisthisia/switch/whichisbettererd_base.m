
% trblocks=[1 2 3];
% exblocks=[];
% 
% code_louk_2jf
% Ro=Res_out;
% Ri=Res_in;

timeperiod=[0 1000];
label_win={'seq1'};

trblocks=[1];
exblocks=[2 3];
n_con_ex=60;
clear ap Res_in Res_out Y decision_values
code_louk_asynch
A1csERD=ap;
A1csERD2=ap2;
A1Ddv=decision_values;
A1DY=Y;
A1DoutfIdxs=outfIdxs;
A1DfoldIdxs=foldIdxs;
ADR1o=Res_out;
ADR1i=Res_in;

trblocks=[2];
exblocks=[1 3];
n_con_ex=60;
clear ap Res_in Res_out Y decision_values
code_louk_asynch
A2csERD=ap;
A2csERD2=ap2;
A2Ddv=decision_values;
A2DY=Y;
A2DoutfIdxs=outfIdxs;
A2DfoldIdxs=foldIdxs;
ADR2o=Res_out;
ADR2i=Res_in;

trblocks=[3];
exblocks=[1 2];
n_con_ex=60;
clear ap Res_in Res_out Y decision_values
code_louk_asynch
A3csERD=ap;
A3csERD2=ap2;
A3Ddv=decision_values;
A3DY=Y;
A3DoutfIdxs=outfIdxs;
A3DfoldIdxs=foldIdxs;
ADR3o=Res_out;
ADR3i=Res_in;


