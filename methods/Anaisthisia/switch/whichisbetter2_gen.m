
timeperiod={{[0 100 900 1000]} {[1000 1200 2800 4000]}};
labels={'1sec'};
nomove='NO1';
immove='IM1';
ammove='AM1';
n_con_ex=6;
clear dm Res_in Res_out
code_louk_2_gen
gzerds1=ztype;
gdsR1o=Res_out;
gdsR1i=Res_in;

timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};
labels={'3sec'};
nomove='NO3';
immove='IM3';
ammove='AM3';
n_con_ex=4;
clear dm Res_in Res_out
code_louk_2_gen
gzerds2=ztype;
gdsR2o=Res_out;
gdsR2i=Res_in;

timeperiod={{[0 500 8500 9000]} {[9000 9250 11750 12000]}};
labels={'9sec'};
nomove='NO9';
immove='IM9';
ammove='AM9';
n_con_ex=2;
clear dm Res_in Res_out
code_louk_2_gen
gzerds3=ztype;
gdsR3o=Res_out;
gdsR3i=Res_in;



