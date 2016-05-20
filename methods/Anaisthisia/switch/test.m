timeperiod={{[0 250 2750 3000]} {[3000 3250 5750 6000]}};
%timeperiod={{[0 250 3750 4000]} {[4000 4250 5750 6000]}};
labels={'3sec'};
nomove='NO3';
immove='IM3';
ammove='AM3';
n_con_ex=4;
clear dm Res_in Res_out
%tr=6;
mt2=9;
mn2=1;
m2=4;
t2='all';
%1->louk single trial,2->jason single trial,3->jason+boris with forget on
%the data though,4->j+b with forget on cov matrices
bias_savC=zeros(1,10);bias_sav=zeros(1,10);bias_nrow=zeros(1,10);bias_nrowC=zeros(1,10);cheating_bias=0;fpr_target=0.01;tp=0.01;

method=4;
L=0;
trdim=3;
time_window=1:897;
T=22;
code_louk_2_gen
gzerds2=ztype;
gdsR2o=Res_out;
gdsR2i=Res_in;


code_louk_justdata
outplos=out;
outplos_switch=out_switch;
outplos_nrow=out_nrow;
outplos_nswitch=out_nswitch;

code_louk_justdata_ind
code_louk_justdata_ad
outplos_ad=out;
outplos_switch_ad=out_switch;
outplos_nrow_ad=out_nrow;
outplos_nswitch_ad=out_nswitch;
%outplos_trans=out_trans;

% code_louk_or
% outroc=out2;
% outroc_nrow=out2_nrow;
%outroc_trans=out2_trans;

synchperf_d1
synchperf_d1_nrow

out=outplos;
out_switch=outplos_switch;
out_nrow=outplos_nrow;
out_nswitch=outplos_nswitch;

out=outplos_ad;
out_switch=outplos_switch_ad;
out_nrow=outplos_nrow_ad;
out_nswitch=outplos_nswitch_ad;
% %out_trans=outplos_trans;
% synchperf_cross
% synchperf_cross_nrow
% 
% % out=outroc;
% % out_nrow=outroc_nrow;
% % %out_trans=outroc_trans;
% % synchperf_cross
% % synchperf_cross_nrow
