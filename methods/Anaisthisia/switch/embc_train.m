timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};
labels={'3sec'};
nomove='NO3';
immove='IM3';
ammove='AM3';
n_con_ex=4;
clear dm Res_in Res_out

mt2=12;
mn2=1;
t2='all';

method=4;
L=0;
trdim=3;
time_window=1:897;
T=22;
code_louk_2_gen
gzerds2=ztype;
gdsR2o=Res_out;
gdsR2i=Res_in;


% code_louk_justdata
% outplos=out;
% outplos_nrow=out_nrow;
% %outplos_trans=out_trans;
% 
% 
% % synchperf_d1
% % synchperf_d1_nrow
% 
% synchperf_cross
% synchperf_cross_nrow
